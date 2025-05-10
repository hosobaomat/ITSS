package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.UpdateUserRequest;
import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.service.UserService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
    /*
    @GetMapping("/myinfo")
    ApiResponse<UserResponse> getMyInfo() {
        return ApiResponse.<UserResponse>builder()
                .result(userService.getMyInfo())
                .build();
    }*/
    /*
    @GetMapping("")
    ApiResponse<List<User>> getAllUsers() {
        var authenticate = SecurityContextHolder.getContext().getAuthentication();

        log.info("Username : {}",authenticate.getName());
        authenticate.getAuthorities().forEach(a -> log.info("Role : {}",a.getAuthority()));


        return ApiResponse.<List<Users>>builder()
                .result(userService.getAllUsers())
                .build();
    }*/

    @GetMapping("/{userId}")
    ApiResponse<UserResponse> getUserById(@PathVariable("userId") Integer userId) {
        return ApiResponse.<UserResponse>builder()
                .result(userService.getUserById(userId))
                .code(200).build();
    }

    @PutMapping("/{userId}")
    ApiResponse<UserResponse> updateUser(@PathVariable Integer userId,@RequestBody UpdateUserRequest request) {
        return ApiResponse.<UserResponse>builder()
                .result(userService.updateUser(userId, request))
                .code(200).build();
    }

    @DeleteMapping("/{userId}")
    void deleteUser(@PathVariable Integer userId) {
        userService.deleteUser(userId);
    }
}
