package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeIngredientResponse {
    String recipeName;
    String instructions;
    Integer prepTime;
    Integer cookTime;
    String description;
    Timestamp createdAt;
    String createBy;
    Set<RecipeIngredientResponse> ingredients = new HashSet<>();

}
