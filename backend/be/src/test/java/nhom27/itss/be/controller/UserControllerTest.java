package nhom27.itss.be.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.extern.slf4j.Slf4j;
import nhom27.itss.be.dto.request.UserCreationRequest;
import nhom27.itss.be.dto.response.UserResponse;
import nhom27.itss.be.exception.AppException;
import nhom27.itss.be.exception.ErrorCode;
import nhom27.itss.be.service.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;

@SpringBootTest
@Slf4j
@AutoConfigureMockMvc
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;


    @MockitoBean
    private UserService userService;


    private UserCreationRequest userCreationRequest;
    private UserResponse userResponse;

    @BeforeEach
    void initData(){
        userCreationRequest = UserCreationRequest.builder()
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
                .createdAt(new Timestamp(1749565640518L))
                .updatedAt(null)
                .build();
    }

    @Test
    void createUser_validRequest_success() throws Exception {
        // GIVEN
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        String content = objectMapper.writeValueAsString(userCreationRequest);

        //userCreationRequest.setEmail(EmailGenerator.generateRandomEmail());
        Mockito.when(userService.createUser(ArgumentMatchers.any()))
                .thenReturn(userResponse);

        // WHEN, THEN
        mockMvc.perform(MockMvcRequestBuilders
                        .post("/users")
                        .contentType(MediaType.APPLICATION_JSON_VALUE)
                        .content(content))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.jsonPath("code")
                        .value(0));
    }

    @Test
    void createUser_usernameInvalid_fail() throws Exception {
        // GIVEN

        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        userCreationRequest.setEmail(null);
        String content = objectMapper.writeValueAsString(userCreationRequest);

        Mockito.when(userService.createUser(ArgumentMatchers.any()))
                .thenThrow(new AppException(ErrorCode.USER_EXISTED));


        // WHEN, THEN
        mockMvc.perform(MockMvcRequestBuilders
                        .post("/users")
                        .contentType(MediaType.APPLICATION_JSON_VALUE)
                        .content(content))
                .andExpect(MockMvcResultMatchers.status().isBadRequest())
                .andExpect(MockMvcResultMatchers.jsonPath("code")
                        .value(1001))
                .andExpect(MockMvcResultMatchers.jsonPath("message")
                        .value("user existed")
                );
    }

    public static class EmailGenerator {
        public static String generateRandomEmail() {
            String randomString = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
            return "test_" + randomString + "@example.com";
        }
    }

}
