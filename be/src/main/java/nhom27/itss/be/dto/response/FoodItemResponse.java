package nhom27.itss.be.dto.response;

import lombok.Builder;
import lombok.Data;
import java.sql.Timestamp;

@Data
@Builder
public class FoodItemResponse {
    private Integer foodId;
    private Integer groupId;
    private String foodName;
    private String categoryName;
    private Integer quantity;
    private String unitName;
    private Timestamp expiryDate;
    private String storageLocation;
    private String storageSuggestion;
    private Timestamp addedAt;
    private Timestamp updatedAt;
}