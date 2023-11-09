package com.emp.estimateManage.entity;

public class QuestionnaireAnswer {

    private String c_opt; //行标题号
    private String c_op;  //选项号
    private String c_detail;  //必填内容

    public String getC_opt() {
        return c_opt;
    }

    public void setC_opt(String c_opt) {
        this.c_opt = c_opt;
    }

    public String getC_op() {
        return c_op;
    }

    public void setC_op(String c_op) {
        this.c_op = c_op;
    }

    public String getC_detail() {
        return c_detail;
    }

    public void setC_detail(String c_detail) {
        this.c_detail = c_detail;
    }
}
