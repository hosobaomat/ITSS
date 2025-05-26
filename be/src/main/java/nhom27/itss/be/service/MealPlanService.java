//package nhom27.itss.be.service;
//
//import lombok.AccessLevel;
//import lombok.RequiredArgsConstructor;
//import lombok.experimental.FieldDefaults;
//import lombok.extern.slf4j.Slf4j;
//import nhom27.itss.be.dto.request.RecipeCreationRequest;
//import nhom27.itss.be.dto.request.RecipeEditRequest;
//import nhom27.itss.be.dto.response.RecipeResponse;
//import nhom27.itss.be.entity.Recipe;
//import nhom27.itss.be.entity.RecipeIngredient;
//import nhom27.itss.be.entity.User;
//import nhom27.itss.be.exception.AppException;
//import nhom27.itss.be.exception.ErrorCode;
//import nhom27.itss.be.repository.FoodcatalogsRepository;
//import nhom27.itss.be.repository.RecipesRepository;
//import nhom27.itss.be.repository.UnitsRepository;
//import nhom27.itss.be.repository.UsersRepository;
//import org.springframework.stereotype.Service;
//
//import java.sql.Timestamp;
//import java.util.List;
//
//
//@Slf4j
//@Service
//@RequiredArgsConstructor
//@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
//public class MealPlanService {
//
//
//    UsersRepository usersRepository;
//    RecipesRepository recipesRepository;
//    UnitsRepository unitsRepository;
//    FoodcatalogsRepository foodcatalogsRepository;
//
//
//    public RecipeResponse createRecipe(RecipeCreationRequest request) {
//        Recipe recipe = new Recipe();
//
//        recipe.setRecipeName(request.getRecipeName());
//        recipe.setDescription(request.getDescription());
//        recipe.setInstructions(request.getInstructions());
//        recipe.setCookTime(request.getCookTime());
//        recipe.setPrepTime(request.getPrepTime());
//        recipe.setCreatedAt(new Timestamp(System.currentTimeMillis()));
//
//        User createdBy = usersRepository.findById(request.getCreatedBy()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
//
//        recipe.setCreatedBy(createdBy);
//
//        recipesRepository.save(recipe);
//
//        return RecipeToResponse(recipe) ;
//    }
//
//
//    public RecipeResponse addIngredientToRecipe(RecipeEditRequest request){
//        Recipe recipe = recipesRepository.findById(request.getRecipeId()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
//
//        List<RecipeIngredient> ingredients = request.getIngredients().stream().map(
//                item -> RecipeIngredient.builder()
//                        .quantity(item.getQuantity())
//                        .unit(unitsRepository.findById(item.getUnitId()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS)))
//                        .foodCatalog(foodcatalogsRepository.findById((item.getFoodCatalogId())).orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS)))
//                        .recipe(recipe)
//                        .build()
//        ).toList();
//
//        recipe.setRecipeIngredients(ingredients);
//
//        return RecipeToResponse(recipe) ;
//
//    }
//
//
//    public void deleteIngredientFromRecipe(RecipeEditRequest request){
//        recipesRepository.deleteById(request.getRecipeId());
//    }
//
//
//    public List<RecipeResponse> getAllRecipes(){
//        List<Recipe> recipes = recipesRepository.findAll();
//
//        return  recipes.stream().map(this::RecipeToResponse).toList();
//    }
//
//    public RecipeResponse getRecipesById(Integer recipeId){
//        Recipe recipes = recipesRepository.findById(recipeId).orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_EXISTS));
//        return  RecipeToResponse(recipes) ;
//    }
//
//    public List<RecipeResponse> getRecipesByUserId(Integer userId){
//        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));
//        List<Recipe> recipes = recipesRepository.findByCreatedBy(user);
//        return  recipes.stream().map(this::RecipeToResponse).toList() ;
//    }
//
//
////    Ham Mapping
//    private RecipeResponse RecipeToResponse(Recipe recipe) {
//        RecipeResponse recipeResponse = new RecipeResponse();
//        recipeResponse.setRecipeName(recipe.getRecipeName());
//        recipeResponse.setId(recipe.getRecipeId());
//        recipeResponse.setDescription(recipe.getDescription()) ;
//        recipeResponse.setInstructions(recipe.getInstructions()) ;
//        recipeResponse.setCookTime(recipe.getCookTime()) ;
//        recipeResponse.setPrepTime(recipe.getPrepTime()) ;
//
//        return recipeResponse;
//    }
//
//
//}
//
//
