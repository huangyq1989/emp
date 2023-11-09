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
        <!-- 导出pdf -->
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/pdf/html2canvas.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/pdf/jspdf.debug.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>试卷查看及导出</title>
    </head>
    <body>
        <div>
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-试卷查看及导出</label>
            </div>
            <div >
                <div style="width:24.6%;height:700px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 20%">
                        <label class="am-fl am-form-label" style="font-size:25px;">考题类型：</label>
                        <img class="img" src="${pageContext.request.contextPath}/images/u2292.png">
                    </div>
                    <div style="margin-top: 8%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">考试单选</label>&nbsp;&nbsp;
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">考试多选</label>&nbsp;&nbsp;
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">考试判断</label>&nbsp;&nbsp;
                    </div>

                    <div style="text-align: center;margin-top: 70%;">
                        <%--<input type="button" onclick="exportPdf();" value="导 出 试 题 PDF" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>--%>
                        <br></br>
                        <input type="button" onclick="exportWord();" value="导 出 试 题 Word" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                        <br></br>
                        <input type="button" onclick="window.close();" value="关         闭" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>

                <div style="width:75%;height:700px;float: left;border:1px solid #808080;" id="e_div">
                    <div style="margin-top: 2%;margin-left: 25%;">
                        <label class="am-fl am-form-label" style="font-size:20px;">${title}-培训课考试卷</label>
                        <label class="am-fl am-form-label" style="font-size:16px;color: #169BD5">
                            <font style="margin-left:6%;font-size: 16px;color: #169BD5" id="sum_score">试卷总分：0分</font>
                            <font style="margin-left:6%;color: seagreen" id="passingScoreLine">及格分：0分</font>
                        </label>
                    </div>
                    <div style="height:89.5%; margin-top: 3%;margin-left: 0.5%;border:1px solid #808080;overflow:auto;" id="div_content"></div>
                </div>
            </div>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/examination/exportTestPaper.do?title=${title}" id="dataForm" name="dataForm">
            <input type="hidden" id="examinationId" name="examinationId" value="${testPaperExamination.examinationId}"/>
        </form>
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
            <c:when test="${not empty testPaperExamination}">
                jsonData = ${testPaperExamination.content} ;
                var sumNum = 0;//总分

                for(var n=0;n<jsonData.length;n++){
                    var rows = jsonData[n];

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
                        '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">（'+rows.score+'分）</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">'+problemsType+'</lable>\n' ;
                    if(rows.subjectType == 1){//多选
                        var t_scoreType = "";
                        if(rows.scoreType == 0){
                            t_scoreType = "少选得部分分";
                        }else if(rows.scoreType == 1){
                            t_scoreType = "少选不得分";
                        }
                        message = message +
                            '    <lable style="color: #FF9966;font-size:19px;">['+t_scoreType+']</lable>\n';
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
                            '            <lable style="font-size:18px;">'+rows.op[c]+'</lable>\n' ;
                        for(var z=0;z<rows.trueAnswer.length;z++){
                            if(Number(c+1) == rows.trueAnswer[z]){
                                message = message +
                                    '    <lable style="font-size:18px;color: #67b168;">（正确答案）</lable>\n' ;
                                break;
                            }
                        }
                        message = message +
                            '        </div>\n' ;
                    }
                    message = message +
                    '    <div style="margin-top: 2%;margin-left: 4%;">\n' +
                    '        <lable style="color: purple;font-size:17px;">'+answerAnalysisText+'</lable>\n' +
                    '    </div>\n' +
                    '    <div style="clear: both;"></div>\n' +
                    '    <br><br><br>\n' +
                    '</div>';

                    //在最后加
                    $("#div_content").append(message);

                    //选中题目类型
                    $("#subjectType_"+question_num).find("option[value = '"+rows.subjectType+"']").attr("selected","selected");
                    if(rows.subjectType == 1){//多选,选中得分类型
                        $("#scoreType_"+question_num).find("option[value = '"+rows.scoreType+"']").attr("selected","selected");
                    }

                    //计算总分
                    sumNum = Number(sumNum) + Number(rows.score);
                }
                document.getElementById("sum_score").innerText = '试卷总分：'+sumNum+'分';
                document.getElementById("passingScoreLine").innerText = '及格分：${passingScoreLine}分';
            </c:when>
            <c:otherwise>
                swal({title: '错误提示',text: "试卷不存在,请点击试卷编辑进行添加",type: "error",confirmButtonText: "确  定"},
                    function(){window.close();});
            </c:otherwise>
        </c:choose>
    });


    //导出PDF
    function exportPdf(){
        //先更改样式方便导出
        document.getElementById("e_div").style="width:75%;height:auto;float: left;";

        html2canvas($('#e_div'), {
            allowTaint: true,
            scale: 2 // 提升画面质量，但是会增加文件大小
        }).then(function (canvas) {
            // 得到canvas画布的单位是px 像素单位,获取e_div的长宽
            var contentWidth = canvas.width;
            var contentHeight = canvas.height;

            console.log('contentWidth', contentWidth);
            console.log('contentHeight', contentHeight);
            // 将canvas转为base64图片
            var pageData = canvas.toDataURL('img/notice/png');

            var px = 911;
            var py = contentHeight<700?720:contentHeight+50;//不满700,也就是一页的长度,打印会有问题
            var cx = 900;
            var cy = contentHeight;

            // (纸张大小)初始化jspdf 第一个参数方向：默认''时为纵向，第二个参数设置pdf内容图片使用的长度单位为pt，第三个参数为PDF的大小，单位是pt
            var PDF = new jsPDF('', 'pt', [px/1.2, py/1.2]);

            // (内容大小)将内容图片添加到pdf中，因为内容宽高和pdf宽高一样，就只需要一页，位置就是 0,0
            PDF.addImage(pageData, 'jpeg', 0, 0, cx/1.2, cy/1.2);
            PDF.save('${title}-培训课考试卷.pdf');
        });

        //导出后还原回来
        document.getElementById("e_div").style="width:75%;height:700px;float: left;border:1px solid #808080;";
    };



    //导出word
    function exportWord(){
        $("#dataForm").submit();
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