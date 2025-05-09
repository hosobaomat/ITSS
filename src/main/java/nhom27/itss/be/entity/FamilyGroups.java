package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "FamilyGroups")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "FamilyGroups")
public class FamilyGroups implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "group_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "group_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer groupId;

    @jakarta.persistence.Column(name = "group_name", nullable = false)
    @Column(name = "group_name", nullable = false)
    private String groupName;

    @jakarta.persistence.Column(name = "created_by")
    @Column(name = "created_by")
    private Integer createdBy;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

}
