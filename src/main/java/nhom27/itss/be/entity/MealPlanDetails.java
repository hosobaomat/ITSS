package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.sql.Date;

@jakarta.persistence.Table(name = "MealPlanDetails")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "MealPlanDetails")
public class MealPlanDetails implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "plan_detail_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "plan_detail_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer planDetailId;

    @jakarta.persistence.Column(name = "plan_id")
    @Column(name = "plan_id")
    private Integer planId;

    @jakarta.persistence.Column(name = "recipe_id")
    @Column(name = "recipe_id")
    private Integer recipeId;

    @jakarta.persistence.Column(name = "meal_date")
    @Column(name = "meal_date")
    private Date mealDate;

    @jakarta.persistence.Column(name = "meal_type")
    @Column(name = "meal_type")
    private String mealType;

}
