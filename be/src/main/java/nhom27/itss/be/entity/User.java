package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import nhom27.itss.be.enums.Role;

import java.sql.Timestamp;
import java.util.Date;
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
    @Column(name = "user_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer userId;

    @Column(name = "username", nullable = false)
    String username;

    @Column(name = "password", nullable = false)
    String password;

    @Column(name = "email", nullable = false)
    String email;

    @Column(name = "full_name")
    String fullName;

    @Column(name = "role")
    Role role;

    @Column(name = "created_at")
    Timestamp createdAt;

    @Column(name = "updated_at")
    Timestamp updatedAt;

}
