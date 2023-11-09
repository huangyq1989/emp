package com.emp.cultivateManage.entity;

import java.util.List;

public class CultivateNote {

    private Integer id;
    private Integer cultivateId;
    private String content;
    private Integer sendDataCode;
    private Integer sendType;
    private String sendTime;
    private String insertTime;
    private String updateTime;
    private String peopleDatail; //保存在数据库对象
    private Integer peopleNum; //发送人数
    private List<PeopleDatailList> peopleDatailList; //接收前端json对象

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCultivateId() {
        return cultivateId;
    }

    public void setCultivateId(Integer cultivateId) {
        this.cultivateId = cultivateId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getSendDataCode() {
        return sendDataCode;
    }

    public void setSendDataCode(Integer sendDataCode) {
        this.sendDataCode = sendDataCode;
    }

    public Integer getSendType() {
        return sendType;
    }

    public void setSendType(Integer sendType) {
        this.sendType = sendType;
    }

    public String getSendTime() {
        return sendTime;
    }

    public void setSendTime(String sendTime) {
        this.sendTime = sendTime;
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

    public List<PeopleDatailList> getPeopleDatailList() {
        return peopleDatailList;
    }

    public void setPeopleDatailList(List<PeopleDatailList> peopleDatailList) {
        this.peopleDatailList = peopleDatailList;
    }

    public String getPeopleDatail() {
        return peopleDatail;
    }

    public void setPeopleDatail(String peopleDatail) {
        this.peopleDatail = peopleDatail;
    }

    public Integer getPeopleNum() {
        return peopleNum;
    }

    public void setPeopleNum(Integer peopleNum) {
        this.peopleNum = peopleNum;
    }
}
