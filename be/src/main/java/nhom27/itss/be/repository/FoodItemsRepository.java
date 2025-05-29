package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.FoodItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface FoodItemsRepository extends JpaRepository<FoodItem, Integer> {

    // Tìm kiếm
    List<FoodItem> findByGroup(FamilyGroup group);
//    List<FoodItem> findByGroup_IdAndFoodNameContainingIgnoreCase(Integer groupId, String foodName);
//    List<FoodItem> findByGroup_IdAndFoodCatalog_Category_Id(Integer groupId, Integer categoryId);
//    List<FoodItem> findByGroup_IdAndFoodNameContainingIgnoreCaseAndFoodCatalog_Category_Id(Integer groupId, String foodName, Integer categoryId);
//
//    // Tìm item cụ thể trong nhóm
//    Optional<FoodItem> findByFoodIdAndGroup_Id(Integer foodId, Integer groupId);
//
//    // Tìm item sắp hết hạn
//    List<FoodItem> findByExpiryDateBetween(Timestamp startDate, Timestamp endDate);

    @Query("SELECT f FROM FoodItem f WHERE f.expiryDate BETWEEN :startDate AND :endDate")
    List<FoodItem> findByExpiryDateBetween(Date startDate, Date endDate);

    List<FoodItem> findByGroupAndExpiryDateAfter(FamilyGroup group, Date date);
}