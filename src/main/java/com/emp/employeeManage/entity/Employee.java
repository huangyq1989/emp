package com.emp.employeeManage.entity;

public class Employee {

    private int id;
    private String userName;
    private String password;
    private String realName;
    private int status;
    private String phone;
    private String email;
    private int sex;
    private String insertTime;
    private String updateTime;
    private String roleData;//角色数据(新增账号的时候用到),数据库不存在改字段
    private String no;//存放临时序号,数据库没此字段
    private String tempSex;//存放中文性别,数据库没此字段
    private String errorMsg;//导入失败原因,数据库没此字段

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getSex() {
        return sex;
    }

    public void setSex(int sex) {
        this.sex = sex;
    }

    public String getInsertTime() {
        return insertTime;
    }

    public void setInsertTime(String insertTime) {
        this.insertTime = insertTime;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getTempSex() {
        return tempSex;
    }

    public void setTempSex(String tempSex) {
        this.tempSex = tempSex;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public String getRoleData() {
        return roleData;
    }

    public void setRoleData(String roleData) {
        this.roleData = roleData;
    }
}
