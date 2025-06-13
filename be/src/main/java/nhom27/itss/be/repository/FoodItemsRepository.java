package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.FoodItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface FoodItemsRepository extends JpaRepository<FoodItem, Integer> {

    // Tìm kiếm
    List<FoodItem> findByGroup(FamilyGroup group);

    @Query("SELECT fi FROM FoodItem fi WHERE fi.expiryDate BETWEEN :startDate AND :endDate AND fi.quantity > 0")
    List<FoodItem> findByExpiryDateBetweenAndQuantityGreaterThan(
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate);

    @Query("SELECT f FROM FoodItem f WHERE f.group.groupId= :groupId AND f.expiryDate >= CURRENT_DATE AND f.quantity > 0")
    List<FoodItem> findValidFoodItemsByGroupId(@Param("groupId") Integer groupId);

    @Query("SELECT f FROM FoodItem f WHERE f.group.groupId = :groupId AND f.expiryDate IS NOT NULL AND f.expiryDate <= CURRENT_DATE AND f.quantity > 0")
    List<FoodItem> findAllExpiredFoodItems();

    @Query("SELECT DISTINCT f.storageLocation FROM FoodItem f  WHERE f.storageLocation IS NOT NULL")
    List<String> findDistinctStorageLocations();


    @Query("SELECT f FROM FoodItem f WHERE f.expiryDate <= :date AND f.is_deleted = 0")
    List<FoodItem> findFoodItemsExpiringBefore(@Param("date") Date date);



}