package test;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class JsoupVideoMsg {

    //链接头
    public static final String baseFinalUrl = "http234com/";
    public static final String baseUrl = baseFinalUrl + "plugin.php?id=dsvue_mjarchive:mjarchive&";
    public static List<Integer> yearList = new ArrayList<Integer>(){{add(2015);add(2016);add(2017);add(2018);add(2019);add(2020);add(2021);add(2022);add(2023);}};
    public static List<Integer> monthList = new ArrayList<Integer>(){{add(1);add(2);add(3);add(4);add(5);add(6);add(7);add(8);add(9);add(10);add(11);add(12);}};
    //线程
    public static ExecutorService executor = Executors.newFixedThreadPool(500 + 10);
    //存放文件夹
    public static final String baseFilePath = "/Users/huangyq/game/swicth/video/";




    //循环获取
    public static void main(String[] args) throws IOException {
        for(Integer year : yearList){
            for(Integer month : monthList){
                if((year == 2015 && month < 6) || (year == 2023 && month > 9)){
                    continue;
                }
                System.out.println("------------------------第" + year + "-" + month + "begin------------------------");
                String basicUrl = "y=" + year + "&m=" + month;
                executor.submit(() -> JsoupVideoMsg.getTitleMsg(basicUrl));
//                String basicUrl = "y=" + "2022" + "&m=" + "1";
//                JsoupVideoMsg.getTitleMsg(basicUrl);
                System.out.println("------------------------第" + year + "-" + month + "end------------------------");
            }

        }
    }


    //获取匹配标题内容
    public static void getTitleMsg(String basicUrl){
        try{
            String nowUrl = baseUrl + basicUrl;
            Document document = Jsoup.parse(new URL(nowUrl), 100000);
            //获取页数
            int pageNum = 1;
            int countPageNum = 1;
            Elements pageEle = document.select("div[class^=pg]");
            if(pageEle != null  && pageEle.size() > 0){
                Elements labelEle = pageEle.get(0).getElementsByTag("label");
                if(labelEle != null  && labelEle.size() > 0){
                    Elements spanEle = labelEle.first().getElementsByTag("span");
                    if(spanEle != null  && spanEle.size() > 0){
                        String pageMsg = spanEle.get(0).attr("title");
                        pageMsg = pageMsg.replace("共 ", "");
                        pageMsg = pageMsg.replace(" 页", "");
                        countPageNum = Integer.valueOf(pageMsg);
                    }
                }
            }
            do {
                String turnUrl = nowUrl + "&page=" + pageNum;
                JsoupVideoMsg.getPageMsg(turnUrl);
                pageNum++;
            }while (pageNum <= countPageNum);
        }catch (Exception e){
            System.out.println("getTitleMsg:-----" + e.getMessage());
        }
    }

    //获取匹配标题内容
    public static void getPageMsg(String basicUrl){
        try{
            Document document = Jsoup.parse(new URL(basicUrl), 100000);
            Element element = document.getElementById("gdtz_lst");
            Elements elements = element.getElementsByTag("ul");
            if(elements != null  && elements.size() > 0){
                Element ulElement = elements.get(0);
                Elements liElements = ulElement.getElementsByTag("li");
                if(liElements != null  && liElements.size() > 0){
                    for(Element liElement : liElements){
                        System.out.println("执行..");
                        Elements aElements = liElement.getElementsByTag("a");
                        if(aElements != null  && aElements.size() > 0){
                            String url = aElements.get(0).attr("href");
                            JsoupVideoMsg.getVideoMsg(url);
                        }
                    }
                }
            }
        }catch (Exception e){
            System.out.println("getTitleMsg:-----" + e.getMessage());
        }
    }


    //获取匹配标题内容
    public static void getVideoMsg(String basicUrl){
        try{
            Document document = Jsoup.parse(new URL(basicUrl), 100000);
            String documentStr = document.toString();
            documentStr = documentStr.replace("\\", "");
            documentStr = documentStr.replace("\"", "");
            String beginStr = "<div class=ylvodv><video src=";
            String endStr = "controls=controls>";
            List<String> findVideoMsgList = JsoupVideoMsg.getChildMsgByParent(documentStr, beginStr, endStr);
            if(CollectionUtils.isNotEmpty(findVideoMsgList)){
                String videoTUrl = findVideoMsgList.get(0);
                videoTUrl = videoTUrl.replace(beginStr, "");
                videoTUrl = videoTUrl.replace(endStr, "");
                String videoUrl = baseFinalUrl + videoTUrl;
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
                int ram = (int)((Math.random()*9+1)*100000);
                String fileName = simpleDateFormat.format(new Date()) + ram + ".mp4";
                System.out.println("准备下载:" + fileName);
                JsoupVideoMsg.downloadMovie(videoUrl, fileName);
            }
        }catch (Exception e){
            System.out.println("getTitleMsg:-----" + e.getMessage());
        }
    }

    public static InputStream getInputStream(String BLUrl){
        try {
            URL url = new URL(BLUrl);
            URLConnection urlConnection = url.openConnection();
            urlConnection.setRequestProperty("Sec-Fetch-Mode", "no-cors");
            urlConnection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36");
            urlConnection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
            urlConnection.setConnectTimeout(10 * 1000);
            return urlConnection.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
            getInputStream(BLUrl);
        }
        return null;
    }

    public static void downloadMovie(String BLUrl, String fileName) {
        InputStream inputStream = getInputStream(BLUrl);
        //定义路径
        String path = baseFilePath + fileName;
        File file = new File(path);
        int i = 1;
        try {
            BufferedInputStream bis = new BufferedInputStream(inputStream);
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
            byte[] bys = new byte[1024];
            int len = 0;
            while ((len = bis.read(bys)) != -1) {
                bos.write(bys, 0, len);
            }
            bis.close();
            bos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 把长报文拆分成多个子报文
     * 拆分规则：以begin开始，以end结尾
     * @param info 待拆分的长报文
     * @param begin 开始字符
     * @param end 结尾字符
     * @return 符合规则的子报文集合
     */
    public static List<String> getChildMsgByParent(String info,String begin,String end){
        //通过起始字符拆分成数组
        String[] split = info.split(begin);
        List<String> list = new ArrayList<>();
        //遍历，从第二个元素开始取值（第一个元素为无效元素）
        for (int i = 1; i < split.length; i++) {
            String str = split[i].substring(0,split[i].lastIndexOf(end)+end.length());
            if (str.length() > end.length()) {
                list.add(begin+str);
            }
        }
        return list;
    }

}
