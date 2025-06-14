package nhom27.itss.be.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodItemRequest {
    Integer foodCatalogId;
    String foodName;
    Integer quantity;
    Integer unitId;
    Timestamp expiryDate;
    String storageLocation;
}