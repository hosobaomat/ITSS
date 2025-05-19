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

    @ManyToOne
    @JoinColumn(name = "list_id")
    private ShoppingList shoppingList;


    @Column(name = "food_name")
    String foodName;

    @Column(name = "quantity", nullable = false)
    Integer quantity;

    @Column(name = "status")
    String status;

    @Column(name = "purchased_at")
    Timestamp purchasedAt;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unit_id")
    private Unit unit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "purchased_by")
    private User purchasedBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id")
    private FoodCatalog food;

}
