package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "FoodCategories")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCategory {

    //static final long serialVersionUID = 1L;

    @Id
    @Column(name = "category_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer categoryId;

    @Column(name = "category_name", nullable = false)
    String categoryName;

    @Column(name = "description")
    String description;

}
