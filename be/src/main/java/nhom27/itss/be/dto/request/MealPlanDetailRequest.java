package nhom27.itss.be.dto.request;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class MealPlanDetailRequest {
    private Integer recipeId;
    private Timestamp mealDate;
    private String mealType;
}
