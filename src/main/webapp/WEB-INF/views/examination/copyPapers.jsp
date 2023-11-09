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
        <!-- sweetAlert -->
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/alert/sweetalert.css">
        <script type="text/javascript" src="${pageContext.request.contextPath}/alert/sweetalert-dev.js"></script>
        <title>${title}-试卷复制</title>
    </head>
    <body>
        <div style="background: #fafafa; color:#080808;height:100%;width:100%">
            <div style="border:1px solid #808080;margin-bottom:-1px;text-align:center;background-color: #428bca;color: #0E2D5F;">
                <label style="font-size: 23px;color: white">${title}-试卷复制</label>
            </div>
            <div style="border:1px solid #808080">
                <div style="padding:5px;">
                    <div style="margin-top: 4%;width:763px; height:709px">
                        <div style="margin-left: 2%;">
                            <label class="am-fl am-form-label" style="font-size:15px;margin-left: 2%;color: #00458a"><strong>说明 : 查询结果可能有部分是已有试卷的(红色标记),保存的话会覆盖掉以前的试卷信息.</strong></label>
                        </div>
                        <div style="margin-top: 12%;margin-left: 10%">
                            <label class="am-fl am-form-label" style="font-size:19px;">考试名称:  </label>
                            <input type="text" maxlength="20" id="inputName" style="width:70%" placeholder="请输入20个字以内..." onkeyup="queryByName(this);"/>
                        </div>
                        <div style="margin-top: 4%;margin-left: 18%;height:320px;">
                            <div style="margin:15px;width:540px;height:310px;border:1px solid #808080;overflow:auto;" id="content"></div>
                        </div>
                        <div style="text-align: center;margin-top: 11%">
                            <input type="button" onclick="save();" value="确     认" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type="button" onclick="window.close();" value="取     消" style="border-radius:9px;background-color:#0092DC;color: snow;width:100px;height:30px"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>


<script type="text/javascript">

    var loadWidth = 0;
    var loadHeight = 0;


    //初始化数据
    $(function(){
        loadWidth = window.innerWidth;
        loadHeight = window.innerHeight;

        <c:choose>
            <c:when test="${not empty testPaperExamination}">
            </c:when>
            <c:otherwise>
                swal({title: '错误提示',text: "该考试没有试题,不可进行复制,请先添加试题!",type: "error",confirmButtonText: "确  定"}, function(){window.close();});
            </c:otherwise>
        </c:choose>

        //初始化显示框
        queryByName("");
    });


    //根据培训名称模糊查询
    function queryByName(examinationName) {
        document.getElementById('content').innerHTML = "";
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/queryByName.do",
            data: {"examinationName":examinationName.value},
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                var div = document.getElementById('content');

                for(var i=0;i<data.rows.length;i++){
                    var t_examinationId = ${examinationId};
                    if(data.rows[i].id != t_examinationId){ //去除自己,不能复制给自己
                        var temp_div = document.createElement("div");
                        temp_div.setAttribute("style","margin-top: 2%;");

                        var temp_input = document.createElement("input");
                        temp_input.setAttribute("id",data.rows[i].id);
                        temp_input.setAttribute("type","checkbox");
                        temp_input.setAttribute("name","option");

                        var temp_label = document.createElement("label");
                        temp_label.setAttribute("class","am-fl am-form-label");
                        if(data.rows[i].examinationName.indexOf("(已有试卷)") != -1){
                            temp_label.setAttribute("style","font-size:17px;color:#b52b27;font-weight: 700;margin-left: 1%;");
                        }else{
                            temp_label.setAttribute("style","font-size:16px;margin-left: 1%;");
                        }
                        temp_label.innerText = "[序号:"+data.rows[i].id+"] "+data.rows[i].examinationName;

                        temp_div.appendChild(temp_input);
                        temp_div.appendChild(temp_label);
                        div.appendChild(temp_div);
                    }
                }
            },
            error: function(){
                swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };


    //保存
    function save() {
        var obj = document.getElementsByName("option");
        var arrs = [];//获取选中的id
        var type = "";
        var inputName = document.getElementById("inputName").value.trim();

        if(obj.length == 0){
            if(inputName == ""){
                swal({title: "错误提示",text: "请输入考试名称",type: "error",confirmButtonText: "确  定"});
                return false;
            }
            //没查询到属于新增
            type = "add" ;
        }else{
            for(var k in obj){
                if(obj[k].checked){
                    arrs.push(obj[k].id);
                }
            }
            if(arrs.length == 0){
                if(inputName == ""){
                    swal({title: "错误提示",text: "请输入考试名称",type: "error",confirmButtonText: "确  定"});
                    return false;
                }
                //检查是否有同名
                for(var k in obj){
                    if(inputName == obj[k].value){
                        swal({title: "错误提示",text: "请勾选同名的考试",type: "error",confirmButtonText: "确  定"});
                        return false;
                    }
                }
                type = "add" ;
            }else{
                type = "update" ;
            }
        }
        $.ajax({
            type: "post",
            url: "${pageContext.request.contextPath}/examination/saveCopyPapers.do?examinationId=${examinationId}&type="+type+"&inputName="+inputName,
            data: {"arrs":arrs},
            traditional:true,
            async:false,
            dataType:"json",
            success: function(data){
                if(data == 0){
                    // 1秒定时关闭弹窗
                    swal({title: "提示",text: "复制成功",showConfirmButton: false,type: "success", showCancelButton: false,timer:1000},function(){
                        window.close();
                    });
                }else{
                    swal({title: "错误提示",text: "复制失败",type: "error",confirmButtonText: "确  定"});
                }
            },
            error: function(){
                swal({title: "错误提示",text: "系统异常,请联系管理员",type: "error",confirmButtonText: "确  定"});
            }
        });
    };


    //浏览器窗口大小变化后，表格宽度自适应
    $(window).resize(function(){
        if(loadWidth > screen.width || loadHeight > screen.height){//打开的高宽比系统的高度大,screen是分辨率
            window.resizeTo(screen.width-20 , screen.height-70);
        }else{
            window.resizeTo(loadWidth , loadHeight+60);
        }
    });


</script>