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
            <div style="border:1px solid #808080">
                <div style="text-align: center; padding:15px;margin-top: 7%;">
                    <form id="formMessage" name="formMessage" style="padding: 20px 100px 100px 0px;">
                        <table width="100%" border="0" width="600" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <tr>
                                <td>序 号：</td>
                                <td align="left">
                                    <c:choose>
                                        <c:when test="${not empty cultivate.id}">
                                            <input type="hidden" id="id" name="id" value="${cultivate.id}"/>
                                            ${cultivate.id}
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" id="id" name="id" value="${autoId}"/>
                                            ${autoId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>培训名称：</td>
                                <td width="30%"><input type="text" id="cultivateName" name="cultivateName" maxlength="20" style="width:100%" value="${cultivate.cultivateName}"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>培训类型：</td>
                                <td width="30%"><input type="text" id="cultivateType" name="cultivateType" value="${cultivate.cultivateType}" maxlength="10" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>培训开始时间：</td>
                                <td width="30%"><input type="text" id="beginTime" name="beginTime" maxlength="20" style="width:100%" value="${cultivate.beginTime}"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>培训结束时间：</td>
                                <td width="30%"><input type="text" id="endTime" name="endTime" maxlength="20" style="width:100%" value="${cultivate.endTime}"/></td>
                            </tr>
                        </table>
                    </form>
                </div>

                <div style="text-align: center;padding: 40px 0px 140px 0px;">
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

        easyuiUtils.lang_zh_CN();//加载easyui中文支持
        //加载时间控件
        $('#beginTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
        $('#endTime').datetimebox({
            required:true,
            showSeconds: true,
            editable:false //禁止输入
        });
    });


    //保存
    function addOrEdit() {
        var type = "0";
        //判断是新增还是修改
        <c:if test="${cultivate.id != null}">
            type = "1" ;
        </c:if>

        var cultivateName = document.getElementById("cultivateName").value.trim();
        var beginTime = document.getElementById('beginTime').value.trim();
        var endTime = document.getElementById('endTime').value.trim();
        var cultivateType = document.getElementById('cultivateType').value.trim();
        if(cultivateName == ""){
            //打印后获取焦点
            swal({title: "错误提示",text: "培训名称不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.cultivateName.focus();},0);
            });
            return false;
        }
        if(beginTime == ""){
            swal({title: "错误提示",text: "培训开始时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else if(endTime == ""){
            swal({title: "错误提示",text: "培训结束时间不能为空",type: "error",confirmButtonText: "确  定"});
            return false;
        }else{
            //开始结束时间比较大小
            var oDate1 = new Date(beginTime);
            var oDate2 = new Date(endTime);
            if (oDate1.getTime() > oDate2.getTime()) {
                swal({title: "错误提示",text: "开始培训时间不能大于结束培训时间",type: "error",confirmButtonText: "确  定"});
                return false;
            }
        }
        if(cultivateType == ""){
            swal({title: "错误提示",text: "培训类型不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.cultivateType.focus();},0);
            });
            return false;
        }


        //表单序列化
        var cultivate = $('#formMessage').serialize();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/cultivate/addOrEdit.do?type="+type,
            data: cultivate,
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
                        setTimeout(function(){document.formMessage.cultivateName.focus();},0);
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