package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.embeddedID.FamilyGroupMemberId;

import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "familygroupmembers")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupMember {


    @EmbeddedId
    FamilyGroupMemberId id;

    @ManyToOne
    @MapsId("memberId")
    @JoinColumn(name="user_id")
    User user;

    @ManyToOne
    @MapsId("groupId")
    @JoinColumn(name = "group_id")
    FamilyGroup group;

    @Column(name = "joined_at")
    Timestamp joinedAt;



}
