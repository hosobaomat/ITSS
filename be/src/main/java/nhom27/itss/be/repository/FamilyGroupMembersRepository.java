package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroupMember;
import nhom27.itss.be.entity.embeddedID.FamilyGroupMemberId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

public interface FamilyGroupMembersRepository extends JpaRepository<FamilyGroupMember, FamilyGroupMemberId>, JpaSpecificationExecutor<FamilyGroupMember> {
    List<FamilyGroupMember> findByIdGroupId(Integer familyGroupId);
}