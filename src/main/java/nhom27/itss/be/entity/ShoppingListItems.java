package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@jakarta.persistence.Table(name = "shoppinglistitems")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "ShoppingListItems")
public class ShoppingListItems implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "list_item_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "list_item_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer listItemId;

    @jakarta.persistence.Column(name = "list_id")
    @Column(name = "list_id")
    private Integer listId;

    @jakarta.persistence.Column(name = "food_id")
    @Column(name = "food_id")
    private Integer foodId;

    @jakarta.persistence.Column(name = "food_name")
    @Column(name = "food_name")
    private String foodName;

    @jakarta.persistence.Column(name = "category_id")
    @Column(name = "category_id")
    private Integer categoryId;

    @jakarta.persistence.Column(name = "quantity", nullable = false)
    @Column(name = "quantity", nullable = false)
    private BigDecimal quantity;

    @jakarta.persistence.Column(name = "status")
    @Column(name = "status")
    private String status;

    @jakarta.persistence.Column(name = "purchased_by")
    @Column(name = "purchased_by")
    private Integer purchasedBy;

    @jakarta.persistence.Column(name = "purchased_at")
    @Column(name = "purchased_at")
    private Date purchasedAt;

}
