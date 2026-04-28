package sgis.login;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import sgis.cmmn.CommonController;
import sgis.cmmn.CommonService;
import sgis.security.dto.user;
import sgis.sys.common.CommandMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/login")
public class LoginController extends CommonController{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public static String  se ="cmmn/";
	public static String  folder ="login";
	
	@RequestMapping(value="/loginPg.do")
	public String loginPage(ModelMap model, HttpServletRequest request) throws Exception {
		String referrer = request.getHeader("Referer");
		request.getSession().setAttribute("prevPage", referrer);
		
		/*referrer 관련 전부 다 주석쳐야함. login, logOut 포함됐을시 문제 발생 가능성있음.*/
		/*String referrer = request.getHeader("Referer");
		//request.getSession().setAttribute("prevPage", referrer);
		logger.debug("referrer  :: " + referrer);
		
		if((referrer.indexOf("loginPg") < 1) || (referrer.indexOf("logOut") < 1)){
			request.getSession().setAttribute("prevPage", referrer);
		}
	    
	    logger.debug("referrer!!!!!!!  :: " + referrer);
	    logger.debug("referrer@@@  :: " + request.getSession().getAttribute("prevPage"));*/
		
		
		/*로그인~시 세션 체크해서 보내야할듯 request.getSession().getAttribute("sess_bcncCode")
		error.jsp 염두
		if(){
			
		}*/
		
		return se+"noTiles/"+folder+"/loginForm.tiles";
	}
	
	/**
	 * 로그아웃
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/logOut.do")
	public String logOut(HttpServletRequest request, Model model){
		HttpSession session = request.getSession();
		session.removeAttribute("prevPage");
		session.invalidate();
		
		return se+"noTiles/"+folder+"/loginForm.tiles";
	}
}
