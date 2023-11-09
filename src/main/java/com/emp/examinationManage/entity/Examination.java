package com.emp.examinationManage.entity;


public class Examination {

    private Integer id;
    private String examinationName;
    private String examinationTime;
    private String examinationEndTime;
    private String examinationTimeLimit;
    private Integer examinationDataCode;
    private Integer makeupNum;
    private String makeupBeginTime;
    private String makeupTime;
    private Integer passingScoreLine;
    private Integer timingMode;
    private Integer examinationNum; //应该考试人数-统计考试学员中间表类的字段,数据库没有该字段
    private Integer alreadyExaminationNum; //实际考试人数-统计考试学员中间表类的字段,数据库没有该字段
    private Integer passingNum; //及格人数-统计考试学员中间表类的字段,数据库没有该字段
    private Integer needMakeUpNum; //需要补考人数-统计考试学员中间表类的字段,数据库没有该字段
    private Integer alreadyMakeUpNum; //已补考人数-统计考试学员中间表类的字段,数据库没有该字段
    private Integer status;
    private String insertTime;
    private String updateTime;
    private Integer cultivateId;
    private Integer isRelease;
    private String releaseTime;
    private Integer isResit;
    private Integer isDisorder;
    private Integer isCertificateNo;
    private String certificateNoTime;
    private Integer isAnswerAnalysis;
    private String testPaperData;//试卷数据,新增考试的时候用来传递参数
    private String cultivateName;//引用Cultivate类的字段
    private String cultivateType;//引用Cultivate类的字段
    private String beginTime;//引用Cultivate类的字段
    private String endTime;//引用Cultivate类的字段
    private Integer isPublish; //引用试卷表字段


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getExaminationName() {
        return examinationName;
    }

    public void setExaminationName(String examinationName) {
        this.examinationName = examinationName;
    }

    public String getExaminationTime() {
        return examinationTime;
    }

    public void setExaminationTime(String examinationTime) {
        this.examinationTime = examinationTime;
    }

    public String getExaminationTimeLimit() {
        return examinationTimeLimit;
    }

    public void setExaminationTimeLimit(String examinationTimeLimit) {
        this.examinationTimeLimit = examinationTimeLimit;
    }

    public Integer getExaminationDataCode() {
        return examinationDataCode;
    }

    public void setExaminationDataCode(Integer examinationDataCode) {
        this.examinationDataCode = examinationDataCode;
    }

    public Integer getMakeupNum() {
        return makeupNum;
    }

    public void setMakeupNum(Integer makeupNum) {
        this.makeupNum = makeupNum;
    }

    public String getMakeupTime() {
        return makeupTime;
    }

    public void setMakeupTime(String makeupTime) {
        this.makeupTime = makeupTime;
    }

    public Integer getPassingScoreLine() {
        return passingScoreLine;
    }

    public void setPassingScoreLine(Integer passingScoreLine) {
        this.passingScoreLine = passingScoreLine;
    }

    public Integer getTimingMode() {
        return timingMode;
    }

    public void setTimingMode(Integer timingMode) {
        this.timingMode = timingMode;
    }

    public Integer getExaminationNum() {
        return examinationNum;
    }

    public void setExaminationNum(Integer examinationNum) {
        this.examinationNum = examinationNum;
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

    public String getTestPaperData() {
        return testPaperData;
    }

    public void setTestPaperData(String testPaperData) {
        this.testPaperData = testPaperData;
    }

    public Integer getPassingNum() {
        return passingNum;
    }

    public void setPassingNum(Integer passingNum) {
        this.passingNum = passingNum;
    }

    public Integer getIsRelease() {
        return isRelease;
    }

    public void setIsRelease(Integer isRelease) {
        this.isRelease = isRelease;
    }

    public Integer getIsResit() {
        return isResit;
    }

    public void setIsResit(Integer isResit) {
        this.isResit = isResit;
    }

    public String getExaminationEndTime() {
        return examinationEndTime;
    }

    public void setExaminationEndTime(String examinationEndTime) {
        this.examinationEndTime = examinationEndTime;
    }

    public String getMakeupBeginTime() {
        return makeupBeginTime;
    }

    public void setMakeupBeginTime(String makeupBeginTime) {
        this.makeupBeginTime = makeupBeginTime;
    }

    public Integer getIsDisorder() {
        return isDisorder;
    }

    public void setIsDisorder(Integer isDisorder) {
        this.isDisorder = isDisorder;
    }

    public Integer getAlreadyExaminationNum() {
        return alreadyExaminationNum;
    }

    public void setAlreadyExaminationNum(Integer alreadyExaminationNum) {
        this.alreadyExaminationNum = alreadyExaminationNum;
    }

    public Integer getNeedMakeUpNum() {
        return needMakeUpNum;
    }

    public void setNeedMakeUpNum(Integer needMakeUpNum) {
        this.needMakeUpNum = needMakeUpNum;
    }

    public Integer getAlreadyMakeUpNum() {
        return alreadyMakeUpNum;
    }

    public void setAlreadyMakeUpNum(Integer alreadyMakeUpNum) {
        this.alreadyMakeUpNum = alreadyMakeUpNum;
    }

    public String getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(String releaseTime) {
        this.releaseTime = releaseTime;
    }

    public Integer getIsCertificateNo() {
        return isCertificateNo;
    }

    public void setIsCertificateNo(Integer isCertificateNo) {
        this.isCertificateNo = isCertificateNo;
    }

    public String getCertificateNoTime() {
        return certificateNoTime;
    }

    public void setCertificateNoTime(String certificateNoTime) {
        this.certificateNoTime = certificateNoTime;
    }

    public Integer getIsAnswerAnalysis() {
        return isAnswerAnalysis;
    }

    public void setIsAnswerAnalysis(Integer isAnswerAnalysis) {
        this.isAnswerAnalysis = isAnswerAnalysis;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }
}
