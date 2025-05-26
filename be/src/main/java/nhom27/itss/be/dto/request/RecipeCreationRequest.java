package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeCreationRequest {
    String recipeName;
    String instructions;
    Integer prepTime;
    Integer cookTime;
    String description;
    Integer createdBy;

}
