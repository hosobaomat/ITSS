package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.embeddedID.RecipeIngredientID;

import java.math.BigDecimal;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "recipeingredients")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeIngredient {
    @EmbeddedId
    RecipeIngredientID recipeIngredientID;

    @Column(name = "quantity", nullable = false)
    BigDecimal quantity;

    @Column(name = "unit")
    String unit;
}
