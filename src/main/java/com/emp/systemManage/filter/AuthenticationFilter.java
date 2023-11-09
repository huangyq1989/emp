 package com.emp.systemManage.filter;

 import org.springframework.http.HttpStatus;

 import javax.servlet.*;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;
 import javax.servlet.http.HttpSession;
 import java.io.IOException;

 /**
 * 用户鉴权过滤器
 */
public class AuthenticationFilter implements Filter {

	private final String indexTag = "/login/index.do" ;//登录页
	private final String loginTag = "/login/login.do" ;//登录方法

	private final String studentTag1 = "/student/queryStudentsByWeChat.do" ;//根据手机号码登录学员json数据(公众号接口)
	private final String studentTag2 = "/student/querySCByWeChat.do" ;//根据学员ID查询对应的培训情况(公众号接口)
	private final String studentTag3 = "/student/addOrEdit.do" ;//修改学员资料保存(公众号接口和后台共用)
	private final String studentTag4 = "/student/getVerificationCode.do" ;//根据手机号码获取验证码(公众号接口)

	private final String cultivate1 = "/cultivate/queryGuideByWeChat.do" ;//获取培训指引(公众号接口)
	private final String cultivate2 = "/cultivate/previewOrDown.do" ;//下载或在线预览培训指引(公众号接口)

	private final String estimateTag1 = "/estimate/getEstimateByWeChat.do" ;//根据培训ID获取评估json数据(公众号接口)
	private final String estimateTag2 = "/estimate/getQuestionnaireByWeChat.do" ;//根据评估ID获取问卷json数据(公众号接口)
	private final String estimateTag3 = "/estimate/saveQiByWeChat.do" ;//保存问卷作答(公众号接口)

	private final String examinationTag1 = "/examination/getExaminationByWeChat.do" ;//根据培训ID获取考试json数据(公众号接口)
	private final String examinationTag2 = "/examination/getTestPaperByWeChat.do" ;//根据考试ID和学员ID获取试卷,成绩,证书等数据(公众号接口)
	private final String examinationTag3 = "/examination/saveTpByWeChat.do" ;//保存试卷作答(公众号接口)
	private final String examinationTag4 = "/examination/updateECbyExamination.do" ;//打开试卷的时候修改成考试中(公众号接口)
	private final String examinationTag5 = "/examination/downloadCertificateByWeChat.do" ;//下载电子证书(公众号接口)
	private final String examinationTag6 = "/examination/updateECbyResit.do" ;//点击补考(公众号接口)
	private final String examinationTag7 = "/examination/queryEcCodeByWeChat.do" ;//查询考试状态(公众号接口)







	public AuthenticationFilter() {
		super();
	}

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest hrequest = (HttpServletRequest) request;
		HttpServletResponse hresponse = (HttpServletResponse) response;
		HttpSession session = hrequest.getSession();



		// 不过滤的uri
		String[] notFilter = new String[] {"/images", "/js", "/css", "/importModel"};

		// 请求的uri
		String uri = hrequest.getRequestURI();
		// 是否过滤
		boolean doFilter = true;
		for (String s : notFilter) {
			if (uri.indexOf(s) != -1){
				// 如果uri中包含不过滤的uri，则不进行过滤
				doFilter = false;
				break;
			}
		}

		if (uri.contains(indexTag) || uri.contains(loginTag) || uri.contains(studentTag1) || uri.contains(studentTag2) ||  uri.contains(studentTag3) || uri.contains(studentTag4)
				|| uri.contains(cultivate1)|| uri.contains(cultivate2) || uri.contains(estimateTag1) || uri.contains(estimateTag2) || uri.contains(estimateTag3) || uri.contains(examinationTag1)
				|| uri.contains(examinationTag2) || uri.contains(examinationTag3) || uri.contains(examinationTag4) || uri.contains(examinationTag5)
				|| uri.contains(examinationTag6) || uri.contains(examinationTag7)) {
			doFilter = false;
		}

		if (doFilter){
			// 执行过滤
			// 从session中获取登录者实体
			Object obj = hrequest.getSession().getAttribute("employee");
			if (null == obj){
				boolean isAjaxRequest = isAjaxRequest(hrequest);
				if (isAjaxRequest){
					hresponse.setCharacterEncoding("UTF-8");
					hresponse.sendError(HttpStatus.UNAUTHORIZED.value(), "您已经太长时间没有操作,请刷新页面");
					return ;
				}
				hresponse.sendRedirect("../login/index.do");
				return;
			}else{
				// 如果session中存在登录者实体，则继续
				chain.doFilter(request, response);
			}
		}else{
			// 如果不执行过滤，则继续
			chain.doFilter(request, response);
		}
	}

	 /** 判断是否为Ajax请求
	  * <功能详细描述>
	  * @param request
	  * @return 是true, 否false
	  * @see [类、类#方法、类#成员]
	  */
	 public static boolean isAjaxRequest(HttpServletRequest request) {
		 String header = request.getHeader("X-Requested-With");
		 if (header != null && "XMLHttpRequest".equals(header))
			 return true;
		 else
			 return false;
	 }

	public void init(FilterConfig config) throws ServletException {
	}

 }
