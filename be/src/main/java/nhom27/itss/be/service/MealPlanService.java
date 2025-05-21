package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.MealPlanDetail;
import nhom27.itss.be.entity.Recipe;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.FamilyGroupsRepository;
import nhom27.itss.be.repository.MealPlanDetailsRepository;
import nhom27.itss.be.repository.MealPlansRepository;
import nhom27.itss.be.repository.RecipesRepository;
import nhom27.itss.be.repository.UsersRepository;
import org.springframework.stereotype.Service;
import nhom27.itss.be.exception.ErrorCode;

import java.sql.Timestamp;
import java.util.List;
import java.util.stream.Collectors;


import java.sql.Timestamp;
import java.util.List;
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

    public MealPlanResponse createMealPlan(CreateMealPlanRequest request) {

        FamilyGroup group = familyGroupsRepository.findById(request.getGroupId())
                .orElseThrow(() -> new AppException(ErrorCode.GROUP_NOT_FOUND));


        User createdBy = usersRepository.findById(request.getCreatedBy())
                .orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION));


        MealPlan plan = MealPlan.builder()
                .planName(request.getPlanName())
                .startDate(Timestamp.valueOf(request.getStartDate().atStartOfDay()))
                .endDate(Timestamp.valueOf(request.getEndDate().atStartOfDay()))
                .group(group)
                .createdBy(createdBy)
                .createdAt(new Timestamp(System.currentTimeMillis()))
                .build();

        mealPlansRepository.save(plan);

        // Xử lý danh sách meal details
        List<MealPlanDetail> detailEntities = request.getDetails().stream().map(d -> {
            Recipe recipe = recipesRepository.findById(d.getRecipeId())
                    .orElseThrow(() -> new AppException(ErrorCode.RECIPE_NOT_FOUND));

            return MealPlanDetail.builder()
                    .mealDate(Timestamp.valueOf(d.getMealDate().atStartOfDay()))
                    .mealType(d.getMealType())
                    .mealPlan(plan)
                    .recipe(recipe)
                    .build();
        }).collect(Collectors.toList());

        mealPlanDetailsRepository.saveAll(detailEntities);

        return mapToResponse(plan);
    }

    public MealPlanResponse getMealPlanById(Integer planId) {
        MealPlan plan = mealPlansRepository.findById(planId)
                .orElseThrow(() -> new AppException(ErrorCode.MEALPLAN_NOT_FOUND));

        return mapToResponse(plan);
    }

    private MealPlanResponse mapToResponse(MealPlan plan) {
        return MealPlanResponse.builder()
                .planId(plan.getPlanId())
                .planName(plan.getPlanName())
                .startDate(plan.getStartDate())
                .endDate(plan.getEndDate())
                .createdAt(plan.getCreatedAt())
                .createdBy(plan.getCreatedBy().getUserId())
                .build();
    }
}
