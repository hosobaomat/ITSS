package nhom27.itss.be.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "RecipeIngredients")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeIngredient {
    @Id
    @Column(name = "recipe_id", nullable = false)
    private Integer recipeId;

    @Id
    @Column(name = "food_id", nullable = false)
    Integer foodId;

    @Column(name = "quantity", nullable = false)
    BigDecimal quantity;

    @Column(name = "unit")
    String unit;
}
