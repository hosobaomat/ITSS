package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.MissingIngredientRequest;
import nhom27.itss.be.dto.request.RecipeCreationRequest;
import nhom27.itss.be.dto.request.RecipeEditRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.FoodUsedResponse;
import nhom27.itss.be.dto.response.RecipeIngredientResponse;
import nhom27.itss.be.dto.response.RecipeResponse;
import nhom27.itss.be.service.RecipeService;
import nhom27.itss.be.service.StatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/stats")
public class StatController {
    StatService statService;
    //ForAdmin
    @GetMapping("/usedItem/{groupId}")
    ApiResponse<List<FoodUsedResponse>> getUsedFood(@PathVariable Integer groupId) {
        ApiResponse<List<FoodUsedResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(statService.getFoodUsed(groupId));
        return response;
    }

    @GetMapping("/wastedItem/{groupId}")
    ApiResponse<List<FoodUsedResponse>> getWastedFood(@PathVariable Integer groupId) {
        ApiResponse<List<FoodUsedResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(statService.getFoodWasted(groupId));
        return response;
    }

    @GetMapping("/AnalyzedFoodUsed/{groupId}")
    ApiResponse<Map<String,Double>> getAnalyzedFoodUsed( @PathVariable Integer groupId) {
        ApiResponse<Map<String,Double>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(statService.AnalyzeFoodUsedByCategory(groupId));
        return response;
    }







}
