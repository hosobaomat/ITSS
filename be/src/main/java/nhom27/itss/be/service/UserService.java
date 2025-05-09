package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.enums.Role;
import nhom27.itss.be.repository.UsersRepository;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class UserService {


    private UsersRepository userRepository;


    public UserResponse createUser(UserCreationRequest request) /*throws Exception*/ {
        /*if(userRepository.existByEmail(request.getEmail())){
            throw new Exception("Emalil has been used");
        }*/

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(request.getPassword());
        user.setRole(Role.valueOf(request.getRole()));
        user.setFullName(request.getFullName());
        user.setUsername(request.getUsername());
        user.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        UserResponse userResponse = new UserResponse();
        userResponse.setEmail(user.getEmail());
        userResponse.setRole(user.getRole().toString());
        userResponse.setFullName(user.getFullName());
        userResponse.setUsername(user.getUsername());
        userResponse.setCreatedAt(user.getCreatedAt());

        userRepository.save(user);

        return userResponse;

    }


}
