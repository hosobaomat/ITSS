package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealDetailResponse;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.MealPlanDetail;
import nhom27.itss.be.entity.User;
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
public class StatService {

    MealPlansRepository mealPlansRepository;
    MealPlanDetailsRepository mealPlanDetailsRepository;
    UsersRepository usersRepository;
    FamilyGroupsRepository familyGroupsRepository;
    RecipesRepository recipesRepository;
    RecipeIngredientsRepository recipeIngredientsRepository;
    private final FoodItemsRepository foodItemsRepository;
    private final FoodCatalogRepository foodCatalogRepository;
    private final UnitsRepository unitsRepository;

    

}
