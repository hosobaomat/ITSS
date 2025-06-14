package nhom27.itss.be.repository;

import nhom27.itss.be.entity.Recipe;
import nhom27.itss.be.entity.RecipeIngredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface RecipeIngredientsRepository extends JpaRepository<RecipeIngredient, Integer>, JpaSpecificationExecutor<RecipeIngredient> {
    List<RecipeIngredient> findByRecipe(Recipe recipe);
}