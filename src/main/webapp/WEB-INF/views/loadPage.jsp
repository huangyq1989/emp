<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
    </head>
    <body>
        <!--进度条显示-1-->
        <div id="loadingDiv" style="display: none; ">
            <div id="over" style=" position: absolute;top: 0;left: 0; width: 100%;height: 100%; background-color: #f5f5f5;opacity:0.5;z-index: 1000;"></div>
            <div id="layout" style="position: absolute;top: 40%; left: 40%;width: 20%; height: 20%;  z-index: 1001;text-align:center;">
                <img src="${pageContext.request.contextPath}/images/loading-line.gif" />
            </div>
        </div>
    </body>
</html>


<script type="text/javascript">

    //加载进度条-2
    function loadShow(){
        document.getElementById("loadingDiv").style.display="block";
    };

    //关闭进度条-3
    function loadHide(){
        document.getElementById("loadingDiv").style.display="none";
    };


</script>