package com.emp.estimateManage.entity;

import java.util.List;

//问卷内容
public class Questionnaire {

    //标题
    private String title;
    //(问卷类型)-0单选 1多选 2矩阵 3简答
    private Integer subjectType;
    //题目必填项(0否 1是)
    private String requiredFields;
    //行标题(只有矩阵有)[行标题1,行标题2…]
    private List<String> opt;
    //选项(简答没有)[选项1,选项2…]
    private List<String> op;
    //对应选项的是否必答(0否 1是)[1,0…]
    private List<String> mustAnswer;
    //每个选项的分数(简答没有)[对应选项…]
    private List<Integer> score;
    //限制字数(只有简答有)
    private Integer wordRestriction;
    //作答-虚拟字段
    private List<QuestionnaireAnswer> answer;
    //统计信息-虚拟字段
    private List<int[]> countMessage;
    //统计信息-有效作答人数
    private int validNum;


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getRequiredFields() {
        return requiredFields;
    }

    public void setRequiredFields(String requiredFields) {
        this.requiredFields = requiredFields;
    }

    public List<String> getOpt() {
        return opt;
    }

    public void setOpt(List<String> opt) {
        this.opt = opt;
    }

    public List<String> getOp() {
        return op;
    }

    public void setOp(List<String> op) {
        this.op = op;
    }

    public List<String> getMustAnswer() {
        return mustAnswer;
    }

    public void setMustAnswer(List<String> mustAnswer) {
        this.mustAnswer = mustAnswer;
    }

    public List<Integer> getScore() {
        return score;
    }

    public void setScore(List<Integer> score) {
        this.score = score;
    }

    public Integer getWordRestriction() {
        return wordRestriction;
    }

    public void setWordRestriction(Integer wordRestriction) {
        this.wordRestriction = wordRestriction;
    }

    public List<QuestionnaireAnswer> getAnswer() {
        return answer;
    }

    public void setAnswer(List<QuestionnaireAnswer> answer) {
        this.answer = answer;
    }

    public List<int[]> getCountMessage() {
        return countMessage;
    }

    public void setCountMessage(List<int[]> countMessage) {
        this.countMessage = countMessage;
    }

    public int getValidNum() {
        return validNum;
    }

    public void setValidNum(int validNum) {
        this.validNum = validNum;
    }

    public Integer getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(Integer subjectType) {
        this.subjectType = subjectType;
    }
}
