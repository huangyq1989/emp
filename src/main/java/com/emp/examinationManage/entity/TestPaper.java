package com.emp.examinationManage.entity;

import java.util.List;

//试题内容
public class TestPaper {

    //标题
    private String title;
    //(考题类型)-0单选 1多选 2判断
    private Integer subjectType;
    //(得分类型,只有多选有)-0少选得部分分  1少选不得分
    private Integer scoreType;
    //单题分数
    private Double score;
    //选项内容
    private List<String> op;
    //正确答案-对应op的选项,从1开始
    private List<String> trueAnswer;
    //答题解析
    private String answerAnalysis;
    //虚拟字段-作答信息
    private List<String> answer;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Double getScore() {
        return score;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    public List<String> getOp() {
        return op;
    }

    public void setOp(List<String> op) {
        this.op = op;
    }

    public List<String> getTrueAnswer() {
        return trueAnswer;
    }

    public void setTrueAnswer(List<String> trueAnswer) {
        this.trueAnswer = trueAnswer;
    }

    public List<String> getAnswer() {
        return answer;
    }

    public void setAnswer(List<String> answer) {
        this.answer = answer;
    }

    public String getAnswerAnalysis() {
        return answerAnalysis;
    }

    public void setAnswerAnalysis(String answerAnalysis) {
        this.answerAnalysis = answerAnalysis;
    }

    public Integer getSubjectType() {
        return subjectType;
    }

    public void setSubjectType(Integer subjectType) {
        this.subjectType = subjectType;
    }

    public Integer getScoreType() {
        return scoreType;
    }

    public void setScoreType(Integer scoreType) {
        this.scoreType = scoreType;
    }
}
