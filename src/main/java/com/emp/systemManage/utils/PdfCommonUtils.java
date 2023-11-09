package com.emp.systemManage.utils;


import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.*;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class PdfCommonUtils {

    //返回新文件路径
    public static String createPdf(Map<String, String> data) throws IOException, DocumentException {

        /* 导入PDF模板 */
        String classpath = PdfCommonUtils.class.getResource("/").getPath();
        String fileName = classpath.replaceAll("classes/", "importModel/certificate.pdf");


        //创建临时文件的目录
        String tempPath = PropertyUtil.getProperty("temp.path", "defaultValue");
        File file = new File(tempPath);
        if(!file.exists()){
            file.mkdirs();
        }

        /* 生成的新文件路径 */
        String dateTime = new SimpleDateFormat("YYYYMMddHHmmssSSS").format(new Date());
        String newPDFPath = file + "/certificate_"+dateTime+".pdf";

        try {
            PdfReader reader = new PdfReader(fileName);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();

            /* 2.读取PDF模板内容 */
            PdfStamper ps = new PdfStamper(reader, bos);
            PdfContentByte under = ps.getUnderContent(1);
            System.out.println("采用PDF模板:" + fileName);

            /* 3.法1:设置使用itext-asian.jar的中文字体 */
            BaseFont bf = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);

			/*法2:使用项目下的自定义的中文字体
			bfChinese = BaseFont.createFont("static/font/SIMSUN.TTC,1", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);*/

			/*法3:使用windows系统下的字体库
			bfChinese = BaseFont.createFont("c://windows//fonts//simsun.ttc,1",BaseFont.IDENTITY_H, false);*/

            ArrayList<BaseFont> fontList = new ArrayList<BaseFont>();
            fontList.add(bf);

            /* 4.获取模板中的所有字段 */
            AcroFields fields = ps.getAcroFields();
            fields.setSubstitutionFonts(fontList);

            fillData(fields, data); 			//调用方法执行写入

            /* 必须要调用这个，否则文档不会生成的 */
            ps.setFormFlattening(true);
            ps.close();

            /* 5.将要生成的目标PDF文件名称 */
            OutputStream fos = new FileOutputStream(newPDFPath);
            fos.write(bos.toByteArray());
            System.out.println("新证书已生成:" + newPDFPath);
            fos.flush();
            fos.close();
            bos.close();
        } catch (IOException e) {
            System.out.println("证书生成失败,原因:" + e.getLocalizedMessage());
        } catch (DocumentException e) {
            System.out.println("证书生成失败,原因:" + e.getLocalizedMessage());
        }
        return newPDFPath;
    }


    // 获取pdf模板中有哪些字段key+赋值的值value
    public static void fillData(AcroFields fields, Map<String, String> data) throws IOException, DocumentException {
        for (String key : data.keySet()) {
            String value = data.get(key); // 调用data方法获取值
            System.out.println(key + "字段:" + value);
            fields.setField(key, value); // 为字段赋值,注意字段名称是区分大小写的
        }
    }


    public static void main(String[] args) throws Exception {
        System.out.println("==========证书生成start==========");

        // 获取pdf模板中有哪些字段key+赋值的值value
        Map<String, String> data = new HashMap<String, String>();
        data.put("studentName", "邹tao畀瘬2"); // 字段需要对应pdf模板里面的名称
        data.put("cultivateName", "高级数学"); // 字段需要对应pdf模板里面的名称
        data.put("certificateNo", "BW1111111"); // 字段需要对应pdf模板里面的名称
        data.put("certificateTime", "2018年7月22日");
        createPdf(data);

        System.out.println("==========证书生成end============");
    }
}
