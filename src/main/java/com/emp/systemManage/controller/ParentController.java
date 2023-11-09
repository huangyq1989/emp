package com.emp.systemManage.controller;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.apache.log4j.Logger;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

public class ParentController {

    private Logger logger = Logger.getLogger(ParentController.class);

    //保存结果到session
    public void outString(HttpServletResponse response, String source) {
        try {
            PrintWriter out = response.getWriter();
            out.write(source);
        } catch (IOException e) {
            logger.error(e.getMessage());
        }
    }

    //获取二维码或下载二维码
    public void getQRCode(HttpServletRequest request, HttpServletResponse response, String url, String type, String name) {
        //生成二维码
        if (url != null && !"".equals(url)) {
            ServletOutputStream stream = null;
            try {
                int width = 200;
                int height = 200;
                if("download".equals(type)){ //下载二维码,否则查看
                    response.setContentType("image/png");
                    name = URLEncoder.encode(name, "utf-8");
                    response.setHeader("content-disposition","attachment;filename="+name+".png");
                }
                stream = response.getOutputStream();
                QRCodeWriter writer = new QRCodeWriter();
                BitMatrix m = writer.encode(url, BarcodeFormat.QR_CODE, height, width);
                MatrixToImageWriter.writeToStream(m, "png", stream);
            } catch (Exception e) {
                // TODO: handle exception
                e.printStackTrace();
            } finally {
                if (stream != null) {
                    try {
                        stream.flush();
                        stream.close();
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
