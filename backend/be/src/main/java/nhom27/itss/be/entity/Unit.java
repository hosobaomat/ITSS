package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;


import java.util.LinkedHashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Table(name = "units")
public class Unit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "unit_id", nullable = false)
    Integer id;


    @Column(name = "unit_name", nullable = false, length = 50)
    String unitName;

    @Lob
    @Column(name = "description")
    String description;


    @OneToMany(mappedBy = "unit")
    Set<FoodItem> fooditems = new LinkedHashSet<>();

    @OneToMany(mappedBy = "unit")
    Set<RecipeIngredient> recipeIngredients = new LinkedHashSet<>();

    @OneToMany(mappedBy = "unit")
    Set<ShoppingListItem> shoppinglistitems = new LinkedHashSet<>();

    @ManyToOne
    @JoinColumn(name = "food_category_id")
    FoodCategory foodCategory;

}