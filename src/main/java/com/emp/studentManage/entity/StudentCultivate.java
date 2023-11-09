package com.emp.studentManage.entity;

/** 学员培训视图 */
public class StudentCultivate {

    private String no;//存放临时序号,数据库没此字段
    private String studentId; //学号
    private String realName;//姓名
    private String idCard; //身份证
    private String unit; //单位
    private String cultivateId; //培训ID
    private String cultivateName; //培训名称
    private String cultivateType; //培训类型
    private String cultivateDataCode; //培训状态(0未开始  1进行中  2已结束)
    private String beginTime; //培训开始时间
    private String endTime; //培训结束时间

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getCultivateId() {
        return cultivateId;
    }

    public void setCultivateId(String cultivateId) {
        this.cultivateId = cultivateId;
    }

    public String getCultivateName() {
        return cultivateName;
    }

    public void setCultivateName(String cultivateName) {
        this.cultivateName = cultivateName;
    }

    public String getCultivateDataCode() {
        return cultivateDataCode;
    }

    public void setCultivateDataCode(String cultivateDataCode) {
        this.cultivateDataCode = cultivateDataCode;
    }

    public String getBeginTime() {
        return beginTime;
    }

    public void setBeginTime(String beginTime) {
        this.beginTime = beginTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getCultivateType() {
        return cultivateType;
    }

    public void setCultivateType(String cultivateType) {
        this.cultivateType = cultivateType;
    }
}
