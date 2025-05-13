package nhom27.itss.be.controller;

import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.repository.MealPlansRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/mealplans")
public class MealPlanController {

    @Autowired
    private MealPlansRepository mealPlanRepository;

    @GetMapping
    public List<MealPlan> getAllMealPlans() {
        return mealPlanRepository.findAll();
    }

    @PostMapping
    public MealPlan createMealPlan(@RequestBody MealPlan mealPlan) {
        return mealPlanRepository.save(mealPlan);
    }

    @GetMapping("/{id}")
    public ResponseEntity<MealPlan> getMealPlanById(@PathVariable Integer id) {
        return mealPlanRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
