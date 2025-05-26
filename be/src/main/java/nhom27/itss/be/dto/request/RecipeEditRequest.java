package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.RecipeIngredient;

import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeEditRequest {
    Integer recipeId;
    String recipeName;
    String instructions;
    Integer prepTime;
    Integer cookTime;
    String description;
    Integer createdBy;

    Set<RecipeIngeredientRequest> ingredients = new HashSet<>();

}
