<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <!-- easyui -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/default/easyui.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/icon.css" type="text/css"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <title>成绩查看</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">成绩查看</label>
            </div>
            <div style="margin-top:4%;margin-left: 72%;">
                <%--<input type="button" onclick="exportEC();" value="导    出" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>--%>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
            </div>
            <div style="border:1px solid #808080;margin-top: 4%;">
                <div style="text-align: center; padding:15px;height: 450px;">
                    <form method="post" action="${pageContext.request.contextPath}/examination/exportEC.do?studentId=${studentId}" id="dataForm" name="dataForm" style="padding: 0px 20px 20px 20px;">
                        <table id="table" cellspacing="0" cellpadding="0"></table>
                    </form>
                </div>
            </div>
        </div>
    </body>

</html>

<script type="text/javascript">

    var loadWidth = 0;
    var loadHeight = 0;

    //初始化加载数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        easyuiUtils.lang_zh_CN();//加载easyui中文支持

        $("#table").datagrid({
            title:"成绩信息",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/examination/queryEC.do?studentId=${studentId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            // fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'chk',checkbox: true,width:60},
                {field:'studentId',title:'学号',width:80, sortable: true, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'phone',title:'手机',width:140, halign:"center", align:"center"},
                {field:'unit',title:'单位',width:160, halign:"center", align:"center"},
                {field:'cultivateName',title:'培训名称',width:150, halign:"center", align:"center"},
                {field:'score',title:'考试成绩',width:100, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value;
                        }else{
                            return "没有成绩";
                        }
                    }},
                {field:'isPassing',title:'是否及格',width:100, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "不及格";
                        }else if(value == 1){
                            return "及格";
                        }else{
                            return "没有成绩";
                        }
                    }
                },
                {field:'stuMakeUpNum',title:'补考次数',width:100, halign:"center", align:"center"}
            ]]
        });

        getPager();
    });


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        commonUtils.fitCoulms("table");
        getPager();

        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });


    //设置分页控件
    function getPager(){
        var p = $('#table').datagrid('getPager');
        $(p).pagination({
            pageSize: 10,//每页显示的记录条数，20
            pageList: [10],//可以设置每页记录条数的列表
            beforePageText: '第',//页数文本框前显示的汉字
            afterPageText: '页    共 {pages} 页',
            displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
            onBeforeRefresh:function(){
                $(this).pagination('loading');
            }
        });
    };


    //导出
    function exportEC(){
        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法导出",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要导出成绩信息吗?",type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
        },
        function(isConfirm){
            if (isConfirm) {
                $("#dataForm").submit();
            } else {}
        });
    }

</script>