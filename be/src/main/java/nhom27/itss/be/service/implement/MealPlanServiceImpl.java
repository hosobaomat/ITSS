package nhom27.itss.be.service.impl;

import nhom27.itss.be.dto.request.CreateMealPlanRequest;
import nhom27.itss.be.dto.response.MealPlanResponse;
import nhom27.itss.be.entity.MealPlan;
import nhom27.itss.be.entity.MealPlanDetail;
import nhom27.itss.be.repository.MealPlanDetailsRepository;
import nhom27.itss.be.repository.MealPlansRepository;
import nhom27.itss.be.service.MealPlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MealPlanServiceImpl implements MealPlanService {

    @Autowired
    private MealPlansRepository mealPlansRepository;

    @Autowired
    private MealPlanDetailsRepository mealPlanDetailsRepository;

    @Override
    public MealPlanResponse createMealPlan(CreateMealPlanRequest request) {
        MealPlan plan = new MealPlan();
        plan.setPlanName(request.getPlanName());
        plan.setStartDate(Timestamp.valueOf(request.getStartDate().atStartOfDay()));
        plan.setEndDate(Timestamp.valueOf(request.getEndDate().atStartOfDay()));
        plan.setGroupId(request.getGroupId());
        plan.setCreatedBy(request.getCreatedBy());
        plan.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        mealPlansRepository.save(plan);

        List<CreateMealPlanRequest.MealDetailRequest> details = request.getDetails();
        if (details != null && !details.isEmpty()) {
            List<MealPlanDetail> detailEntities = details.stream().map(d -> {
                MealPlanDetail detail = new MealPlanDetail();
                detail.setPlanId(plan.getPlanId());
                detail.setRecipeId(d.getRecipeId());
                detail.setMealType(d.getMealType());
                detail.setMealDate(Timestamp.valueOf(d.getMealDate().atStartOfDay()));
                return detail;
            }).collect(Collectors.toList());

            mealPlanDetailsRepository.saveAll(detailEntities);
        }

        return mapToResponse(plan, details);
    }
    @Override
    public MealPlanResponse getMealPlanById(Integer planId) {
        MealPlan plan = mealPlansRepository.findById(planId)
                .orElseThrow(() -> new RuntimeException("MealPlan not found with id " + planId));

        return mapToResponse(plan, null);
    }

    private MealPlanResponse mapToResponse(MealPlan plan, List<CreateMealPlanRequest.MealDetailRequest> details) {
        MealPlanResponse response = new MealPlanResponse();
        response.setPlanId(plan.getPlanId());
        response.setPlanName(plan.getPlanName());
        response.setStartDate(plan.getStartDate());
        response.setEndDate(plan.getEndDate());
        response.setGroupId(plan.getGroupId());
        response.setCreatedBy(plan.getCreatedBy());
        response.setCreatedAt(plan.getCreatedAt());
        return response;
    }
}
