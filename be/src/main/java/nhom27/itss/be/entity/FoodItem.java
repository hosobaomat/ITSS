package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "fooditems")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodItem {
    @Id
    @Column(name = "food_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer foodId;

    @JoinColumn(name = "group_id")
    @ManyToOne
    FamilyGroup group;

    @Column(name = "food_name", nullable = false)
    String foodName;

    @Column(name = "quantity", nullable = false)
    Integer quantity;

    @Column(name = "expiry_date")
    Timestamp expiryDate;

    @Column(name = "storage_location")
    String storageLocation;

    @Column(name = "added_at")
    Timestamp addedAt;

    @Column(name = "updated_at")
    Timestamp updatedAt;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unit_id")
    private Unit unit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_catalog_id")
    private FoodCatalog foodCatalog;



}
