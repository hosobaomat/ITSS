//package nhom27.itss.be.service;
//
//import lombok.AccessLevel;
//import lombok.RequiredArgsConstructor;
//import lombok.experimental.FieldDefaults;
//import lombok.extern.slf4j.Slf4j;
//import nhom27.itss.be.dto.request.AddFoodItemRequest;
//import nhom27.itss.be.dto.request.UpdateFoodItemRequest;
//import nhom27.itss.be.dto.response.AddFoodItemToFrigdeResponse;
//import nhom27.itss.be.dto.response.FoodItemResponse;
//import nhom27.itss.be.entity.*;
//import nhom27.itss.be.exception.AppException;
//import nhom27.itss.be.exception.ErrorCode;
//import nhom27.itss.be.exception.ResourceNotFoundException;
//import nhom27.itss.be.repository.*;
//import org.springframework.scheduling.annotation.Scheduled;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import java.sql.Timestamp;
//import java.time.LocalDate;
//import java.util.Date;
//import java.util.List;
//import java.util.Set;
//import java.util.stream.Collectors;
//
//
//@Slf4j
//@Service
//@RequiredArgsConstructor
//@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
//public class NotificationService {
//
//    FoodItemsRepository foodItemRepository;
//    FoodCatalogRepository foodCatalogRepository;
//    UsersRepository userRepository;
//    FamilyGroupMembersRepository familyGroupMemberRepository;
//    FamilyGroupsRepository familyGroupsRepository;
//    UnitsRepository unitsRepository;
//    FoodItemsRepository foodItemsRepository;
//    NotificationsRepository notificationsRepository;
//
//
//    @Scheduled(cron = "0 0 0 * * ?")
//    @Transactional
//    public void checkExpiringFoodItems() {
//        // Lấy ngày hiện tại và ngày sau 3 ngày
//        LocalDate today = LocalDate.now();
//        LocalDate expiryThreshold = today.plusDays(3);
//        Date startDate = Date.valueOf(today);
//        Date endDate = Date.valueOf(expiryThreshold);
//
//        // Tìm tất cả fooditems sắp hết hạn
//        List<FoodItem> expiringItems = foodItemsRepository.findByExpiryDateBetween(startDate, endDate);
//
//        for (FoodItem item : expiringItems) {
//            // Lấy thông tin thực phẩm từ foodcatalog
//            FoodCatalog foodCatalog = foodCatalogRepository.findById(item.)
//                    .orElseThrow(() -> new AppException(ErrorCode.FOOD_NOT_EXISTS));
//
//            // Lấy group để tìm created_by
//            FamilyGroup group = familyGroupsRepository.findById(item.getGroup().getGroup_id())
//                    .orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED));
//
//            // Tạo thông báo cho created_by
//            createNotificationForUser(
//                    group.getCreatedBy().getUserId(),
//                    item.getFoodId(),
//                    foodCatalog.getFoodName(),
//                    item.getExpiryDate()
//            );
//
//            // (Tùy chọn) Tạo thông báo cho tất cả thành viên trong nhóm
//            List<FamilyGroupMember> members = familyGroupMemberRepository.findByIdGroupId(item.getGroup().getGroup_id());
//            for (FamilyGroupMember member : members) {
//                createNotificationForUser(
//                        member.getUser().getUserId(),
//                        item.getFoodId(),
//                        foodCatalog.getFoodName(),
//                        item.getExpiryDate()
//                );
//            }
//        }
//    }
//
//    private void createNotificationForUser(Integer userId, Integer foodId, String foodName, Date expiryDate) {
//        // Kiểm tra thông báo trùng lặp
//        if (!notificationsRepository.existsByFoodIdAndNotificationTypeAndUserId(foodId, "expiry", userId)) {
//            Notification notification = Notification.builder()
//                    .user(userRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION)))
//                    .
//                    .message(String.format("%s sắp hết hạn vào %s", foodName, expiryDate))
//                    .notificationType("expiry")
//                    .createdAt(new Timestamp(System.currentTimeMillis()))
//                    .read(false)
//                    .build();
//            notificationRepository.save(notification);
//        }
//    }
//}
//
