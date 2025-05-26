package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodCatalog;
import nhom27.itss.be.entity.Unit;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface UnitsRepository extends JpaRepository<Unit, Integer>, JpaSpecificationExecutor<Unit> {

}