package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealDetailResponse;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.*;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;



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
    private final FoodItemsRepository foodItemsRepository;
    private final FoodCatalogRepository foodCatalogRepository;
    private final UnitsRepository unitsRepository;

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
        return mapPlanToResponse(plan);
    }

    public MealPlanResponse getMealPlanById(Integer id) {
        MealPlan plan = mealPlansRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.MEALPLAN_NOT_FOUND));
        return mapPlanToResponse(plan);
    }
    public List<MealPlanResponse> getMealPlansByGroupId(Integer groupId) {
        FamilyGroup group  = familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED));
        List<MealPlan> plans = mealPlansRepository.findByGroup(group);
        return plans.stream()
                .map(this::mapPlanToResponse)
                .toList();
    }

    public List<MealPlanResponse> getMealPlansByUserId(Integer userId) {
        User user = usersRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
        List<MealPlan> plans = mealPlansRepository.findByCreatedBy(user);
        return plans.stream()
                .map(this::mapPlanToResponse)
                .toList();
    }

    public void deleteMealPlan(Integer id) {

        mealPlansRepository.deleteById(id);
    }



    public MealPlanResponse mapPlanToResponse(MealPlan plan) {
        return MealPlanResponse.builder()
                .planId(plan.getPlanId())
                .groupId(plan.getGroup().getGroup_id())
                .planName(plan.getPlanName())
                .startDate(plan.getStartDate())
                .endDate(plan.getEndDate())
                .createdAt(plan.getCreatedAt())
                .createdBy(plan.getCreatedBy().getUserId())
                .details(plan.getMealplandetails().stream().map(this::mapMealDetailToResponse).collect(Collectors.toList()))
                .build();
    }

    public MealDetailResponse mapMealDetailToResponse(MealPlanDetail detail) {
        MealDetailResponse detailResponse = new MealDetailResponse();
        detailResponse.setPlanDetailId(detail.getPlanDetailId());
        detailResponse.setMealDate(detail.getMealDate());
        detailResponse.setRecipeName(detail.getRecipe().getRecipeName());
        detailResponse.setMealType(detail.getMealType());
        detailResponse.setRecipeId(detail.getRecipe().getRecipeId());
        return  detailResponse;
    }

}
