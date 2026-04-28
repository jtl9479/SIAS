package sgis.cn.wrhousInq;

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
 * 입고 조회
 */
@Controller
@RequestMapping("/wrhousInq")
public class WrhousInqController extends CommonController{
	
	@Resource(name="wrhousInqService")
	public WrhousInqService wrhousInqService;
	
	public static String se ="cn/";
	public static String folder ="wrhousInq";
	public static String subMenuCode = "CNW01";
	
	
	/**
	 * 입고조회 페이지 이동
	 * 검색조건에 해당하는 총 목록건수 조회 (더보기 날짜계산을 위해 listStartDt 에 dtTo 사용)
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddWeekDate(-6));
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		dtFrom = CommonUtils.dateReplace(dtFrom);
		dtTo = CommonUtils.dateReplace(dtTo);
		
		commandMap.put("menuSe", subMenuCode);
		commandMap.put("bcncCode", bcncCode);
		//등록사업장
		commandMap.put("registBplc", registBplc);
		
		model.addAttribute("searchDtFrom", dtFrom);
		model.addAttribute("searchDtTo", dtTo);
		model.addAttribute("weekAgo", dtFrom);
		model.addAttribute("curDedt", dtTo);
		model.addAttribute("listStartDt", dtTo);
		model.addAttribute("subMenu", subMenu(commandMap));

		return se+folder+"/listPage.tiles";
	}
	
	/**
	 * 입고조회 목록
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		int pg = commandMap.getIntNull("pg");
		int pgNum = commandMap.getIntNull("pgNum");
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String dtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String dtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String searchItemNm = commandMap.getStrNull("searchItemNm");// 제품명
		String searchEntrpsNm = commandMap.getStrNull("searchEntrpsNm");//배송지업체
		String listStartDt = CommonUtils.nullReplace(commandMap.getStr("listStartDt"), dtFrom);
		
		commandMap.put("pg", pg);
		commandMap.put("pgNum", pgNum);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtFrom", dtFrom);
		commandMap.put("searchDtTo", dtTo);
		commandMap.put("searchItemNm", searchItemNm);
		commandMap.put("searchEntrpsNm", searchEntrpsNm);
		commandMap.put("listStartDt", listStartDt);
		//등록사업장
		commandMap.put("registBplc", registBplc);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".wrhousInqListCnt");
		
		String maxDate = commonService.strVal(commandMap.getMap(), se+folder+".maxDate");
		commandMap.put("listStartDt", maxDate);
		
		Map<String,Object> resultMap = wrhousInqService.listItem(commandMap.getMap(), se+folder+".wrhousInqList");
			
		model.addAttribute("pg", pg);
		model.addAttribute("pgNum", pgNum);
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("dlivyInqireList", resultMap.get("list"));
		model.addAttribute("listStartDt",resultMap.get("listStartDt"));
		
		return se+folder+"/list";
	}
}
