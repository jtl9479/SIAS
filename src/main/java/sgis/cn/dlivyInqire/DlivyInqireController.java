package sgis.cn.dlivyInqire;

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
 * 출고 조회
 * */
@Controller
@RequestMapping("/dlivyInqire")
public class DlivyInqireController extends CommonController {
	
	@Resource(name="dlivyInqireService")
	public DlivyInqireService dlivyInqireService;
	
	public static String  se ="cn/";
	public static String  folder ="dlivyInqire";
	
	/**
	 * 출고조회 페이지 이동
	 * 검색조건에 해당하는 총 목록건수 조회 (더보기 날짜계산을 위해 listEndDt 에 dtTo 사용)
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
		String itemName = commandMap.getStrNull("searchItemNm");
		String dlvyEntrps = commandMap.getStrNull("searchDlvyEntrps");
		String entrpsNm = commandMap.getStrNull("searchEntrpsNm");
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddWeekDate(-6));
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getCurrentDate_yyyymmdd());
		
		dtFrom = CommonUtils.dateReplace(dtFrom);
		dtTo = CommonUtils.dateReplace(dtTo);
		
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtFrom", dtFrom);
		commandMap.put("searchDtTo", dtTo);
		commandMap.put("searchDlvyEntrps", dlvyEntrps);
		commandMap.put("searchItemNm", itemName);
		commandMap.put("listEndDt", dtTo);
		
		long totalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dlivyInqireListCnt");
		
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("searchItemNm", itemName);
		model.addAttribute("searchDtFrom", dtFrom);
		model.addAttribute("searchDtTo", dtTo);
		model.addAttribute("searchEntrpsNm", entrpsNm);
		model.addAttribute("searchDlvyEntrps", dlvyEntrps);
		model.addAttribute("listEndDt", dtTo);

		return se+folder+"/listPage.tiles";
	}
	
	/**
	 * 출고조회 목록
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
	
		commandMap.put("pg", pg);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchDtFrom", CommonUtils.dateReplace(commandMap.getStr("searchDtFrom")));
		commandMap.put("searchDtTo", CommonUtils.dateReplace(commandMap.getStr("searchDtTo")));
		
		Map<String,Object> resultMap = dlivyInqireService.listItem(commandMap.getMap(), se+folder+".dlivyInqireList");
			
		model.addAttribute("pg", pg);
		model.addAttribute("pgNum", pgNum);
		model.addAttribute("dlivyInqireList", resultMap.get("list"));
		model.addAttribute("listEndDt",resultMap.get("listEndDt"));
		
		return se+folder+"/list";
	}
}
