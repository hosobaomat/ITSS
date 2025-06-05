package nhom27.itss.be.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@Table(name = "mealplans")
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class MealPlan {
    @Id
    @Column(name = "plan_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer planId;


    @Column(name = "plan_name", nullable = false)
    String planName;

    @Column(name = "start_date")
    Timestamp startDate;

    @Column(name = "end_date")
    Timestamp endDate;

    @Column(name = "created_at")
    Timestamp createdAt;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id")
    private FamilyGroup group;

    @OneToMany(mappedBy = "mealPlan",cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MealPlanDetail> mealplandetails = new LinkedHashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by")
    private User createdBy;



}
