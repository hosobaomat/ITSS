package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Date;
import java.sql.Timestamp;

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
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    int plan_id;
    int group_id;

    String plan_name;
    Date start_date;
    Date end_date;

    int created_by;
    Timestamp created_at;
}
