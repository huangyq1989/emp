package com.emp.examinationManage.controller;

import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.service.imp.CultivateServiceImp;
import com.emp.examinationManage.entity.Examination;
import com.emp.examinationManage.entity.ExaminationStudent;
import com.emp.examinationManage.entity.TestPaper;
import com.emp.examinationManage.entity.TestPaperExamination;
import com.emp.examinationManage.service.imp.ExaminationServiceImp;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentExamination;
import com.emp.systemManage.controller.ParentController;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.*;
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
import java.io.IOException;
import java.text.*;
import java.util.*;


@Controller
@RequestMapping(value = "/examination")
public class ExaminationController extends ParentController {

    private Logger logger = Logger.getLogger(ExaminationController.class);

    @Autowired
    private ExaminationServiceImp examinationServiceImp ;

    @Autowired
    private CultivateServiceImp cultivateServiceImp;


    //跳转考试管理页面
    @RequestMapping(value = "/examinationList.do")
    public ModelAndView studentList(){
        ModelAndView mv = new ModelAndView("examination/examinationManage");
        return mv;
    }

    //获取考试json数据
    @RequestMapping(value = "/getExaminations.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getExaminations(HttpServletRequest request, HttpServletResponse response){
        String cultivateName = request.getParameter("cultivateName");
        String examinationTime = request.getParameter("examinationTime");
        String examinationDataCode = request.getParameter("examinationDataCode");
        Examination sParam = new Examination();
        if(StringUtils.isNoneBlank(cultivateName)){
            sParam.setCultivateName(cultivateName);
        }
        if(StringUtils.isNoneBlank(examinationTime)){
            sParam.setExaminationTime(examinationTime);
        }
        if(StringUtils.isNoneBlank(examinationDataCode)){
            sParam.setExaminationDataCode(Integer.valueOf(examinationDataCode));
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map=new HashMap<String,Object>();
        List<Examination> examinations = examinationServiceImp.queryExaminationByLike(sParam,pages);
        int total = examinationServiceImp.countExaminationByLike(sParam);
        map.put("total", total);
        map.put("rows", examinations);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到新增页面
    @RequestMapping(value = "/editExamination.do")
    public ModelAndView editExamination(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        ModelAndView mv = new ModelAndView("examination/editExamination");
        List<Cultivate> cultivateList = cultivateServiceImp.queryCultivateByLike(null,null);
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("total", cultivateList.size());
        map.put("rows", cultivateList);
        String jsonStr = new Gson().toJson(map);
        mv.addObject("cultivateList",jsonStr);
        if(StringUtils.isBlank(id)){
            mv.addObject("title","新增考试");
        }else{
            mv.addObject("title","考试设置");
            Examination sParam = new Examination();
            sParam.setId(Integer.valueOf(id));
            Examination examination  = examinationServiceImp.queryExaminationByEquals(sParam,null).get(0);
            mv.addObject("examination",examination);
        }
        return mv;
    }


    // 保存考试并添加培训学员到考试中间表      (考试,考试人员,或许还有试卷)
    @RequestMapping(value = "/save.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String save(@ModelAttribute Examination examination, HttpServletRequest request, HttpServletResponse response){
        String jsonStr = null;
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            //计算考试状态
            String overDate = "";
            if(!StringUtils.isBlank(examination.getExaminationEndTime())){//结束时间
                overDate = examination.getExaminationEndTime();
            }else{
                overDate = CommonUtils.TimeAdd(examination.getExaminationTime(),examination.getExaminationTimeLimit());
            }

            boolean timeFlag = CommonUtils.isgtNow(overDate,"yyyy-MM-dd HH:mm:ss");
            if(timeFlag){
                timeFlag = CommonUtils.isgtNow(examination.getExaminationTime(),"yyyy-MM-dd HH:mm:ss");
                if(timeFlag){
                    examination.setExaminationDataCode(0);//开始时间比当前时间大为未开始
                }else{
                    examination.setExaminationDataCode(1);//开始时间比当前时间大为进行中
                }
            }else{
                examination.setExaminationDataCode(2);//结束时间小于当前时间为已结束
            }

            if(null == examination.getId()){//新增
                String totalScore = request.getParameter("totalScore");
                map = examinationServiceImp.insertExaminationAll(examination,totalScore);
            }else{//修改
                Examination t_eParam = new Examination();
                t_eParam.setId(examination.getId());
                List<Examination> examination2 = examinationServiceImp.queryExaminationByEquals(t_eParam,null);
                if(examination2.size() == 0){
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：该考试已不存在!");
                }else{
                    Examination eParam = new Examination();
                    if(StringUtils.isNoneBlank(examination.getExaminationName())){
                        eParam.setExaminationName(examination.getExaminationName());
                    }
                    List<Examination> examination1 = examinationServiceImp.queryExaminationByEquals(eParam,null);
                    if(examination1.size() == 0 || examination1.get(0).getId().equals(examination2.get(0).getId())){
                        boolean changeFlag = false;
                        if(!examination2.get(0).getCultivateId().equals(examination.getCultivateId())){//培训改变
                            changeFlag = true;
                        }
                        String totalScore = request.getParameter("totalScore");
                        examinationServiceImp.updateExamination(examination,changeFlag,totalScore);
                        map.put("rCode", 0);
                        map.put("detail", "修改考试设置成功");
                    }else{
                        map.put("rCode", 1);
                        map.put("detail", "错误提示：已有同名的考试!");
                    }
                }
            }
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            map.put("rCode", 2);
            map.put("detail", e.getLocalizedMessage());
        }
        jsonStr = new Gson().toJson(map);
        return jsonStr;
    }



//
//    //批量添加学员到考试中间表
//    @RequestMapping(value = "/addES.do")
//    @ResponseBody
//    public String addES(String[] arr,HttpServletRequest request){
//        try{
//            String examinationId = request.getParameter("examinationId");
//            int[] ids = CommonUtils.stringArrayToIntArray(arr);
//            examinationServiceImp.addES(ids,examinationId);
//            return "0";
//        }catch(Exception e){
//            logger.error(e.getLocalizedMessage());
//            return "1";
//        }
//    }


    //导出
    @RequestMapping(value = "/exportExamination.do")
    public void exportExamination(String[] arr,HttpServletRequest request, HttpServletResponse response){
        List<Examination> examinations = null ;
        if(arr != null && arr.length != 0){//根据勾选进行导出
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            examinations = examinationServiceImp.queryExaminationByCheck(ids);
        }else{//根据查询条件进行导出
            String cultivateName = request.getParameter("cultivateName");
            String examinationTime = request.getParameter("examinationTime");
            String examinationDataCode = request.getParameter("examinationDataCode");
            Examination sParam = new Examination();
            if(StringUtils.isNoneBlank(cultivateName)){
                sParam.setCultivateName(cultivateName);
            }
            if(StringUtils.isNoneBlank(examinationTime)){
                sParam.setExaminationTime(examinationTime);
            }
            if(StringUtils.isNoneBlank(examinationDataCode)){
                sParam.setExaminationDataCode(Integer.valueOf(examinationDataCode));
            }
            examinations = examinationServiceImp.queryExaminationByLike(sParam,null);
        }
        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(examinations, PropertyUtil.getProperty("examination.type", "defaultValue"),"考试信息表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }



    //跳转到新增学员到考试中间表页面
    @RequestMapping(value = "/toAddES.do")
    public ModelAndView toAddES(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("examination/addES");
        mv.addObject("type",request.getParameter("type"));
        mv.addObject("examinationId",request.getParameter("examinationId"));
        return mv;
    }

    //获取学员json数据
    @RequestMapping(value = "/getESList.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getESList(HttpServletRequest request, HttpServletResponse response){
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
        String examinationId = request.getParameter("examinationId");
        String type = request.getParameter("type");
        List<Student> students = examinationServiceImp.queryESByLike(sParam,examinationId,pages,type);
        int total = examinationServiceImp.countESByLike(sParam,examinationId,type);
        map.put("total", total);
        map.put("rows", students);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到试卷编辑页面
    @RequestMapping(value = "/editTestPaper.do")
    public ModelAndView editTestPaper(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        ModelAndView mv = new ModelAndView("examination/editTestPaper");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("examinationId",examinationId);

        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
        if(null != te){
            mv.addObject("testPaperExamination",te);
        }
        return mv;
    }


    //查看试卷
    @RequestMapping(value = "/showTestPaper.do")
    public ModelAndView showTestPaper(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        ModelAndView mv = new ModelAndView("examination/showTestPaper");
        mv.addObject("title",request.getParameter("cultivateName"));

        //查询及格分
        Examination sParam = new Examination();
        sParam.setId(Integer.valueOf(examinationId));
        List<Examination> examinations = examinationServiceImp.queryExaminationByEquals(sParam,null);
        mv.addObject("passingScoreLine",examinations.get(0).getPassingScoreLine());

        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
        if(null != te){
            mv.addObject("testPaperExamination",te);
        }
        return mv;
    }


    //保存试卷
    @RequestMapping(value = "/saveTestPaper.do")
    @ResponseBody
    public String saveTestPaper(String jsonData,HttpServletRequest request){
        try{
            String examinationId = request.getParameter("examinationId");
            String id = request.getParameter("id");
            String totalScore = request.getParameter("totalScore");
            TestPaperExamination te = new TestPaperExamination();
            if(StringUtils.isBlank(id)){//新增
                te.setContent(jsonData);
                te.setExaminationId(Integer.valueOf(examinationId));
                te.setTotalScore(Float.parseFloat(totalScore));
                examinationServiceImp.insertTestPaper(te);
            }else{//修改
                te.setId(Integer.valueOf(id));
                te.setContent(jsonData);
                te.setIsPublish(0);//修改后要重新发布
                te.setExaminationId(Integer.valueOf(examinationId));
                te.setTotalScore(Float.parseFloat(totalScore));
                //保存修改后的信息 和 重置学员的答卷信息和试卷信息
                examinationServiceImp.updateTestPaperBySave(te);
            }
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //导出试卷word
    @RequestMapping(value = "/exportTestPaper.do")
    public void exportTestPaper(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        String fileName = request.getParameter("title")+ "培训课考试卷";
        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);

        //查询及格分
        Examination sParam = new Examination();
        sParam.setId(Integer.valueOf(examinationId));
        List<Examination> examinations = examinationServiceImp.queryExaminationByEquals(sParam,null);
        String passingScoreLine = examinations.get(0).getPassingScoreLine()+"";
        try{
            String filePath = new PoiToWordUtils().writeWord(te, PropertyUtil.getProperty("testPaper.type", "defaultValue"),fileName,passingScoreLine);
            CommonUtils.outputToResponse(filePath,"docx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    //去导入试卷页面
    @RequestMapping(value = "/importTestPaper.do")
    public ModelAndView importTestPaper(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        ModelAndView mv = new ModelAndView("examination/importTestPaper");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("examinationId",request.getParameter("examinationId"));
        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
        if(null != te){
            mv.addObject("testPaperExamination",te);
        }
        return mv;
    }


    //去发布试卷页面
    @RequestMapping(value = "/publishPapers.do")
    public ModelAndView publishPapers(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        ModelAndView mv = new ModelAndView("examination/publishPapers");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("examinationId",examinationId);
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
        if(null != te){
            mv.addObject("testPaperExamination",te);
            examinationServiceImp.updateTPByPublish(te.getExaminationId().toString());//修改为已发布
        }
        return mv;
    }


    //获取试卷二维码或下载二维码
    @RequestMapping(value = "/getTpQRCode.do")
    public void getTpQRCode(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        String cultivateId = request.getParameter("cultivateId");
        //   http://localhost:8081/emp/dist/index.html#/exam?id=16&examid=31
        String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()
                + "/dist/index.html#/exam?id=" + cultivateId + "&examid=" + examinationId;
        String type = request.getParameter("type");
        String name = request.getParameter("name");
        this.getQRCode(request,response,url,type,name);
    }


    //去复制试卷页面
    @RequestMapping(value = "/toCopyPapers.do")
    public ModelAndView toCopyPapers(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        ModelAndView mv = new ModelAndView("examination/copyPapers");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("examinationId",examinationId);
        TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
        if(null != te){
            mv.addObject("testPaperExamination",te);
        }
        return mv;
    }


    //获取考试json数据BY-页面复制
    @RequestMapping(value = "/queryByName.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryByName(HttpServletRequest request, HttpServletResponse response){
        String examinationName = request.getParameter("examinationName");
        Examination sParam = new Examination();
        if(StringUtils.isNoneBlank(examinationName)){
            sParam.setExaminationName(examinationName);
        }
        Map<String,Object> map=new HashMap<String,Object>();
        List<Examination> examinations = examinationServiceImp.queryExaminationByLike(sParam,null);
        for(Examination examination:examinations){
            TestPaperExamination te = examinationServiceImp.queryTestPaper(examination.getId().toString());
            if(null != te){
                examination.setExaminationName(examination.getExaminationName()+"  (已有试卷)");
            }
        }
        map.put("rows", examinations);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //复制试卷
    @RequestMapping(value = "/saveCopyPapers.do")
    @ResponseBody
    public String saveCopyPapers(String[] arrs,HttpServletRequest request){
        try{
            String type = request.getParameter("type");
            String examinationId = request.getParameter("examinationId");

            if("add".equalsIgnoreCase(type)){//是否新增一个评估
                String inputName = request.getParameter("inputName");
                Map<String, String> param = new HashMap<>();
                param.put("t_examinationId", examinationId);
                param.put("t_inputName", inputName);
                //执行存储过程
                examinationServiceImp.addExaminationByCopy(param);
                return param.get("t_result") ;
            }else {
                //复制的试卷
                TestPaperExamination te = examinationServiceImp.queryTestPaper(examinationId);
                //需要被修改的试卷
                for (int i = 0; i < arrs.length; i++) {
                    TestPaperExamination te1 = examinationServiceImp.queryTestPaper(arrs[i]);
                    if (null != te1) {//修改
                        te1.setContent(te.getContent());
                        examinationServiceImp.updateTestPaper(te1);
                    } else {//新增
                        TestPaperExamination tp = new TestPaperExamination();
                        tp.setContent(te.getContent());
                        tp.setExaminationId(Integer.valueOf(arrs[i]));
                        tp.setTotalScore(te.getTotalScore());
                        examinationServiceImp.insertTestPaper(tp);
                    }
                }
                return "0";
            }
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //跳转到考试监控页面
    @RequestMapping(value = "/toExaminationControl.do")
    public ModelAndView toExaminationControl(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("examination/examinationControl");
        mv.addObject("examinationId",request.getParameter("examinationId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        mv.addObject("timingMode",request.getParameter("timingMode"));
        mv.addObject("examinationDataCode",request.getParameter("examinationDataCode"));
        return mv;
    }


    //获取参加考试的学员json数据
    @RequestMapping(value = "/getECList.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getECList(HttpServletRequest request, HttpServletResponse response){
        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);
        Map<String,Object> map = new HashMap<String,Object>();
        String examinationId = request.getParameter("examinationId");
        StudentExamination ec = new StudentExamination();
        ec.setExaminationId(examinationId);
        List<StudentExamination> students = examinationServiceImp.queryEC(ec,pages);
        for(StudentExamination stu:students){
            if("1".equals(stu.getExaminationCode()) && null != stu.getOpenTime()){//考试中
                long startTime = 0;
                try {
                    startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(stu.getOpenTime()).getTime();
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                long stopTime= new Date().getTime();
                //计算当前时间-考试时间,单位秒
                long seconds = (stopTime - startTime)/1000;
                long minutes = seconds / 60;
                long remainingSeconds = seconds % 60;
                stu.setOpenTime("{\"minutes\":\""+minutes+"\",\"seconds\":\""+remainingSeconds+"\"}");
            }else if("2".equals(stu.getExaminationCode()) && null != stu.getOpenTime()){//已交卷
                long startTime = 0;
                long closeTime = 0;
                try {
                    startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(stu.getOpenTime()).getTime();
                    closeTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(stu.getCloseTime()).getTime();
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                //计算当前时间-考试时间,单位秒
                long seconds = (closeTime - startTime)/1000;
                long minutes = seconds / 60;
                long remainingSeconds = seconds % 60;
                stu.setOpenTime("{\"minutes\":\""+minutes+"\",\"seconds\":\""+remainingSeconds+"\"}");
            }else{
                stu.setOpenTime("");
            }
        }
        int total = examinationServiceImp.countEC(ec);
        map.put("total", total);
        map.put("rows", students);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //获取参加考试的学员的统计json数据
    @RequestMapping(value = "/getECCount.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getECCount(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        String examinationId = request.getParameter("examinationId");
        String timingMode = request.getParameter("timingMode");
        StudentExamination ec = new StudentExamination();
        ec.setExaminationId(examinationId);
        List<StudentExamination> students = examinationServiceImp.queryEC(ec,null);
        if(students.size() == 0){
            map.put("code", 1);
            map.put("message", "该考试未有学员,请先在培训管理添加学员");
            return new Gson().toJson(map);
        }else{
            int now = 0;
            int over = 0;
            for(StudentExamination s:students){
                if("1".equals(s.getExaminationCode())){//考试中
                    now++;
                }else if("2".equals(s.getExaminationCode())){//已交卷
                    over++;
                }
            }
            try {
                if("0".equals(timingMode)){//打开试卷计时,无需这个计算
                    long startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(students.get(0).getExaminationTime()).getTime();
                    long stopTime= new Date().getTime();
                    //计算当前时间-考试时间,单位秒
                    long seconds = (stopTime - startTime)/1000;
                    long minutes = seconds / 60;
                    long remainingSeconds = seconds % 60;
                    map.put("minutes", minutes);
                    map.put("seconds", remainingSeconds);
                    logger.info("相差:" +minutes +"分钟  "+remainingSeconds+"秒");
                }
                map.put("code", 0);
                map.put("message", "");
                map.put("total", students.size());
                map.put("now", now);
                map.put("over", over);
                return new Gson().toJson(map);
            } catch (Exception e) {
                e.printStackTrace();
                map.put("code", 2);
                map.put("message", e.getMessage());
                return new Gson().toJson(map);
            }
        }
    }


    //回收试卷,把考试中状态改为已交卷
    @RequestMapping(value = "/updateECCode.do")
    @ResponseBody
    public String updateECCode(HttpServletRequest request, HttpServletResponse response){
        try{
            String examinationId = request.getParameter("examinationId");
            String studentId = request.getParameter("studentId");
            examinationServiceImp.updateECAllCode(examinationId,studentId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //试卷是否发布操作
    @RequestMapping(value = "/updatePublishStatus.do")
    @ResponseBody
    public String updatePublishStatus(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        String type = request.getParameter("type");
        String result = examinationServiceImp.updatePublishStatus(type,examinationId);
        return result;
    }



    //跳转到查询考试成绩页面
    @RequestMapping(value = "/toQueryEC.do")
    public ModelAndView toQueryEC(HttpServletRequest request, HttpServletResponse response){
        String examinationId = request.getParameter("examinationId");
        String cultivateName = request.getParameter("cultivateName");
        ModelAndView mv = new ModelAndView("examination/queryEC");
        mv.addObject("examinationId",examinationId);
        mv.addObject("cultivateName",cultivateName);
        return mv;
    }


    //获取考试成绩
    @RequestMapping(value = "/queryEC.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryEC(HttpServletRequest request, HttpServletResponse response){
        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);
        Map<String,Object> map = new HashMap<String,Object>();

        StudentExamination ec = new StudentExamination();
        String examinationId = request.getParameter("examinationId");
        if(StringUtils.isNoneBlank(examinationId)){
            ec.setExaminationId(examinationId);
        }
        String studentId = request.getParameter("studentId");
        if(StringUtils.isNoneBlank(studentId)){
            ec.setStudentId(studentId);
        }
        List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,pages);
        int total = examinationServiceImp.countEC(ec);
        map.put("total", total);
        map.put("rows", ecList);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //导出考试成绩
    @RequestMapping(value = "/exportEC.do")
    public void exportEC(HttpServletRequest request, HttpServletResponse response){
        List<StudentExamination> ecList = null ;
        StudentExamination ec = new StudentExamination();
        String examinationId = request.getParameter("examinationId");
        if(StringUtils.isNoneBlank(examinationId)){
            ec.setExaminationId(examinationId);
        }
        String studentId = request.getParameter("studentId");
        if(StringUtils.isNoneBlank(studentId)){
            ec.setStudentId(studentId);
        }
        ecList = examinationServiceImp.queryEC(ec,null);
        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(ecList, PropertyUtil.getProperty("examination.ec.type", "defaultValue"),"考试成绩表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    //发布成绩
    @RequestMapping(value = "/updateByReleaseEC.do")
    @ResponseBody
    public String updateByReleaseEC(HttpServletRequest request, HttpServletResponse response){
        try{
            Examination ex = new Examination();
            String examinationId = request.getParameter("examinationId");
            String t_sendECTime = request.getParameter("t_sendECTime");
            String reFlag = request.getParameter("reFlag");
            if(StringUtils.isNoneBlank(examinationId)){
                ex.setId(Integer.valueOf(examinationId));
                ex.setReleaseTime(t_sendECTime);
            }
            examinationServiceImp.updateByReleaseEC(ex,reFlag);
            return "0";
        }catch (Exception e){
            logger.error(e.getMessage());
            return "1";
        }
    }



    //发布证书
    @RequestMapping(value = "/updateByReleaseCN.do")
    @ResponseBody
    public String updateByReleaseCN(HttpServletRequest request, HttpServletResponse response){
        try{
            Examination ex = new Examination();
            String examinationId = request.getParameter("examinationId");
            String t_sendCNTime = request.getParameter("t_sendCNTime");
            String reFlag = request.getParameter("reFlag");
            if(StringUtils.isNoneBlank(examinationId)){
                ex.setId(Integer.valueOf(examinationId));
                ex.setCertificateNoTime(t_sendCNTime);
            }
            examinationServiceImp.updateByReleaseCN(ex,reFlag);
            return "0";
        }catch (Exception e){
            logger.error(e.getMessage());
            return "1";
        }
    }



    //根据培训ID获取考试json数据(公众号接口)
    @RequestMapping(value = "/getExaminationByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getExaminationByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String cultivateId = request.getParameter("cultivateId");
            String studentId = request.getParameter("studentId");
            String type = request.getParameter("type");
            Examination sParam = new Examination();
            if(StringUtils.isNoneBlank(cultivateId)){
                sParam.setCultivateId(Integer.valueOf(cultivateId));
            }
            if(StringUtils.isBlank(type)){
                map.put("code",1);
                map.put("message","type不能为空");
                map.put("list",null);
                String jsonStr = new Gson().toJson(map);
                return jsonStr;
            }
            if(StringUtils.isBlank(studentId)){
                map.put("code",1);
                map.put("message","studentId不能为空");
                map.put("list",null);
                String jsonStr = new Gson().toJson(map);
                return jsonStr;
            }
            List<Examination> examinations = examinationServiceImp.getExaminationByWeChat(sParam,studentId,type);
            map.put("code",0);
            map.put("message","");
            map.put("list",examinations);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            map.put("list",null);
            logger.error(e.getMessage());
            return new Gson().toJson(map);
        }
    }


//    //根据考试ID获取试卷json数据(公众号接口)
//    @RequestMapping(value = "/getTestPaperByWeChat.do",produces = "application/json;charset=utf-8")
//    @ResponseBody
//    public String getTestPaperByWeChat(HttpServletRequest request, HttpServletResponse response){
//        Map<String,Object> map = new HashMap<String,Object>();
//        try{
//            String examinationId = request.getParameter("examinationId");
//            String studentId = request.getParameter("studentId");
//            if(StringUtils.isBlank(studentId)){
//                map.put("code",1);
//                map.put("message","studentId不能为空");
//                map.put("list",null);
//                return new Gson().toJson(map);
//            }
//            TestPaperExamination te = examinationServiceImp.queryTestPaperByWeChat(examinationId,studentId);
//            if(null == te){
//                map.put("code",1);
//                map.put("message","该考试没有试卷");
//                map.put("list",null);
//                return new Gson().toJson(map);
//            }
//            if(1 != te.getIsPublish()){
//                map.put("code",1);
//                map.put("message","该试卷还未发布");
//                map.put("list",null);
//                return new Gson().toJson(map);
//            }
//            map.put("code",0);
//            map.put("message","");
//            map.put("list",te);
//            String jsonStr = new Gson().toJson(map);
//            return jsonStr;
//        }catch (Exception e){
//            logger.error(e.getMessage());
//            map.put("code",1);
//            map.put("message",e.getLocalizedMessage());
//            map.put("list",null);
//            return new Gson().toJson(map);
//        }
//    }


    //根据考试ID和学员ID获取试卷,成绩,证书,交卷内容等数据(公众号接口)
    @RequestMapping(value = "/getTestPaperByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getTestPaperByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String examinationId = request.getParameter("examinationId");
            StudentExamination ec = new StudentExamination();
            if(StringUtils.isNoneBlank(examinationId)){
                ec.setExaminationId(examinationId);
            }else{
                map.put("code",1);
                map.put("message","examinationId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            String studentId = request.getParameter("studentId");
            if(StringUtils.isNoneBlank(studentId)){
                ec.setStudentId(studentId);
            }else{
                map.put("code",1);
                map.put("message","studentId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,null);
            if(ecList.size() == 0){
                map.put("code",1);
                map.put("message","未查询到考试信息");
                map.put("list",null);
                return new Gson().toJson(map);
            }

            if("2".equals(ecList.get(0).getExaminationCode())){//已考试,查看成绩和证书之类的
                if(null == ecList.get(0).getIsRelease() || 0 == ecList.get(0).getIsRelease()){
                    map.put("code",1);
                    map.put("message","该试卷成绩还未发布,无法查询");
                    map.put("list",null);
                    return new Gson().toJson(map);
                }
                if(null == ecList.get(0).getIsCertificateNo() || 0 == ecList.get(0).getIsCertificateNo()){//证书未发布,不允许学员查看
                    ecList.get(0).setCertificateNo("");//设置为空
                }
            }else{ //未考试或考试中,获取试卷并准备考试
                if(null == ecList.get(0).getContent()){
                    map.put("code",1);
                    map.put("message","该考试没有试卷");
                    map.put("list",null);
                    return new Gson().toJson(map);
                }
                if(1 != ecList.get(0).getIsPublish()){
                    map.put("message","该试卷还未发布");
                    map.put("code",1);
                    map.put("list",null);
                    return new Gson().toJson(map);
                }
                if("0".equals(ecList.get(0).getExaminationDataCode())){
                    map.put("code",1);
                    map.put("message","该考试未开始");
                    map.put("list",null);
                    return new Gson().toJson(map);
                }else if("2".equals(ecList.get(0).getExaminationDataCode())){
                    if(ecList.get(0).getIsResit().equals(1)){//需要补考
                        //补考是否已经开始
                        if(null == ecList.get(0).getMakeupBeginTime()){
                            map.put("code",1);
                            map.put("message","补考开始时间为空,无法补考");
                            map.put("list",null);
                            return new Gson().toJson(map);
                        }else {
                            boolean timeFlag = CommonUtils.isgtNow(ecList.get(0).getMakeupBeginTime(), "yyyy-MM-dd HH:mm:ss");
                            if (timeFlag) {
                                map.put("code", 1);
                                map.put("message", "补考未开始,无法补考");
                                map.put("list", null);
                                return new Gson().toJson(map);
                            }
                        }
                        //是否超过补考期限
                        if(null == ecList.get(0).getMakeupTime()){
                            map.put("code",1);
                            map.put("message","补考最后期限为空,无法补考");
                            map.put("list",null);
                            return new Gson().toJson(map);
                        }else {
                            boolean timeFlag = CommonUtils.isgtNow(ecList.get(0).getMakeupTime(), "yyyy-MM-dd HH:mm:ss");
                            if (!timeFlag) {
                                map.put("code", 1);
                                map.put("message", "已超过补考最后期限时间,无法补考");
                                map.put("list", null);
                                return new Gson().toJson(map);
                            }
                        }

                        if(!"1".equalsIgnoreCase(ecList.get(0).getExaminationCode())){ //考试中就不用改,防止重复点补考
                            //补考修改状态(考试状态改为考试中 , 补考次数要更新 , 是否及格,答卷,提交试卷时间 和 成绩清空  , 打开试卷时间要改为当前)
                            examinationServiceImp.updateECbyResit(examinationId,studentId);
                        }
                        //修改后的更新查询
                        ecList = examinationServiceImp.queryEC(ec,null);
                        String willCloseTime = null;
                        //根据情况判断是否修改预计关闭试卷时间
                        if(StringUtils.isBlank(ecList.get(0).getWillCloseTime())){
                            if(ecList.get(0).getStuMakeUpNum().equals(0)){//正式考试
                                if(ecList.get(0).getTimingMode().equals(0)){//0:考试时间开始计时
                                    willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getExaminationTime(),ecList.get(0).getExaminationTimeLimit());
                                }else{//1:打开试卷计时
                                    willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                                }
                            }else{//补考
                                willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                            }

                            //如果关闭试卷为空则修改预计关闭试卷时间
                            examinationServiceImp.updateWillCloseTime(examinationId,studentId,willCloseTime);

                            //修改后的更新查询
                            ecList = examinationServiceImp.queryEC(ec,null);
                        }
                    }else{
                        map.put("code",1);
                        map.put("message","该考试已结束");
                        map.put("list",null);
                        return new Gson().toJson(map);

                    }
                }
            }

            map.put("code",0);
            map.put("message","");
            map.put("list",ecList.get(0));
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            logger.error(e.getMessage());
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }


    //保存试卷作答(公众号接口)
    @RequestMapping(value = "/saveTpByWeChat.do")
    @ResponseBody
    public String saveTpByWeChat(String jsonData,HttpServletRequest request){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String examinationId = request.getParameter("examinationId");
            String studentId = request.getParameter("studentId");
            double countScore = 0;

            ExaminationStudent es = new ExaminationStudent();
            es.setStudentId(Integer.valueOf(studentId));
            es.setExaminationId(Integer.valueOf(examinationId));
            es.setAnswer(jsonData);

            ArrayList<TestPaper> te = new Gson().fromJson(jsonData, new TypeToken<List<TestPaper>>() {}.getType());
            for(int i=0;i<te.size();i++){
                TestPaper t_te = te.get(i);
                if(t_te.getSubjectType().equals(0) || t_te.getSubjectType().equals(2)){//单选,判断
                    if(t_te.getTrueAnswer().get(0).equals(t_te.getAnswer().get(0))){
                        countScore = countScore + t_te.getScore();
                    }
                }else{//多选
                    if(t_te.getAnswer().size() == t_te.getTrueAnswer().size()){//选择一样多的情况,选错一个都没分
                        for(int s=0;s<t_te.getTrueAnswer().size();s++){
                            if(!t_te.getTrueAnswer().get(s).equals(t_te.getAnswer().get(s))){
                                break;
                            }
                            if(s == (t_te.getTrueAnswer().size()-1)){
                                countScore = countScore + t_te.getScore();
                            }
                        }
                    }else if(t_te.getAnswer().size() < t_te.getTrueAnswer().size()){ //少选的情况
                        if(t_te.getScoreType().equals(0)){//少选得部分分
                            boolean flag = false;
                            double m_dcore = t_te.getScore() / t_te.getTrueAnswer().size();
                            m_dcore = Double.parseDouble(new DecimalFormat( "0.0 ").format(m_dcore));//每个选项的分数,保留一位小数
                            for(int c=0;c<t_te.getAnswer().size();c++){
                                if(!t_te.getTrueAnswer().contains(t_te.getAnswer().get(c))){// 有一个答错都不算分
                                    break;
                                }else if(c == (t_te.getAnswer().size() - 1)){
                                    flag = true;
                                }
                            }
                            if(flag){
                                countScore =  m_dcore * t_te.getAnswer().size();
                            }
                        }
                    }
                }
            }

            es.setScore(countScore+"");//分数


            Examination sParam = new Examination();
            sParam.setId(Integer.valueOf(examinationId));
            Examination examination  = examinationServiceImp.queryExaminationByEquals(sParam,null).get(0);
            if(examination.getPassingScoreLine() <= countScore){
                es.setIsPassing(1);//及格
                //生成证书
                String year = Calendar.getInstance().get(Calendar.YEAR)+"";
                year = year.substring(2,year.length());
                //16是广东的编码
                String certificateNo = "BW" + year + "16" + studentId +"-J";//证书编码解释（如通信(招标)字BW19230437-J）
                es.setCertificateNo(certificateNo);
            }else{
                es.setIsPassing(0);//不及格
                es.setCertificateNo(null);
            }

            examinationServiceImp.saveTpByWeChat(es);
            map.put("code",0);
            map.put("message","");
            map.put("list",null);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch(Exception e){
            logger.error(e.getMessage());
            map.put("message",e.getMessage());
            map.put("code",1);
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }



    //下载电子证书(公众号接口)  /emp/examination/downloadCertificateByWeChat.do?certificateNo=BW89203923 --下载
    @RequestMapping(value = "/downloadCertificateByWeChat.do")
    public void downloadCertificateByWeChat(HttpServletRequest request, HttpServletResponse response){
        try{
            String certificateNo = request.getParameter("certificateNo");

            StudentExamination ec = new StudentExamination();
            if(StringUtils.isNoneBlank(certificateNo)){
                ec.setCertificateNo(certificateNo);
            }
            List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,null);
            StudentExamination se = ecList.get(0);

            Map<String, String> data = new HashMap<String, String>();
            data.put("studentName", se.getRealName());
            data.put("cultivateName", se.getCultivateName());
            data.put("certificateNo", se.getCertificateNo());
            String time = se.getCertificateTime();
            time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
            data.put("certificateTime", time);

            String type = request.getParameter("type");//预览的话type不能为空
            String filePath = PdfCommonUtils.createPdf(data);
            CommonUtils.outputCNToResponse(filePath,type,response);
        }catch (Exception e){
            logger.error(e.getMessage());
        }
    }


    //打开试卷的时候修改成考试中(公众号接口)
    @RequestMapping(value = "/updateECbyExamination.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String updateECbyExamination(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String examinationId = request.getParameter("examinationId");
            String studentId = request.getParameter("studentId");

            if(StringUtils.isBlank(examinationId)){
                map.put("code",1);
                map.put("message","examinationId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            if(StringUtils.isBlank(studentId)){
                map.put("code",1);
                map.put("message","studentId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }

            examinationServiceImp.updateECbyExamination(examinationId,studentId);

            StudentExamination ec = new StudentExamination();
            ec.setStudentId(studentId);
            ec.setExaminationId(examinationId);
            List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,null);
            String willCloseTime = null;
            //根据情况判断是否修改预计关闭试卷时间
            if(StringUtils.isBlank(ecList.get(0).getWillCloseTime())){
                if(ecList.get(0).getStuMakeUpNum().equals(0)){//正式考试
                    if(ecList.get(0).getTimingMode().equals(0)){//0:考试时间开始计时
                        willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getExaminationTime(),ecList.get(0).getExaminationTimeLimit());
                    }else{//1:打开试卷计时
                        willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                    }
                }else{//补考
                    willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                }

                //如果关闭试卷为空则修改预计关闭试卷时间
                examinationServiceImp.updateWillCloseTime(examinationId,studentId,willCloseTime);
            }else{
                willCloseTime = ecList.get(0).getWillCloseTime();
            }

            map.put("code",0);
            map.put("message","成功");
            map.put("list",willCloseTime);
            //返回当前时间给前端用于计算
            map.put("nowTime",new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            map.put("list",null);
            logger.error(e.getMessage());
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }
    }


    //点击补考(公众号接口)
    @RequestMapping(value = "/updateECbyResit.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String updateECbyResit(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            //校验
            String examinationId = request.getParameter("examinationId");
            String studentId = request.getParameter("studentId");
            StudentExamination ec = new StudentExamination();
            if(StringUtils.isBlank(examinationId)){
                map.put("message","examinationId参数不能为空");
                map.put("code",1);
                map.put("list",null);
                return new Gson().toJson(map);
            }
            if(StringUtils.isBlank(studentId)){
                map.put("message","studentId参数不能为空");
                map.put("code",1);
                map.put("list",null);
                return new Gson().toJson(map);
            }
            ec.setStudentId(studentId);
            ec.setExaminationId(examinationId);

            List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,null);
            if(ecList.size() == 0){
                map.put("code",1);
                map.put("list",null);
                map.put("message","未查询到考试信息");
                return new Gson().toJson(map);
            }
            if(null == ecList.get(0).getContent()){
                map.put("code",1);
                map.put("list",null);
                map.put("message","该考试没有试卷");
                return new Gson().toJson(map);
            }
            if(1 != ecList.get(0).getIsPublish()){
                map.put("code",1);
                map.put("message","该试卷还未发布");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            if(1 > ecList.get(0).getResidueNum()){
                map.put("code",1);
                map.put("message","补考次数为0,无法补考");
                map.put("list",null);
                return new Gson().toJson(map);
            }


            //补考是否已经开始
            if(null == ecList.get(0).getMakeupBeginTime()){
                map.put("code",1);
                map.put("message","补考开始时间为空,无法补考");
                map.put("list",null);
                return new Gson().toJson(map);
            }else {
                boolean timeFlag = CommonUtils.isgtNow(ecList.get(0).getMakeupBeginTime(), "yyyy-MM-dd HH:mm:ss");
                if (timeFlag) {
                    map.put("code", 1);
                    map.put("message", "补考未开始,无法补考");
                    map.put("list", null);
                    return new Gson().toJson(map);
                }
            }
            //是否超过补考期限
            if(null == ecList.get(0).getMakeupTime()){
                map.put("code",1);
                map.put("message","补考最后期限为空,无法补考");
                map.put("list",null);
                return new Gson().toJson(map);
            }else {
                boolean timeFlag = CommonUtils.isgtNow(ecList.get(0).getMakeupTime(), "yyyy-MM-dd HH:mm:ss");
                if (!timeFlag) {
                    map.put("code", 1);
                    map.put("message", "已超过补考最后期限时间,无法补考");
                    map.put("list", null);
                    return new Gson().toJson(map);
                }
            }

            if(!"1".equalsIgnoreCase(ecList.get(0).getExaminationCode())){ //考试中就不用改,防止重复点补考
                //补考修改状态(考试状态改为考试中 , 补考次数要更新 , 是否及格,答卷,提交试卷时间 和 成绩清空  , 打开试卷时间要改为当前)
                examinationServiceImp.updateECbyResit(examinationId,studentId);
            }

            //重新查询
            ecList = examinationServiceImp.queryEC(ec,null);

            String willCloseTime = null;
            //根据情况判断是否修改预计关闭试卷时间
            if(StringUtils.isBlank(ecList.get(0).getWillCloseTime())){
                if(ecList.get(0).getStuMakeUpNum().equals(0)){//正式考试
                    if(ecList.get(0).getTimingMode().equals(0)){//0:考试时间开始计时
                        willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getExaminationTime(),ecList.get(0).getExaminationTimeLimit());
                    }else{//1:打开试卷计时
                        willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                    }
                }else{//补考
                    willCloseTime = CommonUtils.TimeAdd(ecList.get(0).getOpenTime(),ecList.get(0).getExaminationTimeLimit());
                }
                //如果关闭试卷为空则修改预计关闭试卷时间
                examinationServiceImp.updateWillCloseTime(examinationId,studentId,willCloseTime);
            }else{
                willCloseTime = ecList.get(0).getWillCloseTime();
            }

            //重新查询
            ecList = examinationServiceImp.queryEC(ec,null);

            map.put("code",0);
            map.put("message","成功");
            map.put("list",ecList.get(0));
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            logger.error(e.getMessage());
            map.put("list",null);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }
    }



    //查询考试状态(公众号接口)
    @RequestMapping(value = "/queryEcCodeByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryEcCodeByWeChat(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            String examinationId = request.getParameter("examinationId");
            String studentId = request.getParameter("studentId");
            if (StringUtils.isBlank(examinationId)) {
                map.put("code", 1);
                map.put("message", "examinationId参数不能为空");
                map.put("examinationCode", null);
                return new Gson().toJson(map);
            }
            if (StringUtils.isBlank(studentId)) {
                map.put("code", 1);
                map.put("message", "studentId参数不能为空");
                map.put("examinationCode", null);
                return new Gson().toJson(map);
            }
            ExaminationStudent es = new ExaminationStudent();
            es.setExaminationId(Integer.valueOf(examinationId));
            es.setStudentId(Integer.valueOf(studentId));
            int code = examinationServiceImp.queryEcCodeByWeChat(es);
            map.put("code", 0);
            map.put("message", "成功");
            map.put("examinationCode", code);
            return new Gson().toJson(map);
        } catch (Exception e) {
            map.put("code", 1);
            map.put("message", e.getMessage());
            map.put("examinationCode", null);
            logger.error(e.getMessage());
            return new Gson().toJson(map);
        }
    }


    //查询成绩中是否有证书可供下载
    @RequestMapping(value = "/queryExistCertificate.do")
    @ResponseBody
    public String queryExistCertificate(HttpServletRequest request, HttpServletResponse response){
        String result = "1";//默认没有证书
        try{
            String examinationId = request.getParameter("examinationId");
            StudentExamination ec = new StudentExamination();
            ec.setExaminationId(examinationId);
            List<StudentExamination> students = examinationServiceImp.queryEC(ec,null);
            for(StudentExamination se:students){
                if(StringUtils.isNoneBlank(se.getCertificateNo())){
                    result = "0";
                    break;
                }
            }
            return result;
        }catch (Exception e){
            logger.error(e.getMessage());
            return "2";
        }
    }


    //批量删除考试对象
    @RequestMapping(value = "/deleteExaminations.do")
    @ResponseBody
    public String deleteExaminations(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            examinationServiceImp.deleteExaminations(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }

}
