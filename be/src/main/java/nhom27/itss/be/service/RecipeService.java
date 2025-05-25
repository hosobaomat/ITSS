package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddShopingListItemRequest;
import nhom27.itss.be.dto.request.EditShoppingListRequest;
import nhom27.itss.be.dto.request.RecipeCreationRequest;
import nhom27.itss.be.dto.request.ShoppingListCreationRequest;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.enums.ShoppingListItemStatus;
import nhom27.itss.be.enums.ShoppingListStatus;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class RecipeService {

    ShoppingListsRepository shoppingListsRepository;
    UsersRepository usersRepository;
    FamilyGroupsRepository familyGroupsRepository;
    FoodcatalogsRepository foodcatalogsRepository;
    UnitsRepository unitsRepository;
    ShoppingListItemsRepository shoppingListItemsRepository;
    FoodItemsRepository foodItemsRepository;
    FoodCategoriesRepository foodCategoriesRepository;


    public ShoppingListResponse createRecipe(RecipeCreationRequest request) {
        Recipe recipe = new Recipe();

        recipe.setRecipeName(request.getRecipeName());
        recipe.setDescription(request.getDescription());
        recipe.setInstructions(request.getInstructions());
        recipe.setCookTime(request.getCookTime());
        recipe.setPrepTime(request.getPrepTime());
        recipe.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        User createdBy = usersRepository.findById(request.getCreatedBy()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS));

        recipe.setCreatedBy(createdBy);



        shoppingListsRepository.save(recipe);

        return ;
    }

    //ERROR Cant delete old item
