package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AddShopingListItemRequest {
    Integer listId;
    Set<ShoppingListItemRequest> shoppingListItemRequests = new HashSet<>();

}
