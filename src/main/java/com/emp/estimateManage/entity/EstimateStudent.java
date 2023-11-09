package com.emp.estimateManage.entity;

import java.util.List;

public class EstimateStudent {

    private Integer id;
    private Integer estimateId;
    private Integer cultivateId;
    private Integer studentId;
    private String insertTime;
    private String updateTime;
    private Integer estimateCode;
    private String estimateTime;
    /**
     * 其余字段参考 TestPaperExamination 类的content注释,只多了个answer":[{"c_opt":"","c_op":2,"c_detail":""}],另外这个是json数组,可以有多个,所有下标都是从1开始
     * c_opt代表行标题(只有矩阵有),
     * c_op代表第几个选项,
     * c_detail如果是必答这里是必答内容
     */
    private String answer;
    private Integer answerNum;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getEstimateId() {
        return estimateId;
    }

    public void setEstimateId(Integer estimateId) {
        this.estimateId = estimateId;
    }

    public Integer getCultivateId() {
        return cultivateId;
    }

    public void setCultivateId(Integer cultivateId) {
        this.cultivateId = cultivateId;
    }

    public Integer getStudentId() {
        return studentId;
    }

    public void setStudentId(Integer studentId) {
        this.studentId = studentId;
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

    public Integer getEstimateCode() {
        return estimateCode;
    }

    public void setEstimateCode(Integer estimateCode) {
        this.estimateCode = estimateCode;
    }

    public String getEstimateTime() {
        return estimateTime;
    }

    public void setEstimateTime(String estimateTime) {
        this.estimateTime = estimateTime;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Integer getAnswerNum() {
        return answerNum;
    }

    public void setAnswerNum(Integer answerNum) {
        this.answerNum = answerNum;
    }
}
