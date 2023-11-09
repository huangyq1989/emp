package com.emp.estimateManage.service;

import com.emp.estimateManage.entity.Estimate;
import com.emp.estimateManage.entity.EstimateStudent;
import com.emp.estimateManage.entity.QuestionnaireEstimate;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentEstimate;
import com.emp.systemManage.entity.Page;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface EstimateService {

    List<Estimate> queryEstimateByLike(Estimate estimate, Page pages);

    int countEstimateByLike(Estimate estimate);

    List<Estimate> queryEstimateByEquals(Estimate estimate, Page pages);

    int countEstimateByEquals(Estimate estimate);

    void insertEstimate(Estimate estimate);

    Map<String,Object> insertEstimateAll(Estimate estimate) throws Exception;

    void updateEstimate(Estimate estimate,boolean changeFlag) throws Exception;

    QuestionnaireEstimate queryQuestionnaire(QuestionnaireEstimate qi);

    void insertQuestionnaire(QuestionnaireEstimate qi);

    void updateQuestionnaireBySave(QuestionnaireEstimate qi) throws Exception;

    void updateQuestionnaire(QuestionnaireEstimate qi);

    void addEstimateByCopy(Map<String, String> param);

    void addES(String cultivateId,String estimateId);

    List<Student> queryESByLike(Student student, String cultivateId, Page pages, String type);

    int countESByLike(Student student,String cultivateId, String type);

    List<EstimateStudent> queryEsById(EstimateStudent es);

    int countEsById(EstimateStudent es);

    Map<String,Object> importQuestionnaire(String path) throws IOException, SQLException;

    void addCES(Integer[] ids,String estimateId,String cultivateId);

    void updateQEByPublish(String estimateId);

    void updateESByPublish(String estimateId);

    List<StudentEstimate> queryEC(StudentEstimate ec, Page pages);

    int countEC(StudentEstimate ec);

    void updateEstimateDataCode();

    String getShowResult(QuestionnaireEstimate es);

    List<StudentEstimate> queryEstimateResult(StudentEstimate ec);

    void saveQiByWeChat(EstimateStudent es);

    List<Estimate> queryEstimateByWeChat(Estimate estimate, String studentId);

    void updatePublishStatus(QuestionnaireEstimate qi);

    void deleteEstimates(int[] ids);
}