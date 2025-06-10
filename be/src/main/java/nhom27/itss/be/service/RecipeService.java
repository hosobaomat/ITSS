package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.MissingIngredientRequest;
import nhom27.itss.be.dto.request.RecipeCreationRequest;
import nhom27.itss.be.dto.request.RecipeEditRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.entity.embeddedID.RecipeIngredientID;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class RecipeService {


    UsersRepository usersRepository;
    RecipesRepository recipesRepository;
    UnitsRepository unitsRepository;
    FoodCatalogRepository foodcatalogsRepository;
    FamilyGroupsRepository familyGroupsRepository;
    FoodItemsRepository foodItemsRepository;
    FoodCatalogRepository foodCatalogRepository;
    RecipeIngredientsRepository recipeIngredientsRepository;


    public RecipeResponse createRecipe(RecipeCreationRequest request) {
        Recipe recipe = new Recipe();

        recipe.setRecipeName(request.getRecipeName());
        recipe.setDescription(request.getDescription());
        recipe.setInstructions(request.getInstructions());
        recipe.setCookTime(request.getCookTime());
        recipe.setPrepTime(request.getPrepTime());
        recipe.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        User createdBy = usersRepository.findById(request.getCreatedBy()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));

        recipe.setCreatedBy(createdBy);

        recipesRepository.save(recipe);

        return RecipeToResponse(recipe) ;
    }


    public RecipeResponse addIngredientToRecipe(RecipeEditRequest request){
        Recipe recipe = recipesRepository.findById(request.getRecipeId())
                .orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS)); // sửa lại lỗi nếu cần

        // Lấy danh sách nguyên liệu hiện có của công thức
        Set<RecipeIngredient> existingIngredients = recipe.getRecipeingredients();

        // Lấy danh sách các foodCatalogId đã có
        Set<Integer> existingFoodCatalogIds = existingIngredients.stream()
                .map(ri -> ri.getFoodCatalog().getFoodCatalogId())
                .collect(Collectors.toSet());

        // Lọc và tạo mới các nguyên liệu chưa tồn tại
        List<RecipeIngredient> newIngredients = request.getIngredients().stream()
                .filter(item -> !existingFoodCatalogIds.contains(item.getFoodCatalogId()))
                .map(item -> RecipeIngredient.builder()
                        .id(new RecipeIngredientID(request.getRecipeId(), item.getFoodCatalogId()))
                        .quantity(item.getQuantity())
                        .unit(unitsRepository.findById(item.getUnitId())
                                .orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS)))
                        .foodCatalog(foodcatalogsRepository.findById(item.getFoodCatalogId())
                                .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS)))
                        .recipe(recipe)
                        .build())
                .toList();

        // Thêm các nguyên liệu mới vào danh sách hiện tại
        existingIngredients.addAll(newIngredients);

        // Lưu lại nếu cần (nếu JPA không tự cascade persist)
        recipe.setRecipeingredients(existingIngredients);
        recipesRepository.save(recipe);

        return RecipeToResponse(recipe);

    }


    public void deleteIngredientFromRecipe(Integer recipeId){
        recipesRepository.deleteById(recipeId);
    }


    public List<RecipeResponse> getAllRecipes(){
        List<Recipe> recipes = recipesRepository.findAll();

        return  recipes.stream().map(this::RecipeToResponse).toList();
    }

    public RecipeResponse getRecipesById(Integer recipeId){
        Recipe recipes = recipesRepository.findById(recipeId).orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS));
        return  RecipeToResponse(recipes) ;
    }


    public List<RecipeResponse> getRecipesByUserId(Integer userId){
        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
        List<Recipe> recipes = recipesRepository.findByCreatedBy(user);
        return  recipes.stream().map(this::RecipeToResponse).toList() ;
    }


    public List<RecipeResponse> recommendRecipes(Integer groupId){
        FamilyGroup group = familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED));
        List<FoodItem> itemsInFridge = foodItemsRepository.findValidFoodItemsByGroupId(groupId);

        List<Recipe> recipes = recipesRepository.findAll();
        List<Recipe> recipeMatches = new ArrayList<>();

        for (Recipe recipe : recipes) {
            List<RecipeIngredient> ingredients = recipeIngredientsRepository.findByRecipe(recipe);
            int matchedIngredients = 0;
            List<RecipeIngredient> available = new ArrayList<>();
            List<RecipeIngredient> missing = new ArrayList<>();

            for (RecipeIngredient ingredient : ingredients) {
                Optional<FoodItem> matchingItem = itemsInFridge.stream()
                        .filter(item -> item.getFoodCatalog().getFoodCatalogId().equals(ingredient.getFoodCatalog().getFoodCatalogId())
                                && item.getUnit().getId().equals(ingredient.getUnit().getId())
                                && item.getQuantity() >= ingredient.getQuantity())
                        .findFirst();
                FoodCatalog foodCatalog = foodCatalogRepository.findById(ingredient.getFoodCatalog().getFoodCatalogId())
                        .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS));
                Unit unit = unitsRepository.findById(ingredient.getUnit().getId())
                        .orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
                RecipeIngredient ingredientResponse = RecipeIngredient.builder()
                        .id(ingredient.getId())
                        .foodCatalog(foodCatalog)
                        .quantity(ingredient.getQuantity())
                        .unit(ingredient.getUnit())
                        .build();
                if (matchingItem.isPresent()) {
                    matchedIngredients++;
                    available.add(ingredientResponse);
                } else {
                    missing.add(ingredientResponse);
                }
            }
            double matchPercentage = (double) matchedIngredients / ingredients.size();
            if (matchPercentage >=  0.7) {
                recipeMatches.add(recipe);
            }
        }

        return recipeMatches.stream().map(
                this::RecipeToResponse
                ).toList();


    }


    public List<RecipeIngredientResponse> getMissingIngredient(Integer groupId,Integer recipeId){
           Recipe recipe = recipesRepository.findById(recipeId).orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS));

           List<FoodItem> itemsInFridge = foodItemsRepository.findValidFoodItemsByGroupId(groupId);
           List<RecipeIngredient> ingredients = recipeIngredientsRepository.findByRecipe(recipe);

           List<RecipeIngredient> missingIngredients = new ArrayList<>();

           for (RecipeIngredient ingredient : ingredients) {
               Optional<FoodItem> matchingItem = itemsInFridge.stream()
                       .filter(item -> item.getFoodCatalog().getFoodCatalogId().equals(ingredient.getFoodCatalog().getFoodCatalogId())
                               && item.getUnit().getId().equals(ingredient.getUnit().getId())
                               && item.getQuantity() >= ingredient.getQuantity())
                       .findFirst();

               if (matchingItem.isEmpty()) {
                   // Nếu không tìm thấy nguyên liệu phù hợp trong tủ lạnh, thêm vào danh sách thiếu
                   missingIngredients.add(ingredient);
               }

           }


           return missingIngredients.stream().map(
                   this::RecipeIngredientToResponse
           ).toList();

    }

