package nhom27.itss.be.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.UpdateUserRequest;
import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.enums.Role;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.repository.UsersRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.beans.BeanUtils;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class UserService {


    UsersRepository userRepository;
    PasswordEncoder passwordEncoder;



    public UserResponse createUser(UserCreationRequest request) /*throws Exception*/ {
        if(userRepository.existsByEmail(request.getEmail()) || userRepository.existsByUsername(request.getUsername())){
            throw new AppException(ErrorCode.USER_EXISTED);
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
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

    public List<User> getAllUsers(){

        //log.info("In method getAllUsers");


        return userRepository.findAll();
    }

    /*
    public UserResponse getMyInfo(){
        var context = SecurityContextHolder.getContext();

        String name = context.getAuthentication().getName();

        Users user = userRepository.findByUsername(name).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION));

        return userMapper.toUserResponse(user);
    }*/

    public UserResponse getUserById(Integer id){

        log.info("In method getUserById");

        User user = userRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION) );



         UserResponse userResponse = new UserResponse();

        return  UserResponse.builder()
                .username(user.getUsername())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .role(String.valueOf(user.getRole()))
                .build()
                ;
    }

    public UserResponse updateUser(Integer userId, UpdateUserRequest request){
        User user = userRepository.findById(userId).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION));

        if (request.getEmail() != null) {
            user.setEmail(request.getEmail());
        }
        if (request.getUsername() != null) {
            user.setUsername(request.getUsername());
        }
        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }
        if (request.getPassword() != null) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }
        if (request.getRoles() != null) {
            user.setRole(Role.valueOf(request.getRoles()));
        }
        userRepository.save(user);


        return UserResponse.builder()
                .username(user.getUsername())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .createdAt(user.getCreatedAt())
                .role(String.valueOf(user.getRole()))
                .build()
                ;
    }

    public void deleteUser(Integer userId) {
        userRepository.deleteById(userId);
    }

    public List<UserResponse> getUsers(){
        List<User> users = userRepository.findAll(); // Lấy toàn bộ user từ DB

        List<UserResponse> responses = new ArrayList<>();
        for (User user : users) {
            UserResponse response = new UserResponse();
            response.setUsername(user.getUsername());
            response.setEmail(user.getEmail());
            response.setFullName(user.getFullName());
            response.setRole(String.valueOf(user.getRole()));
            response.setCreatedAt(user.getCreatedAt());
            response.setUpdatedAt(user.getUpdatedAt());
            responses.add(response);
        }

        return responses;

    }
}