//    @Transactional
//    public ShoppingListResponse editShoppinglist(EditShoppingListRequest request) {
//        ShoppingList shoppingList = shoppingListsRepository.findById(request.getShoppingListId()).orElseThrow(() -> new AppException(ErrorCode.SHOPPINGLIST_NOT_EXISTS));
//
//        if (!request.getShoppingListName().isEmpty()) {
//            shoppingList.setListName(request.getShoppingListName());
//        }
//        if (request.getStartDate() != null) {
//            shoppingList.setStartDate(request.getStartDate());
//        }
//
//        if(!request.getShoppingListItemRequests().isEmpty() && request.getShoppingListName() != null ){
//            shoppingListItemsRepository.deleteAllByShoppingList(shoppingList);
//
//
//            Set<ShoppingListItem> ListItems = request.getShoppingListItemRequests().stream().map(
//                    item -> ShoppingListItem.builder()
//                            .food(foodcatalogsRepository.findById(item.getFoodCatalogId()).orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS)))
//                            .purchasedBy(shoppingList.getCreatedBy())
//                            .shoppingList(shoppingList)
//                            .foodName(item.getName())
//                            .status(ShoppingListItemStatus.PENDING)
//                            .quantity(item.getQuantity())
//                            .unit(unitsRepository.findById(item.getUnitId()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS)))
//                            .build()).collect(Collectors.toSet());
//
//            shoppingList.setShoppinglistitems(ListItems);
//            shoppingListItemsRepository.saveAll(ListItems);
//        }
//        shoppingListsRepository.save(shoppingList);
//
//        return ShoppinglistToResponse(shoppingList);
//    }
//
//    public void deleteShoppingList(Integer id) {
//        shoppingListsRepository.deleteById(id);
//    }
//
//    public AddFoodItemToFrigdeResponse finishedShoppingList(Integer id) {
//        ShoppingList shoppingList = shoppingListsRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.SHOPPINGLIST_NOT_EXISTS));
//
//        shoppingList.setStatus(ShoppingListStatus.DONE);
//        shoppingList.setEndDate(new Timestamp(System.currentTimeMillis()));
//
//        List<FoodItem> ItemToFrigde = shoppingList.getShoppinglistitems().stream().filter(item -> item.getStatus().equals(ShoppingListItemStatus.PURCHASED)).map(
//                Item -> FoodItem.builder()
//                        .addedAt(new Timestamp(System.currentTimeMillis()))
//                        .group(shoppingList.getGroup())
//                        .foodName(Item.getFoodName())
//                        .quantity(Item.getQuantity())
//                        .unit(Item.getUnit())
//                        .foodCatalog(Item.getFood())
//                        .build()
//        ).toList();
//
//        foodItemsRepository.saveAll(ItemToFrigde);
//
//
//        return AddFoodItemToFrigdeResponse.builder()
//                .addedBy(shoppingList.getCreatedBy().getUsername())
//                .groupId(shoppingList.getGroup().getGroup_id())
//                .foodItemResponses(ItemToFrigde.stream().map(this::ToFoodItemResponse).collect(Collectors.toSet()))
//                .build();
//
//    }
//
//    public ShoppingListResponse getShoppingList(Integer id) {
//        ShoppingList shoppingList = shoppingListsRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.SHOPPINGLIST_NOT_EXISTS));
//
//        return ShoppinglistToResponse(shoppingList);
//    }
//
//    public List<ShoppingListResponse> getAllShoppingLists() {
//        List<ShoppingList> shoppingLists = shoppingListsRepository.findAll();
//
//        return shoppingLists.stream().map(this::ShoppinglistToResponse).toList();
//    }
//
//    public List<ShoppingListResponse> getShoppingListByUserId(Integer userId) {
//        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
//        List<ShoppingList> lists = shoppingListsRepository.findBycreatedBy(user);
//
//        return lists.stream().map(this::ShoppinglistToResponse).toList();
//
//    }
//
//    public List<ShoppingListResponse> getShoppingListByGroupId(Integer groupId) {
//        FamilyGroup group = familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED));
//
//        List<ShoppingList> lists = shoppingListsRepository.findBygroup(group);
//
//        return lists.stream().map(this::ShoppinglistToResponse).toList();
//
//    }
//
//    public ShoppingListResponse addFoodItems(AddShopingListItemRequest request) {
//        ShoppingList shoppingList = shoppingListsRepository.findById(request.getListId()).orElseThrow(() -> new AppException(ErrorCode.SHOPPINGLIST_NOT_EXISTS));
//
//
//        Set<ShoppingListItem> ListItems = request.getShoppingListItemRequests().stream().map(
//                item -> ShoppingListItem.builder()
//                        .food(foodcatalogsRepository.findById(item.getFoodCatalogId()).orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS)))
//                        .foodName(item.getName())
//                        .shoppingList(shoppingList)
//                        .status(ShoppingListItemStatus.PENDING)
//                        .quantity(item.getQuantity())
//                        .unit(unitsRepository.findById(item.getUnitId()).orElseThrow(() -> new AppException(ErrorCode.UNIT_NOT_EXISTS)))
//                        .build()).collect(Collectors.toSet());
//
//        shoppingList.setShoppinglistitems(ListItems);
//        shoppingList.setStatus(ShoppingListStatus.PENDING);
//
//        shoppingListsRepository.save(shoppingList);
//
//        return ShoppinglistToResponse(shoppingList);
//    }
//
//    public List<FoodCategoryResponse> getFoodFilterByCategory() {
//        List<FoodCategory> CategoryList =foodCategoriesRepository.findAll();
//
//
//        return CategoryList.stream().map(
//                item -> FoodCategoryResponse.builder()
//                        .CategoryId(item.getCategoryId())
//                        .CategoryDescription(item.getDescription())
//                        .CategoryName(item.getCategoryName())
//                        .foodCatalogResponses(item.getFoodcatalogs().stream().map(
//                                this::ToFoodCatalogResponse
//                        ).collect(Collectors.toSet()))
//                        .unitResponses(item.getUnits().stream().map(
//                                unit -> UnitResponse.builder()
//                                        .unidId(unit.getId())
//                                        .unitName(unit.getUnitName())
//                                        .unitDescription(unit.getDescription())
//                                        .build()
//                        ).collect(Collectors.toSet()))
//                        .build()
//        ).toList();
//
//
//    }
//
//    public ShoppingListItemResponse purchasedItem(Integer id) {
//        ShoppingListItem item = shoppingListItemsRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.SHOPPINGLIST_NOT_EXISTS));
//        item.setStatus(ShoppingListItemStatus.PURCHASED);
//        item.setPurchasedAt(new Timestamp(System.currentTimeMillis()));
//        shoppingListItemsRepository.save(item);
//
//
//        return ToItemResponse(item);
//
//
//    }
//
//    Ham Mapping
//    private RecipeResponse RecipeToResponse(Recipe recipe) {
//        RecipeResponse recipeResponse = new RecipeResponse();
//        recipeResponse.set;
//        recipeResponse.setListName(shoppingList.getListName());
//        recipeResponse.setStartDate(shoppingList.getStartDate());
//        recipeResponse.setEndDate(shoppingList.getEndDate());
//        recipeResponse.setStatus(String.valueOf(shoppingList.getStatus()));
//        recipeResponse.setCreatedBy(shoppingList.getCreatedBy().getUsername());
//        recipeResponse.setCreatedAt(shoppingList.getCreatedAt());
//        recipeResponse.setGroupName(shoppingList.getGroup().getGroupName());
//        recipeResponse.setItems(shoppingList.getShoppinglistitems().stream().map(this::ToItemResponse).collect(Collectors.toSet()));
//
//        return recipeResponse;
//    }
//
//    private ShoppingListItemResponse ToItemResponse(ShoppingListItem item) {
//        ShoppingListItemResponse shoppingListItemResponse = new ShoppingListItemResponse();
//        shoppingListItemResponse.setId(item.getListItemId());
//        shoppingListItemResponse.setName(item.getFoodName());
//        shoppingListItemResponse.setQuantity(item.getQuantity());
//        shoppingListItemResponse.setStatus(item.getStatus().toString());
//        shoppingListItemResponse.setUnitName(item.getUnit().getUnitName());
//
//        return shoppingListItemResponse;
//    }
//
//    public FoodItemResponse ToFoodItemResponse(FoodItem item){
//        FoodItemResponse foodItemResponse = new FoodItemResponse();
//        foodItemResponse.setId(item.getFoodId());
//        foodItemResponse.setQuantity(item.getQuantity());
//        foodItemResponse.setUnitName(item.getUnit().getUnitName());
//        foodItemResponse.setExpiryDate(item.getExpiryDate());
//        foodItemResponse.setAddedAt(item.getAddedAt());
//        foodItemResponse.setStorageLocation(item.getStorageLocation());
//        return foodItemResponse;
//
//    }
//
//    public FoodCatalogResponse ToFoodCatalogResponse(FoodCatalog foodCatalog){
//        FoodCatalogResponse foodCatalogResponse = new FoodCatalogResponse();
//        foodCatalogResponse.setFoodCatalogId(foodCatalog.getFoodCatalogId());
//        foodCatalogResponse.setFoodCatalogDescription(foodCatalog.getDescription());
//        foodCatalogResponse.setFoodCatalogName(foodCatalog.getFoodName());
//        return foodCatalogResponse;
//    }

}


