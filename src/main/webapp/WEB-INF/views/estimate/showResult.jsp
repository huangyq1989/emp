<%@ page import="java.net.URLEncoder" %>
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
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/echarts.js"></script>
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/fonts/font-awesome-4.7.0/css/font-awesome.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>评估结果</title>

        <!--一共3步  1.悬浮菜单css-->
        <style type="text/css">
            a:hover {
                text-decoration:none;
            }
            ul,li,p {
                margin:0; padding:0;
            }
            .iconfont{
                font-family:"iconfont" !important;
                font-size:16px;font-style:normal;
                -webkit-font-smoothing: antialiased;
                -webkit-text-stroke-width: 0.2px;
                -moz-osx-font-smoothing: grayscale;}
            .form-control {
                display: block;
                width: 100%;
                height: 32px;
                padding: 4px 12px;
                font-size: 14px;
                line-height: 1.42857143;
                color: #555;
                background-color: #fff;
                background-image: none;
                border: 1px solid #ccc;
                border-radius: 2px;
                -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
                -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
                -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
                transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            }
            .form-control:focus {
                border-color: #66afe9;
                outline: 0;
                -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, 0.6);
                box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075), 0 0 8px rgba(102, 175, 233, 0.6);
            }
            .cndns-right {
                position: fixed;
                right: 15px;
                top: 50%;
                margin-top: -150px;
                z-index: 100
            }

            .cndns-right-meau {
                position: relative;
            }

            .cndns-right-btn {
                width: 48px;
                height: 48px;
                border: 1px solid #ddd;
                text-align: center;
                display: block;
                margin-bottom: 6px;
                position: relative;
                background-color: #fff;
            }
            .cndns-right-btn:hover {
                text-decoration: none;
            }
            a.cndns-right-btn i {
                display: inline-block;
                margin-top: 5px;
                color: #999;
                font-size: 24px;
            }
            .cndns-right-btn p {
                text-decoration: none;
            }

            .cndns-right-btn span {
                color: #848484;
                font-size: 26px;
                line-height: 48px;
            }

            .cndns-right-btn p {
                color: #cf3529;
                font-size: 14px;
                line-height: 18px;
                padding-top: 5px;
                text-align: center;
                display: none;
            }

            .cndns-right-meau:hover .cndns-right-btn i {
                display: none
            }

            .cndns-right-meau:hover .cndns-right-btn p {
                display: block;
            }

            .meau-car .cndns-right-btn {
                border-color: #cf3529;
                margin-bottom: 20px;
            }

            .meau-car.cndns-right-meau:hover .cndns-right-btn {
                background-color: #cf3529;
            }

            .meau-car.cndns-right-meau:hover .cndns-right-btn span {
                color: #fff;
                display: block;
            }

            .meau-car .cndns-right-btn span {
                color: #cf3529;
            }

            .meau-sev .cndns-right-btn p {
                color: #fff
            }

            .meau-sev .cndns-right-btn span {
                color: #fff
            }

            .meau-top .cndns-right-btn em {
                display: block;
                font-style: normal;
                font-size: 12px;
                line-height: 12px;
                color: #999
            }
            .meau-top .cndns-right-btn i.icon {
                font-size: 16px;
                margin-top: 2px;
                display: inline-block;
            }

            .meau-top.cndns-right-meau:hover .cndns-right-btn {
                background-color: #cf3529;
            }

            .meau-top.cndns-right-meau:hover .cndns-right-btn i {
                display: block;
                color: #fff
            }

            .meau-top.cndns-right-meau:hover .cndns-right-btn em {
                color: #fff;
            }

            .cndns-right-box {
                position: absolute;
                top: -15px;
                right: 48px;
                padding-right: 25px;
                display: none;
            }

            .cndns-right-box .box-border {
                border: 1px solid #ccc;
                border-top: 4px solid #cf3529;
                padding: 20px;
                background-color: #fff;
                -webkit-box-shadow: 0 3px 8px rgba(0, 0, 0, .15);
                -moz-box-shadow: 0 3px 8px rgba(0, 0, 0, .15);
                box-shadow: 0 3px 8px rgba(0, 0, 0, .15);
                position: relative
            }

            .cndns-right-box .box-border .arrow-right {
                display: block;
                width: 13px;
                height: 16px;
                /*background: url(../images/arrow.png) no-repeat;*/
                position: absolute;
                right: -13px;
                top: 26px;
            }

            .cndns-right-box .box-border .sev-t i.icon {
                font-size: 42px;
                float: left;
                display: block;
                line-height: 56px;
                margin-right: 20px;
                color: #d3d3d3
            }

            .cndns-right-box .box-border .sev-t p {
                float: left;
                color: #cf3529;
                font-size: 20px;
                line-height: 28px;
            }

            .cndns-right-box .box-border .sev-t p i {
                display: block;
                font-size: 14px;
                color: #aaa;
                font-style: normal;
            }

            .cndns-right-box .box-border .sev-b {
                padding-top: 15px;
                margin-top: 15px;
                border-top: 1px solid #e4e4e4
            }

            .cndns-right-box .box-border .sev-b h4 {
                color: #666;
                font-size: 14px;
                font-weight: normal;
                padding-bottom: 15px;
            }
            .cndns-right-box .box-border .sev-b textarea {
                height: 100px;
            }
            .cndns-right-box .box-border .btnbox {
                height: 40px;
                margin-top: 10px;
                text-align: right;
            }


            .meau-sev .cndns-right-box .box-border {
                width: 430px;
            }

            .meau-contact .cndns-right-box .box-border {
                width: 250px;
            }
            .sev-t {
                width: 100%;
                overflow: hidden;
            }

            .cndns-right-meau:hover .cndns-right-box {
                display: block
            }

            .meau-code .cndns-right-box {
                top: inherit;
                bottom: -35px;
            }

            .meau-code .cndns-right-box .box-border {
                width: 156px;
                text-align: center;
                border-top: 1px solid #ccc;
            }

            .meau-code .cndns-right-box .box-border i {
                display: block;
                color: #f66e06;
                font-size: 12px;
                line-height: 26px;
                font-style: normal;
            }

            .meau-code .cndns-right-box .box-border .arrow-right {
                top: inherit;
                bottom: 50px;
            }

            .meau-sev .cndns-right-btn .demo-icon {
                display: none;
            }

            .meau-sev:hover .cndns-right-btn {
                background: #cf3529;
            }

            .meau-zs .cndns-right-btn {
                background-color: #cf3529;
                color: #fff;
                margin-top: 80px;
                border-color: #cf3529;
            }

            .meau-zs .cndns-right-btn span {
                color: #fff
            }

            .meau-zs .cndns-right-btn p {
                color: #fff
            }
        </style>

    </head>
    <body>
        <div style="background: #fafafa; color:#080808;border:1px solid #808080;" id="import_div">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-评估结果</label>
            </div>

            <div style="margin-top: 4%;margin-left: 6%;margin-right: 6%;margin-bottom: 4%;">
                <div class="radiu-box" id="detail_div"></div>
            </div>
        </div>

        <!--一共3步  2.悬浮菜单代码-->
        <div class="cndns-right">
            <div class="cndns-right-meau meau-sev">
                <a href="javascript:" class="cndns-right-btn" onclick="exportWord();">
                    <i class="fa fa-download" style="margin-top: 24%;"></i>
                    <p>原始<br>excel</p>
                </a>
            </div>
            <div class="cndns-right-meau meau-sev">
                <a href="javascript:" class="cndns-right-btn" onclick="exportWord2();">
                    <i class="fa fa-cloud-download" style="margin-top: 24%;"></i>
                    <p>统计<br>word</p>
                </a>
                <!--隐藏二级弹窗-->
                <%--<div class="cndns-right-box">--%>
                    <%--<div class="box-border">--%>
                        <%--<div class="sev-t">--%>
                            <%--<i class="icon iconfont icon-dianhua1"></i>--%>
                            <%--<p>400-920-9933--%>
                                <%--<br>--%>
                                <%--<i>7*24小时客服服务热线</i>--%>
                            <%--</p>--%>
                            <%--<div class="clear"></div>--%>
                        <%--</div>--%>
                        <%--<span class="arrow-right"></span>--%>
                    <%--</div>--%>
                <%--</div>--%>
            </div>
            <div class="cndns-right-meau meau-top" id="top-back" style="display: none;">
                <a href="javascript:" class="cndns-right-btn" onclick="topBack()">
                    <i class="fa fa-desktop"></i>
                    <em>顶部</em>
                </a>
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/estimate/exportEstimateResult.do?title=${title}" id="dataForm" name="dataForm">
            <input type="hidden" id="estimateId" name="estimateId" value="${estimateId}"/>
            <input type="hidden" id="estimateName" name="estimateName" value="${title}"/>
        </form>

        <form method="post" action="${pageContext.request.contextPath}/estimate/exportStatistics.do?title=${title}" id="dataForm2" name="dataForm">
            <input type="hidden" id="htmlText" name="htmlText" />
        </form>
    </body>
