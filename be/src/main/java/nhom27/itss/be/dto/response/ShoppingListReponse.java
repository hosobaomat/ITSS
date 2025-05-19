package nhom27.itss.be.dto.response;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ShoppingListReponse {

    Integer groupId;
    String listName;
    Integer createdBy;
    Timestamp createdAt;
    Timestamp startDate;
    Timestamp endDate;
    String status;
}
