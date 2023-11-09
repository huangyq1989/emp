package com.emp.systemManage.entity;

public class Page {

    public Page(){

    }

    public Page(int pageNum,int size){
        this.pageNum = pageNum;
        this.size = size;
        this.startRow = (pageNum - 1) * size;
    }

    private Integer startRow; //开始条数
    private Integer pageNum; //页码（第几页）
    private Integer size; //每页记录数

    public Integer getStartRow() {
        return startRow;
    }

    public void setStartRow(int startRow) {
        this.startRow = startRow;
    }

    public Integer getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}
