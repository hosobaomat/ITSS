package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.*;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.service.RecipeService;
import nhom27.itss.be.service.RecommendRecipeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/Recipe")
public class RecipeController {
    RecipeService recipeService;
    RecommendRecipeService recommendRecipeService;

    @PostMapping("")
    ApiResponse<RecipeResponse> createRecipe(@RequestBody /*@Valid */ RecipeCreationRequest request) {
        ApiResponse<RecipeResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(recipeService.createRecipe(request));
        return response;
    }
    //ForAdmin
    @GetMapping("")
    ApiResponse<List<RecipeResponse>> getAllRecipes() {
        ApiResponse<List<RecipeResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(recipeService.getAllRecipes());
        return response;
    }

    @GetMapping("/user/{userId}")
    ApiResponse<List<RecipeResponse>> getShoppingListByUserId( @PathVariable Integer userId) {
        ApiResponse<List<RecipeResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(recipeService.getRecipesByUserId(userId));
        return response;
    }


    @DeleteMapping("/{recipeId}")
    ApiResponse<String> deleteShoppingList(@PathVariable Integer recipeId){
        recipeService.deleteIngredientFromRecipe(recipeId);
        return ApiResponse.<String>builder()
                .result("Recipe has been deleted")
                .code(200).build();
    }

    @GetMapping("/{recipeId}")
    ApiResponse<RecipeResponse> getShoppingListById(@PathVariable Integer recipeId){
        return ApiResponse.<RecipeResponse>builder()
                .result(recipeService.getRecipesById(recipeId))
                .code(200).build();
    }

    @PatchMapping("/addIngredients")
    ApiResponse<RecipeResponse> addItemToList(@RequestBody /*@Valid */ RecipeEditRequest request) {
        ApiResponse<RecipeResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(recipeService.addIngredientToRecipe(request));
        return response;
    }

    @GetMapping("/suggestRecipe/{groupId}")
    public ApiResponse<List<RecipeResponse>> getSuggestedMealPlan(@PathVariable Integer groupId) {
        ApiResponse<List<RecipeResponse>> response = new ApiResponse<>();
        response.setResult(recommendRecipeService.recommendRecipes(groupId));
        response.setCode(200);
        return response;
    }

    @GetMapping("/missingIngredient/recipeId={recipeId}&&groupId={groupId}")
    public ApiResponse<List<RecipeIngredientResponse>> getMissingIngredient(@PathVariable Integer groupId,@PathVariable Integer recipeId) {
        ApiResponse<List<RecipeIngredientResponse>> response = new ApiResponse<>();
        response.setResult(recipeService.getMissingIngredient(groupId,recipeId));
        response.setCode(200);
        return response;
    }





}
