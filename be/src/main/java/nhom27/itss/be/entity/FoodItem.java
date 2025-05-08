package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "FoodItems")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FoodItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int food_id;
    int group_id;
    int catergory_id;

    String food_name;
    BigDecimal quantity;
    Date expiry_date;
    String storage_location;
    Timestamp added_at;
    Timestamp updated_at;



}
