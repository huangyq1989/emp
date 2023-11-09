package com.emp.cultivateManage.dao;


import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.entity.CultivateGuide;
import com.emp.cultivateManage.entity.CultivateNote;
import com.emp.cultivateManage.entity.CultivateStudent;
import com.emp.studentManage.entity.Student;
import com.emp.systemManage.entity.Page;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CultivateDao {

    List<Cultivate> queryCultivateByLike(@Param("cultivate") Cultivate cultivate, @Param("pages") Page pages);

    int countCultivateByLike(@Param("cultivate") Cultivate cultivate);

    List<Cultivate> queryCultivateByCheck(@Param("ids")int[] ids);

    int queryAutoId();

    List<Cultivate> queryCultivateByEquals(@Param("cultivate") Cultivate cultivate);

    void insertCultivate(Cultivate cultivate);

    void updateCultivate(@Param("cultivate") Cultivate cultivate);

    void updateCultivateStatus(@Param("ids")int[] ids);

    void deleteCultivates(@Param("ids")int[] ids);

    int countCsById(@Param("cs") CultivateStudent cs);

    void insertCs(@Param("cs") CultivateStudent cs);

    List<Student> queryCSByLike(@Param("student") Student student, @Param("cultivateId") String cultivateId,@Param("pages") Page pages,@Param("type") String type);

    int countCSByLike(@Param("student") Student student,@Param("cultivateId") String cultivateId,@Param("type") String type);

    List<Student> queryCsByCheck(@Param("ids")int[] ids);

    void addCS(@Param("ids")Integer[] ids,@Param("cultivateId") String cultivateId);

    void deleteCS(@Param("ids")int[] ids,@Param("cultivateId") String cultivateId);

    void saveSendData(@Param("note") CultivateNote note);

    void updateSendData(@Param("note") CultivateNote note);

    List<CultivateNote> querySendData(@Param("note") CultivateNote note, @Param("pages") Page pages);

    List<CultivateNote> queryTaskSendData(@Param("note") CultivateNote note);

    int countSendData(@Param("note") CultivateNote note);

    void updateCultivateDataCode();

    String queryGuideByWeChat(@Param("cultivate") Cultivate cultivate);

    List<CultivateGuide> queryCultivateGuideByLike(@Param("cg") CultivateGuide cg, @Param("pages") Page pages);

    int countCultivateGuideByLike(@Param("cg") CultivateGuide cg);

    void insertCultivateGuide(@Param("cg") CultivateGuide cg);

    int deleteCg(int cgId);

    int deleteCgByCultivateId(int cultivateId);

    List<Integer> queryLoseGuide();
}
