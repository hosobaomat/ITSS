package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface MealPlansRepository extends JpaRepository<MealPlan, Integer>, JpaSpecificationExecutor<MealPlan> {


    List<MealPlan> findByGroup(FamilyGroup group);

    List<MealPlan> findByCreatedBy(User createdBy);

}