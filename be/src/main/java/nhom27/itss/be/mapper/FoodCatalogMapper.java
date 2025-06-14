package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.FoodCatalogResponse;
import nhom27.itss.be.entity.FoodCatalog;
import org.springframework.stereotype.Component;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class FoodCatalogMapper {

    public static FoodCatalogResponse toFoodCatalogResponse(FoodCatalog foodCatalog) {
        if (foodCatalog == null) {
            return null;
        }
        return getFoodCatalogResponse(foodCatalog);
    }

    public static FoodCatalogResponse getFoodCatalogResponse(FoodCatalog foodCatalog){
        FoodCatalogResponse foodCatalogResponse = new FoodCatalogResponse();
        foodCatalogResponse.setFoodCatalogId(foodCatalog.getFoodCatalogId());
        foodCatalogResponse.setFoodCatalogDescription(foodCatalog.getDescription());
        foodCatalogResponse.setFoodCatalogName(foodCatalog.getFoodName());
        return foodCatalogResponse;
    }
}
