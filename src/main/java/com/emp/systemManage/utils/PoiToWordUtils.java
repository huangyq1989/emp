package com.emp.systemManage.utils;

import com.emp.estimateManage.entity.Questionnaire;
import com.emp.estimateManage.entity.QuestionnaireEstimate;
import com.emp.examinationManage.entity.TestPaper;
import com.emp.examinationManage.entity.TestPaperExamination;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.poifs.filesystem.DirectoryEntry;
import org.apache.poi.poifs.filesystem.DocumentEntry;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xwpf.usermodel.*;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.*;

import java.io.*;
import java.lang.reflect.Type;
import java.math.BigInteger;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 导出word
 *
 */
public class PoiToWordUtils {


    //把对象转成XLSX存储在临时文件夹,返回路径
    public static String writeWord(Object object,String type,String name,String passingScoreLine) throws IOException {
        String tempPath = PropertyUtil.getProperty("temp.path", "defaultValue");
        // Blank Document
        XWPFDocument document = new XWPFDocument();

        if(type.equals(PropertyUtil.getProperty("testPaper.type", "defaultValue"))){
            // 添加标题
            XWPFParagraph titleParagraph = document.createParagraph();
            // 设置段落居中
            titleParagraph.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun titleParagraphRun = titleParagraph.createRun();
            titleParagraphRun.setText(name);
            titleParagraphRun.setFontSize(16);

            TestPaperExamination te = (TestPaperExamination)object;
            XWPFRun titleParagraphRun1 = titleParagraph.createRun();
            titleParagraphRun1.setText("   总分:"+te.getTotalScore()+"分");
            titleParagraphRun1.setColor("169BD5");
            titleParagraphRun1.setFontSize(12);

            if(StringUtils.isNoneBlank(passingScoreLine)){
                XWPFRun titleParagraphRun2 = titleParagraph.createRun();
                titleParagraphRun2.setText(" 及格分:"+passingScoreLine+"分");
                titleParagraphRun2.setColor("20B2AA");
                titleParagraphRun2.setFontSize(12);
            }

            // 加个换行
            XWPFParagraph paragraph = document.createParagraph();
            XWPFRun paragraphRun = paragraph.createRun();
            paragraphRun.addCarriageReturn();
            paragraphRun.addCarriageReturn();

            //String类型的json数组转List对象
            Type listType = new TypeToken<List<TestPaper>>() {}.getType();
            ArrayList<TestPaper> testPapers = new Gson().fromJson(te.getContent(), listType);
            for(int i=0;i<testPapers.size();i++){

                TestPaper testPaper = testPapers.get(i);
                String scoreType = "";
                String subjectType = "";
                if(testPaper.getSubjectType().equals(0)){
                    subjectType = "单选题";
                }else if(testPaper.getSubjectType().equals(1)){
                    subjectType = "多选题";
                    if(testPaper.getScoreType().equals(0)){
                        scoreType = "[少选得部分分]";
                    }else if(testPaper.getScoreType().equals(1)){
                        scoreType = "[少选不得分]";
                    }
                }else if(testPaper.getSubjectType().equals(2)){
                    subjectType = "判断题";
                }

                // 题目
                XWPFParagraph firstParagraph = document.createParagraph();
                XWPFRun run = firstParagraph.createRun();
                run.setText((i+1) + "." + testPaper.getTitle());
                run.setFontSize(14);
                XWPFRun run1 = firstParagraph.createRun();
                run1.setColor("FF9966");
                run1.setText(" （"+testPaper.getScore()+"分）【"+subjectType+"】"+scoreType);
                run1.setFontSize(14);

                //选项
                for(int j=0;j<testPaper.getOp().size();j++){
                    String op = testPaper.getOp().get(j);
                    XWPFParagraph firstParagraph1 = document.createParagraph();
                    XWPFRun run_1 = firstParagraph1.createRun();
                    String index = (j+1) + "" ;
                    String trueAnswer = testPaper.getTrueAnswer().contains(index)?" （正确答案）":"";
                    run_1.setText("      " + op);
                    run_1.setFontSize(10);
                    XWPFRun run_2 = firstParagraph1.createRun();
                    run_2.setColor("67b168");
                    run_2.setText(" "+trueAnswer);
                    run_2.setFontSize(10);
                }

                //答题解析
                String answerAnalysis = testPaper.getAnswerAnalysis();
                if(StringUtils.isNoneBlank(answerAnalysis)){
                    XWPFRun run2_1 = document.createParagraph().createRun();
                    run2_1.setColor("9370DB");
                    run2_1.setText("  答题解析 : "+answerAnalysis);
                    run2_1.setFontSize(12);
                }

                if(i<(testPapers.size()-1)){//最后一次不换行
                    lineFeed(document);
                }
            }
        }else if(type.equals(PropertyUtil.getProperty("questionnaire.type", "defaultValue"))){
            // 添加标题
            XWPFParagraph titleParagraph = document.createParagraph();
            // 设置段落居中
            titleParagraph.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun titleParagraphRun = titleParagraph.createRun();
            titleParagraphRun.setText(name);
            titleParagraphRun.setFontSize(20);

            // 加个换行
            XWPFParagraph paragraph = document.createParagraph();
            XWPFRun paragraphRun = paragraph.createRun();
            paragraphRun.addCarriageReturn();
            paragraphRun.addCarriageReturn();

            QuestionnaireEstimate qi = (QuestionnaireEstimate)object;
            //String类型的json数组转List对象
            Type listType = new TypeToken<List<Questionnaire>>() {}.getType();
            ArrayList<Questionnaire> questionnaires = new Gson().fromJson(qi.getContent(), listType);
            for(int i=0;i<questionnaires.size();i++){
                Questionnaire questionnaire = questionnaires.get(i);
                String requiredFields = questionnaire.getRequiredFields();
                if("0".equals(requiredFields)){
                    requiredFields = "";
                }else if("1".equals(requiredFields)){
                    requiredFields = "*";
                }
                String subjectType = "";
                if(questionnaire.getSubjectType().equals(0)){
                    subjectType = "单选题";
                }else if(questionnaire.getSubjectType().equals(1)){
                    subjectType = "多选题";
                }else if(questionnaire.getSubjectType().equals(2)){
                    subjectType = "矩阵量表题";
                }else if(questionnaire.getSubjectType().equals(3)){
                    subjectType = "简答题";
                }

                // 题目
                XWPFParagraph firstParagraph1 = document.createParagraph();
                XWPFRun run1 = firstParagraph1.createRun();
                run1.setColor("f06e57");
                run1.setFontSize(14);
                run1.setText(requiredFields);

                XWPFRun run1_1 = firstParagraph1.createRun();
                run1_1.setFontSize(14);
                run1_1.setText((i+1) + "." + questionnaire.getTitle());

                XWPFRun run1_2 = firstParagraph1.createRun();
                run1_2.setColor("FF9966");
                run1_2.setFontSize(14);
                run1_2.setText("【"+subjectType+"】");


                //选项
                if(questionnaire.getSubjectType().equals(0) || questionnaire.getSubjectType().equals(1)){//单多
                    for(int j=0;j<questionnaire.getOp().size();j++){
                        String op = questionnaire.getOp().get(j);
                        XWPFParagraph firstParagraph2 = document.createParagraph();
                        // 选项
                        XWPFRun run2 = firstParagraph2.createRun();
                        run2.setText("      " + op);
                        run2.setFontSize(10);

                        String mustAnswer = questionnaire.getMustAnswer().get(j);
                        if("1".equals(mustAnswer)){
                            mustAnswer = "__________________ *";
                        }else if("0".equals(mustAnswer)){
                            mustAnswer = "";
                        }
                        XWPFRun run2_1 = firstParagraph2.createRun();
                        run2_1.setColor("f06e57");
                        run2_1.setFontSize(10);
                        run2_1.setText(mustAnswer);
                    }
                }else if(questionnaire.getSubjectType().equals(2)){//矩阵
                    // 工作经历表格
                    XWPFTable ComTable = document.createTable();

                    // 列宽自动分割
                    CTTblWidth comTableWidth = ComTable.getCTTbl().addNewTblPr().addNewTblW();
                    comTableWidth.setType(STTblWidth.DXA);
                    comTableWidth.setW(BigInteger.valueOf(9072));

                    // 表格第一行
                    XWPFTableRow comTableRowOne = ComTable.getRow(0);
                    comTableRowOne.getCell(0).setText("");
                    for(int j=0;j<questionnaire.getOp().size();j++){
                        String op = questionnaire.getOp().get(j);
                        comTableRowOne.addNewTableCell().setText(op);
                    }
                    //表格其他行
                    for(int j=0;j<questionnaire.getOpt().size();j++){
                        String opt = questionnaire.getOpt().get(j);
                        XWPFTableRow comTableRowTwo = ComTable.createRow();
                        comTableRowTwo.getCell(0).setText(opt);
                        for(int f=0;f<questionnaire.getOp().size();f++){
                            comTableRowTwo.getCell(f+1).setText("");
                        }
                    }
                }
                if(i<(questionnaires.size()-1)){//最后一次不换行
                    lineFeed(document);
                }
            }
        }
        //创建临时文件的目录
        File file = new File(tempPath);
        if(!file.exists()){
            file.mkdirs();
        }
        String dateTime = new SimpleDateFormat("YYYYMMddHHmmssSSS").format(new Date());
        //临时文件路径/文件名
        String downPath = file + "/"  + name+"_"+dateTime+".docx";
        OutputStream outputStream = null;
        try {
            //使用FileOutputStream将内存中的数据写到本地，生成临时文件
            outputStream = new FileOutputStream(downPath);
            document.write(outputStream);
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return downPath;
    }



    //写入html内容到word文件,返回临时文件夹路径
    public static String writeTempWord(String message,String name) throws IOException {
        String tempPath = PropertyUtil.getProperty("temp.path", "defaultValue");
        //创建临时文件的目录
        File file = new File(tempPath);
        if(!file.exists()){
            file.mkdirs();
        }
        String dateTime = new SimpleDateFormat("YYYYMMddHHmmssSSS").format(new Date());
        //临时文件路径/文件名
        String downPath = file + "/"  + name+"_"+dateTime+".doc";
        OutputStream outputStream = null;
        InputStream inputStream = null ;
        try {
            //使用FileOutputStream将内存中的数据写到本地，生成临时文件
            byte[] bs = message.getBytes();
            ByteArrayInputStream bais = new ByteArrayInputStream(bs);
            POIFSFileSystem poifs = new POIFSFileSystem();
            DirectoryEntry directory = poifs.getRoot();
            DocumentEntry documentEntry = directory.createDocument("WordDocument", bais);
            outputStream = new FileOutputStream(downPath);
            poifs.writeFilesystem(outputStream);
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(outputStream != null) {
                    outputStream.close();
                }
                if(inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return downPath;
    }



    // 两个表格之间加个换行
    public static void lineFeed(XWPFDocument document){
        XWPFRun paragraph1 = document.createParagraph().createRun();
        paragraph1.addCarriageReturn();
        paragraph1.addCarriageReturn();
        paragraph1.addCarriageReturn();
    }


//
//    //生成简单样例
//    public static void main(String[] args) throws Exception {
//        // Blank Document
//        XWPFDocument document = new XWPFDocument();
//        // Write the Document in file system
//        FileOutputStream out = new FileOutputStream(new File("/Users/huangyeqiang/Downloads/create_table.docx"));
//
//        // 添加标题
//        XWPFParagraph titleParagraph = document.createParagraph();
//        // 设置段落居中
//        titleParagraph.setAlignment(ParagraphAlignment.CENTER);
//
//        XWPFRun titleParagraphRun = titleParagraph.createRun();
//        titleParagraphRun.setText("考试试卷标题");
//        titleParagraphRun.setFontSize(20);
//
//
//
//
//        // 题目
//        XWPFParagraph firstParagraph = document.createParagraph();
//        XWPFRun run = firstParagraph.createRun();
//        run.setText("1.Java POI 生成word文件。");
//        run.setFontSize(16);
//        // 选项
//        XWPFRun run_1 = document.createParagraph().createRun();
//        run_1.setText("      a.3432234。");
//        run_1.setFontSize(12);
//        // 选项
//        XWPFRun run_2 = document.createParagraph().createRun();
//        run_2.setText("       b.32423432。");
//        run_2.setFontSize(12);
//
//        // 两个表格之间加个换行
//        XWPFParagraph paragraph = document.createParagraph();
//        XWPFRun paragraphRun = paragraph.createRun();
//        paragraphRun.setText("\r");
//
//
//
//        // 题目
//        XWPFRun run1 = document.createParagraph().createRun();
//        run1.setText("1.Java POI 生成word文件。");
//        run1.setFontSize(16);
//        // 选项
//        XWPFRun run1_1 = document.createParagraph().createRun();
//        run1_1.setText("      a.3432234。");
//        run1_1.setFontSize(12);
//        // 选项
//        XWPFRun run1_2 = document.createParagraph().createRun();
//        run1_2.setText("       b.32423432。");
//        run1_2.setFontSize(12);
//
//
//        document.write(out);
//        out.close();
//        System.out.println("create_table document written success.");
//    }
//


//
//    //生成表格样例
//    public static void main(String[] args) throws Exception {
//        // Blank Document
//        XWPFDocument document = new XWPFDocument();
//        // Write the Document in file system
//        FileOutputStream out = new FileOutputStream(new File("/Users/huangyeqiang/Downloads/create_table.docx"));
//
//         // 添加标题
//         XWPFParagraph titleParagraph = document.createParagraph();
//         // 设置段落居中
//         titleParagraph.setAlignment(ParagraphAlignment.CENTER);
//
//         XWPFRun titleParagraphRun = titleParagraph.createRun();
//         titleParagraphRun.setText("Java PoI");
//         titleParagraphRun.setFontSize(20);
//
//         // 段落
//         XWPFParagraph firstParagraph = document.createParagraph();
//         XWPFRun run = firstParagraph.createRun();
//        run.setText("Java POI 生成word文件。");
//         run.setFontSize(16);
//        run.setColor("BED4F1");
//
////        XWPFParagraph firstParagraph222 = document.createParagraph();
//        XWPFRun run222 = firstParagraph.createRun();
//        run222.setText("323232323。");
//        run222.setFontSize(16);
//        run222.setColor("FF0000");
//
//
//         // 换行
//         XWPFParagraph paragraph1 = document.createParagraph();
//         XWPFRun paragraphRun1 = paragraph1.createRun();
//         paragraphRun1.setText("\r");
//
//         // 基本信息表格
//         XWPFTable infoTable = document.createTable();
//         // 去表格边框
//         infoTable.getCTTbl().getTblPr().unsetTblBorders();
//
//         // 列宽自动分割
//         CTTblWidth infoTableWidth = infoTable.getCTTbl().addNewTblPr().addNewTblW();
//         infoTableWidth.setType(STTblWidth.DXA);
//         infoTableWidth.setW(BigInteger.valueOf(9072));
//
//         // 表格第一行
//         XWPFTableRow infoTableRowOne = infoTable.getRow(0);
//         infoTableRowOne.getCell(0).setText("职位");
//         infoTableRowOne.addNewTableCell().setText(": Java 开发工程师");
//
//         // 表格第二行
//         XWPFTableRow infoTableRowTwo = infoTable.createRow();
//         infoTableRowTwo.getCell(0).setText("姓名");
//         infoTableRowTwo.getCell(1).setText(": seawater");
//
//         // 表格第三行
//         XWPFTableRow infoTableRowThree = infoTable.createRow();
//         infoTableRowThree.getCell(0).setText("生日");
//         infoTableRowThree.getCell(1).setText(": xxx-xx-xx");
//
//         // 表格第四行
//         XWPFTableRow infoTableRowFour = infoTable.createRow();
//         infoTableRowFour.getCell(0).setText("性别");
//         infoTableRowFour.getCell(1).setText(": 男");
//
//         // 表格第五行
//         XWPFTableRow infoTableRowFive = infoTable.createRow();
//         infoTableRowFive.getCell(0).setText("现居地");
//         infoTableRowFive.getCell(1).setText(": xx");
//
//         // 两个表格之间加个换行
//         XWPFParagraph paragraph = document.createParagraph();
//         XWPFRun paragraphRun = paragraph.createRun();
//         paragraphRun.setText("\r");
//
//         // 工作经历表格
//         XWPFTable ComTable = document.createTable();
//
//         // 列宽自动分割
//         CTTblWidth comTableWidth = ComTable.getCTTbl().addNewTblPr().addNewTblW();
//         comTableWidth.setType(STTblWidth.DXA);
//         comTableWidth.setW(BigInteger.valueOf(9072));
//
//         // 表格第一行
//         XWPFTableRow comTableRowOne = ComTable.getRow(0);
//         comTableRowOne.getCell(0).setText("开始时间");
//         comTableRowOne.addNewTableCell().setText("结束时间");
//         comTableRowOne.addNewTableCell().setText("公司名称");
//         comTableRowOne.addNewTableCell().setText("title");
//
//         // 表格第二行
//         XWPFTableRow comTableRowTwo = ComTable.createRow();
//         comTableRowTwo.getCell(0).setText("2016-09-06");
//         comTableRowTwo.getCell(1).setText("至今");
//         comTableRowTwo.getCell(2).setText("seawater");
//         comTableRowTwo.getCell(3).setText("Java开发工程师");
//
//         // 表格第三行
//         XWPFTableRow comTableRowThree = ComTable.createRow();
//         comTableRowThree.getCell(0).setText("2016-09-06");
//         comTableRowThree.getCell(1).setText("至今");
//         comTableRowThree.getCell(2).setText("seawater");
//         comTableRowThree.getCell(3).setText("Java开发工程师");
//
//         CTSectPr sectPr = document.getDocument().getBody().addNewSectPr();
//         XWPFHeaderFooterPolicy policy = new XWPFHeaderFooterPolicy(document, sectPr);
//
//         //添加页眉
//         CTP ctpHeader = CTP.Factory.newInstance();
//         CTR ctrHeader = ctpHeader.addNewR();
//         CTText ctHeader = ctrHeader.addNewT();
//         String headerText = "Java POI create MS word file.";
//         ctHeader.setStringValue(headerText);
//         XWPFParagraph headerParagraph = new XWPFParagraph(ctpHeader, document);
//         // 设置为右对齐
//         headerParagraph.setAlignment(ParagraphAlignment.RIGHT);
//         XWPFParagraph[] parsHeader = new XWPFParagraph[1];
//         parsHeader[0] = headerParagraph;
//         policy.createHeader(XWPFHeaderFooterPolicy.DEFAULT, parsHeader);
//
//         // 添加页脚
//         CTP ctpFooter = CTP.Factory.newInstance();
//         CTR ctrFooter = ctpFooter.addNewR();
//         CTText ctFooter = ctrFooter.addNewT();
//         String footerText = "http://www.gongyoumishu.com/";
//         ctFooter.setStringValue(footerText);
//         XWPFParagraph footerParagraph = new XWPFParagraph(ctpFooter, document);
//         headerParagraph.setAlignment(ParagraphAlignment.CENTER);
//         XWPFParagraph[] parsFooter = new XWPFParagraph[1];
//         parsFooter[0] = footerParagraph;
//         policy.createFooter(XWPFHeaderFooterPolicy.DEFAULT, parsFooter);
//
//        document.write(out);
//        out.close();
//        System.out.println("create_table document written success.");
//    }
}