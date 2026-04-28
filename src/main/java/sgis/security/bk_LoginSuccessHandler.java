package sgis.security;

import java.io.IOException;

import javax.servlet.ServletException;
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
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.util.StringUtils;

import sgis.security.dto.user;

public class bk_LoginSuccessHandler implements AuthenticationSuccessHandler {
Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException, ServletException {
		logger.debug("LoginSuccessHandler.onAuthenticationSuccess.run()");
		/* http://chomman.github.io/blog/java/spring%20security/programming/spring-security-redirect-previous-after-login/
		 * HttpSession session = request.getSession();
		logger.debug("session  :: " + session);
		logger.debug("session.prevPage  :: " + session.getAttribute("prevPage"));*/
		
		HttpSession session = request.getSession();
		user userDetails = (user)SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		session.setAttribute("sess_bcncCode", userDetails.getBcncCode());
		session.setAttribute("sess_userName", userDetails.getUsername());
		
		if(session != null){
			String redirectUrl = (String) session.getAttribute("prevPage");
			logger.debug("redirectUrl  : " + redirectUrl);
			
			if(redirectUrl != null){
				//redirectUrl에 상세페이지 url이 포함 됐을 경우
				if(redirectUrl.indexOf("view.do")>-1){
					redirectUrl = redirectUrl.replace("view.do", "listPg.do");
					
					logger.debug("redirectUrl.replace   :: " + redirectUrl);
					
					session.removeAttribute("prevPage");
					response.sendRedirect(redirectUrl);
				}
			}else {
				response.sendRedirect("/login/menu.do");
				session.removeAttribute("prevPage");
			}
			
		} 
		
	}//onAuthenticationSuccess
}
