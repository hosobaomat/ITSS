package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Recipe;
import nhom27.itss.be.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface RecipesRepository extends JpaRepository<Recipe, Integer>, JpaSpecificationExecutor<Recipe> {
    List<Recipe> findByCreatedBy(User user);

}