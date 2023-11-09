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
        <title>问卷编辑</title>
    </head>
    <body>
        <div>
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-问卷编辑</label>
            </div>
            <div >
                <div style="width:24.6%;height:700px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 20%">
                        <label class="am-fl am-form-label" style="font-size:25px;">文件类型：</label>
                    </div>
                    <div style="margin-top: 8%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(0,1,this);">
                        <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">问卷单选</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(1,1,this);">
                            <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">问卷多选</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(2,1,this);">
                            <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">问卷矩阵量表</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <a href="###" style="text-decoration:none;" onclick="addNew(3,1,this);">
                            <label class="am-fl am-form-label" style="font-size:20px;color: #1E1E1E">问卷简答</label>
                            <label class="am-fl am-form-label" style="font-size:24px;color: #00458a">➬</label>
                        </a>
                    </div>
                    <div style="text-align: center;margin-top: 40%;">
                        <br></br><br></br>
                        <input type="button" onclick="checkAndSave();" value="保  存  问  卷" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                        <br></br>
                        <input type="button" onclick="window.close();" value="关         闭" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>

                <div style="width:75%;height:700px;float: left;border:1px solid #808080;">
                    <div style="margin-top: 2%;margin-left: 35%;margin-right: 30%;">
                        <label class="am-fl am-form-label" style="font-size:20px;">${title}-培训课问卷调查</label>
                    </div>
                    <div style="height:89.5%; margin-top: 3%;margin-left: 0.5%;border:1px solid #808080;overflow:auto;" id="div_content">
                        <div id="initial_div" style="text-align:center;margin-top: 30%;font-size: 25px;color: #e68900">请根据左边区域的问卷类型添加题目</div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="id" name="id" value="${questionnaire.id}"/>
    </body>
</html>


