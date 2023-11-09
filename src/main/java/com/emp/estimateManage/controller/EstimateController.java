package com.emp.estimateManage.controller;

import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.service.imp.CultivateServiceImp;
import com.emp.estimateManage.entity.Estimate;
import com.emp.estimateManage.entity.EstimateStudent;
import com.emp.estimateManage.entity.QuestionnaireEstimate;
import com.emp.estimateManage.service.imp.EstimateServiceImp;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentEstimate;
import com.emp.systemManage.controller.ParentController;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PoiToWordUtils;
import com.emp.systemManage.utils.PropertyUtil;
import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.poifs.filesystem.DirectoryEntry;
import org.apache.poi.poifs.filesystem.DocumentEntry;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value = "/estimate")
public class EstimateController extends ParentController {

    private Logger logger = Logger.getLogger(EstimateController.class);


    @Autowired
    private EstimateServiceImp estimateServiceImp;

    @Autowired
    private CultivateServiceImp cultivateServiceImp;


    //跳转评估管理页面
    @RequestMapping(value = "/estimateList.do")
    public ModelAndView studentList(){
        ModelAndView mv = new ModelAndView("estimate/estimateManage");
        return mv;
    }


    //获取评估json数据
    @RequestMapping(value = "/getEstimate.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getEstimate(HttpServletRequest request, HttpServletResponse response){
        String cultivateName = request.getParameter("cultivateName");
        String estimateBeginTime = request.getParameter("estimateBeginTime");
        String estimateEndTime = request.getParameter("estimateEndTime");
        String estimateDataCode = request.getParameter("estimateDataCode");
        Estimate sParam = new Estimate();
        if(StringUtils.isNoneBlank(cultivateName)){
            sParam.setCultivateName(cultivateName);
        }
        if(StringUtils.isNoneBlank(estimateBeginTime)){
            sParam.setEstimateBeginTime(estimateBeginTime);
        }
        if(StringUtils.isNoneBlank(estimateEndTime)){
            sParam.setEstimateEndTime(estimateEndTime);
        }
        if(StringUtils.isNoneBlank(estimateDataCode)){
            sParam.setEstimateDataCode(Integer.valueOf(estimateDataCode));
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map = new HashMap<String,Object>();
        List<Estimate> estimate = estimateServiceImp.queryEstimateByLike(sParam,pages);
        int total = estimateServiceImp.countEstimateByLike(sParam);
        map.put("total", total);
        map.put("rows", estimate);

        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //跳转到新增修改页面
    @RequestMapping(value = "/editEstimate.do")
    public ModelAndView editEstimate(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        ModelAndView mv = new ModelAndView("estimate/editEstimate");
        List<Cultivate> cultivateList = cultivateServiceImp.queryCultivateByLike(null,null);
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("total", cultivateList.size());
        map.put("rows", cultivateList);
        String jsonStr = new Gson().toJson(map);
        mv.addObject("cultivateList",jsonStr);
        if(StringUtils.isBlank(id)){
            mv.addObject("title","新增评估");
        }else{
            mv.addObject("title","评估设置");
            Estimate sParam = new Estimate();
            sParam.setId(Integer.valueOf(id));
            sParam = estimateServiceImp.queryEstimateByLike(sParam,null).get(0);
            mv.addObject("estimate",sParam);
        }
        return mv;
    }


    // 保存评估
    @RequestMapping(value = "/save.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String save(@ModelAttribute Estimate estimate, HttpServletRequest request, HttpServletResponse response){
        String jsonStr = null;
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            //计算评估状态
            boolean timeFlag = CommonUtils.isgtNow(estimate.getEstimateEndTime(),"yyyy-MM-dd HH:mm:ss");
            if(timeFlag){
                timeFlag = CommonUtils.isgtNow(estimate.getEstimateBeginTime(),"yyyy-MM-dd HH:mm:ss");
                if(timeFlag){
                    estimate.setEstimateDataCode(0);//开始时间比当前时间大为未开始
                }else{
                    estimate.setEstimateDataCode(1);//开始时间比当前时间大为进行中
                }
            }else{
                estimate.setEstimateDataCode(2);//结束时间小于当前时间为已结束
            }

            if(null == estimate.getId()) {//新增
                 map = estimateServiceImp.insertEstimateAll(estimate);
            }else{//修改
                Estimate t_eParam = new Estimate();
                t_eParam.setId(estimate.getId());
                List<Estimate> estimate2 = estimateServiceImp.queryEstimateByLike(t_eParam,null);
                if(estimate2.size() == 0){
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：该评估已不存在!");
                }else{
                    Estimate eParam = new Estimate();
                    if(StringUtils.isNoneBlank(estimate.getEstimateName())){
                        eParam.setEstimateName(estimate.getEstimateName());
                    }
                    List<Estimate> estimate1 = estimateServiceImp.queryEstimateByEquals(eParam,null);

                    if(estimate1.size() == 0 || estimate1.get(0).getId().equals(estimate2.get(0).getId())){
                        boolean changeFlag = false;
                        if(!estimate2.get(0).getCultivateId().equals(estimate.getCultivateId())){//培训改变
                            changeFlag = true;
                        }
                        estimateServiceImp.updateEstimate(estimate,changeFlag);
                        map.put("rCode", 0);
                        map.put("detail", "修改评估设置成功");
                    }else{
                        map.put("rCode", 1);
                        map.put("detail", "错误提示：已有同名的评估!");
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


    //跳转到问卷编辑页面
    @RequestMapping(value = "/editQuestionnaire.do")
    public ModelAndView editQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/editQuestionnaire");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("estimateId",estimateId);

        QuestionnaireEstimate qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(qi);
        if(null != qi1){
            mv.addObject("questionnaire",qi1);
        }
        return mv;
    }


    //保存问卷
    @RequestMapping(value = "/saveQuestionnaire.do")
    @ResponseBody
    public String saveQuestionnaire(String jsonData,HttpServletRequest request){
        try{
            String estimateId = request.getParameter("estimateId");
            String id = request.getParameter("id");
            QuestionnaireEstimate qi = new QuestionnaireEstimate();
            if(StringUtils.isBlank(id)){//新增
                qi.setContent(jsonData);
                qi.setEstimateId(Integer.valueOf(estimateId));
                estimateServiceImp.insertQuestionnaire(qi);
            }else{//修改
                qi.setId(Integer.valueOf(id));
                qi.setContent(jsonData);
                qi.setEstimateId(Integer.valueOf(estimateId));
                qi.setIsPublish(0);//未发布
                //保存修改后的信息 和 重置学员的答卷信息和评估信息
                estimateServiceImp.updateQuestionnaireBySave(qi);
            }
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }



    //跳转到查看问卷页面
    @RequestMapping(value = "/showQuestionnaire.do")
    public ModelAndView showQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/showQuestionnaire");
        mv.addObject("title",request.getParameter("cultivateName"));

        QuestionnaireEstimate qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(qi);
        if(null != qi1){
            mv.addObject("questionnaire",qi1);
        }
        return mv;
    }


    //去复制问卷页面
    @RequestMapping(value = "/toCopyQuestionnaire.do")
    public ModelAndView toCopyQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/copyQuestionnaire");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("estimateId",estimateId);

        QuestionnaireEstimate qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(qi);
        if(null != qi1){
            mv.addObject("questionnaire",qi1);
        }
        return mv;
    }


    //获取json评估问卷数据BY-页面复制
    @RequestMapping(value = "/queryByName.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryByName(HttpServletRequest request, HttpServletResponse response){
        String estimateName = request.getParameter("estimateName");
        Estimate sParam = new Estimate();
        if(StringUtils.isNoneBlank(estimateName)){
            sParam.setEstimateName(estimateName);
        }
        Map<String,Object> map=new HashMap<String,Object>();
        List<Estimate> estimates = estimateServiceImp.queryEstimateByLike(sParam,null);
        for(Estimate estimate:estimates){
            QuestionnaireEstimate qi = new QuestionnaireEstimate();
            if(StringUtils.isNoneBlank(estimate.getId().toString())){
                qi.setEstimateId(Integer.valueOf(estimate.getId().toString()));
            }
            QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(qi);
            if(null != qi1){
                estimate.setEstimateName(estimate.getEstimateName()+"  (已有问卷)");
            }
        }
        map.put("rows", estimates);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //复制问卷
    @RequestMapping(value = "/saveCopyQuestionnaire.do")
    @ResponseBody
    public String saveCopyQuestionnaire(String[] arrs,HttpServletRequest request){
        try{
            String type = request.getParameter("type");
            String estimateId = request.getParameter("estimateId");

            if("add".equalsIgnoreCase(type)){//是否新增一个评估
                String inputName = request.getParameter("inputName");
                Map<String, String> param = new HashMap<>();
                param.put("t_estimateId", estimateId);
                param.put("t_inputName", inputName);
                //执行存储过程
                estimateServiceImp.addEstimateByCopy(param);
                return param.get("t_result") ;
            }else{
                QuestionnaireEstimate t_qi = new QuestionnaireEstimate();
                if(StringUtils.isNoneBlank(estimateId)){
                    t_qi.setEstimateId(Integer.valueOf(estimateId));
                }
                //复制的问卷
                QuestionnaireEstimate qi = estimateServiceImp.queryQuestionnaire(t_qi);
                //需要被修改的问卷
                for(int i=0;i<arrs.length;i++){
                    t_qi.setEstimateId(Integer.valueOf(arrs[i]));
                    QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(t_qi);
                    if(null != qi1){//修改
                        qi1.setContent(qi.getContent());
                        estimateServiceImp.updateQuestionnaire(qi1);
                    }else{//新增
                        QuestionnaireEstimate qi2 = new QuestionnaireEstimate();
                        qi2.setContent(qi.getContent());
                        qi2.setEstimateId(Integer.valueOf(arrs[i]));
                        estimateServiceImp.insertQuestionnaire(qi2);
                    }
                }
                return "0";
            }
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //导出问卷word
    @RequestMapping(value = "/exportQuestionnaire.do")
    public void exportQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        String fileName = request.getParameter("title")+ "培训课问卷";

        QuestionnaireEstimate t_qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            t_qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi = estimateServiceImp.queryQuestionnaire(t_qi);
        try{
            String filePath = new PoiToWordUtils().writeWord(qi, PropertyUtil.getProperty("questionnaire.type", "defaultValue"),fileName,"");
            CommonUtils.outputToResponse(filePath,"docx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }



    //导出问卷统计word
    @RequestMapping(value = "/exportStatistics.do")
    public void exportStatistics(HttpServletRequest request, HttpServletResponse response){
        String fileName = request.getParameter("title")+ "培训课问卷统计";
        String htmlText = request.getParameter("htmlText");
        try{
            String filePath = new PoiToWordUtils().writeTempWord(htmlText,fileName);
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    /**
     *  导出评估结果原始结果,规则如下:
     * 1.单选:题目 和 只显示第几个答案被选择了(4代表第四个答案)
     * 2.简答:题目 和 显示作答填写的信息
     * 3.矩阵:显示每个行标题 , 然后每个行标题显示第几个答案被选择了(3代表第三个被选中)
     * 4.多选:显示每个选项 , 和是否被选中(0代表没选中   1代表选中)
     * */
    @RequestMapping(value = "/exportEstimateResult.do")
    public void exportEstimateResult(String[] arr,HttpServletRequest request, HttpServletResponse response){
        String estimateName = request.getParameter("estimateName");
        String estimateId = request.getParameter("estimateId");

        StudentEstimate se = new StudentEstimate();
        QuestionnaireEstimate qi = new QuestionnaireEstimate();

        if(StringUtils.isNoneBlank(estimateId)){
            se.setEstimateId(estimateId);
            qi.setEstimateId(Integer.valueOf(estimateId));
        }

        qi = estimateServiceImp.queryQuestionnaire(qi);
        List<StudentEstimate> Ses = estimateServiceImp.queryEstimateResult(se);

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("content", qi.getContent());
        map.put("Ses", Ses);

        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(map, PropertyUtil.getProperty("estimateResult.type", "defaultValue"),estimateName+"评估结果原始结果");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }


    //去导入问卷页面
    @RequestMapping(value = "/importQuestionnaire.do")
    public ModelAndView importQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/importQuestionnaire");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("estimateId",request.getParameter("estimateId"));

        QuestionnaireEstimate t_qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            t_qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi = estimateServiceImp.queryQuestionnaire(t_qi);
        if(null != qi){
            mv.addObject("questionnaireEstimate",qi);
        }
        return mv;
    }


    //跳转到新增学员到评估中间表页面
    @RequestMapping(value = "/toAddES.do")
    public ModelAndView toAddES(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("estimate/addES");
        mv.addObject("type",request.getParameter("type"));
        mv.addObject("estimateId",request.getParameter("estimateId"));
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
        String estimateId = request.getParameter("estimateId");
        String type = request.getParameter("type");
        List<Student> students = estimateServiceImp.queryESByLike(sParam,estimateId,pages,type);
        int total = estimateServiceImp.countESByLike(sParam,estimateId,type);
        map.put("total", total);
        map.put("rows", students);

        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //跳转到评估监控页面
    @RequestMapping(value = "/toEstimateControl.do")
    public ModelAndView toEstimateControl(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("estimate/estimateControl");
        mv.addObject("estimateId",request.getParameter("estimateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        return mv;
    }


    //获取参加评估的学员json数据
    @RequestMapping(value = "/getECList.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getECList(HttpServletRequest request, HttpServletResponse response){
        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);
        Map<String,Object> map = new HashMap<String,Object>();
        String estimateId = request.getParameter("estimateId");
        StudentEstimate se = new StudentEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            se.setEstimateId(estimateId);
        }
        List<StudentEstimate> students = estimateServiceImp.queryEC(se,pages);
        int total = estimateServiceImp.countEC(se);
        map.put("total", total);
        map.put("rows", students);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //获取参加评估的学员的统计json数据
    @RequestMapping(value = "/getECCount.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getECCount(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        String estimateId = request.getParameter("estimateId");
        StudentEstimate se = new StudentEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            se.setEstimateId(estimateId);
        }
        List<StudentEstimate> students = estimateServiceImp.queryEC(se,null);
        int over = 0;
        for(StudentEstimate s:students){
            if("2".equals(s.getEstimateCode())){//已交卷
                over++;
            }
        }
        map.put("total", students.size());
        map.put("over", over);
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //去发布问卷页面
    @RequestMapping(value = "/publishQuestionnaire.do")
    public ModelAndView publishQuestionnaire(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/publishQuestionnaire");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("estimateId",estimateId);
        QuestionnaireEstimate qi = new QuestionnaireEstimate();
        if(StringUtils.isNoneBlank(estimateId)){
            qi.setEstimateId(Integer.valueOf(estimateId));
        }
        QuestionnaireEstimate qi1 = estimateServiceImp.queryQuestionnaire(qi);
        if(null != qi1){
            mv.addObject("questionnaireEstimate",qi1);
            estimateServiceImp.updateQEByPublish(qi1.getEstimateId().toString());//修改为已发布
        }
        return mv;
    }


    //获取试卷二维码或下载二维码
    @RequestMapping(value = "/getQiQRCode.do")
    public void getQiQRCode(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        String cultivateId = request.getParameter("cultivateId");
        //   http://localhost:8081/emp/dist/index.html#/question?id=16&queid=26
        String url = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()
                + "/dist/index.html#/question?id=" + cultivateId + "&queid=" + estimateId;
        String type = request.getParameter("type");
        String name = request.getParameter("name");
        this.getQRCode(request,response,url,type,name);
    }



    //跳转到查看评估结果页面
    @RequestMapping(value = "/toShowResult.do")
    public ModelAndView toShowResult(HttpServletRequest request, HttpServletResponse response){
        String estimateId = request.getParameter("estimateId");
        ModelAndView mv = new ModelAndView("estimate/showResult");
        mv.addObject("title",request.getParameter("cultivateName"));
        mv.addObject("estimateId",estimateId);
        return mv;
    }


    //根据培训ID获取评估结果数据
    @RequestMapping(value = "/getShowResult.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getShowResult(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String estimateId = request.getParameter("estimateId");
            QuestionnaireEstimate qi = new QuestionnaireEstimate();
            if(StringUtils.isNoneBlank(estimateId)){
                qi.setEstimateId(Integer.valueOf(estimateId));
            }
            qi = estimateServiceImp.queryQuestionnaire(qi);
            if(qi == null){
                map.put("code",1);
                map.put("message","问卷不存在,无法查看评估结果");
                map.put("str",null);
                return new Gson().toJson(map);
            }
            if(1 != qi.getIsPublish()){
                map.put("code",1);
                map.put("message","请先发布问卷");
                map.put("str",null);
                return new Gson().toJson(map);
            }
            String result = estimateServiceImp.getShowResult(qi);
            map.put("code",0);
            map.put("message","");
            map.put("str",result);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            logger.error(e.getMessage());
            map.put("code",1);
            map.put("message",e.getMessage());
            map.put("str",null);
            return new Gson().toJson(map);
        }
    }


    //根据培训ID获取评估json数据(公众号接口)
    @RequestMapping(value = "/getEstimateByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getEstimateByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String cultivateId = request.getParameter("cultivateId");
            Estimate sParam = new Estimate();
            if(StringUtils.isNoneBlank(cultivateId)){
                sParam.setCultivateId(Integer.valueOf(cultivateId));
            }
            String studentId = request.getParameter("studentId");
            if(StringUtils.isBlank(studentId)){
                map.put("code",1);
                map.put("message","studentId不能为空");
                map.put("list",null);
                String jsonStr = new Gson().toJson(map);
                return jsonStr;
            }
            List<Estimate> estimate = estimateServiceImp.queryEstimateByWeChat(sParam,studentId);
            map.put("code",0);
            map.put("message","");
            map.put("list",estimate);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getLocalizedMessage());
            logger.error(e.getMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }


    //根据评估ID获取问卷json数据(公众号接口)
    @RequestMapping(value = "/getQuestionnaireByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getQuestionnaireByWeChat(HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String estimateId = request.getParameter("estimateId");
            StudentEstimate se = new StudentEstimate();
            if(StringUtils.isNoneBlank(estimateId)){
                se.setEstimateId(estimateId);
            }else{
                map.put("code",1);
                map.put("message","estimateId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            String studentId = request.getParameter("studentId");
            if(StringUtils.isNoneBlank(studentId)){
                se.setStudentId(studentId);
            }else{
                map.put("code",1);
                map.put("message","studentId参数不能为空");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            List<StudentEstimate> ecList = estimateServiceImp.queryEC(se,null);

            if(ecList.size() == 0){
                map.put("code",1);
                map.put("message","未查询到评估信息");
                map.put("list",null);
                return new Gson().toJson(map);
            }

            if(null == ecList.get(0).getContent()){
                map.put("code",1);
                map.put("message","该评估没有问卷");
                map.put("list",null);
                return new Gson().toJson(map);
            }
            if(1 != ecList.get(0).getIsPublish()){
                map.put("message","该问卷还未发布");
                map.put("code",1);
                map.put("list",null);
                return new Gson().toJson(map);
            }
            if("0".equals(ecList.get(0).getEstimateDataCode())){
                map.put("code",1);
                map.put("message","该评估未开始");
                map.put("list",null);
                return new Gson().toJson(map);
            }else if("2".equals(ecList.get(0).getEstimateDataCode())){
                map.put("code",1);
                map.put("message","该评估已结束");
                map.put("list",null);
                return new Gson().toJson(map);
            }

            if(null != ecList.get(0).getAnswerLimitNum()){
                int num = ecList.get(0).getAnswerLimitNum() -  ecList.get(0).getAnswerNum() ;
                if(num < 1){
                    map.put("code",1);
                    map.put("message","该评估作答已达到限制数"+ecList.get(0).getAnswerLimitNum()+"次");
                    map.put("list",null);
                    return new Gson().toJson(map);
                }
            }

            map.put("code",0);
            map.put("message","");
            map.put("list",ecList.get(0));
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch (Exception e){
            map.put("code",1);
            map.put("message",e.getMessage());
            logger.error(e.getMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }


    //保存问卷作答(公众号接口)
    @RequestMapping(value = "/saveQiByWeChat.do")
    @ResponseBody
    public String saveQiByWeChat(String jsonData,HttpServletRequest request){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            String estimateId = request.getParameter("estimateId");
            String studentId = request.getParameter("studentId");
            EstimateStudent es = new EstimateStudent();
            es.setStudentId(Integer.valueOf(studentId));
            es.setEstimateId(Integer.valueOf(estimateId));
            es.setAnswer(jsonData);
            estimateServiceImp.saveQiByWeChat(es);
            map.put("code",0);
            map.put("message","");
            map.put("list",null);
            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            map.put("code",1);
            map.put("message",e.getMessage());
            map.put("list",null);
            return new Gson().toJson(map);
        }
    }


    //问卷是否发布操作
    @RequestMapping(value = "/updatePublishStatus.do")
    @ResponseBody
    public String updatePublishStatus(HttpServletRequest request, HttpServletResponse response){
        try{
            String estimateId = request.getParameter("estimateId");
            String type = request.getParameter("type");
            QuestionnaireEstimate qi = new QuestionnaireEstimate();
            if("stop".equalsIgnoreCase(type)){
                qi.setEstimateId(Integer.valueOf(estimateId));
                qi.setIsPublish(0);//修改为未发布
            }
            estimateServiceImp.updatePublishStatus(qi);
            return "0";
        }catch (Exception e){
            logger.error(e.getMessage());
            return "1";
        }
    }


    //批量删除评估对象
    @RequestMapping(value = "/deleteEstimates.do")
    @ResponseBody
    public String deleteEstimates(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            estimateServiceImp.deleteEstimates(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }

}
