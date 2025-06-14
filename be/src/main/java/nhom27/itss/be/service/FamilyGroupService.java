package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.Generated;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.FamilyGroupMemberRequest;
import nhom27.itss.be.dto.request.FamilyGroupRequest;
import nhom27.itss.be.dto.response.FamilyGroupResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.FamilyGroupMember;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.entity.embeddedID.FamilyGroupMemberId;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.mapper.FamilyGroupMapper;
import nhom27.itss.be.repository.FamilyGroupMembersRepository;
import nhom27.itss.be.repository.FamilyGroupsRepository;
import nhom27.itss.be.repository.UsersRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.*;
import java.util.stream.Collectors;

import static nhom27.itss.be.mapper.FamilyGroupMapper.toFamilyGroupResponse;
import static nhom27.itss.be.mapper.UserMapper.toUserResponse;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class FamilyGroupService {


    FamilyGroupsRepository familyGroupsRepository;
    UsersRepository usersRepository;
    FamilyGroupMembersRepository familyGroupMembersRepository;



    public FamilyGroupResponse createFamilyGroup(FamilyGroupRequest request) /*throws Exception*/ {

        FamilyGroup group = new FamilyGroup();
        group.setGroupName(request.getGroupName());

        User user = usersRepository.findById(request.getCreatedBy())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        group.setCreatedBy(user);
        group.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        group.setInviteCode(UUID.randomUUID().toString().replace("-", "").substring(0, 5).toUpperCase());
        familyGroupsRepository.save(group);


        FamilyGroupMemberId memberId = new FamilyGroupMemberId();
        memberId.setGroupId(group.getGroupId());
        memberId.setMemberId(user.getUserId());

        // Tạo thành viên nhóm
        FamilyGroupMember member = new FamilyGroupMember();
        member.setId(memberId);
        member.setGroup(group);
        member.setUser(user);
        member.setJoinedAt(new Timestamp(System.currentTimeMillis()));

        // Lưu thành viên vào bảng trung gian
        familyGroupMembersRepository.save(member);

        return toFamilyGroupResponse(group);
    }

    public List<FamilyGroupResponse> getAllFamilyGroup(){

        List<FamilyGroup> familyGroupsLists = familyGroupsRepository.findAll();
        return familyGroupsLists.stream().map(FamilyGroupMapper::toFamilyGroupResponse).collect(Collectors.toList());

    }


    public FamilyGroupResponse getFamilyGroupById(Integer id){

        FamilyGroup group = getFamilyGroup(id);
        return  toFamilyGroupResponse(group);
    }

    public FamilyGroupResponse getFamilyGroupByUserId(Integer id){
        User user = usersRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        return  toFamilyGroupResponse(user.getFamilyGroupMembers().getFirst().getGroup());
    }

    public FamilyGroupResponse getFamilyInviteCode(String code){

        return  toFamilyGroupResponse(familyGroupsRepository.findByInviteCode(code));
    }

    public String getInvitedCodeByGroupId(Integer groupId){
        return familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED)).getInviteCode();
    }



    public FamilyGroupResponse updateFamilyGroup(FamilyGroupRequest request,Integer id){
        FamilyGroup group = getFamilyGroup(id);
        if (request.getGroupName() != null) {
            group.setGroupName(request.getGroupName());
        }
        familyGroupsRepository.save(group);

        return  toFamilyGroupResponse(group);

    }


    public FamilyGroupResponse addFamilyGroupMembers(FamilyGroupMemberRequest request, Integer groupId) {
        FamilyGroup group = getFamilyGroup(groupId);

        Set<Integer> userIds = request.getUserIds();
        List<User> users = usersRepository.findAllById(userIds);

        if (users.size() != userIds.size()) {
            throw new AppException(ErrorCode.USERNOTFOUND_EXCEPTION);
        }

        List<FamilyGroupMember> existingMembers = familyGroupMembersRepository.findByIdGroupId(groupId);
        Set<Integer> existingUserIds = existingMembers.stream()
                .map(member -> member.getId().getMemberId())
                .collect(Collectors.toSet());

        List<User> newUsers = users.stream()
                .filter(user -> !existingUserIds.contains(user.getUserId()))
                .toList();

        if (newUsers.isEmpty()) {
            throw new AppException(ErrorCode.MEMBER_ALREADY_EXISTS); // Không có user mới để thêm
        }

        List<FamilyGroupMember> newMembers = newUsers.stream()
                .map(user -> FamilyGroupMember.builder()
                        .id(new FamilyGroupMemberId(groupId, user.getUserId()))
                        .group(group)
                        .user(user)
                        .joinedAt(new Timestamp(System.currentTimeMillis()))
                        .build())
                .toList();

        Set<FamilyGroupMember> members = group.getMembers();
        members.addAll(newMembers);
        group.setMembers(members);
        familyGroupsRepository.save(group);

        return toFamilyGroupResponse(group);
    }
    @Transactional
    public FamilyGroupResponse joinGroupByCode(String code){
        try {
            FamilyGroup group = familyGroupsRepository.findByInviteCode(code);

            if (group == null) {
                throw new AppException(ErrorCode.GROUP_NOT_FOUND);
            }

            var context = SecurityContextHolder.getContext();
            String email = context.getAuthentication().getName();

            User currUser = usersRepository.findByEmail(email);

            Integer currentUserId = currUser.getUserId();

            List<FamilyGroupMember> existingMembers = familyGroupMembersRepository.findByIdGroupId(group.getGroupId());
            boolean isAlreadyMember = existingMembers.stream()
                    .anyMatch(member -> member.getId().getMemberId().equals(currentUserId));

            if (isAlreadyMember) {
                throw new AppException(ErrorCode.MEMBER_ALREADY_EXISTS); // Người dùng đã tham gia
            }

            FamilyGroupMember newMember = FamilyGroupMember.builder()
                    .id(new FamilyGroupMemberId(group.getGroupId(), currentUserId))
                    .group(group)
                    .user(currUser)
                    .joinedAt(new Timestamp(System.currentTimeMillis()))
                    .build();

            group.getMembers().add(newMember);
            familyGroupsRepository.save(group);
            


            return toFamilyGroupResponse(group);
        } catch (AppException e) {
            throw new RuntimeException(e);
        }

    }

    public FamilyGroupResponse deleteUsersFromGroup(FamilyGroupMemberRequest request, Integer groupId) {
        FamilyGroup group = getFamilyGroup(groupId);

        Set<Integer> userIdsToDelete = request.getUserIds();
        List<User> users = usersRepository.findAllById(userIdsToDelete);

        if (users.size() != userIdsToDelete.size()) {
            throw new AppException(ErrorCode.USERNOTFOUND_EXCEPTION);
        }

        // Lấy danh sách thành viên hiện tại của group
        List<FamilyGroupMember> existingMembers = familyGroupMembersRepository.findByIdGroupId(groupId);
        Map<Integer, FamilyGroupMember> userIdToMemberMap = existingMembers.stream()
                .collect(Collectors.toMap(
                        member -> member.getId().getMemberId(),
                        member -> member
                ));

        // Kiểm tra user nào KHÔNG thuộc group thì báo lỗi
        List<Integer> invalidUserIds = userIdsToDelete.stream()
                .filter(userId -> !userIdToMemberMap.containsKey(userId))
                .toList();

        if (!invalidUserIds.isEmpty()) {
            throw new AppException(ErrorCode.USERNOTFOUND_EXCEPTION); // Hoặc tạo lỗi phù hợp
        }

        // Xóa các thành viên đó khỏi DB
        List<FamilyGroupMember> membersToDelete = userIdsToDelete.stream()
                .map(userIdToMemberMap::get)
                .toList();

        familyGroupMembersRepository.deleteAll(membersToDelete);

        // Cập nhật lại danh sách members trong group (nếu bạn đang dùng quan hệ 2 chiều)
        Set<FamilyGroupMember> updatedMembers = group.getMembers();
        membersToDelete.forEach(updatedMembers::remove);
        group.setMembers(updatedMembers);
        familyGroupsRepository.save(group);

        return toFamilyGroupResponse(group);
    }

    public void deleteFamilyGroup(Integer groupId) {
        familyGroupsRepository.deleteById(groupId);
   }

    private FamilyGroup getFamilyGroup(Integer groupId) {
        return familyGroupsRepository.findById(groupId).orElseThrow(() -> new AppException(ErrorCode.FAMILYGROUP_NOT_EXISTED) );
    }
}



