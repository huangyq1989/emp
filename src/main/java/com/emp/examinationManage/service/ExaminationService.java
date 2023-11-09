package com.emp.examinationManage.service;

import com.emp.examinationManage.entity.Examination;
import com.emp.examinationManage.entity.ExaminationStudent;
import com.emp.examinationManage.entity.TestPaperExamination;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentExamination;
import com.emp.systemManage.entity.Page;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface ExaminationService {

    List<Examination> queryExaminationByLike(Examination examination, Page pages);

    int countExaminationByLike(Examination examination);

    List<Examination> queryExaminationByCheck(int[] ids);

    List<Examination> queryExaminationByEquals(Examination examination, Page pages);

    int countExaminationByEquals(Examination examination);

    void insertExamination(Examination examination);

    Map<String,Object> insertExaminationAll(Examination examination,String totalScore) throws Exception;

    void updateExamination(Examination examination,boolean changeFlag,String totalScore) throws Exception;

    List<Student> queryESByLike(Student student, String cultivateId, Page pages,String type);

    int countESByLike(Student student,String cultivateId,String type);

    int countEsById(ExaminationStudent es);

    void addES(String cultivateId,String examinationId);

    void updateByReleaseCN(Examination examination,String reFlag);

    void addCES(Integer[] ids,String examinationId,String cultivateId);

    TestPaperExamination queryTestPaper(String examinationId);

    void updateTPByPublish(String examinationId);

    void updateByTaskCNAndEC();

    void addExaminationByCopy(Map<String, String> param);

    TestPaperExamination queryTestPaperByWeChat(String examinationId,String studentId);

    void insertTestPaper(TestPaperExamination te);

    void updateTestPaper(TestPaperExamination te);

    void updateTestPaperBySave(TestPaperExamination te) throws Exception;

    Map<String,Object> importTestPaper(String path) throws IOException, SQLException;

    List<StudentExamination> queryEC(StudentExamination ec, Page pages);

    int countEC(StudentExamination ec);

    void updateECbyExamination(String examinationId,String studentId);

    void updateECAllCode(String examinationId,String studentId);

    void updateExaminationDataCode();

    void saveTpByWeChat(ExaminationStudent es);

    void updateByReleaseEC(Examination examination,String reFlag);

    void updateECbyResit(String examinationId, String studentId);

    List<Examination> getExaminationByWeChat(Examination examination, String studentId, String type);

    void updateESByPublish(String examinationId);

    int queryEcCodeByWeChat(ExaminationStudent es);

    String updatePublishStatus(String type, String examinationId);

    void deleteExaminations(int[] ids);

    void updateWillCloseTime(String examinationId, String studentId,String willCloseTime);
}