package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Date;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "MealPlanDetails")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlanDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int plan_detail_id;
    int plan_id;
    int recipe_id;

    Date meal_date;
    @Enumerated(EnumType.STRING)
    String meal_type;
}
