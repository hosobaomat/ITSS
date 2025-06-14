package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.response.*;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.util.*;
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
    FoodItemsRepository foodItemsRepository;
    FoodCatalogRepository foodCatalogRepository;
    UnitsRepository unitsRepository;
    ShoppingListItemsRepository shoppingListItemsRepository;
    ShoppingListsRepository shoppingListsRepository;
    FoodHistoryRepository foodHistoryRepository;

    public List<FoodUsedResponse> getFoodUsed(Integer groupId){
        Optional<List<FoodHistory>> foodUsed = foodHistoryRepository.findByGroup_GroupIdAndAction(groupId,"used");
        List<FoodHistory> foodUsedList = foodUsed.orElse(new ArrayList<>());

        return foodUsedList.stream().map(
                this::toFoodUsedResponse
        ).toList();

    }


    public Map<String,Double> AnalyzeFoodUsedByCategory(Integer groupId){
        Optional<List<FoodHistory>> foodUsed = foodHistoryRepository.findByGroup_GroupIdAndAction(groupId,"used");
        List<FoodHistory> foodUsedList = foodUsed.orElse(new ArrayList<>());

        Map<String, Long> foodTypeCount = foodUsedList.stream()
                .collect(Collectors.groupingBy(
                        foodHistory -> String.valueOf(foodHistory.getFood().getFoodCatalog().getFoodCategory().getCategoryName()),
                        Collectors.counting()
                ));

        int total = foodUsedList.size();
        Map<String, Double> foodTypePercentage = new HashMap<>();


        for (Map.Entry<String, Long> entry : foodTypeCount.entrySet()) {
            double percentage = (entry.getValue() * 100.0) / total;
            foodTypePercentage.put(entry.getKey(), percentage);
        }

        return foodTypePercentage;

    }

    public List<FoodUsedResponse> getFoodWasted(Integer groupId){
        Optional<List<FoodHistory>> foodWasted = foodHistoryRepository.findByGroup_GroupIdAndAction(groupId,"wasted");
        List<FoodHistory> foodUsedList = foodWasted.orElse(new ArrayList<>());

        return foodUsedList.stream().map(
                this::toFoodUsedResponse
        ).toList();
    }




    private FoodUsedResponse toFoodUsedResponse(FoodHistory foodUsed){
        FoodUsedResponse foodUsedResponse = new FoodUsedResponse();
        foodUsedResponse.setId(foodUsed.getId());
        foodUsedResponse.setFoodname(foodUsed.getFood().getFoodName());
        foodUsedResponse.setFoodId(foodUsed.getFood().getFoodId());
        foodUsedResponse.setQuantity(foodUsed.getQuantity());
        foodUsedResponse.setActionDate(foodUsed.getActionDate());
        foodUsedResponse.setUnitName(foodUsed.getUnit().getUnitName());
        foodUsedResponse.setUnitId(foodUsed.getUnit().getId());
        return foodUsedResponse;

    }



}
