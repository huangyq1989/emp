package com.emp.employeeManage.service.imp;

import com.emp.employeeManage.dao.EmployeeDao;
import com.emp.employeeManage.entity.Employee;
import com.emp.employeeManage.service.EmployeeService;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PropertyUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class EmployeeServiceImp implements EmployeeService {

    @Autowired
    private EmployeeDao employeeDao;

    @Override
    public Employee queryByUserName(String userName, String password){
        return employeeDao.queryByUserName(userName,password);
    }

    @Override
    public List<Employee> queryEmployeeByLike(Employee employee, Page pages){
        return employeeDao.queryEmployeeByLike(employee,pages);
    }

    @Override
    public int countEmployeeByLike(Employee employee){
        return employeeDao.countEmployeeByLike(employee);
    }

    @Override
    public List<Employee> queryEmployeeByCheck(int[] ids){
        return employeeDao.queryEmployeeByCheck(ids);
    }

    @Override
    public void insertEmployee(Employee employee){
        employeeDao.insertEmployee(employee);
    }

    @Override
    public void updateEmployee(Employee employee){
        employeeDao.updateEmployee(employee);
    }

    @Override
    public void addER(int[] ids,String employeeId){
        employeeDao.addER(ids,employeeId);
    }

    @Override
    public void removeER(int[] ids,String employeeId){
        employeeDao.removeER(ids,employeeId);
    }


    @Override
    //读取文件把导入账号到数据库
    public Map<String,Object> importEmployee(String path) throws IOException, SQLException {
        Employee employee = null;
        List<Employee> list = (List<Employee>)(List)new ImportExcelUtils().readXlxs(path, PropertyUtil.getProperty("employee.type", "defaultValue"));
        int count = list.size(); //总导入数
        int failNum = 0;//失败数
        for (int i = 0; i < list.size(); i++) {
            employee = list.get(i);

            //校验姓名
            if(StringUtils.isBlank(employee.getRealName())){
                employee.setErrorMsg("姓名不能为空");
                failNum++;
                continue;
            }
            //校验登录名
            if(StringUtils.isBlank(employee.getUserName())){
                employee.setErrorMsg("账号不能为空");
                failNum++;
                continue;
            }else {
                //查询是否已经存在数据库
                Employee t_employee = employeeDao.queryByUserName(employee.getUserName(), null);
                if (t_employee != null) {
                    employee.setErrorMsg("账号已存在");
                    failNum++;
                    continue;
                }
            }
            //校验密码
            if(StringUtils.isBlank(employee.getPassword())){
                employee.setErrorMsg("密码不能为空");
                failNum++;
                continue;
            }else{
                if(employee.getPassword().length() < 7){
                    employee.setErrorMsg("密码必须在7-30位");
                    failNum++;
                    continue;
                }
            }
            //校验手机号码
            if(StringUtils.isBlank(employee.getPhone())){
                employee.setErrorMsg("手机号码不能为空");
                failNum++;
                continue;
            }else{
                if(!CommonUtils.isMobileNO(employee.getPhone())){
                    employee.setErrorMsg("手机号码错误");
                    failNum++;
                    continue;
                }
            }
            //校验电子邮箱
            if(!StringUtils.isBlank(employee.getEmail())){
                if(!CommonUtils.isEmail(employee.getEmail())){
                    employee.setErrorMsg("电子邮箱错误");
                    failNum++;
                    continue;
                }
            }else{
                employee.setErrorMsg("电子邮箱不能为空");
                failNum++;
                continue;
            }
            //转换'性别(0男  1女)'
            if("男".equals(employee.getTempSex())){
                employee.setSex(0);
            }else{
                employee.setSex(1);
            }
//            employeeDao.insertEmployee(employee);//创建账号,不在此保存,故注释
//            list.remove(employee);
//            i = i-1;
            employee.setErrorMsg("成功"); //没错误的学员都给个成功
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("flag", 0);//成功
        map.put("count", count);
        map.put("failNum", failNum);
        map.put("list", list);
        return map;
    }

    @Override
    public void deleteEmployees(int[] ids){
        employeeDao.deleteEmployees(ids);
    }

}
