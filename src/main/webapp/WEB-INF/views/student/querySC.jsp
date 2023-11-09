<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <title>学员培训情况</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">学员培训情况</label>
            </div>
            <div style="border:1px solid #808080;margin-top: 3%;">
                <div style="text-align: center; padding:15px;height: 400px;overflow:auto;">
                    <form id="formMessage" name="formMessage" style="padding: 0px 20px 20px 20px;">
                        <table width="100%" width="700" height="50" border="1" bordercolor="#000000" style="border-collapse:collapse" id="resultTable">
                            <c:choose>
                                <c:when test="${fn:length(scList) != 0}">
                                    <tr bgcolor="#b0e0e6">
                                        <td>序号</td>
                                        <td>学号</td>
                                        <td>姓名</td>
                                        <td>培训名称</td>
                                        <td>培训类型</td>
                                        <td>培训状态</td>
                                        <td>培训开始时间</td>
                                        <td>培训结束时间</td>
                                    </tr>
                                    <c:forEach items="${scList}" var="sc" varStatus="id">
                                        <tr>
                                            <td>${id.index + 1}</td>
                                            <td>${sc.studentId}</td>
                                            <td>${sc.realName}</td>
                                            <td>${sc.cultivateName}</td>
                                            <td>${sc.cultivateType}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sc.cultivateDataCode == 0}">
                                                        未开始
                                                    </c:when>
                                                    <c:when test="${sc.cultivateDataCode == 1}">
                                                        进行中
                                                    </c:when>
                                                    <c:otherwise>
                                                        已结束
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                ${fn:substring(sc.beginTime, 0, fn:length(sc.beginTime)-2)}
                                            </td>
                                            <td>
                                                ${fn:substring(sc.endTime, 0, fn:length(sc.endTime)-2)}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr align="center">未查询到培训数据</tr>
                                </c:otherwise>
                            </c:choose>
                        </table>
                    </form>
                </div>
                <div style="text-align: center;padding: 80px 0px 30px 0px;">
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


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });

</script>