package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "Notifications")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "Notifications")
public class Notifications implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.Column(name = "notification_id", nullable = false)
    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id", nullable = false)
    private Integer notificationId;

    @jakarta.persistence.Column(name = "user_id")
    @Column(name = "user_id")
    private Integer userId;

    @jakarta.persistence.Column(name = "food_id")
    @Column(name = "food_id")
    private Integer foodId;

    @jakarta.persistence.Column(name = "message", nullable = false)
    @Column(name = "message", nullable = false)
    private String message;

    @jakarta.persistence.Column(name = "notification_type")
    @Column(name = "notification_type")
    private String notificationType;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

    @jakarta.persistence.Column(name = "is_read")
    @Column(name = "is_read")
    private Boolean read;

}
