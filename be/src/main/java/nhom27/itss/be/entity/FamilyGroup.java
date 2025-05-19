package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.embeddedID.FamilyGroupMemberId;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "familygroups")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "group_id", nullable = false)
    Integer group_id;

    @Column(name = "group_name", nullable = false)
    String groupName;

    @Column(name = "created_at")
    Timestamp createdAt;

    @OneToMany(mappedBy = "group")
    List<FamilyGroupMember> members = new ArrayList<>();

    @OneToMany(mappedBy = "group")
    List<FoodItem> foodItems = new ArrayList<>();

    @OneToMany(mappedBy = "group")
    private Set<MealPlan> mealplans = new LinkedHashSet<>();

    @OneToMany(mappedBy = "group")
    private Set<Report> reports = new LinkedHashSet<>();

    @OneToMany(mappedBy = "group")
    private Set<ShoppingList> shoppinglists = new LinkedHashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

}
