<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <input id="contextPath" type="hidden" value="${pageContext.request.contextPath}"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css"/>
        <title>评估管理</title>
    </head>
    <body>
        <div id="tb" style="padding:3px">
            <form method="post" id="dataForm" name="dataForm">
                <span>培训名称:</span>
                <input id="cultivateName" name="cultivateName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>评估开始时间:</span>
                <input id="estimateBeginTime" name="estimateBeginTime" type="text" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>评估结束时间:</span>
                <input id="estimateEndTime" name="estimateEndTime" type="text" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <input type="hidden" id="estimateDataCode" name="estimateDataCode"/>
                <span>评估状态:</span>
                <select id="tmpDataCode" name="tmpDataCode" style="height:30px;width:130px;border:1px solid #ccc"/>
                    <option value="" selected="selected">全部</option>
                    <option value="0">未开始</option>
                    <option value="1">进行中</option>
                    <option value="2">已结束</option>
                </select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" value="新  增" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/estimate/editEstimate.do','newWindow',1100,685,'table')" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="delete" name="delete" value="删  除" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>
            </form>

            <br></br>
            <div style="text-align:right">
                <input type="button" id="queryStu" name="queryStu" value="查看评估学员" style="border-radius:9px;background-color:snow;color: #333333;width:100px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="estimateEdit" name="estimateEdit" value="评估设置" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="editQuestionnaire" name="editQuestionnaire" value="问卷编辑" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="estimateControl" name="estimateControl" value="评估监控" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="estimateResult" name="estimateResult" value="评估结果" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
            </div>
        </div>
        <table id="table" cellspacing="0" cellpadding="0"></table>
    </body>
</html>


