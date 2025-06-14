package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FamilyGroupsRepository extends JpaRepository<FamilyGroup, Integer>, JpaSpecificationExecutor<FamilyGroup> {
    FamilyGroup findByInviteCode(String code);

}