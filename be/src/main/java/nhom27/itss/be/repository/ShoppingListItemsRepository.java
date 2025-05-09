package nhom27.itss.be.repository;

import nhom27.itss.be.entity.ShoppingListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ShoppingListItemsRepository extends JpaRepository<ShoppingListItem, Integer>, JpaSpecificationExecutor<ShoppingListItem> {

}