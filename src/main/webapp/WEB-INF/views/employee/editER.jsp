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
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>权限配置管理</title>
    </head>

    <body>
        <div style="overflow:auto;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white" id="title"></label>
            </div>
            <div>
                <!-- 左侧菜单 -->
                <div style="width:18%;height:590px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 15%">
                        <label class="am-fl am-form-label" style="font-size:23px;">权限配置管理</label>
                    </div>
                    <div style="text-align: center;margin-top: 30%;">
                        <br><br>
                        <input type="button" onclick="viewNoteMenu(1);" value=" 已 匹 配 权 限 " style="border-radius:9px;background-color: purple;color: snow;width:150px;height:40px"/>
                        <br><br>
                        <input type="button" onclick="viewNoteMenu(2);" value=" 未 匹 配 权 限 " style="border-radius:9px;background-color: #985f0d;color: snow;width:150px;height:40px"/>
                        <br><br>
                        <br><br><br><br><br>
                        <input type="button" onclick="window.close();" value=" 关       闭 " style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>

                <!--右侧内容-->
                <div style="width:82%;height:590px;float: left;border:1px solid #808080;" id="one_div">
                    <div id="tb" style="margin-left: 3%;margin-top:8%;margin-right: 3%">
                        <form method="post" id="dataForm" name="dataForm">
                            <span>权限名称:</span>
                            <input id="roleName" name="roleName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="add" name="add" value="添  加" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="remove" name="remove" value="移  除" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                        </form>
                    </div>
                    <div style="margin-top: 9%;margin-left: 2%;margin-right: 2%;">
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

    //初始化加载数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        viewNoteMenu(1);
    });


    //加载不同的div
    function viewNoteMenu(flag){
        var title = '';
        var url = '';
        var type = '';
        if(flag == 1) {
            document.getElementById('title').innerText = "权限配置管理-已匹配权限" ;
            title = '已匹配权限列表';
            $("#remove").attr("style", "border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px;");
            $("#add").attr("style", "display:none;");
            type = 'remove';
        }else {
            document.getElementById('title').innerText = "权限配置管理-未匹配权限" ;
            title = '未匹配权限列表';
            $("#remove").attr("style", "display:none;");
            $("#add").attr("style", "border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px;");
            type = 'add';
        }
        $("#table").datagrid({
            title:title,
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/roleMenu/getER.do?type='+type+'&employeeId=${employeeId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:360,
            pageSize: 20,
            columns: [[
                {field:'chk',checkbox: true,width:120},
                {field:'id',title:'编号',width:110, sortable: true, halign:"center", align:"center"},
                {field:'roleName',title:'权限名称',width:210, halign:"center", align:"center"},
                {field:'insertTime',title:'新增时间',width:250, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'updateTime',title:'修改时间',width:250, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                }
            ]]
        });

        getPager();


        //查询
        document.getElementById("search").addEventListener("click",function(){
            $('#table').datagrid('load',{
                roleName: $('#roleName').val()
            });
        },false);

        //重置
        document.getElementById("reset").addEventListener("click",function(){
            document.getElementById("roleName").value = '';
            $('#table').datagrid('load',{});
        },false);
    };


    //设置分页控件
    function getPager(){
        var p = $('#table').datagrid('getPager');
        $(p).pagination({
            pageSize: 20,//每页显示的记录条数，20
            pageList: [10,20],//可以设置每页记录条数的列表
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


    //配置权限
    document.getElementById("add").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择一个权限进行添加",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        //获取选择的ID
        var arr = new Array();
        for(var i=0;i<rows.length;i++){
            arr.push(rows[i].id);
        }
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/employee/addER.do?employeeId=${employeeId}",
            data: {"arr":arr},
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == 0){
                    swal({title: "提示",text: "添加成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                    $("#table").datagrid('reload');//刷新表单数据
                }else{
                    swal({title: "错误提示",text: "添加失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "添加失败,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    },false);


    //移除权限
    document.getElementById("remove").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择一个权限进行移除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        //获取选择的ID
        var arr = new Array();
        for(var i=0;i<rows.length;i++){
            arr.push(rows[i].id);
        }
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/employee/removeER.do?&employeeId=${employeeId}",
            data: {"arr":arr},
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == 0){
                    swal({title: "提示",text: "移除成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                    $("#table").datagrid('reload');//刷新表单数据
                }else{
                    swal({title: "错误提示",text: "移除失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "移除失败,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    },false);


</script>