package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "shoppinglistitems")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListItem {
    @Id
    @Column(name = "list_item_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer listItemId;

    @Column(name = "list_id")
    Integer listId;

    @Column(name = "food_id")
    Integer foodId;

    @Column(name = "food_name")
    String foodName;

    @Column(name = "category_id")
    Integer categoryId;

    @Column(name = "quantity", nullable = false)
    Integer quantity;

    @Column(name = "status")
    String status;

    @Column(name = "purchased_by")
    Integer purchasedBy;

    @Column(name = "purchased_at")
    Timestamp purchasedAt;
}
