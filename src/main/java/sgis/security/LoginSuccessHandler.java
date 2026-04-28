package sgis.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import sgis.security.dto.user;

public class LoginSuccessHandler implements AuthenticationSuccessHandler {
	//참고 : https://zgundam.tistory.com/52
	Logger logger = LoggerFactory.getLogger(this.getClass());

	private RequestCache requestCache = new HttpSessionRequestCache();
	private String targetUrlParameter;
	private String defaultUrl;
	private boolean useReferer;
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	public LoginSuccessHandler(){
		targetUrlParameter = "";
		defaultUrl = "/";
		useReferer = false;
	}

	public String getTargetUrlParameter() {
		return targetUrlParameter;
	}

	public void setTargetUrlParameter(String targetUrlParameter) {
		this.targetUrlParameter = targetUrlParameter;
	}

	public String getDefaultUrl() {
		return defaultUrl;
	}

	public void setDefaultUrl(String defaultUrl) {
		this.defaultUrl = defaultUrl;
	}

	public boolean isUseReferer() {
		return useReferer;
	}

	public void setUseReferer(boolean useReferer) {
		this.useReferer = useReferer;
	}


	public String replaceUrl(String oldUrl){
		String returnUrl="";

		if(!"".equals(oldUrl) && !oldUrl.equals(null)){
			//oldUrl에 상세페이지 url이 포함 됐을 경우
			if(oldUrl.indexOf("view.do")>-1){
				returnUrl = oldUrl.replace("view.do", "listPg.do");
			}else{
				returnUrl = oldUrl;
			}
		}

		logger.debug("replaceUrl.run().returnUrl  ::  " + returnUrl);
		return returnUrl;
	}

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		logger.debug("LoginSuccessHandler.onAuthenticationSuccess.run()");
		/* http://chomman.github.io/blog/java/spring%20security/programming/spring-security-redirect-previous-after-login/
		 * HttpSession session = request.getSession();
		logger.debug("session  :: " + session);
		logger.debug("session.prevPage  :: " + session.getAttribute("prevPage"));*/

		clearAuthenticationAttributes(request);

		/*//Security에서 로그인 정보를 받아와서session에 담는다.
		 * session 처리 http://yakolla.tistory.com/49*/
		HttpSession session = request.getSession();
		user userDetails = (user)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		session.setAttribute("sess_bizrNo", userDetails.getBizrNo());
		session.setAttribute("sess_cmpNm", userDetails.getCmpNm());
		session.setAttribute("sess_bcncCode", userDetails.getBcncCode());
		session.setAttribute("sess_userName", userDetails.getUsername());
		session.setAttribute("sess_registBplc", userDetails.getRegistBplc());
		session.setAttribute("sess_userSe", userDetails.getUserSe());
		session.setAttribute("sess_mummOrderQy", userDetails.getMummOrderQy());
		session.setAttribute("sess_ordBplcNm", userDetails.getOrdBplcNm());
		session.setAttribute("sess_dlivyStopAt", userDetails.getDlivyStopAt());
		
		session.setAttribute("sess_bilLmt", userDetails.getBilLmt());
		session.setAttribute("sess_crdtLmt", userDetails.getCrdtLmt());
		
		//로그인한 사용자의 ID 저장
		String userId = ""; 
		String saveIdChk = String.valueOf(request.getParameter("saveId"));
		
		//사용자 구분에 따라 menu url변경
		String userSe = userDetails.getUserSe();
		if(userSe.equals("A")){
			defaultUrl = "/mn/prdInqire/page.do";
			userId = userDetails.getBcncCode();
			
			//관리자여도 프로그램사용권한 값에 따라 접근할 수 있는 메뉴를 제한한다.
			session.setAttribute("sess_accesAuthor", userDetails.getAccesAuthor());
		}else {
			defaultUrl = "/prdInqire/page.do";
			userId = userDetails.getUsername();
			
			//거래처일 경우 미수금 session에 담아줌
			session.setAttribute("sess_unColectMoney", userDetails.getUnColectMoney());

			//어음한도가 1일때에만 값 세팅
			if(userDetails.getBilLmt().equals("1")){
				session.setAttribute("sess_unColectMoneyAm", userDetails.getUnColectMoneyAm());
			}
			
		}
		
