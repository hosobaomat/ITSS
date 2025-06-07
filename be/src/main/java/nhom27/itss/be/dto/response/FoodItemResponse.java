
package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodItemResponse {
    Integer id;
    String foodname;
    Integer quantity;
    String unitName;
    String storageLocation;
    Timestamp expiryDate;
    Timestamp addedAt;
    String storageSuggestion;
    Timestamp updatedAt;


}

