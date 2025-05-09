package nhom27.itss.be.repository;

import nhom27.itss.be.entity.ShoppingListItems;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ShoppingListItemsRepository extends JpaRepository<ShoppingListItems, Integer>, JpaSpecificationExecutor<ShoppingListItems> {

}