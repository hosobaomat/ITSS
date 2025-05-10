package nhom27.itss.be.entity.embeddedID;

import jakarta.persistence.Embeddable;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
@FieldDefaults(level = AccessLevel.PRIVATE)
public class RecipeIngredientID implements Serializable {
    Integer groupId;
    Integer foodId;
}
