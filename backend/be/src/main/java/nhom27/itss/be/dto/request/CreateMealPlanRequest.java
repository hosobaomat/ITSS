package nhom27.itss.be.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CreateMealPlanRequest {
    String planName;
    Timestamp startDate;
    Timestamp endDate;
    Integer groupId;
    Integer createdBy;
    List<MealPlanDetailRequest> details;


}