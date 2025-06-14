package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class ShoppingListMapper {

    public static ShoppingListResponse toShoppingListResponse(ShoppingList shoppingList) {
        if (shoppingList == null) {
            return null;
        }
        return getShoppingListResponse(shoppingList);
    }

    private static ShoppingListResponse getShoppingListResponse(ShoppingList shoppingList) {
        ShoppingListResponse shoppingListResponse = new ShoppingListResponse();
        shoppingListResponse.setId(shoppingList.getListId());
        shoppingListResponse.setListName(shoppingList.getListName());
        shoppingListResponse.setStartDate(shoppingList.getStartDate());
        shoppingListResponse.setEndDate(shoppingList.getEndDate());
        shoppingListResponse.setStatus(String.valueOf(shoppingList.getStatus()));
        shoppingListResponse.setCreatedBy(shoppingList.getCreatedBy().getUsername());
        shoppingListResponse.setCreatedAt(shoppingList.getCreatedAt());
        shoppingListResponse.setGroupName(shoppingList.getGroup().getGroupName());
        shoppingListResponse.setItems(shoppingList.getShoppinglistitems().stream().map(ShoppingListMapper::toShoppingListItemResponse).collect(Collectors.toSet()));

        return shoppingListResponse;
    }

    public static ShoppingListItemResponse toShoppingListItemResponse(ShoppingListItem item) {
        if (item == null) {
            return null;
        }
        return getShoppingListItemResponse(item);
    }

    public static ShoppingListItemResponse getShoppingListItemResponse(ShoppingListItem item) {
        ShoppingListItemResponse shoppingListItemResponse = new ShoppingListItemResponse();
        shoppingListItemResponse.setId(item.getListItemId());
        shoppingListItemResponse.setName(item.getFoodName());
        shoppingListItemResponse.setQuantity(item.getQuantity());
        shoppingListItemResponse.setStatus(item.getStatus().toString());
        shoppingListItemResponse.setUnitName(item.getUnit().getUnitName());

        return shoppingListItemResponse;
    }
}
