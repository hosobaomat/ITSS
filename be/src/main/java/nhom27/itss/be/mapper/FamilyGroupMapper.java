package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.FamilyGroupResponse;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.User;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

import static nhom27.itss.be.mapper.UserMapper.toUserResponse;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class FamilyGroupMapper {




    public static FamilyGroupResponse toFamilyGroupResponse(FamilyGroup FamilyGroup) {
        if (FamilyGroup == null) {
            return null;
        }
        return getFamilyGroupResponse(FamilyGroup);
    }


    public static FamilyGroupResponse getFamilyGroupResponse(FamilyGroup familyGroup) {
        FamilyGroupResponse familyGroupResponse = new FamilyGroupResponse();
        familyGroupResponse.setId(familyGroup.getGroupId());
        familyGroupResponse.setGroupName(familyGroup.getGroupName());
        familyGroupResponse.setCreatedBy(familyGroup.getCreatedBy().getUsername());
        familyGroupResponse.setCreatedAt(familyGroup.getCreatedAt());
        familyGroupResponse.setInviteCode(familyGroup.getInviteCode());
        familyGroupResponse.setMembers(familyGroup.getMembers().stream()
                .map(member -> toUserResponse(member.getUser()))
                .collect(Collectors.toSet()));
        return familyGroupResponse;
    }
}
