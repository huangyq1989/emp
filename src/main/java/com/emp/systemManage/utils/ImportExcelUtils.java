package com.emp.systemManage.utils;


import com.emp.cultivateManage.entity.Cultivate;
import com.emp.employeeManage.entity.Employee;
import com.emp.estimateManage.entity.Questionnaire;
import com.emp.estimateManage.entity.QuestionnaireAnswer;
import com.emp.examinationManage.entity.Examination;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentEstimate;
import com.emp.studentManage.entity.StudentExamination;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.*;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Excel导入工具类
 */
public class ImportExcelUtils {


    //读取XLSX文件的数据转换成list对象
    public List<Object> readXlxs(String path,String type) throws IOException {
        InputStream is = new FileInputStream(path);

        XSSFWorkbook workbook = new XSSFWorkbook(is); //XSSF操作的是Excel2007以上的版本,对应文件的后缀名是xlsx
        List<Object> list = new ArrayList<Object>();
        // 工作表 Sheet
        XSSFSheet Sheet = workbook.getSheetAt(0);//获取第一个 Sheet
        // 循环行 Row
        if(PropertyUtil.getProperty("student.type", "defaultValue").equals(type)){
            for (int rowNum = 1; rowNum <= Sheet.getLastRowNum(); rowNum++) {
                XSSFRow row = Sheet.getRow(rowNum);
                if (row != null) {
                    XSSFCell xNo = row.getCell(0);//序号有些会自动加上.0,需判断转换
                    String xNoStr = xNo.toString();
                    String no = xNoStr.contains(".0")?NumberFormat.getInstance().format(xNo.getNumericCellValue()):xNoStr;
                    XSSFCell realName = row.getCell(1);
                    XSSFCell sex = row.getCell(2);
                    XSSFCell idCard = row.getCell(3);

                    XSSFCell xPhone = row.getCell(4);
                    String phone = null ;
                    if(xPhone.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){//判断是否是科学计算法
                        phone = new DecimalFormat("#").format(xPhone.getNumericCellValue());//是的话需转换
                    }else{
                        phone = getValue(xPhone);
                    }

                    XSSFCell unit = row.getCell(5);
                    XSSFCell department = row.getCell(6);
                    XSSFCell job = row.getCell(7);
                    XSSFCell email = row.getCell(8);

                    Student student = new Student();
                    student.setNo(no);
                    student.setRealName(getValue(realName));
                    student.setTempSex(getValue(sex));
                    student.setIdCard(getValue(idCard));
                    student.setPhone(phone);
                    student.setUnit(getValue(unit));
                    student.setDepartment(getValue(department));
                    student.setJob(getValue(job));
                    student.setEmail(getValue(email));
                    list.add(student);
                }
            }
        }else if(PropertyUtil.getProperty("cultivate.type", "defaultValue").equals(type)){
            for (int rowNum = 1; rowNum <= Sheet.getLastRowNum(); rowNum++) {//此方法跟上面学员导入一样
                XSSFRow row = Sheet.getRow(rowNum);
                if (row != null) {
                    XSSFCell xNo = row.getCell(0);//序号有些会自动加上.0,需判断转换
                    String xNoStr = xNo.toString();
                    String no = xNoStr.contains(".0")?NumberFormat.getInstance().format(xNo.getNumericCellValue()):xNoStr;
                    XSSFCell realName = row.getCell(1);
                    XSSFCell sex = row.getCell(2);
                    XSSFCell idCard = row.getCell(3);

                    XSSFCell xPhone = row.getCell(4);
                    String phone = null ;
                    if(xPhone.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){//判断是否是科学计算法
                        phone = new DecimalFormat("#").format(xPhone.getNumericCellValue());//是的话需转换
                    }else{
                        phone = getValue(xPhone);
                    }

                    XSSFCell unit = row.getCell(5);
                    XSSFCell department = row.getCell(6);
                    XSSFCell job = row.getCell(7);
                    XSSFCell email = row.getCell(8);

                    Student student = new Student();
                    student.setNo(no);
                    student.setRealName(getValue(realName));
                    student.setIdCard(getValue(idCard));
                    student.setTempSex(getValue(sex));
                    student.setPhone(phone);
                    student.setUnit(getValue(unit));
                    student.setDepartment(getValue(department));
                    student.setJob(getValue(job));
                    student.setEmail(getValue(email));
                    list.add(student);
                }
            }
        }else if(PropertyUtil.getProperty("sendNode.type", "defaultValue").equals(type)){
            for (int rowNum = 1; rowNum <= Sheet.getLastRowNum(); rowNum++) {
                XSSFRow row = Sheet.getRow(rowNum);
                if (row != null) {
                    XSSFCell xNo = row.getCell(0);//序号有些会自动加上.0,需判断转换
                    String xNoStr = xNo.toString();
                    String no = xNoStr.contains(".0")?NumberFormat.getInstance().format(xNo.getNumericCellValue()):xNoStr;
                    XSSFCell realName = row.getCell(1);

                    XSSFCell xPhone = row.getCell(2);
                    String phone = null ;
                    if(xPhone.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){//判断是否是科学计算法
                        phone = new DecimalFormat("#").format(xPhone.getNumericCellValue());//是的话需转换
                    }else{
                        phone = getValue(xPhone);
                    }

                    Student student = new Student();
                    student.setNo(no);
                    student.setRealName(getValue(realName));
                    student.setPhone(phone);
                    list.add(student);
                }
            }
        }else if(PropertyUtil.getProperty("employee.type", "defaultValue").equals(type)){
            for (int rowNum = 1; rowNum <= Sheet.getLastRowNum(); rowNum++) {
                XSSFRow row = Sheet.getRow(rowNum);
                if (row != null) {
                    XSSFCell xNo = row.getCell(0);//序号有些会自动加上.0,需判断转换
                    String xNoStr = xNo.toString();
                    String no = xNoStr.contains(".0")?NumberFormat.getInstance().format(xNo.getNumericCellValue()):xNoStr;
                    XSSFCell realName = row.getCell(1);
                    XSSFCell sex = row.getCell(2);

                    XSSFCell xPhone = row.getCell(3);
                    String phone = null ;
                    if(xPhone.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){//判断是否是科学计算法
                        phone = new DecimalFormat("#").format(xPhone.getNumericCellValue());//是的话需转换
                    }else{
                        phone = getValue(xPhone);
                    }

                    XSSFCell email = row.getCell(4);
                    XSSFCell userName = row.getCell(5);
                    XSSFCell password = row.getCell(6);

                    Employee employee = new Employee();
                    employee.setNo(no);
                    employee.setRealName(getValue(realName));
                    employee.setTempSex(getValue(sex));
                    employee.setPhone(phone);
                    employee.setEmail(getValue(email));
                    employee.setUserName(getValue(userName));
                    employee.setPassword(getValue(password));
                    list.add(employee);
                }
            }
        }
        return list;
    }



