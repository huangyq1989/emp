package com.emp.studentManage.entity;

/** 学员考试视图 */
public class StudentExamination {

    private String studentId; //学号
    private String realName;//姓名
    private String idCard; //身份证号码
    private String unit; //单位
    private String department;//部门
    private String job;//职业
    private String phone;//手机
    private String cultivateId; //培训ID
    private String cultivateName;//培训名称
    private String examinationId; //考试ID
    private String examinationDataCode; //考试状态(0未开始  1进行中  2已结束),这个状态是manager表的
    private String examinationCode; //考试状态(0未考试  1考试中  2已交卷)
    private String examinationTime; //考试开始时间
    private String examinationEndTime; //考试结束时间
    private String openTime;//打开试卷时间
    private String closeTime;//交卷时间
    private Integer isPassing;//是否及格 0否 1是
    private String score; //考试分数
    private Integer stuMakeUpNum; //补考次数
    private Integer isRelease;//是否已发布成绩 0否 1是
    private String releaseTime;//发布成绩时间
    private String certificateNo;  //证书编号
    private String certificateTime;  //发证时间
    private Integer residueNum; //剩余补考次数
    private Integer isPublish; //是否已发布试卷 0否 1是
    private String content; //试题内容
    private String makeupBeginTime; //补考开始时间
    private String makeupTime; //补考最后期限
    private Float totalScore; //总分
    private Integer passingScoreLine;//及格分数线
    private String examinationTimeLimit;//考试时限
    private Integer timingMode; //计时方式(0:考试时间开始计时  1:打开试卷时间计时)
    private Integer isResit;//是否需要补考(0否 1是)
    private Integer isDisorder;//试题和选项乱序(0否  1是)
    private Integer isCertificateNo;//证书发布状态(0未发布 1已发布)
    private String certificateNoTime;//证书发布时间
    private Integer isAnswerAnalysis;//是否开放答题解析(0否 1是)
    private String answer;//学员交卷的内容
    private String willCloseTime; //预计关闭试卷时间



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

    public String getExaminationId() {
        return examinationId;
    }

    public void setExaminationId(String examinationId) {
        this.examinationId = examinationId;
    }

    public String getExaminationCode() {
        return examinationCode;
    }

    public void setExaminationCode(String examinationCode) {
        this.examinationCode = examinationCode;
    }

    public String getExaminationTime() {
        return examinationTime;
    }

    public void setExaminationTime(String examinationTime) {
        this.examinationTime = examinationTime;
    }

    public String getOpenTime() {
        return openTime;
    }

    public void setOpenTime(String openTime) {
        this.openTime = openTime;
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

    public Integer getStuMakeUpNum() {
        return stuMakeUpNum;
    }

    public void setStuMakeUpNum(Integer stuMakeUpNum) {
        this.stuMakeUpNum = stuMakeUpNum;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getIsRelease() {
        return isRelease;
    }

    public void setIsRelease(Integer isRelease) {
        this.isRelease = isRelease;
    }

    public String getCultivateName() {
        return cultivateName;
    }

    public void setCultivateName(String cultivateName) {
        this.cultivateName = cultivateName;
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

    public Integer getResidueNum() {
        return residueNum;
    }

    public void setResidueNum(Integer residueNum) {
        this.residueNum = residueNum;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getMakeupTime() {
        return makeupTime;
    }

    public void setMakeupTime(String makeupTime) {
        this.makeupTime = makeupTime;
    }

    public Float getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Float totalScore) {
        this.totalScore = totalScore;
    }

    public Integer getPassingScoreLine() {
        return passingScoreLine;
    }

    public void setPassingScoreLine(Integer passingScoreLine) {
        this.passingScoreLine = passingScoreLine;
    }

    public String getExaminationTimeLimit() {
        return examinationTimeLimit;
    }

    public void setExaminationTimeLimit(String examinationTimeLimit) {
        this.examinationTimeLimit = examinationTimeLimit;
    }

    public Integer getTimingMode() {
        return timingMode;
    }

    public void setTimingMode(Integer timingMode) {
        this.timingMode = timingMode;
    }

    public Integer getIsResit() {
        return isResit;
    }

    public void setIsResit(Integer isResit) {
        this.isResit = isResit;
    }

    public String getExaminationDataCode() {
        return examinationDataCode;
    }

    public void setExaminationDataCode(String examinationDataCode) {
        this.examinationDataCode = examinationDataCode;
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

    public String getCloseTime() {
        return closeTime;
    }

    public void setCloseTime(String closeTime) {
        this.closeTime = closeTime;
    }

    public Integer getIsCertificateNo() {
        return isCertificateNo;
    }

    public void setIsCertificateNo(Integer isCertificateNo) {
        this.isCertificateNo = isCertificateNo;
    }

    public Integer getIsAnswerAnalysis() {
        return isAnswerAnalysis;
    }

    public void setIsAnswerAnalysis(Integer isAnswerAnalysis) {
        this.isAnswerAnalysis = isAnswerAnalysis;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getWillCloseTime() {
        return willCloseTime;
    }

    public void setWillCloseTime(String willCloseTime) {
        this.willCloseTime = willCloseTime;
    }

    public String getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(String releaseTime) {
        this.releaseTime = releaseTime;
    }

    public String getCertificateNoTime() {
        return certificateNoTime;
    }

    public void setCertificateNoTime(String certificateNoTime) {
        this.certificateNoTime = certificateNoTime;
    }
}