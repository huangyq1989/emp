<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="bookmark" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />

        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>${title}</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}</label>
            </div>
            <div style="border:1px solid #808080;height: 630px;">
                <div style="text-align: center; padding:15px;">
                    <form id="formMessage" name="formMessage" style="padding: 60px 80px 110px 20px;">
                        <table width="100%" border="0" width="600" height="190" border="0" cellpadding="0" cellspacing="0" style="border-collapse:separate; border-spacing:17px;">
                            <tr>
                                <td>学 号：</td>
                                <td align="left">
                                    <c:choose>
                                        <c:when test="${not empty student.id}">
                                            <input type="hidden" id="id" name="id" value="${student.id}"/>
                                            ${student.id}
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" id="id" name="id" value="${autoId}"/>
                                            ${autoId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td width="15%"><font color="red">*</font>姓 名：</td>
                                <td width="30%"><input type="text" id="realName" name="realName" maxlength="10" style="width:100%" value="${student.realName}"/></td>
                                <td width="10%"></td>
                                <td width="15%">性 别：</td>
                                <td width="30%">
                                    <input type="hidden" id="sex" name="sex" value="${student.sex}"/>
                                    <select id="tmpSex" name="tmpSex" style="width: 100%">
                                        <c:choose>
                                            <c:when test="${not empty student.sex}">
                                                <option value="0" <c:if test="${student.sex=='0'}"> selected="selected"</c:if> >男</option>
                                                <option value="1" <c:if test="${student.sex=='1'}"> selected="selected"</c:if> >女</option>
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
                                <td width="15%">单 位：</td>
                                <td width="30%"><input type="text" id="unit" name="unit" value="${student.unit}" maxlength="20" style="width:100%"/></td>
                                <td width="10%"></td>
                                <td width="15%">部 门：</td>
                                <td width="30%"><input type="text" id="department" name="department" value="${student.department}" maxlength="20" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%">职 位：</td>
                                <td width="30%"><input type="text" id="job" name="job" value="${student.job}" maxlength="10" style="width:100%"/></td>
                                <td width="10%"></td>
                                <td width="15%">电子邮箱：</td>
                                <td width="30%"><input type="text" id="email" name="email" value="${student.email}" maxlength="30" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td width="15%">身份证号码：</td>
                                <td width="30%"><input type="text" id="idCard" name="idCard" value="${student.idCard}" maxlength="18" style="width:100%"/></td>
                                <td width="10%"></td>
                                <td width="15%"><font color="red">*</font>手机号码：</td>
                                <td width="30%"><input type="number" id="phone" name="phone" value="${student.phone}" maxlength="11" style="width:100%"/></td>
                            </tr>
                            <tr>
                                <td colspan="1">备注</td>
                                <td colspan="3"><input type="text" id="remark" name="remark" value="${student.remark}" style="width:100%" placeholder="请限制在30个字以内" maxlength="30"/></td>
                            </tr>
                        </table>
                    </form>
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


    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;
    });


    //保存
    function addOrEdit() {
        var type = "0";
        //判断是新增还是修改
        <c:if test="${student.id != null}">
            type = "1" ;
        </c:if>

        var realName = document.getElementById("realName").value.trim();
        var email = document.getElementById('email').value.trim();
        var idCard = document.getElementById('idCard').value.trim();
        var phone = document.getElementById('phone').value.trim();
        var sexSelect = document.getElementById("tmpSex");
        document.formMessage.sex.value = sexSelect.options[sexSelect.selectedIndex].value;
        if(realName == ""){
            //打印后获取焦点
            swal({title: "错误提示",text: "姓名不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.realName.focus();},0);
            });
            return false;
        }
        if(!commonUtils.checkEmail(email) && email != ""){
            swal({title: "错误提示",text: "电子邮箱格式错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.email.focus();},0);
            });
            return false;
        }
        if(!commonUtils.checkIdCard(idCard) && idCard != ""){
            swal({title: "错误提示",text: "身份证号码错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.idCard.focus();},0);
            });
            return false;
        }
        if(phone == ""){
            swal({title: "错误提示",text: "手机号码不能为空",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.phone.focus();},0);
            });
            return false;
        }else if(!commonUtils.checkPhone(phone)){
            swal({title: "错误提示",text: "手机号码错误,请重新输入",type: "error",confirmButtonText: "确  定"},function(){
                setTimeout(function(){document.formMessage.phone.focus();},0);
            });
            return false;
        }

        //表单序列化
        var student = $('#formMessage').serialize();
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/student/addOrEdit.do?type="+type,
            data: student,
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
                        setTimeout(function(){document.formMessage.realName.focus();},0);
                    });
                }
            },
            error: function(){
                swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    }


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });

</script>