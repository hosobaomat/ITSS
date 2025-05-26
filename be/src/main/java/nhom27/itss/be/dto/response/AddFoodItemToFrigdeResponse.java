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
public class AddFoodItemToFrigdeResponse {
    Integer groupId;
    String groupName;
    String addedBy;
    Set<FoodItemResponse> foodItemResponses = new HashSet<>();
}
