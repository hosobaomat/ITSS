//package nhom27.itss.be.controller;
//
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import nhom27.itss.be.dto.request.FoodItemRequest;
//import nhom27.itss.be.dto.response.ApiResponse;
//import nhom27.itss.be.dto.response.FoodItemResponse;
//import nhom27.itss.be.service.FoodItemService;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/fooditems")
//@RequiredArgsConstructor
//public class FoodItemController {
//
//    private final FoodItemService foodItemService;
//
//    @PostMapping
//    public ResponseEntity<ApiResponse<FoodItemResponse>> addFoodItem(@Valid @RequestBody FoodItemRequest request) {
//        FoodItemResponse response = foodItemService.addFoodItem(request);
//        return ResponseEntity.status(HttpStatus.CREATED)
//                .body(ApiResponse.<FoodItemResponse>builder()
//                        .code(HttpStatus.CREATED.value())
//                        .message("Food item added successfully.")
//                        .result(response)
//                        .code(200)
//                        .build());
//    }
//
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
//}