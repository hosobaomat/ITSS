package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListItemRequest {
    String name;
    Integer quantity;
    Integer unitId;
    Integer foodCatalogId;
}
