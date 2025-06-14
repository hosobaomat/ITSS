package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlanDetailRequest {
    Integer recipeId;
    Timestamp mealDate;
    String mealType;
}
