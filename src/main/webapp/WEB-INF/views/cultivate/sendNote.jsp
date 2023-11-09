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
        <!-- easyui -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/default/easyui.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/icon.css" type="text/css"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>短信管理</title>

        <!-- easyui每行高度 -->
        <style>
            .datagrid-btable tr{height: 48px;}
        </style>
    </head>
    <body>
        <div style="overflow:auto;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white" id="title">${cultivateName}-短信列表</label>
            </div>
            <div >
                <div style="width:17%;height:690px;background: #ccc;float: left;border:1px solid #808080;">
                    <div style="margin-top: 20%;margin-left: 20%">
                        <label class="am-fl am-form-label" style="font-size:25px;">短信管理</label>
                    </div>
                    <div style="text-align: center;margin-top: 40%;">
                        <input type="button" onclick="viewNoteMenu(1);" value="已 发 短 信 列 表" style="border-radius:9px;background-color:#985f0d;color: snow;width:150px;height:40px"/>
                        <br></br>
                        <br></br>
                        <input type="button" onclick="viewNoteMenu(2);" value="短 信 编 辑 发 送" style="border-radius:9px;background-color:purple;color: snow;width:150px;height:40px"/>
                        <br></br>
                        <br></br>
                        <input type="button" onclick="window.close();" value=" 关       闭 " style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                    </div>
                </div>



                <!--短信列表-->
                <div style="width:83%;height:690px;float: left;border:1px solid #808080;" id="n_div">
                    <div id="tb" style="margin-left: 6%;margin-top: 3%;margin-bottom: 5%;padding:3px">
                        <span style="font-size: 20px;">短信创建日期:</span>&nbsp;&nbsp;&nbsp;
                        <input id="insertTime" name="insertTime" type="text" style="line-height:26px;border:1px solid #ccc"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" id="search" name="search" value="  查    询  " style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:35px"/>&nbsp;&nbsp;&nbsp;
                        <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:35px"/>
                    </div>
                    <div style="margin-left: 1%;margin-right: 1%;">
                        <table id="table" cellspacing="0" cellpadding="0"></table>
                    </div>
                </div>



                <!--编辑短信-->
                <div style="width:83%;height:690px;float: left;border:1px solid #808080;" id="e_div">
                    <div style="margin-top: 1%;margin-left: 11%;">
                        <label class="am-fl am-form-label" style="font-size:20px;" id="peopleNum">收件人(39人):</label>
                        <%--<div style="margin:15px;width:720px;height:150px;border:1px solid #808080;overflow:auto;" id="group"></div>--%>
                        <div style="margin:15px;width:780px;height:150px;">
                            <textarea style="width:780px;height:150px;" rows="9" cols="120" maxlength="3000" id="group" placeholder="186805XXXXX（小X），186805XXXXX（张XX）" onBlur="updateJson(this);"></textarea>
                        </div>
                        <div style="margin:15px;">
                            <input type="text" id="name" maxlength="11" style="width:16%"  placeholder="请输入添加的姓名"/>
                            <input type="text" id="phone" maxlength="11" style="width:25%"  placeholder="请输入需要添加的手机号码..."/>
                            <a href="###" style="text-decoration:none;" onclick="addPeople()"><font color="#6495ed">添加收件人</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="###" style="text-decoration:none;" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/cultivate/importSend.do','newWindow1',900,600,'table');"><font color="#6495ed">批量导入收件人</font></a>
                        </div>
                    </div>

                    <div style="margin-top: 4%;margin-left: 11%;">
                        <label class="am-fl am-form-label" style="font-size:20px;">短信内容:</label>
                        <div style="margin:15px;" id="sendTime_div">
                            <input type="radio" name="option" value="1" checked="checked" onchange="checkRadio(1,this);">立即下发
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="radio" name="option" value="2" onchange="checkRadio(2,this);">下发时间设置
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </div>
                        <%--<div style="margin:15px;width:52px;height:150px;">--%>

                        <%--</div>--%>
                        <div style="margin:15px;width:720px;height:150px;">
                            <div style="float: left;">
                                <input type="button" onclick="addMessageName(document.getElementById('content'),'<<姓名>>');" value="姓 名  ➜" style="border-radius:9px;background-color:snow;color: #333333;width:60px;height:20px"/>
                            </div>
                            <%--<div style="">--%>
                                <textarea style="width:640px;height:150px;margin-left: 2%;" rows="11" cols="120" maxlength="300" id="content" placeholder="短信内容在300字以内..."></textarea>
                            <%--</div>--%>
                        </div>

                        <div style="text-align: center;padding: 60px 150px 0px 0px;">
                            <%--<input type="button" onclick="viewEditNote();" value=" 预    览 " style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>--%>
                            <%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
                            <%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
                            <input type="button" onclick="saveNote();" value=" 确    定 " style="border-radius:9px;background-color:#0092DC;color: snow;width:150px;height:40px"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>


