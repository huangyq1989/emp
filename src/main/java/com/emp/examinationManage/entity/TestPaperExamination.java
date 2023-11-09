package com.emp.examinationManage.entity;


//试卷
public class TestPaperExamination {

    private Integer id;
    /**
     * 试题内容(title-标题,
     * subjectType(考题类型)-0单选 1多选 2判断,
     * scoreType(得分类型,只有多选有)-0少选得部分分 1少选不得分,
     * score-单题分数,
     * trueAnswer-正确答案[对应op的选项,从1开始],
     * op-[数组类型-选项内容])'
     * */
    private String content;
    private Integer examinationId;
    private Integer status;
    private String insertTime;
    private String updateTime;
    private Integer isPublish;
    private Integer examinationCode;
    private Float totalScore;

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

    public Integer getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(Integer examinationId) {
        this.examinationId = examinationId;
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

    public Integer getExaminationCode() {
        return examinationCode;
    }

    public void setExaminationCode(Integer examinationCode) {
        this.examinationCode = examinationCode;
    }

    public Float getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Float totalScore) {
        this.totalScore = totalScore;
    }
}
