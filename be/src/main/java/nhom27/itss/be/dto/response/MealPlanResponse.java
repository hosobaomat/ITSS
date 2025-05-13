package nhom27.itss.be.dto.response;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.util.List;

@Getter
@Setter
@Data
public class MealPlanResponse {
    private Integer planId;
    private String planName;
    private Timestamp startDate;
    private Timestamp endDate;
    private Integer groupId;
    private Integer createdBy;
    private Timestamp createdAt;
    private List<MealDetailResponse> details;

    @Data
    public static class MealDetailResponse {
        private Integer planDetailId;
        private Integer recipeId;
        private String recipeName;
        private Timestamp mealDate;
        private String mealType;
    }
}
