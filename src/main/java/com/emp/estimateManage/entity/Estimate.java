package com.emp.estimateManage.entity;

public class Estimate {

    private Integer id;
    private String estimateName;
    private String estimateBeginTime;
    private String estimateEndTime;
    private Integer estimateDataCode;
    private Integer status;
    private Integer cultivateId;
    private Integer answerLimitNum;
    private String questionnaireData;//试卷数据,新增考试的时候用来传递参数
    private String cultivateName;//引用Cultivate类的字段
    private String cultivateType;//引用Cultivate类的字段
    private String beginTime;//引用Cultivate类的字段
    private String endTime;//引用Cultivate类的字段
    private String insertTime;
    private String updateTime;
    private Integer estimateCode;//引用 tb_estimate_student的字段 评估状态(0未提交 2已提交)
    private Integer isPublish; //引用问卷表的是否发布

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEstimateName() {
        return estimateName;
    }

    public void setEstimateName(String estimateName) {
        this.estimateName = estimateName;
    }

    public Integer getEstimateDataCode() {
        return estimateDataCode;
    }

    public void setEstimateDataCode(Integer estimateDataCode) {
        this.estimateDataCode = estimateDataCode;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getCultivateId() {
        return cultivateId;
    }

    public void setCultivateId(Integer cultivateId) {
        this.cultivateId = cultivateId;
    }

    public String getCultivateName() {
        return cultivateName;
    }

    public void setCultivateName(String cultivateName) {
        this.cultivateName = cultivateName;
    }

    public String getCultivateType() {
        return cultivateType;
    }

    public void setCultivateType(String cultivateType) {
        this.cultivateType = cultivateType;
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

    public String getEstimateBeginTime() {
        return estimateBeginTime;
    }

    public void setEstimateBeginTime(String estimateBeginTime) {
        this.estimateBeginTime = estimateBeginTime;
    }

    public String getEstimateEndTime() {
        return estimateEndTime;
    }

    public void setEstimateEndTime(String estimateEndTime) {
        this.estimateEndTime = estimateEndTime;
    }

    public String getQuestionnaireData() {
        return questionnaireData;
    }

    public void setQuestionnaireData(String questionnaireData) {
        this.questionnaireData = questionnaireData;
    }

    public Integer getAnswerLimitNum() {
        return answerLimitNum;
    }

    public void setAnswerLimitNum(Integer answerLimitNum) {
        this.answerLimitNum = answerLimitNum;
    }

    public Integer getEstimateCode() {
        return estimateCode;
    }

    public void setEstimateCode(Integer estimateCode) {
        this.estimateCode = estimateCode;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }
}
