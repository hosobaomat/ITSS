package nhom27.itss.be.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
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
    @Column(name = "group_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer groupId;

    @Column(name = "group_name", nullable = false)
    String groupName;

    @Column(name = "created_at")
    Timestamp createdAt;

    @OneToMany(mappedBy = "group",cascade = CascadeType.ALL )
    Set<FamilyGroupMember> members = new LinkedHashSet<>();

    @OneToMany(mappedBy = "group",cascade = CascadeType.ALL)
    Set<FoodItem> foodItems = new LinkedHashSet<>();

    @OneToMany(mappedBy = "group",cascade = CascadeType.ALL)
    Set<MealPlan> mealplans = new LinkedHashSet<>();

    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL)
    Set<ShoppingList> shoppinglists = new LinkedHashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    User createdBy;

    @Size(max = 5)
    @NotNull
    @Column(name = "invite_code", nullable = false, length = 5)
    private String inviteCode;

}
