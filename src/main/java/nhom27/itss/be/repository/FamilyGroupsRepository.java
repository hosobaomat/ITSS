package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroups;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface FamilyGroupsRepository extends JpaRepository<FamilyGroups, Integer>, JpaSpecificationExecutor<FamilyGroups> {

}