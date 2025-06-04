package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotificationsRepository extends JpaRepository<Notification, Integer> {
    // Kiểm tra để tránh gửi thông báo trùng lặp
//    boolean existsByFoodIdAndNotificationType(Integer foodId, String notificationType);
//      boolean existsByFoodIdAndNotificationTypeAndUserId(Integer foodId, String notificationType, Integer userId);

}