package nhom27.itss.be.service;

import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealPlanResponse;

public interface MealPlanService {
    MealPlanResponse createMealPlan(CreateMealPlanRequest request);
    MealPlanResponse getMealPlanById(Integer planId);
}
