package nhom27.itss.be.dto.request;

import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class CreateMealPlanRequest {
    private String planName;
    private LocalDate startDate;
    private LocalDate endDate;
    private Integer groupId;
    private Integer createdBy;
    private List<MealDetailRequest> details;

    @Data
    public static class MealDetailRequest {
        private Integer recipeId;
        private LocalDate mealDate;
        private String mealType; // breakfast, lunch, dinner
    }
}