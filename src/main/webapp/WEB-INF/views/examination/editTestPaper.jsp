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
        <title>试卷编辑</title>
    </head>
    <body>
        <div>
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-试卷编辑</label>
            </div>
            <div >
                <div style="width:24.6%;height:700px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 20%">
                        <label class="am-fl am-form-label" style="font-size:25px;">考题类型：</label>
                    </div>
                    <div style="margin-top: 8%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(0,1,this);">
                        <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">考试单选</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(1,1,this);">
                            <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">考试多选</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(2,1,this);">
                            <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">考试判断</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="text-align: center;margin-top: 25%;">
                        单选题：<input type="number" style="width: 25%;" id="singleChoice"/>
                        <br>
                        多选题：<input type="number" style="width: 25%;" id="multipleChoice"/>
                        <br>
                        判断题：<input type="number" style="width: 25%;" id="judgment"/>
                        <br><br>
                        <input type="button" onclick="updateALLScore();" value="批 量 修 改 分 值" style="border-radius:9px;background-color: #6b9cde;color: snow;width:150px;height:40px"/>
                        <br><br><br><br><br>
                        <input type="button" onclick="checkAndSave();" value="保  存  试  题" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                        <br><br>
                        <input type="button" onclick="window.close();" value="关         闭" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>

                <div style="width:75%;height:700px;float: left;border:1px solid #808080;">
                    <div style="margin-top: 2%;margin-left: 20%;margin-right: 30%;">
                        <label class="am-fl am-form-label" style="font-size:20px;">${title}-培训课考试卷</label>
                        <input type="hidden" id="totalScore" name="totalScore"/>
                        <label class="am-fl am-form-label" style="font-size:16px;float: right;color: #169BD5">
                            试卷总分：<label id="sum_score">0</label>分
                        </label>
                    </div>
                    <div style="height:89.5%; margin-top: 3%;margin-left: 0.5%;border:1px solid #808080;overflow:auto;" id="div_content">
                        <div id="initial_div" style="text-align:center;margin-top: 30%;font-size: 25px;color: #e68900">请根据左边区域的考题类型添加题目</div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="id" name="id" value="${testPaperExamination.id}"/>
    </body>
</html>


