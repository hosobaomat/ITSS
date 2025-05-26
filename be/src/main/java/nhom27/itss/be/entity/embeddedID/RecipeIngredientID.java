package nhom27.itss.be.entity.embeddedID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
@FieldDefaults(level = AccessLevel.PRIVATE)
@EqualsAndHashCode
public class RecipeIngredientID implements Serializable {
    @Column(name = "recipe_id")
    Integer recipeId;

    @Column(name = "food_catalog_id")
    Integer foodCatalogId;
}
