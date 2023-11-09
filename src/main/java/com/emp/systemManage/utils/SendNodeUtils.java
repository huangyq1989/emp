package com.emp.systemManage.utils;

import org.apache.http.HttpResponse;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import java.time.Instant;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


/**
 * 发送短信
 * */
public class SendNodeUtils {


    private static Logger logger = Logger.getLogger(SendNodeUtils.class);


    //发短信息
    public static Map<String,Object> sendNode(String message,String mobile) {
        Map<String,Object> map = new HashMap<String,Object>();
        /**
         * 携带Cookies、参数、Header的POST请求
         */
        try {
            // 1:----设置传递参数----
            // 创建post对象
            String url = PropertyUtil.getProperty("sendNode.path", "defaultValue");
            HttpPost post = new HttpPost(url);

            // 2:设置Headers头信息(客户要求的head信息)
            long nowM = Instant.now().getEpochSecond();
            String token = "KCWyQJzFdVHDL8fWb4Jj7FyNGdFDpkzh" + nowM;
            token = CommonUtils.md5Encryption(token);
            post.addHeader("Content-Type", "application/x-www-form-urlencoded");
            post.addHeader("client", "exam");
            post.addHeader("token", token);
            post.addHeader("timeLine", nowM+"");


            // 3.创建集合 添加参数
            List<BasicNameValuePair> list = new LinkedList<>();
            BasicNameValuePair param1 = new BasicNameValuePair("mobile", mobile);
            BasicNameValuePair param2 = new BasicNameValuePair("message", message);
            list.add(param1);
            list.add(param2);
            // 使用URL实体转换工具
            UrlEncodedFormEntity entityParam = new UrlEncodedFormEntity(list, "UTF-8");
            //保存在body
            post.setEntity(entityParam);


            // 4：----设置Cookie信息----
            // 创建CookieStore对象用来管理cookie
            CookieStore cookieStore = new BasicCookieStore();
            // new BasicClientCookie对象 用来注入cookie
            BasicClientCookie cookie = new BasicClientCookie("SessionID", "11AABB22");

            cookie.setDomain("localhost");// 设置cookie的作用域

            cookieStore.addCookie(cookie);// 将cookie添加到cookieStore中

            HttpClient client = HttpClients.custom().setDefaultCookieStore(cookieStore).build();

            // 5.执行Post请求
            HttpResponse response = client.execute(post);
            // 将response对象转换成String类型
            String responseStr = EntityUtils.toString(response.getEntity(), "utf-8");
            logger.info("SendNodeUtils.sendNode: "+responseStr);

            map.put("code",0);
            map.put("message","");
            return map;
        } catch (Exception e) {
            logger.error(e.getMessage());
            map.put("code",1);
            map.put("message",e.getMessage());
            return map;
        }
    }
}
