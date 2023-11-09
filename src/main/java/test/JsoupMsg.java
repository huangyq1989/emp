package test;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class JsoupMsg {

    //链接头
    public static final String baseUrl = "大幅度发";
    //链接后缀
    public static final String baseUrlTwo = "阿打算";
    //开始页
    public static final int beginPage = 1;
    //结束页
    public static final int endPage = 100;
    //线程
    public static ExecutorService executor = Executors.newFixedThreadPool(endPage + 10);
    //存放文件夹
    public static final String baseFilePath = "/Users/huangyq/game/swicth/backUp/";
    //查找关键词
    public static List<String> indexStr = new ArrayList<String>(){{
        add("3");
    }};




    //循环获取
    public static void main(String[] args) throws IOException {
        for(int i = beginPage; i <= endPage; i++){
            System.out.println("------------------------第" + i + "页begin------------------------");
            int finalI = i;
            executor.submit(() -> JsoupMsg.getTitleMsg(finalI));
            System.out.println("------------------------第" + i + "页end------------------------");
        }
    }


    //获取匹配标题内容
    public static void getTitleMsg(int nowPage){
        try{
            String url = baseUrl + baseUrlTwo + nowPage;
            Document document = Jsoup.parse(new URL(url), 100000);
            Elements elements = document.getElementsByClass("tr3 t_one");
            if(elements != null){
                for(Element element : elements){
                    Elements temps = element.select("a[id^=a_ajax_]");
                    if(temps != null){
                        for(Element temp : temps){
                            String text = temp.text();
                            if(StringUtils.isNotBlank(text) && CollectionUtils.isNotEmpty(indexStr)){
                                List<String> tempList = indexStr.stream().filter(item -> text.indexOf(item) != -1).collect(Collectors.toList());
                                if(CollectionUtils.isNotEmpty(tempList)){
                                    String msg = text + "\n" + baseUrl + temp.attr("href") + "\n";
                                    System.out.println("[第" + nowPage + "页]" + msg);
                                    JsoupMsg.makeFile(nowPage, msg);
                                }
                            }
                        }
                    }
                }
            }
        }catch (Exception e){
            System.out.println("getTitleMsg:-----" + e.getMessage());
        }
    }


    //写文件
    public static void makeFile(int nowPage, String msg){
        try{
            if(StringUtils.isNotBlank(msg)){
                File dir = new File(baseFilePath);
                if(!dir.exists()){
                    dir.mkdirs();
                }

                File file = new File(baseFilePath + nowPage + ".txt");
                if(!file.exists()){
                    file.createNewFile();
                }

                FileWriter fileWriter = new FileWriter(file.getPath(), true);
                BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
                bufferedWriter.write(msg);
                bufferedWriter.write("\n");
                bufferedWriter.close();
                fileWriter.close();
            }
        }catch (Exception e){
            System.out.println("makeFile:-----" + e.getMessage());
        }
    }

}
