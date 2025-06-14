package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlanResponse {
    Integer planId;
    String planName;
    Timestamp startDate;
    Timestamp endDate;
    Integer groupId;
    Integer createdBy;
    Timestamp createdAt;
    Boolean status;

    List<MealDetailResponse> details;


}
