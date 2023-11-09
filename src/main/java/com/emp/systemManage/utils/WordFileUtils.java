package com.emp.systemManage.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;


/**
 * <p>Word文件工具类
 */
public class WordFileUtils {

    /**
     * <p>从2003Word文档中提取文本信息
     *
     * @param  wordFile word
     *
     * @return 提取后的文本信息
     */
    protected static String extractTextFrom2003WordFile(File wordFile) {
        String returnValue = null;
        if (wordFile != null) {

            if (wordFile.isFile()) {

                InputStream inputStream = null;
                try {

                    inputStream = new FileInputStream(wordFile);
                    WordExtractor wordExtractor = new WordExtractor(inputStream);
                    returnValue = wordExtractor.getText();
                } catch (Exception ex) {

                    System.err.println(ex.getMessage());
                } finally {

                    IOUtils.closeQuietly(inputStream);
                }
            }
        }
        return returnValue;
    }


    /**
     * <p>从2007Word文档中提取文本信息
     *
     * @param  wordFile word
     *
     * @return 提取后的文本信息
     */
    protected static String extractTextFrom2007WordFile(File wordFile) {
        String returnValue = null;
        if (wordFile != null) {
            if (wordFile.isFile()) {
                InputStream inputStream = null;
                try {
                    inputStream = new FileInputStream(wordFile);
                    XWPFDocument document = new XWPFDocument(inputStream);
                    XWPFWordExtractor wordExtractor = new XWPFWordExtractor(document);
                    returnValue = wordExtractor.getText();
                } catch (Exception ex) {
                    System.err.println(ex.getMessage());
                } finally {

                    IOUtils.closeQuietly(inputStream);
                }
            }
        }
        return returnValue;
    }


    /**
     * <p>判断是2003还是2007从word文档中提取文本信息
     *
     * @param  wordFile word
     *
     * @return 提取后的文本信息
     *
     */
    public static String extractTextFromWordFile(File wordFile) {
        String resultText = null;
        if (wordFile != null && wordFile.exists()) {
            String extension = FilenameUtils.getExtension(wordFile.getName());
            if (StringUtils.equalsIgnoreCase("doc" , extension)) {
                //Office2003版文件处理
                resultText = WordFileUtils.extractTextFrom2003WordFile(wordFile);
            } else if (StringUtils.equalsIgnoreCase("docx" , extension)) {
                //Office2007版文件处理
                resultText = WordFileUtils.extractTextFrom2007WordFile(wordFile);
            } else {
                //文件类型有误
            }
        }
        return resultText;
    }


//    public static void main(String[] args){
//        File wordFile = new File("/Users/huangyeqiang/Downloads/examQuestionsTemplate.docx");
//        //读取Word文档中所有文本内容，以字符串形式返回
//        System.out.println(WordFileUtils.extractTextFromWordFile(wordFile));
//    }
}
