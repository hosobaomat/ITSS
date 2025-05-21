package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.repository.MealPlansRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mealplans")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MealPlanController {

    MealPlansRepository mealPlanRepository;

    @GetMapping
    public ApiResponse<List<MealPlan>> getAllMealPlans() {
        List<MealPlan> result = mealPlanRepository.findAll();
        return ApiResponse.<List<MealPlan>>builder()
                .result(result)
                .code(200)
                .build();
    }

    @PostMapping
    public ApiResponse<MealPlan> createMealPlan(@RequestBody MealPlan mealPlan) {
        MealPlan savedPlan = mealPlanRepository.save(mealPlan);
        return ApiResponse.<MealPlan>builder()
                .result(savedPlan)
                .code(201)
                .build();
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
