package nhom27.itss.be.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodCategoryResponse {
    Integer CategoryId;
    String CategoryName;
    String CategoryDescription;

    Set<FoodCatalogResponse> foodCatalogResponses = new HashSet<>();
    Set<UnitResponse> unitResponses = new HashSet<>();

}
