package nhom27.itss.be.entity.embeddedID;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.data.relational.core.sql.In;

import java.io.Serializable;
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupMemberId implements Serializable {

    @Column(name = "group_id" )
    Integer groupId;

    @Column(name = "user_id")
    Integer memberId;
}
