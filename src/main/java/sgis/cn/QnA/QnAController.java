package sgis.cn.QnA;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

/**
 * Q&A
 */
@Controller
@RequestMapping("/qna")
public class QnAController extends CommonController{
	public static String  se ="cn/";
	public static String  folder ="qna";
	public static String subMenuCode = "CNQ01";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String searchDtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddMonthDate(-1));
		String searchDtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		commandMap.put("menuSe", subMenuCode);// 메뉴구분
		
		model.addAttribute("subMenu", subMenu(commandMap)); // 웹메뉴공지
		model.addAttribute("searchDtFrom", searchDtFrom);
		model.addAttribute("searchDtTo", searchDtTo);
		model.addAttribute("weekAgo", searchDtFrom);
		model.addAttribute("curDedt", searchDtTo);
		
		return se+folder+"/listPage.tiles";
	}
	
	// 리스트조회
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 10;
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String searchTitle = commandMap.getStrNull("searchTitle");// 내용
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtFrom", searchDtFrom);
		commandMap.put("searchDtTo", searchDtTo);
		commandMap.put("searchTitle", searchTitle);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".qnaListCnt");
		Map<String, Object> resultMap = (Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".qnaList");
		
		model.addAttribute("pg", pg);
		model.addAttribute("qnaList", resultMap.get("list"));
		model.addAttribute("pgNum", (pg-1)*pgCnt);
		model.addAttribute("listTotalCnt", listTotalCnt);
		
		return se+folder+"/list";
	}
	
	// 상세보기(확인중, 확인완료)
	@RequestMapping("/view.do")
	public String view(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int viewSeq = commandMap.getIntNull("SEQNO");
		commandMap.put("WI_ID", viewSeq);
		
		Map<String, Object> resultMap = (Map<String, Object>) commonService.view(commandMap.getMap(), se+folder+".qnaView");
		model.addAttribute("view", resultMap);
		
		return se+folder+"/view.tiles";
	}

	// 등록페이지
	@RequestMapping("/insPg.do")
	public String insPg(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String rgsDe = getCurrentDate_yyyy_mm_dd();
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		
		model.addAttribute("rgsDe",rgsDe);//등록일
		model.addAttribute("register",register);//작성자
		
		return se+folder+"/insert.tiles";
	}
	
	// 등록
	@RequestMapping("/ins.do")
	public String insert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String WI_BCNCWRTER = commandMap.getStrNull("WI_BCNCWRTER");//작성자
		String WI_BCNCCODE = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String WI_TITLE = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_TITLE"));//제목
		String WI_CN = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_CN"));// 내용
		
		if(!WI_BCNCWRTER.equals("")){
			commandMap.put("WI_BCNCWRTER", WI_BCNCWRTER);
			commandMap.put("WI_BCNCCODE", WI_BCNCCODE);
			commandMap.put("WI_TITLE", WI_TITLE);
			commandMap.put("WI_CN", WI_CN);
			
			resultCnt = commonService.insert(commandMap.getMap(), se+folder+".qnaInsert");
		}else{
			System.out.println("@@@  WI_BCNCWRTER==== null  :: "+WI_BCNCWRTER);
			resultCnt = -1;
		}
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	// 수정페이지
	@RequestMapping("/udtPg.do")
	public String udtPg(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int viewSeq = commandMap.getIntNull("SEQNO");
		commandMap.put("WI_ID", viewSeq);
		
		Map<String, Object> resultMap = (Map<String, Object>) commonService.view(commandMap.getMap(), se+folder+".qnaView");
		model.addAttribute("view", resultMap);
		
		return se+folder+"/update.tiles";
	}
	
	// 수정(미확인)
	@RequestMapping("/udt.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String WI_BCNCWRTER = commandMap.getStrNull("WI_BCNCWRTER");//작성자
		String WI_BCNCCODE = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String WI_TITLE = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_TITLE"));//제목
		String WI_CN = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_CN"));// 내용
		
		if(!WI_BCNCWRTER.equals("")){
			commandMap.put("WI_BCNCWRTER", WI_BCNCWRTER);
			commandMap.put("WI_BCNCCODE", WI_BCNCCODE);
			commandMap.put("WI_TITLE", WI_TITLE);
			commandMap.put("WI_CN", WI_CN);
			
			resultCnt = commonService.insert(commandMap.getMap(), se+folder+".qnaUpdate");
		}else{
			System.out.println("@@@  WI_BCNCWRTER==== null  :: "+WI_BCNCWRTER);
			resultCnt = -1;
		}
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	//삭제
	@RequestMapping("/del.do")
	public String noticeDelete(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String WI_ID = commandMap.getStr("WI_ID");//일련번호
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//id
		
		if(!WI_ID.equals("")){
			commandMap.put("WI_ID", WI_ID);
			commandMap.put("register", register);
			resultCnt = commonService.delete(commandMap.getMap(), se+folder+".qnaDelete"); // DELETE쿼리
		}else{
			System.out.println("@@@  WI_ID==== null  :: ");
			resultCnt = -1;
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
}
