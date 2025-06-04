package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponse {
    Integer userid;
    String username;
    String email;
    String fullName;
    String role;
    Timestamp createdAt;
    Timestamp updatedAt;
}
