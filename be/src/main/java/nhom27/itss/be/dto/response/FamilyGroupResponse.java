package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.entity.FamilyGroupMember;
import nhom27.itss.be.entity.ShoppingListItem;
import nhom27.itss.be.entity.User;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupResponse {
    Integer id;
    String groupName;
    String createdBy;
    Timestamp createdAt;

    Set<UserResponse> members = new HashSet<>();

}
