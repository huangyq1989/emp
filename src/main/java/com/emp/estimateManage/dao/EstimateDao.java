package com.emp.estimateManage.dao;


import com.emp.estimateManage.entity.Estimate;
import com.emp.estimateManage.entity.EstimateStudent;
import com.emp.estimateManage.entity.QuestionnaireEstimate;
import com.emp.studentManage.entity.Student;
import com.emp.studentManage.entity.StudentEstimate;
import com.emp.systemManage.entity.Page;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface EstimateDao {

    List<Estimate> queryEstimateByLike(@Param("estimate") Estimate estimate, @Param("pages") Page pages);

    int countEstimateByLike(@Param("estimate") Estimate estimate);

    List<Estimate> queryEstimateByEquals(@Param("estimate") Estimate estimate, @Param("pages") Page pages);

    int countEstimateByEquals(@Param("estimate") Estimate estimate);

    void insertEstimate(Estimate estimate);

    void updateEstimate(@Param("estimate") Estimate estimate);

    QuestionnaireEstimate queryQuestionnaire(@Param("qi") QuestionnaireEstimate qi);

    void insertQuestionnaire(@Param("qi") QuestionnaireEstimate qi);

    void updateQuestionnaire(@Param("qi") QuestionnaireEstimate qi);

    void addEstimateByCopy(Map<String, String> param);

    void addES(@Param("cultivateId") String cultivateId,@Param("estimateId") String estimateId);

    List<Student> queryESByLike(@Param("student") Student student, @Param("estimateId") String estimateId, @Param("pages") Page pages, @Param("type") String type);

    int countESByLike(@Param("student") Student student,@Param("estimateId") String estimateId,@Param("type") String type);

    List<EstimateStudent> queryEsById(@Param("es") EstimateStudent es);

    void updateQEByPublish(@Param("estimateId") String estimateId);

    void updateESByPublish(@Param("estimateId") String estimateId);

    int countEsById(@Param("es") EstimateStudent es);

    void addCES(@Param("ids")Integer[] ids,@Param("estimateId") String estimateId,@Param("cultivateId") String cultivateId);

    void deleteCES(@Param("ids")int[] ids,@Param("cultivateId") String cultivateId);

    void deleteCESById(@Param("estimateId") String estimateId);

    List<StudentEstimate> queryEC(@Param("ec") StudentEstimate ec, @Param("pages") Page pages);

    int countEC(@Param("ec") StudentEstimate ec);

    List<StudentEstimate> queryEstimateResult(@Param("ec") StudentEstimate ec);

    void updateEstimateDataCode();

    void saveQiByWeChat(@Param("es") EstimateStudent es);

    List<Estimate> queryEstimateByWeChat(@Param("estimate") Estimate estimate, @Param("studentId") String studentId);

    void updatePublishStatus(@Param("qi") QuestionnaireEstimate qi);

    void deleteEstimates(@Param("ids")int[] ids);
}
