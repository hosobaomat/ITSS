package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;

@jakarta.persistence.Table(name = "foodcategories")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "FoodCategories")
public class FoodCategories implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "category_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "category_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer categoryId;

    @jakarta.persistence.Column(name = "category_name", nullable = false)
    @Column(name = "category_name", nullable = false)
    private String categoryName;

    @jakarta.persistence.Column(name = "description")
    @Column(name = "description")
    private String description;

}
