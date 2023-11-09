document.write('<script src="/emp/ui/jquery.min.js" type="text/javascript" charset="utf-8"></script>');
document.write('<script src="/emp/ui/jquery.easyui.min.js" type="text/javascript" charset="utf-8"></script>');
document.write('<link rel="stylesheet" href="/emp/css/common.css" type="text/css"/>');



/****************************   公共    ****************************/
var commonUtils = {
    //登录
    checkInsertForm(){
        var contextPath = $("#contextPath").val();
        var userName = document.getElementById("userName").value.trim();
        var password = document.getElementById("password").value.trim();
        if(userName==""||userName==null){
            document.loginForm.userName.value="";
            document.loginForm.userName.focus();
            document.getElementById('alertMessage').innerText="错误提示：账号不能为空!";
            return false;
        }else if(password==""||password==null){
            document.loginForm.password.value="";
            document.loginForm.password.focus();
            document.getElementById('alertMessage').innerText="错误提示：密码不能为空!";
            return false;
        }else if(password.length<2||password.length>16){
            document.loginForm.password.value="";
            document.loginForm.password.focus();
            document.getElementById('alertMessage').innerText="错误提示：请正确填写密码!";
            return false;
        }
        $.ajax({
            type: "post",
            url: contextPath+"/login/login.do",
            data: {userName: userName, password: password},
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == 0){
                    document.getElementById('alertMessage').innerText="登录成功，请稍候...";
                    window.location.href = contextPath+'/login/home.do';
                }else if(data == 1){
                    document.loginForm.userName.value="";
                    document.loginForm.userName.focus();
                    document.getElementById('alertMessage').innerText="错误提示：账号不存在！";
                }else if(data == 2){
                    document.loginForm.password.value="";
                    document.loginForm.password.focus();
                    document.getElementById('alertMessage').innerText="错误提示：密码错误！";
                }
            },
            error: function(){
                document.getElementById('alertMessage').innerText="系统异常,请联系管理员!";
            }
        });
    },


    //打开新窗口,关闭后刷新表格
    openWindow(url,name,iWidth,iHeight,tableName) {
        var url;                            //转向网页的地址;
        var name;                           //网页名称，可为空;
        var iWidth;                         //弹出窗口的宽度;
        var iHeight;                        //弹出窗口的高度;
        //window.screen.height获得屏幕的高，window.screen.width获得屏幕的宽
        var iTop = (window.screen.height - 30 - iHeight) / 2;       //获得窗口的垂直位置;
        var iLeft = (window.screen.width - 10 - iWidth) / 2;        //获得窗口的水平位置;
        var page = window.open(url, name, 'height=' + iHeight + ',,innerHeight=' + iHeight + ',width=' + iWidth + ',innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',' +
            'toolbar=no,menubar=no,scrollbars=yes,resizable=no,location=no,status=no');

        //始终保持焦点(保持子窗口焦点)
        window.setInterval(function() {
            page.focus();
        },1000);
        window.onclick = function (){page.focus();};

        page.onload = function() {
            // unload事件放在load事件中是因为直接监听unload事件，页面在打开时会直接触发一次unload事件
            page.onunload = function () {
                $("#"+tableName).datagrid('reload');//刷新表单数据
            }
        }
    },


    //easyui datagrid表格宽度自适应
    fitCoulms(tableName){
        $("#"+tableName).datagrid({fitColumns:true});
    },


    //获取选中的行数
    getCheckRows(tableName) {
        var selRows = $("#"+tableName).datagrid('getChecked');
        return selRows;
    },


    //电子邮箱校验
    checkEmail(oTxt) {
        var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
        if(re.test(oTxt)){
            return true;
        }else{
            return false;
        }
    },


    //手机校验
    checkPhone(phone) {
        return /^1(3\d|4\d|5\d|6\d|7\d|8\d|9\d)\d{8}$/g.test(phone);
    },


    //身份证号码校验
    checkIdCard(idcard) {
        return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(idcard);
    },


    /**
     * 弹出式提示框，默认1秒自动消失  commonUtils.prompts("√    保存成功",'my-alert-success');
     * @param message 提示信息
     * @param style 提示样式，有(成功提示:my-alert-success、失败提示:my-alert-danger、提醒:my-alert-warning、信息提示:my-alert-info)
     * @param time 消失时间
     */
    prompts(message, style, time){
        style = (style === undefined) ? 'my-alert-success' : style;
        time = (time === undefined) ? 1000 : time;
        $('<div>')
        .appendTo('body')
        .addClass('my-alert ' + style)
        .html(message)
        .show()
        .delay(time)
        .fadeOut();
    }
};
/****************************   公共    ****************************/







