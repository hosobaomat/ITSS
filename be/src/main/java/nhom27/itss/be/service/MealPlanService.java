package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.mapper.MealPlanMapper;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

import static nhom27.itss.be.mapper.MealPlanMapper.toMealPlanResponse;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MealPlanService {

    MealPlansRepository mealPlansRepository;
    MealPlanDetailsRepository mealPlanDetailsRepository;
    UsersRepository usersRepository;
    FamilyGroupsRepository familyGroupsRepository;
    RecipesRepository recipesRepository;
    RecipeIngredientsRepository recipeIngredientsRepository;
    FoodItemsRepository foodItemsRepository;
    FoodCatalogRepository foodCatalogRepository;
    UnitsRepository unitsRepository;
    FoodHistoryRepository foodHistoryRepository;

    public MealPlanResponse createMealPlan(CreateMealPlanRequest request) {

        FamilyGroup group = familyGroupsRepository.findById(request.getGroupId())
                .orElseThrow(() -> new AppException(ErrorCode.GROUP_NOT_FOUND));


        User createdBy = usersRepository.findById(request.getCreatedBy())
                .orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION));


        MealPlan plan = MealPlan.builder()
                .planName(request.getPlanName())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .group(group)
                .createdBy(createdBy)
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .status(false)
                .build();

        mealPlansRepository.save(plan);

        // Xử lý danh sách meal details
        Set<MealPlanDetail> detailEntities = request.getDetails().stream()
                .map(d -> MealPlanDetail.builder()
                        .mealDate(d.getMealDate())
                        .mealType(d.getMealType())
                        .mealPlan(plan)
                        .recipe(recipesRepository.findById(d.getRecipeId())
                                .orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_FOUND)))
                        .build())
                .collect(Collectors.toSet());


        plan.setMealplandetails(detailEntities);
        mealPlansRepository.save(plan);
        return toMealPlanResponse(plan);
    }

    public MealPlanResponse getMealPlanById(Integer id) {
        MealPlan plan = mealPlansRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.MEALPLAN_NOT_FOUND));
        return toMealPlanResponse(plan);
    }
    public List<MealPlanResponse> getMealPlansByGroupId(Integer groupId) {
        FamilyGroup group  = familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED));
        List<MealPlan> plans = mealPlansRepository.findByGroup(group);
        return plans.stream()
                .map(MealPlanMapper::toMealPlanResponse)
                .toList();
    }

    public List<MealPlanResponse> getMealPlansByUserId(Integer userId) {
        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
        List<MealPlan> plans = mealPlansRepository.findByCreatedBy(user);
        return plans.stream()
                .map(MealPlanMapper::toMealPlanResponse)
                .toList();
    }

    public void deleteMealPlan(Integer id) {

        mealPlansRepository.deleteById(id);
    }

    public MealPlanResponse finishedMealPlan(Integer id) {
        MealPlan plan = mealPlansRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.MEALPLAN_NOT_FOUND));

        plan.setStatus(true);

        // 3. Lấy danh sách MealPlanDetail liên quan
        List<MealPlanDetail> planDetails = mealPlanDetailsRepository.findByMealPlan(plan);
        List<FoodItem> foodItems = foodItemsRepository.findByGroup(plan.getGroup());
        List<RecipeIngredient> usedIngredients = new ArrayList<>();

        for (MealPlanDetail detail : planDetails) {
            Recipe recipe = detail.getRecipe();
            usedIngredients.addAll(recipe.getRecipeingredients());
        }

        for (RecipeIngredient ingredient : usedIngredients) {
            Optional<FoodItem> itemOptional = findSuitableFoodItem(foodItems, ingredient);

            if (itemOptional.isPresent()) {
                FoodItem item = itemOptional.get();
                item.setQuantity(item.getQuantity() - ingredient.getQuantity());
                item.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                foodItemsRepository.save(item);
                foodHistoryRepository.save(
                        FoodHistory.builder()
                                .action("used")
                                .unit(ingredient.getUnit())
                                .actionDate(item.getUpdatedAt().toInstant())
                                .group(plan.getGroup())
                                .quantity(ingredient.getQuantity())
                                .food(item)
                                .build()
                );
            }
        }
        // 5. Trả về kết quả (tuỳ bạn cần gì trong response)
        return toMealPlanResponse(mealPlansRepository.save(plan));
    }


    private Optional<FoodItem> findSuitableFoodItem(List<FoodItem> foodItems, RecipeIngredient ingredient) {
        return foodItems.stream()
                .filter(item ->
                        item.getFoodCatalog().getFoodCatalogId().equals(ingredient.getFoodCatalog().getFoodCatalogId()) &&
                                item.getExpiryDate().after(new Date()) &&
                                item.getQuantity() >= ingredient.getQuantity()
                )
                .findFirst(); // hoặc sorted() nếu bạn muốn lấy item gần hết hạn nhất
    }

}
