package sgis.cn.ordMod;

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
 * 주문 내역 수정
 * */
@Controller
@RequestMapping("/ordMod")
public class OrdModController extends CommonController{
	public static String  se ="cn/";
	public static String  folder ="ordMod";
	public static String subMenuCode = "CNO01";
	/**
	 * 주문 내역 수정 - Page
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
		
		String itemName = commandMap.getStrNull("searchItemNm");
		String dtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getAddMonthDate(-1));
		String dtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getAddMonthDate(2));
		
		//int mummOrderQy = Integer.valueOf(String.valueOf(request.getSession().getAttribute("sess_mummOrderQy")));
		
		dtFrom = CommonUtils.dateReplace(dtFrom);
		dtTo = CommonUtils.dateReplace(dtTo);
		
		commandMap.put("menuSe", subMenuCode);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchItemNm", itemName);
		commandMap.put("searchDtFrom", dtFrom);
		commandMap.put("searchDtTo", dtTo);
		commandMap.put("registBplc", registBplc);
		
		model.addAttribute("searchItemNm", itemName);
		model.addAttribute("searchDtFrom", dtFrom);
		model.addAttribute("searchDtTo", dtTo);
		model.addAttribute("weekAgo", dtFrom);
		model.addAttribute("curDedt", dtTo);
		model.addAttribute("subMenu", subMenu(commandMap));
		
		model.addAttribute("maxItemDedt", getAddMonthDate(2));
		//model.addAttribute("minimumQy", mummOrderQy);
		
		return se+folder+"/listPage.tiles";
	}
	
	/**
	 * 주문 내역 수정 - List
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		int pg = commandMap.getIntNull("pg");
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String searchItemNm = commandMap.getStrNull("searchItemNm");
		String alocEntrps = commandMap.getStrNull("ALOCENTRPS");//배송지업체
		
		commandMap.put("pg", pg);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("registBplc", registBplc);
		commandMap.put("searchDtFrom", CommonUtils.dateReplace(commandMap.getStr("searchDtFrom")));
		commandMap.put("searchDtTo", CommonUtils.dateReplace(commandMap.getStr("searchDtTo")));
		commandMap.put("searchItemNm", searchItemNm);
		//공통사용 위해 임의 지정
		commandMap.put("searchDtGroup", "basket");
		
		Map<String, Object> dlvyList =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".dlvyList");
		//Controller 에서 dlvyListCnt 를 dlvyListCnt  dlvyList.size()로 대체 확인
		//long dlvyListCnt = commonService.listCnt(commandMap.getMap(), se+folder+".dlvyListCnt");
		List<Map<String, Object>> dlvyListMap = ((List<Map<String, Object>>) (dlvyList.get("list")));
		long dlvyListCnt = dlvyListMap.size();
		
		if(dlvyListCnt > 0) {
			if(alocEntrps.equals("")) {
				// 착지업체 공백, 초기로드시 첫번째값
				alocEntrps = String.valueOf(((List<Map<String, Object>>) (dlvyList.get("list"))).get(0).get("W_ALOCENTRPS"));
			}
		}
		commandMap.put("alocEntrps", alocEntrps);
		
		Map<String,Object> resultMap = (Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".basketList");
		// 납기일자 (공통으로 사용하려 했으나 TAB에 있는 배송지업체 목록을 따라야 하기 때문에 동일한 SQL 재사용 )
		//Map<String, Object> deadLine = (Map<String, Object>) commonService.view(commandMap.getMap(), se+folder+".getDeadLine");
		// 최근 배송지업체
		//Map<String, Object> dlvyView = (Map<String, Object>)commonService.view(commandMap.getMap(), se+"prdInqire"+".dlvyView");
		Map<String, Object> dlvyView = (Map<String, Object>)commonService.view(commandMap.getMap(), se+folder+".dlvyView");
		//공휴일 날짜 리스트
		Map<String, Object> holiday = (Map<String, Object>)commonService.list(commandMap.getMap(), "common.getHoliday");
		
		model.addAttribute("pg", pg);
		model.addAttribute("basketList", resultMap.get("list"));
		model.addAttribute("dlvyList", dlvyList.get("list"));
		//model.addAttribute("view", deadLine); // dlvyView에서 해당요일 까지 확인해서 deadline가지고옴
		model.addAttribute("dlvyView", dlvyView);
		model.addAttribute("holidayList", holiday.get("list"));
		
		return se+folder+"/list";
	}
	
	/**
	 * 주문 내역 수정- 저장
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/update.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("bcncCode", bcncCode);
		
		int result = allUpdate(commandMap);
		
		model.addAttribute("result", result);
		model.addAttribute("udtSe", commandMap.getStr("udtSe"));
		
		return "jsonView";
	}
	
	/**
	 * 주문 내역 수정- 삭제
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/delete.do")
	public String delete(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		int delResult = 0, udtResult = 0;
		
		commandMap.put("bcncCode", bcncCode);
		
		udtResult = allUpdate(commandMap);
		
		if(udtResult > 0){
			String delChk = commandMap.getStr("delItem");
			String[] delChkArr = delChk.split(","); 
			
			String[] oDe = commandMap.getStrArr("W_DE");		//일자
			String[] oSn = commandMap.getStrArr("W_SN");		//일련번호
			
			if(delChkArr != null){
				List<Map<String, Object>> delList = new ArrayList<>();
				
				for(int i=0; i< delChkArr.length; i++){
					Map<String, Object> frm =  new HashMap<String,Object>();
					if(delChkArr[i].equals("Y")){
						frm.put("oDe", CommonUtils.dateReplace(oDe[i]));
						frm.put("oSn", CommonUtils.numReplace(oSn[i]));
						
						delList.add(frm);
					}
				}
				
				commandMap.put("logicSe", "DEL");
				 delResult = commonService.saveList(commandMap.getMap(), delList, se+folder+".delete");
				commandMap.remove("logicSe");
			
			}else {
				delResult = -1;
			}
			
		}else{
			delResult = -1;
		}
		
		model.addAttribute("result", delResult);
		
		return "jsonView";
	}
	
	/**
	 * 주문 확정
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/ordRceptInsert.do")
	public String ordRceptInsert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int result = 0;
		
		String oDate = getCurrentDate_yyyymmdd();
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		
		String selChk = commandMap.getStr("selItem");
		String[] selChkArr = selChk.split(","); 						//선택 체크박스 값
		String[] oDeArr = commandMap.getStrArr("W_DE");		//일자
		String[] oSnArr = commandMap.getStrArr("W_SN");		//일련번호
		String[] oItemCodeArr = commandMap.getStrArr("IC_CODE");				//아이템코드
		String[] oQuantityArr = commandMap.getStrArr("W_QUANTITY");			//수량
		String[] oUntpcUnitArr = commandMap.getStrArr("UPC_UNTPCUNIT"); 	//단가단위
		String[] oUnitBplcArr = commandMap.getStrArr("W_UNIT_BPLC"); 		//단가사업장
		String[] oUnitChrctrArr = commandMap.getStrArr("W_UNIT_CHRCTR");	//단위문자
		String[] oWtArr = commandMap.getStrArr("W_WT"); 							//중량
		String[] oGrpQyArr = commandMap.getStrArr("W_GRP_QY");	//그룹수량
		String[] oPieceQyArr = commandMap.getStrArr("W_PIECE_QY");	//낱개수량
		String[] oNewUnitpcArr = commandMap.getStrArr("UPC_NEWUNITPC"); //신단가
		String[] oVatArr = commandMap.getStrArr("W_VAT");							//부가세
		String[] oSplpcAmArr = commandMap.getStrArr("W_SPLPCAM");			//공급가액
		String[] oSumAmountArr = commandMap.getStrArr("W_SUMAMOUNT");//합계금액
		String[] oItemNoteArr = commandMap.getStrArr("W_NOTE");				//주문비고
		String[] oItemDedtArr = commandMap.getStrArr("W_DEDT");				 //납기일자
		String[] oDlvyEntrpsArr = commandMap.getStrArr("W_ALOCENTRPS");		//배송지업체
		String[] oDlivyBplcArr = commandMap.getStrArr("W_DLIVY_BPLC");		//출고사업장
		
		if(selChkArr != null){
			//일자
			commandMap.put("oDate", oDate);
			//거래처코드
			commandMap.put("bcncCode", bcncCode);
			//등록사업장
			commandMap.put("registBplc", registBplc);
			
			List<Map<String, Object>> insertList = new ArrayList<>();
			for(int i=0; i< selChkArr.length; i++){
				Map<String, Object> frm =  new HashMap<String,Object>();
				if(String.valueOf(selChkArr[i]).equals("Y")){
					frm.put("dlvyEntrps", oDlvyEntrpsArr[i]);
					
					frm.put("oDate", CommonUtils.dateReplace(oDeArr[i]));
					frm.put("oSn" , CommonUtils.numReplace(oSnArr[i]));
					frm.put("oItemCode", String.valueOf(oItemCodeArr[i]));
					frm.put("oQuantity" , CommonUtils.numReplace(oQuantityArr[i]));
					frm.put("oUnitBplc", oUnitBplcArr[i]);
					frm.put("oUntpcUnit", CommonUtils.numReplace(oUntpcUnitArr[i]));
					frm.put("oUnitChrctr", oUnitChrctrArr[i]);
					frm.put("oWt" , CommonUtils.numReplace(oWtArr[i]));
					frm.put("oGrpQy" , CommonUtils.numReplace(oGrpQyArr[i]));
					frm.put("oPieceQy" , CommonUtils.numReplace(oPieceQyArr[i]));
					frm.put("oNewUnitpc", CommonUtils.numReplace(oNewUnitpcArr[i]));
					frm.put("oVat" , CommonUtils.numReplace(oVatArr[i]));
					frm.put("oSplpcAm", CommonUtils.numReplace(oSplpcAmArr[i]));
					frm.put("oSumAmount" , CommonUtils.numReplace(oSumAmountArr[i]));
					frm.put("oItemNote", String.valueOf(oItemNoteArr[i]));
					frm.put("oItemDedt" , CommonUtils.dateReplace(String.valueOf(oItemDedtArr[i])));
					frm.put("oDlivyBplc", String.valueOf(oDlivyBplcArr[i]));
					
					insertList.add(frm);
				}
			}
			
			commandMap.put("logicSe", "INS");
			result = commonService.saveList(commandMap.getMap(), insertList, se+folder+".ordRceptInsert");
			commandMap.remove("logicSe");
		}else {
			System.out.println("@@@  itemCodeArr==== null  :: ");
			result = -1;
		}

		model.addAttribute("result",  result);
		return "jsonView";
	}
	
	/**
	 * 재고상태
	 * 
	 * @param commandMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/invntrySttus.do")
	public String invntrySttus(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String userSe = String.valueOf(request.getSession().getAttribute("sess_userSe"));
		
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("userSe", userSe);
		
		Map<String, Object> rMap = getInvntrySttus(commandMap);
		
		model.addAttribute("color",rMap.get("color"));
		model.addAttribute("invntryWt",rMap.get("invntryWt"));
		model.addAttribute("orgInvntryWt",rMap.get("orgInvntryWt"));
		model.addAttribute("row",commandMap.getInt("ROW"));
		return "jsonView";
	}
	
	/**
	 * 저장 Action 공통 사용
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public int allUpdate(CommandMap commandMap) throws Exception{
		int result=0;
		
		String[] dlvyEntrps = commandMap.getStrArr("W_ALOCENTRPS");		//배송지업체
		String[] itemDedt = commandMap.getStrArr("W_DEDT");		//납기일자
		
		String[] oDeArr = commandMap.getStrArr("W_DE");		//일자
		String[] oSnArr = commandMap.getStrArr("W_SN");		//일련번호
		String[] oQuantityArr = commandMap.getStrArr("W_QUANTITY");		//수량
		String[] oWtArr = commandMap.getStrArr("W_WT");	//중량
		String[] oGrpQyArr = commandMap.getStrArr("W_GRP_QY");	//그룹수량
		String[] oPieceQyArr = commandMap.getStrArr("W_PIECE_QY");	//낱개수량
		String[] oSplpcAmArr = commandMap.getStrArr("W_SPLPCAM");	//공급가액
		String[] oVatArr = commandMap.getStrArr("W_VAT");	//부가세
		String[] oSumAmArr = commandMap.getStrArr("W_SUMAMOUNT");	//금액
		String[] oNoteArr = commandMap.getStrArr("W_NOTE");	//비고
		
		String[] oNewUnitpcArr = commandMap.getStrArr("UPC_NEWUNITPC"); 	//신단가
		String[] oUnitArr = commandMap.getStrArr("UPC_UNTPCUNIT");	//단위
		
		String selChk = commandMap.getStr("selItem");
		String[] selChkArr = selChk.split(",");
		
		if(selChkArr != null){
			
			List<Map<String, Object>> updateList = new ArrayList<>();
			
			for(int i=0; i< selChkArr.length; i++){
				
				Map<String, Object> frm =  new HashMap<String,Object>();
				
				frm.put("dlvyEntrps", dlvyEntrps[i]);
				frm.put("itemDedt", CommonUtils.dateReplace(itemDedt[i]));
				
				frm.put("oDe", CommonUtils.dateReplace(oDeArr[i]));
				frm.put("oSn", CommonUtils.numReplace(oSnArr[i]));
				frm.put("oQuantity", CommonUtils.numReplace(oQuantityArr[i]));
				frm.put("oNewUnitpc", CommonUtils.numReplace(oNewUnitpcArr[i]));
				frm.put("oWt" , CommonUtils.numReplace(oWtArr[i]));
				frm.put("oGrpQy" , CommonUtils.numReplace(oGrpQyArr[i]));
				frm.put("oPieceQy" , CommonUtils.numReplace(oPieceQyArr[i]));
				frm.put("oSplpcAm", CommonUtils.numReplace(oSplpcAmArr[i]));
				frm.put("oVat" , CommonUtils.numReplace(oVatArr[i]));
				frm.put("oSumAm", CommonUtils.numReplace(oSumAmArr[i]));
				frm.put("oUnit", oUnitArr[i]);
				frm.put("oNote", oNoteArr[i]);
				frm.put("oChgAt", selChkArr[i]);
				
				updateList.add(frm);
			}
		
		commandMap.put("logicSe", "UDT");
		result = commonService.saveList(commandMap.getMap(), updateList, se+folder+".update");
		commandMap.remove("logicSe");
		
		}else {
			result = -1;
		}
		
		return result;
	}
}
