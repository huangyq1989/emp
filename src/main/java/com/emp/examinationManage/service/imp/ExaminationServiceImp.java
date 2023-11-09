package com.emp.examinationManage.service.imp;

import com.emp.examinationManage.dao.ExaminationDao;
import com.emp.examinationManage.entity.Examination;
import com.emp.examinationManage.entity.ExaminationStudent;
import com.emp.examinationManage.entity.TestPaper;
import com.emp.examinationManage.entity.TestPaperExamination;
import com.emp.examinationManage.service.ExaminationService;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentExamination;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.WordFileUtils;
import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class ExaminationServiceImp implements ExaminationService {

    private Logger logger = Logger.getLogger(ExaminationServiceImp.class);

    @Autowired
    private ExaminationDao examinationDao;

    @Override
    public List<Examination> queryExaminationByLike(Examination examination, Page pages){
        return examinationDao.queryExaminationByLike(examination,pages);
    }

    @Override
    public int countExaminationByLike(Examination examination){
        return examinationDao.countExaminationByLike(examination);
    }

    @Override
    public List<Examination> queryExaminationByCheck(int[] ids){
        return examinationDao.queryExaminationByCheck(ids);
    }

    @Override
    public List<Examination> queryExaminationByEquals(Examination examination, Page pages){
        return examinationDao.queryExaminationByEquals(examination,pages);
    }

    @Override
    public int countExaminationByEquals(Examination examination){
        return examinationDao.countExaminationByEquals(examination);
    }

    @Override
    public void insertExamination(Examination examination){
        examinationDao.insertExamination(examination);
    }

    @Override
    public Map<String,Object> insertExaminationAll(Examination examination,String totalScore) throws Exception{
        Map<String,Object> map = new HashMap<String,Object>();

        Examination eParam = new Examination();
        if(StringUtils.isNoneBlank(examination.getExaminationName())){
            eParam.setExaminationName(examination.getExaminationName());
        }
        List<Examination> examination1 = examinationDao.queryExaminationByEquals(eParam,null);
        if(examination1.size() != 0){
            map.put("rCode", 2);
            map.put("detail", "考试名称已存在");
        }else{
            examinationDao.insertExamination(examination);
            if(examination.getId() != null){
                examinationDao.addES(examination.getCultivateId().toString(),examination.getId().toString());//添加培训学员到考试中间表

                if(!StringUtils.isBlank(examination.getTestPaperData())){//保存试卷
                    TestPaperExamination te = new TestPaperExamination();
                    te.setContent(examination.getTestPaperData());
                    te.setTotalScore(Float.parseFloat(totalScore));
                    te.setExaminationId(examination.getId());
                    examinationDao.insertTestPaper(te);
                }

                map.put("rCode", 0);
                map.put("detail", "添加考试成功");
            }else{
                map.put("rCode", 1);
                map.put("detail", "添加考试失败");
            }
        }
        return map;
    }


    @Override
    public void updateExamination(Examination examination,boolean changeFlag,String totalScore)throws Exception{
        if(changeFlag){//true为需要跟换培训id
            //删除考试原学员信息
            examinationDao.deleteCESById(examination.getId().toString());
            //添加新培训考试学员
            examinationDao.addES(examination.getCultivateId().toString(),examination.getId().toString());
        }
        //修改考试信息
        examinationDao.updateExamination(examination);
        if(!StringUtils.isBlank(examination.getTestPaperData())){//修改试卷
            TestPaperExamination te = new TestPaperExamination();
            te.setContent(examination.getTestPaperData());
            te.setIsPublish(0);//还原为未发布
            te.setTotalScore(Float.parseFloat(totalScore));
            te.setExaminationId(examination.getId());
            examinationDao.updateTestPaper(te);
        }
    }

    @Override
    public List<Student> queryESByLike(Student student, String cultivateId, Page pages, String type){
        return examinationDao.queryESByLike(student,cultivateId,pages,type);
    }

    @Override
    public int countESByLike(Student student,String cultivateId, String type){
        return examinationDao.countESByLike(student,cultivateId,type);
    }


    @Override
    public int countEsById(ExaminationStudent es){
        return examinationDao.countEsById(es);
    }


    @Override
    public void addES(String cultivateId,String examinationId){
        examinationDao.addES(cultivateId,examinationId);
    }


    @Override
    public void addCES(Integer[] ids,String examinationId,String cultivateId){
        examinationDao.addCES(ids,examinationId,cultivateId);
    }


    @Override
    public TestPaperExamination queryTestPaper(String examinationId){
        return examinationDao.queryTestPaper(examinationId);
    }

    @Override
    public void updateTPByPublish(String examinationId){
        examinationDao.updateTPByPublish(examinationId);
    }

    @Override
    public TestPaperExamination queryTestPaperByWeChat(String examinationId,String studentId){
        return examinationDao.queryTestPaperByWeChat(examinationId,studentId);
    }

    @Override
    public void insertTestPaper(TestPaperExamination te){
        examinationDao.insertTestPaper(te);
    }

    @Override
    public void updateTestPaper(TestPaperExamination te){
        examinationDao.updateTestPaper(te);
    }

    @Override
    public void updateTestPaperBySave(TestPaperExamination te) throws Exception{
        examinationDao.updateTestPaper(te);
        //重置学员的答卷信息和评估信息
        examinationDao.updateESByPublish(te.getExaminationId().toString());
    }

    @Override
    public void addExaminationByCopy(Map<String, String> param){
        examinationDao.addExaminationByCopy(param);
    }


    @Override
    //读取word文件校验试题
    public Map<String,Object> importTestPaper(String path) throws IOException, SQLException {
        ArrayList<String> arrayList = new ArrayList<>();
        String errorMessage = "";
        int paperNo = 0;//第几题
        File wordFile = new File(path);
        String str = WordFileUtils.extractTextFromWordFile(wordFile);//读取文件获取内容
        str = str.substring(str.indexOf("导入内容:",0)+5,str.length());
        String[] arr = str.split("\\["); // 用[分割成几道题
        flag : for(int i=0;i<arr.length;i++){
            String title = null;
            String t_trueAnswer = null ;
            TestPaper tp = new TestPaper();
            List<String> op = new ArrayList<>();
            List<String> trueAnswer = new ArrayList<>();
            List<String> trueAnswer1 = new ArrayList<>();

            String[] m_arr = arr[i].split("\n"); // 用\n分割
            for(int j=0;j<m_arr.length;j++){

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

                if(j == 0){//试卷类型
                    if("单选题]".equals(t_s)){
                        tp.setSubjectType(0);
                        paperNo = paperNo + 1;
                        if(m_arr.length < 4){
                            errorMessage = "第"+paperNo+"题选项少于2个,无法导入";
                            break flag;
                        }
                    }else if("多选题]".equals(t_s)){
                        tp.setSubjectType(1);
                        paperNo = paperNo + 1;
                        if(m_arr.length < 4){
                            errorMessage = "第"+paperNo+"题选项少于2个,无法导入";
                            break flag;
                        }
                    }else if("判断题]".equals(t_s)){
                        tp.setSubjectType(2);
                        paperNo = paperNo + 1;
                    }else{
                        errorMessage = "第"+paperNo+"题题目类型错误,无法导入";
                        break flag;
                    }
                }else if(j == 1){//标题正确答案和分数
                    if (!t_s.contains("@(")) {
                        errorMessage = "第"+paperNo+"题没有正确答案,无法导入";
                        break flag;
                    }
                    if (!t_s.contains("{") || !t_s.contains("分}")) {
                        errorMessage = "第"+paperNo+"题没有分数,无法导入";
                        break flag;
                    }
                    //)超过4位就截取,因为很可能是标题号
                    title = t_s.indexOf(")")<=4&&t_s.indexOf(")")!=-1?t_s.substring(t_s.indexOf(")")+1,t_s.lastIndexOf("@")):t_s.substring(0,t_s.lastIndexOf("@"));
                    tp.setTitle(title);
                    tp.setScore(Double.parseDouble(t_s.substring(t_s.indexOf("{")+1,t_s.lastIndexOf("分}"))));
                    t_trueAnswer = t_s.substring(t_s.indexOf("@(")+2,t_s.lastIndexOf(")"));

                    //多选题的得分类型
                    if(tp.getSubjectType().equals(1)){
                        if (!t_s.contains("<得分类型:") || t_s.indexOf(">") == -1) {
                            errorMessage = "第"+paperNo+"题没有得分类型,无法导入";
                            break flag;
                        }
                        String sub = t_s.substring(t_s.indexOf("<得分类型:")+6,t_s.lastIndexOf(">"));
                        if(StringUtils.isBlank(sub)){
                            errorMessage = "第"+paperNo+"题得分类型错误,请检查";
                            break flag;
                        }else{
                            if("0".equalsIgnoreCase(sub) || "1".equalsIgnoreCase(sub)){
                                tp.setScoreType(Integer.valueOf(sub));
                            }else{
                                errorMessage = "第"+paperNo+"题得分类型只能为0或者1,请检查";
                                break flag;
                            }
                        }
                    }
                }else{//选项
                    if(!StringUtils.isBlank(t_s)){
                        if(tp.getSubjectType().equals(2) && j == 4 && t_s.indexOf("#]")==-1){//判断题超过3个选项不加直接进行下一循环,排除第三个选项其实是答题解析
                            break ;
                        }
                        if(t_s.indexOf("#]")!=-1){//答题解析(非必填),然后直接进入下一循环
                            tp.setAnswerAnalysis(t_s.substring(t_s.indexOf("#]")+2,t_s.length()));
                            break ;
                        }
                        op.add(t_s);
                        tp.setOp(op);
                    }
                }
            }
            if(!StringUtils.isBlank(tp.getTitle())){//空行不加
                //校验正确答案
                char[] temp_trueAnswer = t_trueAnswer.toCharArray();
                for(int k=0;k<temp_trueAnswer.length;k++){
                    String true_as = temp_trueAnswer[k]+"";
                    for(int g=0;g<tp.getOp().size();g++){
                        String no = tp.getOp().get(g);
                        no = no.substring(0,1);
                        if(true_as.equalsIgnoreCase(no)){
                            trueAnswer1.add((g+1)+"");
                            break;
                        }
                    }
                }
                trueAnswer = trueAnswer1.stream().distinct().collect(Collectors.toList());//去重
                if(trueAnswer.size() == 0){
                    errorMessage = "第"+paperNo+"题没有有效的答案,无法导入";
                    break flag;
                }
                tp.setTrueAnswer(trueAnswer);
                String json = new Gson().toJson(tp);
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
    public List<StudentExamination> queryEC(StudentExamination ec, Page pages){
        return examinationDao.queryEC(ec,pages);
    }


    @Override
    public int countEC(StudentExamination ec){
        return examinationDao.countEC(ec);
    }


    @Override
    public void updateECAllCode(String examinationId,String studentId){
        examinationDao.updateECAllCode(examinationId,studentId);
    }

    @Override
    public void updateECbyExamination(String examinationId,String studentId){
        examinationDao.updateECbyExamination(examinationId,studentId);
    }

    @Override
    public void updateExaminationDataCode(){
        examinationDao.updateExaminationDataCode();
    }

    @Override
    public void saveTpByWeChat(ExaminationStudent es){
        examinationDao.saveTpByWeChat(es);
    }

    @Override
    public void updateByReleaseEC(Examination examination,String reFlag){
        if("0".equalsIgnoreCase(reFlag)){//不发布
            examination.setIsRelease(0);
            examination.setReleaseTime(null);
        }else if("1".equalsIgnoreCase(reFlag)){//立即发布
            examination.setIsRelease(1);
        }else{//定时发布
            examination.setIsRelease(0);
        }
        examinationDao.updateByReleaseEC(examination);
    }


    @Override
    public void updateByReleaseCN(Examination examination,String reFlag){
        if("0".equalsIgnoreCase(reFlag)){//不发布
            examination.setIsCertificateNo(0);
            examination.setCertificateNoTime(null);
        }else if("1".equalsIgnoreCase(reFlag)){//立即发布
            examination.setIsCertificateNo(1);
        }else{//定时发布
            examination.setIsCertificateNo(0);
        }
        examinationDao.updateByReleaseCN(examination);
    }


    //定时任务发布证书和成绩
    @Override
    public void updateByTaskCNAndEC(){
        List<Examination> es = examinationDao.queryTaskReleaseEC();
        for(Examination e:es){
            e.setIsRelease(1);
            examinationDao.updateByReleaseEC(e);
        }

        es = examinationDao.queryTaskReleaseCN();
        for(Examination e:es){
            e.setIsCertificateNo(1);
            examinationDao.updateByReleaseCN(e);
        }
    }


    @Override
    public void updateECbyResit(String examinationId, String studentId){examinationDao.updateECbyResit(examinationId,studentId);}

    @Override
    public List<Examination> getExaminationByWeChat(Examination examination, String studentId, String type){
        return examinationDao.getExaminationByWeChat(examination,studentId,type);
    }

    @Override
    public void updateESByPublish(String examinationId){
        examinationDao.updateESByPublish(examinationId);
    }


    @Override
    public int queryEcCodeByWeChat(ExaminationStudent es){
        return examinationDao.queryEcCodeByWeChat(es);
    }


    @Override
    public String updatePublishStatus(String type, String examinationId){
        try{
            if("stop".equalsIgnoreCase(type)){
                //重置学员的答卷信息和评估信息
                examinationDao.updateESByPublish(examinationId);

                TestPaperExamination te = new TestPaperExamination();
                te.setExaminationId(Integer.valueOf(examinationId));
                te.setIsPublish(0);//修改为未发布
                examinationDao.updatePublishStatus(te);
            }
            return "0";
        }catch (Exception e){
            logger.error(e.getMessage());
            return "1";
        }
    }

    @Override
    public void deleteExaminations(int[] ids){
        examinationDao.deleteExaminations(ids);
    }

    @Override
    public void updateWillCloseTime(String examinationId, String studentId,String willCloseTime){examinationDao.updateWillCloseTime(examinationId,studentId,willCloseTime);}
}
