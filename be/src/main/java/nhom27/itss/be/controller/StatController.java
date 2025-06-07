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

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/stats")
public class StatController {
    StatService statService;
    //ForAdmin
    @GetMapping("/usedItem/{groupdId}")
    ApiResponse<List<FoodUsedResponse>> getUsedFood(@PathVariable Integer groupdId) {
        ApiResponse<List<FoodUsedResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(statService.getFoodUsed(groupdId));
        return response;
    }

    @GetMapping("/wastedItem/{groupdId}")
    ApiResponse<List<FoodUsedResponse>> getWastedFood(@PathVariable Integer groupdId) {
        ApiResponse<List<FoodUsedResponse>> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(statService.getFoodWasted(groupdId));
        return response;
    }

//    @GetMapping("/user/{userId}")
//    ApiResponse<List<RecipeResponse>> getShoppingListByUserId( @PathVariable Integer userId) {
//        ApiResponse<List<RecipeResponse>> response = new ApiResponse<>();
//        //log.info("In method createUser,controller");
//        response.setResult(recipeService.getRecipesByUserId(userId));
//        return response;
//    }







}
