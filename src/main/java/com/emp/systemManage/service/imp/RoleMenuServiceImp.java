package com.emp.systemManage.service.imp;

import com.emp.systemManage.dao.RoleMenuDao;
import com.emp.systemManage.entity.Menu;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.entity.Role;
import com.emp.systemManage.entity.RoleMenu;
import com.emp.systemManage.service.RoleMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class RoleMenuServiceImp implements RoleMenuService {

    @Autowired
    private RoleMenuDao roleMenuDao;

    /**
     * 获取父节点菜单
     */
    public List<Menu> getFatherNode(String employeeId){
        List<Menu> menus = roleMenuDao.queryMenuByParams(employeeId);
        List<Menu> newTrees = new ArrayList<Menu>();
        for (Menu mt : menus) {
            if (null == mt.getpId()) {//如果pId为空，则该节点为父节点
                //递归获取父节点下的子节点
                mt.setChildren(getChildrenNode(mt.getId(), menus));
                newTrees.add(mt);
            }
        }
        return newTrees;
    }


    /**
     * 递归获取子节点下的子节点
     */
    public  List<Menu> getChildrenNode(Integer pId, List<Menu> treesList){
        List<Menu> newTrees = new ArrayList<Menu>();
        for (Menu mt : treesList) {
            if (null == mt.getpId()) continue;
            if(mt.getpId().equals(pId)){
                //递归获取子节点下的子节点，即设置树控件中的children
                mt.setChildren(getChildrenNode(mt.getId(), treesList));
                //设置树控件attributes属性的数据
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("url", mt.getUrl());
                mt.setAttributes(map);
                newTrees.add(mt);
            }
        }
        return newTrees;
    }



    @Override
    public List<Role> queryRoleByLike(Role role, Page pages){
        return roleMenuDao.queryRoleByLike(role,pages);
    }

    @Override
    public int countRoleByLike(Role role){
        return roleMenuDao.countRoleByLike(role);
    }


    @Override
    public List<Role> queryRoleByEquals(Role role, Page pages){
        return roleMenuDao.queryRoleByEquals(role,pages);
    }

    @Override
    public int countRoleByEquals(Role role){
        return roleMenuDao.countRoleByEquals(role);
    }


    @Override
    public List<RoleMenu> queryRoleMenu(RoleMenu rm){
        return roleMenuDao.queryRoleMenu(rm);
    }

    @Override
    public void saveRoleMenu(int[] ids,String roleId){
        roleMenuDao.deleteRoleMenu(roleId);
        if (ids != null){
            roleMenuDao.saveRoleMenu(ids,roleId);
        }
    }

    @Override
    public List<Role> getER(Role role, String employeeId,String type, Page pages){
        return roleMenuDao.getER(role,employeeId,type,pages);
    }

    @Override
    public int countER(Role role, String employeeId,String type){
        return roleMenuDao.countER(role,employeeId,type);
    }

    @Override
    public void insertRole(Role role){
        roleMenuDao.insertRole(role);
    }


    @Override
    public void updateRole(Role role){
        roleMenuDao.updateRole(role);
    }

    @Override
    public void deleteRoles(int[] ids){
        roleMenuDao.deleteRoles(ids);
    }
}
