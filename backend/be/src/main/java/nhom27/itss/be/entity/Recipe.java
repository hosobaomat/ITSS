package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "recipes")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Recipe {
    @Id
    @Column(name = "recipe_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer recipeId;

    @Column(name = "recipe_name", nullable = false)
    String recipeName;

    @Column(name = "description")
    String description;

    @Column(name = "instructions", nullable = false)
    String instructions;

    @Column(name = "prep_time")
    Integer prepTime;

    @Column(name = "cook_time")
    Integer cookTime;


    @Column(name = "created_at")
    Timestamp createdAt;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;


    @OneToMany(mappedBy = "recipe",cascade = CascadeType.ALL,fetch = FetchType.EAGER)
    private Set<RecipeIngredient> recipeingredients = new LinkedHashSet<>();

//    @OneToMany(mappedBy = "recipe")
//    List<MealPlanDetail> planMealDetail;

}
