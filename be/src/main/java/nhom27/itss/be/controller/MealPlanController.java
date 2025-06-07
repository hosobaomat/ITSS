package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.MealDetailResponse;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.repository.MealPlansRepository;
import nhom27.itss.be.service.MealPlanService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mealplans")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MealPlanController {

    MealPlansRepository mealPlanRepository;
    MealPlanService mealPlanService;

    @GetMapping
    public ApiResponse<List<MealPlanResponse>> getAllMealPlans() {
        List<MealPlan> result = mealPlanRepository.findAll();

        return ApiResponse.<List<MealPlanResponse>>builder()
                .result(result.stream().map(mealPlanService::mapPlanToResponse).toList())
                .code(200)
                .build();
    }

    @PostMapping("")
    public ApiResponse<MealPlanResponse> createMealPlan(@RequestBody CreateMealPlanRequest request) {
        ApiResponse<MealPlanResponse> response = new ApiResponse<>();
        response.setResult(mealPlanService.createMealPlan(request));  // gọi instance method
        response.setCode(201);
        return response;
    }

    @PatchMapping("/finish/{mealplanId}")
    public ApiResponse<MealPlanResponse> finishMealPlan( @PathVariable Integer mealplanId) {
        ApiResponse<MealPlanResponse> response = new ApiResponse<>();
        response.setResult(mealPlanService.finishedMealPlan(mealplanId));  // gọi instance method
        response.setCode(201);
        return response;
    }

    @GetMapping("/{id}")
    public ApiResponse<MealPlanResponse> getMealPlanById(@PathVariable Integer id) {
        MealPlanResponse mealPlanResponse = mealPlanService.getMealPlanById(id);
        ApiResponse<MealPlanResponse> response = new ApiResponse<>();
        response.setResult(mealPlanResponse);
        response.setCode(200);
        return response;
    }
    @GetMapping("/group/{groupId}")
    public ApiResponse<List<MealPlanResponse>> getMealPlansByGroup(@PathVariable Integer groupId) {
        ApiResponse<List<MealPlanResponse>> response = new ApiResponse<>();
        response.setResult(mealPlanService.getMealPlansByGroupId(groupId));
        response.setCode(200);
        return response;
    }

    @GetMapping("/createdby/{userId}")
    public ApiResponse<List<MealPlanResponse>> getMealPlansByCreatedBy(@PathVariable Integer userId) {
        ApiResponse<List<MealPlanResponse>> response = new ApiResponse<>();
        response.setResult(mealPlanService.getMealPlansByUserId(userId));
        response.setCode(200);
        return response;
    }


    @DeleteMapping("/{id}")
    ApiResponse<String> deleteShoppingList(@PathVariable Integer id){
        mealPlanService.deleteMealPlan(id);
        return ApiResponse.<String>builder()
                .result("mealplan has been deleted")
                .code(200).build();
    }

}

