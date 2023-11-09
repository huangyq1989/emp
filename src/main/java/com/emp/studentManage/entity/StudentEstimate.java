package com.emp.studentManage.entity;

/** 学员评估视图 */
public class StudentEstimate {

    private String studentId; //学号
    private String realName;//姓名
    private String idCard; //身份证
    private String unit; //单位
    private String department;//部门
    private String job;//职业
    private String cultivateId; //培训ID
    private String estimateId; //评估ID
    private String estimateCode; //评估状态(0未提交 2已提交)
    private String estimateTime; //评估时间
    private String answer; //评估答卷信息
    private String content; //问卷内容
    private Integer isPublish; //是否已发布问卷 0否 1是
    private String estimateDataCode; //评估状态(0未开始  1进行中  2已结束),这个状态是manager表的
    private Integer answerLimitNum; //作答次数限制(不填为无限制)
    private Integer answerNum; //作答次数

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

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getCultivateId() {
        return cultivateId;
    }

    public void setCultivateId(String cultivateId) {
        this.cultivateId = cultivateId;
    }

    public String getEstimateId() {
        return estimateId;
    }

    public void setEstimateId(String estimateId) {
        this.estimateId = estimateId;
    }

    public String getEstimateCode() {
        return estimateCode;
    }

    public void setEstimateCode(String estimateCode) {
        this.estimateCode = estimateCode;
    }

    public String getEstimateTime() {
        return estimateTime;
    }

    public void setEstimateTime(String estimateTime) {
        this.estimateTime = estimateTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }

    public String getEstimateDataCode() {
        return estimateDataCode;
    }

    public void setEstimateDataCode(String estimateDataCode) {
        this.estimateDataCode = estimateDataCode;
    }

    public Integer getAnswerLimitNum() {
        return answerLimitNum;
    }

    public void setAnswerLimitNum(Integer answerLimitNum) {
        this.answerLimitNum = answerLimitNum;
    }

    public Integer getAnswerNum() {
        return answerNum;
    }

    public void setAnswerNum(Integer answerNum) {
        this.answerNum = answerNum;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }
}