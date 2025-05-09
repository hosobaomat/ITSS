package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serial;
import java.sql.Timestamp;
import java.util.Date;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "FamilyGroupMembers")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupMember {
    //@Serial
    //static final long serialVersionUID = 1L;

    @Id
    @Column(name = "group_id", nullable = false)
    Integer groupId;

    @Id
    @Column(name = "user_id", nullable = false)
    Integer userId;

    @Column(name = "joined_at")
    Timestamp joinedAt;



}
