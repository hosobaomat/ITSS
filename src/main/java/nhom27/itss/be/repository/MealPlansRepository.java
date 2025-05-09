package nhom27.itss.be.repository;

import nhom27.itss.be.entity.MealPlans;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface MealPlansRepository extends JpaRepository<MealPlans, Integer>, JpaSpecificationExecutor<MealPlans> {

}