//    Ham Mapping
    private RecipeResponse RecipeToResponse(Recipe recipe) {
        RecipeResponse recipeResponse = new RecipeResponse();
        recipeResponse.setRecipeName(recipe.getRecipeName());
        recipeResponse.setId(recipe.getRecipeId());
        recipeResponse.setDescription(recipe.getDescription()) ;
        recipeResponse.setInstructions(recipe.getInstructions()) ;
        recipeResponse.setCookTime(recipe.getCookTime()) ;
        recipeResponse.setPrepTime(recipe.getPrepTime()) ;
        recipeResponse.setCreatedBy(recipe.getCreatedBy().getEmail());
        recipeResponse.setIngredients(recipe.getRecipeingredients().stream().map(
                this::RecipeIngredientToResponse
        ).toList());

        return recipeResponse;
    }

    private RecipeIngredientResponse RecipeIngredientToResponse(RecipeIngredient recipeIngredient) {
        RecipeIngredientResponse recipeIngredientResponse = new RecipeIngredientResponse();
        recipeIngredientResponse.setRecipeid(recipeIngredient.getRecipe().getRecipeId());
        recipeIngredientResponse.setFoodId(recipeIngredient.getFoodCatalog().getFoodCatalogId());
        recipeIngredientResponse.setQuantity(recipeIngredient.getQuantity());
        recipeIngredientResponse.setUnitId(recipeIngredient.getUnit().getId());
        recipeIngredientResponse.setUnitName(recipeIngredient.getUnit().getUnitName());
        recipeIngredientResponse.setFoodname(recipeIngredient.getFoodCatalog().getFoodName());
        return recipeIngredientResponse;
    }


}


