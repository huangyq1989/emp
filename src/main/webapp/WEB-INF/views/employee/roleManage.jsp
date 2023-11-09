<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <input id="contextPath" type="hidden" value="${pageContext.request.contextPath}"/>
        <script type="text/javascript" src="${pageContext.request.contextPath}/scripts/common.js"></script>
        <title>权限种类设置</title>
    </head>
    <body>
        <div id="tb" style="padding:3px">
            <form method="post" id="dataForm" name="dataForm">
                <span>权限名称:</span>
                <input id="roleName" name="roleName" style="line-height:26px;border:1px solid #ccc"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="search" name="search" value="查  询" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="reset" name="reset" value="重  置" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" value="新  增" onclick="commonUtils.openWindow('${pageContext.request.contextPath}/roleMenu/editRoleMenu.do','newWindow',1100,710,'table')" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
                <input type="button" id="delete" name="delete" value="删  除" style="border-radius:9px;background-color:#0092DC;color: snow;width:90px;height:30px"/>&nbsp;&nbsp;&nbsp;
            </form>

            <br></br>
        </div>
        <table id="table" cellspacing="0" cellpadding="0"></table>
    </body>
</html>


<script type="text/javascript">


    //初始化加载数据
    $(function(){

        $("#table").datagrid({
            title:"权限种类设置",
            iconCls:'icon-more',//图标
            method:'post',
            url:'${pageContext.request.contextPath}/roleMenu/getRoles.do',
            border:true,
            nowrap:false,//允许换行
            pagination:true,//分页控件
            collapsible:false,//是否可折叠的
            fit:false,//自动大小
            fitColumns:true,//表格宽度自适应,自动换行
            height:screen.height-430,//分辨率高度-XXX
            pageSize: 20,
            columns: [[
                {field:'chk',checkbox: true,width:120},
                {field:'id',title:'编号',width:150, sortable: true, halign:"center", align:"center"},
                {field:'roleName',title:'权限名称',width:250, halign:"center", align:"center"},
                {field:'deleteFlag',title:'是否可删除',width:200, halign:"center", align:"center",
                    formatter:function(value,rec){
                       if(value == 0){
                           return "可删除";
                       }else{
                           return "不可删除";
                       }
                    }
                },
                {field:'insertTime',title:'新增时间',width:280, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'updateTime',title:'修改时间',width:280, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(value != "" && value != undefined){
                            return value.substr(0,value.length-2);
                        }
                    }
                },
                {field:'roleOpt',title:'操作',width: 330, halign:"center", align:"center",
                    formatter:function(value,rec){
                        if(rec.deleteFlag != 1){
                            var btn = '<a class="editMenu" onclick="roleManage.editMenu(\''+rec.id+'\')" href="javascript:void(0)">编辑权限</a>';
                        }
                        return btn;
                    }
                }
            ]],
            onLoadSuccess:function(data){
                $('.editMenu').linkbutton({text:'编辑权限',plain:true,iconCls:'icon-wrench-orange'});
            }
        });

        getPager();
    });


    //查询
    document.getElementById("search").addEventListener("click",function(){
        $('#table').datagrid('load',{
            roleName: $('#roleName').val()
        });
    },false);


    //重置
    document.getElementById("reset").addEventListener("click",function(){
        document.getElementById("roleName").value = '';
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

    //批量删除
    document.getElementById("delete").addEventListener("click",function(){
        var rows = commonUtils.getCheckRows('table');
        if(rows.length == 0){
            swal({title: "提示",text: "最少选择选择一个权限进行删除",type: "warning",confirmButtonText: "确  定"});
            return false;
        }
        swal({title: "提示",text: "确定要删除这"+rows.length+"个权限吗？",type: "warning",
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
                    if(rows[i].deleteFlag == 1){
                        swal({title: "错误提示",text: rows[i].roleName+"不能被删除,请重新选择",type: "error",confirmButtonText: "确  定"});
                        return false;
                    }else{
                        arr.push(rows[i].id);
                    }
                }
                $.ajax({
                    type: "post",
                    url: "${pageContext.request.contextPath}/roleMenu/deleteRoles.do",
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
                        swal({title: "错误提示",text: "删除异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
                    }
                });
            } else {}
        });
    },false);


</script>