<script type="text/javascript">

    var loadWidth = 0;
    var loadHeight = 0;

    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;


        <c:if test="${questionnaire != null}">
            jsonData = ${questionnaire.content} ;
            for(var n=0;n<jsonData.length;n++){
                var rows = jsonData[n];

                //隐藏初始提示
                document.getElementById("initial_div").style.display = "none";

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
                        '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                        '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                        '        <lable style="color: #f06e57;font-size:19px;">'+temp_requiredFields+'</lable>\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">【单选题】</lable>\n'+
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
                        '            <lable style="font-size:18px;">'+rows.op[u]+'</lable>\n' +
                        '            <lable style="font-size:18px;">'+mustAnswer1+'</lable>\n' +
                        '            <lable style="font-size:18px;color: #f06e57;">'+mustAnswer2+'</lable>\n' +
                        '        </div>\n' ;
                    }
                    message = message +
                        '    </div>\n' +
                        '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                        '        <div style="margin-left: 10%;;float: left;">\n' +
                        '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                            '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                            '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                            '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                            '	    <input type="text" maxlength="10000" value="'+rows.title+'" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                            '	</div>\n' +
                            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                            '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                            '	        <option value="0" selected="selected">问卷单选</option>\n' +
                            '	        <option value="1">问卷多选</option>\n' +
                            '	        <option value="2">问卷矩阵量表</option>\n' +
                            '	        <option value="3">问卷简答</option>\n' +
                            '	    </select>\n' +
                            '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" '+t_requiredFields+' style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                            '	</div>\n' +
                            '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                            '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:44%">必答</label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:22%">分数</label>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div>\n' ;
                    for(var u=0;u<rows.op.length;u++){
                        //是否必答
                        var t_mustAnswer = "";
                        if(rows.mustAnswer[u] == 1){
                            t_mustAnswer = "checked=\"checked\"";
                        }
                        message = message +
                            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                            '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_'+Number(u+1)+'" value="'+rows.op[u]+'" onfocus="if(value==&quot;选项'+Number(u+1)+'&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项'+Number(u+1)+'&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                            '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_'+Number(u+1)+'" value="'+Number(u+1)+'" '+t_mustAnswer+' style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                            '	        <input type="number" value="'+rows.score[u]+'" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' ;
                        if(u > 1){
                            message = message +
                                       '<a href="###" style="text-decoration:none;float: right;margin-right: 3%;" onclick="removeRow(this);">   ➖</a>\n' ;
                        }
                        message = message +
                        '	    </div>\n' ;
                    }
                    message = message +
                            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                            '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div style="text-align: center;margin-top: 2%">\n' +
                            '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                            '	</div>\n' +
                            '</div>\n' +
                        '    <div style="clear: both;"></div>\n' +
                        '    <br><br><br>\n' +
                        '</div>';
                }else if(rows.subjectType == 1) { //多选
                    var message =
                        '<div style="border:1px solid #808080;" id="' + question_num + '" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                        '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                        '        <lable style="color: #f06e57;font-size:19px;">' + temp_requiredFields + '</lable>\n' +
                        '        <lable style="color: #000000;font-size:19px;">' + question_num + '</lable>.\n' +
                        '        <lable style="color: #000000;font-size:19px;">' + rows.title + '</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">【多选题】</lable>\n' +
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
                            '            <lable style="font-size:18px;">' + rows.op[u] + '</lable>\n' +
                            '            <lable style="font-size:18px;">' + mustAnswer1 + '</lable>\n' +
                            '            <lable style="font-size:18px;color: #f06e57;">' + mustAnswer2 + '</lable>\n' +
                            '        </div>\n';
                    }
                    message = message +
                        '    </div>\n' +
                        '    <div style="margin-top: 2%; display: none;" id="btn_' + question_num + '">\n' +
                        '        <div style="margin-left: 10%;;float: left;">\n' +
                        '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                            '<div id="detail_' + question_num + '" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                            '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                            '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                            '	    <input type="text" maxlength="10000" value="' + rows.title + '" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                            '	</div>\n' +
                            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                            '	    <select id="subjectType_' + question_num + '" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                            '	        <option value="0">问卷单选</option>\n' +
                            '	        <option value="1" selected="selected">问卷多选</option>\n' +
                            '	        <option value="2">问卷矩阵量表</option>\n' +
                            '	        <option value="3">问卷简答</option>\n' +
                            '	    </select>\n' +
                            '	    <input type="checkbox" id="title_option_' + question_num + '" value="0" '+t_requiredFields+' style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                            '	</div>\n' +
                            '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                            '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:44%">必答</label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:22%">分数</label>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div>\n';
                        for (var u = 0; u < rows.op.length; u++) {
                            //是否必答
                            var t_mustAnswer = "";
                            if (rows.mustAnswer[u] == 1) {
                                t_mustAnswer = "checked=\"checked\"";
                            }
                            message = message +
                                '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                                '	        <input type="text" name="option_subject_' + question_num + '" id="option_subject_' + question_num + '_' + Number(u + 1) + '" value="' + rows.op[u] + '" onfocus="if(value==&quot;选项'+Number(u+1)+'&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项'+Number(u+1)+'&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                                '	        <input type="checkbox" name="option_' + question_num + '" id="option_' + question_num + '_' + Number(u + 1) + '" value="' + Number(u + 1) + '" ' + t_mustAnswer + ' style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                                '	        <input type="number" value="' + rows.score[u] + '" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' ;
                            if(u > 1){
                                message = message +
                                           '<a href="###" style="text-decoration:none;float: right;margin-right: 3%;" onclick="removeRow(this);">   ➖</a>\n' ;
                            }
                            message = message +
                                '	    </div>\n';
                        }
                        message = message +
                            '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                            '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div style="text-align: center;margin-top: 2%">\n' +
                            '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                            '	</div>\n' +
                            '</div>\n' +
                        '    <div style="clear: both;"></div>\n' +
                        '    <br><br><br>\n' +
                        '</div>';

                }else if(rows.subjectType == 2){ //矩阵量表题
                    var op_title = "";
                    var op_titleLength = 4 + ((rows.op.length-2) *3);
                    for(var u=0;u<rows.opt.length;u++){
                        op_title = op_title + rows.opt[u] ;
                        if(u < (rows.opt.length-1)){
                            op_title = op_title + '\n' ;
                        }
                    }

                    var message =
                        '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                        '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                        '        <lable style="color: #f06e57;font-size:19px;">'+temp_requiredFields+'</lable>\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">【矩阵量表题】</lable>\n'+
                        '    </div>\n' +
                        '    <div id="showAnswer_'+question_num+'">\n' +
                        '        <div style="margin-top: 1%;margin-left: 5%;">\n' +
                        '            <table width="700" height="50" border="0" id="table_'+question_num+'">\n' +
                            '            <tr>\n' +
                                '            <td></td>\n' ;

                    for(var h=0;h<rows.op.length;h++){
                        //是否必答
                        var mustAnswer = "";
                        if (rows.mustAnswer[h] == 1) {
                            mustAnswer = "*";
                        }
                        message = message +
                                 '           <td style="text-align:center;vertical-align:middle;"><label style="color: red">'+mustAnswer+'</label><label>'+rows.op[h]+'</label></td>\n' ;
                    }
                    message = message +
                            '            </tr>\n' ;

                    for(var u=0;u<rows.opt.length;u++){
                        message = message +
                            '            <tr>\n' +
                                '            <td>'+rows.opt[u]+'</td>\n' ;
                        for(var h=0;h<rows.op.length;h++){
                            message = message +
                                '            <td style="text-align:center;vertical-align:middle;"><input type="radio" onclick="javascript:return false" style="margin-left: 8%;"></td>\n' ;
                        }
                        message = message +
                            '            </tr>\n' ;
                    }
                    message = message +
                        '            </table>\n' +
                        '        </div>\n' +
                        '    </div>\n' +
                        '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                        '        <div style="margin-left: 10%;;float: left;">\n' +
                        '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                            '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                            '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                            '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                            '	    <input type="text" maxlength="10000" value="'+rows.title+'" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                            '	</div>\n' +
                            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                            '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                            '	        <option value="0">问卷单选</option>\n' +
                            '	        <option value="1">问卷多选</option>\n' +
                            '	        <option value="2" selected="selected">问卷矩阵量表</option>\n' +
                            '	        <option value="3">问卷简答</option>\n' +
                            '	    </select>\n' +
                            '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" '+t_requiredFields+' style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                            '	</div>\n' +
                            '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                            '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">行标题 </label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:20%">选项文字</label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:33%">必答</label>\n' +
                            '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:6%">分数</label>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div>\n' +
                            '	    <div style="margin-left: 7%;float:left;width: 27%;">\n' +
                            '	        <textarea rows="'+op_titleLength+'" cols="30" maxlength="3000" id="group_'+question_num+'" onkeyup="showRowTitle(this);" wrap="off" style="overflow:scroll;width: 202px;">' +
                                            op_title +
                            '           </textarea>\n' +
                            '	    </div>\n' ;
                    for (var u = 0; u < rows.op.length; u++) {
                        //是否必答
                        var t_mustAnswer = "";
                        if (rows.mustAnswer[u] == 1) {
                            t_mustAnswer = "checked=\"checked\"";
                        }
                        message = message +
                            '	    <div style="margin-top: 2%;">\n' +
                            '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_'+ Number(u + 1) +'" value="'+ rows.op[u] +'" onfocus="if(value==&quot;选项'+ Number(u + 1) +'&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项'+ Number(u + 1) +'&quot;}" maxlength="10000" style="width:38%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                            '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_'+ Number(u + 1) +'" value="'+ Number(u + 1) +'" '+t_mustAnswer+' style="margin-left: 3%" onclick="reacInChain(this,4);">\n' +
                            '	        <input type="number" value="'+rows.score[u]+'" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 2%">\n' ;
                        if(u > 1){
                            message = message +
                                       '<a href="###" style="text-decoration:none;float: right;margin-right: 3%;" onclick="removeRow(this);">   ➖</a>\n' ;
                        }
                        message = message +
                            '	    </div>\n' ;
                    }
                    message = message +
                            '	    <div style="margin-top: 2%;margin-left: 34%">\n' +
                            '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                            '	    </div>\n' +
                            '	</div>\n' +
                            '	<div style="text-align: center;margin-top: 2%">\n' +
                            '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                            '	</div>\n' +
                            '</div>\n' +
                        '    <div style="clear: both;"></div>\n' +
                        '    <br><br><br>\n' +
                        '</div>';
                }else if(rows.subjectType == 3) { //简答题
                    var message =
                        '<div style="border:1px solid #808080;" id="' + question_num + '" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                        '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                        '        <lable style="color: #f06e57;font-size:19px;">'+temp_requiredFields+'</lable>\n' +
                        '        <lable style="color: #000000;font-size:19px;">' + question_num + '</lable>.\n' +
                        '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                        '        <lable style="color: #FF9966;font-size:19px;">【简答题】</lable>\n' +
                        '    </div>\n' +
                        '    <div id="showAnswer_' + question_num + '">\n' +
                        '        <textarea rows="6" cols="120" maxlength="3000" id="group" style="margin-left: 4%;margin-top: 2%;width: 742px;" readonly></textarea>\n' +
                        '    </div>\n' +
                        '    <div style="margin-top: 2%; display: none;" id="btn_' + question_num + '">\n' +
                        '        <div style="margin-left: 10%;;float: left;">\n' +
                        '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                            '<div id="detail_' + question_num + '" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                            '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                            '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                            '	    <input type="text" maxlength="10000" value="'+rows.title+'" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                            '	</div>\n' +
                            '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                            '	    <select id="subjectType_' + question_num + '" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                            '	        <option value="0">问卷单选</option>\n' +
                            '	        <option value="1">问卷多选</option>\n' +
                            '	        <option value="2">问卷矩阵量表</option>\n' +
                            '	        <option value="3"  selected="selected">问卷简答</option>\n' +
                            '	    </select>\n' +
                            '	    <input type="checkbox" id="title_option_' + question_num + '" value="0" '+t_requiredFields+' style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                            '	</div>\n' +
                            '	<div style="margin-top: 2%;margin-left: 7%;margin-bottom: 7%;">\n' +
                            '	    <label class="am-fl am-form-label" style="font-size:17px;">限制范围 </label>\n' +
                            '	    <input type="number" id="limitNumber_' + question_num + '" value="'+rows.wordRestriction+'" onfocus="if(value==&quot;100&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;100&quot;}" style="width:7%"/>个字\n' +
                            '	</div>\n' +
                            '	<div style="text-align: center;margin-top: 2%">\n' +
                            '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                            '	</div>\n' +
                            '</div>\n' +
                        '    <div style="clear: both;"></div>\n' +
                        '    <br><br><br>\n' +
                        '</div>';
                }
                //在最后加
                $("#div_content").append(message);
            }
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
        }else if(flag == 3){//下拉选择,直接替换原来的
            question_num = p_this.parentNode.parentNode.parentNode.id;;
        }
        if(type == 0){//单选
            var message =
                '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                '        <lable style="color: #f06e57;font-size:19px;">*</lable>\n' +
                '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                '        <lable style="color: #000000;font-size:19px;">标题</lable>\n' +
                '        <lable style="color: #FF9966;font-size:19px;">【单选题】</lable>\n'+
                '    </div>\n' +
                '    <div id="showAnswer_'+question_num+'">\n' +
                '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                '            <input type="radio" onClick="javascript:return false"/>\n' +
                '            <lable style="font-size:18px;">选项1</lable>\n' +
                '            <lable style="font-size:18px;">__________________</lable>\n' +
                '            <lable style="font-size:18px;color: #f06e57;">*</lable>\n' +
                '        </div>\n' +
                '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                '            <input type="radio" onClick="javascript:return false"/>\n' +
                '            <lable style="font-size:18px;">选项2</lable>\n' +
                '            <lable style="font-size:18px;"></lable>\n' +
                '            <lable style="font-size:18px;color: #f06e57;"></lable>\n' +
                '        </div>\n' +
                '    </div>\n' +
                '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                '        <div style="margin-left: 10%;;float: left;">\n' +
                '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                    '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                    '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="标题" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                    '	        <option value="0" selected="selected">问卷单选</option>\n' +
                    '	        <option value="1">问卷多选</option>\n' +
                    '	        <option value="2">问卷矩阵量表</option>\n' +
                    '	        <option value="3">问卷简答</option>\n' +
                    '	    </select>\n' +
                    '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" checked="checked" style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                    '	</div>\n' +
                    '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                    '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:44%">必答</label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:22%">分数</label>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_1" value="选项1" onfocus="if(value==&quot;选项1&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项1&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_1" value="1" checked="checked" style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_2" value="选项2" onfocus="if(value==&quot;选项2&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项2&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_2" value="2" style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div style="text-align: center;margin-top: 2%">\n' +
                    '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                    '	</div>\n' +
                    '</div>\n' +
                '    <div style="clear: both;"></div>\n' +
                '    <br><br><br>\n' +
                '</div>';
        }else if(type == 1){ //多选
            var message =
                '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                '        <lable style="color: #f06e57;font-size:19px;">*</lable>\n' +
                '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                '        <lable style="color: #000000;font-size:19px;">标题</lable>\n' +
                '        <lable style="color: #FF9966;font-size:19px;">【多选题】</lable>\n'+
                '    </div>\n' +
                '    <div id="showAnswer_'+question_num+'">\n' +
                '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                '            <input type="checkbox" onClick="javascript:return false"/>\n' +
                '            <lable style="font-size:18px;">选项1</lable>\n' +
                '            <lable style="font-size:18px;">__________________</lable>\n' +
                '            <lable style="font-size:18px;color: #f06e57;">*</lable>\n' +
                '        </div>\n' +
                '        <div style="margin-top: 1%;margin-left: 8%;">\n' +
                '            <input type="checkbox" onClick="javascript:return false"/>\n' +
                '            <lable style="font-size:18px;">选项2</lable>\n' +
                '            <lable style="font-size:18px;"></lable>\n' +
                '            <lable style="font-size:18px;color: #f06e57;"></lable>\n' +
                '        </div>\n' +
                '    </div>\n' +
                '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                '        <div style="margin-left: 10%;;float: left;">\n' +
                '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                    '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                    '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="标题" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                    '	        <option value="0">问卷单选</option>\n' +
                    '	        <option value="1" selected="selected">问卷多选</option>\n' +
                    '	        <option value="2">问卷矩阵量表</option>\n' +
                    '	        <option value="3">问卷简答</option>\n' +
                    '	    </select>\n' +
                    '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" checked="checked" style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                    '	</div>\n' +
                    '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                    '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">选项文字 </label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:44%">必答</label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:22%">分数</label>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_1" value="选项1" onfocus="if(value==&quot;选项1&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项1&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_1" value="1" checked="checked" style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_2" value="选项2" onfocus="if(value==&quot;选项2&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项2&quot;}" maxlength="10000" style="width:40%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_2" value="2" style="margin-left: 16%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 19%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 7%">\n' +
                    '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div style="text-align: center;margin-top: 2%">\n' +
                    '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                    '	</div>\n' +
                    '</div>\n' +
                '    <div style="clear: both;"></div>\n' +
                '    <br><br><br>\n' +
                '</div>';
        }else if(type == 2){ //矩阵量表题
            var message =
                '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                '        <lable style="color: #f06e57;font-size:19px;">*</lable>\n' +
                '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                '        <lable style="color: #000000;font-size:19px;">标题</lable>\n' +
                '        <lable style="color: #FF9966;font-size:19px;">【矩阵量表题】</lable>\n'+
                '    </div>\n' +
                '    <div id="showAnswer_'+question_num+'">\n' +
                '        <div style="margin-top: 1%;margin-left: 5%;">\n' +
                '            <table width="700" height="50" border="0" id="table_'+question_num+'">\n' +
                '            <tr>\n' +
                '            <td></td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><label style="color: red">*</label><label>选项1</label></td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><label style="color: red"></label><label>选项2</label></td>\n' +
                '            </tr>\n' +
                '            <tr>\n' +
                '            <td>行标题1</td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><input type="radio" onclick="javascript:return false" style="margin-left: 8%;"></td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><input type="radio" onclick="javascript:return false" style="margin-left: 8%;"></td>\n' +
                '            </tr>\n' +
                '            <tr>\n' +
                '            <td>行标题2</td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><input type="radio" onclick="javascript:return false" style="margin-left: 8%;"></td>\n' +
                '            <td style="text-align:center;vertical-align:middle;"><input type="radio" onclick="javascript:return false" style="margin-left: 8%;"></td>\n' +
                '            </tr>\n' +
                '            </table>\n' +
                '        </div>\n' +
                '    </div>\n' +
                '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                '        <div style="margin-left: 10%;;float: left;">\n' +
                '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                    '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                    '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="标题" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                    '	        <option value="0">问卷单选</option>\n' +
                    '	        <option value="1">问卷多选</option>\n' +
                    '	        <option value="2" selected="selected">问卷矩阵量表</option>\n' +
                    '	        <option value="3">问卷简答</option>\n' +
                    '	    </select>\n' +
                    '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" checked="checked" style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                    '	</div>\n' +
                    '	<div style="width:90%;height:8%;margin-top: 2%;margin-left: 7%;background: #ffffff;">\n' +
                    '	    <div style="margin-top: 2%;margin-left: 2%;">\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:1%">行标题 </label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:20%">选项文字</label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:33%">必答</label>\n' +
                    '	        <label class="am-fl am-form-label" style="font-size:19px;margin-left:6%">分数</label>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div>\n' +
                    '	    <div style="margin-left: 7%;float:left;width: 27%;">\n' +
                    '	        <textarea rows="4" cols="30" maxlength="3000" id="group_'+question_num+'" onkeyup="showRowTitle(this);" wrap="off" style="overflow:scroll;width: 202px;">' +
                                    '行标题1\n' +
                                    '行标题2' +
                    '           </textarea>\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_1" value="选项1" onfocus="if(value==&quot;选项1&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项1&quot;}" maxlength="10000" style="width:38%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_1" value="1" checked="checked" style="margin-left: 3%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 2%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;">\n' +
                    '	        <input type="text" name="option_subject_'+question_num+'" id="option_subject_'+question_num+'_2" value="选项2" onfocus="if(value==&quot;选项2&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;选项2&quot;}" maxlength="10000" style="width:38%;float:left;" onkeyup="reacInChain(this,3);"/>\n' +
                    '	        <input type="checkbox" name="option_'+question_num+'" id="option_'+question_num+'_2" value="2" style="margin-left: 3%" onclick="reacInChain(this,4);">\n' +
                    '	        <input type="number" value="0" onfocus="if(value==&quot;0&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;0&quot;}" oninput="if(value.length>5)value=value.slice(0,5)" style="width:10%;margin-left: 2%">\n' +
                    '	    </div>\n' +
                    '	    <div style="margin-top: 2%;margin-left: 34%">\n' +
                    '	        <a href="###" onclick="addOption_subject(this);"><font color="#6495ed">添加选项</font></a>\n' +
                    '	    </div>\n' +
                    '	</div>\n' +
                    '	<div style="text-align: center;margin-top: 2%">\n' +
                    '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                    '	</div>\n' +
                    '</div>\n' +
                '    <div style="clear: both;"></div>\n' +
                '    <br><br><br>\n' +
                '</div>';
        }else if(type == 3){ //简答题
            var message =
                '<div style="border:1px solid #808080;" id="'+question_num+'" name="question" onmouseover="btnEvent(this,1);" onmouseout="btnEvent(this,2);">\n' +
                '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                '        <lable style="color: #f06e57;font-size:19px;">*</lable>\n' +
                '        <lable style="color: #000000;font-size:19px;">'+question_num+'</lable>.\n' +
                '        <lable style="color: #000000;font-size:19px;">标题</lable>\n' +
                '        <lable style="color: #FF9966;font-size:19px;">【简答题】</lable>\n'+
                '    </div>\n' +
                '    <div id="showAnswer_'+question_num+'">\n' +
                '        <textarea rows="6" cols="120" maxlength="3000" id="group" style="margin-left: 4%;margin-top: 2%;width: 742px;" readonly></textarea>\n' +
                '    </div>\n' +
                '    <div style="margin-top: 2%; display: none;" id="btn_'+question_num+'">\n' +
                '        <div style="margin-left: 10%;;float: left;">\n' +
                '            <a style="text-decoration:underline;color:#428bca;font-size: 16px;" href="###" onmouseover="MM_showHideLayers(this,1,1);" onfocus="MM_showHideLayers(this,1,2);">在此题后插入新题</a>\n' +
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
                    '<div id="detail_'+question_num+'" name="detail_div" style="width:98%;height:100%;margin-top: 3%;margin-left: 1%;margin-right: 1%;background: rgba(242, 242, 242, 1);float: left;display: none;">\n' +
                    '    <div style="margin-top: 2%;margin-left: 6%">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:19px;">标题 </label>\n' +
                    '	    <input type="text" maxlength="10000" value="标题" onfocus="if(value==&quot;标题&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;标题&quot;}" style="width:70%" onkeyup="reacInChain(this,2);"/>\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 1%;margin-left: 6%">\n' +
                    '	    <select id="subjectType_'+question_num+'" style="width: 20%" onchange="selectSubjectType(this);">\n' +
                    '	        <option value="0">问卷单选</option>\n' +
                    '	        <option value="1">问卷多选</option>\n' +
                    '	        <option value="2">问卷矩阵量表</option>\n' +
                    '	        <option value="3"  selected="selected">问卷简答</option>\n' +
                    '	    </select>\n' +
                    '	    <input type="checkbox" id="title_option_'+question_num+'" value="0" checked="checked" style="margin-left: 8%" onclick="reacInChain(this,1);">必填项\n' +
                    '	</div>\n' +
                    '	<div style="margin-top: 2%;margin-left: 7%;margin-bottom: 7%;">\n' +
                    '	    <label class="am-fl am-form-label" style="font-size:17px;">限制范围 </label>\n' +
                    '	    <input type="number" id="limitNumber_'+question_num+'" value="100" onfocus="if(value==&quot;100&quot;){value=&quot;&quot;}" onblur="if(value==&quot;&quot;){value=&quot;100&quot;}" style="width:7%"/>个字\n' +
                    '	</div>\n' +
                    '	<div style="text-align: center;margin-top: 2%">\n' +
                    '	    <input type="button" value="完成编辑" onclick="overEdit(this)" style="border-radius:9px;background-color: #ffab1a;color: snow;width:100%;height:40px;"/>\n' +
                    '	</div>\n' +
                    '</div>\n' +
                '    <div style="clear: both;"></div>\n' +
                '    <br><br><br>\n' +
                '</div>';
        }


        if(flag == 2){//在对应的题目后面加
            addAfter(question_num-1);//先往后移
            $("#"+Number(question_num-1)+"").after(message);//再添加
        }else if(flag == 1){//在最后加
            $("#div_content").append(message);
        }else if(flag == 3){//替换原来的
            $("#"+question_num).replaceWith(message);
        }
    };




    //后面的div往后移1(要从后面开始先移动,不然同名的radio会覆盖后面的值)
    function addAfter(p_id) {
        var c_num = document.getElementsByName("question");
        for(var b = c_num.length-1;b >= p_id;b--){
            var c_div = c_num[b];
            c_div.id = Number(b+2);
            c_div.children[0].children[1].innerText = Number(b+2);
            c_div.children[1].id = "showAnswer_" + Number(b+2);
            c_div.children[2].id = "btn_" + Number(b+2);
            c_div.children[3].id = "detail_" + Number(b+2);
            c_div.children[3].children[1].children[0].id = "subjectType_" + Number(b+2);
            c_div.children[3].children[1].children[1].id = "title_option_" + Number(b+2);

            var subjectTypeIndex = c_div.children[3].children[1].children[0].selectedIndex; //题目类型
            if(subjectTypeIndex == 0 || subjectTypeIndex == 1){//单选,多选
                var inputs = c_div.children[3].children[3].children;
                for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                    inputs[j].children[0].name = "option_subject_" + Number(b+2);
                    inputs[j].children[0].id = "option_subject_" + Number(b+2) + "_" + Number(j+1);
                    inputs[j].children[1].name = "option_" + Number(b+2);
                    inputs[j].children[1].id = "option_" + Number(b+2) + "_" + Number(j+1);
                }
            }else if(subjectTypeIndex == 2){//矩阵
                var inputs = c_div.children[3].children[3].children;
                for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                    if(j == 0){
                        inputs[j].children[0].id = "group_" + Number(b+2);
                    }else{
                        inputs[j].children[0].name = "option_subject_" + Number(b+2);
                        inputs[j].children[0].id = "option_subject_" + Number(b+2) + "_" + Number(j);
                        inputs[j].children[1].name = "option_" + Number(b+2);
                        inputs[j].children[1].id = "option_" + Number(b+2) + "_" + Number(j);
                    }
                }
            }else if(subjectTypeIndex == 3){//简答
                c_div.children[3].children[2].children[1].id = "limitNumber_" + Number(b+2);
            }
        }
    };


    //移除本题
    function remove(p_this){
        //内容div
        var div_content = document.getElementById("div_content");

        //移除的divId
        var r_id = p_this.parentNode.parentNode.parentNode.id;
        //移除div
        div_content.removeChild(document.getElementById(r_id));

        var c_num = document.getElementsByName("question");
        for(var b=r_id;b<=c_num.length;b++){
            var c_div = c_num[b-1];
            c_div.id = b;
            c_div.children[0].children[1].innerText = b;
            c_div.children[1].id = "showAnswer_" + Number(b);
            c_div.children[2].id = "btn_" + Number(b);
            c_div.children[3].id = "detail_" + Number(b);
            c_div.children[3].children[1].children[0].id = "subjectType_" + Number(b);
            c_div.children[3].children[1].children[1].id = "title_option_" + Number(b);

            var subjectTypeIndex = c_div.children[3].children[1].children[0].selectedIndex; //题目类型
            if(subjectTypeIndex == 0 || subjectTypeIndex == 1){//单选,多选
                var inputs = c_div.children[3].children[3].children;
                for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                    inputs[j].children[0].name = "option_subject_" + Number(b);
                    inputs[j].children[0].id = "option_subject_" + Number(b) + "_" + Number(j+1);
                    inputs[j].children[1].name = "option_" + Number(b);
                    inputs[j].children[1].id = "option_" + Number(b) + "_" + Number(j+1);
                }
            }else if(subjectTypeIndex == 2){//矩阵
                var inputs = c_div.children[3].children[3].children;
                for(var j=0;j<inputs.length-1;j++){//-1是不要处理添加选项按钮
                    if(j == 0){
                        inputs[j].children[0].id = "group_" + Number(b);
                    }else{
                        inputs[j].children[0].name = "option_subject_" + Number(b);
                        inputs[j].children[0].id = "option_subject_" + Number(b) + "_" + Number(j);
                        inputs[j].children[1].name = "option_" + Number(b);
                        inputs[j].children[1].id = "option_" + Number(b) + "_" + Number(j);
                    }
                }
            }else if(subjectTypeIndex == 3){//简答
                c_div.children[3].children[2].children[1].id = "limitNumber_" + Number(b);
            }
        }
        if(c_num.length == 0){
            //显示初始提示
            document.getElementById("initial_div").style.display = "block";
        }
    };



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



    //下拉列表-题目类型
    function selectSubjectType(p_this){
        addNew(p_this.selectedIndex,3,p_this);
        var v_content = p_this.parentNode.parentNode.parentNode;//总id
        //打开编辑框
        edit(v_content.children[2].children[1].children[0]);
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



    //单选多选矩阵的添加选项
    function addOption_subject(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;//获得总id
        var div = p_this.parentNode.parentNode;
        var length = div.children.length - 1;

        var inputType = '';
        var t_subjectType = $("#subjectType_"+p_id).val();
        if(t_subjectType == 0 || t_subjectType == 1){//单选,多选
            if(length >= 20){
                swal({title: '错误提示',text: "选项最多20个",type: "error",confirmButtonText: "确  定"});
                return false ;
            }

            if(t_subjectType == 0){
                inputType = "radio";
            }else if(t_subjectType == 1){
                inputType = "checkbox";
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
            div_1_1.setAttribute("style", "width:40%;float:left;");
            div_1_1.setAttribute("onkeyup", "reacInChain(this,3);");
            div_1.appendChild(div_1_1);

            var div_1_2 = document.createElement("input");
            div_1_2.setAttribute("type", "checkbox");
            div_1_2.setAttribute("name", "option_"+p_id);
            div_1_2.setAttribute("id", "option_"+p_id+"_"+Number(length+1));
            div_1_2.setAttribute("value", Number(length+1));
            div_1_2.setAttribute("style", "margin-left: 16%;");
            div_1_2.setAttribute("onclick", "reacInChain(this,4);");
            div_1.appendChild(div_1_2);

            var div_1_3 = document.createElement("input");
            div_1_3.setAttribute("type", "number");
            div_1_3.setAttribute("value", "0");
            div_1_3.setAttribute("onfocus", "if(value=='0'){value=''}");
            div_1_3.setAttribute("onblur", "if(value==''){value='0'}");
            div_1_3.setAttribute("oninput", "if(value.length>5)value=value.slice(0,5)");
            div_1_3.setAttribute("style", "width:10%;margin-left: 20%;");
            div_1.appendChild(div_1_3);

            var div_1_4 = document.createElement("a");
            div_1_4.setAttribute("href", "###");
            div_1_4.setAttribute("style", "text-decoration:none;float: right;margin-right: 3%;");
            div_1_4.setAttribute("onclick", "removeRow(this);");
            div_1_4.innerText = "   ➖";
            div_1.appendChild(div_1_4);

            //父级.第一个参数是创建的div，第二个参数是要插入到哪个div前面
            div.insertBefore(div_1,div.children[length]);


            //显示上面选项显示
            var s_message =
                '    <div style="margin-top: 1%;margin-left: 8%;">\n' +
                '        <input type="'+inputType+'" onClick="javascript:return false">\n' +
                '        <lable style="font-size:18px;">选项'+Number(length+1)+'</lable>\n' +
                '        <lable style="font-size:18px;"></lable>\n' +
                '        <lable style="font-size:18px;color: #f06e57;"></lable>\n' +
                '    </div>';
            $("#"+"showAnswer_"+p_id+"").append(s_message);

        }else if(t_subjectType == 2){//矩阵
            if(length >= 21){
                swal({title: '错误提示',text: "选项最多20个",type: "error",confirmButtonText: "确  定"});
                return false ;
            }

            inputType = "radio";
            //扩大行标题
            document.getElementById("group_"+p_id).rows = document.getElementById("group_"+p_id).rows + 3;

            var div_1 = document.createElement("div");
            div_1.setAttribute("style", "margin-top: 2%;");

            var div_1_1 = document.createElement("input");
            div_1_1.setAttribute("type", "text");
            div_1_1.setAttribute("name", "option_subject_"+p_id);
            div_1_1.setAttribute("id", "option_subject_"+p_id+"_"+Number(length));
            div_1_1.setAttribute("value", "选项"+Number(length));
            div_1_1.setAttribute("onfocus", "if(value=='选项"+Number(length)+"'){value=''}");
            div_1_1.setAttribute("onblur", "if(value==''){value='选项"+Number(length)+"'}");
            div_1_1.setAttribute("maxlength", 10000);
            div_1_1.setAttribute("style", "width:38%;float:left;");
            div_1_1.setAttribute("onkeyup", "reacInChain(this,3);");
            div_1.appendChild(div_1_1);

            var div_1_2 = document.createElement("input");
            div_1_2.setAttribute("type", "checkbox");
            div_1_2.setAttribute("name", "option_"+p_id);
            div_1_2.setAttribute("id", "option_"+p_id+"_"+Number(length));
            div_1_2.setAttribute("value", Number(length));
            div_1_2.setAttribute("style", "margin-left: 3%;");
            div_1_2.setAttribute("onclick", "reacInChain(this,4);");
            div_1.appendChild(div_1_2);

            var div_1_3 = document.createElement("input");
            div_1_3.setAttribute("type", "number");
            div_1_3.setAttribute("value", "0");
            div_1_3.setAttribute("onfocus", "if(value=='0'){value=''}");
            div_1_3.setAttribute("onblur", "if(value==''){value='0'}");
            div_1_3.setAttribute("oninput", "if(value.length>5)value=value.slice(0,5)");
            div_1_3.setAttribute("style", "width:10%;margin-left: 3%;");
            div_1.appendChild(div_1_3);

            var div_1_4 = document.createElement("a");
            div_1_4.setAttribute("href", "###");
            div_1_4.setAttribute("style", "text-decoration:none;float: right;margin-right: 3%;");
            div_1_4.setAttribute("onclick", "removeRow(this);");
            div_1_4.innerText = "   ➖";
            div_1.appendChild(div_1_4);

            //父级.第一个参数是创建的div，第二个参数是要插入到哪个div前面
            div.insertBefore(div_1,div.children[length]);


            //显示上面表格显示
            var p_table = document.getElementById("table_"+p_id).children[0].children;
            for(var k=0;k<p_table.length;k++){
                var p_tr = p_table[k];
                if(k == 0){
                    var p_td = document.createElement("td");
                    p_td.setAttribute("style","text-align:center;vertical-align:middle;");

                    var p_lable1 = document.createElement("lable");
                    p_lable1.setAttribute("style","color: red;");
                    p_lable1.innerHTML = "" ;
                    p_td.appendChild(p_lable1);
                    var p_lable2 = document.createElement("lable");
                    p_lable2.innerHTML = "选项" + Number(length);
                    p_td.appendChild(p_lable2);

                    p_tr.appendChild(p_td);
                }else{
                    var p_td = document.createElement("td");
                    p_td.setAttribute("style","text-align:center;vertical-align:middle;");

                    var p_radio = document.createElement("input");
                    p_radio.setAttribute("type", "radio");
                    p_radio.setAttribute("onclick", "javascript:return false;");
                    p_radio.setAttribute("style", "margin-left: 8%;");
                    p_td.appendChild(p_radio);

                    p_tr.appendChild(p_td);
                }
            }
        }
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

        var t_subjectType = $("#subjectType_"+p_id).val();
        if(t_subjectType == 0 || t_subjectType == 1) {//单选,多选
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
        }else{//矩阵
            //把后面的id都往前移一位
            for(var u=remove_index;u<p_this.parentNode.parentNode.children.length-1;u++){//此处length-1是为了不修改添加选项这个标签
                var row = p_this.parentNode.parentNode.children[u];
                row.children[0].id = "option_subject_"+p_id+"_"+Number(u-1);
                row.children[1].id = "option_"+p_id+"_"+Number(u-1);
                row.children[1].value = Number(u-1);
            }

            //删除编辑行
            p_this.parentNode.parentNode.removeChild(p_this.parentNode.parentNode.children[remove_index-1]);

            //删除显示行
            var p_table = document.getElementById("table_"+p_id).children[0].children;
            for(var k=0;k<p_table.length;k++) {
                var p_tr = p_table[k];
                p_tr.removeChild(p_tr.children[remove_index-1]);
            }
        }
    };



    //输入或点击联动
    function reacInChain(p_this,p_type){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;//获得总id
        if(p_type == 1){//必填项显示
            if(p_this.checked){//判断checkbox是否选中
                p_this.parentNode.parentNode.parentNode.children[0].children[0].innerHTML = "*";
            }else{
                p_this.parentNode.parentNode.parentNode.children[0].children[0].innerHTML = "";
            }
        }else if(p_type == 2){//标题显示
            p_this.parentNode.parentNode.parentNode.children[0].children[2].innerHTML = p_this.value ;
        }else if(p_type == 3){//选项显示
            var t_id = p_this.id;
            t_id = t_id.substring(t_id.lastIndexOf('_')+1,t_id.length);//得出是第几个
            var t_subjectType = $("#subjectType_"+p_id).val();
            if(t_subjectType == 0 || t_subjectType == 1) {//单选,多选
                document.getElementById("showAnswer_"+p_id).children[t_id-1].children[1].innerHTML = p_this.value;
            }else{//矩阵
                var p_table = document.getElementById("table_"+p_id).children[0].children[0].children[t_id].children[1].innerHTML = p_this.value;

            }
        }else if(p_type == 4){//必答显示
            var t_id = p_this.id;
            t_id = t_id.substring(t_id.lastIndexOf('_')+1,t_id.length);//得出是第几个
            var t_subjectType = $("#subjectType_"+p_id).val();
            if(t_subjectType == 0 || t_subjectType == 1) {//单选,多选
                if(p_this.checked){//判断checkbox是否选中
                    document.getElementById("showAnswer_"+p_id).children[t_id-1].children[2].innerHTML = "__________________";
                    document.getElementById("showAnswer_"+p_id).children[t_id-1].children[3].innerHTML = "*";
                }else{
                    document.getElementById("showAnswer_"+p_id).children[t_id-1].children[2].innerHTML = "";
                    document.getElementById("showAnswer_"+p_id).children[t_id-1].children[3].innerHTML = "";
                }
            }else{//矩阵
                if(p_this.checked){//判断checkbox是否选中
                    var p_table = document.getElementById("table_"+p_id).children[0].children[0].children[t_id].children[0].innerHTML = "*";
                }else{
                    var p_table = document.getElementById("table_"+p_id).children[0].children[0].children[t_id].children[0].innerHTML = "";
                }
            }
        }
    };



    //行标题操作(只有矩阵有)
    function showRowTitle(p_this){
        var p_id = p_this.parentNode.parentNode.parentNode.parentNode.id;

        var txt = p_this.value ;
        var split_text = txt.split('\n');
        var split_arr = [];
        //去掉空行,空格再赋值
        for(var y=0;y<split_text.length;y++){
            var t_text = split_text[y].trim();
            if(t_text != ""){
                split_arr.push(t_text);
            }
        }
        if(split_arr.length < 1){
            swal({title: '错误提示',text: "最少保留一行",type: "error",confirmButtonText: "确  定"});
            p_this.value = "行标题1";
            split_arr.push("行标题1");
        }

        //新增和修改
        for(var t=0;t<split_arr.length;t++){
            var p_tr = document.getElementById("table_"+p_id).children[0].rows[t+1];
            if(p_tr != "" && p_tr != undefined){//存在tr,修改
                p_tr.children[0].innerText = split_arr[t];
            }else{//不存在tr,新增
                var before_tr = document.getElementById("table_"+p_id).children[0].rows[t].innerHTML;//获取上一行的模板
                before_tr = before_tr.replace(split_arr[t-1],split_arr[t]);//换成当前值
                $("#table_"+p_id).append("<tr>" + before_tr + "</tr>");
            }
        }

        //检测一遍删除,不一样就循环删除
        var p_trs = document.getElementById("table_"+p_id).children[0];
        var tr_num = p_trs.children.length-1;//tr总数
        var num = tr_num - split_arr.length ;
        for(var a=0;a<num;a++){//第一行是选项文字,这里不循环
            p_trs.removeChild(p_trs.children[tr_num]);//没删除一行都要减一行,不然下标对不上
            tr_num -- ;
        }
    };




    //校验以及保存
    function checkAndSave(){
        //问卷json数据
        var jsonData = [];

        //获取所有的题目
        var p_questions = document.getElementsByName("question");
        if(p_questions.length == 0){
            swal({title: '错误提示',text: "该问卷没有题目,请添加题目",type: "error",confirmButtonText: "确  定"});
            return false;
        }

        //循环问卷
        for(var g=0;g<p_questions.length;g++){
            // 每题数据(标题 是否必填 问卷类型 行标题(矩阵有) 选项(简答没有) 分数(简答没有) 是否必答(简答没有) 限制字数(只有简答有))
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



            //获取问卷类型
            var dataSelect = document.getElementById("subjectType_"+p_questions[g].id);
            var vs = dataSelect.options[dataSelect.selectedIndex].value;
            row.subjectType = dataSelect.selectedIndex;



            //校验选项填写(简答没有)
            if(vs != 3) {
                var option_subjects = document.getElementsByName("option_subject_" + p_questions[g].id);
                var r_op = [];
                for (var k = 0; k < option_subjects.length; k++) {
                    var op = option_subjects[k].value.trim();
                    if (op == "" || op == null) {
                        option_subjects[k].focus();
                        swal({title: '错误提示', text: "输入框" + (K + 1) + "不能为空", type: "error", confirmButtonText: "确  定"});
                        return false;
                    }
                    r_op.push(op);
                }
                row.op = r_op;
            }




            //判断必填项checkbox是否选中
            if(document.getElementById("title_option_"+p_questions[g].id).checked){
                row.requiredFields = 1;
            }else{
                row.requiredFields = 0;
            }


            //矩阵-行标题
            if(vs == 2){
                var txt = document.getElementById("group_"+p_questions[g].id).value ;
                var split_text = txt.split('\n');
                var r_opt = [];
                //去掉空行,空格再赋值
                for(var y=0;y<split_text.length;y++){
                    var t_text = split_text[y].trim();
                    if(t_text != ""){
                        r_opt.push(t_text);
                    }
                }
                row.opt = r_opt;
            }



            //简答-字数限制
            if(vs == 3) {
                var limitNumber = document.getElementById("limitNumber_"+p_questions[g].id).value.trim();
                if (limitNumber == "" || limitNumber == null || limitNumber < 0) {
                    edit(document.getElementById("btn_"+p_questions[g].id).children[1].children[0]);//打开编辑框
                    window.location.hash = "###";//初始化锚链接,不写这个的话,有时候跳转会失败
                    window.location.hash = "#"+p_questions[g].id+"";//跳转到没选中的div锚链接
                    document.getElementById("limitNumber_"+p_questions[g].id).focus();
                    swal({title: '错误提示', text: "填写范围字数不能为空或负数", type: "error", confirmButtonText: "确  定"});
                    return false;
                }
                row.wordRestriction = limitNumber;
            }




            //是否必答以及分数(除了简答)
            if(vs != 3) {
                var r_mustAnswer = [];
                var r_score = [];
                var t_mustAnswer = document.getElementsByName("option_"+p_questions[g].id);
                for(var k=0;k<t_mustAnswer.length;k++){
                    if(t_mustAnswer[k].checked){
                        r_mustAnswer.push(1);
                    }else{
                        r_mustAnswer.push(0);
                    }

                    //校验分数
                    var t_score = t_mustAnswer[k].parentNode.children[2].value.trim();
                    if(t_score==""||t_score==null){
                        detail_div.children[2].children[1].focus();
                        swal({title: '错误提示',text: "分数不能为空",type: "error",confirmButtonText: "确  定"});
                        return false;
                    }else if(t_score < 0){
                        edit(document.getElementById("btn_"+p_questions[g].id).children[1].children[0]);//打开编辑框
                        window.location.hash = "###";//初始化锚链接,不写这个的话,有时候跳转会失败
                        window.location.hash = "#"+p_questions[g].id+"";//跳转到没选中的div锚链接
                        t_mustAnswer[k].parentNode.children[2].focus();
                        swal({title: '错误提示',text: "分数不能为负数",type: "error",confirmButtonText: "确  定"});
                        return false;
                    }
                    r_score.push(t_score);
                }
                row.mustAnswer = r_mustAnswer;
                row.score = r_score;
            }


            //添加到json
            jsonData.push(row);
        }

        var param = JSON.stringify(jsonData);//json转string
        var t_id = document.getElementById("id").value;
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/estimate/saveQuestionnaire.do?estimateId=${estimateId}&id="+t_id,
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