<script type="text/javascript">


    var loadWidth = 0;
    var loadHeight = 0;


    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        <c:if test="${testPaperExamination != null}">
            jsonData = ${testPaperExamination.content} ;
            for(var n=0;n<jsonData.length;n++){
                var rows = jsonData[n];

                //隐藏初始提示
                document.getElementById("initial_div").style.display = "none";

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
                var answerAnalysisText2 = "";
                if(rows.answerAnalysis != "" && rows.answerAnalysis != undefined){
                    answerAnalysisText = "答题解析 : "+rows.answerAnalysis;
                    answerAnalysisText2 = rows.answerAnalysis;
                }else{
                    answerAnalysisText = "";
                    answerAnalysisText2 = "";
                }
                var message =
                    '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                    '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                    '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                    '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                    '        <lable style="color: #FF9966;font-size:19px;">（'+rows.score+'分）</lable>\n' +
                    '        <lable style="color: #FF9966;font-size:19px;">'+problemsType+'</lable>\n';
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
                    '    </div>\n' +
                    '    <div style="margin-top: 2%;margin-left: 4%;">\n' +
                    '        <lable style="color: purple;font-size:17px;">'+answerAnalysisText+'</lable>\n' +
                    '    </div>\n' +
                    '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                    '        <div style="margin-left: 10%;;float: left;">\n' +
                    '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
                    '            <div style="VISIBILITY: hidden;" onmouseover="MM_showHideLayers(this,2,1);" onmouseout="MM_showHideLayers(this,2,2);">\n' +
                    '                <input type="button" value="单选" onclick="addNew(0,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                    '                <input type="button" value="多选" onclick="addNew(1,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                    '                <input type="button" value="判断" onclick="addNew(2,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
                    '            </div>\n' +
                    '        </div>\n' +
                    '        <div style="float: right;margin-right: 10%;">\n' +
                    '            <input type="button" value="编辑" onclick="edit(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                    '            <input type="button" value="删除" onclick="remove(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
                    '        </div>\n' +
                    '    </div>\n' +
                    '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                    '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="'+rows.title+'" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                    '	        <option value="0">考试单选</option>\n' +
                    '	        <option value="1">考试多选</option>\n' +
                    '	        <option value="2">考试判断</option>\n' +
                    '	    </select>\n';
                if(rows.subjectType == 1){//多选
                    message = message +
                        '	    <select id="scoreType_'+question_num+'" style="width: 20%" onchange="selectScoreType(this);">\n' +
                        '	        <option value="0">少选得部分分</option>\n' +
                        '	        <option value="1">少选不得分</option>\n' +
                        '	    </select>\n';
                }
                message = message +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">题目分值 </label>\n' +
                    '	    <input type="number" value="'+rows.score+'" onfocus="if(value==&quot;5&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;5&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:20%" onkeyup="reacInChain(this,1);"/>\n' +
                    '	    说明：分值只能是0.5的倍数\n' +
                    '	</div>\n' +
                    '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                    '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:67%">正确答案</label>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div>\n';

                for(var m=0;m<rows.op.length;m++){//选项和正确答案编辑框
                    message = message +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_'+Number(m+1)+'" value="'+rows.op[m]+'" onfocus="if(value==&quot;选项'+Number(m+1)+'&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项'+Number(m+1)+'&quot;}" maxlength="10000" style="width:80%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="'+inputType+'" name="option_'+question_num+'" id="option_'+question_num+'_'+Number(m+1)+'" value="'+Number(m+1)+'" onclick="reacInChain(this,4);" ';
                    for(var l=0;l<rows.trueAnswer.length;l++){
                        if(Number(m+1) == rows.trueAnswer[l]){
                            message = message + 'checked="checked"/>\n' ;
                            break;
                        }else if(l == (rows.trueAnswer.length-1)){
                            message = message + '/>\n' ;
                        }
                    }
                    if(m > 1){
                        message = message + '<a href="###" style="text-decoration:none;float: right;margin-right: 10%;" onclick="removeRow(this);">   ➖</a>'
                    }
                    message = message +
                    '	    </div>\n';
                }
                if(rows.subjectType != 2){//单,多选
                    message = message +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                    '	    </div>\n' ;
                }
                message = message +
                    '	</div>\n' +
                    '	<div style="margin-left: 5% ;margin-top: 2%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">答题解析 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="'+answerAnalysisText2+'"  style="width:70%" onkeyup="reacInChain(this,5);"/>\n' +
                    '	</div>\n' +
                    '	<div style="text-align: center;margin-top: 2%">\n' +
                    '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                    '	</div>\n' +
                    '</div>\n' +
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
            }
            //计算总分
            sumScore();
        </c:if>
    });



    //添加题目
    function addNew(type,flag,p_this){
        //隐藏初始提示
        document.getElementById("initial_div").style.display = "none";

        //计算第几题
        var question_num = '';
        if(flag == 2){//题目菜单添加题目,在对应的下一题加,计算出是第几题
            question_num = p_this.parentNode.parentNode.parentNode.parentNode.id;
            question_num = Number(question_num) + Number(1);
        }else if(flag == 1){//左侧菜单添加题目,在最后加,计算出是第几题
            question_num = document.getElementsByName("question");
            question_num = Number(question_num.length+1);
        }

        var problemsType = "";
        var inputType = "";
        var op1 = "";
        var op2 = "";
        if(type == 0 || type == 1){
            if(type == 0){
                problemsType = "【单选题】";
                inputType = "radio";
            }else{
                problemsType = "【多选题】";
                inputType = "checkbox";
            }
            op1 = "选项1";
            op2 = "选项2";
        }else{
            problemsType = "【判断题】";
            inputType = "radio";
            op1 = "正确";
            op2 = "错误";
        }

        var message =
        '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
        '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
        '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
        '        <lable style="color: #000000;font-size:19px;">标题</lable>\n' +
        '        <lable style="color: #FF9966;font-size:19px;">（5分）</lable>\n' +
        '        <lable style="color: #FF9966;font-size:19px;">'+problemsType+'</lable>\n';
        if(type == 1){//多选
            message = message +
            '    <lable style="color: #FF9966;font-size:19px;">[少选得部分分]</lable>\n';
        }
        message = message +
        '    </div>\n' +
        '    <div id="showAnswer_'+question_num+'">\n' +
        '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
        '            <input name="show_input_'+question_num+'" type="'+inputType+'" onClick="javascript:return false" checked="checked"/>\n' +
        '            <lable style="font-size:18px;">'+op1+'</lable>\n' +
        '            <lable style="font-size:18px;color: #67b168;">（正确答案）</lable>\n' +
        '        </div>\n' +
        '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
        '            <input name="show_input_'+question_num+'" type="'+inputType+'" onClick="javascript:return false"/>\n' +
        '            <lable style="font-size:18px;">'+op2+'</lable>\n' +
        '        </div>\n' +
        '    </div>\n' +
        '    <div style="margin-top: 2%;margin-left: 4%;">\n' +
        '        <lable style="color: purple;font-size:19px;"></lable>\n' +
        '    </div>\n' +
        '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
        '        <div style="margin-left: 10%;;float: left;">\n' +
        '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
        '            <div style="VISIBILITY: hidden;" onmouseover="MM_showHideLayers(this,2,1);" onmouseout="MM_showHideLayers(this,2,2);">\n' +
        '                <input type="button" value="单选" onclick="addNew(0,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
        '                <input type="button" value="多选" onclick="addNew(1,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
        '                <input type="button" value="判断" onclick="addNew(2,2,this);" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:20px;"/>\n' +
        '            </div>\n' +
        '        </div>\n' +
        '        <div style="float: right;margin-right: 10%;">\n' +
        '            <input type="button" value="编辑" onclick="edit(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
        '            <input type="button" value="删除" onclick="remove(this);" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px;"/>\n' +
        '        </div>\n' +
        '    </div>\n' +
            '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
            '    <div style="margin-top: 2%;margin-left: 6%">\n' +
            '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
            '	    <input type="text" maxlength="10000" value="标题" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
            '	</div>\n' +
            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
            '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
            '	        <option value="0" selected="selected">考试单选</option>\n' +
            '	        <option value="1">考试多选</option>\n' +
            '	        <option value="2">考试判断</option>\n' +
            '	    </select>\n';
        if(type == 1){//多选
            message = message +
            '	    <select id="scoreType_'+question_num+'" style="width: 20%" onchange="selectScoreType(this);">\n' +
            '	        <option value="0" selected="selected">少选得部分分</option>\n' +
            '	        <option value="1">少选不得分</option>\n' +
            '	    </select>\n';
        }
        message = message +
            '	</div>\n' +
            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
            '	    <label class="am-fl am-form-label" style="font-size:19px;">题目分值 </label>\n' +
            '	    <input type="number" value="5" onfocus="if(value==&quot;5&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;5&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:20%" onkeyup="reacInChain(this,1);"/>\n' +
            '	    说明：分值只能是0.5的倍数\n' +
            '	</div>\n' +
            '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
            '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:67%">正确答案</label>\n' +
            '	    </div>\n' +
            '	</div>\n' +
            '	<div>\n' +
            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
            '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_1" value="选项1" onfocus="if(value==&quot;选项1&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项1&quot;}" maxlength="10000" style="width:80%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
            '	        <input type="radio" name="option_'+question_num+'" id="option_'+question_num+'_1" value="1" checked="checked" onclick="reacInChain(this,4);"/>\n' +
            '	    </div>\n' +
            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
            '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_2" value="选项2" onfocus="if(value==&quot;选项2&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项2&quot;}" maxlength="10000" style="width:80%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
            '	        <input type="radio" name="option_'+question_num+'" id="option_'+question_num+'_2" value="2" onclick="reacInChain(this,4);"/>\n' +
            '	    </div>\n' +
            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
            '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
            '	    </div>\n' +
            '	</div>\n' +
            '	<div style="margin-left: 5% ;margin-top: 2%">\n' +
            '	    <label class="am-fl am-form-label" style="font-size:19px;">答题解析 </label>\n' +
            '	    <input type="text" maxlength="10000" value=""  style="width:70%" onkeyup="reacInChain(this,5);"/>\n' +
            '	</div>\n' +
            '	<div style="text-align: center;margin-top: 2%">\n' +
            '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
            '	</div>\n' +
            '</div>\n' +
        '    <div style="clear: both;"></div>\n' +
        '    <br><br><br>\n' +
        '</div>';

        if(flag == 2){//在对应的题目后面加
            addAfter(question_num-1);//先往后移
            $("#"+Number(question_num-1)+"").after(message);//再添加
        }else if(flag == 1){//在最后加
            $("#div_content").append(message);
        }

        if (type == 1 || type == 2){//根据题目类型重置select
            var content_div = document.getElementById(question_num);
            var selectInput = content_div.children[4].children[1].children[0];//获取select
            if (type == 1){ //根据题目类型重置select-多选
                selectInput.children[1].selected=true;
            }else if (type == 2){//根据题目类型重置select-判断
                selectInput.children[2].selected=true;
            }
            selectSubjectType(selectInput);
        }
        //计算总分
        sumScore();
    };




    //后面的div往后移1(因为有radio,所以要从后面开始先移动,不然同名的radio会覆盖后面的值)
    function addAfter(p_id) {
        //后面的往前移(标题和移除的divId)
        var c_num = document.getElementsByName("question");
        for(var b = c_num.length-1;b >= p_id;b--){
            var c_div = c_num[b];
            c_div.children[0].children[0].innerText = Number(b+2);
            c_div.id = Number(b+2);
            c_div.children[1].id = "showAnswer_" + Number(b+2);
            updateShowInput(c_div.children[1],"show_input_" + Number(b+2));
            c_div.children[3].id = "btn_" + Number(b+2);

            c_div.children[4].id = "detail_" + Number(b+2);
            c_div.children[4].children[1].children[0].id = "subjectType_" + Number(b+2);
            var scoreSelect = c_div.children[4].children[1].children[1];//分数类型下拉列表
            if(scoreSelect != "" && scoreSelect != undefined){
                scoreSelect.id = "scoreType_" + Number(b+2);
            }
            var inputs = c_div.children[4].children[4].children;
            for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                inputs[j].children[0].name = "option_subject_" + Number(b+2);
                inputs[j].children[0].id = "option_subject_" + Number(b+2) + "_" + Number(j+1);
                inputs[j].children[1].name = "option_" + Number(b+2);
                inputs[j].children[1].id = "option_" + Number(b+2) + "_" + Number(j+1);
            }
        }
    };

    // function addAfter(p_id) {
    //     //后面的往前移(标题和移除的divId)
    //     var c_num = document.getElementsByName("question");
    //     for(var b = p_id;b<c_num.length;b++){
    //         var c_div = c_num[b];
    //         c_div.children[0].children[0].innerText = Number(b+2);
    //         c_div.id = Number(b+2);
    //         c_div.children[1].id = "showAnswer_" + Number(b+2);
    //         updateShowInput(c_div.children[1],"show_input_" + Number(b+2));
    //         c_div.children[3].id = "btn_" + Number(b+2);
    //
    //         c_div.children[4].id = "detail_" + Number(b+2);
    //         c_div.children[4].children[1].children[0].id = "subjectType_" + Number(b+2);
    //         var scoreSelect = c_div.children[4].children[1].children[1];//分数类型下拉列表
    //         if(scoreSelect != "" && scoreSelect != undefined){
    //             scoreSelect.id = "scoreType_" + Number(b+2);
    //         }
    //         var inputs = c_div.children[4].children[4].children;
    //         for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
    //             inputs[j].children[0].name = "option_subject_" + Number(b+2);
    //             inputs[j].children[0].id = "option_subject_" + Number(b+2) + "_" + Number(j+1);
    //             inputs[j].children[1].name = "option_" + Number(b+2);
    //             inputs[j].children[1].id = "option_" + Number(b+2) + "_" + Number(j+1);
    //         }
    //     }
    // };



    //显示按钮或者隐藏按钮(编辑框不出现才给执行)
    function btnEvent(p_this,p_event){
        var t_detail = $("#detail_"+p_this.id).css('display');
        if(t_detail == 'block'){
            return false;
        }
        var temp_btn = document.getElementById("btn_"+p_this.id);
        if(p_event == 1){ //显示
            if(temp_btn != "" && temp_btn != undefined){
                temp_btn.style = "margin-top: 2%;";
            }
        }else{//隐藏
            if(temp_btn != "" && temp_btn != undefined){
                temp_btn.style = "margin-top: 2%;display:none;";
            }
        }
    };



    //显示隐藏二级菜单
    function MM_showHideLayers(p_this,p_type,p_event) {
        var sh = '';
        if(p_event == 1) {//显示
            sh = 'visible';
        }else if(p_event == 2){//隐藏
            sh = 'hidden';
        }else{
            sh = p_event;
        }
        if(p_type == 1){
            p_this.parentNode.children[1].style.visibility = sh;
        }else{
            p_this.style.visibility = sh;
        }
    };



    //移除本题
    function remove(p_this){
        //内容体
        var div_content = document.getElementById("div_content");

        //移除的divId
        var r_id = p_this.parentNode.parentNode.parentNode.id;
        //移除div
        div_content.removeChild(document.getElementById(r_id));

        //后面的往前移(标题和移除的divId)
        var c_num = document.getElementsByName("question");
        for(var b=r_id;b<=c_num.length;b++){
            var c_div = c_num[b-1];
            c_div.children[0].children[0].innerText = b;
            c_div.id = b;
            c_div.children[1].id = "showAnswer_" + Number(b);
            updateShowInput(c_div.children[1],"show_input_" + Number(b));
            c_div.children[3].id = "btn_" + Number(b);

            c_div.children[4].id = "detail_" + Number(b);
            c_div.children[4].children[1].children[0].id = "subjectType_" + Number(b);
            var scoreSelect = c_div.children[4].children[1].children[1];//分数类型下拉列表
            if(scoreSelect != "" && scoreSelect != undefined){
                scoreSelect.id = "scoreType_" + Number(b);
            }
            var inputs = c_div.children[4].children[4].children;
            for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                inputs[j].children[0].name = "option_subject_" + Number(b);
                inputs[j].children[0].id = "option_subject_" + Number(b) + "_" + Number(j+1);
                inputs[j].children[1].name = "option_" + Number(b);
                inputs[j].children[1].id = "option_" + Number(b) + "_" + Number(j+1);
            }
        }


        if(c_num.length == 0){
            //显示初始提示
            document.getElementById("initial_div").style.display = "block";
        }

        //计算总分
        sumScore();
    };



    //单选多选的添加选项
    function addOption_subject(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;//获得总id
        var div = p_this.parentNode.parentNode;
        var length = div.children.length - 1;

        if(length >= 20){
            swal({title: '错误提示',text: "选项最多20个",type: "error",confirmButtonText: "确  定"});
            return false ;
        }
        var div_1 = document.createElement("div");
        div_1.setAttribute("style", "margin-top: 2%;margin-left: 7%;");

        var div_1_1 = document.createElement("input");
        div_1_1.setAttribute("type", "text");
        div_1_1.setAttribute("name", "option_subject_"+p_id);
        div_1_1.setAttribute("id", "option_subject_"+p_id+"_"+Number(length+1));
        div_1_1.setAttribute("value", "选项"+Number(length+1));
        div_1_1.setAttribute("onfocus", "if(value=='选项"+Number(length+1)+"'){value=''}");
        div_1_1.setAttribute("onblur", "if(value==''){value='选项"+Number(length+1)+"'}");
        div_1_1.setAttribute("maxlength", 10000);
        div_1_1.setAttribute("style", "width:80%;float:left;");
        div_1_1.setAttribute("onkeyup", "reacInChain(this,3);");
        div_1.appendChild(div_1_1);

        var inputType = '';
        var t_subjectType = $("#subjectType_"+p_id).val();
        var div_1_2 = document.createElement("input");
        if(t_subjectType == 0 || t_subjectType == 2){//单选,判断
            inputType = "radio";
        }else if(t_subjectType == 1){//多选
            inputType = "checkbox";
        }
        div_1_2.setAttribute("type", inputType);
        div_1_2.setAttribute("name", "option_"+p_id);
        div_1_2.setAttribute("id", "option_"+p_id+"_"+Number(length+1));
        div_1_2.setAttribute("value", Number(length+1));
        div_1_2.setAttribute("onclick", "reacInChain(this,4);");
        div_1.appendChild(div_1_2);

        var div_1_3 = document.createElement("a");
        div_1_3.setAttribute("href", "###");
        div_1_3.setAttribute("style", "text-decoration:none;float: right;margin-right: 10%;");
        div_1_3.setAttribute("onclick", "removeRow(this);");
        div_1_3.innerText = "   ➖";
        div_1.appendChild(div_1_3);


        //父级.第一个参数是创建的div，第二个参数是要插入到哪个div前面
        div.insertBefore(div_1,div.children[length]);

        //显示上面添加选项
        var s_message =
            '    <div style="margin-top: 1%;margin-left: 8%;">\n' +
            '        <input name="show_input_'+p_id+'" type="'+inputType+'" onClick="javascript:return false">\n' +
            '        <lable style="font-size:18px;">选项'+Number(length+1)+'</lable>\n' +
            '    </div>';
        $("#"+"showAnswer_"+p_id+"").append(s_message);
    };



    //下拉列表-题目类型
    function selectSubjectType(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.id;//总id
        var v_showAnswer = document.getElementById("showAnswer_"+p_id);//获取showAnswer
        var scoreType = document.getElementById("scoreType_"+p_id);//得分选项
        var scoreTypeShow = p_this.parentNode.parentNode.parentNode.children[0].children[4];//得分显示

        var par = p_this.parentNode.parentNode.children[4];
        var c_div = par.children;
        if(p_this.selectedIndex == 0 || p_this.selectedIndex == 1){
            c_div[c_div.length-1].style.display = "";//显示添加选项
            //标题题目类型显示
            if(p_this.selectedIndex == 0){
                p_this.parentNode.parentNode.parentNode.children[0].children[3].innerText = "【单选题】";
                updateInputType(par,'checkbox','radio');//编辑的input类型
                updateInputType(v_showAnswer,'checkbox','radio');//显示的input类型

                if(scoreType != "" && scoreType != undefined){//得分下拉选项
                    p_this.parentNode.removeChild(p_this.parentNode.children[1]);
                }
                if(scoreTypeShow != "" && scoreTypeShow != undefined) {//得分类型显示
                    p_this.parentNode.parentNode.parentNode.children[0].removeChild(p_this.parentNode.parentNode.parentNode.children[0].children[4]);
                }
            }else{
                p_this.parentNode.parentNode.parentNode.children[0].children[3].innerText = "【多选题】";
                updateInputType(par,'radio','checkbox');//编辑的input类型
                updateInputType(v_showAnswer,'radio','checkbox');//显示的input类型

                if(scoreType == "" || scoreType == undefined){//得分下拉选项
                    var newSelect = document.createElement("select");
                    newSelect.setAttribute("id","scoreType_"+p_id);
                    newSelect.setAttribute("style","width: 20%;");
                    newSelect.setAttribute("onchange","selectScoreType(this);");
                    var newOption1 = document.createElement("option");
                    newOption1.setAttribute("value","0");
                    newOption1.setAttribute("selected","selected");
                    newOption1.innerText = "少选得部分分";
                    var newOption2 = document.createElement("option");
                    newOption2.setAttribute("value","1");
                    newOption2.innerText = "少选不得分";
                    newSelect.appendChild(newOption1);
                    newSelect.appendChild(newOption2);
                    p_this.parentNode.insertBefore(newSelect, p_this.nextElementSibling);
                }
                if(scoreTypeShow == "" || scoreTypeShow == undefined) {//得分类型显示
                    var newLable = document.createElement("lable");
                    newLable.setAttribute("style","color: #FF9966;font-size:19px;");
                    newLable.innerText = "[少选得部分分]";
                    p_this.parentNode.parentNode.parentNode.children[0].appendChild(newLable);
                }
            }
            //1.变更input类型后,显示列还有正确答案存在,故删除   2.变更类型后需要转换显示的内容,比如单多是选项1,判断是正确错误
            updateTrueAnswer(p_id,1);
            //如果由判断转单多选,选项1和2的内容要变更
            var t_option = document.getElementsByName("option_subject_"+p_id);
            for(var d=0;d<t_option.length;d++){
                if(d == 0){
                    t_option[d].value = "选项1";
                }else if(d == 1){
                    t_option[d].value = "选项2";
                }
            }
        }else if(p_this.selectedIndex == 2){
            c_div[c_div.length-1].style.display = "none";//隐藏添加选项
            //标题题目类型显示
            p_this.parentNode.parentNode.parentNode.children[0].children[3].innerText = "【判断题】";
            //删除选项显示
            var t_input = document.getElementsByName("show_input_"+p_id);
            for(var p=0;p<t_input.length;p++){
                if(p > 1){//超过两个了
                    t_input[p].parentNode.parentNode.removeChild(t_input[p].parentNode);
                    p--;//移除子元素后d也要接着-1
                }
            }
            //删除选项编辑
            var t_option = document.getElementsByName("option_subject_"+p_id);
            for(var d=0;d<t_option.length;d++){
                if(d == 0){
                    t_option[d].value = "正确";
                }else if(d == 1){
                    t_option[d].value = "错误";
                }else if(d > 1){//超过两个就删掉
                    t_option[d].parentNode.parentNode.removeChild(t_option[d].parentNode);
                    d--;//移除子元素后d也要接着-1
                }
            }
            updateInputType(par,'checkbox','radio');//编辑的input类型
            updateInputType(v_showAnswer,'checkbox','radio');//显示的input类型
            //1.变更input类型后,显示列还有正确答案存在,故删除   2.变更类型后需要转换显示的内容,比如单多是选项1,判断是正确错误
            updateTrueAnswer(p_id,2);

            if(scoreType != "" && scoreType != undefined){//得分下拉选项
                p_this.parentNode.removeChild(p_this.parentNode.children[1]);
            }
            if(scoreTypeShow != "" && scoreTypeShow != undefined) {//得分类型显示
                p_this.parentNode.parentNode.parentNode.children[0].removeChild(p_this.parentNode.parentNode.parentNode.children[0].children[4]);
            }
        }
    };



    //下拉列表-得分类型
    function selectScoreType(p_this){
        if(p_this.selectedIndex == 0){
            p_this.parentNode.parentNode.parentNode.children[0].children[4].innerText = "[少选得部分分]";
        }else if(p_this.selectedIndex == 1){
            p_this.parentNode.parentNode.parentNode.children[0].children[4].innerText = "[少选不得分]";
        }
    };


    // 遍历指定元素下所有的子元素,1该元素下的所有子级,2要修改的type,3改成的ytpe
    function updateInputType(parent,p1,p2) {
        for (var i = 0; i < parent.children.length; i++) {
            // 遍历第一级子元素
            var child = parent.children[i];
            if (child.type == p1) {
                // 处理找到的子元素
                child.type = p2;
            }
            // 递归调用
            updateInputType(child,p1,p2);
        }
    };


    // 遍历指定元素下所有的子元素,1该元素下的所有子级,2修改成的name
    function updateShowInput(parent,p2) {
        for (var i = 0; i < parent.children.length; i++) {
            // 遍历第一级子元素
            var child = parent.children[i];
            if (child.type == 'radio' || child.type == 'checkbox') {
                // 处理找到的子元素
                child.name = p2;
            }
            // 递归调用
            updateShowInput(child,p2);
        }
    };


    //输入或点击联动
    function reacInChain(p_this,p_type){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;//获得总id
        if(p_type == 1){//分数显示
            p_this.parentNode.parentNode.parentNode.children[0].children[2].innerHTML = "（" + p_this.value + "分）";
            //计算总分
            sumScore();
        }else if(p_type == 2){//标题显示
            p_this.parentNode.parentNode.parentNode.children[0].children[1].innerHTML = p_this.value ;
        }else if(p_type == 3){//选项显示
            var t_id = p_this.id;
            t_id = t_id.substring(t_id.lastIndexOf('_')+1,t_id.length);//得出是第几个
            document.getElementById("showAnswer_"+p_id).children[t_id-1].children[1].innerHTML = p_this.value;
        }else if(p_type == 4){//正確答案显示以及选中
            var t_id = p_this.id;
            t_id = t_id.substring(t_id.lastIndexOf('_')+1,t_id.length);//得出是第几个

            var t_showAnswer = document.getElementById("showAnswer_"+p_id);
            if(p_this.type == 'checkbox'){//判断当前的是checkbox还是radio
                if(p_this.checked){
                    if(t_showAnswer.children[t_id-1].children.length < 3){
                        //添加新的
                        var label1 = document.createElement("lable");
                        label1.setAttribute("style", "font-size:18px;color: #67b168;");
                        label1.innerText = "（正确答案）";
                        t_showAnswer.children[t_id-1].appendChild(label1);//创建
                        t_showAnswer.children[t_id-1].children[0].checked = true;//选中
                    }
                }else{
                    //添加新的
                    t_showAnswer.children[t_id-1].removeChild(t_showAnswer.children[t_id-1].children[2]);
                    t_showAnswer.children[t_id-1].children[0].checked = false;
                }
            }else if(p_this.type == 'radio'){
                if(t_showAnswer.children[t_id-1].children.length < 3){
                    //先移除旧的
                    for(var t=0;t<t_showAnswer.children.length;t++){
                        var c_length = t_showAnswer.children[t].children;
                        if(c_length.length > 2){//代表有正确答案显示
                            t_showAnswer.children[t].removeChild(c_length[2]);
                        }
                    }
                    //添加新的
                    var label1 = document.createElement("lable");
                    label1.setAttribute("style", "font-size:18px;color: #67b168;");
                    label1.innerText = "（正确答案）";
                    t_showAnswer.children[t_id-1].appendChild(label1);
                    t_showAnswer.children[t_id-1].children[0].checked = true;
                }
            }
        }else if(p_type == 5){//答题解析显示
            if(p_this.value != ""){
                // p_this.parentNode.parentNode.parentNode.children[2].innerHTML = "答题解析 : "+p_this.value;
                p_this.parentNode.parentNode.parentNode.children[2].children[0].innerHTML = "答题解析 : "+p_this.value;
            }else {
                p_this.parentNode.parentNode.parentNode.children[2].children[0].innerHTML = "";
            }
        }
    };



    //1.变更input类型后,显示列还有正确答案存在,故删除   2.变更类型后需要转换显示的内容,比如单多是选项1,判断是正确错误
    function updateTrueAnswer(p_id,p_type){
        var t_input = document.getElementsByName("show_input_"+p_id);
        for(var v=0;v<t_input.length;v++){
            if(v == 0){
                t_input[v].parentNode.children[1].innerText = p_type==1?"选项1":"正确";
            }else if(v == 1){
                t_input[v].parentNode.children[1].innerText = p_type==1?"选项2":"错误";
            }
            if(!t_input[v].checked && t_input[v].parentNode.children[2] != undefined){
                t_input[v].parentNode.removeChild(t_input[v].parentNode.children[2]);
            }
        }
    };



    //编辑
    function edit(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.id;//总id
        var t_btn = document.getElementById("btn_"+p_id);
        var details = document.getElementsByName("detail_div");//获取所有的detail_div
        var now_deatil = t_btn.nextElementSibling;//获取当前的下一节点(忽略空格注释等)
        for(var t=0;t<details.length;t++){
            if(details[t].id == now_deatil.id){//判断是不是当前的编辑框,不是的话就隐藏,是的话就打开
                now_deatil.style.display = "block";
                t_btn.style.display = "none";
            }else{
                details[t].style.display = "none";
            }
        }
    };


    //完成编辑
    function overEdit(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.id;
        var t_detail = document.getElementById("detail_"+p_id);
        t_detail.style.display = "none";
        var t_btn = document.getElementById("btn_"+p_id);
        t_btn.style.display = "block";
    };



    //删除当前选项行
    function removeRow(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;
        var child = p_this.parentNode;
        var remove_index = 0;
        while(true){
            if(child.previousElementSibling != null){
                child = child.previousElementSibling; //previousElementSibling：获取上一个兄弟元素节点；（只包含元素节点）
                remove_index++;
            }else{
                break;
            }
        }
        remove_index = remove_index + 1;//+1是因为得出的下标是从0开始的

        //把后面的id都往前移一位
        for(var u=remove_index;u<p_this.parentNode.parentNode.children.length-1;u++){//此处length-1是为了不修改添加选项这个标签
            var row = p_this.parentNode.parentNode.children[u];
            row.children[0].id = "option_subject_"+p_id+"_"+Number(u);
            row.children[1].id = "option_"+p_id+"_"+Number(u);
            row.children[1].value = Number(u);
        }

        //删除编辑行
        p_this.parentNode.parentNode.removeChild(p_this.parentNode.parentNode.children[remove_index-1]);
        //删除显示行
        document.getElementById("showAnswer_"+p_id).removeChild(document.getElementById("showAnswer_"+p_id).children[remove_index-1]);
    };


    //计算试卷总分
    function sumScore(){
        //获取所有的题目
        var p_details = document.getElementsByName("detail_div");
        var sumNum = 0;
        for(var t=0;t<p_details.length;t++){
            p_details[t].children[2].children[1].value;
            sumNum = Number(sumNum) + Number(p_details[t].children[2].children[1].value);
        }
        document.getElementById("sum_score").innerText = sumNum;
        document.getElementById("totalScore").value = sumNum;
    };



    //批量更新分数
    function updateALLScore(){
        var singleChoice = document.getElementById("singleChoice").value.trim();;//单选分数
        var multipleChoice = document.getElementById("multipleChoice").value.trim();;//多选分数
        var judgment = document.getElementById("judgment").value.trim();;//判断分数
        if((singleChoice==""||singleChoice==null) && (multipleChoice==""||multipleChoice==null) && (judgment==""||judgment==null)){
            document.getElementById("singleChoice").focus();
            swal({title: '错误提示',text: "最少填写一项分数值",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        if(singleChoice!="" && singleChoice!=null && singleChoice < 0){
            document.getElementById("singleChoice").focus();
            swal({title: '错误提示',text: "单选分数不能为负数",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        if(multipleChoice!="" && multipleChoice!=null && multipleChoice < 0){
            document.getElementById("multipleChoice").focus();
            swal({title: '错误提示',text: "多选分数不能为负数",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        if(judgment!="" && judgment!=null && judgment < 0){
            document.getElementById("judgment").focus();
            swal({title: '错误提示',text: "判断分数不能为负数",type: "error",confirmButtonText: "确  定"});
            return false;
        }

        //更新题目分数
        //获取所有的题目
        var p_questions = document.getElementsByName("question");
        if(p_questions.length == 0){
            swal({title: '错误提示',text: "请先添加试题再修改分数",type: "error",confirmButtonText: "确  定"});
            return false;
        }
        //循环考题
        for(var g=0;g<p_questions.length;g++){
            //获取考题类型
            var dataSelect = document.getElementById("subjectType_"+p_questions[g].id);
            var vs = dataSelect.options[dataSelect.selectedIndex].value;
            if(vs == 0 && singleChoice!="" && singleChoice!=null){//单选并且单选分数框不为空
                p_questions[g].children[4].children[2].children[1].value = singleChoice;
                p_questions[g].children[0].children[2].innerText = "（" + singleChoice + "分）";
            }else if(vs == 1 && multipleChoice!="" && multipleChoice!=null) {//多选并且多选分数框不为空
                p_questions[g].children[4].children[2].children[1].value = multipleChoice;
                p_questions[g].children[0].children[2].innerText = "（" + multipleChoice + "分）";
            }else if(vs == 2 && judgment!="" && judgment!=null) {//判断并且判断分数框不为空
                p_questions[g].children[4].children[2].children[1].value = judgment;
                p_questions[g].children[0].children[2].innerText = "（" + judgment + "分）";
            }
        }

        //计算试卷总分
        sumScore();

        // 1秒定时关闭弹窗
        swal({title: "提示",text: "批量修改成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
    };




    //校验以及保存
    function checkAndSave(){
        //试题json数据
        var jsonData = [];

        //获取所有的题目
        var p_questions = document.getElementsByName("question");
        if(p_questions.length == 0){
            swal({title: '错误提示',text: "该试卷没有题目,请添加题目",type: "error",confirmButtonText: "确  定"});
            return false;
        }

        //循环考题
        for(var g=0;g<p_questions.length;g++){
            // 每题数据(标题 试题类型 得分类型(多选) 分数 正确答案 选项)
            var row = {};

            //获取输入框总div
            var detail_div = document.getElementById("detail_"+p_questions[g].id);

            //校验标题
            var title = detail_div.children[0].children[1].value.trim();
            if(title==""||title==null){
                detail_div.children[0].children[1].focus();
                swal({title: '错误提示',text: "标题不能为空",type: "error",confirmButtonText: "确  定"});
                return false;
            }
            row.title = title;

            //校验分数
            var score = detail_div.children[2].children[1].value.trim();
            if(score==""||score==null){
                detail_div.children[2].children[1].focus();
                swal({title: '错误提示',text: "分数不能为空",type: "error",confirmButtonText: "确  定"});
                return false;
            }else if(score < 0){
                edit(document.getElementById("btn_"+p_questions[g].id).children[1].children[0]);//打开编辑框
                window.location.hash = "###";//初始化锚链接,不写这个的话,有时候跳转会失败
                window.location.hash = "#"+p_questions[g].id+"";//跳转到没选中的div锚链接
                detail_div.children[2].children[1].focus();
                swal({title: '错误提示',text: "分数不能为负数",type: "error",confirmButtonText: "确  定"});
                return false;
            }
            row.score = score;

            //校验选项填写
            var option_subjects = document.getElementsByName("option_subject_"+p_questions[g].id);
            var r_op = [];
            for(var k=0;k<option_subjects.length;k++){
                var op = option_subjects[k].value.trim();
                if(op==""||op==null){
                    option_subjects[k].focus();
                    swal({title: '错误提示',text: "输入框"+(K+1)+"不能为空",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
                r_op.push(op);
            }
            row.op = r_op;


            //获取考题类型
            var dataSelect = document.getElementById("subjectType_"+p_questions[g].id);
            var vs = dataSelect.options[dataSelect.selectedIndex].value;
            row.subjectType = dataSelect.selectedIndex;

            //校验正确答案是否已经选择
            var option_check = $('input:radio[name="option_'+p_questions[g].id+'"]:checked').val();
            if(vs == 1){//多选
                option_check = $('input:checkbox[name="option_'+p_questions[g].id+'"]:checked').val();
                //获取得分类型
                var scoreSelect = document.getElementById("scoreType_"+p_questions[g].id);
                row.scoreType = scoreSelect.selectedIndex;
            }
            if(option_check == null){//没选中
                edit(document.getElementById("btn_"+p_questions[g].id).children[1].children[0]);//打开编辑框
                window.location.hash = "###";//初始化锚链接,不写这个的话,有时候跳转会失败
                window.location.hash = "#"+p_questions[g].id+"";//跳转到没选中的div锚链接
                swal({title: '错误提示',text: "第"+p_questions[g].id+"题请选择正确答案",type: "error",confirmButtonText: "确  定"});
                return false;
            }

            //保存正确答案
            var trues = [];
            if(vs == 1){//多选
                var arr = document.getElementsByName("option_"+p_questions[g].id);
                for(i=0;i<arr.length;i++){
                    if(arr[i].checked){
                        trues.push(arr[i].value);
                    }
                }
            }else if(vs == 0 || vs == 2){//单选,判断
                var t_num = $('input:radio[name="option_'+p_questions[g].id+'"]:checked').val();
                trues.push(t_num);
            }
            row.trueAnswer = trues;

            //校验标题
            var answerAnalysis = detail_div.children[5].children[1].value.trim();
            row.answerAnalysis = answerAnalysis;

            //添加到json
            jsonData.push(row);
        }

        var param = JSON.stringify(jsonData);//json转string
        var t_id = document.getElementById("id").value;
        var totalScore =  document.getElementById("totalScore").value ;
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/saveTestPaper.do?examinationId=${examinationId}&id="+t_id+"&totalScore="+totalScore,
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
                    swal({title: "错误提示",text: "保存失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "保存异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
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