package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListCreationRequest {
    String listName;
    Integer createdBy;
    Integer group_id;
    Timestamp startDate;
    Timestamp endDate;
    String status;

    Set<ShoppingListItemRequest> items = new HashSet<>();

}
