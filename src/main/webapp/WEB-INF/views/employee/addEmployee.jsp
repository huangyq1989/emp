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
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <title>${title}</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}</label>
            </div>
            <div style="border:1px solid #808080;height: 630px;" id="t_div">
                <div style="text-align: center; padding:15px;">
                    <form id="formMessage" name="formMessage" style="padding: 110px 80px 110px 20px;">
                        <table width="100%" border="0" width="600" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <c:if test="${employeeM.id != null}">
                                <input type="hidden" id="id" name="id" value="${employeeM.id}"/>
                            </c:if>
                            <tr>
                                <td width="15%"><font color="red">*</font>姓 名：</td>
                                <td width="30%"><input type="text" id="realName" name="realName" maxlength="10" style="width:100%" value="${employeeM.realName}"/></td>
                                <td width="10%"></td>
                                <td width="15%">性 别：</td>
                                <td width="30%">
                                    <input type="hidden" id="sex" name="sex" value="${employeeM.sex}"/>
                                    <select id="tmpSex" name="tmpSex" style="width: 100%">
                                        <c:choose>
                                            <c:when test="${not empty employeeM.sex}">
                                                <option value="0" <c:if test="${employeeM.sex=='0'}"> selected="selected"</c:if> >男</option>
                                                <option value="1" <c:if test="${employeeM.sex=='1'}"> selected="selected"</c:if> >女</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="0" selected="selected">男</option>
                                                <option value="1">女</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%">邮 箱：</td>
                                <td width="30%"><input type="text" id="email" name="email" value="${employeeM.email}" maxlength="30" style="width:100%"/></td>
                                <td width="10%"></td>
                                <td width="15%">手机号码：</td>
                                <td width="30%"><input type="number" id="phone" name="phone" value="${employeeM.phone}" maxlength="11" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>登录名：</td>
                                <td width="30%"><input type="text" id="userName" name="userName" value="${employeeM.userName}" maxlength="30" placeholder="登录账号" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>密码：</td>
                                <td width="30%"><input type="text" id="password" name="password" value="${employeeM.password}" maxlength="30" placeholder="最少7位" style="width:100%"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>确认密码：</td>
                                <td width="30%"><input type="text" id="checkPassword" name="checkPassword" value="${employeeM.password}" maxlength="30" placeholder="需与密码一致" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%">添加角色：</td>
                                <td width="30%">
                                    <select id="roleFlag" name="roleFlag" style="width: 100%;" onchange="selectRoleFlag();">
                                        <option value="0" selected="selected">否</option>
                                        <option value="1">是</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="roleData" name="roleData"/>
                    </form>
                </div>

                <div id="roleDiv">
                    <div id="tb" style="padding:3px;margin-top: 1%;margin-left: 6%;margin-right: 5%;">
                        <form method="post" id="dataForm" name="dataForm">
                            <span>角色名称:</span>
                            <input id="roleName" name="roleName" style="line-height:22px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                            <input type="button" id="search" name="search" value="查询角色" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                        </form>
                        <br>
                    </div>
                    <div style="margin-top: 0%;margin-left: 6%;margin-right: 5%;">
                        <table id="table" cellspacing="0" cellpadding="0"></table>
                    </div>
                    <br>
                </div>
                <div style="text-align: center;padding: 20px 0px 30px 0px;">
                    <input type="button" onclick="addOrEdit();" value="确    认" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                </div>
            </div>
        </div>
    </body>

</html>


