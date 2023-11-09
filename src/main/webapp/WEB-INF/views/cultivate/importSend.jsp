<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="../loadPage.jsp"/>
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
        <title>导入收件人</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">导入收件人</label>
            </div>
            <div style="text-align:left;margin-top: 1%;margin-left: 3%">
                <!-- 上传域 -->
                <form id="signupForm" method="post" enctype="multipart/form-data" >
                    请选择要导入的模板：<input type="file" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" name="SensitiveExcle" id="SensitiveExcle" style="height: 26px;" class="files" size="1" hidefocus/>
                </form><br>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" id="download" name="download" value="模板下载" onclick="download();" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" id="delete" name="delete" value="导入并预览" onclick="importAndCheck()" style="border-radius:9px;background-color:snow;color: #333333;width:90px;height:30px"/>
            </div>
            <div style="text-align: center; padding:15px;;color: #9EA7B4;">
                <font color="red" id="resultMessage"></font>
            </div>
            <div style="border:1px solid #808080">
                <div style="text-align: center; padding:15px;height: 300px;overflow:auto;">
                    <form id="formMessage" name="formMessage" style="padding: 0px 80px 20px 20px;">
                        <table width="100%" width="700" height="50" border="1" bordercolor="#000000" style="border-collapse:collapse" id="resultTable">
                            <tr bgcolor="#b0e0e6"><td>序号</td><td>姓名</td><td>手机号码</td><td>校验结果</td></tr>
                        </table>
                    </form>
                </div>
                <div style="text-align: center;padding: 20px 0px 30px 0px;">
                    <input type="button" onclick="saveImportData();" value="保    存" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
        </div>
    </body>
</html>


