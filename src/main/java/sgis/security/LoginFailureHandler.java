package sgis.security;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

public class LoginFailureHandler implements AuthenticationFailureHandler{
	
	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

			System.out.println("onAuthenticationFailure.run()   ::  ");
		
			/* http://antop.tistory.com/153 참조
			 * ObjectMapper om = new ObjectMapper();

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("success", false);
			map.put("message", exception.getMessage());

			// {"success" : false, "message" : "..."}
			String jsonString = om.writeValueAsString(map);

			OutputStream out = response.getOutputStream();
			out.write(jsonString.getBytes());*/
			
			//http://syaku.tistory.com/280 참조
			/*String accept = request.getHeader("accept"); 
			String error = "true"; 
			String message = "로그인실패하였습니다."; 
			if( StringUtils.indexOf(accept, "html") > -1 ) { 
				String redirectUrl = request.getParameter(this.targetUrlParameter); 
				if (redirectUrl != null) { 
					super.logger.debug("Found redirect URL: " + redirectUrl); 
					getRedirectStrategy().sendRedirect(request, response, redirectUrl); 
				} else { 
					super.onAuthenticationFailure(request, response, exception); 
				} 
			} else if( StringUtils.indexOf(accept, "xml") > -1 ) { 
				response.setContentType("application/xml"); 
				response.setCharacterEncoding("utf-8"); 
				String data = StringUtils.join(new String[] { 
						"<?xml version=\"1.0\" encoding=\"UTF-8\"?>", 
						"<response>", 
						"<error>" , error , "</error>", 
						"<message>" ,message , "</message>", 
						"</response>" }); 
				PrintWriter out = response.getWriter(); 
				out.print(data); 
				out.flush(); 
				out.close(); 
			} else if( StringUtils.indexOf(accept, "json") > -1 ) { 
				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				String data = StringUtils.join(new String[] { 
						" { \"response\" : {", " \"error\" : " , error , ", ", 
						" \"message\" : \"", message , "\" ", "} } " 
						}); 
				PrintWriter out = response.getWriter(); 
				out.print(data); 
				out.flush(); 
				out.close(); } 
			}*/
			
			String accept = request.getHeader("accept"); 
			String error = "true"; 
			String message = "로그인실패하였습니다."; 
			
			System.out.println("accept  :: " + accept);
			System.out.println("@@@@  :: " +StringUtils.indexOf(accept, "json"));
			
			if( StringUtils.indexOf(accept, "json") > -1 ) { 
				System.out.println("if in@@    ::");
				
				response.setContentType("application/json"); 
				response.setCharacterEncoding("utf-8"); 
				String data = StringUtils.join(new String[] { 
						" { \"response\" : {", " \"error\" : " , error , ", ", 
						" \"message\" : \"", message , "\" ", "} } " 
						}); 
				
				System.out.println("data :::   " + data);
				
				PrintWriter out = response.getWriter(); 
				out.print(data); 
				out.flush(); 
				out.close(); 
			} 
	}
}
