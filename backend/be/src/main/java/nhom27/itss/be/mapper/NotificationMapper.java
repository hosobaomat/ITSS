package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.NotificationResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.Notification;
import nhom27.itss.be.entity.User;
import org.springframework.stereotype.Component;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class NotificationMapper {

    public static NotificationResponse toNotificationsResponse(Notification notification) {
        if (notification == null) {
            return null;
        }
        return getNotificationsResponse(notification);
    }

    private static NotificationResponse getNotificationsResponse(Notification notification) {
        NotificationResponse notificationResponse = new NotificationResponse();
        notificationResponse.setNotificationId(notification.getNotificationId());
        notificationResponse.setUserId(notification.getUser().getUserId());
        notificationResponse.setMessage(notification.getMessage());
        notificationResponse.setCreatedAt(notification.getCreatedAt());
        notificationResponse.setIsRead(notification.getRead());
        notificationResponse.setNotificationType(notification.getNotificationType());
        notificationResponse.setFoodId(notification.getFood().getFoodId());
        return notificationResponse;
    }
}
