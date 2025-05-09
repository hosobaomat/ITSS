package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.Date;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "MealPlans")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlan {
    @Id
    @Column(name = "plan_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer planId;

    @Column(name = "group_id")
    Integer groupId;

    @Column(name = "plan_name", nullable = false)
    String planName;

    @Column(name = "start_date")
    Timestamp startDate;

    @Column(name = "end_date")
    Timestamp endDate;

    @Column(name = "created_by")
    Integer createdBy;

    @Column(name = "created_at")
    Timestamp createdAt;
}
