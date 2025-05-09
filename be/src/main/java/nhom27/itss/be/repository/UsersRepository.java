package nhom27.itss.be.repository;

import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UsersRepository extends JpaRepository<User, Integer>, JpaSpecificationExecutor<User> {
    boolean existByEmail(String email);
}