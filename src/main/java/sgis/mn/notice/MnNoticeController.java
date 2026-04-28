package sgis.mn.notice;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

/**
 * 공지사항
 */
@Controller
@RequestMapping("/mn/notice")
public class MnNoticeController extends CommonController{
	public static String  se ="mn/";
	public static String  folder ="notice";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		HttpSession session = request.getSession(true);
		String searchTitle = commandMap.getStrNull("searchTitle");
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddMonthDate(-1));
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getAddMonthDate(1));
		
		commandMap.remove("searchDtFrom");
		commandMap.remove("searchDtTo");
		
		dtFrom = CommonUtils.dateReplace(dtFrom);
		dtTo = CommonUtils.dateReplace(dtTo);
		
		commandMap.put("searchDtFrom", dtFrom);
		commandMap.put("searchDtTo", dtTo);
		
		
		model.addAttribute("searchTitle", searchTitle);
		model.addAttribute("searchDtFrom", dtFrom);
		model.addAttribute("searchDtTo", dtTo);
		
		return se+folder+"/listPage.tiles";
	}
	
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 10;
		
		String dtFrom = commandMap.getStrNull("searchDtFrom");
		String dtTo = commandMap.getStrNull("searchDtTo");

		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("searchDtFrom", CommonUtils.dateReplace(dtFrom));
		commandMap.put("searchDtTo", CommonUtils.dateReplace(dtTo));
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".noticeListCnt");
		
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".noticeList");
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("noticeList", resultMap.get("list"));
		model.addAttribute("pgNum", (pg-1)*pgCnt);
		
		return se+folder+"/list";
	}
	
	//공지사항 등록페이지
	@RequestMapping("/insPg.do")
	public String view(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String rgsDe = getCurrentDate_yyyy_mm_dd();
		String register = String.valueOf(request.getSession().getAttribute("sess_userName"));
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getCurrentDate_yyyymmdd());
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getAddMonthDate(1));
		
		model.addAttribute("dtFrom",dtFrom);//등록일
		model.addAttribute("dtTo",dtTo);//등록일
		model.addAttribute("rgsDe",rgsDe);//등록일
		model.addAttribute("register",register);//작성자
		
		return se+folder+"/insert.tiles";
	}
	
	//공지사항 등록
	@RequestMapping("/ins.do")
	public String noticeInsert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String noticeDtFrom = commandMap.getStrNull("NOTICEDTFROM");//공지시작일자
		String noticeDtTo = commandMap.getStrNull("NOTICEDTTO");//공지종료일자
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//id
		String noticeTitle = StringEscapeUtils.unescapeHtml(commandMap.getStr("NOTICETITLE"));// 제목
		String noticeCn = StringEscapeUtils.unescapeHtml(commandMap.getStr("NOTICECN"));// 내용 디코딩
		
		if(!register.equals("")){
			commandMap.put("register", register);
			commandMap.put("noticeCn", noticeCn);
			commandMap.put("noticeTitle", noticeTitle);
			commandMap.put("noticeDtFrom", CommonUtils.dateReplace(noticeDtFrom));
			commandMap.put("noticeDtTo", CommonUtils.dateReplace(noticeDtTo));
			
			resultCnt = commonService.insert(commandMap.getMap(), se+folder+".noticeInsert");
		}else{
			System.out.println("@@@  register==== null  :: "+register);
			resultCnt = -1;
		}
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	
	// 한개의 수정페이지 로드
	@RequestMapping("/udtPg.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int viewSeq = commandMap.getIntNull("SEQNO");
		
		commandMap.put("ID", viewSeq);
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".noticeView");
		
		model.addAttribute("notice", resultMap.get("list"));
		model.addAttribute("bcncCode", request.getSession().getAttribute("sess_bcncCode"));
		return se+folder+"/update.tiles";
	}
	
	// 수정
	@RequestMapping("/udt.do")
	public String noticeUpdate(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		
		String noticeDtFrom = commandMap.getStrNull("NOTICEDTFROM");//공지시작일자
		String noticeDtTo = commandMap.getStrNull("NOTICEDTTO");//공지종료일자
		String noticeId = commandMap.getStr("NOTICEID");//일련번호
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//id
		String noticeTitle = StringEscapeUtils.unescapeHtml(commandMap.getStr("NOTICETITLE"));// 제목
		String noticeCn= StringEscapeUtils.unescapeHtml(commandMap.getStr("NOTICECN"));// 내용 디코딩
		
		if(!noticeId.equals("")){
			commandMap.put("noticeCn", noticeCn);
			commandMap.put("register", register);
			commandMap.put("noticeTitle", noticeTitle);
			commandMap.put("noticeDtFrom", CommonUtils.dateReplace(noticeDtFrom));
			commandMap.put("noticeDtTo", CommonUtils.dateReplace(noticeDtTo));
			commandMap.put("ID", noticeId);
			
			resultCnt = commonService.update(commandMap.getMap(), se+folder+".noticeUpdate");
		}else{
			System.out.println("@@@  noticeId==== null  :: ");
			resultCnt = -1;
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
	 //삭제
	@RequestMapping("/del.do")
	public String noticeDelete(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int resultCnt = 0;
		String noticeId = commandMap.getStr("NOTICEID");//일련번호
		String register = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));//id
		
		if(!noticeId.equals("")){
			commandMap.put("ID", noticeId);
			commandMap.put("register", register);
			resultCnt = commonService.delete(commandMap.getMap(), se+folder+".noticeDelete"); // DELETE쿼리
			
//			commandMap.put("noticeAt", "N"); //update로 할시 표시유무 N으로 변경
//			insResult = commonService.update(commandMap.getMap(), folder+".noticeUpdateDel"); // UPDATE쿼리
		}else{
			System.out.println("@@@  noticeId==== null  :: ");
			resultCnt = -1;
		}
		
		model.addAttribute("resultCnt", resultCnt);
		
		return "jsonView";
	}
}
