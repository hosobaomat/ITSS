package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.MealDetailResponse;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.MealPlanDetail;
import nhom27.itss.be.entity.User;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class MealPlanMapper {

    public static MealPlanResponse toMealPlanResponse(MealPlan plan) {
        if (plan == null) {
            return null;
        }
        return getMealPlanResponse(plan);
    }

    public static MealPlanResponse getMealPlanResponse(MealPlan plan) {
        return MealPlanResponse.builder()
                .planId(plan.getPlanId())
                .groupId(plan.getGroup().getGroupId())
                .planName(plan.getPlanName())
                .startDate(plan.getStartDate())
                .endDate(plan.getEndDate())
                .createdAt(plan.getCreatedAt())
                .createdBy(plan.getCreatedBy().getUserId())
                .details(plan.getMealplandetails().stream().map(MealPlanMapper::toMealDetailResponse).collect(Collectors.toList()))
                .status(plan.getStatus())
                .build();
    }

    public static MealDetailResponse toMealDetailResponse(MealPlanDetail detail) {
        if (detail == null) {
            return null;
        }
        return getMealDetailToResponse(detail);
    }

    public static MealDetailResponse getMealDetailToResponse(MealPlanDetail detail) {
        MealDetailResponse detailResponse = new MealDetailResponse();
        detailResponse.setPlanDetailId(detail.getPlanDetailId());
        detailResponse.setMealDate(detail.getMealDate());
        detailResponse.setRecipeName(detail.getRecipe().getRecipeName());
        detailResponse.setMealType(detail.getMealType());
        detailResponse.setRecipeId(detail.getRecipe().getRecipeId());
        return  detailResponse;
    }
}
