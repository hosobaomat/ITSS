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
@Table(name = "Notifications")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int notification_id;
    int user_id;
    int food_id;
    String messages;

    @Enumerated(EnumType.STRING)
    String notification_type;
    Timestamp created_at;
    boolean is_read;
}
