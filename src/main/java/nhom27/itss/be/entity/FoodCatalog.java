package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;

@jakarta.persistence.Table(name = "foodcatalog")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "FoodCatalog")
public class FoodCatalog implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.Column(name = "food_catalog_id", nullable = false)
    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Id
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_catalog_id", nullable = false)
    private Integer foodCatalogId;

    @jakarta.persistence.Column(name = "food_name", nullable = false)
    @Column(name = "food_name", nullable = false)
    private String foodName;

    @jakarta.persistence.Column(name = "category_id")
    @Column(name = "category_id")
    private Integer categoryId;

    @jakarta.persistence.Column(name = "description")
    @Column(name = "description")
    private String description;

}
