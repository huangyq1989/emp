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
                <div style="text-align: center; padding:15px;margin-top: 2%;" id="div_t">
                    <form id="formMessage" name="formMessage" style="padding: 0px 80px 20px 20px;">
                        <table width="100%" border="0" width="650" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <input type="hidden" id="id" name="id" value="${examination.id}"/>
                            <tr>
                                <td width="15%"><font color="red">*</font>考试名称：</td>
                                <td width="30%"><input type="text" id="examinationName" name="examinationName" maxlength="20" value="${examination.examinationName}" placeholder="考试名称限定在20个字以内..." style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>培训课程：</td>
                                <td width="30%">
                                    <input type="hidden" id="cultivateId" name="cultivateId" value="${examination.cultivateId}"/>
                                    <select id="cultivateSelect" name="cultivateSelect" onchange="getType();" style="width: 100%"></select>
                                </td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>课程类型：</td>
                                <td width="30%"><input type="text" id="cultivateType" name="cultivateType" disabled="disabled" style="background:#CCCCCC;width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>计时方式：</td>
                                <td width="30%">
                                    <input type="hidden" id="timingMode" name="timingMode" value="${examination.timingMode}"/>
                                    <select id="timingModeSelect" name="timingModeSelect" style="width: 100%" onchange="selectTimingMode();">
                                        <option value="0" <c:if test="${examination.timingMode=='0'}"> selected="selected"</c:if> >考试时间开始计时</option>
                                        <option value="1" <c:if test="${examination.timingMode=='1'}"> selected="selected"</c:if> >打开试卷时间计时</option>
                                    </select>
                                </td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>考试限时时间：</td>
                                <td width="30%"><input type="number" id="examinationTimeLimit" name="examinationTimeLimit" style="width:85%" value="${examination.examinationTimeLimit}"/>分钟</td>
                            </tr>

                            <tr>
                                <td width="15%"><font color="red">*</font>考试开始时间：</td>
                                <td width="30%">
                                    <input type="text" id="examinationTime" name="examinationTime" style="width:100%" value="${examination.examinationTime}"/>
                                </td>
                                <td width="10%"></td>
                                <td width="15%">考试结束时间：</td>
                                <td width="30%">
                                    <input type="text" id="examinationEndTime" name="examinationEndTime" style="width:100%" value="${examination.examinationEndTime}"/>
                                </td>
                            </tr>


                            <tr>
                                <td width="15%"><font color="red">*</font>是否需要补考：</td>
                                <td width="30%">
                                    <input type="hidden" id="isResit" name="isResit" value="${examination.isResit}"/>
                                    <select id="isResit_t" name="isResit_t" style="width: 100%;" onchange="selectIsResit();">
                                        <option value="0" <c:if test="${examination.isResit=='0'}">selected="selected"</c:if> >否</option>
                                        <option value="1" <c:if test="${examination.isResit=='1'}">selected="selected"</c:if> >是</option>
                                    </select>
                                </td>
                                <td width="10%"></td>

                                <td width="15%">补考次数：</td>
                                <td width="30%"><input type="number" id="makeupNum" name="makeupNum" style="width:90%;background:#CCCCCC" value="${examination.makeupNum}" readonly="true"/>次</td>
                            </tr>
                            <tr>
                                <td width="15%">补考开始时间：</td>
                                <td width="30%">
                                    <input type="text" id="makeupBeginTime" name="makeupBeginTime" style="width:100%" value="${examination.makeupBeginTime}"/>
                                </td>
                                <td width="10%"></td>
                                <td width="15%">补考最后期限：</td>
                                <td width="30%">
                                    <input type="text" id="makeupTime" name="makeupTime" style="width:100%" value="${examination.makeupTime}"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>及格分数线：</td>
                                <td width="30%">
                                    <input type="number" id="passingScoreLine" name="passingScoreLine" style="width:100%" value="${examination.passingScoreLine}"/>
                                </td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>试题和选项乱序：</td>
                                <td width="30%">
                                    <input type="hidden" id="isDisorder" name="isDisorder" value="${examination.isDisorder}"/>
                                    <select id="isDisorder_t" name="isDisorder_t" style="width: 100%;">
                                        <option value="0" <c:if test="${examination.isDisorder=='0'}">selected="selected"</c:if> >否</option>
                                        <option value="1" <c:if test="${examination.isDisorder=='1'}">selected="selected"</c:if> >是</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%">导入试卷：</td>
                                <td width="30%">
                                    <select id="importFlag" name="importFlag" style="width: 100%;" onchange="selectImportFlag();">
                                        <option value="0" selected="selected">否</option>
                                        <option value="1">是</option>
                                    </select>
                                </td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>开放答题解析：</td>
                                <td width="30%">
                                    <input type="hidden" id="isAnswerAnalysis" name="isAnswerAnalysis" value="${examination.isAnswerAnalysis}"/>
                                    <select id="isAnswerAnalysis_t" name="isAnswerAnalysis_t" style="width: 100%;">
                                        <option value="0" <c:if test="${examination.isAnswerAnalysis=='0'}">selected="selected"</c:if> >否</option>
                                        <option value="1" <c:if test="${examination.isAnswerAnalysis=='1'}">selected="selected"</c:if> >是</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="testPaperData" name="testPaperData"/>
                        <input type="hidden" id="totalScore" name="totalScore"/>
                    </form>
                    <div>
                        <font color="red" id="errorMessage"></font>
                    </div>
                </div>


                <div style="background: #fafafa; color:#080808;border:1px solid #808080;margin-right: 1%;margin-left: 1%;" id="importDiv">
                    <div style="float: left;width: 1200px;">
                        <div style="margin-top: 1%;">
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">1.试题内容请填写在导入内容下进行编辑，正确答案请写在@()里面.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">2.题目与题目之间需空一行，题目可以不加题号，题干中间不得换行.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">3.题目类型只有单选题，多选题以及判断题，请在题目上一行的[XXX]正确填写.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">4.题干与选项，及各选项之间需回车换行，选项不得以数字开头（会被识别为题干).</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">5.多选题有个得分类型, 0:少选得部分分, 1:少选不得分,请写在(得分类型:X)里面.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">6.答题解析写在每题最后, 以#]开始, 可不写.</label>
                            <div style="margin-left: 50%;">
                                <!-- 上传域 -->
                                <form id="signupForm" method="post" enctype="multipart/form-data" >
                                    请选择要导入的模板：<input type="file" accept="application/vnd.openxmlformats-officedocument.wordprocessingml.document" name="SensitiveExcle" id="SensitiveExcle" style="height: 26px;" class="files" size="1" hidefocus/>
                                </form>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="button" id="download" name="download" value="模板下载" onclick="download();" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="button" id="delete" name="delete" value="导入并预览" onclick="importAndCheck()" style="border-radius:9px;background-color:snow;color: #333333;width:90px;height:30px"/>
                            </div>
                        </div>
                    </div>
                    <div style="margin-top: 18%;height:320px;">
                        <div style="margin:15px;height:310px;border:1px solid #808080;overflow:auto;" id="content"></div>
                    </div>
                </div>


                <div style="text-align: center;padding: 100px 0px 100px 0px;" id="btn">
                    <input type="button" id="ok" name="ok" onclick="save();" value="确    认" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
        </div>
    </body>

