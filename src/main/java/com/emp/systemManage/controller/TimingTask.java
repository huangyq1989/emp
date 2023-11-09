package com.emp.systemManage.controller;

import com.emp.cultivateManage.entity.CultivateNote;
import com.emp.cultivateManage.service.imp.CultivateServiceImp;
import com.emp.estimateManage.service.imp.EstimateServiceImp;
import com.emp.examinationManage.service.imp.ExaminationServiceImp;
import com.emp.systemManage.utils.FileDirectory;
import com.emp.systemManage.utils.PropertyUtil;
import com.emp.systemManage.utils.SendNodeUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.List;
import java.util.Map;


/*
* 定时任务
*/
@Component
public class TimingTask {

    private Logger logger = Logger.getLogger(TimingTask.class);

    @Autowired
    private CultivateServiceImp cultivateServiceImp;

    @Autowired
    private EstimateServiceImp estimateServiceImp;

    @Autowired
    private ExaminationServiceImp examinationServiceImp ;


    /**
     * 每5秒一次,修改状态
     */
    @Scheduled(cron="0/5 * * * * ?")
    public void updateAllDataCode() {
        logger.info("-------updateAllDataCode 启动-------");
        //修改培训状态
        cultivateServiceImp.updateCultivateDataCode();
        //修改考试状态
        examinationServiceImp.updateExaminationDataCode();
        //修改评估状态
        estimateServiceImp.updateEstimateDataCode();
        logger.info("-------updateAllDataCode 结束-------");
    }


    /**
     * 每5分钟一次,检测一遍,发短信
     */
    @Scheduled(cron="0 0/5 * * * ?")
    public void sendNoteTask() {
        logger.info("-------sendNoteTask 启动-------");
        //查询出要发短信的数据
        CultivateNote note = new CultivateNote();
        note.setSendDataCode(0);
        List<CultivateNote> cnList = cultivateServiceImp.queryTaskSendData(note);

        flag : for(CultivateNote cn:cnList){
            String[] pds = cn.getPeopleDatail().split("，");
            int i = 0;
            for(String pd:pds){
                String phone = pd.substring(0,pd.indexOf("（"));
                String name = pd.substring(pd.indexOf("（")+1,pd.indexOf("）"));
                String content = cn.getContent().replaceAll("<<姓名>>",name);
                Map<String,Object> resultMap = SendNodeUtils.sendNode(content,phone);
                if(!resultMap.get("code").equals(0) && i==0){//失败返回,检测第一次
                    continue flag;
                }
                logger.info("发送给: "+phone);
                i++;
            }
            cn.setSendDataCode(2);
            //修改发送短信状态
            cultivateServiceImp.updateSendData(cn);
        }
        logger.info("-------sendNoteTask 结束-------");
    }


    /**
     * 每天凌晨0点执行一遍,删除已失效的培训指引表数据和对应的文件
     */
    @Scheduled(cron="0 0 0 * * ?")
    public void deleteLoseGuide() {
        logger.info("-------deleteLoseGuide 启动-------");
        //查询出清除的指引数据
        List<Integer> cultivateIds = cultivateServiceImp.queryLoseGuide();
        for(Integer cultivateId:cultivateIds){
            //删除数据
            cultivateServiceImp.deleteCgByCultivateId(cultivateId);
            //清除文件
            FileDirectory.deleteDir(new File(PropertyUtil.getProperty("cultivateGuide.path", "defaultValue") + cultivateId));
        }
        logger.info("-------deleteLoseGuide 结束-------");
    }


    /**
     * 每4分钟一次,检测一遍,发布成绩和证书
     */
    @Scheduled(cron="0 0/4 * * * ?")
    public void sendCNOrEC() {
        logger.info("-------sendCNOrEC 启动-------");
        examinationServiceImp.updateByTaskCNAndEC();
        logger.info("-------sendCNOrEC 结束-------");
    }
}
