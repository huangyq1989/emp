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
            ${cultivateName}-考试监控
        </title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;border:1px solid #808080;">
            <div style="height:50px;">
                <div style="margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                    <label style="font-size: 23px;color: white">${cultivateName}-考试监控</label>
                </div>
            </div>
            <!-- DIV居中 -->
            <div style="height:50px;background-color: #d7d7d7" class="div_center">
                <c:if test="${examinationDataCode == 1}">
                    <div style="float: left;display: none;" id="showTime1">
                        <label style="color: red;font-size: 19px">已用时：</label>
                        <label style="color: red;font-size: 19px" id="minutes" name="minutes">25</label>
                        <label style="color: red;font-size: 19px">分</label>
                        <label style="color: red;font-size: 19px" id="seconds" name="seconds">03</label>
                        <label style="color: red;font-size: 19px">秒</label>
                    </div>
                    <div id="showTime2" style="float: left;display: none;">
                        <label style="color: red;font-size: 19px">打开试卷计时</label>
                    </div>
                </c:if>
                <div style="margin-left: 11%;float: left">
                    <label id="total"></label>
                </div>
                <div style="margin-left: 11%;float: left">
                    <label id="now"></label>
                </div>
                <div style="margin-left: 11%;float: left">
                    <label id="over"></label>
                </div>
                <div style="margin-left: 11%;">
                    <input type="button" id="reload" name="reload" value="刷  新" style="border-radius:9px;background-color:snow;color: #333333;width:100px;height:35px"/>
                </div>
            </div>
            <div style="margin-top: 1%;margin-left: 2%;">
                <input type="button" id="removeAll" name="removeAll" value="全  部  回  收" style="border-radius:9px;background-color:#0092DC;color: snow;width:120px;height:35px"/>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="   取   消   " onclick="window.close();" style="border-radius:9px;background-color:#0092DC;color: snow;width:120px;height:35px"/>
            </div>
            <div style="margin-top: 1%;">
                <table id="table" cellspacing="0" cellpadding="0"></table>
            </div>
        </div>
        <input type="hidden" id="timingMode" value="${timingMode}"/>
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
            title:'${cultivateName}-考试监控',
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/examination/getECList.do?examinationId=${examinationId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'id',title:'序号',width:90, halign:"center", align:"center",
                    formatter: function(val,rec,index){
                        var op = $('#table').datagrid('options');
                        return op.pageSize * (op.pageNumber - 1) + (index + 1);
                    }
                },
                {field:'studentId',title:'学号',width:90, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'unit',title:'单位',width:130, halign:"center", align:"center"},
                {field:'department',title:'部门',width:130, halign:"center", align:"center"},
                {field:'job',title:'职位',width:120, halign:"center", align:"center"},
                {field:'examinationCode',title:'考试状态',width:137, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "未考试";
                        }else if(value == 1){
                            return "考试中";
                        }else{
                            return "已交卷";
                        }
                    }
                },
                {field:'closeTime',title:'交卷时间',width:80, sortable: true, halign:"center", align:"center",hidden:true},
                {field:'openTime',title:'已用时',width:170, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            var t_timingMode = document.getElementById("timingMode").value;
                            if(rec.examinationCode == 1 && t_timingMode == 1){//考试中和打开试卷才显示
                                var result = $.parseJSON(value);
                                result = result.minutes+"分"+result.seconds+"秒";
                                return '<span style="color:red">'+result+'</span>' ;
                            }else if(rec.examinationCode == 2){
                                var result = $.parseJSON(value);
                                result = result.minutes+"分"+result.seconds+"秒";
                                return result ;
                            }else{
                                return  "";
                            }

                        }
                    }
                },
                {field:'opt',title:'操作',<c:if test="${timingMode == 1}">width: 150,</c:if><c:if test="${timingMode != 1}">width: 320,</c:if> halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(rec.examinationCode == 1){
                            var btn = '<a class="removePaper" onclick="removeOne(\''+rec.studentId+'\')" href="javascript:void(0)">回收试卷</a>';
                            return btn;
                        }
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.removePaper').linkbutton({text:'回收试卷',plain:true,iconCls:'icon-lock'});
                //加载数量
                $.ajax({
                    url : "${pageContext.request.contextPath}/examination/getECCount.do?examinationId=${examinationId}&timingMode=${timingMode}",
                    type: 'POST',
                    async: false,
                    cache: false,
                    contentType: false,
                    processData: false,
                    error : function(request) {
                        swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    },
                    success : function(data) {
                        if(data.code == 0){
                            document.getElementById("total").innerText = "应考试："+data.total+"人";
                            document.getElementById("now").innerText = "参加考试："+Number(data.now+data.over)+"人";
                            document.getElementById("over").innerText = "已交卷："+data.over+"人";
                            if(data.total == 0){
                                document.getElementById("removeAll").style.display = "none";
                            }else{
                                document.getElementById("removeAll").style.display = "";
                            }

                            <c:if test="${examinationDataCode == 1}">
                                var t_timingMode = document.getElementById("timingMode").value;
                                if(0 == t_timingMode){//考试时间计时
                                    document.getElementById("showTime1").style.display = "";
                                    document.getElementById("showTime2").style.display = "none";
                                    document.getElementById("minutes").innerText = data.minutes;
                                    document.getElementById("seconds").innerText = data.seconds;
                                }else{//打开试卷开始计时
                                    document.getElementById("showTime1").style.display = "none";
                                    document.getElementById("showTime2").style.display = "";
                                }
                            </c:if>
                        }else{
                            swal({title: '错误提示',text: data.message,type: "error",confirmButtonText: "确  定"},
                                function(){window.close();});
                        }
                    }
                });
            }
        });

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


    <c:if test="${examinationDataCode == 1}">
        // 动态计算时间
        setInterval(function(){
            var t_timingMode = document.getElementById("timingMode").value;
            if(0 == t_timingMode){
                var seconds = document.getElementById("seconds").innerText ;
                seconds ++ ;
                if(seconds == 60){//60前进到分钟
                    var minutes = document.getElementById("minutes").innerText;
                    minutes++;
                    document.getElementById("minutes").innerText = minutes;
                    document.getElementById("seconds").innerText = "00";
                }else{
                    document.getElementById("seconds").innerText = seconds;
                }
            }else{
                var rows = $('#table').datagrid('getRows');
                for(var g=0;g<rows.length;g++){
                    var t_str = rows[g].openTime;
                    if(t_str != "" && rows[g].examinationCode == 1){
                        var result = $.parseJSON(t_str);
                        var m = result.minutes;
                        var s = result.seconds;
                        s ++ ;
                        if(s == 60){//60前进到分钟
                            m++;
                            s = 0;
                        }
                        rows[g]['openTime'] = "{\"minutes\":\""+m+"\",\"seconds\":\""+s+"\"}";
                        $('#table').datagrid('refreshRow',g);
                    }
                }
                //改变后需要重新设置回收样式
                $('.removePaper').linkbutton({text:'回收试卷',plain:true,iconCls:'icon-lock'});
            }
        },1000);
    </c:if>


    //回收所有试卷
    document.getElementById("removeAll").addEventListener("click",function(){
        swal({
            title: "提示",
            text: "是否回收考试中的所有试卷?",
            type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
            closeOnConfirm: false, //确认再提示
            // closeOnCancel: false //关闭再提示
        },
        function(isConfirm){
            if (isConfirm) {
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/examination/updateECCode.do?examinationId=${examinationId}",
                    traditional:true,
                    async:false,
                    dataType:"json",
                    success: function(data){
                        if(data == 0){
                            //弹窗闪现,1秒后定时关闭
                            swal({title: "提示",text: "回收成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                            $("#table").datagrid('reload');//刷新表单数据
                        }else{
                            swal({title: "错误提示",text: "回收失败",type: "error",confirmButtonText: "确  定"});
                        }
                    },
                    error: function(){
                        swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    }
                });
            } else {}
        });
    },false);


    //回收试卷
    function removeOne(studentId){
        swal({
            title: "提示",
            text: "是否回收学号为"+studentId+"的学员试卷?",
            type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
            closeOnConfirm: false, //确认再提示
            // closeOnCancel: false //关闭再提示
        },
        function(isConfirm){
            if (isConfirm) {
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/examination/updateECCode.do?examinationId=${examinationId}&studentId="+studentId,
                    traditional:true,
                    async:false,
                    dataType:"json",
                    success: function(data){
                        if(data == 0){
                            //弹窗闪现
                            swal({title: "提示",text: "回收成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                            $("#table").datagrid('reload');//刷新表单数据
                        }else{
                            swal({title: "错误提示",text: "回收失败",type: "error",confirmButtonText: "确  定"});
                        }
                    },
                    error: function(){
                        swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    }
                });
            } else {}
        });
    };


</script>