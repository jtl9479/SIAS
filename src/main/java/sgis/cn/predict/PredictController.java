package sgis.cn.predict;

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
/***
 * 수요 예측
 */
@Controller
@RequestMapping("/predict")
public class PredictController extends CommonController{
	public static String  se ="cn/";
	public static String  folder ="predict";
	public static String subMenuCode = "CNP02";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		commandMap.put("menuSe", subMenuCode);// 메뉴구분
		
		model.addAttribute("subMenu", subMenu(commandMap));
		
		return se+folder+"/listPage.tiles";
	}
	
	/**
	 * 리스트조회
	 * 오늘 날짜기준 - 일
	 * 해당구간에 해당일이 포함되면
	 * 1구간 : 1~10 -> 해당월의 1구간, 2구간 수정제외
	 * 2구간 : 11~20 -> 해당월의 1구간, 2구간, 3구간 수정제외
	 * 3구간 : 21~말일 -> 해당월의 1구간, 2구간, 3구간, 다음월 1구간 수정제외
	 * */ 
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String searchItemNm = commandMap.getStrNull("searchItemNm");
		String thisMonth = getCurrentDate_yyyymmdd();
		String nextMonth = getAddMonthDate(1);
		
		commandMap.put("bcncCode", bcncCode);
		//등록사업장
		commandMap.put("registBplc", registBplc);
		commandMap.put("searchItemNm", searchItemNm);
		commandMap.put("thisMonth", thisMonth.substring(0, 6));
		commandMap.put("nextMonth", nextMonth.substring(0, 6));
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".predictListCnt");
		
		Map<String, Object> resultMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".predictList");
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("predictList", resultMap.get("list"));
		
		return se+folder+"/list";
	}
	
	//저장
	@RequestMapping("/update.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int udtResult = 0;
		
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String[] updateYn1 = commandMap.getStrArr("updateYn1"); //업데이트확인1
		String[] updateYn2 = commandMap.getStrArr("updateYn2"); //업데이트확인2
		String[] updateYn3 = commandMap.getStrArr("updateYn3"); //업데이트확인3
		String[] wDedtArr = commandMap.getStrArr("W_DEDT"); //년월
		String[] wCodeArr = commandMap.getStrArr("IC_CODE");//품목코드
		String[] wDcsnWt1Arr = commandMap.getStrArr("W_DCSNWT1");//확정중량1
		String[] wDcsnWt2Arr = commandMap.getStrArr("W_DCSNWT2");//확정중량2
		String[] wDcsnWt3Arr = commandMap.getStrArr("W_DCSNWT3");//확정중량3
		String[] wNoteArr = commandMap.getStrArr("W_NOTE");//비고
		
		if (wDedtArr != null) {
			List<Map<String, Object>> udtList = new ArrayList<>();
			Map<String, Object> frm = null;
			commandMap.put("bcncCode", bcncCode);
			commandMap.put("logicSe", "UDT");
			for (int i = 0; i < wDedtArr.length; i++) {
				frm = new HashMap<String, Object>();
				if(updateYn1[i].equals("Y")) {
					frm.put("wDcsnWt1", CommonUtils.numReplace(wDcsnWt1Arr[i]));
				}
				if(updateYn2[i].equals("Y")) {
					frm.put("wDcsnWt2", CommonUtils.numReplace(wDcsnWt2Arr[i]));
				}
				if(updateYn3[i].equals("Y")) {
					frm.put("wDcsnWt3", CommonUtils.numReplace(wDcsnWt3Arr[i]));
				}
				frm.put("updateYn1", updateYn1[i]);
				frm.put("updateYn2", updateYn2[i]);
				frm.put("updateYn3", updateYn3[i]);
				frm.put("wDedt", CommonUtils.dateReplace(wDedtArr[i]));
				frm.put("wCode", wCodeArr[i]);
				frm.put("wNote", wNoteArr[i]);
				udtList.add(frm);
			}
			udtResult = commonService.saveList(commandMap.getMap(), udtList, se+folder+".predictUpdate");
			commandMap.remove("logicSe");
		} else {
			System.out.println("wDedtArr == null");
			udtResult = -1;
		}
		
		model.addAttribute("udtResult", udtResult);
		
		return "jsonView";
	}
}
