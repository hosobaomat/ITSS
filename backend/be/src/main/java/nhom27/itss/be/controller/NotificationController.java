package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.FoodUsedResponse;
import nhom27.itss.be.dto.response.NotificationResponse;
import nhom27.itss.be.service.NotificationService;
import nhom27.itss.be.service.StatService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/notifiation")
public class NotificationController {

    NotificationService notificationService;


    // GET /api/notifications/user/{userId}
    @GetMapping("/user/{userId}")
    public ApiResponse<List<NotificationResponse>> getAllNotificationsByUserId(@PathVariable Integer userId) {
        List<NotificationResponse> notifications = notificationService.getAllNotificationsByUserId(userId);
        return ApiResponse.<List<NotificationResponse>>builder()
                .code(200)
                .result(notifications)
                .build();
    }

    // PUT /api/notifications/{notificationId}/read
    @PutMapping("/{notificationId}/read")
    public ApiResponse<NotificationResponse> markNotificationAsRead(@PathVariable Integer notificationId) {

        return ApiResponse.<NotificationResponse>builder()
                .code(200)
                .result( notificationService.readNotification(notificationId))
                .build();
    }






}
