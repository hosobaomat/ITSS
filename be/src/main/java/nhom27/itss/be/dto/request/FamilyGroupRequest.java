package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.FamilyGroupMember;
import nhom27.itss.be.entity.ShoppingListItem;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupRequest {
    String groupName;
    Integer createdBy;

    Set<Integer> members = new HashSet<>();

}
