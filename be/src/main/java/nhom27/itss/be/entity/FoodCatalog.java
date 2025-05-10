package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "foodcatalog")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCatalog implements java.io.Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "food_catalog_id", nullable = false)
    Integer foodCatalogId;

    @Column(name = "food_name", nullable = false)
    String foodName;

    @Column(name = "category_id")
    Integer categoryId;


    @Column(name = "description")
    String description;

}
