package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "ShoppingLists")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "ShoppingLists")
public class ShoppingLists implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "list_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "list_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer listId;

    @jakarta.persistence.Column(name = "group_id")
    @Column(name = "group_id")
    private Integer groupId;

    @jakarta.persistence.Column(name = "list_name", nullable = false)
    @Column(name = "list_name", nullable = false)
    private String listName;

    @jakarta.persistence.Column(name = "created_by")
    @Column(name = "created_by")
    private Integer createdBy;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

    @jakarta.persistence.Column(name = "start_date")
    @Column(name = "start_date")
    private Date startDate;

    @jakarta.persistence.Column(name = "end_date")
    @Column(name = "end_date")
    private Date endDate;

    @jakarta.persistence.Column(name = "Status")
    @Column(name = "Status")
    private String status;

}
