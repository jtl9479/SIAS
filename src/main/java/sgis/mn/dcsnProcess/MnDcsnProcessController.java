package sgis.mn.dcsnProcess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
 * 주문확정처리
 */
@Controller
@RequestMapping("/mn/dcsnProcess")
public class MnDcsnProcessController extends CommonController{
	public static String  se ="mn/";
	public static String  folder ="dcsnProcess";
	
	@Resource(name="mnDcsnProcessService")
	public MnDcsnProcessService mnDcsnProcessService;
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		//String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		//2019.07.15 SCM  김정우 요청으로 기간 변경
		String searchDtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddWeekDate(1));
		String searchDtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getAddWeekDate(4));
		
		searchDtFrom = CommonUtils.dateReplace(searchDtFrom);
		searchDtTo = CommonUtils.dateReplace(searchDtTo);
		
		model.addAttribute("searchDtFrom", searchDtFrom);
		model.addAttribute("searchDtTo", searchDtTo);
		model.addAttribute("weekAgo", searchDtFrom);
		model.addAttribute("curDedt", searchDtTo);
		
		//2020.02.07. 강대천 과장 연락 -> 주문목록 중복표시로인해 확인 결과 초기 startDt값이 문제였음, 조회와 같은 조건으로 추가
		//model.addAttribute("listStartDt", searchDtTo);
		model.addAttribute("listStartDt", searchDtFrom);
		
		return se+folder+"/listPage.tiles";
	}
	
	//확인 기본로드시 확인탭
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		int pg = commandMap.getIntNull("pg");
		int pgNum = commandMap.getIntNull("pgNum");
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String searchDtGroup = commandMap.getStrNull("searchDtGroup");//일자분류
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String confirm = commandMap.getStrNull("confirm");//확인 Y,미확인 N
		String listStartDt = CommonUtils.nullReplace(commandMap.getStr("listStartDt"), searchDtFrom);
		String searchBplcNm = commandMap.getStrNull("searchBplcNm");//출고사업장명칭
		String searchBplcCode = commandMap.getStrNull("searchBplcCode");//출고사업장코드
		String searchBcncNm = commandMap.getStrNull("searchBcncNm");//거래처 명칭
		String searchBcncCode = commandMap.getStrNull("searchBcncCode");//거래처코드
		String searchEntrpsNm = commandMap.getStrNull("searchEntrpsNm");//배송지명칭
		String searchDlvyEntrps = commandMap.getStrNull("searchDlvyEntrps");//배송지코드
		String searchItemNm = commandMap.getStrNull("searchItemNm");// 제품명
		String searchBplcSe = commandMap.getStrNull("searchBplcSe");
		String searchBcncSe = commandMap.getStrNull("searchBcncSe");
		String searchDlvySe = commandMap.getStrNull("searchDlvySe");
		
		searchDtFrom = CommonUtils.dateReplace(searchDtFrom);
		searchDtTo = CommonUtils.dateReplace(searchDtTo);
		
		commandMap.put("pg", pg);
		commandMap.put("searchDtGroup", searchDtGroup);
		commandMap.put("searchDtFrom", searchDtFrom);
		commandMap.put("searchDtTo", searchDtTo);
		commandMap.put("searchBplcSe", searchBplcSe);
		commandMap.put("searchBcncSe", searchBcncSe);
		commandMap.put("searchDlvySe", searchDlvySe);
		commandMap.put("searchBplcNM", searchBplcNm);//출고사업장명칭
		commandMap.put("searchBplcCode", searchBplcCode);//출고사업장코드
		commandMap.put("searchBcncCode", searchBcncCode);//거래처코드
		commandMap.put("searchBcncNm", searchBcncNm);//거래처명칭
		commandMap.put("searchEntrpsNm", searchEntrpsNm);//배송지 명칭
		commandMap.put("searchDlvyEntrps", searchDlvyEntrps);//배송지 코드
		commandMap.put("searchItemNm", searchItemNm);//제품명
		commandMap.put("listStartDt", listStartDt);
		commandMap.put("confirm", confirm);
		
		long listTotalCnt;
		Map<String,Object> resultMap;
		String returnStr;
		String maxDate;
		
		if(confirm.equals("Y")) {//확인
			listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dcsnProcessListCnt");
			maxDate = commonService.strVal(commandMap.getMap(), se+folder+".maxDate");
			commandMap.put("listStartDt", maxDate);
			
			resultMap = mnDcsnProcessService.listItem(commandMap.getMap(), se+folder+".dcsnProcessList");
			returnStr = se+folder+"/list";
		}else {//미확인
			listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dcsnProcessUnListCnt");
			maxDate = commonService.strVal(commandMap.getMap(), se+folder+".unMaxDate");
			commandMap.put("listStartDt", maxDate);
			
			resultMap = mnDcsnProcessService.listItem(commandMap.getMap(), se+folder+".dcsnProcessUnList");
			returnStr = se+folder+"/unList";
		}
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("pg", pg);
		model.addAttribute("pgNum", pgNum);
		model.addAttribute("resultMap", resultMap.get("list"));
		model.addAttribute("listStartDt",resultMap.get("listStartDt"));
		model.addAttribute("confirm", confirm);
		
		return returnStr;
	}
	
	//선택제품확인
	@RequestMapping("/update.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("bcncCode", bcncCode);
		
		// 수주명세서 INSERT 및 UPDATE service로 Logic 이동.
		Map<String, Object> m = mnDcsnProcessService.osSaveItem(commandMap.getMap(), se+folder);
		
		model.addAttribute("result", m.get("result"));
		model.addAttribute("resultMsg", m.get("resultMsg"));
		
		return "jsonView";
	}
	
	//선택제품삭제
	@RequestMapping("/delete.do")
	public String delete(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int delResult = 0;
		
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String[] selectYnArr = commandMap.getStrArr("selectYn");
		String[] wRceptdeArr = commandMap.getStrArr("W_RCEPTDE"); // 접수일자
		String[] wSnArr = commandMap.getStrArr("W_SN"); // 일련번호
		
		if (selectYnArr != null) {
			List<Map<String, Object>> udtList = new ArrayList<>();
			Map<String, Object> frm = null;
			commandMap.put("bcncCode", bcncCode);
			commandMap.put("logicSe", "UDT");
			for (int i = 0; i < selectYnArr.length; i++) {
				frm = new HashMap<String, Object>();
				if(selectYnArr[i].equals("Y")){
					frm.put("wRceptde", CommonUtils.dateReplace(wRceptdeArr[i]));
					frm.put("wSn", wSnArr[i]);
					udtList.add(frm);
				}
			}
			delResult = commonService.saveList(commandMap.getMap(), udtList, se+folder+".dcsnProcessDelete");
			commandMap.remove("logicSe");
		} else {
			System.out.println("selectYnArr == null");
			delResult = -1;
		}
		
		model.addAttribute("delResult", delResult);
		
		return "jsonView";
	}
}
