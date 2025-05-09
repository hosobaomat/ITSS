package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FoodCategoriesRepository extends JpaRepository<FoodCategory, Integer>, JpaSpecificationExecutor<FoodCategory> {

}