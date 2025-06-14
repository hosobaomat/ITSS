package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "foodcategories")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCategory {

    @Id
    @Column(name = "category_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer categoryId;

    @Column(name = "category_name", nullable = false)
    String categoryName;

    @Column(name = "description")
    String description;

    @OneToMany(mappedBy = "foodCategory",cascade = CascadeType.ALL )
    private Set<FoodCatalog> foodcatalogs = new LinkedHashSet<>();


    @OneToMany(mappedBy = "foodCategory",fetch = FetchType.EAGER)
    private Set<Unit> units = new LinkedHashSet<>();
}
