<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">   <%-- 在IE运行最新的渲染模式 --%>
        <meta name="viewport" content="width=device-width, initial-scale=1">   <%-- 初始化移动浏览显示 --%>
        <link rel="icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <link rel="bookmark" href="${pageContext.request.contextPath}/images/my.ico" type="image/x-icon" />
        <!-- Bootstrap -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">    <!-- 修改自Bootstrap官方Demon，你可以按自己的喜好制定CSS样式 -->
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/jquery-1.12.3.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/bootstrap.min.js"></script>
        <!-- easyui -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/default/easyui.css" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/ui/themes/icon.css" type="text/css"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/ui/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>考试管理平台</title>
    </head>

    <body>
        <!-- 顶部菜单（来自bootstrap官方Demon）==================================== -->
        <nav class="navbar navbar-inverse navbar-fixed-top" style="background-color: #2e6da4">

            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" >
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>
            </div>

            <div id="navbar" class="navbar-collapse collapse">
                <!--圆角DIV-->
                <div style="float: left;margin-left: 1%;margin-top: 0.2%;background-color: #F5F5F5;border-radius:5px 5px 5px 5px;">
                    <a href="" style="text-decoration:none;">
                        <label style="font-size: 23px;width: 210px;color: #6C6C6C">
                            &nbsp;&nbsp;
                            <img height="38px" width="38px" src="${pageContext.request.contextPath}/images/login/avatar-02.jpg" alt="AVATAR">
                            &nbsp;&nbsp;&nbsp;&nbsp;管理平台
                        </label>
                    </a>
                </div>
                <div style="margin-right: 3%;">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="http://192.168.46.247:8081/login/loginToken.do?token=${token}">IDC平台</a></li>
                        <li><a href="###"><i class="fa fa-users"></i><font color="#98FB98">欢迎您：${employee.realName}</font></a></li>
                        <li><a href="${pageContext.request.contextPath}/login/quit.do" style="text-decoration:underline;"><font color="aqua">退出</font></a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- 左侧菜单选项========================================= -->
        <div class="container-fluid">
            <div class="row-fluie">
                <div class="col-sm-3 col-md-2 sidebar" id="accordion">
                    <%--<!-- 一级菜单 -->--%>
                    <%--<div class="nav nav-sidebar panel panel-default">--%>
                        <%--<li class="active">--%>
                            <%--<a href="#studentList" class="nav-header menu-first collapsed" data-toggle="collapse" data-parent="#accordion">学员管理</a>--%>
                        <%--</li>--%>
                        <%--<!-- 二级菜单(注意一级菜单中<a>标签内的href="#……"里面的内容要与二级菜单中<ul>标签内的id="……"里面的内容一致) -->--%>
                        <%--<ul id="studentList" class="nav nav-list collapse menu-second">--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/student/studentList.do','学员管理')">学员管理</a>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>

                    <%--<div class="nav nav-sidebar panel panel-default">--%>
                        <%--<li>--%>
                            <%--<a href="#cultivateList" class="nav-header menu-first collapsed" data-toggle="collapse" data-parent="#accordion">培训管理</a>--%>
                        <%--</li>--%>
                        <%--<ul id="cultivateList" class="nav nav-list collapse menu-second">--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/cultivate/cultivateList.do','培训管理')">培训管理</a>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>

                    <%--<div class="nav nav-sidebar panel panel-default">--%>
                        <%--<li>--%>
                            <%--<a href="#examinationList" class="nav-header menu-first collapsed" data-toggle="collapse" data-parent="#accordion">考试管理</a>--%>
                        <%--</li>--%>
                        <%--<ul id="examinationList" class="nav nav-list collapse menu-second">--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/examination/examinationList.do','考试管理')">考试管理</a>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>

                    <%--<div class="nav nav-sidebar panel panel-default">--%>
                        <%--<li>--%>
                            <%--<a href="#estimateList" class="nav-header menu-first collapsed" data-toggle="collapse" data-parent="#accordion">评估管理</a>--%>
                        <%--</li>--%>
                        <%--<ul id="estimateList" class="nav nav-list collapse menu-second">--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/estimate/estimateList.do','评估管理')">评估管理</a>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>

                    <%--<div class="nav nav-sidebar panel panel-default">--%>
                        <%--<li>--%>
                            <%--<a href="#employeeList" class="nav-header menu-first collapsed" data-toggle="collapse" data-parent="#accordion">账号管理</a>--%>
                        <%--</li>--%>
                        <%--<ul id="employeeList" class="nav nav-list collapse menu-second">--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/employee/employeeList.do','管理员账号')">管理员账号</a>--%>
                            <%--</li>--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/employee/treeEmployee.do','角色管理')">角色管理</a>--%>
                            <%--</li>--%>
                            <%--<li>--%>
                                <%--<a href="###" class="goToUrl" style="padding-left:50px;" onclick="showAtRight('${pageContext.request.contextPath}/student/studentList.do','修改个人信息')">修改个人信息</a>--%>
                            <%--</li>--%>
                        <%--</ul>--%>
                    <%--</div>--%>
                </div>
            </div>
        </div>

        <!-- 右侧内容展示==================================================   -->
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h1 class="page-header"><i class="fa fa-cog fa-spin"></i><small id="headTitle" name="headTitle"></small></h1>

            <!-- 载入左侧菜单指向的jsp（或html等）页面内容 -->
            <div id="content"><h4></h4></div>
        </div>
    </body>
