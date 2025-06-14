package nhom27.itss.be.repository;

import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.MealPlanDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface MealPlanDetailsRepository extends JpaRepository<MealPlanDetail, Integer>, JpaSpecificationExecutor<MealPlanDetail> {
    List<MealPlanDetail> findByMealPlan(MealPlan mealPlanId);

}