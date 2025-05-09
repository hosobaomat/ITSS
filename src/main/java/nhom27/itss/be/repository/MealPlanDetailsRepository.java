package nhom27.itss.be.repository;

import nhom27.itss.be.entity.MealPlanDetails;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface MealPlanDetailsRepository extends JpaRepository<MealPlanDetails, Integer>, JpaSpecificationExecutor<MealPlanDetails> {

}