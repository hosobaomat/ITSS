package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealDetailResponse {
    Integer planDetailId;
    Integer recipeId;
    String recipeName;
    Timestamp mealDate;
    String mealType;
}
