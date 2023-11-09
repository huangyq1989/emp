package com.emp.systemManage.controller;

import com.emp.employeeManage.entity.Employee;
import com.emp.systemManage.entity.Menu;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.entity.Role;
import com.emp.systemManage.entity.RoleMenu;
import com.emp.systemManage.service.imp.RoleMenuServiceImp;
import com.emp.systemManage.utils.CommonUtils;
import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/roleMenu")
public class RoleMenuController {

    private Logger logger = Logger.getLogger(RoleMenuController.class);

    @Autowired
    private RoleMenuServiceImp roleMenuServiceImp;



    //获取当前登录人菜单的json数据
    @RequestMapping(value = "/queryMenuByLogin.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryMenuByLogin(HttpServletRequest request, HttpServletResponse response,HttpSession httpSession){
        Employee e = (Employee)httpSession.getAttribute("employee");
        Map<String,Object> map = new HashMap<String,Object>();
        List<Menu> treesList = roleMenuServiceImp.getFatherNode(e.getId()+"");
        String code = treesList.size()==0?"0":"1";//0查询不到菜单
        map.put("code", code);
        map.put("menus", treesList);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //获取所有菜单json数据
    @RequestMapping(value = "/queryMenu.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryMenu(HttpServletRequest request, HttpServletResponse response){
        List<Menu> treesList = roleMenuServiceImp.getFatherNode(null);
        String jsonStr = new Gson().toJson(treesList);
        return jsonStr;
    }


    //跳转角色管理页面
    @RequestMapping(value = "/roleList.do")
    public ModelAndView roleList() {
        ModelAndView mv = new ModelAndView("employee/roleManage");
        return mv;
    }



    //获取角色json数据
    @RequestMapping(value = "/getRoles.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getRoles(HttpServletRequest request, HttpServletResponse response){
        String roleName = request.getParameter("roleName");
        Role rParam = new Role();
        if(StringUtils.isNoneBlank(roleName)){
            rParam.setRoleName(roleName);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map=new HashMap<String,Object>();
        List<Role> roles = roleMenuServiceImp.queryRoleByLike(rParam,pages);
        int total = roleMenuServiceImp.countRoleByLike(rParam);
        map.put("total", total);
        map.put("rows", roles);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //获取角色所拥有的权限json数据
    @RequestMapping(value = "/getRoleMenus.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getRoleMenus(HttpServletRequest request, HttpServletResponse response){
        String roleId = request.getParameter("roleId");
        RoleMenu rm = new RoleMenu();
        if(StringUtils.isNoneBlank(roleId)){
            rm.setRoleId(Integer.valueOf(roleId));
        }
        Map<String,Object> map=new HashMap<String,Object>();
        List<RoleMenu> rms = roleMenuServiceImp.queryRoleMenu(rm);
        map.put("detail", rms);
        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //保存角色权限
    @RequestMapping(value = "/saveRoleMenu.do")
    @ResponseBody
    public String saveRoleMenu(String[] arr,HttpServletRequest request, HttpServletResponse response){
        try{
            String roleId = request.getParameter("roleId");
            int[] ids = arr==null?null:CommonUtils.stringArrayToIntArray(arr);
            roleMenuServiceImp.saveRoleMenu(ids,roleId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //获取人员已有或未有的角色列表
    @RequestMapping(value = "/getER.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getER(HttpServletRequest request, HttpServletResponse response){
        String roleName = request.getParameter("roleName");
        String type = request.getParameter("type");
        String employeeId = request.getParameter("employeeId");
        Role rParam = new Role();
        if(StringUtils.isNoneBlank(roleName)){
            rParam.setRoleName(roleName);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map=new HashMap<String,Object>();
        List<Role> students = roleMenuServiceImp.getER(rParam,employeeId,type,pages);
        int total = roleMenuServiceImp.countER(rParam,employeeId,type);
        map.put("total", total);
        map.put("rows", students);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到新增或修改角色(包括权限)页面
    @RequestMapping(value = "/editRoleMenu.do")
    public ModelAndView editRoleMenu(HttpServletRequest request, HttpServletResponse response){
        String roleId = request.getParameter("roleId");
        ModelAndView mv = new ModelAndView("employee/editRoleMenu");
        if(StringUtils.isBlank(roleId)){
            mv.addObject("title","添加权限");
        }else{
            mv.addObject("title","修改权限");
            Role rParam = new Role();
            rParam.setId(Integer.valueOf(roleId));
            Role role = roleMenuServiceImp.queryRoleByEquals(rParam,null).get(0);
            mv.addObject("roleId",roleId);
            mv.addObject("role",role);
        }
        return mv;
    }


    // 新增或修改角色
    @RequestMapping(value = "/addOrEdit.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String addOrEdit(@ModelAttribute Role role, HttpServletRequest request, HttpServletResponse response){
        String type = request.getParameter("type");
        Map<String,Object> map = new HashMap<String,Object>();
        String roleName = role.getRoleName();
        Role rParam = new Role();
        if(StringUtils.isNoneBlank(roleName)){
            rParam.setRoleName(roleName);
        }
        List<Role> role1 = roleMenuServiceImp.queryRoleByEquals(rParam,null);
        if("0".equals(type)){//新增
            if(role1.size() != 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：角色已存在!");
            }else{
                map.put("rCode", 0);
                roleMenuServiceImp.insertRole(role);
                map.put("returnRoleId", role.getId());
                map.put("detail", "添加角色成功");
            }
        }else{//修改
            int roleId = role.getId();
            Role rParam2 = new Role();
            rParam2.setId(roleId);
            List<Role> role2 = roleMenuServiceImp.queryRoleByEquals(rParam2,null);
            if(role2.size() == 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：该角色已不存在!");
            }else{
                if(role1.size() == 0 || role1.get(0).getId().equals(role2.get(0).getId())){
                    map.put("rCode", 0);
                    roleMenuServiceImp.updateRole(role);
                    map.put("detail", "修改角色成功");
                }else{
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：已有同名的角色!");
                }
            }
        }
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //批量删除角色
    @RequestMapping(value = "/deleteRoles.do")
    @ResponseBody
    public String deleteRoles(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            roleMenuServiceImp.deleteRoles(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }
}