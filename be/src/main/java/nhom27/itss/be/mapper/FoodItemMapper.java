package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.FoodItemResponse;
import nhom27.itss.be.entity.FoodItem;
import org.springframework.stereotype.Component;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class FoodItemMapper {

    public static FoodItemResponse toFoodItemResponse(FoodItem foodItem) {
        if (foodItem == null) {
            return null;
        }
        return getFoodItemResponse(foodItem);
    }

    public static FoodItemResponse getFoodItemResponse(FoodItem foodItem) {
        return FoodItemResponse.builder()
                .id(foodItem.getFoodId())
                .foodname(foodItem.getFoodName())
                .quantity(foodItem.getQuantity())
                .unitName(foodItem.getUnit().getUnitName())
                .expiryDate(foodItem.getExpiryDate())
                .storageLocation(foodItem.getStorageLocation())
                .storageSuggestion(foodItem.getFoodCatalog().getDescription())
                .addedAt(foodItem.getAddedAt())
                .updatedAt(foodItem.getUpdatedAt())
                .build();
    }
}
