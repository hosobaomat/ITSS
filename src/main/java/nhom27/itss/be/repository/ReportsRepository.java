package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Reports;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ReportsRepository extends JpaRepository<Reports, Integer>, JpaSpecificationExecutor<Reports> {

}