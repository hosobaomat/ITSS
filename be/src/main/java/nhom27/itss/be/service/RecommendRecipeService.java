package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.response.RecipeResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.mapper.RecipeMapper;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class RecommendRecipeService {


    UsersRepository usersRepository;
    RecipesRepository recipesRepository;
    UnitsRepository unitsRepository;
    FoodCatalogRepository foodcatalogsRepository;
    FamilyGroupsRepository familyGroupsRepository;
    FoodItemsRepository foodItemsRepository;
    FoodCatalogRepository foodCatalogRepository;
    RecipeIngredientsRepository recipeIngredientsRepository;




    public List<RecipeResponse> recommendRecipes(Integer groupId) {
        // 1. Load toàn bộ FoodItems hợp lệ
        List<FoodItem> itemsInFridge = foodItemsRepository.findValidFoodItemsByGroupId(groupId);

        // 2. Tạo map để tra cứu nhanh (theo FoodCatalogId + UnitId)
        Map<String, FoodItem> fridgeMap = itemsInFridge.stream().collect(Collectors.toMap(
                item -> item.getFoodCatalog().getFoodCatalogId() + "-" + item.getUnit().getId(),
                item -> item,
                (item1, item2) -> item1 // nếu trùng thì giữ lại cái đầu
        ));

        // 3. Load toàn bộ recipes và ingredients (eager fetch để tránh N+1)
        List<Recipe> recipes = recipesRepository.findAllWithIngredients(); // cần viết custom query
        List<Recipe> recipeMatches = new ArrayList<>();

        for (Recipe recipe : recipes) {
            Set<RecipeIngredient> ingredients = recipe.getRecipeingredients();
            long matchedCount = ingredients.stream()
                    .filter(ingredient -> {
                        String key = ingredient.getFoodCatalog().getFoodCatalogId() + "-" + ingredient.getUnit().getId();
                        FoodItem item = fridgeMap.get(key);
                        return item != null && item.getQuantity() >= ingredient.getQuantity();
                    })
                    .count();

            double matchPercentage = (double) matchedCount / ingredients.size();
            if (matchPercentage >= 0.7) {
                recipeMatches.add(recipe);
            }
        }

        return recipeMatches.stream()
                .map(RecipeMapper::toRecipeResponse)
                .toList();
    }










}


