<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:include page="../loadPage.jsp"/>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>学员管理</title>
    </head>
    <body>
        <div style="overflow:auto;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white" id="title">${cultivateName}-培训学员管理</label>
            </div>
            <div>
                <!--添加删除导出列表-->
                <div style="width:100%;height:690px;float: left;border:1px solid #808080;" id="one_div">
                    <div id="tb" style="margin-left: 2%;margin-top: 5%;margin-bottom: 5%;padding:3px">
                        <form method="post" action="${pageContext.request.contextPath}/cultivate/exportCs.do?cultivateName=${cultivateName}&cultivateId=${cultivateId}" id="dataForm" name="dataForm">
                            <span>姓名:</span>
                            <input id="realName" name="realName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                            <span>单位:</span>
                            <input id="unit" name="unit" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                            <span>手机号码:</span>
                            <input id="phone" name="phone" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;
                            <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;
                            <input type="button" id="export" name="export" value="导  出" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;
                            <input type="button" onclick="window.close();" value="关  闭" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;
                        </form>
                        <br>
                    </div>
                    <div style="text-align:right">
                        <input type="button" id="add" name="add" value="添  加" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/cultivate/toAddCs.do?cultivateName=${cultivateName}&cultivateId=${cultivateId}','newWindow3',1090,740,'table')" style="border-radius:9px;background-color:snow;color: #333333;width:80px;height:30px"/>&nbsp;&nbsp;&nbsp;
                        <input type="button" id="import" name="import" value="导  入" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/cultivate/toImportCs.do?cultivateName=${cultivateName}&cultivateId=${cultivateId}','newWindow2',1090,740,'table')" style="border-radius:9px;background-color:snow;color: #333333;width:80px;height:30px"/>&nbsp;&nbsp;&nbsp;
                        <input type="button" id="delete" name="delete" value="删  除" style="border-radius:9px;background-color:snow;color: #333333;width:80px;height:30px"/>&nbsp;&nbsp;&nbsp;
                    </div>
                    <div style="margin-left: 1%;margin-right: 1%;margin-top: 2%;">
                        <table id="table" cellspacing="0" cellpadding="0"></table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>


<script type="text/javascript">

    var loadWidth = 0;
    var loadHeight = 0;



    //初始化加载添加列表数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        easyuiUtils.lang_zh_CN();//加载easyui中文支持

        $("#table").datagrid({
            title:"已培训学员列表",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/cultivate/getCSList.do?cultivateId=${cultivateId}&type=delete',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'chk',checkbox: true,width:120},
                {field:'id',title:'学号',width:110, sortable: true, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:180, halign:"center", align:"center"},
                {field:'sex',title:'性别',width:100, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "男";
                        }else{
                            return "女";
                        }
                    }
                },
                {field:'idCard',title:'身份证号码',width:230, halign:"center", align:"center"},
                {field:'phone',title:'手机',width:180, halign:"center", align:"center"},
                {field:'unit',title:'单位',width:254, halign:"center", align:"center"}
            ]]
        });

        getPager();
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



    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            realName: $('#realName').val(),
            unit: $('#unit').val(),
            phone: $('#phone').val()
        });
    },false);


    //刷新表格
    function reloadTable(){
        $('#table').datagrid('load',{
            realName: $('#realName').val(),
            unit: $('#unit').val(),
            phone: $('#phone').val()
        });
    };


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        document.getElementById("realName").value = '';
        document.getElementById("unit").value = '';
        document.getElementById("phone").value = '';
        $('#table').datagrid('load',{});
    },false);



    //批量删除
    document.getElementById("delete").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择一个学员进行删除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要删除这"+rows.length+"个学员吗？",type: "warning",
                showCancelButton: true,// 是否显示取消按钮
                confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                confirmButtonText: "确  定",// 确定按钮的 文字
                cancelButtonText: "取  消",// 取消按钮的 文字
                closeOnConfirm: false, //确认再提示
                // closeOnCancel: false //关闭再提示
            },
            function(isConfirm){
                if (isConfirm) {
                    //获取选择的ID
                    var arr = new Array();
                    for(var i=0;i<rows.length;i++){
                        arr.push(rows[i].id);
                    }
                    $.ajax({
                        type: "post",
                        url: "${pageContext.request.contextPath}/cultivate/deleteCS.do?cultivateId=${cultivateId}",
                        data: {"arr":arr},
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(data){
                            if(data == 0){
                                // 1秒定时关闭弹窗
                                swal({title: "提示",text: "删除成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                                $("#table").datagrid('reload');//刷新表单数据
                            }else{
                                swal({title: "错误提示",text: "删除失败",type: "error",confirmButtonText: "确  定"});
                            }
                        },
                        error: function(){
                            swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                        }
                    });
                } else {}
            });
    },false);


    //导出
    document.getElementById("export").addEventListener("click",function(){
        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法导出",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要导出培训数据吗?",type: "warning",
                showCancelButton: true,// 是否显示取消按钮
                confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                confirmButtonText: "确  定",// 确定按钮的 文字
                cancelButtonText: "取  消",// 取消按钮的 文字
                // closeOnConfirm: false, //确认再提示
                // closeOnCancel: false //关闭再提示
            },
            function(isConfirm){
                if (isConfirm) {
                    var rows = commonUtils.getCheckRows('table');
                    if(rows.length == 0){//条件查询导出
                        $("#dataForm").submit();
                    }else{//勾选导出
                        var arr = new Array();
                        for(var i=0;i<rows.length;i++){
                            arr.push(rows[i].id);
                        }
                        //小数据量可以使用
                        window.location.href = "${pageContext.request.contextPath}/cultivate/exportCs.do?cultivateName=${cultivateName}&arr="+arr;
                    }
                } else {}
            });
    },false);

</script>