package nhom27.itss.be.repository;

import nhom27.itss.be.entity.FamilyGroup;
import nhom27.itss.be.entity.FamilyGroupMember;

import nhom27.itss.be.entity.User;

import nhom27.itss.be.entity.embeddedID.FamilyGroupMemberId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

import java.util.Optional;

@Repository
public interface FamilyGroupMembersRepository extends JpaRepository<FamilyGroupMember, FamilyGroupMemberId> {


    List<FamilyGroupMember> findByIdGroupId(Integer familyGroupId);

    Optional<FamilyGroupMember> findTopById_MemberIdOrderByJoinedAtDesc(Integer memberId);

    List<FamilyGroupMember> findById_MemberId(Integer memberId);

    @Query("SELECT fgm.user FROM FamilyGroupMember fgm WHERE fgm.id.groupId = :groupId")
    List<User> findAllUsersByGroupId(@Param("groupId") Integer groupId);

    FamilyGroup



}