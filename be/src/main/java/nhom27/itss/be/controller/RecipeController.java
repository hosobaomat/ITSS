package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddShopingListItemRequest;
import nhom27.itss.be.dto.request.EditShoppingListRequest;
import nhom27.itss.be.dto.request.RecipeCreationRequest;
import nhom27.itss.be.dto.request.RecipeEditRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.service.RecipeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/Recipe")
public class RecipeController {
    RecipeService recipeService;

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
    ApiResponse<String> getShoppingListById(@PathVariable Integer recipeId){
        recipeService.getRecipesById(recipeId);
        return ApiResponse.<String>builder()
                .result("Recipe has been deleted")
                .code(200).build();
    }

    @PatchMapping("/addIngredients")
    ApiResponse<RecipeResponse> addItemToList(@RequestBody /*@Valid */ RecipeEditRequest request) {
        ApiResponse<RecipeResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(recipeService.addIngredientToRecipe(request));
        return response;
    }





}
