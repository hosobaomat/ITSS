package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.response.NotificationResponse;
import nhom27.itss.be.entity.*;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.mapper.NotificationMapper;
import nhom27.itss.be.repository.*;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static nhom27.itss.be.mapper.NotificationMapper.toNotificationsResponse;


@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class NotificationService {

    FoodItemsRepository foodItemRepository;
    FoodCatalogRepository foodCatalogRepository;
    UsersRepository userRepository;
    FamilyGroupMembersRepository familyGroupMemberRepository;
    FamilyGroupsRepository familyGroupsRepository;
    UnitsRepository unitsRepository;
    FoodItemsRepository foodItemsRepository;
    NotificationsRepository notificationsRepository;


    public List<NotificationResponse> getAllNotificationsByUserId(Integer userId) {
        Optional<List<Notification>> optionalList= notificationsRepository.findByUser_UserIdAndReadFalse(userId);
        List<Notification> notificationList = optionalList.orElse(new ArrayList<>());

        return notificationList.stream().map(
                NotificationMapper::toNotificationsResponse
        ).toList();
    }


    public   NotificationResponse readNotification(Integer notiId) {
        Optional<Notification> optional = notificationsRepository.findById(notiId);
        Notification notification = new Notification();
        if (optional.isPresent()) {
            notification = optional.get();
            notification.setRead(true);
            notificationsRepository.save(notification);
        }

        return  toNotificationsResponse(notification);
    }



}

