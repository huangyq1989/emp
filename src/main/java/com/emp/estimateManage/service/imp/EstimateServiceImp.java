package com.emp.estimateManage.service.imp;

import com.emp.estimateManage.dao.EstimateDao;
import com.emp.estimateManage.entity.*;
import com.emp.estimateManage.service.EstimateService;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentEstimate;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.WordFileUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class EstimateServiceImp implements EstimateService {

    private Logger logger = Logger.getLogger(EstimateService.class);

    @Autowired
    private EstimateDao estimateDao;

    @Override
    public List<Estimate> queryEstimateByLike(Estimate estimate, Page pages){
        return estimateDao.queryEstimateByLike(estimate,pages);
    }

    @Override
    public int countEstimateByLike(Estimate estimate){
        return estimateDao.countEstimateByLike(estimate);
    }

    @Override
    public List<Estimate> queryEstimateByEquals(Estimate estimate, Page pages){
        return estimateDao.queryEstimateByEquals(estimate,pages);
    }

    @Override
    public int countEstimateByEquals(Estimate estimate){
        return estimateDao.countEstimateByEquals(estimate);
    }

    @Override
    public void insertEstimate(Estimate estimate){
        estimateDao.insertEstimate(estimate);
    }

    @Override
    public Map<String,Object> insertEstimateAll(Estimate estimate) throws Exception{
        Map<String,Object> map = new HashMap<String,Object>();
        Estimate eParam = new Estimate();
        if(StringUtils.isNoneBlank(estimate.getEstimateName())){
            eParam.setEstimateName(estimate.getEstimateName());
        }
        List<Estimate> estimate1 = estimateDao.queryEstimateByEquals(eParam,null);

        if(estimate1.size() > 0){
            map.put("rCode", 2);
            map.put("detail", "评估名称已存在");
        }else{
            estimateDao.insertEstimate(estimate);
            if(estimate.getId() != null){
                estimateDao.addES(estimate.getCultivateId().toString(),estimate.getId().toString());//添加评估人员

                if(!StringUtils.isBlank(estimate.getQuestionnaireData())){//保存问卷
                    QuestionnaireEstimate qi = new QuestionnaireEstimate();
                    qi.setContent(estimate.getQuestionnaireData());
                    qi.setEstimateId(Integer.valueOf(estimate.getId()));
                    estimateDao.insertQuestionnaire(qi);
                }

                map.put("rCode", 0);
                map.put("detail", "添加评估成功");
            }else{
                map.put("rCode", 1);
                map.put("detail", "添加评估失败");
            }
        }
        return map;
    }


    @Override
    public void updateEstimate(Estimate estimate,boolean changeFlag) throws Exception{
        if(changeFlag){//true为需要更换培训id
            //删除考试原学员信息
            estimateDao.deleteCESById(estimate.getId().toString());
            //添加新培训考试学员
            estimateDao.addES(estimate.getCultivateId().toString(),estimate.getId().toString());
        }
        //修改评估信息
        estimateDao.updateEstimate(estimate);
    }

    @Override
    public QuestionnaireEstimate queryQuestionnaire(QuestionnaireEstimate qi){
        return estimateDao.queryQuestionnaire(qi);
    }

    @Override
    public void insertQuestionnaire(QuestionnaireEstimate qi){
        estimateDao.insertQuestionnaire(qi);
    }

    @Override
    public void updateQuestionnaire(QuestionnaireEstimate qi){
        estimateDao.updateQuestionnaire(qi);
    }

    @Override
    public void updateQuestionnaireBySave(QuestionnaireEstimate qi) throws Exception{
        estimateDao.updateQuestionnaire(qi);
        //重置学员的答卷信息和评估信息
        estimateDao.updateESByPublish(qi.getEstimateId().toString());
    }

    @Override
    public void addEstimateByCopy(Map<String, String> param){
        estimateDao.addEstimateByCopy(param);
    }

    @Override
    public void addES(String cultivateId,String estimateId){
        estimateDao.addES(cultivateId,estimateId);
    }

    @Override
    public List<Student> queryESByLike(Student student, String cultivateId, Page pages, String type){
        return estimateDao.queryESByLike(student,cultivateId,pages,type);
    }

    @Override
    public int countESByLike(Student student,String cultivateId, String type){
        return estimateDao.countESByLike(student,cultivateId,type);
    }

    @Override
    public List<EstimateStudent> queryEsById(EstimateStudent es){
        return estimateDao.queryEsById(es);
    }

    @Override
    public int countEsById(EstimateStudent es){
        return estimateDao.countEsById(es);
    }

    @Override
    //读取woed文件校验问卷
    public Map<String,Object> importQuestionnaire(String path) throws IOException, SQLException {
        ArrayList<String> arrayList = new ArrayList<>();
        String errorMessage = "";
        int paperNo = 0;//第几题
        File wordFile = new File(path);
        String str = WordFileUtils.extractTextFromWordFile(wordFile);//读取文件获取内容
        str = str.substring(str.indexOf("导入内容:",0)+5,str.length());
        String[] arr = str.split("\\["); // 用[分割成几道题
        flag : for(int i=0;i<arr.length;i++){
            String title = null;
            Questionnaire qi = new Questionnaire();
            List<String> op = new ArrayList<>();
            List<String> mustAnswer = new ArrayList<>();
            List<Integer> score = new ArrayList<>();

            String[] m_arr = arr[i].split("\n"); // 用\n分割
            for(int j=0;j<m_arr.length;j++) {
                String t_s = m_arr[j].trim();

                // 去除前后的空格
                if (null != t_s && !"".equals(t_s)) {
                    t_s = t_s.replaceAll("^[　*| *| *|//s*]*", "").replaceAll("[　*| *| *|//s*]*$", "");

                    //去除奇怪的空格,java中的字符都用utf-16be进行编码，所以转码为utf-16be我们就知道了这个奇怪的字符在java里的编码。这样方便后面查找
                    String urlEncoderUnicode = URLEncoder.encode(t_s,"utf-16be");
                    if(urlEncoderUnicode.equalsIgnoreCase("%00%A0")){//不间断空格\u00A0,主要用在office中,让一个单词在结尾处不会换行显示,快捷键ctrl+shift+space ;
                        t_s=t_s.replaceAll("\u00A0+", "");
                    }else if(urlEncoderUnicode.equalsIgnoreCase("%30%00")){//全角空格(中文符号)\u3000,中文文章中使用
                        t_s=t_s.replaceAll("\u3000+", "");
                    }
                }

                if (j == 0) {//问卷类型
                    if ("单选题]".equals(t_s)) {
                        qi.setSubjectType(0);
                        paperNo = paperNo + 1;
                        if(m_arr.length < 4){
                            errorMessage = "第"+paperNo+"题选项少于2个,无法导入";
                            break flag;
                        }
                    } else if ("多选题]".equals(t_s)) {
                        qi.setSubjectType(1);
                        paperNo = paperNo + 1;
                        if(m_arr.length < 4){
                            errorMessage = "第"+paperNo+"题选项少于2个,无法导入";
                            break flag;
                        }
                    } else if ("简答题]".equals(t_s)) {
                        qi.setSubjectType(3);
                        paperNo = paperNo + 1;
                    }else{
                        errorMessage = "第"+paperNo+"题题目类型错误,无法导入";
                        break flag;
                    }
                } else if (j == 1) {//标题和是否必填
                    //)超过4位就截取,因为很可能是标题号
                    int titleLastIndex = t_s.contains("@必填")?t_s.lastIndexOf("@"):t_s.length();
                    title = t_s.indexOf(")") <= 4 && t_s.indexOf(")") != -1 ? t_s.substring(t_s.indexOf(")") + 1, titleLastIndex) : t_s.substring(0, titleLastIndex);
                    qi.setTitle(title);

                    if (t_s.contains("@必填")) {
                        qi.setRequiredFields("1");
                    } else {
                        qi.setRequiredFields("0");
                    }
                }else{//标题以下,选项或者限制字数
                    if (qi.getSubjectType().equals(0) || qi.getSubjectType().equals(1)) {
                        if(t_s.contains("@必答")){
                            op.add(t_s.substring(0,t_s.indexOf("@必答")));
                            mustAnswer.add("1");
                        }else{
                            op.add(t_s);
                            mustAnswer.add("0");
                        }
                        qi.setOp(op);
                        qi.setMustAnswer(mustAnswer);
                        score.add(0);//分数暂时用不到,客户建议默认为0
                        qi.setScore(score);
                    }else if(qi.getSubjectType().equals(3)){
                        if(j == 3){
                            break ;
                        }

                        if (!t_s.contains("@字数限制") || t_s.lastIndexOf(")") == -1) {
                            errorMessage = "第"+paperNo+"题字数限制未填写,无法导入";
                            break flag;
                        } else {
                            qi.setWordRestriction(Integer.valueOf(t_s.substring(t_s.indexOf("@字数限制")+5,t_s.lastIndexOf(")"))));
                        }
                    }
                }
            }
            if(!StringUtils.isBlank(qi.getTitle())){//空行不加
                String json = new Gson().toJson(qi);
                arrayList.add(json);
            }
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("errorMessage", errorMessage);
        map.put("list", arrayList);
        if(StringUtils.isBlank(errorMessage)){
            map.put("flag", 0);//成功
        }else{
            map.put("flag", 1);//失败
        }
        return map;
    }


    @Override
    public void addCES(Integer[] ids,String estimateId,String cultivateId){
        estimateDao.addCES(ids,estimateId,cultivateId);
    }

    @Override
    public List<StudentEstimate> queryEC(StudentEstimate ec, Page pages){
        return estimateDao.queryEC(ec,pages);
    }

    @Override
    public void updateQEByPublish(String estimateId){
        estimateDao.updateQEByPublish(estimateId);
    }

    @Override
    public void updateESByPublish(String estimateId){
        estimateDao.updateESByPublish(estimateId);
    }

    @Override
    public int countEC(StudentEstimate ec){
        return estimateDao.countEC(ec);
    }

    @Override
    public void updateEstimateDataCode(){
        estimateDao.updateEstimateDataCode();
    }


    @Override
    public String getShowResult(QuestionnaireEstimate qi){
        String json = null ;
        try{
            //题目
            List<Questionnaire> qi_f = new Gson().fromJson( qi.getContent(), new TypeToken<List<Questionnaire>>() {}.getType());

            //获取所有已答卷的信息
            EstimateStudent t_es = new EstimateStudent();
            t_es.setEstimateId(Integer.valueOf(qi.getEstimateId()));
            t_es.setEstimateCode(2);
            List<EstimateStudent> es = estimateDao.queryEsById(t_es);


            //循环题目
            for(int y=0;y<qi_f.size();y++){
                List<int[]> li = new ArrayList<>();
                if(qi_f.get(y).getSubjectType().equals(2)){//判断是否矩阵
                    for(int z=0;z<qi_f.get(y).getOpt().size();z++){
                        int[] nums = new int[qi_f.get(y).getOp().size()];
                        li.add(nums);
                    }
                }else if(qi_f.get(y).getSubjectType().equals(0) || qi_f.get(y).getSubjectType().equals(1)){
                    int[] nums = new int[qi_f.get(y).getOp().size()];
                    li.add(nums);
                }

                //简答不参与统计
                if(!qi_f.get(y).getSubjectType().equals(3)){
                    //循环学生的答题信息
                    for(int k=0;k<es.size();k++){
                        //把每个学生的答卷信息转成对象
                        String e_an = es.get(k).getAnswer();
                        ArrayList<Questionnaire> qi_a = new Gson().fromJson(e_an, new TypeToken<List<Questionnaire>>() {}.getType());
                        List<QuestionnaireAnswer> answer = qi_a.get(y).getAnswer();
                        if(qi_a.get(y).getSubjectType().equals(0)){//判断是否单选
                            if(answer.size() != 0){
                                int no = Integer.valueOf(answer.get(0).getC_op());//获取答案第几项
                                li.get(0)[no-1] = li.get(0)[no-1] + 1 ;
                                qi_f.get(y).setValidNum(qi_f.get(y).getValidNum() + 1);
                            }
                        }else if(qi_a.get(y).getSubjectType().equals(1)){//判断是否多选
                            if(answer.size() != 0){
                                for(QuestionnaireAnswer an:answer){//多选需循环
                                    int no = Integer.valueOf(an.getC_op());//获取答案第几项
                                    li.get(0)[no-1] = li.get(0)[no-1] + 1 ;
                                }
                                qi_f.get(y).setValidNum(qi_f.get(y).getValidNum() + 1);
                            }
                        }else if(qi_a.get(y).getSubjectType().equals(2)){//判断是否矩阵
                            if(answer.size() != 0){
                                for(QuestionnaireAnswer an:answer){//矩阵需循环,同时分题赋值
                                    int no_t = Integer.valueOf(an.getC_opt());//获取答案第几题
                                    int no = Integer.valueOf(an.getC_op());//获取答案第几项
                                    li.get(no_t-1)[no-1] = li.get(no_t-1)[no-1] + 1 ;
                                }
                                qi_f.get(y).setValidNum(qi_f.get(y).getValidNum() + 1);
                            }
                        }
                    }
                    qi_f.get(y).setCountMessage(li);
                }
            }
            json =new Gson().toJson(qi_f);
        }catch (Exception e){
            logger.error(e.getMessage());
            json = e.getMessage();
        }
        return json;
    }


    @Override
    public List<StudentEstimate> queryEstimateResult(StudentEstimate ec){
        return estimateDao.queryEstimateResult(ec);
    }


    @Override
    public void saveQiByWeChat(EstimateStudent es){
        estimateDao.saveQiByWeChat(es);
    }


    @Override
    public List<Estimate> queryEstimateByWeChat(Estimate estimate, String studentId){
        return estimateDao.queryEstimateByWeChat(estimate,studentId);
    }

    @Override
    public void updatePublishStatus(QuestionnaireEstimate qi){
        estimateDao.updatePublishStatus(qi);
    }

    @Override
    public void deleteEstimates(int[] ids){
        estimateDao.deleteEstimates(ids);
    }
}
