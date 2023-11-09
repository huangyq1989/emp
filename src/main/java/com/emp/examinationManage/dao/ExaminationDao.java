package com.emp.examinationManage.dao;


import com.emp.examinationManage.entity.Examination;
import com.emp.examinationManage.entity.ExaminationStudent;
import com.emp.examinationManage.entity.TestPaperExamination;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentExamination;
import com.emp.systemManage.entity.Page;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface ExaminationDao {

    List<Examination> queryExaminationByLike(@Param("examination") Examination examination, @Param("pages") Page pages);

    int countExaminationByLike(@Param("examination") Examination examination);

    List<Examination> queryExaminationByEquals(@Param("examination") Examination examination, @Param("pages") Page pages);

    int countExaminationByEquals(@Param("examination") Examination examination);

    List<Examination> queryExaminationByCheck(@Param("ids")int[] ids);

    List<Examination> queryTaskReleaseEC();

    List<Examination> queryTaskReleaseCN();

    void insertExamination(Examination examination);

    void updateExamination(@Param("examination") Examination examination);

    List<Student> queryESByLike(@Param("student") Student student, @Param("examinationId") String examinationId, @Param("pages") Page pages,@Param("type") String type);

    int countESByLike(@Param("student") Student student,@Param("examinationId") String examinationId,@Param("type") String type);

    int countEsById(@Param("es") ExaminationStudent es);

    void addES(@Param("cultivateId") String cultivateId,@Param("examinationId") String examinationId);

    void addCES(@Param("ids")Integer[] ids,@Param("examinationId") String examinationId,@Param("cultivateId") String cultivateId);

    void deleteCES(@Param("ids")int[] ids,@Param("cultivateId") String cultivateId);

    void deleteCESById(@Param("examinationId") String examinationId);

    TestPaperExamination queryTestPaper(@Param("examinationId") String examinationId);

    void updateTPByPublish(@Param("examinationId") String examinationId);

    TestPaperExamination queryTestPaperByWeChat(@Param("examinationId") String examinationId, @Param("studentId") String studentId);

    void insertTestPaper(@Param("te") TestPaperExamination te);

    void updateTestPaper(@Param("te") TestPaperExamination te);

    void addExaminationByCopy(Map<String, String> param);

    List<StudentExamination> queryEC(@Param("ec") StudentExamination ec, @Param("pages") Page pages);

    int countEC(@Param("ec") StudentExamination ec);

    void updateECAllCode(@Param("examinationId") String examinationId, @Param("studentId") String studentId);

    void updateECbyExamination(@Param("examinationId") String examinationId, @Param("studentId") String studentId);

    void updateExaminationDataCode();

    void saveTpByWeChat(@Param("es") ExaminationStudent es);

    void updateByReleaseEC(@Param("examination") Examination examination);

    void updateByReleaseCN(@Param("examination") Examination examination);

    void updateECbyResit(@Param("examinationId") String examinationId, @Param("studentId") String studentId);

    List<Examination> getExaminationByWeChat(@Param("examination") Examination examination, @Param("studentId") String studentId, @Param("type") String type);

    void updateESByPublish(@Param("examinationId") String examinationId);

    int queryEcCodeByWeChat(@Param("es") ExaminationStudent es);

    void updatePublishStatus(@Param("te") TestPaperExamination te);

    void deleteExaminations(@Param("ids")int[] ids);

    void updateWillCloseTime(@Param("examinationId") String examinationId, @Param("studentId") String studentId, @Param("willCloseTime") String willCloseTime);
}
