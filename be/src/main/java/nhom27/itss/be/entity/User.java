package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.enums.Role;

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
@Table(name = "users")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User {
    @Id
    @Column(name = "user_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer userId;

    @Column(name = "username", nullable = false)
    String username;

    @Column(name = "password", nullable = false)
    String password;

    @Column(name = "email", nullable = false)
    String email;

    @Column(name = "full_name")
    String fullName;

    @Enumerated(EnumType.STRING)
    @Column(name = "role")
    Role role;

    @Column(name = "created_at")
    Timestamp createdAt;

    @Column(name = "updated_at")
    Timestamp updatedAt;

    @OneToMany(mappedBy = "user")
    List<FamilyGroupMember> familyGroupMembers = new ArrayList<>();

    @OneToMany(mappedBy = "createdBy")
    private Set<FamilyGroup> familygroups = new LinkedHashSet<>();

    @OneToMany(mappedBy = "createdBy")
    private Set<MealPlan> mealplans = new LinkedHashSet<>();

    @OneToMany(mappedBy = "user")
    private Set<Notification> notifications = new LinkedHashSet<>();

    @OneToMany(mappedBy = "createdBy")
    private Set<Recipe> recipes = new LinkedHashSet<>();

    @OneToMany(mappedBy = "purchasedBy")
    private Set<ShoppingListItem> shoppinglistitems = new LinkedHashSet<>();

    @OneToMany(mappedBy = "createdBy")
    private Set<ShoppingList> shoppinglists = new LinkedHashSet<>();

}
