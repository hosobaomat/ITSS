package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "recipes")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "Recipes")
public class Recipes implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "recipe_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "recipe_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer recipeId;

    @jakarta.persistence.Column(name = "recipe_name", nullable = false)
    @Column(name = "recipe_name", nullable = false)
    private String recipeName;

    @jakarta.persistence.Column(name = "description")
    @Column(name = "description")
    private String description;

    @jakarta.persistence.Column(name = "instructions", nullable = false)
    @Column(name = "instructions", nullable = false)
    private String instructions;

    @jakarta.persistence.Column(name = "prep_time")
    @Column(name = "prep_time")
    private Integer prepTime;

    @jakarta.persistence.Column(name = "cook_time")
    @Column(name = "cook_time")
    private Integer cookTime;

    @jakarta.persistence.Column(name = "created_by")
    @Column(name = "created_by")
    private Integer createdBy;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

}
