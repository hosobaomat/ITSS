package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "ShoppingListItems")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int list_item_id;
    int list_id;
    int food_id;
    String food_name;
    int category_id;
    BigDecimal quantity;
    @Enumerated(EnumType.STRING)
    String status;
    Integer purchased_by;
    Timestamp purchased_at;
}