</html>

<script type="text/javascript">

    $(document).ready(function () {
        var oUrl = "";
        var oText = "";
        var code = 0;
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/roleMenu/queryMenuByLogin.do",
            data: null,
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data) {
                if(data.code == 0){
                    swal({title: '错误提示',text: "该账号没有菜单权限,请联系管理员进行配置",type: "error",confirmButtonText: "确  定"},
                        function(){window.location.href = '${pageContext.request.contextPath}/login/index.do';});
                }else{
                    code = 1 ;
                    var div = document.getElementById("accordion");
                    for (var i = 0; i < data.menus.length; i++){

                        <!-- 一级菜单 -->
                        var p_div = document.createElement("div");
                        p_div.setAttribute("class","nav nav-sidebar panel panel-default");

                        var p_li = document.createElement("li");
                        if(i == 0) {
                            p_li.setAttribute("class", "active");
                        }

                        var p_ahref = document.createElement("a");
                        p_ahref.setAttribute("href","#"+i+"");
                        p_ahref.setAttribute("class","nav-header menu-first collapsed");
                        p_ahref.setAttribute("data-toggle","collapse");
                        p_ahref.setAttribute("data-parent","#accordion");
                        p_ahref.innerText = data.menus[i].text;

                        p_li.appendChild(p_ahref);


                        <!-- 二级菜单 -->
                        var c_ul = document.createElement("ul");
                        c_ul.setAttribute("id",i);
                        c_ul.setAttribute("class","nav nav-list collapse menu-second");

                        for (var j = 0; j < data.menus[i].children.length; j++){
                            var c_li = document.createElement("li");

                            var c_ahref = document.createElement("a");
                            var aText = data.menus[i].children[j].text;
                            var aUrl = data.menus[i].children[j].url;
                            c_ahref.setAttribute("href","###");
                            c_ahref.setAttribute("class","goToUrl");
                            c_ahref.setAttribute("id","href"+i+j);
                            c_ahref.setAttribute("style","padding-left:50px;");
                            c_ahref.setAttribute("onclick","showAtRight('${pageContext.request.contextPath}"+aUrl+"','"+aText+"')");
                            c_ahref.innerText = aText;

                            c_li.appendChild(c_ahref);
                            c_ul.appendChild(c_li);


                            if(i == 0 && j == 0) {//初始页面的地址和名称
                                oUrl = aUrl;
                                oText = aText;
                            }
                        }


                        <!-- 添加到主菜单 -->
                        p_div.appendChild(p_li);
                        p_div.appendChild(c_ul);
                        div.appendChild(p_div);
                    }
                }
            },
            error: function(){
                swal({title: '错误提示',text: "加载菜单异常,请联系管理员",type: "error",confirmButtonText: "确  定"},
                    function(){window.location.href = '${pageContext.request.contextPath}/login/index.do';});
            }
        });

        if(code == 1){//成功才加载下面的步骤
            easyuiUtils.lang_zh_CN();//加载easyui中文支持

            <!-- 加载初始页面到右边框 -->
            showAtRight("${pageContext.request.contextPath}"+oUrl ,oText);
            /*
             * 对选中的标签激活active状态，对先前处于active状态但之后未被选中的标签取消active
             * （实现左侧菜单中的标签点击后变色的效果）
             */
            $('div.nav > li').click(function (e) {
                //e.preventDefault();    加上这句则导航的<a>标签会失效
                $('div.nav > li').removeClass('active');
                $(this).addClass('active');
            });
        }
    });



    /*
     * 利用div实现左边点击右边显示的效果（以id="content"的div进行内容展示）
     * 注意：
     *   ①：js获取网页的地址，是根据当前网页来相对获取的，不会识别根目录；
     *   ②：如果右边加载的内容显示页里面有css，必须放在主页（即例中的index.jsp）才起作用
     *   （如果单纯的两个页面之间include，子页面的css和js在子页面是可以执行的。 主页面也可以调用子页面的js。但这时要考虑页面中js和渲染的先后顺序 ）
    */
    function showAtRight(url,tagName) {
        var div_a = $("#accordion .goToUrl");//获取id为accordion 下面所有class为goToUrl 的标签
        div_a.click(function(){
            div_a.css('color', '#337AAB');
            div_a.css('background-color', 'white');
            div_a.css('font-weight', 'normal');
            div_a.css('font-size', '14px');
            $(this).css('color', 'white');
            $(this).css('background-color', '#afd9ee');
            $(this).css('font-weight', 'bold');
            $(this).css('font-size', '17px');
        });



        document.getElementById('headTitle').innerText=tagName;
        var xmlHttp;

        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlHttp=new XMLHttpRequest();    //创建 XMLHttpRequest对象
        }
        else {
            // code for IE6, IE5
            xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
        }

        xmlHttp.onreadystatechange=function() {
            //onreadystatechange — 当readystate变化时调用后面的方法

            if (xmlHttp.readyState == 4) {
                //xmlHttp.readyState == 4    ——    finished downloading response

                if (xmlHttp.status == 200) {
                    //xmlHttp.status == 200        ——    服务器反馈正常
                    document.getElementById("content").innerHTML=xmlHttp.responseText;    //重设页面中id="content"的div里的内容
                    executeScript(xmlHttp.responseText);    //执行从服务器返回的页面内容里包含的JavaScript函数
                }else if (xmlHttp.status == 404){//错误状态处理
                    alert("出错了☹   （错误代码：404 Not Found），……！");
                    /* 对404的处理 */
                    return;
                }
                else if (xmlHttp.status == 403) {/* 对403的处理  */
                    alert("出错了☹   （错误代码：403 Forbidden），……");
                    return;
                }
                else {
                    alert("出错了☹   （错误代码：" + request.status + "），……");/* 对出现了其他错误代码所示错误的处理   */
                    return;
                }
            }

        }
        //把请求发送到服务器上的指定文件（url指向的文件）进行处理
        xmlHttp.open("GET", url, false);        //true表示异步处理
        xmlHttp.send();
    };



    /*
    * 解决ajax返回的页面中含有javascript的办法：
    * 把xmlHttp.responseText中的脚本都抽取出来，不管AJAX加载的HTML包含多少个脚本块，我们对找出来的脚本块都调用eval方法执行它即可
    */
    function executeScript(html){
        var reg = /<script[^>]*>([^\x00]+)$/i;
        //对整段HTML片段按<\/script>拆分
        var htmlBlock = html.split("<\/script>");
        for (var i in htmlBlock){
            var blocks;//匹配正则表达式的内容数组，blocks[1]就是真正的一段脚本内容，因为前面reg定义我们用了括号进行了捕获分组
            if (blocks = htmlBlock[i].match(reg)){
                //清除可能存在的注释标记，对于注释结尾-->可以忽略处理，eval一样能正常工作
                var code = blocks[1].replace(/<!--/, '');
                try{
                    eval(code) //执行脚本
                }catch (e){}
            }
        }
    }


</script>