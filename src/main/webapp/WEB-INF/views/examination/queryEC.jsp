<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <title>成绩查看</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${cultivateName}-成绩查看</label>
            </div>
            <div style="margin-top:4%;margin-left: 2%;">
                <div style="margin:15px;" id="sendECTime_div">
                    <input type="button" onclick="releaseEC();" value="保存发布成绩设置" style="border-radius:9px;background-color:#0092DC;color: snow;width:130px;height:31px"/>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option" value="0" checked="checked" onchange="checkRadio(1,this);">不发布成绩</input>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option" value="1" onchange="checkRadio(1,this);">立即发布成绩</input>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option" value="2" onchange="checkRadio(2,this);">发布成绩时间设置</input>
                </div>

                <div style="margin:15px;" id="sendCNTime_div">
                    <input type="button" onclick="releaseCN();" value="保存发布证书设置" style="border-radius:9px;background-color:#0092DC;color: snow;width:130px;height:31px"/>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option1" value="0" checked="checked" onchange="checkCNRadio(1,this);">不发布证书</input>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option1" value="1" onchange="checkCNRadio(1,this);">立即发布证书</input>
                    &nbsp;&nbsp;&nbsp;
                    <input type="radio" name="option1" value="2" onchange="checkCNRadio(2,this);">发布证书时间设置</input>
                </div>

                <div style="margin-top:0%;margin-left: 60%;">
                    <input type="button" onclick="exportEC();" value="批量导出成绩" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="downloadPackage();" value="打包下载证书" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value=" 关    闭 " style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
            <div style="margin-top: 1%;">
                <div style="text-align: center; padding:15px;height: 450px;">
                    <form method="post" action="${pageContext.request.contextPath}/examination/exportEC.do?examinationId=${examinationId}" id="dataForm" name="dataForm" style="padding: 0px 20px 20px 20px;">
                        <table id="table" cellspacing="0" cellpadding="0"></table>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/downLoad/downloadPackage.do?type=certificate&examinationId=${examinationId}" id="dataForm1" name="dataForm1" style="padding: 0px 20px 20px 20px;">
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
            url:'${pageContext.request.contextPath}/examination/queryEC.do?examinationId=${examinationId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:420,
            pageSize: 10,
            columns: [[
                {field:'studentId',title:'学号',width:80, sortable: true, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'phone',title:'手机',width:140, halign:"center", align:"center"},

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
                {
                field: 'isRelease', title: '发布成绩', width: 80, halign: "center", align: "center",
                    formatter: function (value, rec) {
                        if (value == 0) {
                            return "否";
                        } else {
                            return "是";
                        }
                    }
                },
                {field:'stuMakeUpNum',title:'补考次数',width:80, halign:"center", align:"center"},
                {field:'isCertificateNo',title:'证书发布',width:80, halign:"center", align:"center",
                    formatter: function (value, rec) {
                        if (value == 0) {
                            return "否";
                        } else {
                            return "是";
                        }
                    }
                },
                {field:'certificateNo',title:'证书编号',width:130, halign:"center", align:"center",
                    formatter:function(value){
                        if(value != "" && value != undefined){
                            return '<a href="###" onclick="downloadCertificate(&quot;'+value+'&quot;,&quot;view&quot;);">'+value+'</a>';
                        }
                    }
                },
                {field:'opt',title:'下载',width: 80, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(rec.certificateNo != "" && rec.certificateNo != undefined){
                            var btn = '<a class="download" onclick="downloadCertificate(&quot;'+rec.certificateNo+'&quot;);" href="javascript:void(0)">下载</a>';
                            return btn;
                        }
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.download').linkbutton({text:'下载',plain:true,iconCls:'icon-down-alt'});

                //设置发布成绩和发布证书的按钮
                var v_rows = $("#table").datagrid("getRows"); //获取当前页的所有行
                if(v_rows.length > 0){
                    if(v_rows[0].isRelease == 1){//成绩
                        $("[name='option'][value='1']").prop("checked", "checked");
                    }
                    if(v_rows[0].isCertificateNo == 1){//证书
                        $("[name='option1'][value='1']").prop("checked", "checked");
                    }
                }
            }
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


    //导出成绩
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


    //打包下载证书
    function downloadPackage(){
        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法下载",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要打包下载证书吗?",type: "warning",
                showCancelButton: true,// 是否显示取消按钮
                confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                confirmButtonText: "确  定",// 确定按钮的 文字
                cancelButtonText: "取  消",// 取消按钮的 文字
                closeOnConfirm: false, //确认再提示
            },
            function(isConfirm){
                if (isConfirm) {
                    loadShow();
                    //先判断是否有证书可以下载
                    $.ajax({
                        type: "post",
                        url: "${pageContext.request.contextPath}/examination/queryExistCertificate.do?examinationId=${examinationId}",
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(data){
                            loadHide();
                            if(data == "0"){
                                //弹窗闪现
                                swal({title: "提示",text: "正在打包下载,请稍候...",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                                //打包下载
                                $("#dataForm1").submit();
                            }else if(data == "1"){
                                swal({title: "错误提示",text: "当前成绩无证书可下载",type: "error",confirmButtonText: "确  定"});
                            }else{
                                swal({title: "错误提示",text: "当前成绩证书查询失败",type: "error",confirmButtonText: "确  定"});
                            }
                        },
                        error: function(){
                            loadHide();
                            swal({title: "错误提示",text: "打包下载证书异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                        }
                    });
                } else {}
            });
    }


    //发布成绩
    function releaseEC(){
        var val = $('input:radio[name="option"]:checked').val();

        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法发布",type: "warning",confirmButtonText: "确  定"});
            return false;
        }else{
            if(val == "0"){//取消发布
                if(rows[0].isRelease == 0){
                    swal({title: "提示",text: "该成绩已经是未发布",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }else if(rows[0].isCertificateNo == 1){
                    swal({title: "提示",text: "需要先取消发布证书才能取消发布成绩",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }
            }else{//需要发布
                if(rows[0].isRelease == 1){
                    swal({title: "提示",text: "该成绩已发布,无需再发布",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }

        var t_sendECTime = "";
        if(val == "2"){
            t_sendECTime = $('#sendECTime').val();
            if(t_sendECTime == ""){
                swal({title: "错误提示",text: "请设置成绩发布时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date();
                var oDate2 = new Date(t_sendECTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "成绩发布时间不能小于当前时间,请重新设置发布时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }

        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/updateByReleaseEC.do?examinationId=${examinationId}&reFlag="+val+"&t_sendECTime="+t_sendECTime,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == "0"){
                    // 1秒定时关闭弹窗(再确认的写法)
                    swal({title: "提示",text: "设置成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                    $("#table").datagrid('reload');//刷新表单数据
                }else{
                    swal({title: "错误提示",text: "设置失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "设置异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };



    //发布证书
    function releaseCN(){
        var val = $('input:radio[name="option1"]:checked').val();

        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法发布",type: "warning",confirmButtonText: "确  定"});
            return false;
        }else{
            if(val == "0"){//取消发布
                if(rows[0].isCertificateNo == 0){
                    swal({title: "提示",text: "该证书已经是未发布",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }
            }else{//需要发布
                if(rows[0].isCertificateNo == 1){
                    swal({title: "提示",text: "该证书已发布,无需再发布",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }
                if(rows[0].isRelease == 0){
                    swal({title: "提示",text: "需要先发布成绩才能发布证书",type: "warning",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }

        var t_sendCNTime = "";
        if(val == "2"){
            t_sendCNTime = $('#sendCNTime').val();
            if(t_sendCNTime == ""){
                swal({title: "错误提示",text: "请设置证书发布时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date();
                var oDate2 = new Date(t_sendCNTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "证书发布时间不能小于当前时间,请重新设置发布时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }

        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/updateByReleaseCN.do?examinationId=${examinationId}&reFlag="+val+"&t_sendCNTime="+t_sendCNTime,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == "0"){
                    // 1秒定时关闭弹窗(再确认的写法)
                    swal({title: "提示",text: "设置成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                    $("#table").datagrid('reload');//刷新表单数据
                }else{
                    swal({title: "错误提示",text: "设置失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "设置异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };



    //下载电子证书
    function downloadCertificate(certificateNo,type) {
        if(type == 'view'){
            //打开新窗口预览
            window.open("${pageContext.request.contextPath}/examination/downloadCertificateByWeChat.do?type=view&certificateNo="+certificateNo,'cnWindow');
        }else{
            //当前页面下载
            window.location.href = '${pageContext.request.contextPath}/examination/downloadCertificateByWeChat.do?certificateNo='+certificateNo;
        }
    };



    //显示或隐藏发布成绩时间
    function checkRadio(type,check){
        if(type == 1){
            //销毁datetimebox
            $('#sendECTime').combobox('destroy');
        }else{
            var input = document.createElement("input");
            input.setAttribute("type","text");
            input.setAttribute("id","sendECTime");
            input.setAttribute("style","width:25%;");
            document.getElementById('sendECTime_div').appendChild(input);
            this.addDatebox();
        }
    };

    //加载发布成绩时间控件
    function addDatebox(){
        $('#sendECTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
    };








    //显示或隐藏发布证书时间
    function checkCNRadio(type,check){
        if(type == 1){
            //销毁datetimebox
            $('#sendCNTime').combobox('destroy');
        }else{
            var input = document.createElement("input");
            input.setAttribute("type","text");
            input.setAttribute("id","sendCNTime");
            input.setAttribute("style","width:25%;");
            document.getElementById('sendCNTime_div').appendChild(input);
            this.addCNDatebox();
        }
    };

    //加载发布成绩证书控件
    function addCNDatebox(){
        $('#sendCNTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
    };

</script>