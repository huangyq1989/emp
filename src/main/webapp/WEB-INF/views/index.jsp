<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
    <head>
        <title>考试管理平台</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="apple-mobile-web-app-capable" content="yes"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="bookmark" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <input id="contextPath" type="hidden" value="${pageContext.request.contextPath}"/>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/fonts/font-awesome-4.7.0/css/font-awesome.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login/util.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login/main.css">
        <script src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/login/main.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/common.js"></script>
    </head>

    <body>
        <div class="dowebok limiter">
            <div class="container-login100" style="background-image: url('${pageContext.request.contextPath}/images/login/img-01.jpg');">
                <div class="wrap-login100 p-t-190 p-b-30">
                    <form class="login100-form validate-form" id="loginForm" name="loginForm">
                        <div class="login100-form-avatar">
                            <img src="${pageContext.request.contextPath}/images/login/avatar-02.jpg" alt="AVATAR">
                        </div>

                        <span class="login100-form-title p-t-20 p-b-45">考试管理平台</span>
                        <div class="wrap-input100 validate-input m-b-10" data-validate="请输入用户名">
                            <input class="input100" type="text" name="userName" id="userName" value="" maxlength="20" placeholder="用户名" autocomplete="off">
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-user"></i>
                            </span>
                        </div>

                        <div class="wrap-input100 validate-input m-b-10" data-validate="请输入密码">
                            <input class="input100" type="password" name="password" id="password" value="" maxlength="20" placeholder="密码">
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-lock"></i>
                            </span>
                        </div>
                    </form>

                    <font color="red" id="alertMessage"></font>
                    <div class="container-login100-form-btn p-t-10">
                        <button class="login100-form-btn" id="saveId" name="saveId" onclick="commonUtils.checkInsertForm();">登 录</button>
                    </div>

                    <div class="text-center w-full p-t-25 p-b-230">
                        <%--<a href="###" class="txt1" target="_blank">忘记密码？</a>--%>
                    </div>

                    <div class="text-center w-full">
                        <%--<a class="txt1" href="###" target="_blank">--%>
                            <%--立即注册--%>
                            <%--<i class="fa fa-long-arrow-right"></i>--%>
                        <%--</a>--%>
                        <label style="color: #e7e7e7">请使用 火狐浏览器 或 谷歌浏览器 进行访问</label>
                    </div>

                </div>
            </div>
        </div>
    </body>
</html>

<script type="text/javascript">
    $(document).keydown(function (event) {
        if (event.keyCode == 13) {
            commonUtils.checkInsertForm();
        }
    });
</script>