<script type="text/javascript">


    var loadWidth = 0;
    var loadHeight = 0;

    //初始化加载数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;


        var title = '';
        var url = '';
        $("#table").datagrid({
            title:title,
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/roleMenu/getER.do?type=add',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:400,
            pageSize: 10,
            columns: [[
                {field:'chk',checkbox: true,width:120},
                {field:'id',title:'编号',width:120, sortable: true, halign:"center", align:"center"},
                {field:'roleName',title:'角色名称',width:230, halign:"center", align:"center"},
                {field:'insertTime',title:'新增时间',width:290, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'updateTime',title:'修改时间',width:290, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                }
            ]]
        });

        getPager();

        document.getElementById("roleDiv").style.display = "none";//默认隐藏添加角色
    });


    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            roleName: $('#roleName').val()
        });
    },false);


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


    //是否需要添加角色
    function selectRoleFlag(){
        //获取被选中的option标签
        var roleFlag = document.getElementById("roleFlag");
        var vs = roleFlag.options[roleFlag.selectedIndex].value;
        if(vs == 0) {
            document.getElementById("roleDiv").style.display = "none";
            document.getElementById("t_div").style = "border:1px solid #808080;height: 630px;";
            document.getElementById("formMessage").style = "padding: 110px 80px 110px 20px;";
        }else{
            document.getElementById("roleDiv").style.display = "";
            document.getElementById("t_div").style = "border:1px solid #808080;height: 860px;";
            document.getElementById("formMessage").style = "padding: 0px 80px 20px 20px;";
        }
    };


    //保存
    function addOrEdit() {
        var type = "0";
        //判断是新增还是修改
        <c:if test="${employeeM.id != null}">
            type = "1" ;
        </c:if>

        var realName = document.getElementById("realName").value.trim();
        var sexSelect = document.getElementById("tmpSex");
        document.formMessage.sex.value = sexSelect.options[sexSelect.selectedIndex].value;
        var email = document.getElementById('email').value.trim();
        var phone = document.getElementById('phone').value.trim();
        var userName = document.getElementById('userName').value.trim();
        var password = document.getElementById('password').value.trim();
        var checkPassword = document.getElementById('checkPassword').value.trim();

        if(realName == ""){
            swal({title: "错误提示",text: "姓名不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.realName.focus();},0);
            });
            return false;
        }
        if(email != "" && !commonUtils.checkEmail(email)){
            swal({title: "错误提示",text: "电子邮箱格式错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.email.focus();},0);
            });
            return false;
        }
        if(phone != "" && !commonUtils.checkPhone(phone)){
            swal({title: "错误提示",text: "手机号码错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.phone.focus();},0);
            });
            return false;
        }
        if(userName == ""){
            swal({title: "错误提示",text: "登录名不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.userName.focus();},0);
            });
            return false;
        }
        if(password == ""){
            swal({title: "错误提示",text: "密码不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.password.focus();},0);
            });
            return false;
        }else if(checkPassword == ""){
            swal({title: "错误提示",text: "确认密码不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.checkPassword.focus();},0);
            });
            return false;
        }else if(checkPassword != password){
            swal({title: "错误提示",text:"确认密码与密码不一致",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.checkPassword.focus();},0);
            });
            return false;
        }
        if (password.length < 7) {//密码中最少7位
            swal({title: "错误提示",text: "密码最少7位",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.password.focus();},0);
            });
            return false;
        }

        //角色
        var roleFlag = document.getElementById("roleFlag");
        var vs = roleFlag.options[roleFlag.selectedIndex].value;
        if(vs != 0) {//添加角色
            var rows = commonUtils.getCheckRows('table');
            if(rows.length == 0){
                swal({title: "提示",text: "请选择需要添加的角色",type: "warning",confirmButtonText: "确  定"});
                return false;
            }else{
                //获取选择的ID
                var t_Data = new Array();
                for(var i=0;i<rows.length;i++) {
                    t_Data.push(rows[i].id);
                }
                var param = JSON.stringify(t_Data);//json转string
                document.getElementById("roleData").value = param;
            }
        }

        //表单序列化
        var employeeM = $('#formMessage').serialize();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/employee/addOrEdit.do?type="+type,
            data: employeeM,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data.rCode == 0){
                    // 1秒定时关闭弹窗
                    swal({title: "提示",text: data.detail,showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                        window.close();
                    });
                }else if(data.rCode == 1){
                    swal({title: "错误提示",text: data.detail,type: "error",confirmButtonText: "确  定"},function(){
                        setTimeout(function(){document.formMessage.userName.focus();},0);
                    });
                }
            },
            error: function(){
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