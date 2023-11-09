package com.emp.estimateManage.entity;

//问卷
public class QuestionnaireEstimate {

    private Integer id;
    /*
    * 问卷内容(title-标题,subjectType-0单选 1多选 2矩阵 3简答,
    * requiredFields-必填项(0否 1是),
    * opt-行标题(只有矩阵有)[行标题1,行标题2…],
    * op-选项(简答没有)[选项1,选项2…],
    * mustAnswer-对应选项的是否必答(0否 1是)[1,0…],
    * score-每个选项的分数(简答没有)[对应选项…],
    * wordRestriction-限制字数(只有简答有))
    * */
    private String content;
    private Integer estimateId;
    private Integer status;
    private String insertTime;
    private String updateTime;
    private Integer isPublish;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getEstimateId() {
        return estimateId;
    }

    public void setEstimateId(Integer estimateId) {
        this.estimateId = estimateId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }
}
