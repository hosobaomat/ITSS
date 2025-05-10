package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "notifications")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id", nullable = false)
    Integer notificationId;

    @Column(name = "user_id")
    Integer userId;

    @Column(name = "food_id")
    Integer foodId;

    @Column(name = "message", nullable = false)
    String message;

    @Column(name = "notification_type")
    String notificationType;

    @Column(name = "created_at")
    Timestamp createdAt;

    @Column(name = "is_read")
    Boolean read;
}
