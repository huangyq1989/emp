package com.emp.cultivateManage.service;

import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.entity.CultivateGuide;
import com.emp.cultivateManage.entity.CultivateNote;
import com.emp.cultivateManage.entity.CultivateStudent;
import com.emp.studentManage.entity.Student;
import com.emp.systemManage.entity.Page;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface CultivateService {

    List<Cultivate> queryCultivateByLike(Cultivate cultivate, Page pages);

    int countCultivateByLike(Cultivate cultivate);

    List<Cultivate> queryCultivateByCheck(int[] ids);

    int queryAutoId();

    List<Cultivate> queryCultivateByEquals(Cultivate cultivate);

    void insertCultivate(Cultivate cultivate);

    void updateCultivate(Cultivate cultivate);

    void updateCultivateStatus(int[] ids);

    void deleteCultivates(int[] ids);

    int countCsById(CultivateStudent cs);

    void insertCs(CultivateStudent cs);

    Map<String,Object> importCS(String path,String cultivateId,String checkType) throws IOException, SQLException ;

    String saveImportData(String sendData, String cultivateId);

    List<Student> queryCSByLike(Student student, String cultivateId, Page pages,String type);

    int countCSByLike(Student student,String cultivateId,String type);

    List<CultivateNote> queryTaskSendData(CultivateNote note);

    List<Student> queryCsByCheck(int[] ids);

    void addCS(int[] ids,String cultivateId);

    void deleteCS(int[] ids,String cultivateId);

    void saveSendData(CultivateNote note);

    void updateSendData(CultivateNote note);

    List<CultivateNote> querySendData(CultivateNote note,Page pages);

    int countSendData(CultivateNote note);

    Map<String,Object> importSendPeople(String path) throws IOException;

    void updateCultivateDataCode();

    String queryGuideByWeChat(Cultivate cultivate);

    List<CultivateGuide> queryCultivateGuideByLike(CultivateGuide cg, Page pages);

    int countCultivateGuideByLike(CultivateGuide cg);

    Map<String,Object> insertCultivateGuide(CultivateGuide cg);

    int deleteCg(int cgId);

    int deleteCgByCultivateId(int cultivateId);

    List<Integer> queryLoseGuide();
}