		//로그인 정보 쿠키 저장
		if(!saveIdChk.equals("") && !saveIdChk.equals(null)){
			if(saveIdChk.equals("Y")){
				Cookie cookie = new Cookie("CusID",userId);
				cookie.setMaxAge(60*60*24*60);
				cookie.setPath(request.getContextPath()+"/");
				response.addCookie(cookie);
			}else{
				Cookie cookie = new Cookie("CusID","");
				cookie.setMaxAge(0);
				cookie.setPath(request.getContextPath()+"/");
				response.addCookie(cookie);
			}
		}

		int intRedirectStrategy = decideRedirectStrategy(request, response);

		switch(intRedirectStrategy){
		case 1:
			useTargetUrl(request, response);
			break;
		case 2:
			useSessionUrl(request, response);
			break;
		case 3:
			useRefererUrl(request, response);
			break;
		default:
			useDefaultUrl(request, response);
		}

	}

	private void clearAuthenticationAttributes(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if (session == null) {
			return;
		}
		session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
	}

	private void useTargetUrl(HttpServletRequest request, HttpServletResponse response) throws IOException{
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		if(savedRequest != null){
			requestCache.removeRequest(request, response);
		}
		String targetUrl = request.getParameter(targetUrlParameter);
		targetUrl = replaceUrl(targetUrl);
		logger.debug("useTargetUrl.targetUrl  :: " + targetUrl);

		redirectStrategy.sendRedirect(request, response, targetUrl);
	}

	private void useSessionUrl(HttpServletRequest request, HttpServletResponse response) throws IOException{
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		String targetUrl = savedRequest.getRedirectUrl();
		targetUrl = replaceUrl(targetUrl);
		logger.debug("useSessionUrl.targetUrl  :: " + targetUrl);

		redirectStrategy.sendRedirect(request, response, targetUrl);
	}

	private void useRefererUrl(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String targetUrl = request.getHeader("REFERER");
		targetUrl = replaceUrl(targetUrl);
		logger.debug("useRefererUrl.targetUrl  :: " + targetUrl);

		redirectStrategy.sendRedirect(request, response, targetUrl);
	}

	private void useDefaultUrl(HttpServletRequest request, HttpServletResponse response) throws IOException{
		logger.debug("useDefaultUrl.defaultUrl  :: " + defaultUrl);
		redirectStrategy.sendRedirect(request, response, defaultUrl);
	}

	/**
	 * 인증 성공후 어떤 URL로 redirect 할지를 결정한다
	 * 판단 기준은 targetUrlParameter 값을 읽은 URL이 존재할 경우 그것을 1순위
	 * 1순위 URL이 없을 경우 Spring Security가 세션에 저장한 URL을 2순위
	 * 2순위 URL이 없을 경우 Request의 REFERER를 사용하고 그 REFERER URL이 존재할 경우 그 URL을 3순위
	 * 3순위 URL이 없을 경우 Default URL을 4순위로 한다
	 * @param request
	 * @param response
	 * @return   1 : targetUrlParameter 값을 읽은 URL
	 *            2 : Session에 저장되어 있는 URL
	 *            3 : referer 헤더에 있는 url
	 *            0 : default url
	 */

	private int decideRedirectStrategy(HttpServletRequest request, HttpServletResponse response){
		logger.debug("decideRedirectStrategy.run()");

		int result = 0;
		SavedRequest savedRequest = requestCache.getRequest(request, response);

		logger.debug("decideRedirectStrategy.savedRequest  ::  "+ savedRequest);

		logger.debug("decideRedirectStrategy.targetUrlParameter  ::  "+ targetUrlParameter);
		if(!"".equals(targetUrlParameter)){
			String targetUrl = request.getParameter(targetUrlParameter);
			logger.debug("decideRedirectStrategy.hasText(targetUrl)  ::  "+ StringUtils.hasText(targetUrl));
			if(StringUtils.hasText(targetUrl)){
				result = 1;
			}else{
				if(savedRequest != null){
					result = 2;
				}else{
					String refererUrl = request.getHeader("REFERER");

					logger.debug("refererUrl  :: " + refererUrl);

					if(useReferer && StringUtils.hasText(refererUrl)){
						logger.debug("result==3   :: " + (useReferer && StringUtils.hasText(refererUrl)));
						result = 3;
					}else{
						result = 0;
					}
				}
			}
			return result;
		}
		if(savedRequest != null){
			result = 2;
			return result;
		}
		String refererUrl = request.getHeader("REFERER");
		if(useReferer && StringUtils.hasText(refererUrl)){
			result = 3;
		}else{
			result = 0;
		}
		return result;
	}//decideRedirectStrategy

}//end class
