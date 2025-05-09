package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.Date;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "FamilyGroups")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class FamilyGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(table = "group_id", nullable = false)
    Integer group_id;

    @Column(name = "group_name", nullable = false)
    String groupName;

    @Column(name = "created_by")
    Integer createdBy;

    @Column(name = "created_at")
    Timestamp createdAt;

}
