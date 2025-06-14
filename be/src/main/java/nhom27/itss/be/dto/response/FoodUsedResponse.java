
package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodUsedResponse {
    Integer id;
    Integer foodId;
    String foodname;
    Integer quantity;
    Integer unitId;
    String unitName;
    Instant actionDate;
}

