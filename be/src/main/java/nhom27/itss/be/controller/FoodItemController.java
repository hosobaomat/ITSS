package nhom27.itss.be.controller;

import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddFoodItemRequest;
import nhom27.itss.be.dto.request.UpdateFoodItemRequest;
import nhom27.itss.be.dto.response.AddFoodItemToFrigdeResponse;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.FamilyFoodItemResponse;
import nhom27.itss.be.dto.response.FoodItemResponse;
import nhom27.itss.be.service.FoodItemService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/FoodItems")
@RequiredArgsConstructor
public class FoodItemController {

    FoodItemService foodItemService;

    @PostMapping("")
    public ApiResponse<AddFoodItemToFrigdeResponse> addFoodItem(@Valid @RequestBody AddFoodItemRequest request) {
        return ApiResponse.<AddFoodItemToFrigdeResponse>builder()
                .result(foodItemService.addFoodItem(request))
                .code(200).build();
    }

    @PatchMapping("")
    public ApiResponse<FoodItemResponse> updateFoodItem(@Valid @RequestBody UpdateFoodItemRequest request) {
        return ApiResponse.<FoodItemResponse>builder()
                .result(foodItemService.updateFoodItem(request))
                .code(200).build();
    }


    @DeleteMapping("")
    public ApiResponse<String> deleteFoodItem(@Valid @RequestBody AddFoodItemRequest request) {
        return ApiResponse.<String>builder()
                .result("FoodItem has been deleted")
                .code(200).build();
    }

    @GetMapping("/group/{groupId}")
    public ApiResponse<List<FamilyFoodItemResponse>> getFoodItem(@PathVariable Integer groupId) {
        return ApiResponse.<List<FamilyFoodItemResponse>>builder()
                .result(foodItemService.getFoodItems(groupId))
                .code(200).build();

    }

//    @GetMapping("/search")
//    public ResponseEntity<ApiResponse<List<FoodItemResponse>>> searchFoodItems(
//            @RequestParam(required = false) String name,
//            @RequestParam(required = false) Integer categoryId) {
//        List<FoodItemResponse> results = foodItemService.searchFoodItems(name, categoryId);
//        return ResponseEntity.ok(
//                ApiResponse.<List<FoodItemResponse>>builder()
//                        .code(HttpStatus.OK.value())
//                        .result(results)
//                        .code(200)
//                        .build());
//    }
}