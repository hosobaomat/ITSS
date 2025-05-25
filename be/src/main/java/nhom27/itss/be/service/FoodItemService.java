package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddShopingListItemRequest;
import nhom27.itss.be.dto.request.EditShoppingListRequest;
import nhom27.itss.be.dto.request.ShoppingListCreationRequest;
import nhom27.itss.be.dto.response.AddFoodItemToFrigdeResponse;
import nhom27.itss.be.dto.response.FoodItemResponse;
import nhom27.itss.be.dto.response.ShoppingListItemResponse;
import nhom27.itss.be.dto.response.ShoppingListResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.enums.ShoppingListItemStatus;
import nhom27.itss.be.enums.ShoppingListStatus;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class FoodItemService {

    ShoppingListsRepository shoppingListsRepository;
    UsersRepository usersRepository;
    FamilyGroupsRepository familyGroupsRepository;
    FoodcatalogsRepository foodcatalogsRepository;
    UnitsRepository unitsRepository;
    ShoppingListItemsRepository shoppingListItemsRepository;
    FoodItemsRepository foodItemsRepository;








}


