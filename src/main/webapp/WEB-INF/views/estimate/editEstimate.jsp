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
                <div style="text-align: center; padding:15px;margin-top: 12%;" id="div_t">
                    <form id="formMessage" name="formMessage" style="padding: 0px 80px 20px 20px;">
                        <table width="100%" border="0" width="600" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <input type="hidden" id="id" name="id" value="${estimate.id}"/>
                            <tr>
                                <td width="15%"><font color="red">*</font>评估名称：</td>
                                <td width="30%">
                                    <input type="text" id="estimateName" name="estimateName" maxlength="20" value="${estimate.estimateName}" placeholder="评估名称限定在20个字以内..." style="width:100%"/></td>
                                </td>
                                <td width="10%"></td>
                                <td width="15%">作答次数：</td>
                                <td width="30%">
                                    <input type="number" id="answerLimitNum" name="answerLimitNum" style="width:100%" value="${estimate.answerLimitNum}" placeholder="不填为无限制"/>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>评估开始时间：</td>
                                <td width="30%"><input type="text" id="estimateBeginTime" name="estimateBeginTime" style="width:100%" value="${estimate.estimateBeginTime}"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>评估结束时间：</td>
                                <td width="30%"><input type="text" id="estimateEndTime" name="estimateEndTime" style="width:100%" value="${estimate.estimateEndTime}"/></td>
                            </tr>
                            <tr>
                                <td width="15%">培训课程：</td>
                                <td width="30%">
                                    <input type="hidden" id="cultivateId" name="cultivateId" value="${estimate.cultivateId}"/>
                                    <select id="cultivateSelect" name="cultivateSelect" onchange="getType();" style="width: 100%"></select></td>
                                </td>
                                <td width="10%"></td>
                                <td width="15%">课程类型：</td>
                                <td width="30%"><input type="text" id="cultivateType" name="cultivateType" disabled="disabled" style="background:#CCCCCC;width:100%"/></td>
                            </tr>
                            <tr <c:if test="${estimate.id != null}">style="display: none"</c:if>>
                                <td width="15%">导入问卷：</td>
                                <td width="30%">
                                    <select id="importFlag" name="importFlag" style="width: 100%;" onchange="selectImportFlag();">
                                        <option value="0" selected="selected">否</option>
                                        <option value="1">是</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="questionnaireData" name="questionnaireData"/>
                    </form>
                    <div>
                        <font color="red" id="errorMessage"></font>
                    </div>
                </div>


                <div style="background: #fafafa; color:#080808;border:1px solid #808080;margin-right: 1%;margin-left: 1%;" id="importDiv">
                    <div style="float: left;width: 1200px;">
                        <div style="margin-top: 1%;">

                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">1.问卷内容请填写在导入内容下进行编辑，必填题目请在该题后面加@必填.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">2.题目与题目之间需空一行，题目可以不加题号，题干中间不得换行.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">3.题目类型只有单选题，多选题以及简答题，请在题目上一行的[XXX]正确填写.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">4.题干与选项，及各选项之间需回车换行，选项不得以数字开头（会被识别为题干）.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">5.必答的题目在选项最后面加@必答.</label>
                            <div style="clear: both"></div>
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a">6.简答题的字数限制请在题目下面加上(@字数限制XX).</label>
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
                    <div style="margin-top: 19%;height:320px;">
                        <div style="margin:15px;height:310px;border:1px solid #808080;overflow:auto;" id="content"></div>
                    </div>
                </div>


                <div style="text-align: center;padding: 20px 0px 210px 0px;" id="btn">
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
    //问卷json数据
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
        <c:if test="${estimate.id != null}">
            //根据value选中select的option
            var selectId = document.getElementById("cultivateId").value;
            $("#cultivateSelect").val(selectId);
            getType();
        </c:if>

        easyuiUtils.lang_zh_CN();//加载easyui中文支持
        //加载时间控件
        $('#estimateBeginTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        //加载时间控件
        $('#estimateEndTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });

        document.getElementById("importDiv").style.display = "none";//默认隐藏导入
    });


    //动态获取培训类型
    function getType() {
        var dataSelect = document.getElementById("cultivateSelect");
        var sValue = dataSelect.options[dataSelect.selectedIndex].value;
        sValue = "cultivateType_"+sValue;
        document.getElementById("cultivateType").value = document.getElementById(sValue).value;
    };



    //是否需要导入试卷
    function selectImportFlag(){
        //获取被选中的option标签
        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs == 0) {
            document.getElementById("importDiv").style.display = "none";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 9%;";
            document.getElementById("btn").style = "text-align: center;padding: 100px 0px 100px 0px;";
        }else{
            document.getElementById("importDiv").style.display = "";
            document.getElementById("div_t").style = "text-align: center; padding:15px;margin-top: 1%;";
            document.getElementById("btn").style = "text-align: center;padding: 40px 0px 50px 0px;";
        }
    };



    //下载模板
    function download() {
        window.location.href = '${pageContext.request.contextPath}/importModel/问卷导入模板.docx';
    };



    //上传文件并校验
    function importAndCheck(){
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: "错误提示",text: "请先选择需要导入的问卷模板",type: "error",confirmButtonText: "确  定"});
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
                url : "${pageContext.request.contextPath}/fileUpload/UploadServlet?type=questionnaire",
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
                        for(var n=0;n<result.list.length;n++){
                            var rows = $.parseJSON(result.list[n]);

                            //计算第几题
                            var question_num = Number(n+1);

                            //是否必填
                            var temp_requiredFields = "";
                            var t_requiredFields = "";
                            if(rows.requiredFields == 1){
                                temp_requiredFields = "*";
                                t_requiredFields = "checked=\"checked\"";
                            }

                            if(rows.subjectType == 0){//单选
                                var message =
                                    '<div style="border:1px solid #808080;" id="'+question_num+'" name="question">\n' +
                                    '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                                    '        <lable style="color: #f06e57;font-size:17px;">'+temp_requiredFields+'</lable>\n' +
                                    '        <lable style="color: #000000;font-size:17px;">'+question_num+'</lable>.\n' +
                                    '        <lable style="color: #000000;font-size:17px;">'+rows.title+'</lable>\n' +
                                    '        <lable style="color: #FF9966;font-size:17px;">【单选题】</lable>\n'+
                                    '    </div>\n' +
                                    '    <div id="showAnswer_'+question_num+'">\n' ;
                                for(var u=0;u<rows.op.length;u++){
                                    //是否必答
                                    var mustAnswer1 = "";
                                    var mustAnswer2 = "";
                                    if(rows.mustAnswer[u] == 1){
                                        mustAnswer1 = "__________________";
                                        mustAnswer2 = "*";
                                    }
                                    message = message +
                                        '        <div style="margin-top: 1%;margin-left: 8%;">\n'+
                                        '            <input type="radio" onClick="javascript:return false"/>\n' +
                                        '            <lable style="font-size:16px;">'+rows.op[u]+'</lable>\n' +
                                        '            <lable style="font-size:16px;">'+mustAnswer1+'</lable>\n' +
                                        '            <lable style="font-size:16px;color: #f06e57;">'+mustAnswer2+'</lable>\n' +
                                        '        </div>\n' ;
                                }
                                message = message +
                                    '    </div>\n' +
                                    '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                                    '        <div style="margin-left: 10%;;float: left;">\n' +
                                    '            <a style="text-decoration:underline;color:#428bca;font-size:14px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
                                    '            <div style="VISIBILITY: hidden;" onmouseover="MM_showHideLayers(this,2,1);" onmouseout="MM_showHideLayers(this,2,2);">\n' +
                                    '                <input type="button" value="单选" onclick="addNew(0,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="多选" onclick="addNew(1,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="矩阵量表" onclick="addNew(2,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="简答" onclick="addNew(3,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '            </div>\n' +
                                    '        </div>\n' +
                                    '        <div style="float: right;margin-right: 10%;">\n' +
                                    '            <input type="button" value="编辑" onclick="edit(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '            <input type="button" value="删除" onclick="remove(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '        </div>\n' +
                                    '    </div>\n' +
                                    '    <div style="clear: both;"></div>\n' +
                                    '    <br><br><br>\n' +
                                    '</div>';
                            }else if(rows.subjectType == 1) { //多选
                                var message =
                                    '<div style="border:1px solid #808080;" id="' + question_num + '" name="question">\n' +
                                    '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                                    '        <lable style="color: #f06e57;font-size:17px;">' + temp_requiredFields + '</lable>\n' +
                                    '        <lable style="color: #000000;font-size:17px;">' + question_num + '</lable>.\n' +
                                    '        <lable style="color: #000000;font-size:17px;">' + rows.title + '</lable>\n' +
                                    '        <lable style="color: #FF9966;font-size:17px;">【多选题】</lable>\n' +
                                    '    </div>\n' +
                                    '    <div id="showAnswer_' + question_num + '">\n';
                                for (var u = 0; u < rows.op.length; u++) {
                                    //是否必答
                                    var mustAnswer1 = "";
                                    var mustAnswer2 = "";
                                    if (rows.mustAnswer[u] == 1) {
                                        mustAnswer1 = "__________________";
                                        mustAnswer2 = "*";
                                    }
                                    message = message +
                                        '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                                        '            <input type="checkbox" onClick="javascript:return false"/>\n' +
                                        '            <lable style="font-size:16px;">' + rows.op[u] + '</lable>\n' +
                                        '            <lable style="font-size:16px;">' + mustAnswer1 + '</lable>\n' +
                                        '            <lable style="font-size:16px;color: #f06e57;">' + mustAnswer2 + '</lable>\n' +
                                        '        </div>\n';
                                }
                                message = message +
                                    '    </div>\n' +
                                    '    <div style="margin-top: 2%; display: none;" id="btn_' + question_num + '">\n' +
                                    '        <div style="margin-left: 10%;;float: left;">\n' +
                                    '            <a style="text-decoration:underline;color:#428bca;font-size:14px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
                                    '            <div style="VISIBILITY: hidden;" onmouseover="MM_showHideLayers(this,2,1);" onmouseout="MM_showHideLayers(this,2,2);">\n' +
                                    '                <input type="button" value="单选" onclick="addNew(0,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="多选" onclick="addNew(1,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="矩阵量表" onclick="addNew(2,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="简答" onclick="addNew(3,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '            </div>\n' +
                                    '        </div>\n' +
                                    '        <div style="float: right;margin-right: 10%;">\n' +
                                    '            <input type="button" value="编辑" onclick="edit(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '            <input type="button" value="删除" onclick="remove(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '        </div>\n' +
                                    '    </div>\n' +
                                    '    <div style="clear: both;"></div>\n' +
                                    '    <br><br><br>\n' +
                                    '</div>';
                            }else if(rows.subjectType == 3) { //简答题
                                var message =
                                    '<div style="border:1px solid #808080;" id="' + question_num + '" name="question">\n' +
                                    '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                                    '        <lable style="color: #f06e57;font-size:17px;">'+temp_requiredFields+'</lable>\n' +
                                    '        <lable style="color: #000000;font-size:17px;">' + question_num + '</lable>.\n' +
                                    '        <lable style="color: #000000;font-size:17px;">'+rows.title+'</lable>\n' +
                                    '        <lable style="color: #FF9966;font-size:17px;">【简答题】</lable>\n' +
                                    '    </div>\n' +
                                    '    <div id="showAnswer_' + question_num + '">\n' +
                                    '        <textarea rows="6" cols="120" maxlength="3000" id="group" style="margin-left: 4%;margin-top: 2%" readonly></textarea>\n' +
                                    '    </div>\n' +
                                    '    <div style="margin-top: 2%; display: none;" id="btn_' + question_num + '">\n' +
                                    '        <div style="margin-left: 10%;;float: left;">\n' +
                                    '            <a style="text-decoration:underline;color:#428bca;font-size:14px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
                                    '            <div style="VISIBILITY: hidden;" onmouseover="MM_showHideLayers(this,2,1);" onmouseout="MM_showHideLayers(this,2,2);">\n' +
                                    '                <input type="button" value="单选" onclick="addNew(0,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="多选" onclick="addNew(1,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="矩阵量表" onclick="addNew(2,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '                <input type="button" value="简答" onclick="addNew(3,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                                    '            </div>\n' +
                                    '        </div>\n' +
                                    '        <div style="float: right;margin-right: 10%;">\n' +
                                    '            <input type="button" value="编辑" onclick="edit(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '            <input type="button" value="删除" onclick="remove(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                                    '        </div>\n' +
                                    '    </div>\n' +
                                    '    <div style="clear: both;"></div>\n' +
                                    '    <br><br><br>\n' +
                                    '</div>';
                            }
                            <!-- 添加到json数组 -->
                            jsonData.push(rows);
                            //在最后加
                            $("#content").append(message);
                        }
                    } else {
                        swal({title: "错误提示",text: result.errorMessage,type: "error",confirmButtonText: "确  定"},function(){
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
        var estimateName = document.getElementById("estimateName").value.trim();
        if(estimateName == ""){
            swal({title: "错误提示",text: "评估名称不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.estimateName.focus();},0);
            });
            return false;
        }
        var estimateBeginTime = document.getElementById('estimateBeginTime').value.trim();
        var estimateEndTime = document.getElementById('estimateEndTime').value.trim();
        if(estimateBeginTime == ""){
            swal({title: "错误提示",text: "评估开始时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else if(estimateEndTime == ""){
            swal({title: "错误提示",text: "评估结束时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else{
            //开始结束时间比较大小
            var oDate1 = new Date(estimateBeginTime);
            var oDate2 = new Date(estimateEndTime);
            if (oDate1.getTime() > oDate2.getTime()) {
                swal({title: "错误提示",text: "评估开始时间不能大于评估结束时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }
        }
        var answerLimitNum = document.getElementById("answerLimitNum").value.trim();
        if(answerLimitNum != "" && answerLimitNum < 1){
            swal({title: "错误提示",text: "作答次数最少为一次",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.answerLimitNum.focus();},0);
            });
            return false;
        }
        var dataSelect = document.getElementById("cultivateSelect");
        document.formMessage.cultivateId.value = dataSelect.options[dataSelect.selectedIndex].value;



        //问卷校验
        var importFlag = document.getElementById("importFlag");
        var vs = importFlag.options[importFlag.selectedIndex].value;
        if(vs != 0) {//需要导入问卷
            if(jsonData.length == 0){
                swal({title: '错误提示',text: "请先导入数据",type: "error",confirmButtonText: "确  定"});
                return false;
            }
            var param = JSON.stringify(jsonData);//json转string
            document.getElementById("questionnaireData").value = param;
        }


        //表单序列化
        var examination = $('#formMessage').serialize();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/estimate/save.do",
            data: examination,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
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