package nhom27.itss.be.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "FamilyGroupMembers")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "FamilyGroupMembers")
public class FamilyGroupMembers implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.Column(name = "group_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "group_id", nullable = false)
    private Integer groupId;

    @jakarta.persistence.Column(name = "user_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "user_id", nullable = false)
    private Integer userId;

    @jakarta.persistence.Column(name = "joined_at")
    @Column(name = "joined_at")
    private Date joinedAt;

}
