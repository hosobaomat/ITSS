package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddFoodItemRequest;
import nhom27.itss.be.dto.request.FoodItemRequest;
import nhom27.itss.be.dto.request.UpdateFoodItemRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.enums.ShoppingListItemStatus;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.exception.ResourceNotFoundException;
import nhom27.itss.be.repository.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FoodItemService {

    FoodItemsRepository foodItemRepository;
    FoodCatalogRepository foodCatalogRepository;
    UsersRepository userRepository;
    FamilyGroupMembersRepository familyGroupMemberRepository;
    FamilyGroupsRepository familyGroupsRepository;
    UnitsRepository unitsRepository;


    private FoodItemResponse mapToFoodItemResponse(FoodItem foodItem) {
        return FoodItemResponse.builder()
                .id(foodItem.getFoodId())
                .foodname(foodItem.getFoodName())
                .categoryName(foodItem.getFoodCatalog().getFoodCategory().getCategoryName())
                .quantity(foodItem.getQuantity())
                .unitName(foodItem.getUnit().getUnitName())
                .expiryDate(foodItem.getExpiryDate())
                .storageLocation(foodItem.getStorageLocation())
                .storageSuggestion(foodItem.getFoodCatalog().getDescription())
                .addedAt(foodItem.getAddedAt())
                .updatedAt(foodItem.getUpdatedAt())
                .build();
    }

    @Transactional
    public AddFoodItemToFrigdeResponse addFoodItem(AddFoodItemRequest request) {
        FamilyGroup currentGroup = familyGroupsRepository.findById(request.getGroupId()).orElseThrow(() -> new ResourceNotFoundException("Group not found"));
        User user =userRepository.findById(request.getUserId()).orElseThrow(() -> new ResourceNotFoundException("User not found"));
        Set<FoodItem> ItemToFrigde = request.getFoodItems().stream().map(
                Item -> FoodItem.builder()
                        .addedAt(new Timestamp(System.currentTimeMillis()))
                        .group(currentGroup)
                        .foodName(Item.getFoodName())
                        .quantity(Item.getQuantity())
                        .unit(unitsRepository.findById(Item.getUnitId()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS)))
                        .foodCatalog(foodCatalogRepository.findById(Item.getFoodCatalogId()).orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS)))
                        .expiryDate(Item.getExpiryDate())
                        .storageLocation(Item.getStorageLocation())
                        .build()
        ).collect(Collectors.toSet());

        foodItemRepository.saveAll(ItemToFrigde);

        return AddFoodItemToFrigdeResponse.builder()
                .foodItemResponses(ItemToFrigde.stream().map(this::mapToFoodItemResponse).collect(Collectors.toSet()))
                .addedBy(user.getUsername())
                .groupId(currentGroup.getGroup_id())
                .groupName(currentGroup.getGroupName())
                .build();
    }

    public List<FamilyFoodItemResponse> getFoodItems(Integer groupId) {
        FamilyGroup currentGroup = familyGroupsRepository.findById(groupId).orElseThrow(() -> new ResourceNotFoundException("Group not found"));
        List<FoodItem> items =foodItemRepository.findValidFoodItemsByGroupId(groupId);


        Map<FoodCategory, List<FoodItem>> groupedItems = items.stream()
                .collect(Collectors.groupingBy(item -> item.getFoodCatalog().getFoodCategory()));

        return groupedItems.entrySet().stream()
                .map(entry -> {
                    FoodCategory category = entry.getKey();
                    List<FoodItemResponse> foodItemResponses = entry.getValue().stream()
                            .map(item -> {
                                return FoodItemResponse.builder()
                                        .id(item.getFoodId())
                                        .foodname(item.getFoodCatalog().getFoodName())
                                        .quantity(item.getQuantity())
                                        .unitName(item.getUnit().getUnitName())
                                        .storageLocation(item.getStorageLocation())
                                        .expiryDate(item.getExpiryDate())
                                        .addedAt(item.getAddedAt())
                                        .updatedAt(item.getUpdatedAt())
                                        .storageSuggestion(item.getFoodCatalog().getDescription())
                                        .build();
                            })
                            .collect(Collectors.toList());

                    return FamilyFoodItemResponse.builder()
                            .CategoryId(category.getCategoryId())
                            .CategoryName(category.getCategoryName())
                            .CategoryDescription(category.getDescription())
                            .foodItemResponses(foodItemResponses)
                            .build();
                })
                .collect(Collectors.toList());
    }


    public FoodItemResponse updateFoodItem(UpdateFoodItemRequest request ) {
           FoodItem item = foodItemRepository.findById(request.getId()).orElseThrow(() -> new ResourceNotFoundException("FoodItem not found"));

           item.setStorageLocation(request.getStorageLocation());
           item.setExpiryDate(request.getExpireDate());

           foodItemRepository.save(item);

           return mapToFoodItemResponse(item);

    }

    public void DeleteFoodItem(Integer id) {
        foodItemRepository.deleteById(id);
    }

    public List<FoodItemResponse> getAllFoodItems(Integer groupId) {

        FamilyGroup currentGroup = familyGroupsRepository.findById(groupId).orElseThrow(() -> new ResourceNotFoundException("Group not found"));
        List<FoodItem> items =foodItemRepository.findValidFoodItemsByGroupId(groupId);

        return items.stream()
                .map(this::mapToFoodItemResponse)
                .collect(Collectors.toList());

    }

    public List<String> getAllStorageLocation() {
        return foodItemRepository.findDistinctStorageLocations();
    }




//    public List<FoodItemResponse> searchFoodItems(String name, Integer categoryId) {
//        Integer groupId = getCurrentUserGroup().getGroup_id();
//        List<FoodItem> foodItems;
//
//        boolean hasName = name != null && !name.trim().isEmpty();
//        boolean hasCategory = categoryId != null;
//
//        if (hasName && hasCategory) {
//            foodItems = foodItemRepository.findByGroup_IdAndFoodNameContainingIgnoreCaseAndFoodCatalog_Category_Id(groupId, name, categoryId);
//        } else if (hasName) {
//            foodItems = foodItemRepository.findByGroup_IdAndFoodNameContainingIgnoreCase(groupId, name);
//        } else if (hasCategory) {
//            foodItems = foodItemRepository.findByGroup_IdAndFoodCatalog_Category_Id(groupId, categoryId);
//        } else {
//            foodItems = foodItemRepository.findByGroup_Id(groupId);
//        }
//
//        return foodItems.stream()
//                .map(this::mapToFoodItemResponse)
//                .collect(Collectors.toList());
//    }

}