/****************************   easyui中文支持    ****************************/
var easyuiUtils = {
    lang_zh_CN(){
        if ($.fn.pagination){
            $.fn.pagination.defaults.beforePageText = '第';
            $.fn.pagination.defaults.afterPageText = '共{pages}页';
            $.fn.pagination.defaults.displayMsg = '显示{from}到{to},共{total}记录';
        }
        if ($.fn.datagrid){
            $.fn.datagrid.defaults.loadMsg = '正在处理，请稍待。。。';
        }
        if ($.fn.treegrid && $.fn.datagrid){
            $.fn.treegrid.defaults.loadMsg = $.fn.datagrid.defaults.loadMsg;
        }
        if ($.messager){
            $.messager.defaults.ok = '确定';
            $.messager.defaults.cancel = '取消';
        }
        $.map(['validatebox','textbox','passwordbox','filebox','searchbox',
            'combo','combobox','combogrid','combotree',
            'datebox','datetimebox','numberbox',
            'spinner','numberspinner','timespinner','datetimespinner'], function(plugin){
            if ($.fn[plugin]){
                $.fn[plugin].defaults.missingMessage = '该输入项为必输项';
            }
        });
        if ($.fn.validatebox){
            $.fn.validatebox.defaults.rules.email.message = '请输入有效的电子邮件地址';
            $.fn.validatebox.defaults.rules.url.message = '请输入有效的URL地址';
            $.fn.validatebox.defaults.rules.length.message = '输入内容长度必须介于{0}和{1}之间';
            $.fn.validatebox.defaults.rules.remote.message = '请修正该字段';
        }
        if ($.fn.calendar){
            $.fn.calendar.defaults.weeks = ['日','一','二','三','四','五','六'];
            $.fn.calendar.defaults.months = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
        }
        if ($.fn.datebox){
            $.fn.datebox.defaults.currentText = '今天';
            $.fn.datebox.defaults.closeText = '关闭';
            $.fn.datebox.defaults.okText = '确定';
            $.fn.datebox.defaults.formatter = function(date){
                var y = date.getFullYear();
                var m = date.getMonth()+1;
                var d = date.getDate();
                return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
            };
            $.fn.datebox.defaults.parser = function(s){
                if (!s) return new Date();
                var ss = s.split('-');
                var y = parseInt(ss[0],10);
                var m = parseInt(ss[1],10);
                var d = parseInt(ss[2],10);
                if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
                    return new Date(y,m-1,d);
                } else {
                    return new Date();
                }
            };
        }
        if ($.fn.datetimebox && $.fn.datebox){
            $.extend($.fn.datetimebox.defaults,{
                currentText: $.fn.datebox.defaults.currentText,
                closeText: $.fn.datebox.defaults.closeText,
                okText: $.fn.datebox.defaults.okText
            });
        }
        if ($.fn.datetimespinner){
            $.fn.datetimespinner.defaults.selections = [[0,4],[5,7],[8,10],[11,13],[14,16],[17,19]]
        }
    }
};
/****************************   easyui中文支持    ****************************/





