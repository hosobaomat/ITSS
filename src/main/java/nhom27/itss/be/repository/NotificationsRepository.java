package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Notifications;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface NotificationsRepository extends JpaRepository<Notifications, Integer>, JpaSpecificationExecutor<Notifications> {

}