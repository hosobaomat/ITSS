package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface RecipesRepository extends JpaRepository<Recipe, Integer>, JpaSpecificationExecutor<Recipe> {

}