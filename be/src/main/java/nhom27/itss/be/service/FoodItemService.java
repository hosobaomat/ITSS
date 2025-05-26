package nhom27.itss.be.service;

import lombok.RequiredArgsConstructor;
import nhom27.itss.be.dto.request.FoodItemRequest;
import nhom27.itss.be.dto.response.FoodItemResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.exception.ResourceNotFoundException;
import nhom27.itss.be.repository.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FoodItemService {

    private final FoodItemsRepository foodItemRepository;
    private final FoodCatalogRepository foodCatalogRepository;
    private final UsersRepository userRepository;
    private final FamilyGroupMembersRepository familyGroupMemberRepository;

    // --- HÀM HỖ TRỢ ---
    private User getCurrentUser() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
    }

    private FamilyGroup getCurrentUserGroup() {
        User currentUser = getCurrentUser();
        FamilyGroupMember member = familyGroupMemberRepository.findTopById_MemberIdOrderByJoinedAtDesc(currentUser.getUserId())
                .orElseThrow(() -> new ResourceNotFoundException("User is not in any group"));
        return member.getGroup();
    }

    private FoodItemResponse mapToFoodItemResponse(FoodItem foodItem) {
        return FoodItemResponse.builder()
                .foodId(foodItem.getFoodId())
                .groupId(foodItem.getGroup().getGroup_id())
                .foodName(foodItem.getFoodName())
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
    public FoodItemResponse addFoodItem(FoodItemRequest request) {
        FamilyGroup currentGroup = getCurrentUserGroup();
        FoodCatalog foodCatalog = foodCatalogRepository.findById(request.getFoodCatalogId())
                .orElseThrow(() -> new ResourceNotFoundException("Food Catalog not found with ID: " + request.getFoodCatalogId()));

        FoodItem newFoodItem = new FoodItem();
        newFoodItem.setGroup(currentGroup);
        newFoodItem.setFoodCatalog(foodCatalog);
        newFoodItem.setFoodName(foodCatalog.getFoodName());
        newFoodItem.setUnit(foodCatalog.getUnit());
        newFoodItem.setQuantity(request.getQuantity());
        newFoodItem.setExpiryDate(request.getExpiryDate());
        newFoodItem.setStorageLocation(request.getStorageLocation());
        newFoodItem.setAddedAt(Timestamp.from(Instant.now()));
        newFoodItem.setUpdatedAt(Timestamp.from(Instant.now()));


        FoodItem savedItem = foodItemRepository.save(newFoodItem);
        return mapToFoodItemResponse(savedItem);
    }

    public List<FoodItemResponse> searchFoodItems(String name, Integer categoryId) {
        Integer groupId = getCurrentUserGroup().getGroup_id();
        List<FoodItem> foodItems;

        boolean hasName = name != null && !name.trim().isEmpty();
        boolean hasCategory = categoryId != null;

        if (hasName && hasCategory) {
            foodItems = foodItemRepository.findByGroup_IdAndFoodNameContainingIgnoreCaseAndFoodCatalog_Category_Id(groupId, name, categoryId);
        } else if (hasName) {
            foodItems = foodItemRepository.findByGroup_IdAndFoodNameContainingIgnoreCase(groupId, name);
        } else if (hasCategory) {
            foodItems = foodItemRepository.findByGroup_IdAndFoodCatalog_Category_Id(groupId, categoryId);
        } else {
            foodItems = foodItemRepository.findByGroup_Id(groupId);
        }

        return foodItems.stream()
                .map(this::mapToFoodItemResponse)
                .collect(Collectors.toList());
    }
}