package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@jakarta.persistence.Table(name = "FoodItems")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "FoodItems")
public class FoodItems implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "food_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "food_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer foodId;

    @jakarta.persistence.Column(name = "group_id")
    @Column(name = "group_id")
    private Integer groupId;

    @jakarta.persistence.Column(name = "category_id")
    @Column(name = "category_id")
    private Integer categoryId;

    @jakarta.persistence.Column(name = "food_name", nullable = false)
    @Column(name = "food_name", nullable = false)
    private String foodName;

    @jakarta.persistence.Column(name = "quantity", nullable = false)
    @Column(name = "quantity", nullable = false)
    private BigDecimal quantity;

    @jakarta.persistence.Column(name = "expiry_date")
    @Column(name = "expiry_date")
    private Date expiryDate;

    @jakarta.persistence.Column(name = "storage_location")
    @Column(name = "storage_location")
    private String storageLocation;

    @jakarta.persistence.Column(name = "added_at")
    @Column(name = "added_at")
    private Date addedAt;

    @jakarta.persistence.Column(name = "updated_at")
    @Column(name = "updated_at")
    private Date updatedAt;

}
