package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.embeddedID.RecipeIngredientID;
import org.springframework.format.annotation.DurationFormat;

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
    private RecipeIngredientID id;

    @ManyToOne
    @MapsId("recipeId") // tên field trong RecipeIngredientId
    @JoinColumn(name = "recipe_id")
    private Recipe recipe;

    @ManyToOne
    @MapsId("foodId") // tên field trong RecipeIngredientId
    @JoinColumn(name = "food_id")
    private FoodCatalog foodCatalog;

    @Column(name = "quantity", nullable = false)
    Integer quantity;

    @ManyToOne
    @JoinColumn(name = "unit_id")
    private Unit unit;


}
