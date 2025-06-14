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
import nhom27.itss.be.mapper.UserMapper;
import nhom27.itss.be.repository.UsersRepository;
import org.springframework.security.core.context.SecurityContextHolder;

import nhom27.itss.be.repository.FamilyGroupMembersRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.beans.BeanUtils;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import static nhom27.itss.be.mapper.UserMapper.toUserResponse;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE,makeFinal = true)
public class UserService {


    UsersRepository userRepository;
    PasswordEncoder passwordEncoder;
    AuthenticationService authenticationService;

    FamilyGroupMembersRepository familyGroupMemberRepository;

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
        userRepository.save(user);

        return toUserResponse(user);

    }

    public List<UserResponse> getAllUsers(){

        //log.info("In method getAllUsers");


        return userRepository.findAll().stream().map(UserMapper::toUserResponse).toList();
    }

    public UserResponse getUserById(Integer id){

        log.info("In method getUserById");

        User user = userRepository.findById(id).orElseThrow(() -> new AppException(ErrorCode.USERNOTFOUND_EXCEPTION) );

        return  toUserResponse(user);
    }

    public UserResponse getMyInfo() {
        String email = authenticationService.getCurrentEmail();

        User user = userRepository.findByEmail(email);


        return toUserResponse(user);

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


        return toUserResponse(user);
    }

    public void deleteUser(Integer userId) {
        userRepository.deleteById(userId);
    }




}



