package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Unit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
public interface UnitRepository extends JpaRepository<Unit, Integer>, JpaSpecificationExecutor<Unit>{

}
