package nhom27.itss.be.repository;

import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface UsersRepository extends JpaRepository<User, Integer>, JpaSpecificationExecutor<User> {
    boolean existsByEmail(String email);
    boolean existsByUsername(String username);

    User findByEmail(String email);

    Optional<User> findByEmail(String email);
    Optional<User> findByUsername(String username);
   // Optional<User> findByUserId(int id);

}