<script type="text/javascript">

    //校验后的json数据
    var jsonData = [];


    //下载模板
    function download() {
        window.location.href = '${pageContext.request.contextPath}/importModel/导入收件人模板.xlsx';
    };


    //上传文件并校验
    function importAndCheck(){
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: "错误提示",text: "请先选择需要导入的收件人模板",type: "error",confirmButtonText: "确  定"});
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
                    //清除提示
                    document.getElementById('resultMessage').innerText = "";
                    // jQuery删除table除第一行标题以外的所有数据行
                    $("#resultTable tbody tr").eq(0).nextAll().remove();
                    jsonData = [];
                });
                return false;
            }else{
                loadShow();
                //清除提示
                document.getElementById('resultMessage').innerText = "";
                // jQuery删除table除第一行标题以外的所有数据行
                $("#resultTable tbody tr").eq(0).nextAll().remove();
                jsonData = [];

                var formData = new FormData($('#signupForm')[0]);
                $.ajax({
                    url : "${pageContext.request.contextPath}/fileUpload/UploadServlet?type=sendNode",
                    type: 'POST',
                    data: formData,
                    async: true,
                    cache: false,
                    contentType: false,
                    processData: false,
                    error : function(request) {
                        loadHide();
                        swal({title: "错误提示",text: "系统异常，请联系管理员",type: "error",confirmButtonText: "确  定"});
                    },
                    success : function(data) {
                        loadHide();
                        var result = $.parseJSON(data);
                        jsonData = result;
                        if (result.flag == 0) {
                            document.getElementById('resultMessage').innerHTML = "总导入:"+result.count+"人&nbsp;&nbsp;&nbsp;&nbsp;可成功导入:"+(result.count-result.failNum)+"人&nbsp;&nbsp;&nbsp;&nbsp;导入失败:"+result.failNum+"人";
                            for(var i=0;i<result.list.length;i++){
                                var x = document.getElementById("resultTable").insertRow(i+1);
                                var one = x.insertCell(0);
                                var two = x.insertCell(1);
                                var three= x.insertCell(2);
                                var four = x.insertCell(3);
                                one.innerHTML = result.list[i].no;
                                two.innerHTML = result.list[i].realName;
                                three.innerHTML = result.list[i].phone;
                                four.innerHTML = result.list[i].errorMsg;
                            }
                        } else {
                            swal({title: "错误提示",text: result.message ,type: "error",confirmButtonText: "确  定"});
                        }
                    }
                });
            }
        }
    };



    <%--//如果上面的方法响应到后端得到的contentType为false，则使用这个方法--%>
    <%--var xmlHttp;--%>
    <%--//XmlHttpRequest对象--%>
    <%--function createXmlHttpRequest(){--%>
    <%--    if(window.ActiveXObject){ //如果是IE浏览器--%>
    <%--        return new ActiveXObject("Microsoft.XMLHTTP");--%>
    <%--    }else if(window.XMLHttpRequest){ //非IE浏览器--%>
    <%--        return new XMLHttpRequest();--%>
    <%--    }--%>
    <%--};--%>
    <%--//回调函数--%>
    <%--function callback() {--%>
    <%--    //判断对象状态是否交互完成，如果为4则交互完成--%>
    <%--    if(xmlHttp.readyState == 4) {--%>
    <%--        //判断对象状态是否交互成功,如果成功则为200--%>
    <%--        if(xmlHttp.status == 200) {--%>
    <%--            loadHide();--%>
    <%--            //接收数据,得到服务器输出的纯文本数据--%>
    <%--            var responseT = xmlHttp.responseText;--%>
    <%--            var result = $.parseJSON(responseT);--%>
    <%--            jsonData = result;--%>
    <%--            if (result.flag == 0) {--%>
    <%--                document.getElementById('resultMessage').innerHTML = "<font color='#985f0d'>总导入:"+result.count+"人&nbsp;&nbsp;&nbsp;&nbsp;可成功导入:<font color='green'>"+(result.count-result.failNum)+"人</font>&nbsp;&nbsp;&nbsp;&nbsp;导入失败:<font color='red'>"+result.failNum+"人</font></font>";--%>
    <%--                for(var i=0;i<result.list.length;i++){--%>
    <%--                    var x = document.getElementById("resultTable").insertRow(i+1);--%>
    <%--                    var one = x.insertCell(0);--%>
    <%--                    var two = x.insertCell(1);--%>
    <%--                    var three= x.insertCell(2);--%>
    <%--                    let color = "green";--%>
    <%--                    if(result.list[i].errorMsg != '成功'){--%>
    <%--                        color = "red";--%>
    <%--                    }--%>
    <%--                    one.innerHTML = " <font color='"+color+"'>"+ result.list[i].lineNumber +"</font> " ;--%>
    <%--                    two.innerHTML = " <font color='"+color+"'>"+ result.list[i].phone +"</font> " ;--%>
    <%--                    three.innerHTML = " <font color='"+color+"'>"+ result.list[i].errorMsg +"</font> " ;--%>
    <%--                }--%>
    <%--            } else {--%>
    <%--                swal({title: "错误提示",text: result.message ,type: "error",confirmButtonText: "确  定"});--%>
    <%--            }--%>
    <%--        }--%>
    <%--    }--%>
    <%--};--%>
    <%--//上传文件并校验--%>
    <%--function importAndCheck(){--%>
    <%--    var fileName = document.getElementById('SensitiveExcle').value;--%>
    <%--    if(fileName == "" || fileName == null){--%>
    <%--        swal({title: "错误提示",text: "请先选择需要导入的收件人模板",type: "error",confirmButtonText: "确  定"});--%>
    <%--        return false;--%>
    <%--    }--%>
    <%--    var filesList = document.querySelector('#SensitiveExcle').files;--%>
    <%--    if (filesList.length == 0) {//如果取消上传，则改文件的长度为0--%>
    <%--        return;--%>
    <%--    } else {//如果有文件上传，这在这里面进行--%>
    <%--        if (filesList[0].size > 5000000) {--%>
    <%--            swal({title: "错误提示",text: "上传的文件不能超过5MB,请重新选择",type: "error",confirmButtonText: "确  定"},function(){--%>
    <%--                //清空上传文件--%>
    <%--                document.getElementById('SensitiveExcle').value = "";--%>
    <%--                //清除提示--%>
    <%--                document.getElementById('resultMessage').innerText = "";--%>
    <%--                // jQuery删除table除第一行标题以外的所有数据行--%>
    <%--                $("#resultTable tbody tr").eq(0).nextAll().remove();--%>
    <%--                jsonData = [];--%>
    <%--            });--%>
    <%--            return false;--%>
    <%--        }else{--%>
    <%--            loadShow();--%>
    <%--            //清除提示--%>
    <%--            document.getElementById('resultMessage').innerText = "";--%>
    <%--            // jQuery删除table除第一行标题以外的所有数据行--%>
    <%--            $("#resultTable tbody tr").eq(0).nextAll().remove();--%>
    <%--            jsonData = [];--%>

    <%--            var formData = new FormData($('#signupForm')[0]);--%>
    <%--            xmlHttp = createXmlHttpRequest();--%>
    <%--            xmlHttp.open("post","${pageContext.request.contextPath}/myFileKServlet?type=importSend",true);--%>
    <%--            xmlHttp.onreadystatechange=callback;--%>
    <%--            xmlHttp.send(formData);--%>
    <%--        }--%>
    <%--    }--%>
    <%--};--%>



    //保存数据
    function saveImportData(){
        if(jsonData.length == 0){
            swal({title: "错误提示",text: "请先导入数据" ,type: "error",confirmButtonText: "确  定"});
            return false;
        }

        var sendData = [];
        for(var i=0;i<jsonData.list.length;i++) {
            var t_row = jsonData.list[i];
            if(t_row.errorMsg == "成功"){
                var row = t_row;
                sendData.push(row);
            }
        }
        if(sendData.length == 0){
            swal({title: "错误提示",text: "可成功导入的数量为0,无需保存" ,type: "error",confirmButtonText: "确  定"});
            return false;
        }
        var param = JSON.stringify(sendData);//json转string
        localStorage.setItem('sendPeople',param);
        // 1秒定时关闭弹窗
        swal({title: "提示",text: "保存成功,返回编辑短信页面",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
            window.close();
            window.opener.window.addPeopleByImport();//执行父窗口方法
        });
    };


</script>