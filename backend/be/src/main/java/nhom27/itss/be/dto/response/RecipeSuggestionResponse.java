package nhom27.itss.be.dto.response;

import lombok.Data;

import java.util.List;

@Data
public class RecipeSuggestionResponse {
    private Integer recipeId;
    private String recipeName;
    private String description;
    private List<String> ingredients;
}