<script type="text/javascript">


    //初始化加载数据
    $(function(){

        $("#table").datagrid({
            title:"评估管理",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/estimate/getEstimate.do',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:screen.height-460,//分辨率高度-XXX
            pageSize: 20,
            columns: [[
                {field:'chk',checkbox: true,width:60},
                {field:'id',title:'序号',width:80, sortable: true, halign:"center", align:"center"},
                {field:'estimateName',title:'评估名称',width:150, halign:"center", align:"center"},
                {field:'cultivateName',title:'培训名称',width:170, halign:"center", align:"center"},
                {field:'cultivateType',title:'培训类型',width:170, halign:"center", align:"center"},
                {field:'beginTime',title:'培训开始时间',width:170, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'endTime',title:'培训结束时间',width:170, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'estimateDataCode',title:'评估状态',width:130, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value == 0){
                            return "未开始";
                        }else if(value == 1){
                            return "进行中";
                        }else{
                            return "已结束";
                        }
                    }
                },
                {field:'estimateBeginTime',title:'评估开始时间',width:170, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'estimateEndTime',title:'评估结束时间',width:170, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'opt',title:'问卷',width: 450, halign:"center", align:"center",
                    formatter:function(value,rec){
                        var isPublishName = '';
                        if(rec.isPublish == 0){
                            isPublishName = '未发布';
                        }else if(rec.isPublish == 1){
                            isPublishName = '已发布';
                        }else{
                            isPublishName = '无问卷';
                        }
                        var btn = '<a class="details" onclick="estimateManage.queryQuestionnaire(\''+rec.id+'\',\''+rec.cultivateName+'\')" href="javascript:void(0)">详情及导出</a>';
                        btn = btn + '<a class="importQuestionnaire" onclick="estimateManage.importQuestionnaire(\''+rec.id+'\',\''+rec.cultivateName+'\')" href="javascript:void(0)">导入问卷</a>';
                        btn = btn + '<a class="publishEstimate" onclick="estimateManage.publishQuestionnaire(\''+rec.id+'\',\''+rec.cultivateName+'\',\''+rec.cultivateId+'\')" href="javascript:void(0)">发布问卷('+isPublishName+')</a>';
                        btn = btn + '<a class="copyEstimate" onclick="estimateManage.copyQuestionnaire(\''+rec.id+'\',\''+rec.cultivateName+'\')" href="javascript:void(0)">复制问卷</a>';
                        return btn;
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.details').linkbutton({text:'详情及导出',plain:true,iconCls:'icon-search'});
                $('.importQuestionnaire').linkbutton({text:'导入问卷',plain:true,iconCls:'icon-undo'});
                $('.publishEstimate').linkbutton({plain:true,iconCls:'icon-add'});
                $('.copyEstimate').linkbutton({text:'复制问卷',plain:true,iconCls:'icon-large-shapes'});
            }
        });

        getPager();

        //加载时间控件
        $('#estimateBeginTime').datebox({
            // required:true 非必须
            // editable:false //禁止输入
        });
        //加载时间控件
        $('#estimateEndTime').datebox({
            // required:true 非必须
            // editable:false //禁止输入
        });
    });


    //查询
    document.getElementById("search").addEventListener("click",function(){
        var dataSelect = document.getElementById("tmpDataCode");
        document.getElementById("estimateDataCode").value = dataSelect.options[dataSelect.selectedIndex].value;
        $('#table').datagrid('load',{
            cultivateName: $('#cultivateName').val(),
            estimateBeginTime: $('#estimateBeginTime').val(),
            estimateEndTime: $('#estimateEndTime').val(),
            estimateDataCode: $('#estimateDataCode').val()
        });
    },false);


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        document.getElementById("cultivateName").value = '';
        $('#estimateBeginTime').combo('setText','');//清空时间
        document.getElementById("estimateBeginTime").value = '';//清空时间内容
        $('#estimateEndTime').combo('setText','');//清空时间
        document.getElementById("estimateEndTime").value = '';//清空时间内容
        $("#tmpDataCode").val("");//选中下拉
        $('#table').datagrid('load',{});
    },false);



    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        var nowPageSize = $('#table').datagrid('getPager').data("pagination").options.pageSize;//现在的页数
        commonUtils.fitCoulms("table");
        getPager(nowPageSize);
    });


    //设置分页控件
    function getPager(nowPageSize){
        var p = $('#table').datagrid('getPager');
        $(p).pagination({
            pageSize: nowPageSize==null?20:nowPageSize,//每页显示的记录条数，20
            pageList: [10,20,30,40,50],//可以设置每页记录条数的列表,30,50,80,100
            beforePageText: '第',//页数文本框前显示的汉字
            afterPageText: '页    共 {pages} 页',
            displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录',
            onBeforeRefresh:function(){
                $(this).pagination('loading');
            }
        });
    };


    //查看评估学员
    document.getElementById("queryStu").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一条评估信息",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/estimate/toAddES.do?type=viewExisting&estimateId='+rows[0].id;
        commonUtils.openWindow(url,'newWindow',1100,685,'table');
    },false);


    //评估监控
    document.getElementById("estimateControl").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一条评估信息",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        if(rows[0].examinationDataCode == 0){
            swal({title: "提示",text: "该评估未开始,无法查看评估监控",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/estimate/toEstimateControl.do?estimateId='+rows[0].id + "&cultivateName=" + rows[0].cultivateName;
        commonUtils.openWindow(url,'newWindow',1200,627,'table');
    },false);


    //评估设置
    document.getElementById("estimateEdit").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一条评估信息",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/estimate/editEstimate.do?id=' + rows[0].id;
        commonUtils.openWindow(url,'newWindow',1100,685,'table');
    },false);



    //评估监控
    document.getElementById("editQuestionnaire").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一条评估信息",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/estimate/editQuestionnaire.do?estimateId=' + rows[0].id + "&cultivateName=" + rows[0].cultivateName;
        commonUtils.openWindow(url,'newWindow',1190,760,'table');
    },false);


    //评估结果
    document.getElementById("estimateResult").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一条评估信息",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/estimate/toShowResult.do?estimateId=' + rows[0].id + "&cultivateName=" + rows[0].cultivateName;
        commonUtils.openWindow(url,'newWindow',1200,760,'table');
    },false);



    //批量删除
    document.getElementById("delete").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择选择一个评估进行删除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要删除这"+rows.length+"个评估吗？",type: "warning",
                showCancelButton: true,// 是否显示取消按钮
                confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
                confirmButtonText: "确  定",// 确定按钮的 文字
                cancelButtonText: "取  消",// 取消按钮的 文字
                closeOnConfirm: false, //确认再提示
            },
            function(isConfirm){
                if (isConfirm) {
                    //获取选择的ID
                    var arr = new Array();
                    for(var i=0;i<rows.length;i++){
                        arr.push(rows[i].id);
                    }
                    $.ajax({
                        type: "post",
                        url: "${pageContext.request.contextPath}/estimate/deleteEstimates.do",
                        data: {"arr":arr},
                        traditional:true,
                        async:false,
                        dataType:"json",
                        success: function(data){
                            if(data == 0){
                                swal({title: "提示",text: "删除成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000});
                                $("#table").datagrid('reload');//刷新表单数据
                            }else{
                                swal({title: "错误提示",text: "删除失败",type: "error",confirmButtonText: "确  定"});
                            }
                        },
                        error: function(){
                            swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                        }
                    });
                } else {}
            });
    },false);


</script>