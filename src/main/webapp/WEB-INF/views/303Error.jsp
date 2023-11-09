<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head style="background:#ffffff">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <link rel="icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
    <link rel="bookmark" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
    <title>权限不足</title>
    <link rel="stylesheet" type="text/css" href="css/base.css">
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body style="    background: #ffffff;height: 100%;width: 100%;">
    <div class="main_box">
        <div class="line_h"></div>
        <img style="margin:0 auto;width:342px;height:276px;display: block;"src="images/miwu.jpg" height="342" width="276" alt="#"/>
        <div class="nonetext_con">
            <p class="none_text">您可以<a href="javascript:history.go(-1);">返回</a>或者换其他账号<a href="redirectToLlogin.jsp">登录</a></p>

        </div>
    </div>


</body>
</html>