<script type="text/javascript">

    var loadWidth = 0;
    var loadHeight = 0;

    // 发送人员
    var jsonData = [];

    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        easyuiUtils.lang_zh_CN();//加载easyui中文支持

        //隐藏编辑短信
        document.getElementById('e_div').style.display = "none";

        $("#table").datagrid({
            title:"已发送短信列表",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/cultivate/querySendData.do?cultivateId=${cultivateId}',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            nowrap:false,//超长后换行
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:540,
            pageSize: 10,
            columns: [[
                {field:'id',title:'编号',width:50,sortable: true, halign:"center", align:"center"},
                {field:'content',title:'内容',width:510, halign:"center", align:"center"},
                {field:'sendDataCode',title:'发送状态',width:80, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "未发送";
                        }else{
                            return "已发送";
                        }
                    }
                },
                {field:'sendTime',title:'发送时间',width:160, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'peopleNum',title:'发送人数',width:100, halign:"center", align:"center"},
                {field:'insertTime',title:'创建时间',width:160, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                }
            ]]
        });

        getPager();

        //加载查询时间控件
        $('#insertTime').datebox({
            // required:true 非必须
            editable:false //禁止输入
        });

        //加载短信学员
        var studentDeatils = ${studentDetails};
        var sDeatils = "";
        if(studentDeatils.total != 0){
            for(var j=0;j<studentDeatils.rows.length;j++){
                var t_row = {};
                t_row.realName = studentDeatils.rows[j].realName;
                t_row.phone = studentDeatils.rows[j].phone;
                jsonData.push(t_row);
                sDeatils = sDeatils + studentDeatils.rows[j].phone + "（"+ studentDeatils.rows[j].realName +"），";
            }
            sDeatils = sDeatils.substring(0,sDeatils.length-1);
        }
        document.getElementById('group').value = sDeatils;
        document.getElementById('peopleNum').innerText = "收件人("+jsonData.length+"人):";
    });


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        commonUtils.fitCoulms("table");
        getPager();

        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });


    //设置分页控件
    function getPager(){
        var p = $('#table').datagrid('getPager');
        $(p).pagination({
            pageSize: 10,//每页显示的记录条数，20
            pageList: [10],//可以设置每页记录条数的列表
            beforePageText: '第',//页数文本框前显示的汉字
            afterPageText: '页    共 {pages} 页',
            displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
            onBeforeRefresh:function(){
                $(this).pagination('loading');
            }
        });
    };


    //显示或隐藏时间
    function checkRadio(type,check){
        if(type == 1){
            //销毁datetimebox
            $('#sendTime').combobox('destroy');
        }else{
            var input = document.createElement("input");
            input.setAttribute("type","text");
            input.setAttribute("id","sendTime");
            input.setAttribute("style","width:25%;");
            document.getElementById('sendTime_div').appendChild(input);
            this.addDatebox();
        }
    };


    //加载时间控件
    function addDatebox(){
        $('#sendTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
    };


    //加载不同的菜单
    function viewNoteMenu(type){
        if(type == 1){
            document.getElementById('e_div').style.display = "none";
            document.getElementById('n_div').style.display = "";
            document.getElementById('title').innerText = "${cultivateName}-短信列表" ;
        }else{
            document.getElementById('e_div').style.display = "";
            document.getElementById('n_div').style.display = "none";
            document.getElementById('title').innerText = "${cultivateName}-编辑短信" ;
        }
    };


    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            insertTime: $('#insertTime').val()
        });
    },false);


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        $('#insertTime').combo('setText','');//清空时间
        document.getElementById("insertTime").value = '';//清空时间内容
        $('#table').datagrid('load',{});
    },false);


    //添加收件人
    function addPeople(){
        var name = document.getElementById('name').value.trim();
        if(name == ""){
            swal({title: "错误提示",text: "姓名不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.getElementById('name').focus();},0);
            });
            return false;
        }
        var phone = document.getElementById('phone').value.trim();
        if(phone == ""){
            swal({title: "错误提示",text: "手机号码不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.getElementById('phone').focus();},0);
            });
            return false;
        }else if(!commonUtils.checkPhone(phone)){
            swal({title: "错误提示",text: "手机号码错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.getElementById('phone').focus();},0);
            });
            return false;
        }
        var g_value = document.getElementById('group').value ;
        if(jsonData.length == 0){
            document.getElementById('group').value = g_value + phone + "（"+ name +"）";
        }else{
            document.getElementById('group').value = g_value + "，" + phone + "（"+ name +"）";
        }
        var t_row = {};
        t_row.realName = name;
        t_row.phone = phone;
        jsonData.push(t_row);
        document.getElementById('peopleNum').innerText = "收件人("+jsonData.length+"人):";
        document.getElementById('name').value = "";
        document.getElementById('phone').value = "";
    };


    //导入后的收件人
    function addPeopleByImport(){
        var t_sendPeople = localStorage.getItem('sendPeople');
        var sendPeople = JSON.parse(t_sendPeople);
        for(var i=0;i<sendPeople.length;i++){
            var name = sendPeople[i].realName;
            var phone = sendPeople[i].phone;
            var g_value = document.getElementById('group').value ;
            if(jsonData.length == 0){
                document.getElementById('group').value = g_value + phone + "（"+ name +"）";
            }else{
                document.getElementById('group').value = g_value + "，" + phone + "（"+ name +"）";
            }
            var t_row = {};
            t_row.realName = name;
            t_row.phone = phone;
            jsonData.push(t_row);
            document.getElementById('peopleNum').innerText = "收件人("+jsonData.length+"人):";
        }
        localStorage.removeItem('sendPeople');//移除保存的数据
    };


    //更新json
    function updateJson(message) {
        var t_message = message.value.trim();

        if(t_message.indexOf(",") != -1){
            swal({title: "错误提示",text: "分隔符请使用 ， 中文逗号",type: "error",confirmButtonText: "确  定"});
            return false;
        }else if(t_message.indexOf("(") != -1 || t_message.indexOf(")") != -1){
            swal({title: "错误提示",text: "姓名请写在中文括号（）里面",type: "error",confirmButtonText: "确  定"});
            return false;
        }else{
            if(t_message != null && t_message != ""){
                var arr = t_message.split("，");
                //先重置jsonData
                jsonData = [];
                for(var z=0;z<arr.length;z++){
                    var t_arr = arr[z].trim();
                    if(t_arr != null && t_arr != ""){
                        var t_phone = arr[z].substring(0,arr[z].indexOf("（"));
                        t_phone = t_phone.trim();
                        var t_name = arr[z].substring(arr[z].indexOf("（")+1,arr[z].lastIndexOf("）"));
                        t_name = t_name.trim();
                        if(!commonUtils.checkPhone(t_phone)) {
                            swal({title: "错误提示",text: "手机号码"+t_phone+"错误,请重新输入",type: "error",confirmButtonText: "确  定"});
                            return false;
                        }else if(t_name == ""){
                            swal({title: "错误提示",text: "手机号码"+t_phone+",请输入对应的姓名",type: "error",confirmButtonText: "确  定"});
                            return false;
                        }else if(t_name.indexOf("（") != -1 || t_name.indexOf("）") != -1){
                            swal({title: "错误提示",text: "手机号码"+t_phone+",姓名格式错误",type: "error",confirmButtonText: "确  定"});
                            return false;
                        }else{
                            var t_row_t = {};
                            t_row_t.realName = t_name ;
                            t_row_t.phone = t_phone ;
                            jsonData.push(t_row_t);
                        }
                    }
                }
                return true;
            }else{
                jsonData = [];
                return true;
            }
            document.getElementById('peopleNum').innerText = "收件人("+jsonData.length+"人):";
        }
    };



    //保存
    function saveNote(){
        //再检测一遍号码输入框
        var flag = updateJson(document.getElementById("group"));
        if(!flag){
            return false;
        }


        if(jsonData.length == 0){
            swal({title: "错误提示",text: "收件人不能为空,请添加收件人",type: "error",confirmButtonText: "确  定"});
            return false;
        }

        var content = document.getElementById('content').value.trim();
        if(content == ""){
            swal({title: "错误提示",text: "短信内容不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.getElementById('content').focus();},0);
            });
            return false;
        }
        var val=$('input:radio[name="option"]:checked').val();
        var t_sendTime = "立即";
        if(val != "1"){
            t_sendTime = $('#sendTime').val();
            if(t_sendTime == ""){
                swal({title: "错误提示",text: "请设置下发时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }else{
                //时间比较大小
                var oDate1 = new Date();
                var oDate2 = new Date(t_sendTime);
                if (oDate1.getTime() > oDate2.getTime()) {
                    swal({title: "错误提示",text: "下发时间不能小于当前时间,请重新设置下发时间",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
            }
        }
        swal({
            title: "提示",
            text: "确定要"+t_sendTime+"发送吗?",
            type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
            closeOnConfirm: false, //确认再提示
            // closeOnCancel: false //关闭再提示
        },
        function(isConfirm){
            if (isConfirm) {
                var sendData = [];
                var row = {};
                row.cultivateId = ${cultivateId};
                row.content = content;
                row.peopleDatailList = jsonData;
                row.peopleNum = jsonData.length;
                row.sendType = val;
                row.sendTime = t_sendTime;
                sendData.push(row);

                var param = JSON.stringify(sendData);//json转string
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/cultivate/saveSendData.do",
                    data: {"sendData":param},
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
            } else {
            }
        });
    };



    //在光标后追加姓名替换符  myField：textarea的id   myValue：要插入的内容
    function addMessageName(myField, myValue){
        //IE浏览器
        if (document.selection) {
            myField.focus();
            sel = document.selection.createRange();
            sel.text = myValue;
            sel.select();
        }
        //火狐/网景 浏览器
        else if (myField.selectionStart || myField.selectionStart == '0') {
            //得到光标前的位置
            var startPos = myField.selectionStart;
            //得到光标后的位置
            var endPos = myField.selectionEnd;
            // 在加入数据之前获得滚动条的高度
            var restoreTop = myField.scrollTop;
            myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
            //如果滚动条高度大于0
            if (restoreTop > 0) {
                // 返回
                myField.scrollTop = restoreTop;
            }
            myField.focus();
            myField.selectionStart = startPos + myValue.length;
            myField.selectionEnd = startPos + myValue.length;
        } else {
            myField.value += myValue;
            myField.focus();
        }
    };


</script>