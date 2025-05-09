package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ReportsRepository extends JpaRepository<Report, Integer>, JpaSpecificationExecutor<Report> {

}