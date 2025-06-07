package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodItem;
import nhom27.itss.be.entity.Notification;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NotificationsRepository extends JpaRepository<Notification, Integer> {
    boolean existsByFoodAndNotificationTypeAndUser(FoodItem food, String notificationType, User user);

    Optional<List<Notification>> findByUser_UserId(Integer userid);

}