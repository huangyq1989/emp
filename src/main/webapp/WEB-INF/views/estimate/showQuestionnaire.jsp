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
        <title>问卷查看及导出</title>
    </head>
    <body>
        <div>
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-问卷查看及导出</label>
            </div>
            <div>
                <div style="width:24.6%;height:810px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 20%">
                        <label class="am-fl am-form-label" style="font-size:25px;">问卷类型：</label>
                        <img class="img" src="${pageContext.request.contextPath}/images/u2292.png">
                    </div>
                    <div style="margin-top: 8%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">问卷单选</label>&nbsp;&nbsp;
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">问卷多选</label>&nbsp;&nbsp;
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">问卷矩阵量表</label>&nbsp;&nbsp;
                    </div>
                    <div style="margin-top: 3%;margin-left: 30%">
                        <label class="am-fl am-form-label" style="font-size:20px;">问卷简答</label>&nbsp;&nbsp;
                    </div>

                    <div style="text-align: center;margin-top: 70%;">
                        <%--<input type="button" onclick="exportPdf();" value="导 出 问 卷 PDF" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>--%>
                        <br></br>
                        <input type="button" onclick="exportWord();" value="导 出 问 卷 Word" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                        <br></br>
                        <input type="button" onclick="window.close();" value="取         消" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>

                <div style="width:75%;height:810px;float: left;border:1px solid #808080;"  id="e_div">
                    <div style="margin-top: 2%;margin-left: 35%;margin-right: 30%;">
                        <label class="am-fl am-form-label" style="font-size:20px;">${title}-培训课问卷调查</label>
                    </div>
                    <div style="height:89.5%; margin-top: 3%;margin-left: 0.5%;border:1px solid #808080;overflow:auto;" id="div_content"></div>
                </div>
            </div>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/estimate/exportQuestionnaire.do?title=${title}" id="dataForm" name="dataForm">
            <input type="hidden" id="estimateId" name="estimateId" value="${questionnaire.estimateId}"/>
        </form>
    </body>
</html>


<script type="text/javascript">

    //问卷json数据
    var jsonData = [];


    var loadWidth = 0;
    var loadHeight = 0;


    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        <c:choose>
            <c:when test="${not empty questionnaire}">
                jsonData = ${questionnaire.content} ;
                for(var n=0;n<jsonData.length;n++){
                    var rows = jsonData[n];

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
                            '    <div style="clear: both;"></div>\n' +
                            '    <br><br><br>\n' +
                            '</div>';
                    }else if(rows.subjectType == 1) { //多选
                        var message =
                            '<div style="border:1px solid #808080;" id="' + question_num + '" name="question">\n' +
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
                            '<div style="border:1px solid #808080;" id="'+question_num+'" name="question">\n' +
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
                            '    <div style="clear: both;"></div>\n' +
                            '    <br><br><br>\n' +
                            '</div>';
                    }else if(rows.subjectType == 3) { //简答题
                        var message =
                            '<div style="border:1px solid #808080;" id="' + question_num + '" name="question">\n' +
                            '    <div style="margin-top: 2%;margin-left: 3%;">\n' +
                            '        <lable style="color: #f06e57;font-size:19px;">'+temp_requiredFields+'</lable>\n' +
                            '        <lable style="color: #000000;font-size:19px;">' + question_num + '</lable>.\n' +
                            '        <lable style="color: #000000;font-size:19px;">'+rows.title+'</lable>\n' +
                            '        <lable style="color: #FF9966;font-size:19px;">【简答题】</lable>\n' +
                            '    </div>\n' +
                            '    <div id="showAnswer_' + question_num + '">\n' +
                            '        <textarea rows="6" cols="120" maxlength="3000" id="group" style="width:640px;margin-left: 4%;margin-top: 2%" readonly></textarea>\n' +
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
                            '    <div style="clear: both;"></div>\n' +
                            '    <br><br><br>\n' +
                            '</div>';
                    }
                    //在最后加
                    $("#div_content").append(message);
                }
            </c:when>
            <c:otherwise>
                swal({title: '错误提示',text: "问卷不存在,请点击问卷编辑进行添加",type: "error",icon: "success",button: "确定"},
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