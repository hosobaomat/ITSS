package nhom27.itss.be.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@jakarta.persistence.Table(name = "RecipeIngredients")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "RecipeIngredients")
public class RecipeIngredients implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.Column(name = "recipe_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "recipe_id", nullable = false)
    private Integer recipeId;

    @jakarta.persistence.Column(name = "food_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "food_id", nullable = false)
    private Integer foodId;

    @jakarta.persistence.Column(name = "quantity", nullable = false)
    @Column(name = "quantity", nullable = false)
    private BigDecimal quantity;

    @jakarta.persistence.Column(name = "unit")
    @Column(name = "unit")
    private String unit;

}
