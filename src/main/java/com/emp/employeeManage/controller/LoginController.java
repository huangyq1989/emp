package com.emp.employeeManage.controller;


import com.emp.employeeManage.entity.Employee;
import com.emp.employeeManage.service.imp.EmployeeServiceImp;
import com.emp.systemManage.controller.ParentController;
import com.emp.systemManage.utils.HttpURLUtils;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/login")
public class LoginController extends ParentController {

    private Logger logger = Logger.getLogger(LoginController.class);

    @Autowired
    private EmployeeServiceImp employeeServiceImp;


    //登录页面
    @RequestMapping(value = "/index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView("index");
        return mv;
    }

    //登录系统
    @RequestMapping(value = "/login.do")
    public void login(HttpServletRequest request, HttpServletResponse response,HttpSession httpSession){
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        //判断账号是否存在
        Employee e = employeeServiceImp.queryByUserName(userName,null);
        if(e == null){
            this.outString(response, "1");//错误提示：未找到该用户
        }else{
            //判断密码是否正确
            e = employeeServiceImp.queryByUserName(userName,password);
            if(e == null){
                this.outString(response, "2");//错误提示：密码错误
            }else{
                httpSession.setAttribute("employee",e);
                try{
                    //成功后获取IDC的token
//                    String token = new HttpURLUtils().doPost("http://192.168.46.247:8081/login/token.do?userName=gd_wly&pwd=abc@123&clientId=WLYCMDB",null);
                    String token = "";
                    //转Map对象
                    Map<String,String> map = new Gson().fromJson(token, new TypeToken<Map<String,String>>() {}.getType());
                    httpSession.setAttribute("token",map.get("token"));
                }catch (Exception ex){
                    logger.error("请求接口错误{}",ex);
                }
                this.outString(response, "0");//符合条件
            }
        }
    }

    //跳转首页
    @RequestMapping(value = "/home.do")
    public ModelAndView home(HttpServletRequest request, HttpServletResponse response,HttpSession httpSession){
        ModelAndView mv = new ModelAndView("home");
        return mv;
    }

    //退出系统
    @RequestMapping(value = "/quit.do")
    public ModelAndView quit(HttpServletRequest request, HttpServletResponse response,HttpSession httpSession){
        httpSession.removeAttribute("employee");
        httpSession.invalidate();
        ModelAndView mv = new ModelAndView("index");
        return mv;
    }
}
