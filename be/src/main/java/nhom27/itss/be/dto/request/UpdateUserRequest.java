package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UpdateUserRequest {
    //@Size(min = 8, message = "PASSWORD_INVALID")
    String password;
    String username;
    String email;
    String fullName;

    //@DobConstraint(message = "INVALID_AGE")
    LocalDate birthDate;

    String roles;


}

