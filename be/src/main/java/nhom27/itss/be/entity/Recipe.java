package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "Recipes")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Recipe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int recipe_id;
    String recipe_name;
    String description;
    String instructions;
    int prep_time;
    int cook_time;
    int created_by;
    Timestamp created_at;
}
