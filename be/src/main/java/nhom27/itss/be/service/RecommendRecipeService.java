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
        List<FoodItem> itemsInFridge = foodItemsRepository.findValidFoodItemsByGroupId(groupId);

        // Tạo map key = foodCatalogId-unitId
        Map<String, FoodItem> fridgeMap = itemsInFridge.stream().collect(Collectors.toMap(
                item -> item.getFoodCatalog().getFoodCatalogId() + "-" + item.getUnit().getId(),
                item -> item,
                (item1, item2) -> item1
        ));

        List<Recipe> recipes = recipesRepository.findAllWithIngredients(); // custom query with fetch join
        List<Recipe> recipeMatches = new ArrayList<>();

        for (Recipe recipe : recipes) {
            Set<RecipeIngredient> ingredients = recipe.getRecipeingredients();

            double totalRequired = 0.0;
            double quantityMatched = 0.0;

            for (RecipeIngredient ingredient : ingredients) {
                double requiredQty = ingredient.getQuantity();
                totalRequired += requiredQty;

                String key = ingredient.getFoodCatalog().getFoodCatalogId() + "-" + ingredient.getUnit().getId();
                FoodItem item = fridgeMap.get(key);

                if (item != null) {
                    double availableQty = item.getQuantity();
                    // Nếu đủ, cộng toàn bộ, nếu thiếu, cộng phần có
                    quantityMatched += Math.min(availableQty, requiredQty);
                }
            }

            double matchRatio = totalRequired == 0 ? 0 : quantityMatched / totalRequired;

            // Đủ từ 70% trở lên tổng quantity → chấp nhận
            if (matchRatio >= 0.7) {
                recipeMatches.add(recipe);
            }
        }

        return recipeMatches.stream()
                .map(RecipeMapper::toRecipeResponse)
                .toList();
    }











}


