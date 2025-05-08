package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "FoodCatalog")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCatalog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int food_catalog_id ;

    String food_name;
    int category_id;
    String description;

}
