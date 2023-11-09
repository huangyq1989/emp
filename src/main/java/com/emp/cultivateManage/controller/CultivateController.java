package com.emp.cultivateManage.controller;


import com.emp.cultivateManage.entity.Cultivate;
import com.emp.cultivateManage.entity.CultivateGuide;
import com.emp.cultivateManage.entity.CultivateNote;
import com.emp.cultivateManage.entity.PeopleDatailList;
import com.emp.cultivateManage.service.imp.CultivateServiceImp;
import com.emp.studentManage.entity.Student;
import com.emp.systemManage.entity.Page;
import com.emp.systemManage.utils.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.util.*;


@Controller
@RequestMapping(value = "/cultivate")
public class CultivateController {

    private Logger logger = Logger.getLogger(CultivateController.class);

    @Autowired
    private CultivateServiceImp cultivateServiceImp;


    //跳转培训管理页面
    @RequestMapping(value = "/cultivateList.do")
    public ModelAndView cultivateList(){
        ModelAndView mv = new ModelAndView("cultivate/cultivateManage");
        return mv;
    }


    //获取培训json数据
    @RequestMapping(value = "/getCultivateList.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getCultivateList(HttpServletRequest request, HttpServletResponse response){
        String cultivateName = request.getParameter("cultivateName");
        String beginTime = request.getParameter("beginTime");
        String endTime = request.getParameter("endTime");
        String cultivateDataCode = request.getParameter("cultivateDataCode");
        Cultivate cParam = new Cultivate();
        if(StringUtils.isNoneBlank(cultivateName)){
            cParam.setCultivateName(cultivateName);
        }
        if(StringUtils.isNoneBlank(beginTime)){
            cParam.setBeginTime(beginTime);
        }
        if(StringUtils.isNoneBlank(endTime)){
            cParam.setEndTime(endTime);
        }
        if(StringUtils.isNoneBlank(cultivateDataCode)){
            cParam.setCultivateDataCode(Integer.valueOf(cultivateDataCode));
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map=new HashMap<String,Object>();
        List<Cultivate> cultivateList = cultivateServiceImp.queryCultivateByLike(cParam,pages);
        int total = cultivateServiceImp.countCultivateByLike(cParam);
        map.put("total", total);
        map.put("rows", cultivateList);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //跳转到新增或修改页面
    @RequestMapping(value = "/addCultivate.do")
    public ModelAndView addCultivate(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        ModelAndView mv = null;
        if(StringUtils.isBlank(id)){
            mv = new ModelAndView("cultivate/addCultivate");
            int autoId = cultivateServiceImp.queryAutoId();
            mv.addObject("title","新增培训");
            mv.addObject("autoId",autoId);
        }else{
            mv = new ModelAndView("cultivate/updateCultivate");
            Cultivate cParam = new Cultivate();
            cParam.setId(Integer.valueOf(id));
            cParam = cultivateServiceImp.queryCultivateByEquals(cParam).get(0);
            String time = cParam.getBeginTime();
            time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
            cParam.setBeginTime(time);
            time = cParam.getEndTime();
            time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
            cParam.setEndTime(time);
            mv.addObject("title","修改培训");
            mv.addObject("cultivate",cParam);
        }
        return mv;
    }


    // 新增培训
    @RequestMapping(value = "/saveCultivate.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String saveCultivate(@ModelAttribute Cultivate cultivate, HttpServletRequest request, HttpServletResponse response){
        Map<String,Object> map = new HashMap<String,Object>();
        String cultivateName = cultivate.getCultivateName();
        Cultivate cParam = new Cultivate();
        if(StringUtils.isNoneBlank(cultivateName)){
            cParam.setCultivateName(cultivateName);
        }
        List<Cultivate> cultivateList = cultivateServiceImp.queryCultivateByEquals(cParam);
        if(cultivateList.size() != 0){
            map.put("rCode", 1);
            map.put("detail", "错误提示：培训名称已存在!");
        }else{
            //计算培训状态
            boolean timeFlag = CommonUtils.isgtNow(cultivate.getEndTime(),"yyyy-MM-dd HH:mm:ss");
            if(timeFlag){
                timeFlag = CommonUtils.isgtNow(cultivate.getBeginTime(),"yyyy-MM-dd HH:mm:ss");
                if(timeFlag){
                    cultivate.setCultivateDataCode(0);//开始时间比当前时间大为未开始
                }else{
                    cultivate.setCultivateDataCode(1);//开始时间比当前时间小为进行中
                }
            }else{
                cultivate.setCultivateDataCode(2);//结束时间小于当前时间为已结束
            }
            cultivateServiceImp.insertCultivate(cultivate);
            String cultivateId = cultivate.getId().toString();
            if(StringUtils.isBlank(cultivateId)){
                map.put("rCode", 1);
                map.put("detail", "错误提示：添加培训失败");
            }else{
                map.put("rCode", 0);
                map.put("detail", "添加培训成功");
                if(!StringUtils.isBlank(cultivate.getSendData())){
                    cultivateServiceImp.saveImportData(cultivate.getSendData(),cultivateId);
                }
            }
        }
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    // 新增或修改培训情况(新增在上面的方法,此方法的新增弃用)
    @RequestMapping(value = "/addOrEdit.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String addOrEdit(@ModelAttribute Cultivate cultivate, HttpServletRequest request, HttpServletResponse response){
        String type = request.getParameter("type");
        Map<String,Object> map = new HashMap<String,Object>();

        String cultivateName = cultivate.getCultivateName();
        Cultivate cParam = new Cultivate();
        if(StringUtils.isNoneBlank(cultivateName)){
            cParam.setCultivateName(cultivateName);
        }
        List<Cultivate> cultivateList = cultivateServiceImp.queryCultivateByEquals(cParam);
        if("0".equals(type)){//新增在上面的方法
//            if(cultivateList.size() != 0){
//                map.put("rCode", 1);
//                map.put("detail", "错误提示：培训名称已存在!");
//            }else{
//                map.put("rCode", 0);
//                cultivateServiceImp.insertCultivate(cultivate);
//                map.put("detail", "添加培训成功");
//            }
        }else{//修改
            int cultivateId = cultivate.getId();
            Cultivate cParam2 = new Cultivate();
            cParam2.setId(cultivateId);
            List<Cultivate> cultivateList2 = cultivateServiceImp.queryCultivateByEquals(cParam2);
            if(cultivateList2.size() == 0){
                map.put("rCode", 1);
                map.put("detail", "错误提示：该培训名称已不存在!");
            }else{
                if(cultivateList.size() == 0 || cultivateList.get(0).getId().equals(cultivateList2.get(0).getId())){
                    //计算培训状态
                    boolean timeFlag = CommonUtils.isgtNow(cultivate.getEndTime(),"yyyy-MM-dd HH:mm:ss");
                    if(!timeFlag){
                        cultivate.setCultivateDataCode(2);//结束时间小于当前时间为已结束
                    }else{
                        timeFlag = CommonUtils.isgtNow(cultivate.getBeginTime(),"yyyy-MM-dd HH:mm:ss");
                        if(timeFlag){
                            cultivate.setCultivateDataCode(0);//开始时间比当前时间大为未开始
                        }else{
                            cultivate.setCultivateDataCode(1);//开始时间比当前时间大为进行中
                        }
                    }
                    cultivateServiceImp.updateCultivate(cultivate);
                    map.put("rCode", 0);
                    map.put("detail", "修改培训成功");
                }else{
                    map.put("rCode", 1);
                    map.put("detail", "错误提示：已有同名的培训名称!");
                }
            }
        }
        String jsonStr = new Gson().toJson(map);
        return jsonStr;
    }


    //批量删除培训对象(只修改状态为失效)
    @RequestMapping(value = "/updateCultivateStatus.do")
    @ResponseBody
    public String updateCultivateStatus(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            cultivateServiceImp.updateCultivateStatus(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //批量删除培训对象
    @RequestMapping(value = "/deleteCultivates.do")
    @ResponseBody
    public String deleteCultivates(String[] arr){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            cultivateServiceImp.deleteCultivates(ids);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //导出
    @RequestMapping(value = "/exportCultivate.do")
    public void exportCultivate(String[] arr,HttpServletRequest request, HttpServletResponse response){
        List<Cultivate> cultivateList = null ;
        if(arr != null && arr.length != 0){//根据勾选进行导出
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            cultivateList = cultivateServiceImp.queryCultivateByCheck(ids);
        }else{//根据查询条件进行导出
            String cultivateName = request.getParameter("cultivateName");
            try {
                cultivateName= URLDecoder.decode(cultivateName,"UTF-8");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            String beginTime = request.getParameter("beginTime");
            String endTime = request.getParameter("endTime");
            String cultivateDataCode = request.getParameter("cultivateDataCode");
            Cultivate cParam = new Cultivate();
            if(StringUtils.isNoneBlank(cultivateName)){
                cParam.setCultivateName(cultivateName);
            }
            if(StringUtils.isNoneBlank(beginTime)){
                cParam.setBeginTime(beginTime);
            }
            if(StringUtils.isNoneBlank(endTime)){
                cParam.setEndTime(endTime);
            }

            if(StringUtils.isNoneBlank(cultivateDataCode)){
                cParam.setCultivateDataCode(Integer.valueOf(cultivateDataCode));
            }
            cultivateList = cultivateServiceImp.queryCultivateByLike(cParam,null);
        }
        String filePath = null;
        try{
            filePath = new ImportExcelUtils().writeXlxs(cultivateList, PropertyUtil.getProperty("cultivate.type", "defaultValue"),"培训信息表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }



    //批量保存账号(导入保存)
    @RequestMapping(value = "/saveImportData.do")
    @ResponseBody
    public String saveImportData(String sendData, HttpServletRequest request, HttpServletResponse response){
        String cultivateId = request.getParameter("cultivateId");
        return cultivateServiceImp.saveImportData(sendData,cultivateId);
    }


    //跳转到学员管理页面
    @RequestMapping(value = "/toCS.do")
    public ModelAndView toCS(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/csManage");
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        return mv;
    }


    //跳转到培训指引页面
    @RequestMapping(value = "/toCultivateGuide.do")
    public ModelAndView toCultivateGuide(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/cultivateGuide");
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        return mv;
    }


    //获取培训指引json数据
    @RequestMapping(value = "/getCultivateGuide.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getCultivateGuide(HttpServletRequest request, HttpServletResponse response){
        String cultivateId = request.getParameter("cultivateId");
        String insertTime = request.getParameter("insertTime");
        CultivateGuide cg = new CultivateGuide();
        if(StringUtils.isNoneBlank(cultivateId)){
            cg.setCultivateId(Integer.valueOf(cultivateId));
        }
        if(StringUtils.isNoneBlank(insertTime)){
            cg.setInsertTime(insertTime);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);

        Map<String,Object> map=new HashMap<String,Object>();
        List<CultivateGuide> cgList = cultivateServiceImp.queryCultivateGuideByLike(cg,pages);
        int total = cultivateServiceImp.countCultivateGuideByLike(cg);
        map.put("total", total);
        map.put("rows", cgList);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //在线预览或下载培训指引
    @RequestMapping(value = "/previewOrDown.do")
    public void previewOrDown(HttpServletRequest request, HttpServletResponse response) throws IOException{
        OutputStream os = null;
        try {
            String filename = request.getParameter("fileName");
            String fileRealPath = request.getParameter("filePath");
            File file = new File(fileRealPath);
//            if (!file.exists()) {
//                throw new WAFException("阅读的附件不存在！");
//            }

            // 读取文件
            InputStream fis = new BufferedInputStream(new FileInputStream(fileRealPath));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            response.reset();

            // 设置下载文件名等
            String showFileName = new String(filename.replaceAll(" ", "").getBytes("utf-8"), "iso8859-1");
            String extName = showFileName.substring(showFileName.lastIndexOf(".")).toLowerCase();

            String type = request.getParameter("type");
            //下载文件
            if("download".equalsIgnoreCase(type)){
                response.addHeader("Content-Disposition", "attachment;filename="+ showFileName);
            }

            response.addHeader("Content-Length", "" + file.length());
            // 设置内容编码
            response.setCharacterEncoding("utf-8");
            // 设置响应MIME
            if (".doc".equals(extName)) {
                response.setContentType("application/msword");
            } else if (".docx".equals(extName)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            } else if (".pdf".equals(extName)) {
                response.setContentType("application/pdf");
            } else if (".xls".equals(extName)) {
                response.setContentType("application/vnd.ms-excel");
            } else if (".xlsx".equals(extName)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            } else if (".ppt".equals(extName)) {
                response.setContentType("application/vnd.ms-powerpoint");
            } else if (".pptx".equals(extName)) {
                response.setContentType("application/vnd.openxmlformats-officedocument.presentationml.presentation");
            } else if (".bmp".equals(extName)) {
                response.setContentType("image/bmp");
            } else if (".gif".equals(extName)) {
                response.setContentType("image/gif");
            } else if (".ief".equals(extName)) {
                response.setContentType("image/ief");
            } else if (".jpeg".equals(extName)) {
                response.setContentType("image/jpeg");
            } else if (".jpg".equals(extName)) {
                response.setContentType("image/jpeg");
            } else if (".png".equals(extName)) {
                response.setContentType("image/png");
            } else if (".tiff".equals(extName)) {
                response.setContentType("image/tiff");
            } else if (".tif".equals(extName)) {
                response.setContentType("image/tif");
            }

            os = new BufferedOutputStream(response.getOutputStream());
            os.write(buffer);// 输出文件
            os.flush();

            response.flushBuffer();

        } catch (Exception e) {
            e.printStackTrace();
            if (os != null) {
                try {
                    os.write(e.getLocalizedMessage().getBytes("utf-8"));
                    os.flush();
                } catch (Exception le) {
                    // NOOP
                }
            }
        } finally {
            if (os != null) {
                try {
                    os.close();
                } catch (Exception e) {
                    // NOOP
                }
            }
        }
    }


    //批量删除培训指引
    @RequestMapping(value = "/deleteCg.do")
    @ResponseBody
    public String deleteCg(String[] arr,String[] path){
        try{
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            for(int i=0;i<ids.length;i++){
                int result = cultivateServiceImp.deleteCg(ids[i]);
                if(result != 0){//删除成功
                    FileDirectory.deleteFile(path[i]);//删除对应的文件
                }
            }
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //跳转到添加培训学员页面
    @RequestMapping(value = "/toAddCs.do")
    public ModelAndView toAddCs(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/addCs");
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        return mv;
    }


    //跳转到导入培训学员页面
    @RequestMapping(value = "/toImportCs.do")
    public ModelAndView toImportCs(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/importCs");
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));
        return mv;
    }


    //获取可添加培训的学员json数据
    @RequestMapping(value = "/getCSList.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String getCSList(HttpServletRequest request, HttpServletResponse response){
        String realName = request.getParameter("realName");
        String unit = request.getParameter("unit");
        String phone = request.getParameter("phone");
        Student sParam = new Student();
        if(StringUtils.isNoneBlank(realName)){
            sParam.setRealName(realName);
        }
        if(StringUtils.isNoneBlank(unit)){
            sParam.setUnit(unit);
        }
        if(StringUtils.isNoneBlank(phone)){
            sParam.setPhone(phone);
        }

        int page = Integer.parseInt(request.getParameter("page"));
        int rows = Integer.parseInt(request.getParameter("rows"));
        Page pages = new Page(page,rows);
        Map<String,Object>map=new HashMap<String,Object>();
        String cultivateId = request.getParameter("cultivateId");
        String type = request.getParameter("type");
        List<Student> students = cultivateServiceImp.queryCSByLike(sParam,cultivateId,pages,type);
        int total = cultivateServiceImp.countCSByLike(sParam,cultivateId,type);
        map.put("total", total);
        map.put("rows", students);

        Gson gson = new Gson();
        String jsonStr = gson.toJson(map);
        return jsonStr;
    }


    //批量添加学员到培训中间表
    @RequestMapping(value = "/addCS.do")
    @ResponseBody
    public String addCS(String[] arr,HttpServletRequest request){
        try{
            String cultivateId = request.getParameter("cultivateId");
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            cultivateServiceImp.addCS(ids,cultivateId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //批量删除学员从培训中间表
    @RequestMapping(value = "/deleteCS.do")
    @ResponseBody
    public String deleteCS(String[] arr,HttpServletRequest request){
        try{
            String cultivateId = request.getParameter("cultivateId");
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            cultivateServiceImp.deleteCS(ids,cultivateId);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }


    //导出培训学员数据
    @RequestMapping(value = "/exportCs.do")
    public void exportCs(String[] arr,HttpServletRequest request, HttpServletResponse response){
        List<Student> csList = null ;
        if(arr != null && arr.length != 0){//根据勾选进行导出
            int[] ids = CommonUtils.stringArrayToIntArray(arr);
            csList = cultivateServiceImp.queryCsByCheck(ids);
        }else{//根据查询条件进行导出
            String realName = request.getParameter("realName");
            String unit = request.getParameter("unit");
            String phone = request.getParameter("phone");
            Student sParam = new Student();
            if(StringUtils.isNoneBlank(realName)){
                sParam.setRealName(realName);
            }
            if(StringUtils.isNoneBlank(unit)){
                sParam.setUnit(unit);
            }
            if(StringUtils.isNoneBlank(phone)){
                sParam.setPhone(phone);
            }
            String cultivateId = request.getParameter("cultivateId");
            csList = cultivateServiceImp.queryCSByLike(sParam,cultivateId,null,"delete");
        }
        String filePath = null;
        try{
            String cultivateName = request.getParameter("cultivateName");
            filePath = new ImportExcelUtils().writeXlxs(csList, PropertyUtil.getProperty("student.type", "defaultValue"),cultivateName+"-培训学员表");
            CommonUtils.outputToResponse(filePath,"xlsx",response);
        }catch (IOException e){
            logger.error(e.getMessage());
        }
    }

    //跳转到短信下发页面
    @RequestMapping(value = "/toSendNote.do")
    public ModelAndView toSendNote(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/sendNote");
        mv.addObject("cultivateId",request.getParameter("cultivateId"));
        mv.addObject("cultivateName",request.getParameter("cultivateName"));

        //短信学员
        Map<String,Object> map = new HashMap<String,Object>();
        List<Student> students = cultivateServiceImp.queryCSByLike(null,request.getParameter("cultivateId"),null,"delete");
        map.put("total", students.size());
        map.put("rows", students);
        String jsonStr = new Gson().toJson(map);
        mv.addObject("studentDetails",jsonStr);

        return mv;
    }


    //保存短信信息
    @RequestMapping(value = "/saveSendData.do")
    @ResponseBody
    public String saveSendData(String sendData,HttpServletRequest request){
        try{
            ArrayList<CultivateNote> notes = new ArrayList<CultivateNote>();
            Type listType = new TypeToken<List<CultivateNote>>() {}.getType();
            notes = new Gson().fromJson(sendData, listType);

            CultivateNote note = notes.get(0);
            //保存短信信息
            if(note.getSendType() != null && note.getSendType() == 1){//立即下发
                //发短信
                Map<String,Object> t_map = this.send(note);
                if(!t_map.get("code").equals(0)){//失败返回
                    return "1";
                }

                note.setSendTime("");//前端有传时间,不过这里不需要,数据库直接保存当前时间,短信立即发出
                note.setSendDataCode(2);
            }else{
                note.setSendDataCode(0);
            }

            //保存日志
            List<PeopleDatailList> pl = note.getPeopleDatailList();
            String peopleDetail = "";
            for(PeopleDatailList p : pl){
                peopleDetail = peopleDetail + p.getPhone() + "（" + p.getRealName() +"），";
            }
            peopleDetail = peopleDetail.substring(0,peopleDetail.length()-1);
            note.setPeopleDatail(peopleDetail);
            cultivateServiceImp.saveSendData(note);
            return "0";
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "1";
        }
    }

//    //异步发短信
//    public void send(CultivateNote note) {
//        //新定义线程来处理发送
//        new Thread(){
//            public void run(){
//            logger.info("----发送短信开始----");
//            List<PeopleDatailList> p_list = note.getPeopleDatailList();
//            int i = 0 ;
//            for(PeopleDatailList p : p_list){
//                String content = note.getContent().replaceAll("<<姓名>>",p.getRealName());
//                Map<String,Object> resultMap =SendNodeUtils.sendNode(content,p.getPhone());
//                if(!resultMap.get("code").equals(0) && i==0){//失败返回,只校验第一次
//                }
//                i++;
//            }
//            //控制台打印日志
//            logger.info("----发送短信结束----");
//            }
//        }.start();
//    }



    //同步发短信
    public Map<String,Object> send(CultivateNote note) {
        Map<String,Object> resultMap = new HashMap<String,Object>() ;
        logger.info("----发送短信开始----");
        List<PeopleDatailList> p_list = note.getPeopleDatailList();
        int i = 0 ;
        for(PeopleDatailList p : p_list){
            String content = note.getContent().replaceAll("<<姓名>>",p.getRealName());
            if(i == 0){
                resultMap = SendNodeUtils.sendNode(content,p.getPhone());
                if(!resultMap.get("code").equals(0) && i==0){//失败返回,检测第一次
                    return resultMap ;
                }
            }else{
                SendNodeUtils.sendNode(content,p.getPhone());
            }
            i++;
        }
        logger.info("----发送短信结束----");
        return resultMap;
    }



    //查询短信信息json数据
    @RequestMapping(value = "/querySendData.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String querySendData(HttpServletRequest request, HttpServletResponse response){
        try{
            CultivateNote note = new CultivateNote();
            String cultivateId = request.getParameter("cultivateId");
            if(StringUtils.isNoneBlank(cultivateId)){
                note.setCultivateId(Integer.valueOf(cultivateId));
            }
            String insertTime = request.getParameter("insertTime");
            if(StringUtils.isNoneBlank(insertTime)){
                note.setInsertTime(insertTime);
            }

            int page = Integer.parseInt(request.getParameter("page"));
            int rows = Integer.parseInt(request.getParameter("rows"));
            Page pages = new Page(page,rows);

            Map<String,Object> map=new HashMap<String,Object>();
            List<CultivateNote> cnList = cultivateServiceImp.querySendData(note,pages);
            int total = cultivateServiceImp.countSendData(note);
            map.put("total", total);
            map.put("rows", cnList);

            String jsonStr = new Gson().toJson(map);
            return jsonStr;
        }catch(Exception e){
            logger.error(e.getLocalizedMessage());
            return "";
        }
    }


    //跳转到导入收件人页面
    @RequestMapping(value = "/importSend.do")
    public ModelAndView importSend(HttpServletRequest request, HttpServletResponse response){
        ModelAndView mv = new ModelAndView("cultivate/importSend");
        return mv;
    }



    //获取培训指引(公众号接口)
    @RequestMapping(value = "/queryGuideByWeChat.do",produces = "application/json;charset=utf-8")
    @ResponseBody
    public String queryGuideByWeChat(HttpServletRequest request, HttpServletResponse response) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            String cultivateId = request.getParameter("cultivateId");
            if (StringUtils.isBlank(cultivateId)) {
                map.put("code", 1);
                map.put("message", "cultivateId参数不能为空");
                map.put("guide", null);
                return new Gson().toJson(map);
            }
            CultivateGuide cg = new CultivateGuide();
            cg.setCultivateId(Integer.valueOf(cultivateId));
            List<CultivateGuide> cgList = cultivateServiceImp.queryCultivateGuideByLike(cg,null);

            map.put("code", 0);
            map.put("message", "成功");
            map.put("guide", cgList);
            return new Gson().toJson(map);
        } catch (Exception e) {
            map.put("code", 1);
            map.put("message", e.getMessage());
            map.put("guide", null);
            logger.error(e.getMessage());
            return new Gson().toJson(map);
        }
    }
}
