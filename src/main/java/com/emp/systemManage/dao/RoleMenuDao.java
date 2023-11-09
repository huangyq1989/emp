package com.emp.systemManage.dao;


import com.emp.systemManage.entity.Menu;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.entity.Role;
import com.emp.systemManage.entity.RoleMenu;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoleMenuDao {

    List<Menu> queryMenuByParams(@Param("employeeId")String employeeId);

    List<Role> queryRoleByLike(@Param("role") Role role, @Param("pages") Page pages);

    int countRoleByLike(@Param("role") Role role);

    List<Role> queryRoleByEquals(@Param("role") Role role, @Param("pages") Page pages);

    int countRoleByEquals(@Param("role") Role role);

    List<RoleMenu> queryRoleMenu(@Param("rm") RoleMenu rm);

    void deleteRoleMenu(@Param("roleId") String roleId);

    void saveRoleMenu(@Param("ids") int[] ids,@Param("roleId") String roleId);

    List<Role> getER(@Param("role") Role role,@Param("employeeId") String employeeId, @Param("type") String type, @Param("pages") Page pages);

    int countER(@Param("role") Role role, @Param("employeeId") String employeeId, @Param("type") String type);

    void insertRole(Role role);

    void updateRole(@Param("role") Role role);

    void deleteRoles(@Param("ids")int[] ids);
}
