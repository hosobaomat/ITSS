package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UnitResponse {
    Integer unidId;
    String unitName;
    String unitDescription;

}
