package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeIngredientResponse {
    Integer recipeid;
    Integer foodId;
    String foodname;
    String unitName;
    Integer unitId;
    Integer quantity;
}
