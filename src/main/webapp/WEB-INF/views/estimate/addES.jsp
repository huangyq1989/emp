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
        <!-- 添加考试学员暂不完成 -->
        <title>
            <c:choose>
                <c:when test="${type == 'add'}">
                    添加评估学员
                </c:when>
                <c:otherwise>
                    查看评估学员
                </c:otherwise>
            </c:choose>
        </title>
    </head>
    <body>
        <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
            <label style="font-size: 23px;color: white">
                <c:choose>
                    <c:when test="${type == 'add'}">
                        添加评估学员
                    </c:when>
                    <c:otherwise>
                        查看评估学员
                    </c:otherwise>
                </c:choose>
            </label>
        </div>
        <div id="tb" style="padding:3px;margin-top: 7%;">
            <form method="post" id="dataForm" name="dataForm">
                <span>姓名:</span>
                <input id="realName" name="realName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>单位:</span>
                <input id="unit" name="unit" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>手机号码:</span>
                <input id="phone" name="phone" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <c:if test="${type == 'add'}">
                    <input type="button" id="add" name="add" value="添  加" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                </c:if>
                <input type="button" onclick="window.close();" value="取  消" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>
            </form>
            <br></br>
        </div>
        <table id="table" cellspacing="0" cellpadding="0"></table>
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

        var title = '查看评估学员列表';
        <c:if test="${type == 'add'}">
            title = '可添加学员列表';
        </c:if>

        $("#table").datagrid({
            title:title,
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/estimate/getESList.do?estimateId=${estimateId}&type=${type}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'chk',checkbox: true,width:100},
                {field:'id',title:'学号',width:110, sortable: true, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'sex',title:'性别',width:101, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "男";
                        }else{
                            return "女";
                        }
                    }
                },
                {field:'idCard',title:'身份证号码',width:250, halign:"center", align:"center"},
                {field:'phone',title:'手机',width:180, halign:"center", align:"center"},
                {field:'unit',title:'单位',width:260, halign:"center", align:"center"}
            ]]
        });

        getPager();
    });


    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            realName: $('#realName').val(),
            unit: $('#unit').val(),
            phone: $('#phone').val()
        });
    },false);


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        document.getElementById("realName").value = '';
        document.getElementById("unit").value = '';
        document.getElementById("phone").value = '';
        $('#table').datagrid('load',{});
    },false);


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


    //批量添加
    document.getElementById("add").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择一个学员进行添加",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要添加这"+rows.length+"个学员吗？",type: "warning",
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
                    url: "${pageContext.request.contextPath}/estimate/addES.do?estimateId=${estimateId}",
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
                        swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    }
                });
            } else {}
        });
    },false);


</script>