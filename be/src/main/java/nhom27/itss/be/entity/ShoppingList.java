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
@Table(name = "shoppinglists")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingList {
    @Id
    @Column(name = "list_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer listId;

    @Column(name = "group_id")
    Integer groupId;

    @Column(name = "list_name", nullable = false)
    String listName;

    @Column(name = "created_by")
    Integer createdBy;

    @Column(name = "created_at")
    Timestamp createdAt;

    @Column(name = "start_date")
    Timestamp startDate;

    @Column(name = "end_date")
    Timestamp endDate;

    @Column(name = "Status")
    String status;
}
