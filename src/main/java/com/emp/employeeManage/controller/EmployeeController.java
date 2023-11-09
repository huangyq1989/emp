package com.emp.employeeManage.controller;


import com.emp.employeeManage.entity.Employee;
import com.emp.employeeManage.service.imp.EmployeeServiceImp;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PropertyUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
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
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/employee")
public class EmployeeController {

    private Logger logger = Logger.getLogger(EmployeeController.class);

    @Autowired
    private EmployeeServiceImp employeeServiceImp;


    //跳转管理员账号页面
    @RequestMapping(value = "/employeeList.do")
    public ModelAndView studentList(){
        ModelAndView mv = new ModelAndView("employee/employeeManage");
        return mv;
    }


    //获取账号json数据
    @RequestMapping(value = "/getEmployees.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getEmployees(HttpServletRequest request, HttpServletResponse response){
        String realName = request.getParameter("realName");
        String userName = request.getParameter("userName");
        String phone = request.getParameter("phone");
        Employee sParam = new Employee();
        if(StringUtils.isNoneBlank(realName)){
            sParam.setRealName(realName);
        }
        if(StringUtils.isNoneBlank(userName)){
            sParam.setUserName(userName);
        }
        if(StringUtils.isNoneBlank(phone)){
            sParam.setPhone(phone);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object>map=new HashMap<String,Object>();
        List<Employee> employees = employeeServiceImp.queryEmployeeByLike(sParam,pages);
        int total = employeeServiceImp.countEmployeeByLike(sParam);
        map.put("total", total);
        map.put("rows", employees);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到新增和修改页面
    @RequestMapping(value = "/addEmployee.do")
    public ModelAndView addEmployee(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        ModelAndView mv = null;
        if(StringUtils.isBlank(id)){
            mv = new ModelAndView("employee/addEmployee");
            mv.addObject("title","添加账号");
        }else{
            mv = new ModelAndView("employee/updateEmployee");
            Employee eParam = new Employee();
            eParam.setId(Integer.valueOf(id));
            eParam = employeeServiceImp.queryEmployeeByLike(eParam,null).get(0);
            mv.addObject("title","修改账号");
            mv.addObject("employeeM",eParam);
        }
        return mv;
    }


    // 新增或修改账号
    @RequestMapping(value = "/addOrEdit.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String addOrEdit(@ModelAttribute Employee employeeM, HttpServletRequest request, HttpServletResponse response){
        String type = request.getParameter("type");
        Map<String,Object> map = new HashMap<String,Object>();
        String userName = employeeM.getUserName();
        Employee employee = employeeServiceImp.queryByUserName(userName,null);
        if("0".equals(type)){//新增
            if(employee != null){
                map.put("rCode", 1);
                map.put("detail", "错误提示：登录名已存在!");
            }else{
                employeeServiceImp.insertEmployee(employeeM);
                String employeeId = employeeM.getId()+"";
                if(StringUtils.isBlank(employeeId)){
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：添加账号失败");
                }else{
                    map.put("rCode", 0);
                    map.put("detail", "添加账号成功");
                    if(!StringUtils.isBlank(employeeM.getRoleData())){//添加角色
                        //String类型的json数组转int数组
                        ArrayList<String> list = new ArrayList<>();
                        Type listType = new TypeToken<List<String>>() {}.getType();
                        list = new Gson().fromJson(employeeM.getRoleData(), listType);
                        int[] i_list = new int[list.size()];
                        for(int i=0;i<list.size();i++){
                            i_list[i] = Integer.valueOf(list.get(i));
                        }
                        employeeServiceImp.addER(i_list,employeeId);
                    }
                }
            }
        }else{//修改
            int employeeId = employeeM.getId();
            Employee eParam = new Employee();
            eParam.setId(employeeId);
            List<Employee> employee2 = employeeServiceImp.queryEmployeeByLike(eParam,null);
            if(employee2.size() == 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：该账号已不存在!");
            }else{
                if(employee == null || employee.getId() == employee2.get(0).getId()){
                    map.put("rCode", 0);
                    employeeServiceImp.updateEmployee(employeeM);
                    map.put("detail", "修改账号成功");
                }else{
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：登录名已存在");
                }
            }
        }
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //跳转到新增和修改页面
    @RequestMapping(value = "/treeEmployee.do")
    public ModelAndView treeEmployee(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("employee/treeEmployee");
        return mv;
    }


    //跳转到配置角色页面
    @RequestMapping(value = "/toEditER.do")
    public ModelAndView toEditER(HttpServletRequest request, HttpServletResponse response) {
        String employeeId = request.getParameter("employeeId");
        String type = request.getParameter("type");
        ModelAndView mv = mv = new ModelAndView("employee/editER");
        mv.addObject("type",type);
        mv.addObject("employeeId",employeeId);
        return mv;
    }


    //配置角色
    @RequestMapping(value = "/addER.do")
    @ResponseBody
    public String addER(String[] arr,HttpServletRequest request, HttpServletResponse response){
        try{
            String employeeId = request.getParameter("employeeId");
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            employeeServiceImp.addER(ids,employeeId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }

    //移除角色
    @RequestMapping(value = "/removeER.do")
    @ResponseBody
    public String removeER(String[] arr,HttpServletRequest request, HttpServletResponse response){
        try{
            String employeeId = request.getParameter("employeeId");
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            employeeServiceImp.removeER(ids,employeeId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //跳转到导入页面
    @RequestMapping(value = "/importEmployee.do")
    public ModelAndView importEmployee(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("employee/importEmployee");
        return mv;
    }



    //批量保存账号(导入保存)
    @RequestMapping(value = "/saveImportData.do")
    @ResponseBody
    public String saveImportData(String sendData, HttpServletRequest request, HttpServletResponse response){
        try {
            //转List对象
            ArrayList<Employee> employees = new ArrayList<Employee>();
            Type listType = new TypeToken<List<Employee>>() {
            }.getType();
            employees = new Gson().fromJson(sendData, listType);
            for (Employee e : employees) {
                //查询是否已经存在数据库
                Employee t_employee = employeeServiceImp.queryByUserName(e.getUserName(), null);
                if (t_employee == null) {
                    employeeServiceImp.insertEmployee(e);
                }
            }
            return "0";
        }catch (Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //导出
    @RequestMapping(value = "/exportEmployee.do")
    public void exportEmployee(String[] arr,HttpServletRequest request, HttpServletResponse response){
        List<Employee> employees = null ;
        if(arr != null && arr.length != 0){//根据勾选进行导出
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            employees = employeeServiceImp.queryEmployeeByCheck(ids);
        }else{//根据查询条件进行导出
            String realName = request.getParameter("realName");
            String userName = request.getParameter("userName");
            String phone = request.getParameter("phone");
            Employee sParam = new Employee();
            if(StringUtils.isNoneBlank(realName)){
                sParam.setRealName(realName);
            }
            if(StringUtils.isNoneBlank(userName)){
                sParam.setUserName(userName);
            }
            if(StringUtils.isNoneBlank(phone)){
                sParam.setPhone(phone);
            }
            employees = employeeServiceImp.queryEmployeeByLike(sParam,null);
        }
        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(employees, PropertyUtil.getProperty("employee.type", "defaultValue"),"账号信息表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    //批量删除账号
    @RequestMapping(value = "/deleteEmployees.do")
    @ResponseBody
    public String deleteEmployees(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            employeeServiceImp.deleteEmployees(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //跳转到修改个人信息页面
    @RequestMapping(value = "/editPersonal.do")
    public ModelAndView editPersonal(HttpServletRequest request, HttpServletResponse response, HttpSession httpSession){
        ModelAndView mv = new ModelAndView("employee/editPersonal");
        Employee eParam = (Employee)httpSession.getAttribute("employee");
        Employee t_Param = new Employee();
        if(0 != eParam.getId()){
            t_Param.setId(eParam.getId());
            //再查询是因为session不是即时更新
            eParam = employeeServiceImp.queryEmployeeByLike(t_Param,null).get(0);
        }
        mv.addObject("title","修改个人信息");
        mv.addObject("employeeM",eParam);
        return mv;
    }
}