/****************************   培训管理    ****************************/
var cultivateManage = {
    //短信管理
    sendNode(cultivateId,cultivateName) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/cultivate/toSendNote.do?cultivateId=' + cultivateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1315,740,'table');
    },
    //学员管理
    toCS(cultivateId,cultivateName){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/cultivate/toCS.do?cultivateId='+cultivateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1315,740,'table');
    },
    //培训指引
    toCultivateGuide(cultivateId,cultivateName){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/cultivate/toCultivateGuide.do?cultivateId='+cultivateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1315,740,'table');
    }
};
/****************************   培训管理    ****************************/








/****************************   考试管理    ****************************/
var examinationManage = {
    //查看及导出试卷
    queryPapers(examinationId,cultivateName) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/examination/showTestPaper.do?examinationId=' + examinationId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1190,760,'table');
    },
    //导入试卷
    importPapers(examinationId,cultivateName) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/examination/importTestPaper.do?examinationId=' + examinationId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1200,760,'table');
    },
    //发布试卷
    publishPapers(examinationId,cultivateName,cultivateId) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/examination/publishPapers.do?examinationId=' + examinationId + "&cultivateName=" + cultivateName + "&cultivateId=" + cultivateId;
        commonUtils.openWindow(url,'newWindow',775,580,'table');
    },
    //复制试卷
    copyPapers(examinationId,cultivateName){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/examination/toCopyPapers.do?examinationId=' + examinationId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',875,800,'table');
    }
};
/****************************   考试管理    ****************************/









/****************************   评估管理    ****************************/
var estimateManage = {
    //查看问卷及导出详情
    queryQuestionnaire(estimateId,cultivateName) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/estimate/showQuestionnaire.do?estimateId=' + estimateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1190,760,'table');
    },
    //问卷导入
    importQuestionnaire(estimateId,cultivateName){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/estimate/importQuestionnaire.do?estimateId=' + estimateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',1200,760,'table');
    },
    //发布问卷
    publishQuestionnaire(estimateId,cultivateName,cultivateId) {
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/estimate/publishQuestionnaire.do?estimateId=' + estimateId + "&cultivateName=" + cultivateName + "&cultivateId=" + cultivateId;;
        commonUtils.openWindow(url,'newWindow',775,580,'table');
    },
    //复制问卷
    copyQuestionnaire(estimateId,cultivateName){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/estimate/toCopyQuestionnaire.do?estimateId=' + estimateId + "&cultivateName=" + cultivateName;
        commonUtils.openWindow(url,'newWindow',875,800,'table');
    }
};
/****************************   评估管理    ****************************/








