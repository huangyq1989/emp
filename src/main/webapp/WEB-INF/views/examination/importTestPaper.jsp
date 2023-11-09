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
        <title>导入试题</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;border:1px solid #808080;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-试题批量导入</label>
            </div>
            <div style="float: left;width: 1200px">
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
                    <div style="margin-left: 60%;">
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
            <div style="margin-top: 17%;height:500px;">
                <div style="margin:15px;height:410px;border:1px solid #808080;overflow:auto;" id="content"></div>
                <div style="text-align: center;padding: 10px 0px 30px 0px;">
                    <input type="button" onclick="saveTestPaper();" value="保    存" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
        </div>
        <input type="hidden" id="id" name="id" value="${testPaperExamination.id}"/>
    </body>
</html>


<script type="text/javascript">

    //试题json数据
    var jsonData = [];

    var loadWidth = 0;
    var loadHeight = 0;


    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        <c:choose>
            <c:when test="${not empty testPaperExamination}">
                swal({
                    title: "提示",
                    text: "该考试已有试题,再导入会覆盖掉之前的试题,确定要进行导入吗?",
                    type: "warning",
                    showCancelButton: true,// 是否显示取消按钮
                    confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                    confirmButtonText: "确定导入",// 确定按钮的 文字
                    cancelButtonText: "取消导入",// 取消按钮的 文字
                    // closeOnConfirm: false, //确认再提示
                    closeOnCancel: false //关闭再提示
                },
                function(isConfirm){
                    if (isConfirm) {
                        // swal("确定", "你的虚拟文件已经被删除。","success");
                    } else {
                        window.close();
                    }
                });
            </c:when>
            <c:otherwise>
            </c:otherwise>
        </c:choose>
    });

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


    //保存试卷
    function saveTestPaper(){
        //判断是否已经上传文件
        var fileName = document.getElementById('SensitiveExcle').value;
        if(fileName == "" || fileName == null){
            swal({title: '错误提示',text: "请先点击试题导入，选择需要导入的试题模板",type: "error",confirmButtonText: "确  定"});
            return false;
        }else if(jsonData.length == 0){
            swal({title: "错误提示",text: "请先导入并预览",type: "error",confirmButtonText: "确  定"});
            return false;
        }else{
            var totalScore = 0;
            //计算总分
            for(var k=0;k<jsonData.length;k++){
                totalScore = Number(totalScore) + (jsonData[k].score)
            }

            <c:choose>
                <c:when test="${not empty testPaperExamination}">
                    swal({
                        title: "提示",
                        text: "该考试已有试题,保存会覆盖掉之前的试题,确定保存吗?",
                        type: "warning",
                        showCancelButton: true,// 是否显示取消按钮
                        confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                        confirmButtonText: "确定保存",// 确定按钮的 文字
                        cancelButtonText: "取消保存",// 取消按钮的 文字
                        closeOnConfirm: false, //确认再提示
                        // closeOnCancel: false //关闭再提示
                    },
                    function(isConfirm){
                        if (isConfirm) {
                            var param = JSON.stringify(jsonData);//json转string
                            var t_id = document.getElementById("id").value;
                            $.ajax({
                                type: "post",
                                url: "${pageContext.request.contextPath}/examination/saveTestPaper.do?&examinationId=${examinationId}&id="+t_id+"&totalScore="+totalScore,
                                data: {"jsonData":param},
                                traditional:true,
                                async:false,
                                dataType:"json",
                                success: function(data){
                                    if(data == 0){
                                        // 1秒定时关闭弹窗
                                        swal({title: "提示",text: "保存成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                                            window.close();
                                        });
                                    }else{
                                        swal({title: "错误提示",text: "保存失败" ,type: "error",confirmButtonText: "确  定"});
                                    }
                                },
                                error: function(){
                                    swal({title: "错误提示",text: "保存异常,请联系管理员" ,type: "error",confirmButtonText: "确  定"});
                                }
                            });
                        } else {
                        }
                    });
                </c:when>
                <c:otherwise>
                    var param = JSON.stringify(jsonData);//json转string
                    var t_id = document.getElementById("id").value;
                    $.ajax({
                        type: "post",
                        url: "${pageContext.request.contextPath}/examination/saveTestPaper.do?&examinationId=${examinationId}&id="+t_id+"&totalScore="+totalScore,
                        data: {"jsonData":param},
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(data){
                            if(data == 0){
                                // 1秒定时关闭弹窗
                                swal({title: "提示",text: "保存成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                                    window.close();
                                });
                            }else{
                                swal({title: "错误提示",text: "保存失败" ,type: "error",confirmButtonText: "确  定"});
                            }
                        },
                        error: function(){
                            swal({title: "错误提示",text: "保存异常,请联系管理员" ,type: "error",confirmButtonText: "确  定"});
                        }
                    });
                </c:otherwise>
            </c:choose>
        }
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