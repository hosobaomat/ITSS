package nhom27.itss.be.service;

import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.RecipeCreationRequest;
import nhom27.itss.be.dto.request.RecipeEditRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.entity.embeddedID.RecipeIngredientID;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.mapper.RecipeMapper;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import static nhom27.itss.be.mapper.RecipeMapper.toRecipeResponse;


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

        User createdBy = usersRepository.findById(request.getCreatedBy()).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION));

        recipe.setCreatedBy(createdBy);

        recipesRepository.save(recipe);

        return toRecipeResponse(recipe) ;
    }

    @Transactional
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

        return toRecipeResponse(recipe);

    }


    public void deleteIngredientFromRecipe(Integer recipeId){
        recipesRepository.deleteById(recipeId);
    }


    public List<RecipeResponse> getAllRecipes(){
        List<Recipe> recipes = recipesRepository.findAll();

        return  recipes.stream().map(RecipeMapper::toRecipeResponse).toList();
    }

    public RecipeResponse getRecipesById(Integer recipeId){
        Recipe recipes = recipesRepository.findById(recipeId).orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS));
        return  toRecipeResponse(recipes) ;
    }


    public List<RecipeResponse> getRecipesByUserId(Integer userId){
        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
        List<Recipe> recipes = recipesRepository.findByCreatedBy(user);
        return  recipes.stream().map(RecipeMapper::toRecipeResponse).toList() ;
    }





    public List<RecipeIngredientResponse> getMissingIngredient(Integer groupId,Integer recipeId){
           Recipe recipe = recipesRepository.findById(recipeId).orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS));

           List<FoodItem> itemsInFridge = foodItemsRepository.findValidFoodItemsByGroupId(groupId);
           List<RecipeIngredient> ingredients = recipeIngredientsRepository.findByRecipe(recipe);

           List<RecipeIngredient> missingIngredients = ingredients.stream()
                   .filter(ingredient -> itemsInFridge.stream().noneMatch(item ->
                           item.getFoodCatalog().getFoodCatalogId().equals(ingredient.getFoodCatalog().getFoodCatalogId())
                                   && item.getUnit().getId().equals(ingredient.getUnit().getId())
                                   && item.getQuantity() >= ingredient.getQuantity()))
                   .toList();


        return missingIngredients.stream().map(
                   RecipeMapper::toRecipeIngredientResponse
           ).toList();

    }






}


