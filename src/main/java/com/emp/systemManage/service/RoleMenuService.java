package com.emp.systemManage.service;

import com.emp.systemManage.entity.Menu;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.entity.Role;
import com.emp.systemManage.entity.RoleMenu;

import java.util.List;


public interface RoleMenuService {

    List<Menu> getFatherNode(String employeeId);

    List<Menu> getChildrenNode(Integer pId, List<Menu> treesList);

    List<Role> queryRoleByLike(Role role, Page pages);

    int countRoleByLike(Role role);

    List<Role> queryRoleByEquals(Role role, Page pages);

    int countRoleByEquals(Role role);

    List<RoleMenu> queryRoleMenu(RoleMenu rm);

    void saveRoleMenu(int[] ids,String roleId);

    List<Role> getER(Role role, String employeeId,String type, Page pages);

    int countER(Role role, String employeeId,String type);

    void insertRole(Role role);

    void updateRole(Role role);

    void deleteRoles(int[] ids);
}