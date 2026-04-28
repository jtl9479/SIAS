package sgis.cn.dcsnOrd;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;
/**
 * 주문 완료 조회
 */
@Controller
@RequestMapping("/dcsnOrd")
public class DcsnOrdController extends CommonController{
	public static String  se ="cn/";
	public static String  folder ="dcsnOrd";
	public static String  subMenuCode = "CND01";
	
	@Resource(name="dcsnOrdService")
	public DcsnOrdService dcsnOrdService;
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"),getAddWeekDate(-6));
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		dtFrom = CommonUtils.dateReplace(dtFrom);
		dtTo = CommonUtils.dateReplace(dtTo);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("menuSe", subMenuCode);// forder 메뉴구분
		
		model.addAttribute("subMenu", subMenu(commandMap)); // 웹메뉴공지
		model.addAttribute("searchDtFrom", dtFrom);
		model.addAttribute("searchDtTo", dtTo);
		model.addAttribute("weekAgo", dtFrom);
		model.addAttribute("curDedt", dtTo);
		model.addAttribute("listStartDt", dtTo);
		
		return se+folder+"/listPage.tiles";
	}
	
	// 리스트조회
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("pg");
		int pgNum = commandMap.getIntNull("pgNum");
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String searchDtGroup = commandMap.getStrNull("searchDtGroup");//일자분류
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String searchItemNm = commandMap.getStrNull("searchItemNm");// 제품명
		String searchEntrpsNm = commandMap.getStrNull("searchEntrpsNm");//배송지업체
		String listStartDt = CommonUtils.nullReplace(commandMap.getStr("listStartDt"), searchDtFrom);
		
		commandMap.put("pg", pg);
		commandMap.put("pgNum", pgNum);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtGroup", searchDtGroup);
		commandMap.put("searchDtFrom", searchDtFrom);
		commandMap.put("searchDtTo", searchDtTo);
		commandMap.put("searchItemNm", searchItemNm);
		commandMap.put("searchEntrpsNm", searchEntrpsNm);
		commandMap.put("listStartDt", listStartDt);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dcsnOrdListCnt");
		
		String maxDate = commonService.strVal(commandMap.getMap(), se+folder+".maxDate");
		commandMap.put("listStartDt", maxDate);
		
		Map<String, Object> resultMap =(Map<String, Object>) dcsnOrdService.listItem(commandMap.getMap(), se+folder+".dcsnOrdList");
		
		model.addAttribute("pg", pg);
		model.addAttribute("pgNum", pgNum);
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("dcsnOrdList", resultMap.get("list"));
		model.addAttribute("listStartDt", resultMap.get("listStartDt"));
		
		return se+folder+"/list";
	}
}
