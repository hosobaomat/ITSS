package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class NotificationResponse {
    Integer notificationId;
    String message;
    String notificationType;
    Timestamp createdAt;
    Boolean isRead;

    Integer userId;
    Integer foodId;

}
