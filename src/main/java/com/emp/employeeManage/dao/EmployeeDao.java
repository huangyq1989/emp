package com.emp.employeeManage.dao;


import com.emp.employeeManage.entity.Employee;
import com.emp.systemManage.entity.Page;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmployeeDao {

    Employee queryByUserName(@Param("userName") String userName, @Param("password") String password);

    List<Employee> queryEmployeeByLike(@Param("employee") Employee employee, @Param("pages") Page pages);

    int countEmployeeByLike(@Param("employee") Employee employee);

    List<Employee> queryEmployeeByCheck(@Param("ids")int[] ids);

    void insertEmployee(Employee employee);

    void updateEmployee(@Param("employee") Employee employee);

    void addER(@Param("ids")int[] ids,@Param("employeeId") String employeeId);

    void removeER(@Param("ids")int[] ids,@Param("employeeId") String employeeId);

    void deleteEmployees(@Param("ids")int[] ids);
}
