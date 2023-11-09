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
        <!-- easyui -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/default/easyui.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/icon.css" type="text/css"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>${title}</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}</label>
            </div>
            <div style="border:1px solid #808080">
                <div style="text-align: center; padding:15px;margin-top: 7%;" id="div_t">
                    <form id="formMessage1" name="formMessage1" style="padding: 20px 100px 100px 0px;">
                        <table width="100%" border="0" width="600" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <tr>
                                <td>序 号：</td>
                                <td align="left">
                                    <c:choose>
                                        <c:when test="${not empty cultivate.id}">
                                            <input type="hidden" id="id" name="id" value="${cultivate.id}"/>
                                            ${cultivate.id}
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" id="id" name="id" value="${autoId}"/>
                                            ${autoId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>培训名称：</td>
                                <td width="30%"><input type="text" id="cultivateName" name="cultivateName" maxlength="20" style="width:100%" value="${cultivate.cultivateName}"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>培训类型：</td>
                                <td width="30%"><input type="text" id="cultivateType" name="cultivateType" value="${cultivate.cultivateType}" maxlength="10" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>培训开始时间：</td>
                                <td width="30%"><input type="text" id="beginTime" name="beginTime" maxlength="20" style="width:100%" value="${cultivate.beginTime}"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>培训结束时间：</td>
                                <td width="30%"><input type="text" id="endTime" name="endTime" maxlength="20" style="width:100%" value="${cultivate.endTime}"/></td>
                            </tr>
                            <tr>
                                <td width="15%">导入学员：</td>
                                <td width="30%">
                                    <select id="importFlag" name="importFlag" style="width: 100%;" onchange="selectImportFlag();">
                                        <option value="0" selected="selected">否</option>
                                        <option value="1">是</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="sendData" name="sendData"/>
                    </form>
                </div>

                <div style="background: #fafafa; color:#080808;margin-left: 2%;margin-right: 2%;display: none" id="importDiv">
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
                    <div style="text-align: center; padding:15px;;color: #9EA7B4">
                        <font color="red" id="resultMessage"></font>
                    </div>
                    <div style="border:1px solid #808080">
                        <div style="text-align: center; padding:15px;height: 400px;overflow:auto;">
                            <form id="formMessage" name="formMessage" style="padding: 0px 80px 20px 20px;">
                                <table width="100%" width="700" height="50" border="1" bordercolor="#000000" style="border-collapse:collapse" id="resultTable">
                                    <tr bgcolor="#b0e0e6"><td>序号</td><td>姓名</td><td>身份证号码</td><td>手机号码</td><td>校验结果</td></tr>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
                <div style="text-align: center;padding: 0px 0px 180px 0px;">
                    <input type="button" id="btn1" onclick="addOrEdit();" value="保    存" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" id="btn2" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
        </div>
    </body>

</html>


<script type="text/javascript">


    //校验后的导入学员json数据
    var jsonData = [];


    var loadWidth = 0;
    var loadHeight = 0;



    //初始化加载数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        easyuiUtils.lang_zh_CN();//加载easyui中文支持
        //加载时间控件
        $('#beginTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        $('#endTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        // document.getElementById("importDiv").style.display = "none";//默认隐藏导入
    });



    //是否需要导入学员
    function selectImportFlag(){
        //获取被选中的option标签
        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs == 0) {
            document.getElementById("importDiv").style.display = "none";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 7%;";
            document.getElementById("formMessage1").style = "padding: 20px 100px 100px 0px;";
        }else{
            document.getElementById("importDiv").style.display = "";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 1%;";
            document.getElementById("formMessage1").style = "padding: 20px 100px 0px 0px;";
        }
    };



    //下载模板
    function download() {
        window.location.href = '${pageContext.request.contextPath}/importModel/学员导入模板.xlsx';
    };


    //上传文件并校验
    function importAndCheck(){
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: "错误提示",text: "请先选择需要导入的培训导入学员模板",type: "error",confirmButtonText: "确  定"});
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
                    url : "${pageContext.request.contextPath}/fileUpload/UploadServlet?type=cultivate&cultivateId=${cultivateId}&checkType=addPage",
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
                            for(i=0;i<result.list.length;i++){
                                var x = document.getElementById("resultTable").insertRow(i+1);
                                var one = x.insertCell(0);
                                var two = x.insertCell(1);
                                var three= x.insertCell(2);
                                var four = x.insertCell(3);
                                var five = x.insertCell(4);
                                one.innerHTML = result.list[i].no;
                                two.innerHTML = result.list[i].realName;
                                three.innerHTML = result.list[i].idCard;
                                four.innerHTML = result.list[i].phone;
                                five.innerHTML = result.list[i].errorMsg;
                            }
                        } else {
                            swal({title: "错误提示",text: result.message ,type: "error",confirmButtonText: "确  定"});
                        }
                    }
                });
            }
        }
    };


    //保存
    function addOrEdit() {
        var type = "0";
        //判断是新增还是修改
        <c:if test="${cultivate.id != null}">
            type = "1" ;
        </c:if>
        var cultivateName = document.getElementById("cultivateName").value.trim();
        var beginTime = document.getElementById('beginTime').value.trim();
        var endTime = document.getElementById('endTime').value.trim();
        var cultivateType = document.getElementById('cultivateType').value.trim();
        // var cultivateDataCodeSelect = document.getElementById("tmpCultivateDataCode");
        // document.formMessage.cultivateDataCode.value = cultivateDataCodeSelect.options[cultivateDataCodeSelect.selectedIndex].value;
        if(cultivateName == ""){
            //打印后获取焦点
            swal({title: "错误提示",text: "培训名称不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage1.cultivateName.focus();},0);
            });
            return false;
        }
        if(beginTime == ""){
            swal({title: "错误提示",text: "培训开始时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else if(endTime == ""){
            swal({title: "错误提示",text: "培训结束时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else{
            //开始结束时间比较大小
            var oDate1 = new Date(beginTime);
            var oDate2 = new Date(endTime);
            if (oDate1.getTime() > oDate2.getTime()) {
                swal({title: "错误提示",text: "开始培训时间不能大于结束培训时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }
        }
        if(cultivateType == ""){
            swal({title: "错误提示",text: "培训类型不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage1.cultivateType.focus();},0);
            });
            return false;
        }

        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs != 0) {//导入学员
            if(jsonData.length == 0){
                swal({title: "错误提示",text: "请先导入数据" ,type: "error",confirmButtonText: "确  定"});
                return false;
            }
            var t_Data = [];
            for(var i=0;i<jsonData.list.length;i++) {
                var t_row = jsonData.list[i];
                if(t_row.errorMsg == "成功" || t_row.errorMsg == "成功,自动创建学员"){
                    var row = t_row;
                    t_Data.push(row);
                }
            }
            if(t_Data.length == 0){
                swal({title: "错误提示",text: "可成功导入的数量为0,无需保存" ,type: "error",confirmButtonText: "确  定"});
                return false;
            }
            var param = JSON.stringify(t_Data);//json转string
            document.getElementById("sendData").value = param;
        }
        //表单序列化
        var cultivate = $('#formMessage1').serialize();
        loadShow();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/cultivate/saveCultivate.do",
            data: cultivate,
            traditional:true,
            async:true,
            dataType:"json",
            success: function(data){
                loadHide();
                if(data.rCode == 0){
                    // 1秒定时关闭弹窗
                    swal({title: "提示",text: data.detail,showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                        window.close();
                    });
                }else if(data.rCode == 1){
                    swal({title: "错误提示",text: data.detail,type: "error",confirmButtonText: "确  定"},function(){
                        setTimeout(function(){document.formMessage1.cultivateName.focus();},0);
                    });
                }
            },
            error: function(){
                loadHide();
                swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });


</script>