</html>


<script type="text/javascript">

    //培训信息
    var cultivateList = '${cultivateList}';
    cultivateList = $.parseJSON(cultivateList);
    //试卷json数据
    var jsonData = [];


    var loadWidth = 0;
    var loadHeight = 0;

    //初始化加载数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;


        if (cultivateList.total == 0) {
            document.getElementById("ok").style.display="none";//按钮隐藏
            swal({title: '错误提示',text: "目前没有培训课程,请先在培训管理新增课程",type: "error",icon: "success",button: "确定"}, function(){window.close();});
        }

        //加载培训课程
        var sel = document.getElementById("cultivateSelect");
        for(var i=0;i<cultivateList.rows.length;i++){
            sel.options.add(new Option(cultivateList.rows[i].cultivateName,cultivateList.rows[i].id));
            if(i == 0){//初始化第一个cultivateType
                document.getElementById("cultivateType").value = cultivateList.rows[i].cultivateType;
            }
            var input = '<input type="hidden" name="cultivateType_'+cultivateList.rows[i].id+'" id="cultivateType_'+cultivateList.rows[i].id+'" value="'+cultivateList.rows[i].cultivateType+'"/>';
            $('body').append(input);//添加到body
        }
        <c:if test="${examination.id != null}">
            //根据value选中select的option
            var selectId = document.getElementById("cultivateId").value;
            $("#cultivateSelect").val(selectId);
            getType();
        </c:if>

        easyuiUtils.lang_zh_CN();//加载easyui中文支持
        //加载时间控件
        $('#examinationTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        $('#examinationEndTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        $('#makeupBeginTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        $('#makeupTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });

        //初始化计时方式的样式
        selectTimingMode();

        //初始化是否需要补考的样式
        selectIsResit();

        document.getElementById("importDiv").style.display = "none";//默认隐藏导入
    });


    //动态获取培训类型
    function getType() {
        var dataSelect = document.getElementById("cultivateSelect");
        var sValue = dataSelect.options[dataSelect.selectedIndex].value;
        sValue = "cultivateType_"+sValue;
        document.getElementById("cultivateType").value = document.getElementById(sValue).value;
    };



    //计时方式
    function selectTimingMode(){
        //获取被选中的option标签
        var timingModeSelect_t = document.getElementById("timingModeSelect");
        var vs = timingModeSelect_t.options[timingModeSelect_t.selectedIndex].value;
        if(vs == 0) {
            $('#examinationEndTime').datetimebox('disable');
            $('#examinationEndTime').combo('setText','');
        }else{
            $('#examinationEndTime').datetimebox('enable');
        }
    };



    //是否需要补考
    function selectIsResit(){
        //获取被选中的option标签
        var isResit_t = document.getElementById("isResit_t");
        var vs = isResit_t.options[isResit_t.selectedIndex].value;
        if(vs == 0) {
            document.getElementById("makeupNum").style.backgroundColor = "#CCCCCC";
            document.getElementById("makeupNum").setAttribute("readonly",true);
            document.getElementById("makeupNum").value = "";
            $('#makeupBeginTime').datetimebox('disable');
            $('#makeupBeginTime').combo('setText','');
            $('#makeupTime').datetimebox('disable');
            $('#makeupTime').combo('setText','');
        }else{
            document.getElementById("makeupNum").style.backgroundColor = "white";
            document.getElementById("makeupNum").removeAttribute("readonly");
            $('#makeupBeginTime').datetimebox('enable');
            $('#makeupTime').datetimebox('enable');
        }
    };


    //是否需要导入试卷
    function selectImportFlag(){
        //获取被选中的option标签
        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs == 0) {
            document.getElementById("importDiv").style.display = "none";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 2%;";
        // <div style="text-align: center; padding:15px;margin-top: 2%;" id="div_t">
        // <div style="text-align: center;padding: 100px 0px 100px 0px;" id="btn">
            document.getElementById("btn").style = "text-align: center;padding: 100px 0px 100px 0px;";
        }else{
            document.getElementById("importDiv").style.display = "";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 1%;";
            document.getElementById("btn").style = "text-align: center;padding: 40px 0px 50px 0px;";
        }
    };



    //下载模板
    function download() {
        window.location.href = '${pageContext.request.contextPath}/importModel/试题导入模板.docx';
    };



    //上传文件并校验
    function importAndCheck(){
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: "错误提示",text: "请先选择需要导入的试题模板",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        var filesList = document.querySelector('#SensitiveExcle').files;
        if(filesList.length==0){//如果取消上传，则改文件的长度为0
            return;
        }else{//如果有文件上传，这在这里面进行
            if(filesList[0].size > 5000000){
                swal({title: "错误提示",text: "上传的文件不能超过5MB,请重新选择",type: "error",confirmButtonText: "确  定"},function(){
                    jsonData = [];
                    document.getElementById('SensitiveExcle').value="";//清空上传文件
                    document.getElementById('content').innerHTML = "";
                });
                return false;
            }

            // 清空内容
            document.getElementById('content').innerHTML = "";
            jsonData = [];
            loadShow();
            var formData = new FormData($('#signupForm')[0]);
            $.ajax({
                url : "${pageContext.request.contextPath}/fileUpload/UploadServlet?type=testPaper",
                type: 'POST',
                data: formData,
                async: true,
                cache: false,
                contentType: false,
                processData: false,
                error : function(request) {
                    loadHide();
                    swal({title: "错误提示",text: "系统异常，请联系管理员!",type: "error",confirmButtonText: "确  定"},function(){
                        //报错或失败后还原
                        document.getElementById('SensitiveExcle').value="";//清空上传文件
                        jsonData = [];
                    });
                },
                success : function(data) {
                    loadHide();
                    var result = $.parseJSON(data);
                    if (result.flag == 0) {
                        if(result.errorMessage != ""){
                            swal({title: "错误提示",text: result.errorMessage,type: "error",confirmButtonText: "确  定"});
                        }
                        var div = document.getElementById('content');
                        for(var n=0;n<result.list.length;n++){
                            var rows = $.parseJSON(result.list[n]);

                            //计算第几题
                            var question_num = Number(n+1);

                            var problemsType = "";
                            var inputType = "";
                            var op1 = "";
                            var op2 = "";
                            if(rows.subjectType == 0 || rows.subjectType == 1){
                                if(rows.subjectType == 0){
                                    problemsType = "【单选题】";
                                    inputType = "radio";
                                }else{
                                    problemsType = "【多选题】";
                                    inputType = "checkbox";
                                }
                            }else{
                                problemsType = "【判断题】";
                                inputType = "radio";
                            }
                            var answerAnalysisText = "";
                            if(rows.answerAnalysis != "" && rows.answerAnalysis != undefined){
                                answerAnalysisText = "答题解析 : "+rows.answerAnalysis;
                            }else{
                                answerAnalysisText = "";
                            }
                            var message =
                                '<div style="border:1px solid #808080;" id="'+question_num+'" name="question">\n' +
                                '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                                '        <lable style="color: #000000;font-size:17px;">'+question_num+'</lable>.\n' +
                                '        <lable style="color: #000000;font-size:17px;">'+rows.title+'</lable>\n' +
                                '        <lable style="color: #FF9966;font-size:17px;">（'+rows.score+'分）</lable>\n' +
                                '        <lable style="color: #FF9966;font-size:17px;">'+problemsType+'</lable>\n' ;
                            if(rows.subjectType == 1){//多选
                                var t_scoreType = "";
                                if(rows.scoreType == 0){
                                    t_scoreType = "少选得部分分";
                                }else if(rows.scoreType == 1){
                                    t_scoreType = "少选不得分";
                                }
                                message = message +
                                    '    <lable style="color: #FF9966;font-size:17px;">['+t_scoreType+']</lable>\n';
                            }
                            message = message +
                                '    </div>\n' +
                                '    <div id="showAnswer_'+question_num+'">\n' ;//选项和正确答案显示
                            for(var c=0;c<rows.op.length;c++){
                                message = message +
                                '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                                '            <input name="show_input_'+question_num+'" type="'+inputType+'" onClick="javascript:return false"';
                                for(var l=0;l<rows.trueAnswer.length;l++){
                                    if(Number(c+1) == rows.trueAnswer[l]){
                                        message = message + 'checked="checked"/>\n' ;
                                        break;
                                    }else if(l == (rows.trueAnswer.length-1)){
                                        message = message + '/>\n' ;
                                    }
                                }
                                message = message +
                                '            <lable style="font-size:16px;">'+rows.op[c]+'</lable>\n' ;
                                for(var z=0;z<rows.trueAnswer.length;z++){
                                    if(Number(c+1) == rows.trueAnswer[z]){
                                        message = message +
                                        '    <lable style="font-size:16px;color: #67b168;">（正确答案）</lable>\n' ;
                                        break;
                                    }
                                }
                                message = message +
                                '        </div>\n' ;
                            }
                            message = message +
                                '    <div style="margin-top: 2%;margin-left: 4%;">\n' +
                                '        <lable style="color: purple;font-size:15px;">'+answerAnalysisText+'</lable>\n' +
                                '    </div>\n' +
                                '    <div style="clear: both;"></div>\n' +
                                '    <br><br><br>\n' +
                                '</div>';

                            //在最后加
                            $("#content").append(message);

                            //选中题目类型
                            $("#subjectType_"+question_num).find("option[value = '"+rows.subjectType+"']").attr("selected","selected");
                            if(rows.subjectType == 1){//多选,选中得分类型
                                $("#scoreType_"+question_num).find("option[value = '"+rows.scoreType+"']").attr("selected","selected");
                            }

                            <!-- 添加到json数组 -->
                            jsonData.push(rows);
                        }
                    } else {
                        swal({title: "错误提示",text: result.message,type: "error",confirmButtonText: "确  定"},function(){
                            //报错或失败后还原
                            document.getElementById('SensitiveExcle').value="";//清空上传文件
                            jsonData = [];
                        });
                    }
                }
            });
        }
    };



    //保存
    function save() {
        var examinationName = document.getElementById("examinationName").value.trim();
        if(examinationName == ""){
            swal({title: "错误提示",text: "考试名称不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.examinationName.focus();},0);
            });
            return false;
        }

        var dataSelect = document.getElementById("cultivateSelect");
        document.formMessage.cultivateId.value = dataSelect.options[dataSelect.selectedIndex].value;

        var examinationTime = document.getElementById("examinationTime").value.trim();
        var examinationEndTime = document.getElementById("examinationEndTime").value.trim();
        var examinationTimeLimit = document.getElementById("examinationTimeLimit").value.trim();
        if(examinationTime == ""){
            swal({title: "错误提示",text: "考试开始时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }

        var timeSelect = document.getElementById("timingModeSelect");
        document.formMessage.timingMode.value = timeSelect.options[timeSelect.selectedIndex].value;
        var vs = timeSelect.options[timeSelect.selectedIndex].value;
        if(vs == 1) {
            if(examinationEndTime == ""){
                swal({title: "错误提示",text: "考试结束时间不能为空",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date(examinationTime);
                var oDate2 = new Date(examinationEndTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "考试结束时间不能小于考试开始时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }

        if(examinationTimeLimit == "" || examinationTimeLimit < 0){
            swal({title: "错误提示",text: "考试限时时间不能为空并只能为正整数",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.examinationTimeLimit.focus();},0);
            });
            return false;
        }else if(examinationTimeLimit > 300){
            swal({title: "错误提示",text: "考试限时时间不能超过300分钟",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.examinationTimeLimit.focus();},0);
            });
            return false;
        }


        var makeupBeginTime = document.getElementById("makeupBeginTime").value.trim();
        var makeupTime = document.getElementById("makeupTime").value.trim();
        var makeupNum = document.getElementById("makeupNum").value.trim();
        var isResit_t = document.getElementById("isResit_t");
        document.formMessage.isResit.value = isResit_t.options[isResit_t.selectedIndex].value;
        var vs1 = isResit_t.options[isResit_t.selectedIndex].value;
        if(vs1 == 1) {
            if(makeupBeginTime == ""){
                swal({title: "错误提示",text: "补考开始时间不能为空",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date(examinationTime);
                var oDate2 = new Date(makeupBeginTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "补考开始时间不能小于考试开始时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }

            if(makeupTime == ""){
                swal({title: "错误提示",text: "补考最后期限不能为空",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date(makeupBeginTime);
                var oDate2 = new Date(makeupTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "补考最后期限不能小于补考开始时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }
            if(makeupNum == "" || makeupNum < 0){
                swal({title: "错误提示",text: "补考次数不能为空并只能为正整数",type: "error",confirmButtonText: "确  定"},function(){
                    setTimeout(function(){document.formMessage.makeupNum.focus();},0);
                });
                return false;
            }
        }else{
            document.getElementById("makeupNum").value = "0";//默认为0
        }


        var passingScoreLine = document.getElementById("passingScoreLine").value.trim();
        if(passingScoreLine == "" || passingScoreLine < 0){
            swal({title: "错误提示",text: "及格分数线不能为空并只能为正整数",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.passingScoreLine.focus();},0);
            });
            return false;
        }

        var isDisorder_t = document.getElementById("isDisorder_t");
        document.formMessage.isDisorder.value = isDisorder_t.options[isDisorder_t.selectedIndex].value;

        var isAnswerAnalysis_t = document.getElementById("isAnswerAnalysis_t");
        document.formMessage.isAnswerAnalysis.value = isAnswerAnalysis_t.options[isAnswerAnalysis_t.selectedIndex].value;



        //试卷校验
        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs != 0) {//需要导入试卷
            if(jsonData.length == 0){
                swal({title: '错误提示',text: "请先导入数据",type: "error",confirmButtonText: "确  定"});
                return false;
            }
            var param = JSON.stringify(jsonData);//json转string
            document.getElementById("testPaperData").value = param;
            var totalScore = 0;
            //计算总分
            for(var k=0;k<jsonData.length;k++){
                totalScore = Number(totalScore) + (jsonData[k].score)
            }
            document.getElementById("totalScore").value = totalScore;
        }


        //表单序列化
        var examination = $('#formMessage').serialize();
        loadShow();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/save.do",
            data: examination,
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
                }else{
                    swal({title: "错误提示",text: data.detail,type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                loadHide();
                swal({title: "错误提示",text: "系统异常,请联系管理员!",type: "error",confirmButtonText: "确  定"});
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