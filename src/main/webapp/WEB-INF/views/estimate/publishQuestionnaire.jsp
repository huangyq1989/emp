<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>${title}-问卷发布</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;height:100%;width:100%">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-问卷发布</label>
            </div>

            <div style="border:1px solid #808080">
                <div style="margin-top: 14%;text-align:center;">
                    <img class="q_code" src="${pageContext.request.contextPath}/estimate/getQiQRCode.do?estimateId=${estimateId}&cultivateId=${cultivateId}" />
                </div>
                <div style="text-align: center;margin-top: 12%;margin-bottom: 12%;">
                    <input type="button" onclick="stopPublish();" value="停 止 发 布" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="downloadQR();" value="下载二维码" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>

        </div>
    </body>

</html>


<script type="text/javascript">


    var loadWidth = 0;
    var loadHeight = 0;


    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        <c:choose>
            <c:when test="${not empty questionnaireEstimate}">
            </c:when>
            <c:otherwise>
                swal({title: '错误提示',text: "该评估没有问卷,不可进行发布,请先添加问卷!",type: "error",confirmButtonText: "确  定"}, function(){window.close();});
            </c:otherwise>
        </c:choose>
    });


    //下载二维码
    function downloadQR() {
        window.location.href = '${pageContext.request.contextPath}/estimate/getQiQRCode.do?estimateId=${estimateId}&cultivateId=${cultivateId}&type=download&name=${title}问卷二维码';
    };


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });


    //停止发布问卷
    function stopPublish(){
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/estimate/updatePublishStatus.do?estimateId=${estimateId}&type=stop",
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == "0"){
                    // 1秒定时关闭弹窗
                    swal({title: "提示",text: "设置成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                        $("#table").datagrid('reload');//刷新表单数据
                        window.close();
                    });

                }else{
                    swal({title: "错误提示",text: "设置失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "设置异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };

</script>