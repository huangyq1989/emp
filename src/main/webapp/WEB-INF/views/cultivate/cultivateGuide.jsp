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
        <title>培训指引</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${cultivateName}-培训指引</label>
            </div>
            <!--导入列表-->
            <div style="text-align:left;margin-top: 2%;margin-left: 3%">
                <!-- 上传域 -->
                <form id="signupForm" method="post" enctype="multipart/form-data" >
                    请选择要上传的文件(PDF或图片)：<input type="file" accept="image/*,application/pdf" name="SensitiveExcle" id="SensitiveExcle" style="height: 26px;" class="files" size="1" hidefocus/>
                    <input type="button" value="上 传 文 件" onclick="importFile()" style="border-radius:9px;background-color:snow;color: #333333;width:90px;height:30px"/>
                </form>
            </div>

            <div style="margin-top:4%;margin-left: 74%;">
                <input type="button" onclick="deleteCg();" value="删    除" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" onclick="window.close();" value="关 闭 页 面" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
            </div>

            <div style="border:1px solid #808080;margin-top: 4%;">
                <div style="text-align: center; padding:15px;height: 450px;">
                    <form method="post" id="dataForm" name="dataForm" style="padding: 0px 20px 20px 20px;">
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
            title:"培训指引信息",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/cultivate/getCultivateGuide.do?cultivateId=${cultivateId}',
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
                {field:'id',title:'序号',width:80, sortable: true, halign:"center", align:"center"},
                {field:'fileName',title:'文件名称',width:300, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return '<a href="###" onclick="previewOrDown(&quot;'+rec.filePath+'&quot;,&quot;'+value+'&quot;);">'+value+'</a>';
                        }
                    }
                },
                {field:'filePath',title:'文件路径',width:80, sortable: true, halign:"center", align:"center",hidden:true},
                {field:'insertTime',title:'新增时间',width:120, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'opt',title:'下载',width: 80, halign:"center", align:"center",
                    formatter:function(value,rec){
                        var btn = '<a class="download" onclick="previewOrDown(&quot;'+rec.filePath+'&quot;,&quot;'+rec.fileName+'&quot;,&quot;download&quot;);" href="javascript:void(0)">下载</a>';
                        return btn;
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.download').linkbutton({text:'下载',plain:true,iconCls:'icon-down-alt'});
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




    //上传文件
    function importFile(){
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: "错误提示",text: "请先选择需要导入的文件",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        var filesList = document.querySelector('#SensitiveExcle').files;
        if (filesList.length == 0) {//如果取消上传，则改文件的长度为0
            return;
        } else {//如果有文件上传，这在这里面进行
            if (filesList[0].size > 5000000) {
                swal({title: "错误提示",text: "上传的文件不能超过5MB,请重新选择",type: "error",confirmButtonText: "确  定"},function(){
                    //清空上传文件
                    document.getElementById('SensitiveExcle').value = "";
                });
                return false;
            }else{
                loadShow();

                //检测是否有同名的附件
                var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
                for(var i=0;i<rows.length;i++){
                    if(filesList[0].name == rows[i].fileName){
                        swal({title: "错误提示",text: "要上传的文件跟已上传的文件名称重复,无法上传,请重新选择",type: "error",confirmButtonText: "确  定"},function(){
                            //清空上传文件
                            document.getElementById('SensitiveExcle').value = "";
                        });
                        loadHide();
                        return false;
                    }
                }

                var formData = new FormData($('#signupForm')[0]);
                $.ajax({
                    url : "${pageContext.request.contextPath}/fileUpload/UploadServlet?type=cultivateGuide&cultivateId=${cultivateId}",
                    type: 'POST',
                    data: formData,
                    async: true,
                    cache: false,
                    contentType: false,
                    processData: false,
                    error : function(request) {
                        loadHide();
                        //清空上传文件
                        document.getElementById('SensitiveExcle').value = "";
                        swal({title: "错误提示",text: "系统异常，请联系管理员",type: "error",confirmButtonText: "确  定"});
                    },
                    success : function(data) {
                        loadHide();
                        //清空上传文件
                        document.getElementById('SensitiveExcle').value = "";
                        var result = $.parseJSON(data);
                        jsonData = result;
                        if (result.flag == 0) {
                            swal({title: "提示",text: "上传成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                            $("#table").datagrid('reload');//刷新表单数据
                        } else {
                            swal({title: "错误提示",text: result.message ,type: "error",confirmButtonText: "确  定"});
                        }
                    }
                });
            }
        }
    };


    //在线预览或下载
    function previewOrDown(filePath,fileName,type){
        if(type == 'download'){
            //当前页面下载
            window.location.href = "${pageContext.request.contextPath}/cultivate/previewOrDown.do?filePath="+filePath+"&fileName="+fileName+"&type=download";
        }else{
            //打开新窗口预览
            window.open("${pageContext.request.contextPath}/cultivate/previewOrDown.do?filePath="+filePath+"&fileName="+fileName,'fileWindow');
        }
    };


    //删除
    function deleteCg(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择选择一个指引进行删除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要删除这"+rows.length+"个指引吗？",type: "warning",
                showCancelButton: true,// 是否显示取消按钮
                confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                confirmButtonText: "确  定",// 确定按钮的 文字
                cancelButtonText: "取  消",// 取消按钮的 文字
                closeOnConfirm: false, //确认再提示
            },
            function(isConfirm){
                if (isConfirm) {
                    //获取选择的ID
                    var arr = new Array();
                    var path = new Array();
                    for(var i=0;i<rows.length;i++){
                        arr.push(rows[i].id);
                        path.push(rows[i].filePath);
                    }
                    $.ajax({
                        type: "post",
                        url: "${pageContext.request.contextPath}/cultivate/deleteCg.do",
                        data: {"arr":arr,"path":path},
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(data){
                            if(data == 0){
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
    };


</script>