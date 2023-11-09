<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <!-- easyui -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/default/easyui.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/icon.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>
            ${cultivateName}-评估监控
        </title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;border:1px solid #808080;">
            <div style="height:50px;">
                <div style="margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                    <label style="font-size: 23px;color: white">${cultivateName}-评估监控</label>
                </div>
            </div>

            <div style="height:50px;background-color: #d7d7d7" class="div_center">
                <!-- DIV居中 -->
                <div style="margin-left: 11%;float: left">
                    <label id="total"></label>
                </div>
                <div style="margin-left: 11%;float: left">
                    <label id="over"></label>
                </div>
                <div style="margin-left: 11%;">
                    <input type="button" id="reload" name="reload" value="刷  新" style="border-radius:9px;background-color:snow;color: #333333;width:100px;height:35px"/>
                </div>
            </div>
            <div style="margin-top: 1%;margin-left: 2%;">
                <input type="button" value="   取   消   " onclick="window.close();" style="border-radius:9px;background-color:#0092DC;color: snow;width:120px;height:35px"/>
            </div>
            <div style="margin-top: 1%;">
                <table id="table" cellspacing="0" cellpadding="0"></table>
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
            title:'${cultivateName}-评估监控',
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/estimate/getECList.do?estimateId=${estimateId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'id',title:'序号',width:70, halign:"center", align:"center",
                    formatter: function(val,rec,index){
                        var op = $('#table').datagrid('options');
                        return op.pageSize * (op.pageNumber - 1) + (index + 1);
                    }
                },
                {field:'studentId',title:'学号',width:90, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'unit',title:'单位',width:200, halign:"center", align:"center"},
                {field:'department',title:'部门',width:200, halign:"center", align:"center"},
                {field:'job',title:'职位',width:170, halign:"center", align:"center"},
                {field:'estimateCode',title:'评估状态',width:100, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "未提交";
                        }else{
                            return "已提交";
                        }
                    }
                },
                {field:'estimateTime',title:'评估时间',width:200, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                }
            ]],
            onLoadSuccess:function(data){
                //加载数量
                $.ajax({
                    url : "${pageContext.request.contextPath}/estimate/getECCount.do?estimateId=${estimateId}",
                    type: 'POST',
                    async: false,
                    cache: false,
                    contentType: false,
                    processData: false,
                    error : function(request) {
                        swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    },
                    success : function(data) {
                        document.getElementById("total").innerText = "应评估人数："+data.total+"人";
                        document.getElementById("over").innerText = "已交卷："+data.over+"人";
                    }
                });
            }
        });

        //设置分页控件
        getPager();
    });


    //查询
    document.getElementById("reload").addEventListener("click",function(){
        $('#table').datagrid('load',{});
    },false);


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

</script>