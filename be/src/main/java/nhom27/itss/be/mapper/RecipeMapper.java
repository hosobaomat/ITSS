package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.RecipeIngredientResponse;
import nhom27.itss.be.dto.response.RecipeResponse;
import nhom27.itss.be.entity.Recipe;
import nhom27.itss.be.entity.RecipeIngredient;
import org.springframework.stereotype.Component;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class RecipeMapper {

    public static RecipeResponse toRecipeResponse(Recipe Recipe) {
        if (Recipe == null) {
            return null;
        }
        return getRecipeToResponse(Recipe);
    }

    private static RecipeResponse getRecipeToResponse(Recipe recipe) {
        RecipeResponse recipeResponse = new RecipeResponse();
        recipeResponse.setRecipeName(recipe.getRecipeName());
        recipeResponse.setId(recipe.getRecipeId());
        recipeResponse.setDescription(recipe.getDescription()) ;
        recipeResponse.setInstructions(recipe.getInstructions()) ;
        recipeResponse.setCookTime(recipe.getCookTime()) ;
        recipeResponse.setPrepTime(recipe.getPrepTime()) ;
        recipeResponse.setCreatedBy(recipe.getCreatedBy().getEmail());
        recipeResponse.setIngredients(recipe.getRecipeingredients().stream().map(
                RecipeMapper::toRecipeIngredientResponse
        ).toList());

        return recipeResponse;
    }

    public static RecipeIngredientResponse toRecipeIngredientResponse(RecipeIngredient recipeIngredient) {
        if (recipeIngredient == null) {
            return null;
        }
        return getRecipeIngredientResponse(recipeIngredient);
    }

    private static RecipeIngredientResponse getRecipeIngredientResponse(RecipeIngredient recipeIngredient) {
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
