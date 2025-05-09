package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodItems;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FoodItemsRepository extends JpaRepository<FoodItems, Integer>, JpaSpecificationExecutor<FoodItems> {

}