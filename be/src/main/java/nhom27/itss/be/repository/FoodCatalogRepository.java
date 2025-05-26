package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FoodCatalog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FoodCatalogRepository extends JpaRepository<FoodCatalog, Integer>, JpaSpecificationExecutor<FoodCatalog> {

}