<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
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
            <div style="text-align: center; padding:5px;">
                <form id="formMessage" name="formMessage" style="padding: 0px 80px 0px 0px;">
                    <table border="0" height="100" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                        <c:if test="${role.id != null}">
                            <input type="hidden" id="id" name="id" value="${role.id}"/>
                        </c:if>
                        <tr>
                            <td width="15%"><font color="red">*</font>权限名称：</td>
                            <td width="30%"><input type="text" id="roleName" name="roleName" maxlength="10" style="width:100%" value="${role.roleName}"/></td>
                        </tr>
                    </table>
                </form>
            </div>
            <div style="height: 360px;border:1px solid #808080;overflow:auto;margin-left: 16%;margin-right: 7%;">
                <ul id="regionTree"></ul>
            </div>
            <div style="text-align: center;padding: 80px 0px 50px 0px;">
                <input type="button" onclick="addOrEdit();" value="确    认" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" onclick="window.close();" value="取    消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
            </div>
        </div>


    </body>
</html>


<script type="text/javascript">


    var loadWidth = 0;
    var loadHeight = 0;


    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        $('#regionTree').tree({
            url : '${pageContext.request.contextPath}/roleMenu/queryMenu.do',
            checkbox: true,
            onLoadSuccess(data) {//选中已经存在的菜单
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/roleMenu/getRoleMenus.do?roleId=${roleId}",
                    data: null,
                    traditional:true,
                    async:false,
                    dataType:"json",
                    success: function(re){
                        for(var i=0;i<re.detail.length;i++){
                            var node = $('#regionTree').tree('find', re.detail[i].menuId);//找到id为”regionTree“这个树的节点id为”10“的对象
                            $('#regionTree').tree('check', node.target);//设置选中该节点
                        }
                    },
                    error: function(){
                        swal({title: "错误提示",text: "加载权限菜单失败",type: "error",confirmButtonText: "确  定"});
                    }
                });
            }
        });
    });



    //保存权限和权限
    function addOrEdit() {
        var type = "0";
        //判断是新增还是修改
        <c:if test="${role.id != null}">
            type = "1" ;
        </c:if>
        var roleName = document.getElementById("roleName").value.trim();
        if(roleName == ""){
            swal({title: "错误提示",text: "权限名称不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.roleName.focus();},0);
            });
            return false;
        }
        //表单序列化
        var role = $('#formMessage').serialize();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/roleMenu/addOrEdit.do?type="+type,
            data: role,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data.rCode == 0){
                    var t_url = "";
                    if(type == "0"){
                        t_url = "${pageContext.request.contextPath}/roleMenu/saveRoleMenu.do?roleId="+data.returnRoleId;
                    }else{
                        t_url = "${pageContext.request.contextPath}/roleMenu/saveRoleMenu.do?roleId=${roleId}";
                    }

                    /**********保存权限**********/
                    var nodes = $('#regionTree').tree('getChecked');
                    //获取选择的ID
                    var arr = new Array();
                    for(var i=0;i<nodes.length;i++){
                        if(nodes[i].menuClass != 1){//不是父节点
                            arr.push(nodes[i].id);
                        }
                    }
                    $.ajax({
                        type: "post",
                        url: t_url,
                        data: {"arr":arr},
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(re){
                            if(re == 0){
                                // 1秒定时关闭弹窗
                                swal({title: "提示",text: "保存成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                                    window.close();
                                });
                            }else{
                                swal({title: "错误提示",text: "保存失败",type: "error",confirmButtonText: "确  定"});
                            }
                        },
                        error: function(){
                            swal({title: "错误提示",text: "保存出错",type: "error",confirmButtonText: "确  定"});
                        }
                    });
                }else if(data.rCode == 1){
                    swal({title: "错误提示",text: data.detail,type: "error",confirmButtonText: "确  定"},function(){
                        setTimeout(function(){document.formMessage.roleName.focus();},0);
                    });
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