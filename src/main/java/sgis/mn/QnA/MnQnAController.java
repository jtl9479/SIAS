package sgis.mn.QnA;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

@Controller
@RequestMapping("mn/qna")
public class MnQnAController extends CommonController{
	public static String  se ="mn/";
	public static String  folder ="qna";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String searchDtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddMonthDate(-1));
		String searchDtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		model.addAttribute("searchDtFrom", searchDtFrom);
		model.addAttribute("searchDtTo", searchDtTo);
		model.addAttribute("weekAgo", searchDtFrom);
		model.addAttribute("curDedt", searchDtTo);
		
		return se+folder+"/listPage.tiles";
	}
	
	// 리스트조회
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 10;
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String searchBcncCode = commandMap.getStrNull("searchBcncCode");//거래처코드
		String searchBcncNm = commandMap.getStrNull("searchBcncNm");//거래처명칭
		String searchTitle = commandMap.getStrNull("searchTitle");// 내용
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtFrom", searchDtFrom);
		commandMap.put("searchDtTo", searchDtTo);
		commandMap.put("searchBcncCode", searchBcncCode);
		commandMap.put("searchBcncNm", searchBcncNm);
		commandMap.put("searchTitle", searchTitle);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".qnaListCnt");
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".qnaList");
		
		model.addAttribute("pg", pg);
		model.addAttribute("qnaList", resultMap.get("list"));
		model.addAttribute("pgNum", (pg-1)*pgCnt);
		model.addAttribute("listTotalCnt", listTotalCnt);
		
		
		return se+folder+"/list";
	}
	
	// 등록페이지
	@RequestMapping("/insPg.do")
	public String insPg(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String rgsDe = getCurrentDate_yyyy_mm_dd();
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registerNM = String.valueOf(request.getSession().getAttribute("sess_userName"));
		
		model.addAttribute("rgsDe",rgsDe);//등록일
		model.addAttribute("register",register);//작성자
		model.addAttribute("registerNM",registerNM);//작성자이름
		
		return se+folder+"/insert.tiles";
	}
	
	// 등록
	@RequestMapping("/ins.do")
	public String insert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String WI_PROGRSSE = commandMap.getStrNull("WI_PROGRSSE");//진행상태
		String WI_BCNCWRTER = commandMap.getStrNull("WI_BCNCWRTER");//작성자
		String WI_BCNCCODE = commandMap.getStrNull("searchBcncCode");//거래처코드
		String WI_TITLE = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_TITLE"));//제목
		String WI_CN= StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_CN"));// 내용
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//답변자(관리자)
		String WI_ANSWER = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_ANSWER")); //답변
		
		if(!WI_BCNCCODE.equals("")){
			commandMap.put("WI_PROGRSSE", WI_PROGRSSE);
			commandMap.put("WI_BCNCWRTER", WI_BCNCWRTER);
			commandMap.put("WI_BCNCCODE", WI_BCNCCODE);
			commandMap.put("WI_TITLE", WI_TITLE);
			commandMap.put("WI_CN", WI_CN);
			commandMap.put("bcncCode", bcncCode);
			commandMap.put("WI_ANSWER", WI_ANSWER);
			
			resultCnt = commonService.insert(commandMap.getMap(), se+folder+".qnaInsert");
		}else{
			System.out.println("@@@  WI_BCNCCODE==== null  :: "+WI_BCNCCODE);
			resultCnt = -1;
		}
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	// 상세페이지
	@RequestMapping("/udtPg.do")
	public String udtPg(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int viewSeq = commandMap.getIntNull("SEQNO");
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("WI_ID", viewSeq);
		
		Map<String, Object> resultMap = (Map<String, Object>) commonService.view(commandMap.getMap(), se+folder+".qnaView");
		model.addAttribute("view", resultMap);
		model.addAttribute("register",register);
		
		return se+folder+"/update.tiles";
	}
	
	// 상세
	@RequestMapping("/udt.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String WI_PROGRSSE = commandMap.getStrNull("WI_PROGRSSE");//진행상태
		String WI_BCNCWRTER = commandMap.getStrNull("WI_BCNCWRTER");//작성자
		String WI_TITLE = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_TITLE"));//제목
		String WI_CN= StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_CN"));// 내용
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//답변자(관리자)
		String WI_ANSWER = StringEscapeUtils.unescapeHtml(commandMap.getStrNull("WI_ANSWER"));//답변
		
		if(!WI_PROGRSSE.equals("")){
			commandMap.put("WI_PROGRSSE", WI_PROGRSSE);
			commandMap.put("WI_BCNCWRTER", WI_BCNCWRTER);
			commandMap.put("WI_TITLE", WI_TITLE);
			commandMap.put("WI_CN", WI_CN);
			commandMap.put("bcncCode", bcncCode);
			commandMap.put("WI_ANSWER", WI_ANSWER);
			
			resultCnt = commonService.insert(commandMap.getMap(), se+folder+".qnaUpdate");
		}else{
			System.out.println("@@@  WI_PROGRSSE==== null  :: "+WI_PROGRSSE);
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
			resultCnt = 1;
		}else{
			System.out.println("@@@  WI_ID==== null  :: ");
			resultCnt = -1;
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
}
