package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FoodHistoryRepository extends JpaRepository<FoodHistory, Integer> {
    Optional<List<FoodHistory>> findByGroup_GroupIdAndAction(Integer groupId, String action);


}