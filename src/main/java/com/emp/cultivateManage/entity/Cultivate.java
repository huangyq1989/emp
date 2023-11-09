package com.emp.cultivateManage.entity;

public class Cultivate {

    private Integer id;
    private String cultivateName;
    private String cultivateType;
    private String beginTime;
    private String endTime;
    private Integer cultivateNum;//培训人数,数据库不存在改字段
    private Integer cultivateDataCode;
    private Integer status;
    private String insertTime;
    private String updateTime;
    private String guideText;
    private String sendData;//学员数据(新增培训的时候用到),数据库不存在改字段

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
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

    public Integer getCultivateNum() {
        return cultivateNum;
    }

    public void setCultivateNum(Integer cultivateNum) {
        this.cultivateNum = cultivateNum;
    }

    public Integer getCultivateDataCode() {
        return cultivateDataCode;
    }

    public void setCultivateDataCode(Integer cultivateDataCode) {
        this.cultivateDataCode = cultivateDataCode;
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

    public String getSendData() {
        return sendData;
    }

    public void setSendData(String sendData) {
        this.sendData = sendData;
    }

    public String getGuideText() {
        return guideText;
    }

    public void setGuideText(String guideText) {
        this.guideText = guideText;
    }
}
