package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "foodcatalog")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCatalog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_catalog_id", nullable = false)
    Integer foodCatalogId;

    @Column(name = "food_name", nullable = false)
    String foodName;

    @ManyToOne
    @JoinColumn(name = "category_id")
    FoodCategory foodCategory;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "foodCatalog")
    private Set<FoodItem> fooditems = new LinkedHashSet<>();

    @OneToMany(mappedBy = "foodCatalog")
    private Set<RecipeIngredient> recipeingredients = new LinkedHashSet<>();

    @OneToMany(mappedBy = "food")
    private Set<ShoppingListItem> shoppinglistitems = new LinkedHashSet<>();

}
