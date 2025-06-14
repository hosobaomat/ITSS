package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeResponse {
    Integer id ;
    String recipeName;
    String instructions;
    Integer prepTime;
    Integer cookTime;
    String description;
    String createdBy;
    List<RecipeIngredientResponse> ingredients = new ArrayList<>();

}
