package com.emp.examinationManage.entity;

public class ExaminationStudent {

    private Integer id;
    private Integer examinationId;
    private Integer cultivateId;
    private Integer studentId;
    private String insertTime;
    private String updateTime;
    private String openTime;
    private String closeTime;
    private Integer stuMakeUpNum;
    private String score;
    private Integer isPassing;
    private Integer examinationCode;
    /**
     * 其余字段参考 QuestionnaireEstimate 类的content注释,只多了个多了"answer": [1, 4],另外这个是json数组,可以有多个,所有下标都是从1开始
     * 1和4代表选择了1和4选择,可以只有一个
     * */
    private String answer;
    private String certificateNo;
    private String certificateTime;
    private String willCloseTime;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(Integer examinationId) {
        this.examinationId = examinationId;
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

    public Integer getExaminationCode() {
        return examinationCode;
    }

    public void setExaminationCode(Integer examinationCode) {
        this.examinationCode = examinationCode;
    }

    public String getOpenTime() {
        return openTime;
    }

    public void setOpenTime(String openTime) {
        this.openTime = openTime;
    }

    public String getCloseTime() {
        return closeTime;
    }

    public void setCloseTime(String closeTime) {
        this.closeTime = closeTime;
    }

    public Integer getStuMakeUpNum() {
        return stuMakeUpNum;
    }

    public void setStuMakeUpNum(Integer stuMakeUpNum) {
        this.stuMakeUpNum = stuMakeUpNum;
    }

    public Integer getIsPassing() {
        return isPassing;
    }

    public void setIsPassing(Integer isPassing) {
        this.isPassing = isPassing;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getCertificateNo() {
        return certificateNo;
    }

    public void setCertificateNo(String certificateNo) {
        this.certificateNo = certificateNo;
    }

    public String getCertificateTime() {
        return certificateTime;
    }

    public void setCertificateTime(String certificateTime) {
        this.certificateTime = certificateTime;
    }

    public String getWillCloseTime() {
        return willCloseTime;
    }

    public void setWillCloseTime(String willCloseTime) {
        this.willCloseTime = willCloseTime;
    }
}
