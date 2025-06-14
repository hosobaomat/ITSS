package nhom27.itss.be.mapper;

import lombok.AccessLevel;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.User;
import org.springframework.stereotype.Component;

@Component
@FieldDefaults(level = AccessLevel.PUBLIC,makeFinal = true)
public class UserMapper {

    public static UserResponse toUserResponse(User user) {
        if (user == null) {
            return null;
        }
        return getUserResponse(user);
    }

    public static UserResponse getUserResponse(User user) {
        UserResponse userResponse = new UserResponse();
        userResponse.setUserid(user.getUserId());
        userResponse.setUsername(user.getUsername());
        userResponse.setEmail(user.getEmail());
        userResponse.setRole(user.getRole().toString());
        userResponse.setFullName(user.getFullName());
        userResponse.setCreatedAt(user.getCreatedAt());

        return userResponse;
    }
}
