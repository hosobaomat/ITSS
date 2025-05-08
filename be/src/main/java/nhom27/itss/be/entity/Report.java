package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Date;
import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "Reports")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Report {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int report_id;
    int group_id;
    @Enumerated(EnumType.STRING)
    String report_type;
    Date start_date;
    Date end_date;
    @Column(columnDefinition = "json")
    String data;
    Timestamp created_at;
}
