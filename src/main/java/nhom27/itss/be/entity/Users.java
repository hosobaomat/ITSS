package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "Users")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "Users")
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "user_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "user_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer userId;

    @jakarta.persistence.Column(name = "username", nullable = false)
    @Column(name = "username", nullable = false)
    private String username;

    @jakarta.persistence.Column(name = "password", nullable = false)
    @Column(name = "password", nullable = false)
    private String password;

    @jakarta.persistence.Column(name = "email", nullable = false)
    @Column(name = "email", nullable = false)
    private String email;

    @jakarta.persistence.Column(name = "full_name")
    @Column(name = "full_name")
    private String fullName;

    @jakarta.persistence.Column(name = "role")
    @Column(name = "role")
    private String role;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

    @jakarta.persistence.Column(name = "updated_at")
    @Column(name = "updated_at")
    private Date updatedAt;

}
