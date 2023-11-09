<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <input id="contextPath" type="hidden" value="${pageContext.request.contextPath}"/>
        <title>管理员账号</title>
    </head>
    <body>
        <div id="tb" style="padding:3px">
            <form method="post" action="${pageContext.request.contextPath}/employee/exportEmployee.do" id="dataForm" name="dataForm">
                <span>姓名:</span>
                <input id="realName" name="realName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>登录账号:</span>
                <input id="userName" name="userName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <span>手机号码:</span>
                <input id="phone" name="phone" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" value="新  增" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/employee/addEmployee.do','newWindow',1100,685,'table')" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="import" name="import" value="导  入" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="export" name="export" value="导  出" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>
            </form>

            <br></br>
            <div style="text-align:right">
                <input type="button" id="edit" name="edit" value="修  改" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="delete" name="delete" value="删  除" style="border-radius:9px;background-color:snow;color: #333333;width:70px;height:30px"/>&nbsp;&nbsp;&nbsp;
            </div>
        </div>
        <table id="table" cellspacing="0" cellpadding="0"></table>
    </body>
</html>


<script type="text/javascript">


    //初始化加载数据
    $(function(){

        $("#table").datagrid({
            title:"管理员账号",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/employee/getEmployees.do',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            height:screen.height-460,//分辨率高度-XXX
            fitColumns:true,//表格宽度自适应,自动换行
            pageSize: 20,
            columns: [[
                {field:'chk',checkbox: true,width:60},
                {field:'id',title:'账号ID',width:90, sortable: true, halign:"center", align:"center"},
                {field:'realName',title:'姓名',width:150, halign:"center", align:"center"},
                {field:'sex',title:'性别',width:60, halign:"center", align:"center",
                    formatter:function(value,rec){
                       if(value == 0){
                           return "男";
                       }else{
                           return "女";
                       }
                    }
                },
                {field:'userName',title:'账号',width:200, halign:"center", align:"center"},
                {field:'phone',title:'手机',width:110, halign:"center", align:"center",fixed:true},
                {field:'email',title:'电子邮箱',width:180, halign:"center", align:"center",fixed:true},
                {field:'updateTime',title:'修改时间',width:240, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'roleOpt',title:'操作',width: 330, halign:"center", align:"center",
                    formatter:function(value,rec){
                        var btn = '<a class="addER" onclick="employeeManage.toEditER(\''+rec.id+'\',\'add\')" href="javascript:void(0)">权限设置</a>';
                        return btn;
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.addER').linkbutton({text:'权限设置',plain:true,iconCls:'icon-user-edit'});
            }
        });

        getPager();
    });


    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            realName: $('#realName').val(),
            userName: $('#userName').val(),
            phone: $('#phone').val()
        });
    },false);


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        document.getElementById("realName").value = '';
        document.getElementById("userName").value = '';
        document.getElementById("phone").value = '';
        $('#table').datagrid('load',{});
    },false);


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        var nowPageSize = $('#table').datagrid('getPager').data("pagination").options.pageSize;
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


    //跳转到修改页面
    document.getElementById("edit").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0 || rows.length > 1){
            swal({title: "提示",text: "请选择一个账号进行修改",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        var url = '${pageContext.request.contextPath}/employee/addEmployee.do?id=' + rows[0].id;
        commonUtils.openWindow(url,'newWindow',1100,685,'table');
    },false);


    //批量删除
    document.getElementById("delete").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择一个账号进行删除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要删除这"+rows.length+"个账号吗？",type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
            closeOnConfirm: false, //确认再提示
            // closeOnCancel: false //关闭再提示
        },function(isConfirm){
            if (isConfirm) {
                //获取选择的ID
                var arr = new Array();
                for(var i=0;i<rows.length;i++){
                    arr.push(rows[i].id);
                }
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/employee/deleteEmployees.do",
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


    //跳到导入页面
    document.getElementById("import").addEventListener("click",function(){
        var url = '${pageContext.request.contextPath}/employee/importEmployee.do';
        commonUtils.openWindow(url,'newWindow',1100,685,'table');
    },false);


    //导出
    document.getElementById("export").addEventListener("click",function(){
        var rows = $("#table").datagrid("getRows"); //获取当前页的所有行
        if(rows == 0){
            swal({title: "提示",text: "没有查询到数据,无法导出",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要导出账号信息吗?",type: "warning",
            showCancelButton: true,// 是否显示取消按钮
            confirmButtonColor: "#DD6B55",// 确定按钮的 颜色
            confirmButtonText: "确  定",// 确定按钮的 文字
            cancelButtonText: "取  消",// 取消按钮的 文字
        },function(isConfirm){
            if (isConfirm) {
                var rows = commonUtils.getCheckRows('table');
                if(rows.length == 0){//条件查询导出
                    $("#dataForm").submit();
                }else{//勾选导出
                    var arr = new Array();
                    for(var i=0;i<rows.length;i++){
                        arr.push(rows[i].id);
                    }
                    //小数据量可以使用
                    window.location.href = "${pageContext.request.contextPath}/employee/exportEmployee.do?arr="+arr;
                }
            } else {}



        });
    },false);

</script>