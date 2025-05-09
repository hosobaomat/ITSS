package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface UsersRepository extends JpaRepository<Users, Integer>, JpaSpecificationExecutor<Users> {

}