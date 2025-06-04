
package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyFoodItemResponse {
    Integer CategoryId;
    String CategoryName;
    String CategoryDescription;

    List<FoodItemResponse> foodItemResponses = new ArrayList<>();
}

