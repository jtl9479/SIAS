package sgis.security;


import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class EgovSecurityController {

	Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	
	//@Resource(name="userService")
	//protected UserService userService;
	
	@RequestMapping(value="/user/loginForm.do")
	public String loginForm(ModelMap model) throws Exception {
		LOGGER.info("[URL ==> /user/loginForm.do ]");
		return "security/loginForm.tiles";
	}
	
}
