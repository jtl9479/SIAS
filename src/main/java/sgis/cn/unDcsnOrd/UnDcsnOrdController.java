package sgis.cn.unDcsnOrd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;
/**
 * 주문 접수 진행중...
 */
@Controller
@RequestMapping("/unDcsnOrd")
public class UnDcsnOrdController extends CommonController{
	public static String se ="cn/";
	public static String folder ="unDcsnOrd";
	public static String subMenuCode = "CNU01";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String searchDtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"),getAddWeekDate(-6));
		String searchDtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		searchDtFrom = CommonUtils.dateReplace(searchDtFrom);
		searchDtTo = CommonUtils.dateReplace(searchDtTo);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("menuSe", subMenuCode);// 메뉴구분+
		
		model.addAttribute("subMenu", subMenu(commandMap));
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
		String searchDtGroup = commandMap.getStrNull("searchDtGroup");//일자분류
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String searchItemNm = commandMap.getStrNull("searchItemNm");// 제품명
		String alocEntrps = commandMap.getStrNull("ALOCENTRPS");//배송지업체
		
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtGroup", searchDtGroup);
		commandMap.put("searchDtFrom", searchDtFrom);
		commandMap.put("searchDtTo", searchDtTo);
		commandMap.put("searchItemNm", searchItemNm);
		
		Map<String, Object> dlvyList =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".dlvyList");
		long dlvyListCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dlvyListCnt");
		
		if(dlvyListCnt > 0) {
			if(alocEntrps.equals("")) {
				// 착지업체 공백, 초기로드시 첫번째값
				alocEntrps = String.valueOf(((List<Map<String, Object>>) (dlvyList.get("list"))).get(0).get("W_ALOCENTRPS"));
			}
		}
		commandMap.put("alocEntrps", alocEntrps);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".unDcsnOrdListCnt");
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".unDcsnOrdList");
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("dlvyList", dlvyList.get("list"));
		model.addAttribute("unDcsnOrdList", resultMap.get("list"));
		
		return se+folder+"/list";
	}
	
	//저장
	@RequestMapping("/update.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int udtResult = 0;
		
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String[] wRceptdeArr = commandMap.getStrArr("W_RCEPTDE"); // 접수일자
		String[] wSnArr = commandMap.getStrArr("W_SN"); // 일련번호
		String[] wNoteArr = commandMap.getStrArr("W_NOTE");// 비고
		String[] wDedtArr = commandMap.getStrArr("W_DEDT");// 납기일자
		String[] wIcCodeArr = commandMap.getStrArr("IC_CODE");// 품목코드

		if (wSnArr != null) {
			List<Map<String, Object>> udtList = new ArrayList<>();
			Map<String, Object> frm = null;
			commandMap.put("bcncCode", bcncCode);
			commandMap.put("logicSe", "UDT");
			for (int i = 0; i < wNoteArr.length; i++) {
					frm = new HashMap<String, Object>();
					frm.put("wRceptde", CommonUtils.dateReplace(wRceptdeArr[i]));
					frm.put("wSn", wSnArr[i]);
					frm.put("wNote", wNoteArr[i]);
					frm.put("wDedt", CommonUtils.dateReplace(wDedtArr[i]));
					frm.put("wIcCode", wIcCodeArr[i]);
					udtList.add(frm);
			}
			udtResult = commonService.saveList(commandMap.getMap(), udtList, se+folder+".unDcsnOrdUpdate");
			commandMap.remove("logicSe");
		} else {
			System.out.println("wSnArr == null");
			udtResult = -1;
		}
		
		model.addAttribute("udtResult", udtResult);
		
		return "jsonView";
	}
}
