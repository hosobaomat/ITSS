package nhom27.itss.be.repository;

import nhom27.itss.be.entity.ShoppingList;
import nhom27.itss.be.entity.ShoppingListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface ShoppingListItemsRepository extends JpaRepository<ShoppingListItem, Integer>, JpaSpecificationExecutor<ShoppingListItem> {
    void deleteAllByShoppingList(ShoppingList shoppingList);

    List<ShoppingListItem> findByShoppingList(ShoppingList list);
}