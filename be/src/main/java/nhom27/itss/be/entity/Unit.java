package nhom27.itss.be.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "units", schema = "DichoTienloi")
public class Unit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "unit_id", nullable = false)
    private Integer id;

    @Size(max = 50)
    @NotNull
    @Column(name = "unit_name", nullable = false, length = 50)
    private String unitName;

    @Lob
    @Column(name = "description")
    private String description;

}