package nhom27.itss.be.repository;

import nhom27.itss.be.entity.ShoppingList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ShoppingListsRepository extends JpaRepository<ShoppingList, Integer>, JpaSpecificationExecutor<ShoppingList> {

}