package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodCatalog;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface FoodcatalogsRepository extends JpaRepository<FoodCatalog, Integer>, JpaSpecificationExecutor<FoodCatalog> {

}