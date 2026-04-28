package sgis.sys.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

public class FilterUtils implements Filter{
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpSession session = req.getSession();
		String requestURI = req.getRequestURI();
		/* 메뉴 URL 
		 * page.do : 메뉴 첫페이지 
		 * %%view.do : 상세페이지
		 * %%insPg.do : 등록페이지
		 * %%udtPg.do : 수정페이지
		 * 
		 * %%ins.do : 단일등록
		 * %%udt.do : 단일수정
		 * %%del.do : 단일삭제 
		 * 
		 * %%insert.do : 다중등록
		 * %%update.do : 다중등록
		 * %%delete.do : 다중삭제
		 * 
		 * pop%%.do : 팝업
		 * 
		 */
		// view.do, udtPg.do, udt.do, del.do URL에서 체크, (pop 단어 포함 X)
		// SEQNO  값이 NULL, '', '0' 인 경우에는 메뉴 첫페이지로 이동 (page.do)
		// pop, .do 세션정보 체크 후 정보가 없으면 로그인 페이지로 이동
		response.setCharacterEncoding("UTF-8"); 
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = null;
		
		String userSe = String.valueOf(session.getAttribute("sess_userSe"));
		String uri = String.valueOf(req.getRequestURI());
		String userName = String.valueOf(session.getAttribute("sess_userName"));
		String hearderValue = req.getHeader("AJAX");
		String upperURI = requestURI.toUpperCase();
		String seqNo = req.getParameter("SEQNO");
		if(seqNo == null) {
			seqNo = req.getParameter("NOTICEID");
		}
		
		// 세션만료 아닐시
		if(userSe != null) {
			if(userSe.equals("A")) {// 관리자 경우
				if(!uri.contains("/ckeditor/")) {
					if(!uri.contains("/mn/")){// 관리자경우 mn포함안된경우
						if(!uri.contains("/login/") && !uri.contains("/popup/") ) {// mn포함 안된상태에서 로그아웃, 팝업처리 위해분기처리
							out = response.getWriter();
							out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
							out.println("<script type='text/javascript'>");
							out.println("$(document).ready(function(){");
							out.println("location.href='/mn/notice/page.do'");
							out.println("});");
							out.println("</script>");
							out.flush();
							out.close();
						}
					}
				}
				
				//[주문확정처리] 메뉴에 접근 권한이 없는 관리자가 접근할 경우 [제품조회 및 주문조회]로 보내는 logic
				if(session.getAttribute("sess_accesAuthor").equals("N")){
					if(upperURI.contains("DCSNPROCESS")){
						out = response.getWriter();
						out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
						out.println("<script type='text/javascript'>");
						out.println("$(document).ready(function(){");
						out.println("location.href='/mn/prdInqire/rflect.do'");
						out.println("});");
						out.println("</script>");
						out.flush();
						out.close();
					}
				}
			}else if(userSe.equals("U")) {//거래처 경우
				if(uri.contains("/mn/")) {// 거래처 경우  mn포함되면 공지사항이동
					out = response.getWriter();
					out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
					out.println("<script type='text/javascript'>");
					out.println("$(document).ready(function(){");
					out.println("location.href='/notice/page.do'");
					out.println("});");
					out.println("</script>");
					out.flush();
					out.close();
				}
			}
		}
		
		//미수금이 존재할 경우[제품조회 및 주문등록], [주문 내역 수정] 이용 불가 처리
		if(session.getAttribute("sess_unColectMoney") !=null){
			if(session.getAttribute("sess_userSe").equals("U")){
				if((Boolean) session.getAttribute("sess_unColectMoney")){
					if(upperURI.contains("PRDINQIRE") || upperURI.contains("ORDMOD")){
						out = response.getWriter();
						out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
						out.println("<script type='text/javascript'>");
						out.println("$(document).ready(function(){");
						out.println("location.href='/notice/rflect.do'");
						out.println("});");
						out.println("</script>");
						out.flush();
						out.close();
					}
				}
			}
		}
		
		String pg = req.getParameter("pg");
		boolean sessionChk = true;
		boolean seqNoChk = true;
		String firstURI = requestURI.substring(requestURI.indexOf("/"), requestURI.lastIndexOf("/"));
		
		if(hearderValue != null) {
			if(userName == null || userName.equals("null")) {
				//ajax이면서 세션만료
				sessionChk = false;
			}
		}
		
		if(userName != null) {
			if(upperURI.contains("VIEW.DO") || upperURI.contains("UDTPG.DO") || upperURI.contains("UDT.DO") || upperURI.contains("DEL.DO")) {
				if(seqNo == null || seqNo.equals("null") || seqNo == "" || seqNo == "0") {
					seqNoChk = false;
				}
			}else if(upperURI.contains("LIST.DO")){
				if(upperURI.contains("POP")) {
					pg = req.getParameter("popPg");
				}
				if(pg == null || pg.equals("null") || pg == "") {
					seqNoChk = false;
				}
			}
		}
		
		if(!sessionChk) {
			//login이동
			out = response.getWriter();
			out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
			out.println("<script type='text/javascript'>");
			out.println("$(document).ready(function(){");
			out.println("location.href='/login/loginPg.do'");
			out.println("});");
			out.println("</script>");
			out.flush();
			out.close();
		}else {
			if(!seqNoChk) {
				//page이동
				out = response.getWriter();
				out.println("<script src='/resources/js/jquery-3.3.1.min.js'></script>");
				out.println("<script type='text/javascript'>");
				out.println("$(document).ready(function(){");
				out.println("location.href='"+firstURI+"/page.do'");
				out.println("});");
				out.println("</script>");
				out.flush();
				out.close();
			}else {
				//정상이동
				chain.doFilter(request, response);
			}
		}
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}
	
}
