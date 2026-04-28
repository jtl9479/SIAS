package sgis.cn.notice;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import sgis.cmmn.CommonController;
import sgis.cmmn.CommonService;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

@Controller
@RequestMapping("/notice")
public class NoticeController extends CommonController{
	public static String  se ="cn/";
	public static String  folder ="notice";
	
	/**
	 * 중간정산 된 미수금 내역이 없거나 미수금이 존재할 경우 [제품조회 및 주문등록], [주문 내역 수정] 접근 제한 Method
	 * 전처리 : filter 
	 * 후처리 : NoticeController.rflect 
	 * @param : commandMap
	 * @param : request
	 * @param : model
	 * @return : page
	 * */
	@RequestMapping("/rflect.do")
	public String rflect(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		//model.addAttribute("alertBoxMsg", "미수금이 존재하여 <br/>[제품조회 및 주문등록], [주문 내역 수정] 메뉴는 <br/> 이용하실 수 없습니다.");
		commandMap.put("alertBoxMsg", "미수금이 존재하여 <br/>[제품조회 및 주문등록], [주문 내역 수정] 메뉴는 <br/> 이용하실 수 없습니다.");
		
		return page(commandMap, request, model);
	}
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		HttpSession session = request.getSession(true);
		
		long totalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".noticeListCnt");
		model.addAttribute("totalCnt", totalCnt);
		
		if(commandMap.containsKey("alertBoxMsg")){
			model.addAttribute("alertBoxMsg", commandMap.getStrNull("alertBoxMsg"));
		}
		
		return se+folder+"/listPage.tiles";
	}
	
	// 리스트조회
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 10;
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".noticeList");
		
		model.addAttribute("pg", pg);
		model.addAttribute("noticeList", resultMap.get("list"));
		model.addAttribute("pgNum", (pg-1)*pgCnt);
		
		return se+folder+"/list";
	}
	
	// 상세보기
	@RequestMapping("/view.do")
	public String view(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int viewSeq = commandMap.getIntNull("SEQNO");
		commandMap.put("ID", viewSeq);
		
		Map<String, Object> resultMap = (Map<String, Object>) commonService.view(commandMap.getMap(), se+folder+".noticeView");
		model.addAttribute("view", resultMap);
		
		return se+folder+"/view.tiles";
	}
}
