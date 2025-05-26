package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.repository.MealPlansRepository;
import nhom27.itss.be.service.MealPlanService;
import org.springframework.http.ResponseEntity;
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
    public ApiResponse<List<MealPlan>> getAllMealPlans() {
        List<MealPlan> result = mealPlanRepository.findAll();
        return ApiResponse.<List<MealPlan>>builder()
                .result(result)
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

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<MealPlan>> getMealPlanById(@PathVariable Integer id) {
        return mealPlanRepository.findById(id)
                .map(plan -> ResponseEntity.ok(
                        ApiResponse.<MealPlan>builder()
                                .result(plan)
                                .code(200)
                                .build()))
                .orElse(ResponseEntity.notFound().build());
    }
}
