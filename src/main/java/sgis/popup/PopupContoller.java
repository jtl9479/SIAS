package sgis.popup;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;

/**
 * 팝업
 * */
@Controller
@RequestMapping("/popup")
public class PopupContoller extends CommonController {
	public static String folder = "popup";
	
	//팝업 페이지
	@RequestMapping("/popPage.do")
	public String popPage(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String nm = commandMap.getStr("name");
		String returnUrl = "/pop"+nm+"Page";
		return folder+returnUrl;
	}
	
	//배송지업체 리스트
	@RequestMapping("/popDLVYList.do")
	public String popDLVYList(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		//관리자 사용시 se = 'Y' 
		int pg = commandMap.getIntNull("popPg");
		int pgCnt = 10;
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		
		if(commandMap.getStr("se").equals("Y")){
			commandMap.put("bcncCode", commandMap.getStr("bcncCd"));
			commandMap.put("registBplc", commandMap.getStr("ordBplc"));
		}else {
			commandMap.put("bcncCode", request.getSession().getAttribute("sess_bcncCode"));
			commandMap.put("registBplc", request.getSession().getAttribute("sess_registBplc"));
		}
		long totalCnt = commonService.listCnt(commandMap.getMap(), folder+".dlvyListCnt");
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), folder+".dlvyList");
		
		model.addAttribute("dlvyList", resultMap.get("list"));
		model.addAttribute("totalCnt", totalCnt);
		
		return folder+"/popDLVYList";
	}

	//사업장 리스트
	@RequestMapping("/popBPLCList.do")
	public String popBPLCList(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("popPg");
		int pgCnt = 10;
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("bcncCode", request.getSession().getAttribute("sess_bcncCode"));
		
		long totalCnt = commonService.listCnt(commandMap.getMap(), folder+".bplcListCnt");
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), folder+".bplcList");
		
		model.addAttribute("bplcList", resultMap.get("list"));
		model.addAttribute("totalCnt", totalCnt);
		
		return folder+"/popBPLCList";
	}
	
	//거래처 리스트
	@RequestMapping("/popBCNCList.do")
	public String popBCNCList(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("popPg");
		int pgCnt = 10;
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		
		long totalCnt = commonService.listCnt(commandMap.getMap(), folder+".bcncListCnt");
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), folder+".bcncList");
		
		model.addAttribute("bcncList", resultMap.get("list"));
		model.addAttribute("totalCnt", totalCnt);
		
		return folder+"/popBCNCList";
	}
	
	//거래처 리스트
	@RequestMapping("/popDVRBCNCList.do")
	public String popDVRBCNCList(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("popPg");
		int pgCnt = 10;
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		
		long totalCnt = commonService.listCnt(commandMap.getMap(), folder+".dvrBcncListCnt");
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), folder+".dvrBcncList");
		
		model.addAttribute("bcncList", resultMap.get("list"));
		model.addAttribute("totalCnt", totalCnt);
		
		return folder+"/popDVRBCNCList";
	}
	
	//패스워드 변경
	@RequestMapping("/popPassword.do")
	public String popPassword(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int result=0;
		int pg = commandMap.getIntNull("popPg");
		String loginId = String.valueOf(request.getSession().getAttribute("sess_userName"));
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		
		commandMap.put("loginId", loginId);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("pg", pg);
		
		/* 비밀번호 변경할 쿼리 name = password
		 * form id popSearchFrm
		 * */
		result = commonService.update(commandMap.getMap(), folder+".password");
		
		//model.addAttribute("pw", commandMap.get("password"));
		model.addAttribute("result", result);
		
		return "jsonView";
	}
	
	
}
