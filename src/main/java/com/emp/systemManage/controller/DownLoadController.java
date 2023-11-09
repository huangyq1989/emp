package com.emp.systemManage.controller;

import com.emp.examinationManage.service.imp.ExaminationServiceImp;
import com.emp.studentManage.entity.StudentExamination;
import com.emp.systemManage.utils.PdfCommonUtils;
import com.emp.systemManage.utils.PropertyUtil;
import com.itextpdf.text.DocumentException;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Controller
@RequestMapping(value = "/downLoad")
public class DownLoadController {

    private Logger logger = Logger.getLogger(DownLoadController.class);

    @Autowired
    private ExaminationServiceImp examinationServiceImp ;


    //打包下载
    @RequestMapping(value = "/downloadPackage.do")
    public void downloadPackage(HttpServletRequest request, HttpServletResponse response) {

        String path = "" ;

        String type = request.getParameter("type");
        if (type == null || type == "") return;

        //打包证书
        if(PropertyUtil.getProperty("certificate.type", "defaultValue").equals(type)){
            StudentExamination ec = new StudentExamination();
            String examinationId = request.getParameter("examinationId");
            if(StringUtils.isNoneBlank(examinationId)){
                ec.setExaminationId(examinationId);
            }
            List<StudentExamination> ecList = examinationServiceImp.queryEC(ec,null);
            for(StudentExamination se:ecList){
                if(StringUtils.isNoneBlank(se.getCertificateNo())){
                    Map<String, String> data = new HashMap<String, String>();
                    data.put("studentName", se.getRealName());
                    data.put("cultivateName", se.getCultivateName());
                    data.put("certificateNo", se.getCertificateNo());
                    String time = se.getCertificateTime();
                    time = time.substring(0,time.lastIndexOf("."));//去掉毫秒
                    data.put("certificateTime", time);
                    try {
                        //生成证书
                        String filePath = PdfCommonUtils.createPdf(data);
                        path = path + filePath + ";";
                    } catch (IOException e) {
                        logger.error(e.getMessage());
                    } catch (DocumentException e) {
                        logger.error(e.getMessage());
                    }
                }
            }
            if(StringUtils.isNoneBlank(path)){
                path = path.substring(0,path.length()-1);//去除最后一位;
            }
        }

        if (path == null || path == "") return;

        List<File> fileList = new ArrayList<>();
        //文件地址数组
        String[] paths = path.split(";");
        for (String string : paths) {
            File f = new File(string);
            if (!f.exists()) continue;
            fileList.add(f);
        }
        if (fileList.size() <= 0) return;
        try {
            //保存的文件名为 当前日期 +随机数
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
            String date = sdf.format(new Date());
            String ran = 2 + (int) (Math.random() * (102 - 2)) + "";
            //判断或创建临时文件的目录
            String tempPath = PropertyUtil.getProperty("temp.path", "defaultValue");
            File f = new File(tempPath);
            if(!f.exists()){
                f.mkdirs();
            }
            //保存文件
            File file = new File(f + "/证书打包" + date + ran + ".rar");
            if (!file.exists()) {
                file.createNewFile();
            }
            response.reset();
            //创建文件输出流
            FileOutputStream fous = new FileOutputStream(file);
            /**打包的方法我们会用到ZipOutputStream这样一个输出流, 所以这里我们把输出流转换一下*/
            ZipOutputStream zipOut = new ZipOutputStream(fous);
            zipFile(fileList, zipOut);
            zipOut.close();
            fous.close();

            //如果是证书类型,最后删除文件,因为证书是即时生成的
            if(PropertyUtil.getProperty("certificate.type", "defaultValue").equals(type)){
                for (String string : paths) {
                    File tempFile = new File(string);
                    if (!tempFile.exists()) continue;
                    tempFile.delete();
                }
            }

            download(type,file, request, response);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            logger.error(e.getMessage());
        }
    }


    /**
     * 把接受的全部文件打成压缩包
     */
    public static void zipFile(List files, ZipOutputStream outputStream) {
        int size = files.size();
        for (int i = 0; i < size; i++) {
            File file = (File) files.get(i);
            zipFile(file, outputStream);
        }
    }


    /**
     * 根据输入的文件与输出流对文件进行打包
     */
    public static void zipFile(File inputFile, ZipOutputStream ouputStream) {
        try {
            if (inputFile.exists()) {
                /**
                 * 如果是目录的话这里是不采取操作的，  * 至于目录的打包正在研究中
                 */
                if (inputFile.isFile()) {
                    FileInputStream IN = new FileInputStream(inputFile);
                    BufferedInputStream bins = new BufferedInputStream(IN, 512);
                    // org.apache.tools.zip.ZipEntry
                    ZipEntry entry = new ZipEntry(inputFile.getName());
                    ouputStream.putNextEntry(entry);
                    // 向压缩文件中输出数据
                    int nNumber;
                    byte[] buffer = new byte[512];
                    while ((nNumber = bins.read(buffer)) != -1) {
                        ouputStream.write(buffer, 0, nNumber);
                    }
                    // 关闭创建的流对象
                    bins.close();
                    IN.close();
                } else {
                    try {
                        File[] files = inputFile.listFiles();
                        for (int i = 0; i < files.length; i++) {
                            zipFile(files[i], ouputStream);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    //回写文件给前端
    public void download(String type, File f,HttpServletRequest request, HttpServletResponse response) {
        if (!f.exists()) return;
        try {
            String filename=f.getName();
            // 当文件名不是英文名的时候，最好使用url解码器去编码一下，
            filename = URLEncoder.encode(filename, "UTF-8");
            // 将响应的类型设置为图片
            //response.setContentType("image/jpeg");
            response.setHeader("Content-Disposition", "attachment;filename=" + filename);
            // 现在通过IO流来传送数据
            InputStream input = new FileInputStream(f);
            // getServletContext().getResourceAsStream("/testImage.jpg");
            OutputStream output = response.getOutputStream();
            byte[] buff = new byte[1024 * 10];// 可以自己 指定缓冲区的大小
            int len = 0;
            while ((len = input.read(buff)) > -1) {
                output.write(buff, 0, len);
            }
            // 关闭输入输出流
            input.close();
            output.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            logger.error(e.getMessage());
        }finally {
            //如果是证书类型,最后删除文件,因为证书是即时生成的
            if(PropertyUtil.getProperty("certificate.type", "defaultValue").equals(type)){
                f.delete();
            }
        }
    }
}