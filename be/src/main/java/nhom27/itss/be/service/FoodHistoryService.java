package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.AddFoodItemRequest;
import nhom27.itss.be.dto.request.UpdateFoodItemRequest;
import nhom27.itss.be.dto.response.AddFoodItemToFrigdeResponse;
import nhom27.itss.be.dto.response.FamilyFoodItemResponse;
import nhom27.itss.be.dto.response.FoodItemResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.enums.NotificationType;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.exception.ResourceNotFoundException;
import nhom27.itss.be.mapper.FoodItemMapper;
import nhom27.itss.be.repository.*;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static nhom27.itss.be.mapper.FoodItemMapper.toFoodItemResponse;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@EnableScheduling
public class FoodHistoryService {

    FoodItemsRepository foodItemRepository;
    FoodCatalogRepository foodCatalogRepository;
    UsersRepository userRepository;
    FamilyGroupMembersRepository familyGroupMemberRepository;
    FamilyGroupsRepository familyGroupsRepository;
    UnitsRepository unitsRepository;
    FoodHistoryRepository foodHistoryRepository;
    NotificationsRepository notificationsRepository;


    @Scheduled(cron = "0 * * * * *")
    @Transactional
    public void checkExpiringFoodItems() {

        List<FoodItem> expiredItems = foodItemRepository.findAllExpiredFoodItems();

        for (FoodItem item : expiredItems) {
            FamilyGroup group = item.getGroup();

            // Ghi vào foodhistory
            if(item.getIs_deleted() == 0 || item.getIs_deleted() == 2){
            FoodHistory history = FoodHistory.builder()
                    .food(item)
                    .group(group)
                    .quantity(item.getQuantity())
                    .unit(item.getUnit())
                    .action("wasted")
                    .actionDate(Instant.now())
                    .food(item)
                    .build();
            foodHistoryRepository.save(history);

            // Tạo thông báo

            for(FamilyGroupMember member : group.getMembers()) {
                if (!notificationsRepository.existsByFoodAndNotificationTypeAndUser(item, String.valueOf(NotificationType.EXPIRED), member.getUser())) {
                    Notification notification = Notification.builder()
                            .user(member.getUser())
                            .food(item)
                            .message(String.format("%s đã hết hạn, %d %s bị lãng phí",
                                    item.getFoodCatalog().getFoodName(), item.getQuantity(),
                                    item.getUnit().getUnitName()))
                            .notificationType(String.valueOf(NotificationType.EXPIRED))
                            .createdAt(new Timestamp(System.currentTimeMillis()))
                            .read(false)
                            .build();
                    notificationsRepository.save(notification);
                }

            }

                item.setIs_deleted(1);
                foodItemRepository.save(item);

            }
        }


    }

    @Scheduled(cron = "0 * * * * *") // chạy lúc 8h sáng mỗi ngày
    @Transactional
    public void checkUpcomingExpiringFoodItems() {
        LocalDate now = LocalDate.now();
        LocalDate threeDaysLater = now.plusDays(3);

        List<FoodItem> soonToExpireItems = foodItemRepository.findFoodItemsExpiringBefore(
                Date.from(threeDaysLater.atStartOfDay(ZoneId.systemDefault()).toInstant())
        );

        for (FoodItem item : soonToExpireItems) {
            if (item.getIs_deleted() == 2  ) continue;

            FamilyGroup group = item.getGroup();

            for (FamilyGroupMember member : group.getMembers()) {
                if (!notificationsRepository.existsByFoodAndNotificationTypeAndUser(
                        item, String.valueOf(NotificationType.UPEXPIRED), member.getUser())) {

                    Notification notification = Notification.builder()
                            .user(member.getUser())
                            .food(item)
                            .message(String.format("Thực phẩm %s sẽ hết hạn vào %s. Vui lòng sử dụng sớm!",
                                    item.getFoodCatalog().getFoodName(),
                                    item.getExpiryDate().toString()))
                            .notificationType(String.valueOf(NotificationType.UPEXPIRED))
                            .createdAt(new Timestamp(System.currentTimeMillis()))
                            .read(false)
                            .build();

                    notificationsRepository.save(notification);
                }
            }

            item.setIs_deleted(2);
            foodItemRepository.save(item);
        }
    }





}


