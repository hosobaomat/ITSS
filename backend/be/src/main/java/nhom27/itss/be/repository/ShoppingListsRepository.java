package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.ShoppingList;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface ShoppingListsRepository extends JpaRepository<ShoppingList, Integer>, JpaSpecificationExecutor<ShoppingList> {
    List<ShoppingList> findBycreatedBy (User createdBy);
    List<ShoppingList> findBygroup (FamilyGroup group);

}