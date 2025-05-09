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
@Table(name = "MealPlanDetails")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlanDetail {
    @Id
    @Column(name = "plan_detail_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer planDetailId;

    @Column(name = "plan_id")
    Integer planId;

    @Column(name = "recipe_id")
    Integer recipeId;

    @Column(name = "meal_date")
    Timestamp mealDate;

    @Column(name = "meal_type")
    String mealType;
}
