package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddShopingListItemRequest;
import nhom27.itss.be.dto.request.EditShoppingListRequest;
import nhom27.itss.be.dto.request.ShoppingListCreationRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.service.ShoppingListService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/ShoppingList")
public class ShoppingListController {
    ShoppingListService shoppingListService;

    @PostMapping("")
    ApiResponse<ShoppingListResponse> createShoppingList(@RequestBody /*@Valid */ ShoppingListCreationRequest request) {
        ApiResponse<ShoppingListResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.createShoppingList(request));
        return response;
    }
    //ForAdmin
    @GetMapping("")
    ApiResponse<List<ShoppingListResponse>> getAllShoppingList() {
        ApiResponse<List<ShoppingListResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.getAllShoppingLists());
        return response;
    }

    @GetMapping("/user/{userId}")
    ApiResponse<List<ShoppingListResponse>> getShoppingListByUserId( @PathVariable Integer userId) {
        ApiResponse<List<ShoppingListResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.getShoppingListByUserId(userId));
        return response;
    }

    @GetMapping("/group/{groupId}")
    ApiResponse<List<ShoppingListResponse>> getAllShoppingListByGroupId(@PathVariable Integer groupId) {
        ApiResponse<List<ShoppingListResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.getShoppingListByGroupId(groupId));
        return response;
    }

    @GetMapping("/FoodCatalog")
    ApiResponse<List<FoodCategoryResponse>> getFoodCatalogFilterd() {
        ApiResponse<List<FoodCategoryResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.getFoodFilterByCategory());
        return response;
    }

    @PatchMapping("{listId}")
    ApiResponse<ShoppingListResponse> EditShoppingList (@PathVariable Integer listId, @RequestBody EditShoppingListRequest request) {
        ApiResponse<ShoppingListResponse> response = new ApiResponse<>();
        response.setResult(shoppingListService.editShoppinglist(request));
        return response;
    }

    @DeleteMapping("/{listId}")
    ApiResponse<String> deleteShoppingList(@PathVariable Integer listId){
        shoppingListService.deleteShoppingList(listId);
        return ApiResponse.<String>builder()
                .result("Shopping List has been deleted")
                .code(200).build();
    }

    @PostMapping("/addItem")
    ApiResponse<ShoppingListResponse> addItemToList(@RequestBody /*@Valid */ AddShopingListItemRequest request) {
        ApiResponse<ShoppingListResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.addFoodItems(request));
        return response;
    }

    @PatchMapping("purchased/{itemId}")
    ApiResponse<ShoppingListItemResponse> purchasedItem(@PathVariable /*@Valid */ Integer itemId) {
        ApiResponse<ShoppingListItemResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.purchasedItem(itemId));
        return response;
    }

    @PatchMapping("/FinishList/{listId}")
    ApiResponse<AddFoodItemToFrigdeResponse> addItemToList(@PathVariable /*@Valid */Integer listId) {
        ApiResponse<AddFoodItemToFrigdeResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(shoppingListService.finishedShoppingList(listId));
        return response;
    }



}
