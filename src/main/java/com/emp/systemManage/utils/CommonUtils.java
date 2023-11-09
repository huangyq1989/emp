package com.emp.systemManage.utils;


import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CommonUtils {

    private static Logger logger = Logger.getLogger(CommonUtils.class);

    // String数组 转 int数组
    public static int[] stringArrayToIntArray(String [] str) {
        int[] num = new int[str.length];
        for(int i=0;i<num.length;i++){
            num[i]=Integer.parseInt(str[i]);
        }
        return num;
    }



    /**
     * 对象是否为空
     * @param o String,List,Map,Object[],int[],long[]
     * @return
     */
    @SuppressWarnings("rawtypes")
    public static boolean isEmpty(Object o) {
        if (o == null) {
            return true;
        }
        if (o instanceof String) {
            if (o.toString().trim().equals("")) {
                return true;
            }
            if (o.equals("null") || o.equals("NULL")) {
                return true;
            }
        } else if (o instanceof List) {
            if (((List) o).size() == 0) {
                return true;
            }
        } else if (o instanceof Map) {
            if (((Map) o).size() == 0) {
                return true;
            }
        } else if (o instanceof Set) {
            if (((Set) o).size() == 0) {
                return true;
            }
        } else if (o instanceof Object[]) {
            if (((Object[]) o).length == 0) {
                return true;
            }
        } else if (o instanceof int[]) {
            if (((int[]) o).length == 0) {
                return true;
            }
        } else if (o instanceof long[]) {
            if (((long[]) o).length == 0) {
                return true;
            }
        }
        return false;
    }


    //判断是否是数字
    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }


    //判断是不是手机号码
    public static boolean isMobileNO(String mobiles) {
        Pattern p = Pattern.compile("^((13[0-9])|(14[5,7,9])|(15([0-3]|[5-9]))|(166)|(17[0,1,3,5,6,7,8])|(18[0-9])|(19[8|9]))\\d{8}$");
        Matcher m = p.matcher(mobiles);
        return m.matches();
    }


    //判断是不是电子邮箱
    public static boolean isEmail(String email){
        if (null==email || "".equals(email)){
            return false;
        }
        String regEx1 = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        Pattern p = Pattern.compile(regEx1);
        Matcher m = p.matcher(email);
        if(m.matches()){
            return true;
        }else{
            return false;
        }
    }


    /**
     * 18位身份证号 最后一位校验码 判断方法
     * 逻辑：
     * 1：身份证号前17位数分别乘不同的系数
     * 从第1位到17位的系数分别为：7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2
     * 2：将乘积之和除以11，余数可能为：0 1 2 3 4 5 6 7 8 9 10
     * 3：根据余数，分别对应最后一位身份证号：1 0 X 9 8 7 6 5 4 3 2
     * 余数与校验码对应关系：0:1,1:0,2:X,3:9,4:8,5:7,6:6,7:5,8:4,9:3:10:2
     *
     * @param idCard 身份证号
     */
    public static boolean checkIDCard(String idCard) {
        if (idCard == null || idCard.equals("") || idCard.length() != 18) {
            return false;
        }

        char[] chars = idCard.toCharArray();
        int charsLength = chars.length - 1;
        int count = 0;
        for (int i = 0; i < charsLength; i++) {
            int charI = Integer.parseInt(String.valueOf(chars[i]));
            count += charI * (Math.pow(2, 17 - i) % 11);
        }
        String idCard18 = String.valueOf(chars[17]).toUpperCase();

        String idCardLast;
        switch (count % 11) {
            case 0:
                idCardLast = "1";
                break;

            case 1:
                idCardLast = "0";
                break;

            case 2:
                idCardLast = "X";
                break;

            default:
                idCardLast = 12 - (count % 11) + "";
                break;
        }
        return idCard18.equals(idCardLast);
    }




    /**
     * 包含大小写字母及数字且在7-30位
     * 是否包含
     * @param str
     * @return
     */
    public static boolean isLetterDigit(String str) {
        boolean isDigit = false;//定义一个boolean值，用来表示是否包含数字
        boolean isLetter = false;//定义一个boolean值，用来表示是否包含字母
        for (int i = 0; i < str.length(); i++) {
            if (Character.isDigit(str.charAt(i))) {  //用char包装类中的判断数字的方法判断每一个字符
                isDigit = true;
            } else if (Character.isLetter(str.charAt(i))) { //用char包装类中的判断字母的方法判断每一个字符
                isLetter = true;
            }
        }

        String regex = "(?=.*[0-9])(?=.*[a-zA-Z]).{7,30}";
        boolean isRight = isDigit && isLetter && str.matches(regex);
        return isRight;
    }


    /**
     *  处理时间
     * @param oldTime  原时间
     * @param add  增加时间
     * @return
     * @throws ParseException
     */
    public static String TimeAdd(String oldTime,String add) throws ParseException {
        int addMit = Integer.valueOf(add);
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = df.parse(oldTime);
        Date expireTime = new Date(date.getTime() + addMit*60*1000);
        String newTime = df.format(expireTime);
        return newTime;
    }



    /**
     * 是否大于现在的时间
     * true 大于
     * @param date
     * @param dateFormate
     */
    public static boolean isgtNow(String date,String dateFormate) {
        boolean flag = false;
        try {
            Date nowdt = new Date();
            Date compt = CommonUtils.parseDate(date, dateFormate);
            long nowtm = nowdt.getTime();
            long comptm = compt.getTime();
            if(comptm > nowtm) {
                flag=true;
            }
        }catch (Exception e) {
            flag=false;
        }
        return flag;
    }


    /**
     * 字符串时间类型转换返回Date类型
     * @param date 字符串时间
     * @param dateFormat 时间格式
     * @return 转换后的时间
     */
    public static Date parseDate(String date, String dateFormat) {
        if (StringUtils.isEmpty(date)) {
            return null;
        }
        SimpleDateFormat format = new SimpleDateFormat(dateFormat);
        try {
            return format.parse(date);
        } catch (Exception e) {
            logger.error(e.getMessage());
            return null;
        }
    }



    //回写数据到response
    public static void outputToResponse(String filePath, String type,HttpServletResponse response){
        String fileName = null ;
        try{
            fileName = filePath.substring(filePath.lastIndexOf("/")+1);
            //避免文件名中文乱码，将UTF8打散重组成ISO-8859-1编码方式(不转换下载的文件中文是没有的)
            fileName = new String (fileName.getBytes("UTF8"),"ISO-8859-1");
        }catch (IOException e){
            logger.error(e.getMessage());
        }
        //根据临时文件的路径创建File对象，FileInputStream读取时需要使用
        File file = new File(filePath);

        // 设置响应MIME
        if (".doc".equals(type)) {
            response.setContentType("application/msword");
        } else if (".docx".equals(type)) {
            response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        } else if (".pdf".equals(type)) {
            response.setContentType("application/pdf");
        } else if (".xls".equals(type)) {
            response.setContentType("application/vnd.ms-excel");
        } else if (".xlsx".equals(type)) {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        } else if (".ppt".equals(type)) {
            response.setContentType("application/vnd.ms-powerpoint");
        } else if (".pptx".equals(type)) {
            response.setContentType("application/vnd.openxmlformats-officedocument.presentationml.presentation");
        } else if (".bmp".equals(type)) {
            response.setContentType("image/bmp");
        } else if (".gif".equals(type)) {
            response.setContentType("image/gif");
        } else if (".ief".equals(type)) {
            response.setContentType("image/ief");
        } else if (".jpeg".equals(type)) {
            response.setContentType("image/jpeg");
        } else if (".jpg".equals(type)) {
            response.setContentType("image/jpeg");
        } else if (".png".equals(type)) {
            response.setContentType("image/png");
        } else if (".tiff".equals(type)) {
            response.setContentType("image/tiff");
        } else if (".tif".equals(type)) {
            response.setContentType("image/tif");
        }


        //让浏览器下载文件,name是上述默认文件下载名
        response.addHeader("Content-Disposition","attachment;filename=\"" + fileName + "\"");
        InputStream inputStream = null;
        OutputStream outputStream = null;
        try {
            //通过FileInputStream读临时文件，ServletOutputStream将临时文件写给浏览器
            inputStream = new FileInputStream(file);
            outputStream = response.getOutputStream();
            //这句不加的话microsoft excel显示不正常,wps正常
            response.setHeader("Content-Length", String.valueOf(inputStream.available()));
            int len = -1;
            byte[] b = new byte[1024];
            while((len = inputStream.read(b)) != -1){
                outputStream.write(b);
            }
            //刷新
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            //关闭输入输出流
            try {
                if(inputStream != null) {
                    inputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            try {
                if(outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }
        //最后才能删除临时文件，如果流在使用临时文件，file.delete()是删除不了的
        file.delete();
    }



    //回写数据到response(在线预览和下载证书专用,看完后要删除)
    public static void outputCNToResponse(String filePath,String type, HttpServletResponse response){
        OutputStream os = null;
        String filename = null ;
        File file = null ;
        try {

            filename = filePath.substring(filePath.lastIndexOf("/")+1);
            //避免文件名中文乱码，将UTF8打散重组成ISO-8859-1编码方式(不转换下载的文件中文是没有的)
            filename = new String (filename.getBytes("UTF8"),"ISO-8859-1");

            String fileRealPath = filePath;
            file = new File(fileRealPath);
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

            //为空是下载文件
            if(StringUtils.isBlank(type)){
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
        //最后才能删除临时文件，如果流在使用临时文件，file.delete()是删除不了的
        file.delete();
    }



    /**
     * md5加密
     * @param data
     * @return
     * @throws NoSuchAlgorithmException
     */
    public static String md5Encryption(String data) throws NoSuchAlgorithmException {
        //信息摘要器                                算法名称
        MessageDigest md = MessageDigest.getInstance("MD5");
        //把字符串转为字节数组
        byte[] b = data.getBytes();
        //使用指定的字节来更新我们的摘要
        md.update(b);
        //获取密文  （完成摘要计算）
        byte[] b2 = md.digest();
        //获取计算的长度
        int len = b2.length;
        //16进制字符串
        String str = "0123456789abcdef";
        //把字符串转为字符串数组
        char[] ch = str.toCharArray();

        //创建一个32位长度的字节数组
        char[] chs = new char[len*2];
        //循环16次
        for(int i=0,k=0;i<len;i++) {
            byte b3 = b2[i];//获取摘要计算后的字节数组中的每个字节
            // >>>:无符号右移
            // &:按位与
            //0xf:0-15的数字
            chs[k++] = ch[b3 >>> 4 & 0xf];
            chs[k++] = ch[b3 & 0xf];
        }

        //字符数组转为字符串
        return new String(chs);
    }


    //4位数字随机验证码
    public static String getCheckCode() {
        return String.valueOf((int)((Math.random()*9+1)*1000));
    }

}
