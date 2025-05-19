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
@Table(name = "mealplandetails")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlanDetail {
    @Id
    @Column(name = "plan_detail_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer planDetailId;

    @Column(name = "meal_date")
    Timestamp mealDate;

    @Column(name = "meal_type")
    String mealType;

    @ManyToOne
    @JoinColumn(name = "plan_id")
    MealPlan mealPlan;

    @OneToOne
    @JoinColumn(name = "recipe_id")
    Recipe recipe;
}
