package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.enums.Role;

import java.sql.Timestamp;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "USERS")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int user_id;
    String username;
    String password;
    String email;
    String full_name;
    Timestamp created_at;
    Timestamp updated_at;

    @Enumerated(EnumType.STRING)
    Role role;

}
