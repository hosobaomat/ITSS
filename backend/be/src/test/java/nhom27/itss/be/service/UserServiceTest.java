package nhom27.itss.be.service;

import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.entity.User;
import nhom27.itss.be.enums.Role;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.repository.UsersRepository;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import java.sql.Timestamp;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@SpringBootTest
public class UserServiceTest {
    @Autowired
    private UserService userService;

    @MockitoBean
    private UsersRepository userRepository;

    private UserCreationRequest request;
    private UserResponse userResponse;
    private User user;

    @BeforeEach
    void initData(){

        request = UserCreationRequest.builder()
                .username("hung36")
                .password("hung")
                .email("hung36@gmail.com")
                .fullName("tran van hien")
                .role("user")
                .build();

        userResponse = UserResponse.builder()
                .userid(17)
                .username("hung36")
                .email("hung36@gmail.com")
                .fullName("tran van hien")
                .role("user")
                .createdAt(new Timestamp(1649565640518L))
                .updatedAt(null)
                .build();

        user = User.builder()
                .userId(17)
                .username("hung36")
                .email("hung36@gmail.com")
                .fullName("tran van hien")
                .role(Role.user)
                .createdAt(new Timestamp(1749565640518L))
                .updatedAt(null)
                .build();
    }

    @Test
    void createUser_validRequest_success(){
        // GIVEN
        when(userRepository.existsByUsername(anyString())).thenReturn(false);
        when(userRepository.existsByEmail(anyString())).thenReturn(false);
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User savedUser = invocation.getArgument(0);
            savedUser.setUserId(17); // Giả lập ID được sinh ra
            return savedUser;
        });


        // WHEN
        var response = userService.createUser(request);
        // THEN

        Assertions.assertThat(response.getUserid()).isEqualTo(17);
        Assertions.assertThat(response.getUsername()).isEqualTo("hung36");
        Assertions.assertThat(response.getEmail()).isEqualTo("hung36@gmail.com");
    }

    @Test
    void createUser_userExisted_fail(){
        // GIVEN
        when(userRepository.existsByUsername(anyString())).thenReturn(true);
        when(userRepository.existsByEmail(anyString())).thenReturn(true);

        // WHEN
        var exception = assertThrows(AppException.class,
                () -> userService.createUser(request));

        // THEN
        Assertions.assertThat(exception.getErrorCode().getCode())
                .isEqualTo(1001);
    }
}
