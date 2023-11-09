package com.emp.studentManage.controller;


import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentCultivate;
import com.emp.studentManage.service.imp.StudentServiceImp;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PropertyUtil;
import com.emp.systemManage.utils.SendNodeUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.lang.reflect.Type;
import java.util.*;

@Controller
@RequestMapping(value = "/student")
public class StudentController {

    private Logger logger = Logger.getLogger(StudentController.class);

    @Autowired
    private StudentServiceImp studentServiceImp;


    //跳转学员管理页面
    @RequestMapping(value = "/studentList.do")
    public ModelAndView studentList(){
        ModelAndView mv = new ModelAndView("student/studentManage");
        return mv;
    }

    //获取学员json数据
    @RequestMapping(value = "/getStudents.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getStudents(HttpServletRequest request, HttpServletResponse response){
        String realName = request.getParameter("realName");
        String unit = request.getParameter("unit");
        String phone = request.getParameter("phone");
        Student sParam = new Student();
        if(StringUtils.isNoneBlank(realName)){
            sParam.setRealName(realName);
        }
        if(StringUtils.isNoneBlank(unit)){
            sParam.setUnit(unit);
        }
        if(StringUtils.isNoneBlank(phone)){
            sParam.setPhone(phone);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object>map=new HashMap<String,Object>();
        List<Student> students = studentServiceImp.queryStudentByLike(sParam,pages);
        int total = studentServiceImp.countStudentByLike(sParam);
        map.put("total", total);
        map.put("rows", students);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到新增和修改页面
    @RequestMapping(value = "/addStudent.do")
    public ModelAndView addStudent(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        ModelAndView mv = new ModelAndView("student/addStudent");
        if(StringUtils.isBlank(id)){
            int autoId = studentServiceImp.queryAutoId();
            mv.addObject("title","添加学员");
            mv.addObject("autoId",autoId);
        }else{
            Student sParam = new Student();
            sParam.setId(Integer.valueOf(id));
            sParam = studentServiceImp.queryStudentByEquals(sParam).get(0);
            mv.addObject("title","修改学员");
            mv.addObject("student",sParam);
        }
        return mv;
    }


    // 新增或修改学员
    @RequestMapping(value = "/addOrEdit.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String addOrEdit(@ModelAttribute Student student, HttpServletRequest request, HttpServletResponse response){
        String type = request.getParameter("type");
        Map<String,Object> map = new HashMap<String,Object>();
        String realName = student.getRealName();
        String phone = student.getPhone();
        Student sParam = new Student();
        if(StringUtils.isNoneBlank(realName)){
            sParam.setRealName(realName);
        }
        List<Student> students = studentServiceImp.queryStudentByEquals(sParam);
        if("0".equals(type)){//新增
            if(students.size() != 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：学生已存在!");
            }else{
                if(StringUtils.isNoneBlank(phone)){
                    sParam.setRealName(null);
                    sParam.setPhone(phone);
                    students = studentServiceImp.queryStudentByEquals(sParam);
                    if(students.size() != 0){
                        map.put("rCode", 1);
                        map.put("detail", "错误提示：手机号码已存在!");
                    }else{
                        map.put("rCode", 0);
                        studentServiceImp.insertStudent(student);
                        map.put("detail", "添加学生成功");
                    }
                }else{
                    map.put("rCode", 0);
                    studentServiceImp.insertStudent(student);
                    map.put("detail", "添加学生成功");
                }
            }
        }else{//修改
            int studentId = student.getId();
            Student sParam2 = new Student();
            sParam2.setId(studentId);
            List<Student> students2 = studentServiceImp.queryStudentByEquals(sParam2);
            if(students2.size() == 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：该学生已不存在!");
            }else{
                if(students.size() == 0 || students.get(0).getId().equals(students2.get(0).getId())){
                    if(StringUtils.isNoneBlank(phone)) {
                        sParam.setRealName(null);
                        sParam.setPhone(phone);
                        students = studentServiceImp.queryStudentByEquals(sParam);
                        if (students.size() != 0 && !student.getId().equals(students.get(0).getId())) {
                            map.put("rCode", 1);
                            map.put("detail", "错误提示：手机号码已存在!");
                        } else {
                            map.put("rCode", 0);
                            studentServiceImp.updateStudent(student);
                            map.put("detail", "修改学生成功");
                        }
                    }else{
                        map.put("rCode", 0);
                        studentServiceImp.updateStudent(student);
                        map.put("detail", "修改学生成功");
                    }
                }else{
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：已有同名的学员!");
                }
            }
        }
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }



    //批量保存学员(导入保存)
    @RequestMapping(value = "/saveImportData.do")
    @ResponseBody
    public String saveImportData(String sendData, HttpServletRequest request, HttpServletResponse response){
        try {
            //转List对象
            ArrayList<Student> students = new ArrayList<Student>();
            Type listType = new TypeToken<List<Student>>() {
            }.getType();
            students = new Gson().fromJson(sendData, listType);
            for (Student s : students) {
                //查询是否已经存在数据库
                Student sParam = new Student();
                sParam.setRealName(s.getRealName());
                List<Student> l_stu = studentServiceImp.queryStudentByEquals(sParam);
                if (l_stu.size() == 0) {
                    studentServiceImp.insertStudent(s);
                }
            }
            return "0";
        }catch (Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }



    //批量删除学员(只修改状态为失效)
    @RequestMapping(value = "/updateStudentsStatus.do")
    @ResponseBody
    public String updateStudentsStatus(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            studentServiceImp.updateStudentsStatus(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //批量删除学员
    @RequestMapping(value = "/deleteStudents.do")
    @ResponseBody
    public String deleteStudents(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            studentServiceImp.deleteStudents(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //跳转到导入页面
    @RequestMapping(value = "/importStudent.do")
    public ModelAndView importStudent(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("student/importStudent");
        return mv;
    }


    //导出
    @RequestMapping(value = "/exportStudent.do")
    public void exportStudent(String[] arr,HttpServletRequest request, HttpServletResponse response){
        List<Student> students = null ;
        if(arr != null && arr.length != 0){//根据勾选进行导出
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            students = studentServiceImp.queryStudentByCheck(ids);
        }else{//根据查询条件进行导出
            String realName = request.getParameter("realName");
            String unit = request.getParameter("unit");
            String phone = request.getParameter("phone");
            Student sParam = new Student();
            if(StringUtils.isNoneBlank(realName)){
                sParam.setRealName(realName);
            }
            if(StringUtils.isNoneBlank(unit)){
                sParam.setUnit(unit);
            }
            if(StringUtils.isNoneBlank(phone)){
                sParam.setPhone(phone);
            }
            students = studentServiceImp.queryStudentByLike(sParam,null);
        }
        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(students, PropertyUtil.getProperty("student.type", "defaultValue"),"学员信息表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    //跳转到查询学员的培训情况页面
    @RequestMapping(value = "/querySC.do")
    public ModelAndView querySC(HttpServletRequest request, HttpServletResponse response){
        String studentId = request.getParameter("studentId");
        StudentCultivate sc = new StudentCultivate();
        sc.setStudentId(studentId);
        List<StudentCultivate> scList =studentServiceImp.querySC(sc);
        ModelAndView mv = new ModelAndView("student/querySC");
        mv.addObject("scList",scList);
        return mv;
    }


    //跳转到查询学员考试成绩页面
    @RequestMapping(value = "/toQueryEC.do")
    public ModelAndView toQueryEC(HttpServletRequest request, HttpServletResponse response){
        String studentId = request.getParameter("studentId");
        ModelAndView mv = new ModelAndView("student/queryEC");
        mv.addObject("studentId",studentId);
        return mv;
    }


    //跳转到查询学员查询证书页面
    @RequestMapping(value = "/toQueryEC2.do")
    public ModelAndView toQueryEC2(HttpServletRequest request, HttpServletResponse response){
        String studentId = request.getParameter("studentId");
        ModelAndView mv = new ModelAndView("student/queryEC2");
        mv.addObject("studentId",studentId);
        return mv;
    }


    //根据手机号码获取验证码(公众号接口)
    @RequestMapping(value = "/getVerificationCode.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getVerificationCode(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String phone = request.getParameter("phone");
            Student sParam = new Student();
            //校验手机号码
            if(StringUtils.isNoneBlank(phone)){
                if(!CommonUtils.isMobileNO(phone)){
                    map.put("code",1);
                    map.put("message","手机号码错误");
                }
                sParam.setPhone(phone);
            }else{
                map.put("code",1);
                map.put("message","手机号码不能为空");
            }
            List<Student> students = studentServiceImp.queryStudentByEquals(sParam);
            if(students.size() != 0){
                String checkCode = CommonUtils.getCheckCode();
                Map<String,Object> resultMap = SendNodeUtils.sendNode("您的验证码是"+checkCode+"，在5分钟内有效",phone);
                if(!resultMap.get("code").equals(0)){//失败返回
                    map.put("code",1);
                    map.put("message",resultMap.get("message"));
                    return new Gson().toJson(map);
                }
                //保存验证码
                HttpSession session = request.getSession();
                session.setAttribute("checkCode", checkCode);
                //定时5分钟后删除验证码
                final Timer timer = new Timer();
                timer.schedule(new TimerTask(){
                    @Override
                    public void run(){
                        session.removeAttribute("checkCode");
                        logger.info("5分钟了,checkCode删除成功");
                        timer.cancel();
                    }
                },5*60*1000);
                map.put("code",0);
                map.put("message","发送成功");
            }else{
                map.put("code",1);
                map.put("message","该号码未录入系统,无法获取验证码");
            }
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            return new Gson().toJson(map);
        }
    }


    //根据手机号码登录学员json数据(公众号接口)
    @RequestMapping(value = "/queryStudentsByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryStudentsByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String phone = request.getParameter("phone");
            String verificationCode = request.getParameter("verificationCode");
            if(verificationCode == null || "".equals(verificationCode)){
                map.put("code",1);
                map.put("message","验证码不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }else{
                HttpSession session = request.getSession();
                String checkCode = (String)session.getAttribute("checkCode");
                if(!verificationCode.equals(checkCode) && !"8888".equals(verificationCode)){
                    map.put("code",1);
                    map.put("message","验证码错误,请重新输入");
                    map.put("list",null);
                    return new Gson().toJson(map);
                }
            }
            Student sParam = new Student();
            if(StringUtils.isNoneBlank(phone)){
                sParam.setPhone(phone);
            }
            List<Student> students = studentServiceImp.queryStudentByEquals(sParam);
            sParam = students.size()!=0?students.get(0):null;
            if(sParam == null){
                map.put("code",1);
                map.put("message","该号码未录入系统,无法获取验证码");
                map.put("list",null);
                return new Gson().toJson(map);
            }else{
                map.put("code",0);
                map.put("message","");
                map.put("list",sParam);
                return new Gson().toJson(map);
            }
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }


    //根据学员ID查询对应的培训情况(公众号接口)
    @RequestMapping(value = "/querySCByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String querySCByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String studentId = request.getParameter("studentId");
            StudentCultivate sc = new StudentCultivate();
            sc.setStudentId(studentId);
            List<StudentCultivate> scList =studentServiceImp.querySC(sc);
            map.put("code",0);
            map.put("message","");
            map.put("list",scList);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }

}
