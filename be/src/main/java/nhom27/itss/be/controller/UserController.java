package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.service.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/users")
public class UserController {
    UserService userService;

    @PostMapping("")
    ApiResponse<UserResponse> createUser(@RequestBody /*@Valid */ UserCreationRequest request) {
        ApiResponse<UserResponse> response = new ApiResponse<>();
        //log.info("In method createUser,controller");
        response.setResult(userService.createUser(request));

        return response;
    }
}