</html>




</html>

<script type="text/javascript">

    var jsonData = [];

    //初始化加载数据
    $(function(){
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/estimate/getShowResult.do?estimateId=${estimateId}",
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data.code == 0){
                    if(data.str == "" || data.str == undefined){
                        swal({title: '错误提示',text: "问卷不存在,无法查看评估结果",type: "error",icon: "success",button: "确定"},
                            function(){window.close();});
                        return false;
                    }
                    var result = $.parseJSON(data.str);
                    jsonData = result;
                    for(var i=0;i<result.length;i++){
                        var row = result[i];
                        var count = 0;//算总数的(单多)
                        var jz_count = [];//算总数的(矩阵)
                        var t_subjectType = "";
                        if(row.subjectType == 0){
                            t_subjectType = "【单选题】";
                            for(var s=0;s<row.countMessage[0].length;s++){
                                count = count + row.countMessage[0][s];
                            }
                        }else if(row.subjectType == 1){
                            t_subjectType = "【多选题】";
                            for(var s=0;s<row.countMessage[0].length;s++){
                                count = count + row.countMessage[0][s];
                            }
                        }else if(row.subjectType == 2){
                            t_subjectType = "【矩阵量表题】";
                            for(var p=0;p<row.opt.length;p++){
                                var t_count = 0;
                                for(var b=0;b<row.countMessage[p].length;b++){
                                    t_count = t_count + row.countMessage[p][b];
                                }
                                jz_count.push(t_count);
                            }
                        }else if(row.subjectType == 3){
                            t_subjectType = "【简答题】";
                        }

                        var message =
                            '<div id="'+(i+1)+'" style="margin-top: 2%;">\n' +
                                '<input type="hidden" id="" value=""></input>\n' +
                                '<label style="font-size: 20px;">'+(i+1)+'.'+row.title+'  '+t_subjectType+'</label>\n' ;
                                '<label style="font-size: 20px;">'+(i+1)+'.'+row.title+'  '+t_subjectType+'</label>\n' ;
                        if(row.subjectType == 0 || row.subjectType == 1){
                            var message = message +
                                '<table class="the-table" qi="10000" cellspacing="0" cellpadding="3" border="0" style="background-color:#e0e0e0;width:100%;border-collapse:collapse;">\n' +
                                    '<tr align="center" style="font-weight:bold;background: #e4e7eb;">\n' +
                                        '<td style="cursor: pointer;" class="arrge">选项 <i class="icon"></i></td>\n' +
                                        '<td id="sort-10000" align="center" class="arrge" style="width:50px;cursor: pointer;white-space:nowrap;">小计</td>\n' +
                                        '<td align="left" style="width:360px;">比例</td>\n' +
                                    '</tr>\n' ;
                            for(var m=0;m<row.op.length;m++){
                                var percentage = row.countMessage[0][m]==0?0:(row.countMessage[0][m]/count*100).toFixed(1);//百分比
                                var message = message +
                                    '<tr style="background: rgb(247, 250, 252);">\n' +
                                        '<td align="center" val="'+(m+1)+'">'+row.op[m]+'</td>\n' +
                                        '<td align="center">'+row.countMessage[0][m]+'</td>\n' +
                                        '<td percent="0">\n' +
                                            '<div style="margin-top:3px;float:left;">'+percentage+'%</div>\n' +
                                            '<div style="clear:both;"></div>\n' +
                                        '</td>\n' +
                                    '</tr>\n' ;
                            }
                            var message = message +
                                    '<tr style="background: #e4e7eb;" total="1">\n' +
                                        '<td align="center"><b>本题有效填写人次</b></td>\n' +
                                        '<td align="center"><b>'+row.validNum+'</b></td>\n' +
                                        '<td></td>\n' +
                                    '</tr>\n' +
                                '</table>\n' ;
                        }else if(row.subjectType == 2){
                            var message = message +
                                '<table class="the-table" qi="30000" cellspacing="0" cellpadding="3" border="0" style="background-color: rgb(224, 224, 224); width: 100%; border-collapse: collapse; display: table;">\n' +
                                    '<tr style="font-weight:bold;background: #e4e7eb;" align="center">\n' +
                                        '<td style="min-width:100px;">题目\选项</td>\n' ;
                            for(var p=0;p<row.op.length;p++){
                                var message = message +
                                        '<td>'+row.op[p]+'</td>\n' ;
                            }
                            var message = message +
                                    '</tr>\n' ;

                            for(var p=0;p<row.opt.length;p++){
                                var message = message +
                                    '<tr align="center" style="background:#f7fafc">\n' +
                                        '<td>'+row.opt[p]+'</td>\n' ;
                                for(var b=0;b<row.countMessage[p].length;b++){
                                    var percentage = row.countMessage[p][b]==0?0:(row.countMessage[p][b]/jz_count[p]*100).toFixed(1);//百分比
                                    var message = message +
                                        '<td>'+row.countMessage[p][b]+'('+percentage+'%)</td>\n' ;
                                }
                                var message = message +
                                    '</tr>\n' ;
                            }
                            var message = message +
                                '<tr style="background: #e4e7eb;" total="1">\n' +
                                    '<td align="center"><b>本题有效填写人次</b></td>\n' +
                                    '<td align="center"><b>'+row.validNum+'</b></td>\n' +
                                    '<td></td>\n'
                                '</tr>\n' +
                                '</table>\n' ;
                            var message = message +
                                '</table>\n' ;
                        }
                        var message = message +
                            '</div>\n' ;
                        if(row.subjectType != 3) {
                            var message = message +
                            '<div style="margin-top: 1%;margin-bottom: 1%;">\n' +
                                '<div style="margin-left: 70%;">\n' ;
                            if(row.subjectType != 2) {
                                var message = message +
                                    '<input type="button" name="btn_'+(i+1)+'" onclick="show(0,' + (i + 1) + ',this)" value="扇  形  图" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>\n' ;
                            }
                            var message = message +
                                    '<input type="button" name="btn_'+(i+1)+'" onclick="show(1,' + (i + 1) + ',this)" value="柱  状  图" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>\n' +
                                    '<input type="button" name="btn_'+(i+1)+'" onclick="show(2,' + (i + 1) + ',this)" value="条  形  图" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>\n' +
                                '</div>\n' +
                                '<div id="main_' + (i + 1) + '" style="height:400px;display: none"></div>\n' +
                            '</div>\n';
                        }
                        var message = message +
                        '<br><br><br><br>';
                        $("#detail_div").append(message);
                    }
                }else{
                    swal({title: '错误提示',text: data.message,type: "error",icon: "success",button: "确定"},
                        function(){window.close();});
                }
            },
            error: function(){
                swal({title: '错误提示',text: "加载异常,请联系管理员",type: "error",icon: "success",button: "确定"},
                    function(){window.close();});
            }
        });
    });


    function show(p_type,p_id,p_this){
        var main = document.getElementById('main_'+p_id);

        //修改正在点击的按钮颜色以及显示或隐藏图标div
        if(p_this.style.backgroundColor == "purple"){
            var btns = document.getElementsByName("btn_"+p_id);
            for(var h=0;h<btns.length;h++){
                btns[h].style.backgroundColor = "#0092DC";
            }
            main.style.display = "none";
            return false;
        }else{
            var btns = document.getElementsByName("btn_"+p_id);
            for(var h=0;h<btns.length;h++){
                btns[h].style.backgroundColor = "#0092DC";
            }
            p_this.style.backgroundColor = "purple";
            main.style.display = "";
        }

        var myChart = echarts.init(main);
        var option = null ;
        if(p_type == 0){
            // 基于准备好的dom，初始化echarts图表
            option = {
                title : {
                    x:'center'
                },
                tooltip : {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                legend: {
                    orient : 'vertical',
                    x : 'left',
                    // data:['选项1','选项2','选项3','选项4','选项5']
                    data:(function(){
                        var res = [];
                        for(var t=0;t<jsonData[p_id-1].op.length;t++){
                            res.push(jsonData[p_id-1].op[t]);
                        }
                        return res;
                    })()
                },
                toolbox: {
                    show : true,
                    feature : {
                        mark : {show: true},
                        magicType : {
                            show: true,
                            option: {
                                funnel: {
                                    x: '25%',
                                    width: '50%',
                                    funnelAlign: 'left',
                                    max: 1548
                                }
                            }
                        },
                        saveAsImage : {show: true}
                    }
                },
                calculable : true,
                series : [
                    {
                        name:'评估选择',
                        type:'pie',
                        radius : '55%',
                        center: ['50%', '60%'],
                        label: {
                            normal: {
                                show: true,
                                formatter: '{b}: {c}({d}%)'
                            }
                        },
                        // data:[
                        //     {name:'选项1',value:335 },{value:310, name:'选项2'},
                        //     {value:234, name:'选项3'},
                        //     {value:135, name:'选项4'},
                        //     {value:1548, name:'选项5'}
                        // ]
                        data:(function(){
                            var res = [];
                            for(var t=0;t<jsonData[p_id-1].op.length;t++){
                                res.push({
                                    name: jsonData[p_id-1].op[t],
                                    value: jsonData[p_id-1].countMessage[0][t]
                                });
                            }
                            return res;
                        })()
                    }
                ]
            };

        }else if(p_type == 1){

            option = {
                toolbox: {
                    show : true,
                    feature : {
                        mark : {show: true},
                        magicType : {
                            show: true,
                            option: {
                                funnel: {
                                    x: '25%',
                                    width: '50%',
                                    funnelAlign: 'left',
                                    max: 1548
                                }
                            }
                        },
                        saveAsImage : {show: true}
                    }
                },
                color: ['#3398DB'],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                        type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                    }
                },
                legend: {},
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: [
                    {
                        type: 'category',
                        // data: ['选项1', '选项2', '选项3', '选项4', '选项5', '选项6', '选项7'],
                        data:(function(){
                            var res = [];
                            var title = null;
                            if(jsonData[p_id-1].subjectType == 2){
                                title = jsonData[p_id-1].opt;
                            }else{
                                title = jsonData[p_id-1].op;
                            }
                            for(var t=0;t<title.length;t++){
                                res.push(title[t]);
                            }
                            return res;
                        })(),
                        axisTick: {
                            alignWithLabel: true
                        }
                    }
                ],
                yAxis: [
                    {
                        type: 'value'
                    }
                ],
                // series: [
                //     {
                //         name: '123213',
                //         type: 'bar',
                //         barWidth: '20%',
                //         data: [10, 52, 100, 334, 30, 330, 220]
                //     }, {
                //         name: '评估选择',
                //         type: 'bar',
                //         barWidth: '20%',
                //         data: [10, 52, 200, 334, 30, 330, 220]
                //     }
                // ],
                series:function(){
                    var serie = [];
                    if(jsonData[p_id-1].subjectType == 2){
                        for(var p=0;p<jsonData[p_id-1].op.length;p++){//循环选项
                            var dataItem = new Array();
                            for(var b=0;b<jsonData[p_id-1].countMessage.length;b++){//循环数据
                                dataItem.push(jsonData[p_id-1].countMessage[b][p]);
                            }
                            var item={
                                name:jsonData[p_id-1].op[p],
                                type:'bar',
                                data:dataItem
                            };
                            serie.push(item);
                        }
                    }else{
                        var dataItem = new Array();
                        for(var b=0;b<jsonData[p_id-1].countMessage[0].length;b++){//循环数据
                            dataItem.push(jsonData[p_id-1].countMessage[0][b]);
                        }
                        var item={
                            type:'bar',
                            data:dataItem
                        };
                        serie.push(item);
                    }
                    return serie;
                }(),
                label: {
                    show: true, //开启显示
                    position: 'top', //在上方显示
                }
            };

        }else if(p_type == 2){

            option = {
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    },
                },
                toolbox: {
                    show : true,
                    feature : {
                        mark : {show: true},
                        magicType : {
                            show: true,
                            option: {
                                funnel: {
                                    x: '25%',
                                    width: '50%',
                                    funnelAlign: 'left',
                                    max: 1548
                                }
                            }
                        },
                        saveAsImage : {show: true}
                    }
                },
                legend: {},
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'value',
                    boundaryGap: [0, 0.01]
                },
                yAxis: {
                    type: 'category',
                    // data: ['巴西', '印尼', '美国', '印度', '中国']
                    data:(function(){
                        var res = [];
                        var title = null;
                        if(jsonData[p_id-1].subjectType == 2){
                            title = jsonData[p_id-1].opt;
                        }else{
                            title = jsonData[p_id-1].op;
                        }
                        for(var t=0;t<title.length;t++){
                            res.push(title[t]);
                        }
                        return res;
                    })(),
                },
                // series: [
                //     {
                //         name: '2011年',
                //         type: 'bar',
                //         data: [18203, 23489, 29034, 104970, 131744]
                //     },
                //     {
                //         name: '2012年',
                //         type: 'bar',
                //         data: [19325, 23438, 31000, 121594, 134141]
                //     }
                // ]
                series:function(){
                    var serie = [];
                    if(jsonData[p_id-1].subjectType == 2){
                        for(var p=0;p<jsonData[p_id-1].op.length;p++){//循环选项
                            var dataItem = new Array();
                            for(var b=0;b<jsonData[p_id-1].countMessage.length;b++){//循环数据
                                dataItem.push(jsonData[p_id-1].countMessage[b][p]);
                            }
                            var item={
                                name:jsonData[p_id-1].op[p],
                                type:'bar',
                                data:dataItem
                            };
                            serie.push(item);
                        }
                    }else{
                        var dataItem = new Array();
                        for(var b=0;b<jsonData[p_id-1].countMessage[0].length;b++){//循环数据
                            dataItem.push(jsonData[p_id-1].countMessage[0][b]);
                        }
                        var item={
                            type:'bar',
                            data:dataItem
                        };
                        serie.push(item);
                    }
                    return serie;
                }(),
                label: {
                    show: true, //开启显示
                    position: 'right', //在上方显示
                }
            };

        }

        myChart.clear();
        myChart.setOption(option);
    };


    //导出统计word
    function exportWord2(){

        document.getElementById("htmlText").value = document.getElementById("import_div").innerHTML;
        // htmlText = htmlText + message;
        $("#dataForm2").submit();
    };


    //导出原始word
    function exportWord(){
        $("#dataForm").submit();
    };







    <!--一共3步  3.悬浮菜单css-->
    //置顶图标显示
    $('#top-back').hide();
    $(window).scroll(function () {
        if ($(this).scrollTop() > 350) {
            $("#top-back").fadeIn();
        }
        else {
            $("#top-back").fadeOut();
        }
    });
    //置顶事件
    function topBack() {
        $('body,html').animate({ scrollTop: 0 }, 300);
    }
    <!--一共3步  3.悬浮菜单css-->



</script>