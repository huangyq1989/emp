package com.emp.employeeManage.service;


import com.emp.employeeManage.entity.Employee;
import com.emp.systemManage.entity.Page;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface EmployeeService {

    Employee queryByUserName(String userName, String password);

    List<Employee> queryEmployeeByLike(Employee employee, Page pages);

    int countEmployeeByLike(Employee employee);

    List<Employee> queryEmployeeByCheck(int[] ids);

    void insertEmployee(Employee employee);

    void updateEmployee(Employee employee);

    void addER(int[] ids,String employeeId);

    void removeER(int[] ids,String employeeId);

    Map<String,Object> importEmployee(String path) throws IOException, SQLException ;

    void deleteEmployees(int[] ids);
}