/****************************   问卷管理    ****************************/
var questionnaireManage = {
    //加载数据
    dataLoad(rows) {
        document.getElementById("title").value = rows.title;
        document.getElementById("title_title").innerHTML = rows.title;
        $("#subjectType").val(rows.subjectType);
        this.selectSubjectType();
        if(rows.subjectType == 3){
            document.getElementById("limitNumber").value = rows.wordRestriction;
        }else if(rows.subjectType == 2){
            for(var i=0;i<rows.opt.length;i++){
                document.getElementById("matrix_option_subject"+Number(i+1)).value = rows.opt[i];
                var tempTitle = rows.opt[i]==null||rows.opt[i]==""?rows.opt[i]:Number(i+1)+")"+rows.opt[i];
                document.getElementById("matrix_showOption"+Number(i+1)).innerHTML = tempTitle;
            }
            for(var i=0;i<rows.op.length;i++){
                document.getElementById("matrix_option_detail"+Number(i+1)).value = rows.op[i];
                this.matrixOptionContent(Number(i+1),rows.op[i]);
                document.getElementById("matrix_score"+Number(i+1)).value = rows.ops[i];
            }
        }else{
            for(var i=0;i<rows.op.length;i++){
                if(i == 2 || i == 3){
                    this.addOption_subject();
                }
                document.getElementById("option_subject"+Number(i+1)).value = rows.op[i];
                document.getElementById("score"+Number(i+1)).value = rows.ops[i];
                var tempTitle = rows.op[i]==null||rows.op[i]==""?rows.op[i]:"<input type=\"radio\" name=\"showRadio1\"/>"+rows.op[i];
                document.getElementById("showOption"+Number(i+1)).innerHTML = tempTitle;
            }
        }
    },
    //根据题目类型变动内容div 以及 标题题目类型显示
    selectSubjectType() {
        //先清空移除已输入的选项值
        document.getElementById("option_subject1").value = "";
        document.getElementById("option_subject2").value = "";
        document.getElementById("score1").value = "";
        document.getElementById("score2").value = "";
        var option_subject3 = document.getElementById("option_subject3");
        var option_subject4 = document.getElementById("option_subject4");
        if(option_subject3 != null){
            $("#option_subject3").remove();
            $("#score3").remove();
        }
        if(option_subject4 != null){
            $("#option_subject4").remove();
            $("#score4").remove();
        }
        document.getElementById("showOption1").innerHTML = "";
        document.getElementById("showOption2").innerHTML = "";
        var showOption3 = document.getElementById("showOption3");
        var showOption4 = document.getElementById("showOption4");
        if(showOption3 != null){
            showOption3.innerHTML = "";
        }
        if(showOption4 != null){
            showOption4.innerHTML = "";
        }
        document.getElementById("limitNumber").value = "";
        document.getElementById("addOption_subject").style.display = "";
        document.getElementById("select_show").style.display = "";
        //清空矩阵的数据
        for(var i=1;i<=4;i++){
            document.getElementById("matrix_option_subject"+i).value = "";
            document.getElementById("matrix_option_detail"+i).value = "";
            document.getElementById("matrix_score"+i).value = "";
            document.getElementById("matrix_showOption"+i).innerHTML = "";
            for(var j=1;j<=4;j++){
                document.getElementById("matrix_showOption"+i+"_"+j).innerHTML = "";
            }
        }
        document.getElementById("matrix_option").style.display = "none";
        document.getElementById("matrix_show").style.display = "none";

        //还原被隐藏的元素和隐藏限制字数
        document.getElementById("select_option").style.display = "";
        document.getElementById("limit_div").style.display = "none";

        //获取被选中的option标签
        var dataSelect = document.getElementById("subjectType");
        var vs = dataSelect.options[dataSelect.selectedIndex].value;
        if(vs == 0 || vs == 1) {
            if(vs == 0){
                document.getElementById("title_subjectType").innerHTML = "【单选题】";
            }else{
                document.getElementById("title_subjectType").innerHTML = "【多选题】";
            }
        }else if(vs == 2){
            document.getElementById("title_subjectType").innerHTML = "【矩阵量表题】";
            document.getElementById("matrix_show").style.display = "";
            document.getElementById("select_show").style.display = "none";
            document.getElementById("select_option").style.display = "none";
            document.getElementById("matrix_option").style.display = "";
        }else if(vs == 3){
            document.getElementById("title_subjectType").innerHTML = "【简答题】";
            document.getElementById("select_option").style.display = "none";
            document.getElementById("limit_div").style.display = "";
        }
    },
    //单选多选的添加选项
    addOption_subject(){
        var div = document.getElementById("option_div");
        var div2 = document.getElementById("title_div");

        var option_subject3 = document.getElementById("option_subject3");
        var option_subject4 = document.getElementById("option_subject4");
        if(option_subject3 == null || option_subject4 == null) {
            var temp_div = document.createElement("div");
            temp_div.setAttribute("style", "margin-top: 2%;margin-left: 7%");

            var temp_input1 = document.createElement("input"); //编辑描述框
            temp_input1.setAttribute("type", "text");
            temp_input1.setAttribute("name", "option_subject");
            temp_input1.setAttribute("maxlength", "30");
            temp_input1.setAttribute("style", "width:80%;float:left;");

            var temp_input2 = document.createElement("input"); //编辑分数框
            temp_input2.setAttribute("type", "number");
            temp_input2.setAttribute("name", "score");
            temp_input2.setAttribute("oninput", "if(value.length>5)value=value.slice(0,5)");
            temp_input2.setAttribute("style", "width:6%");


            var temp_div2 = document.createElement("div");
            temp_div2.setAttribute("style", "margin-top: 1%;margin-left: 8%");

            var temp_label1 = document.createElement("label"); //选项显示框
            temp_label1.setAttribute("class", "am-fl am-form-label");
            temp_label1.setAttribute("style", "font-size:18px;");

            if (option_subject3 == null) {
                temp_input1.setAttribute("id", "option_subject3");
                temp_input1.setAttribute("placeholder", "请输入选项3的信息...");
                temp_input1.setAttribute("onkeyup", "showOption(this,3)");

                temp_input2.setAttribute("id", "score3");

                temp_label1.setAttribute("id", "showOption3");
            } else if (option_subject4 == null) {
                temp_input1.setAttribute("id", "option_subject4");
                temp_input1.setAttribute("placeholder", "请输入选项4的信息...");
                temp_input1.setAttribute("onkeyup", "showOption(this,4)");

                temp_input2.setAttribute("id", "score4");

                temp_label1.setAttribute("id", "showOption4");

                document.getElementById("addOption_subject").style.display = "none";//隐藏添加选项按钮
            }
            temp_div.appendChild(temp_input1);
            temp_div.appendChild(temp_input2);
            div.appendChild(temp_div);
            temp_div2.appendChild(temp_label1);
            div2.appendChild(temp_div2);
        }
    },
    //矩阵内容的显示与清空
    matrixOptionContent(i,value){
        var checkValue1 = document.getElementById("matrix_option_subject1").value;
        var checkValue2 = document.getElementById("matrix_option_subject2").value;
        var checkValue3 = document.getElementById("matrix_option_subject3").value;
        var checkValue4 = document.getElementById("matrix_option_subject4").value;
        var id1 = "matrix_showOption1_"+i;
        var id2 = "matrix_showOption2_"+i;
        var id3 = "matrix_showOption3_"+i;
        var id4 = "matrix_showOption4_"+i;
        if(checkValue1 == null || checkValue1 == "" || value == null || value == ""){
            document.getElementById(id1).innerHTML = "";
        }else{
            document.getElementById(id1).innerHTML = "<input type=\"radio\" name=\"tempRadio1\"/>"+value;
        }
        if(checkValue2 == null || checkValue2 == "" || value == null || value == ""){
            document.getElementById(id2).innerHTML = "";
        }else{
            document.getElementById(id2).innerHTML = "<input type=\"radio\" name=\"tempRadio2\"/>"+value;
        }
        if(checkValue3 == null || checkValue3 == "" || value == null || value == ""){
            document.getElementById(id3).innerHTML = "";
        }else{
            document.getElementById(id3).innerHTML = "<input type=\"radio\" name=\"tempRadio3\"/>"+value;
        }
        if(checkValue4 == null || checkValue4 == "" || value == null || value == ""){
            document.getElementById(id4).innerHTML = "";
        }else{
            document.getElementById(id4).innerHTML = "<input type=\"radio\" name=\"tempRadio4\"/>"+value;
        }
    }
};
/****************************   问卷管理    ****************************/








/****************************   管理员账号    ****************************/
var employeeManage = {
    //添加人员角色或删除人员角色
    toEditER(employeeId,type){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/employee/toEditER.do?type='+type+'&employeeId='+employeeId;
        commonUtils.openWindow(url,'newWindow',1100,650,'table');
    }
};
/****************************   管理员账号    ****************************/







/****************************   角色管理    ****************************/
var roleManage = {
    //修改角色名
    editRole(roleId){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/roleMenu/editRole.do?roleId='+roleId;
        commonUtils.openWindow(url,'newWindow',1100,685,'table');
    },
    //编辑权限
    editMenu(roleId){
        var contextPath = $("#contextPath").val();
        var url = contextPath+'/roleMenu/editRoleMenu.do?roleId='+roleId;
        commonUtils.openWindow(url,'newWindow',1100,710,'table');
    }
};
/****************************   角色管理    ****************************/