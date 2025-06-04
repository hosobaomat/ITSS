package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListResponse {
    Integer id;
    String groupName;
    String listName;
    String createdBy;
    Timestamp createdAt;
    Timestamp startDate;
    Timestamp endDate;
    String status;

    Set<ShoppingListItemResponse> Items = new HashSet<>();

}
