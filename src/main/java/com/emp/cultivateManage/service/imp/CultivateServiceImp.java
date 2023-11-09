package com.emp.cultivateManage.service.imp;

import com.emp.cultivateManage.dao.CultivateDao;
import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.entity.CultivateGuide;
import com.emp.cultivateManage.entity.CultivateNote;
import com.emp.cultivateManage.entity.CultivateStudent;
import com.emp.cultivateManage.service.CultivateService;
import com.emp.estimateManage.dao.EstimateDao;
import com.emp.estimateManage.entity.Estimate;
import com.emp.estimateManage.entity.EstimateStudent;
import com.emp.examinationManage.dao.ExaminationDao;
import com.emp.examinationManage.entity.Examination;
import com.emp.examinationManage.entity.ExaminationStudent;
import com.emp.studentManage.dao.StudentDao;
import com.emp.studentManage.entity.Student;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PropertyUtil;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class CultivateServiceImp implements CultivateService {

    private Logger logger = Logger.getLogger(CultivateService.class);

    @Autowired
    private CultivateDao cultivateDao;

    @Autowired
    private StudentDao studentDao;

    @Autowired
    private ExaminationDao examinationDao;

    @Autowired
    private EstimateDao estimateDao;

    @Override
    public List<Cultivate> queryCultivateByLike(Cultivate cultivate, Page pages){
        return cultivateDao.queryCultivateByLike(cultivate,pages);
    }

    @Override
    public int countCultivateByLike(Cultivate cultivate){
        return cultivateDao.countCultivateByLike(cultivate);
    }

    @Override
    public List<Cultivate> queryCultivateByCheck(int[] ids){
        return cultivateDao.queryCultivateByCheck(ids);
    }

    @Override
    public int queryAutoId(){
        return cultivateDao.queryAutoId();
    }

    @Override
    public List<Cultivate> queryCultivateByEquals(Cultivate cultivate){
        return cultivateDao.queryCultivateByEquals(cultivate);
    }

    @Override
    public void insertCultivate(Cultivate cultivate){
        cultivateDao.insertCultivate(cultivate);
    }


    @Override
    public void insertCs(CultivateStudent cs){
        cultivateDao.insertCs(cs);
    }


    @Override
    public void updateCultivate(Cultivate cultivate){
        cultivateDao.updateCultivate(cultivate);
    }

    @Override
    public void updateCultivateStatus(int[] ids){
        cultivateDao.updateCultivateStatus(ids);
    }

    @Override
    public void deleteCultivates(int[] ids){
        cultivateDao.deleteCultivates(ids);
    }

    @Override
    //读取文件把学员关联到培训表
    public Map<String,Object> importCS(String path,String cultivateId,String checkType) throws IOException, SQLException {
        Student student = null;
        List<Student> list = (List<Student>)(List)new ImportExcelUtils().readXlxs(path, PropertyUtil.getProperty("cultivate.type", "defaultValue"));
        int count = list.size(); //总导入数
        int failNum = 0;//失败数
        for (int i = 0; i < list.size(); i++) {
            student = list.get(i);

            //校验姓名
            if(StringUtils.isBlank(student.getRealName())){
                student.setErrorMsg("姓名不能为空");
                failNum++;
                continue;
            }
            //校验手机号码
            if(!StringUtils.isBlank(student.getPhone())){
                if(!CommonUtils.isMobileNO(student.getPhone())){
                    failNum++;
                    student.setErrorMsg("手机号码错误");
                    continue;
                }
            }else{
                student.setErrorMsg("手机号码不能为空");
                failNum++;
                continue;
            }
            //校验电子邮箱
            if(!StringUtils.isBlank(student.getEmail())){
                if(!CommonUtils.isEmail(student.getEmail())){
                    student.setErrorMsg("电子邮箱错误");
                    failNum++;
                    continue;
                }
            }
            //校验身份证号码
            if(!StringUtils.isBlank(student.getIdCard())){
                if(!CommonUtils.checkIDCard(student.getIdCard())){
                    student.setErrorMsg("身份证号码错误");
                    failNum++;
                    continue;
                }
            }

            //转换'性别(0男  1女)'
            if("男".equals(student.getTempSex())){
                student.setSex(0);
            }else{
                student.setSex(1);
            }
            student.setRemark("");

            //查询学员是否存在
            Student sParam = new Student();
            sParam.setRealName(student.getRealName());
            List<Student> students = studentDao.queryStudentByEquals(sParam);
            if(students.size() == 0){//不存在学员需要创建
                sParam.setRealName(null);
                sParam.setPhone(student.getPhone());
                students = studentDao.queryStudentByEquals(sParam);//新增学员的时候校验手机号码是否存在
                if(students.size() == 0){
                    student.setErrorMsg("成功,自动创建学员");
                    continue;
                }else{
                    student.setErrorMsg("新学员手机号码已存在");
                    failNum++;
                    continue;
                }
            }
            if(StringUtils.isBlank(checkType) || !"addPage".equals(checkType)){// addPage来源于新增培训的时候顺便导入学员标识
                //查询学员是否已经在培训学员关联表
                CultivateStudent csParam = new CultivateStudent();
                csParam.setStudentId(students.get(0).getId());
                csParam.setCultivateId(Integer.valueOf(cultivateId));
                int csNum = cultivateDao.countCsById(csParam);
                if(csNum != 0){
                    student.setErrorMsg("学员已在该培训中");
                    failNum++;
                    continue;
                }
            }
            student.setErrorMsg("成功"); //没错误的学员都给个成功
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("flag", 0);//成功
        map.put("count", count);
        map.put("failNum", failNum);
        map.put("list", list);
        return map;
    }


    //批量保存账号(导入保存)
    public String saveImportData(String sendData, String cultivateId){
        try {
            //转List对象
            ArrayList<Student> students = new ArrayList<Student>();
            Type listType = new TypeToken<List<Student>>() {}.getType();
            students = new Gson().fromJson(sendData, listType);
            for (Student s : students) {
                Student sParam = new Student();
                sParam.setRealName(s.getRealName());
                List<Student> l_student = studentDao.queryStudentByEquals(sParam);
                if(l_student.size() == 0){//学员没数据先新建再关联
                    studentDao.insertStudent(s);
                }else{
                    s.setId(l_student.get(0).getId());
                }
                //查询学员是否已经在培训学员关联表
                CultivateStudent csParam = new CultivateStudent();
                csParam.setStudentId(s.getId());
                csParam.setCultivateId(Integer.valueOf(cultivateId));
                int csNum = cultivateDao.countCsById(csParam);
                if(csNum == 0){
                    //1.添加培训学员关联
                    cultivateDao.insertCs(csParam);
                }


                //2.添加该培训下所有考试学员
                Examination eParam = new Examination();
                if(StringUtils.isNoneBlank(cultivateId)){
                    eParam.setCultivateId(Integer.valueOf(cultivateId));
                }
                List<Examination> examinations = examinationDao.queryExaminationByEquals(eParam,null);
                for(Examination e:examinations){
                    Examination examination = new Examination();
                    examination.setId(e.getId());
                    examination = examinationDao.queryExaminationByEquals(examination,null).get(0);
                    //再检测一遍是否已经存在了该考试中
                    List<Integer> tempList1 = new ArrayList();
                    ExaminationStudent esParam = new ExaminationStudent();
                    esParam.setStudentId(s.getId());
                    esParam.setExaminationId(e.getId());
                    int esNum = examinationDao.countEsById(esParam);
                    if(esNum == 0){
                        tempList1.add(esParam.getStudentId());
                    }

                    Integer[] newArr1 = tempList1.toArray(new Integer[0]);
                    if(newArr1.length != 0){examinationDao.addCES(newArr1,e.getId().toString() ,examination.getCultivateId().toString());}
                }



                //3.添加该培训下所有评估学员
                Estimate etParam = new Estimate();
                if(StringUtils.isNoneBlank(cultivateId)){
                    etParam.setCultivateId(Integer.valueOf(cultivateId));
                }
                List<Estimate> estimates = estimateDao.queryEstimateByLike(etParam,null);
                for(Estimate e:estimates){
                    Estimate estimate = new Estimate();
                    estimate.setId(e.getId());
                    estimate = estimateDao.queryEstimateByLike(estimate,null).get(0);
                    //再检测一遍是否已经存在了该考试中
                    List<Integer> tempList1 = new ArrayList();
                    EstimateStudent esParam = new EstimateStudent();
                    esParam.setStudentId(s.getId());
                    esParam.setEstimateId(e.getId());
                    int eesNum = estimateDao.countEsById(esParam);
                    if(eesNum == 0){
                        tempList1.add(esParam.getStudentId());
                    }
                    Integer[] newArr1 = tempList1.toArray(new Integer[0]);
                    if(newArr1.length != 0){estimateDao.addCES(newArr1,e.getId().toString() ,estimate.getCultivateId().toString());}
                }
            }
            return "0";
        }catch (Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    @Override
    public List<Student> queryCSByLike(Student student, String cultivateId, Page pages,String type){
        return cultivateDao.queryCSByLike(student,cultivateId,pages,type);
    }


    @Override
    public List<Student> queryCsByCheck(int[] ids){
        return cultivateDao.queryCsByCheck(ids);
    }


    @Override
    public int countCSByLike(Student student,String cultivateId,String type){
        return cultivateDao.countCSByLike(student,cultivateId,type);
    }


    @Override
    public int countCsById(CultivateStudent cs){
        return cultivateDao.countCsById(cs);
    }


    @Override
    public void addCS(int[] ids,String cultivateId){
        //添加培训学员-再检测一遍是否已经存在了该培训中
        List<Integer> tempList = new ArrayList();
        for(int i=0;i<ids.length;i++){
            CultivateStudent csParam = new CultivateStudent();
            csParam.setStudentId(ids[i]);
            csParam.setCultivateId(Integer.valueOf(cultivateId));
            int csNum = cultivateDao.countCsById(csParam);
            if(csNum == 0){
                tempList.add(csParam.getStudentId());
            }
        }
        Integer[] newArr = tempList.toArray(new Integer[0]);
        if(newArr.length != 0){cultivateDao.addCS(newArr,cultivateId);}


        //添加考试学员
        Examination eParam = new Examination();
        if(StringUtils.isNoneBlank(cultivateId)){
            eParam.setCultivateId(Integer.valueOf(cultivateId));
        }
        List<Examination> examinations = examinationDao.queryExaminationByEquals(eParam,null);
        for(Examination e:examinations){
            Examination examination = new Examination();
            examination.setId(e.getId());
            examination = examinationDao.queryExaminationByEquals(examination,null).get(0);
            //再检测一遍是否已经存在了该考试中
            List<Integer> tempList1 = new ArrayList();
            for(int i=0;i<ids.length;i++){
                ExaminationStudent esParam = new ExaminationStudent();
                esParam.setStudentId(ids[i]);
                esParam.setExaminationId(e.getId());
                int csNum = examinationDao.countEsById(esParam);
                if(csNum == 0){
                    tempList1.add(esParam.getStudentId());
                }
            }
            Integer[] newArr1 = tempList1.toArray(new Integer[0]);
            if(newArr1.length != 0){examinationDao.addCES(newArr1,e.getId().toString() ,examination.getCultivateId().toString());}
        }


        //添加评估学员
        Estimate etParam = new Estimate();
        if(StringUtils.isNoneBlank(cultivateId)){
            etParam.setCultivateId(Integer.valueOf(cultivateId));
        }
        List<Estimate> estimates = estimateDao.queryEstimateByLike(etParam,null);
        for(Estimate e:estimates){
            Estimate estimate = new Estimate();
            estimate.setId(e.getId());
            estimate = estimateDao.queryEstimateByLike(estimate,null).get(0);
            //再检测一遍是否已经存在了该考试中
            List<Integer> tempList1 = new ArrayList();
            for(int i=0;i<ids.length;i++){
                EstimateStudent esParam = new EstimateStudent();
                esParam.setStudentId(ids[i]);
                esParam.setEstimateId(e.getId());
                int csNum = estimateDao.countEsById(esParam);
                if(csNum == 0){
                    tempList1.add(esParam.getStudentId());
                }
            }
            Integer[] newArr1 = tempList1.toArray(new Integer[0]);
            if(newArr1.length != 0){estimateDao.addCES(newArr1,e.getId().toString() ,estimate.getCultivateId().toString());}
        }
    }


    @Override
    public void deleteCS(int[] ids,String cultivateId){
        //删除培训学员
        cultivateDao.deleteCS(ids,cultivateId);
        //删除考试学员
        examinationDao.deleteCES(ids,cultivateId);
        //删除评估学员
        estimateDao.deleteCES(ids,cultivateId);
    }


    @Override
    public void saveSendData(CultivateNote note){
        cultivateDao.saveSendData(note);
    }


    @Override
    public void updateSendData(CultivateNote note){
        cultivateDao.updateSendData(note);
    }


    @Override
    public List<CultivateNote> querySendData(CultivateNote note,Page pages){
        return cultivateDao.querySendData(note,pages);
    }

    @Override
    public List<CultivateNote> queryTaskSendData(CultivateNote note){
        return cultivateDao.queryTaskSendData(note);
    }

    @Override
    public int countSendData(CultivateNote note){
        return cultivateDao.countSendData(note);
    }


    @Override
    //读取文件检验收件人,返回给前端
    public Map<String,Object> importSendPeople(String path) throws IOException {
        Student student = null;
        List<Student> list = (List<Student>)(List)new ImportExcelUtils().readXlxs(path, PropertyUtil.getProperty("sendNode.type", "defaultValue"));
        int count = list.size(); //总导入数
        int failNum = 0;//失败数
        for (int i = 0; i < list.size(); i++) {
            student = list.get(i);

            //校验姓名
            if(StringUtils.isBlank(student.getRealName())){
                student.setErrorMsg("姓名不能为空");
                failNum++;
                continue;
            }
            //校验手机号码
            if(StringUtils.isBlank(student.getPhone())){
                student.setErrorMsg("手机号码不能为空");
                failNum++;
                continue;
            }else{
                if(!CommonUtils.isMobileNO(student.getPhone())){
                    student.setErrorMsg("手机号码格式错误");
                    failNum++;
                    continue;
                }
            }
            student.setErrorMsg("成功"); //没错误的学员都给个成功
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("flag", 0);//成功
        map.put("count", count);
        map.put("failNum", failNum);
        map.put("list", list);
        return map;
    }


    @Override
    public void updateCultivateDataCode(){
        cultivateDao.updateCultivateDataCode();
    }


    @Override
    public String queryGuideByWeChat(Cultivate cultivate){
        return cultivateDao.queryGuideByWeChat(cultivate);
    }

    @Override
    public List<CultivateGuide> queryCultivateGuideByLike(CultivateGuide cg, Page pages){
        return cultivateDao.queryCultivateGuideByLike(cg,pages);
    }

    @Override
    public int countCultivateGuideByLike(CultivateGuide cg){
        return cultivateDao.countCultivateGuideByLike(cg);
    }

    @Override
    public Map<String,Object> insertCultivateGuide(CultivateGuide cg){
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            cultivateDao.insertCultivateGuide(cg);
            map.put("flag", 0);//成功
            map.put("message", "");
            return map;
        }catch (Exception e){
            logger.error(e.getMessage());
            map.put("flag", 1);//失败
            map.put("message", e.getMessage());
            return map;
        }
    }

    @Override
    public int deleteCg(int cgId){
        return cultivateDao.deleteCg(cgId);
    }

    @Override
    public int deleteCgByCultivateId(int cultivateId){
        return cultivateDao.deleteCgByCultivateId(cultivateId);
    }

    @Override
    public List<Integer> queryLoseGuide(){
        return cultivateDao.queryLoseGuide();
    }
}
