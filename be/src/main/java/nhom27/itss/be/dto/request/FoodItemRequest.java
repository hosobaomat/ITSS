package nhom27.itss.be.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.sql.Timestamp;

@Data
public class FoodItemRequest {
    @NotNull
    private Integer foodCatalogId;

    @NotNull
    @Min(1)
    private Integer quantity;

    private Timestamp expiryDate;
    private String storageLocation;
}