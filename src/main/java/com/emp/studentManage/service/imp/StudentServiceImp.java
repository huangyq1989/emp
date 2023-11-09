package com.emp.studentManage.service.imp;

import com.emp.studentManage.dao.StudentDao;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentCultivate;
import com.emp.studentManage.service.StudentService;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.CommonUtils;
import com.emp.systemManage.utils.ImportExcelUtils;
import com.emp.systemManage.utils.PropertyUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class StudentServiceImp implements StudentService {

    @Autowired
    private StudentDao studentDao;

    @Override
    public List<Student> queryStudentByLike(Student student, Page pages){
        return studentDao.queryStudentByLike(student,pages);
    }

    @Override
    public int countStudentByLike(Student student){
        return studentDao.countStudentByLike(student);
    }

    @Override
    public List<Student> queryStudentByCheck(int[] ids){
        return studentDao.queryStudentByCheck(ids);
    }

    @Override
    public int queryAutoId(){
        return studentDao.queryAutoId();
    }


    @Override
    public List<Student> queryStudentByEquals(Student student){
        return studentDao.queryStudentByEquals(student);
    }

    @Override
    public void insertStudent(Student student){
        studentDao.insertStudent(student);
    }


    @Override
    public void updateStudent(Student student){
        studentDao.updateStudent(student);
    }

    @Override
    public void updateStudentsStatus(int[] ids){
        studentDao.updateStudentsStatus(ids);
    }

    @Override
    public void deleteStudents(int[] ids){
        studentDao.deleteStudents(ids);
    }

    @Override
    //读取文件把导入学员到数据库
    public Map<String,Object> importStudents(String path) throws IOException, SQLException {
        Student student = null;
        List<Student> list = (List<Student>)(List)new ImportExcelUtils().readXlxs(path, PropertyUtil.getProperty("student.type", "defaultValue"));
        int count = list.size(); //总导入数
        int failNum = 0;//失败数
        for (int i = 0; i < list.size(); i++) {
            student = list.get(i);

            //校验姓名
            if(StringUtils.isBlank(student.getRealName())){
                student.setErrorMsg("姓名不能为空");
                failNum++;
                continue;
            }else{
                //查询是否已经存在数据库
                Student sParam = new Student();
                sParam.setRealName(student.getRealName());
                List<Student> students = studentDao.queryStudentByEquals(sParam);
                if(students.size() != 0){
                    student.setErrorMsg("学员已存在");
                    failNum++;
                    continue;
                }
            }
            //校验手机号码
            if(!StringUtils.isBlank(student.getPhone())){
                if(!CommonUtils.isMobileNO(student.getPhone())){
                    student.setErrorMsg("手机号码错误");
                    failNum++;
                    continue;
                }
                //查询是否已经存在数据库
                Student sParam = new Student();
                sParam.setPhone(student.getPhone());
                List<Student> students = studentDao.queryStudentByEquals(sParam);
                if(students.size() != 0){
                    student.setErrorMsg("手机号码已存在");
                    failNum++;
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
            //校验身份证
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
//            studentDao.insertStudent(student);//创建学员, 不在此保存,故注释
//            list.remove(student);
//            i = i-1;
            student.setErrorMsg("成功"); //没错误的学员都给个成功
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("flag", 0);//成功
        map.put("count", count);
        map.put("failNum", failNum);
        map.put("list", list);
        return map;
    }

    public List<StudentCultivate> querySC(StudentCultivate sc){
        return studentDao.querySC(sc);
    }
}
