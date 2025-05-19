package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

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
@Table(name = "shoppinglists")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingList {
    @Id
    @Column(name = "list_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer listId;

    @Column(name = "list_name", nullable = false)
    String listName;

    @Column(name = "created_at")
    Timestamp createdAt;

    @Column(name = "start_date")
    Timestamp startDate;

    @Column(name = "end_date")
    Timestamp endDate;

    @Column(name = "Status")
    String status;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private FamilyGroup group;

    @OneToMany(mappedBy = "shoppingList")
    private Set<ShoppingListItem> shoppinglistitems = new LinkedHashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;

}
