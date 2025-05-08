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
@Table(name = "FamilyGroupMembers")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroupMember {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int group_id;
    int user_id;
    Timestamp joined_at;


}