    //把对象转成XLSX存储在临时文件夹,返回路径
    public static String writeXlxs(Object object,String type,String name) throws IOException {
        String tempPath = PropertyUtil.getProperty("temp.path", "defaultValue");
        //创建工作簿
        XSSFWorkbook xssfWorkbook = new XSSFWorkbook();
        //创建工作表
        XSSFSheet sheet = xssfWorkbook.createSheet();
        if(type.equals(PropertyUtil.getProperty("student.type", "defaultValue"))){
            xssfWorkbook.setSheetName(0,name);
            //创建表头
            XSSFRow head = sheet.createRow(0);
            String[] heads = {"学号","姓名","性别","身份证号码","手机号码","单位","部门","职务","电子邮箱","备注"};
            for(int i = 0;i < heads.length ;i++){
                XSSFCell cell = head.createCell(i);
                cell.setCellValue(heads[i]);
            }
            List<Student> list = (List<Student>)object;
            for (int i = 1;i <= list.size();i++) {
                Student student = list.get(i - 1);
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);
                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(student.getId());
                cell = row.createCell(1);
                cell.setCellValue(student.getRealName());
                cell = row.createCell(2);
                cell.setCellValue(student.getSex() == 0?"男":"女");
                cell = row.createCell(3);
                cell.setCellValue(student.getIdCard());
                cell = row.createCell(4);
                cell.setCellValue(student.getPhone());
                cell = row.createCell(5);
                cell.setCellValue(student.getUnit());
                cell = row.createCell(6);
                cell.setCellValue(student.getDepartment());
                cell = row.createCell(7);
                cell.setCellValue(student.getJob());
                cell = row.createCell(8);
                cell.setCellValue(student.getEmail());
                cell = row.createCell(9);
                cell.setCellValue(student.getRemark());
            }
        }else if(type.equals(PropertyUtil.getProperty("cultivate.type", "defaultValue"))){
            xssfWorkbook.setSheetName(0,name);
            //创建表头
            XSSFRow head = sheet.createRow(0);
            String[] heads = {"序号","培训名称","培训类型","培训开始时间","培训结束时间","培训人数","培训状态"};
            for(int i = 0;i < heads.length ;i++){
                XSSFCell cell = head.createCell(i);
                cell.setCellValue(heads[i]);
            }
            List<Cultivate> list = (List<Cultivate>)object;
            for (int i = 1;i <= list.size();i++) {
                Cultivate cultivate = list.get(i - 1);
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);
                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(cultivate.getId());
                cell = row.createCell(1);
                cell.setCellValue(cultivate.getCultivateName());
                cell = row.createCell(2);
                cell.setCellValue(cultivate.getCultivateType());
                cell = row.createCell(3);
                String time = cultivate.getBeginTime();
                time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                cell = row.createCell(4);
                time = cultivate.getEndTime();
                time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                cell = row.createCell(5);
                cell.setCellValue(cultivate.getCultivateNum()==null?0:cultivate.getCultivateNum());
                String code = null ;
                if(cultivate.getCultivateDataCode()== 1){
                    code = "进行中";
                }else if(cultivate.getCultivateDataCode()== 2){
                    code = "已结束";
                }else{
                    code = "未开始";
                }
                cell = row.createCell(6);
                cell.setCellValue(code);
            }
        }else if(type.equals(PropertyUtil.getProperty("examination.type", "defaultValue"))){
            xssfWorkbook.setSheetName(0,name);
            //创建表头
            XSSFRow head = sheet.createRow(0);
            String[] heads = {"序号","培训名称","培训类型","培训开始时间","培训结束时间","考试时间","考试时限(分钟)","考试状态","补考次数","应考人数","实考人数","及格人数","需补考人数","已补考人数"};
            for(int i = 0;i < heads.length ;i++){
                XSSFCell cell = head.createCell(i);
                cell.setCellValue(heads[i]);
            }
            List<Examination> list = (List<Examination>)object;
            for (int i = 1;i <= list.size();i++) {
                Examination examination = list.get(i - 1);
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);
                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(examination.getId());
                cell = row.createCell(1);
                cell.setCellValue(examination.getCultivateName());
                cell = row.createCell(2);
                cell.setCellValue(examination.getCultivateType());
                cell = row.createCell(3);
                String time = examination.getBeginTime();
                time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                cell = row.createCell(4);
                time = examination.getEndTime();
                time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);



                cell = row.createCell(5);
                time = examination.getExaminationTime();
                time = time==null?"":time.substring(0,time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                cell = row.createCell(6);
                cell.setCellValue(examination.getExaminationTimeLimit());
                cell = row.createCell(7);
                String code = null ;
                if(examination.getExaminationDataCode()== 1){
                    code = "进行中";
                }else if(examination.getExaminationDataCode()== 2){
                    code = "已结束";
                }else{
                    code = "未开始";
                }
                cell.setCellValue(code);
                cell = row.createCell(8);
                cell.setCellValue(examination.getMakeupNum());
                cell = row.createCell(9);
                cell.setCellValue(examination.getExaminationNum());
                cell = row.createCell(10);
                cell.setCellValue(examination.getAlreadyExaminationNum());
                cell = row.createCell(11);
                cell.setCellValue(examination.getPassingNum());
                cell = row.createCell(12);
                cell.setCellValue(examination.getNeedMakeUpNum());
                cell = row.createCell(13);
                cell.setCellValue(examination.getAlreadyMakeUpNum());
            }
        }else if(type.equals(PropertyUtil.getProperty("examination.ec.type", "defaultValue"))){
            xssfWorkbook.setSheetName(0,name);
            //创建表头
            XSSFRow head = sheet.createRow(0);
            String[] heads = {"学号","姓名","手机","单位","考试成绩","是否及格","发布成绩","补考次数","发布证书","证书编号"};
            for(int i = 0;i < heads.length ;i++){
                XSSFCell cell = head.createCell(i);
                cell.setCellValue(heads[i]);
            }
            List<StudentExamination> list = (List<StudentExamination>)object;
            for (int i = 1;i <= list.size();i++) {
                StudentExamination ses = list.get(i - 1);
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);
                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(ses.getStudentId());
                cell = row.createCell(1);
                cell.setCellValue(ses.getRealName());
                cell = row.createCell(2);
                cell.setCellValue(ses.getPhone());
                cell = row.createCell(3);
                cell.setCellValue(ses.getUnit());
                cell = row.createCell(4);
                String score = null;
                if(ses.getScore() != null){
                    score = ses.getScore();
                }else{
                    score = "没有成绩";
                }
                cell.setCellValue(score);
                cell = row.createCell(5);
                String isPassing = null;
                if(ses.getIsPassing() == null){
                    isPassing = "没有成绩";
                }else{
                    if(ses.getIsPassing() == 0){
                        isPassing = "不及格";
                    }else if(ses.getIsPassing() == 1){
                        isPassing = "及格";
                    }
                }
                cell.setCellValue(isPassing);

                cell = row.createCell(6);
                String isRelease = null;
                if(Objects.equals(0,ses.getIsRelease())){
                    isRelease = "否";
                }else{
                    isRelease = "是";
                }
                cell.setCellValue(isRelease);

                cell = row.createCell(7);
                cell.setCellValue(ses.getStuMakeUpNum());

                cell = row.createCell(8);
                String isCertificateNo = null;
                if(Objects.equals(0,ses.getIsCertificateNo())){
                    isCertificateNo = "否";
                }else{
                    isCertificateNo = "是";
                }
                cell.setCellValue(isCertificateNo);

                cell = row.createCell(9);
                cell.setCellValue(ses.getCertificateNo());
            }
        }else if(type.equals(PropertyUtil.getProperty("employee.type", "defaultValue"))){
            xssfWorkbook.setSheetName(0,name);
            //创建表头
            XSSFRow head = sheet.createRow(0);
            String[] heads = {"账号ID","姓名","性别","账号","手机","电子邮箱"};
            for(int i = 0;i < heads.length ;i++){
                XSSFCell cell = head.createCell(i);
                cell.setCellValue(heads[i]);
            }
            List<Employee> list = (List<Employee>)object;
            for (int i = 1;i <= list.size();i++) {
                Employee employee = list.get(i - 1);
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);
                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(employee.getId());
                cell = row.createCell(1);
                cell.setCellValue(employee.getRealName());
                cell = row.createCell(2);
                cell.setCellValue(employee.getSex() == 0?"男":"女");
                cell = row.createCell(3);
                cell.setCellValue(employee.getUserName());
                cell = row.createCell(4);
                cell.setCellValue(employee.getPhone());
                cell = row.createCell(5);
                cell.setCellValue(employee.getEmail());
            }
        }else if(type.equals(PropertyUtil.getProperty("estimateResult.type", "defaultValue"))) {
            /**
             *  导出评估结果原始结果,规则如下:
             * 1.单选:题目 和 只显示第几个答案被选择了(4代表第四个答案)
             * 2.简答:题目 和 显示作答填写的信息
             * 3.矩阵:显示每个行标题 , 然后每个行标题显示第几个答案被选择了(3代表第三个被选中)
             * 4.多选:显示每个选项 , 和是否被选中(0代表没选中   1代表选中)
             * */
            Map<String, Object> map = (HashMap<String, Object>) object;

            xssfWorkbook.setSheetName(0, name);


            //1.创建表头
            XSSFRow head = sheet.createRow(0);
            XSSFCell headCell = head.createCell(0);
            headCell.setCellValue("姓名");
            headCell = head.createCell(1);
            headCell.setCellValue("提交答卷时间");
            int headNo = 2;
            //题目
            String content = (String) map.get("content");
            List<Questionnaire> qi_content = new Gson().fromJson(content, new TypeToken<List<Questionnaire>>() {
            }.getType());
            for (int i = 0; i < qi_content.size(); i++) {
                //每道题
                Questionnaire qi = qi_content.get(i);

                if (qi.getSubjectType().equals(0) || qi.getSubjectType().equals(3)) {//单选和简答:显示题目
                    headCell = head.createCell(headNo);
                    headCell.setCellValue((i + 1) + "、" + qi.getTitle());
                    headNo++;
                } else if (qi.getSubjectType().equals(1)) {//多选:显示每个选项
                    List<String> op = qi.getOp();
                    for (int j = 0; j < op.size(); j++) {
                        headCell = head.createCell(headNo);
                        headCell.setCellValue((i + 1) + "、" + "(" + op.get(j) + ")");
                        headNo++;
                    }
                } else if (qi.getSubjectType().equals(2)) {//矩阵:显示每个行标题
                    List<String> opt = qi.getOpt();
                    for (int h = 0; h < opt.size(); h++) {
                        headCell = head.createCell(headNo);
                        headCell.setCellValue((i + 1) + "、" + "(" + opt.get(h) + ")");
                        headNo++;
                    }
                }
            }


            //2.创建内容体
            List<StudentEstimate> ses = (List<StudentEstimate>) map.get("Ses");
            for (int i = 1; i <= ses.size(); i++) {
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet.createRow(i);

                StudentEstimate se = ses.get(i - 1);

                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(se.getRealName());
                cell = row.createCell(1);
                String time = se.getEstimateTime();
                time = time.substring(0, time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                int contentNo = 2;


                List<Questionnaire> qi_answer = new Gson().fromJson(se.getAnswer(), new TypeToken<List<Questionnaire>>() {
                }.getType());
                for (int k = 0; k < qi_answer.size(); k++) {
                    //每道题
                    Questionnaire qi = qi_answer.get(k);
                    //每题答案
                    List<QuestionnaireAnswer> qa = qi.getAnswer();

                    if (qi.getSubjectType().equals(0) || qi.getSubjectType().equals(3)) {//单选和简答:显示题目
                        cell = row.createCell(contentNo);
                        if (qi.getSubjectType().equals(0)) {//单选和简答:显示第几个答案(4代表第四个答案)
                            cell.setCellValue(qa.size() == 0 ? "" : qa.get(0).getC_op());
                        } else if (qi.getSubjectType().equals(3)) {//简答:显示答题内容
                            cell.setCellValue(qa.size() == 0 ? "" : qa.get(0).getC_detail());
                        }
                        contentNo++;
                    } else if (qi.getSubjectType().equals(1)) {//多选:每个选项是否被选中(0代表没选中   1代表选中)
                        List<String> op = qi.getOp();
                        for (int j = 0; j < op.size(); j++) {//循环每个选项
                            cell = row.createCell(contentNo);
                            if (qa.size() == 0) {//没作答
                                cell.setCellValue(0);
                            } else {
                                for (int p = 0; p < qa.size(); p++) {//循环每个答案
                                    if (qa.get(p).getC_op().equalsIgnoreCase((j + 1) + "")) {//选项号对比
                                        cell.setCellValue(1);
                                        break;
                                    } else {
                                        cell.setCellValue(0);
                                    }
                                }
                            }
                            contentNo++;
                        }
                    } else if (qi.getSubjectType().equals(2)) {//矩阵:每个行标题显示第几个答案被选择了(3代表第三个被选中)
                        List<String> opt = qi.getOpt();
                        for (int h = 0; h < opt.size(); h++) {//循环每个行标题
                            cell = row.createCell(contentNo);
                            if (qa.size() == 0) {//没作答
                                cell.setCellValue("");
                            } else {
                                for (int p = 0; p < qa.size(); p++) {//循环每个答案
                                    if (qa.get(p).getC_opt().equalsIgnoreCase((h + 1) + "")) {//行标题号对比
                                        cell.setCellValue(qa.get(p).getC_op());
                                        break;
                                    } else {
                                        cell.setCellValue("");
                                    }
                                }
                                contentNo++;
                            }
                        }
                    }
                }
            }








            //---------------第二个sheet,基本跟上面一样,只是在选项多了个(必答的内容)--------------
            XSSFSheet sheet2 = xssfWorkbook.createSheet(name.replace("原始结果","作答信息"));
            Map<String, Object> map1 = (HashMap<String, Object>) object;

            xssfWorkbook.setSheetName(0, name);


            //1.创建表头
            XSSFRow head1 = sheet2.createRow(0);
            XSSFCell headCell1 = head1.createCell(0);
            headCell1.setCellValue("姓名");
            headCell1 = head1.createCell(1);
            headCell1.setCellValue("提交答卷时间");
            int headNo1 = 2;
            //题目
            String content1 = (String) map1.get("content");
            List<Questionnaire> qi_content1 = new Gson().fromJson(content1, new TypeToken<List<Questionnaire>>() {
            }.getType());
            for (int i = 0; i < qi_content1.size(); i++) {
                //每道题
                Questionnaire qi = qi_content1.get(i);

                if (qi.getSubjectType().equals(0) || qi.getSubjectType().equals(3)) {//单选和简答:显示题目
                    headCell1 = head1.createCell(headNo1);
                    headCell1.setCellValue((i + 1) + "、" + qi.getTitle());
                    headNo1++;
                } else if (qi.getSubjectType().equals(1)) {//多选:显示每个选项
                    List<String> op = qi.getOp();
                    for (int j = 0; j < op.size(); j++) {
                        headCell1 = head1.createCell(headNo1);
                        headCell1.setCellValue((i + 1) + "、" + "(" + op.get(j) + ")");
                        headNo1++;
                    }
                } else if (qi.getSubjectType().equals(2)) {//矩阵:显示每个行标题
                    List<String> opt = qi.getOpt();
                    for (int h = 0; h < opt.size(); h++) {
                        headCell1 = head1.createCell(headNo1);
                        headCell1.setCellValue((i + 1) + "、" + "(" + opt.get(h) + ")");
                        headNo1++;
                    }
                }
            }


            //2.创建内容体
            List<StudentEstimate> ses1 = (List<StudentEstimate>) map1.get("Ses");
            for (int i = 1; i <= ses1.size(); i++) {
                //创建行,从第二行开始，所以for循环的i从1开始取
                XSSFRow row = sheet2.createRow(i);

                StudentEstimate se = ses1.get(i - 1);

                //创建单元格，并填充数据
                XSSFCell cell = row.createCell(0);
                cell.setCellValue(se.getRealName());
                cell = row.createCell(1);
                String time = se.getEstimateTime();
                time = time.substring(0, time.lastIndexOf("."));//去掉毫秒
                cell.setCellValue(time);
                int contentNo = 2;


                List<Questionnaire> qi_answer = new Gson().fromJson(se.getAnswer(), new TypeToken<List<Questionnaire>>() {
                }.getType());
                for (int k = 0; k < qi_answer.size(); k++) {
                    //每道题
                    Questionnaire qi = qi_answer.get(k);
                    //每题答案
                    List<QuestionnaireAnswer> qa = qi.getAnswer();

                    if (qi.getSubjectType().equals(0) || qi.getSubjectType().equals(3)) {//单选和简答:显示题目
                        cell = row.createCell(contentNo);
                        if (qi.getSubjectType().equals(0)) {//单选和简答:显示第几个答案(4代表第四个答案)
                            String c_detail = qa.get(0).getC_detail();
                            c_detail = StringUtils.isBlank(c_detail)?"":"("+c_detail+")";
                            cell.setCellValue(qa.size() == 0 ? "" : qa.get(0).getC_op()+c_detail);
                        } else if (qi.getSubjectType().equals(3)) {//简答:显示答题内容
                            cell.setCellValue(qa.size() == 0 ? "" : qa.get(0).getC_detail());
                        }
                        contentNo++;
                    } else if (qi.getSubjectType().equals(1)) {//多选:每个选项是否被选中(0代表没选中   1代表选中)
                        List<String> op = qi.getOp();
                        for (int j = 0; j < op.size(); j++) {//循环每个选项
                            cell = row.createCell(contentNo);
                            if (qa.size() == 0) {//没作答
                                cell.setCellValue(0);
                            } else {
                                for (int p = 0; p < qa.size(); p++) {//循环每个答案
                                    if (qa.get(p).getC_op().equalsIgnoreCase((j + 1) + "")) {//选项号对比
                                        String c_detail = qa.get(p).getC_detail();
                                        c_detail = StringUtils.isBlank(c_detail)?"":"("+c_detail+")";
                                        cell.setCellValue(1+c_detail);
                                        break;
                                    } else {
                                        cell.setCellValue(0);
                                    }
                                }
                            }
                            contentNo++;
                        }
                    } else if (qi.getSubjectType().equals(2)) {//矩阵:每个行标题显示第几个答案被选择了(3代表第三个被选中)
                        List<String> opt = qi.getOpt();
                        for (int h = 0; h < opt.size(); h++) {//循环每个行标题
                            cell = row.createCell(contentNo);
                            if (qa.size() == 0) {//没作答
                                cell.setCellValue("");
                            } else {
                                for (int p = 0; p < qa.size(); p++) {//循环每个答案
                                    if (qa.get(p).getC_opt().equalsIgnoreCase((h + 1) + "")) {//行标题号对比
                                        String c_detail = qa.get(p).getC_detail();
                                        c_detail = StringUtils.isBlank(c_detail)?"":"("+c_detail+")";
                                        cell.setCellValue(qa.get(p).getC_op()+c_detail);
                                        break;
                                    } else {
                                        cell.setCellValue("");
                                    }
                                }
                                contentNo++;
                            }
                        }
                    }
                }
            }

        }

        //创建临时文件的目录
        File file = new File(tempPath);
            if(!file.exists()){
            file.mkdirs();
        }
        String dateTime = new SimpleDateFormat("YYYYMMddHHmmssSSS").format(new Date());
        //临时文件路径/文件名
        String downloadPath = file + "/"  + name+"_"+dateTime+".xlsx";
        OutputStream outputStream = null;
        try {
            //使用FileOutputStream将内存中的数据写到本地，生成临时文件
            outputStream = new FileOutputStream(downloadPath);
            xssfWorkbook.write(outputStream);
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return downloadPath;
    }




    private String getValue(XSSFCell cell) {
        if (cell.getCellType() == cell.CELL_TYPE_BOOLEAN) {
            // 返回布尔类型的值
            return String.valueOf(cell.getBooleanCellValue());
        } else if (cell.getCellType() == cell.CELL_TYPE_NUMERIC) {
            // 返回数值类型的值
            return String.valueOf(cell.getNumericCellValue());
        } else {
            // 返回字符串类型的值
            return String.valueOf(cell.getStringCellValue());
        }
    }

}