package nhom27.itss.be.controller;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.FamilyGroupMemberRequest;
import nhom27.itss.be.dto.request.FamilyGroupRequest;
import nhom27.itss.be.dto.response.ApiResponse;
import nhom27.itss.be.dto.response.FamilyGroupResponse;
import nhom27.itss.be.service.FamilyGroupService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
@RequestMapping("/family_group")
public class FamilyGroupController {
    FamilyGroupService familyGroupService;

    @PostMapping("")
    ApiResponse<FamilyGroupResponse> createFamilyGroup(@RequestBody /*@Valid */ FamilyGroupRequest request) {
        //log.info("In method createUser,controller");
        FamilyGroupResponse response = familyGroupService.createFamilyGroup(request);
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(response)
                .code(200)
                .build();
    }

    @PostMapping("/{groupId}/members")
    public ApiResponse<FamilyGroupResponse> addFamilyGroupMembers(
            @PathVariable Integer groupId,
            @RequestBody FamilyGroupMemberRequest request) {
        FamilyGroupResponse response = familyGroupService.addFamilyGroupMembers(request, groupId);
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(response)
                .code(200)
                .build();
    }

    @DeleteMapping("/{groupId}/members")
    public ApiResponse<FamilyGroupResponse> deleteFamilyGroupMembers(
            @PathVariable Integer groupId,
            @RequestBody FamilyGroupMemberRequest request) {
        FamilyGroupResponse response = familyGroupService.deleteUsersFromGroup(request, groupId);
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(response)
                .code(200)
                .build();
    }

    @GetMapping
    ApiResponse<List<FamilyGroupResponse>> getAllFamilyGroups(){

        return ApiResponse.<List<FamilyGroupResponse>>builder()
                .result(familyGroupService.getAllFamilyGroup())
                .code(200).build();
    }

    @GetMapping("/invite/{inviteCode}")
    ApiResponse<FamilyGroupResponse> getFamilyGroupByInviteCode(@PathVariable String inviteCode){

        return ApiResponse.<FamilyGroupResponse>builder()
                .result(familyGroupService.getFamilyInviteCode(inviteCode))
                .code(200).build();
    }

    @GetMapping("/{familygroupid}")
    ApiResponse<FamilyGroupResponse> getFamilyGroupById(@PathVariable("familygroupid") Integer familygroupid) {
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(familyGroupService.getFamilyGroupById(familygroupid))
                .code(200).build();
    }

    @GetMapping("/user/{userId}")
    ApiResponse<FamilyGroupResponse> getFamilyGroupByUserId(@PathVariable("userId") Integer userId) {
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(familyGroupService.getFamilyGroupByUserId(userId))
                .code(200).build();
    }

    @PutMapping("/{familygroupid}")
    ApiResponse<FamilyGroupResponse> updateFamilyGroup(@RequestBody FamilyGroupRequest request, @PathVariable Integer familygroupid) {
        return ApiResponse.<FamilyGroupResponse>builder()
                .result(familyGroupService.updateFamilyGroup(request, familygroupid))
                .code(200).build();
    }

    @DeleteMapping("/{groupdId}")
    ApiResponse<String> deleteFamilyGroup(@PathVariable Integer groupdId){
        familyGroupService.deleteFamilyGroup(groupdId);
        return ApiResponse.<String>builder()
                .result("Family group has been deleted")
                .code(200).build();
    }
}
