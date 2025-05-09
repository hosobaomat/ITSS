package nhom27.itss.be.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@jakarta.persistence.Table(name = "MealPlans")
@jakarta.persistence.Entity
@lombok.Data
@Data
@Entity
@Table(name = "MealPlans")
public class MealPlans implements Serializable {

    private static final long serialVersionUID = 1L;

    @jakarta.persistence.GeneratedValue(strategy = GenerationType.IDENTITY)
    @jakarta.persistence.Column(name = "plan_id", nullable = false)
    @jakarta.persistence.Id
    @Id
    @Column(name = "plan_id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer planId;

    @jakarta.persistence.Column(name = "group_id")
    @Column(name = "group_id")
    private Integer groupId;

    @jakarta.persistence.Column(name = "plan_name", nullable = false)
    @Column(name = "plan_name", nullable = false)
    private String planName;

    @jakarta.persistence.Column(name = "start_date")
    @Column(name = "start_date")
    private Date startDate;

    @jakarta.persistence.Column(name = "end_date")
    @Column(name = "end_date")
    private Date endDate;

    @jakarta.persistence.Column(name = "created_by")
    @Column(name = "created_by")
    private Integer createdBy;

    @jakarta.persistence.Column(name = "created_at")
    @Column(name = "created_at")
    private Date createdAt;

}
