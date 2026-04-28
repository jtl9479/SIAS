package sgis.cn.menu;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;

@Controller
@RequestMapping("/menu")
public class MenuController extends CommonController{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public static String  se ="cn/";
	public static String  folder ="menu";
	
	@RequestMapping("/menu.do")
	public String menu(CommandMap commandMap, Model model) throws Exception{
		//getBoard(commandMap, model);
		return se+folder+"/menu.tiles";
	}

	public Model getBoard(CommandMap commandMap, Model model) throws Exception{
		
		// 게시판 최근글 1건
		Map<String, Object> resultMap = (Map<String, Object>) commonService.view(commandMap.getMap(), "notice"+".noticeTopOneRead");
		
		// 줄바꿈문자 <br>로 치환
		Map<String,Object> board = resultMap;
		String content = board.get("NOTICECN").toString();
		content = content.replace("\n","<br/>");
		board.put("content", content);
		
		model.addAttribute("board", board);
		
		return model;
	}
}
