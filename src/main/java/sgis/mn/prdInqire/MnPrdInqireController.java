package sgis.mn.prdInqire;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

@Controller
@RequestMapping("/mn/prdInqire")
public class MnPrdInqireController extends CommonController{
	public static String se = "mn/";
	public static String folder = "prdInqire";
	public static String subMenuCode = "CNP01";
	
	/**
	 * 접근권한이 없는 관리자의  [주문확정처리] 접근 제한 Method
	 * 전처리 : filter 
	 * 후처리 : MnPrdInqireController.rflect 
	 * @param : commandMap
	 * @param : request
	 * @param : model
	 * @return : page
	 * */
	@RequestMapping("/rflect.do")
	public String rflect(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		commandMap.put("alertBoxMsg", "접근 권한이 없습니다.");
		
		return page(commandMap, request, model);
	}
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String itemName = commandMap.getStrNull("searchItemNm");
		
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchItemNm", itemName);
		commandMap.put("menuSe", subMenuCode);
		
		if(commandMap.containsKey("alertBoxMsg")){
			model.addAttribute("alertBoxMsg", commandMap.getStrNull("alertBoxMsg"));
		}
		
		// 납기일자
		//Map<String, Object> deadLine = (Map<String, Object>) commonService.view(commandMap.getMap(), "common.getDeadLine");
		//단순 +3일인건지? deadLine 3일 기본값, maximum 60일
		Map<String, Object> deadLine = (Map<String, Object>) commonService.view(commandMap.getMap(), "common.getDeadLine");
		String minDeadLine = getAddWeekDate(1);// 변경 deadLine은 +1일부터
		String maxDeadLine = getAddWeekDate(60);
		// 최근 배송지업체
		Map<String, Object> dlvyView = (Map<String, Object>)commonService.view(commandMap.getMap(), se+folder+".dlvyView");
		
		//model.addAttribute("view", deadLine);
		model.addAttribute("deadLine", deadLine);
		model.addAttribute("minDeadLine", minDeadLine);
		model.addAttribute("maxDeadLine", maxDeadLine);
		model.addAttribute("searchItemNm", itemName);
		model.addAttribute("dlvyView", dlvyView);
		model.addAttribute("subMenu", subMenu(commandMap));
		
		return se+folder+"/listPage.tiles";
	}
	
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 30;
		String bcncCode = commandMap.getStrNull("searchBcncCode");
		String itemName = commandMap.getStrNull("searchItemNm");
		String rcvordDedt = commandMap.getStrNull("rcvordDedt");
		String ordBplc = commandMap.getStrNull("searchBplcCode");
		
		rcvordDedt = rcvordDedt.toUpperCase();
		
		if(rcvordDedt.equals(null) || rcvordDedt.equals("") || rcvordDedt.equals("ALL")) {
			rcvordDedt = ""; // 수주일자가 초기상태랑 전체일경우
		}
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("rcvordDedt", rcvordDedt);
		commandMap.put("ordBplc", ordBplc);
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), se+folder+".prdInqireList");
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".prdInqireListCnt");
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("searchItemNm", itemName);
		model.addAttribute("prdInqireList", resultMap.get("list"));
		model.addAttribute("pgNum", (pg-1)*pgCnt);
		model.addAttribute("rcvordDedt", rcvordDedt);
		
		return se+folder+"/list";
	}
	
	@RequestMapping("/prdInfo.do")
	@ResponseBody
	public Object prdInfo(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		String[] chkArr =  commandMap.getStrArr("selectYn");
		String[] itemArr =  commandMap.getStrArr("IC_CODE");
		String bcncCode = commandMap.getStrNull("bcncCd");
		String ordBplc = commandMap.getStrNull("ordBplc");
		
		ArrayList<String> icCodeList = new ArrayList<>();
		
		if(chkArr != null){
			for(int i=0; i<chkArr.length; i++){
				if(chkArr[i].equals("Y")){
					icCodeList.add(itemArr[i].toString());
				}
			}
		}
		
		commandMap.put("IC_CODE", icCodeList);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("ordBplc", ordBplc);
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), se+folder+".prdInfoList");
		
		return resultMap.get("list");
	}
	
	/**
	 * 거래처코드에 따른 배송지 업체 조회
	 * */
	@RequestMapping("/dlvy.do")
	@ResponseBody
	public Object dlvy(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = commandMap.getStrNull("bcncCd");
		String ordBplc = commandMap.getStrNull("ordBplc");
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("registBplc", ordBplc);
		
		//Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), "popup"+".dlvyList");
		//return resultMap.get("list");
		
		// 최근 배송지업체
		Map<String, Object> dlvyView = (Map<String, Object>)commonService.view(commandMap.getMap(), se+folder+".dlvyView");
		

		return dlvyView;
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
		
		System.out.println("Map  ::: >>  " + commandMap.getMap());
		
		Map<String, Object> rMap = getInvntrySttus(commandMap);
		
		model.addAttribute("color",rMap.get("color"));
		model.addAttribute("invntryWt",rMap.get("invntryWt"));
		model.addAttribute("row",commandMap.getInt("ROW"));
		return "jsonView";
	}
	
	// 주문 접수 등록
	@RequestMapping("/insert.do")
	public String insert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int insResult = 0;
		
		String admEmpNo = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String ordBplc = commandMap.getStrNull("ordBplc");
		String oDate = getCurrentDate_yyyymmdd();
		
		//String[] chkArr = commandMap.getStrArr("selectPrdItem");	//체크박스
		String[] bcncCodeArr = commandMap.getStrArr("BCNC_CODE");		//거래처코드
		String[] dlvyEntrpsArr = commandMap.getStrArr("DLVY_ENTRPS");		//착지업체
		String[] itemDedtArr = commandMap.getStrArr("W_DEDT");		//납기일자
		String[] bIcCodeArr = commandMap.getStrArr("IC_CODE");	//품목코드
		String[] oQuantityArr = commandMap.getStrArr("W_QUANTITY");		//수량
		String[] oWtArr = commandMap.getStrArr("W_WT");	//중량
		String[] oGrpQyArr = commandMap.getStrArr("W_GRP_QY");	//그룹수량
		String[] oPieceQyArr = commandMap.getStrArr("W_PIECE_QY");	//낱개수량
		String[] oSplpcAmArr = commandMap.getStrArr("W_SPLPCAM");	//공급가액
		String[] oVatArr = commandMap.getStrArr("W_VAT");	//부가세
		String[] oSumAm = commandMap.getStrArr("W_SUMAMOUNT");	//금액
		String[] oUnitBplcArr = commandMap.getStrArr("UPC_BPLC");	//단가사업장
		String[] oNewUnitpcArr = commandMap.getStrArr("UPC_NEWUNITPC"); 	//입력단가(신단가로 가져와서 단가수정가능)
		String[] oUntpcUnitArr = commandMap.getStrArr("UPC_UNTPCUNIT"); 	//단가단위
		String[] oUnitChrctrArr = commandMap.getStrArr("UPC_UNIT_CHRCTR");	//단위문자
		String[] oStdrUnitpcArr = commandMap.getStrArr("STDR_UPC_NEWUNITPC"); 	//기준단가(신단가로 가져옴)
		String[] oRmArr = commandMap.getStrArr("RM");	//비고
		
		
		if(bIcCodeArr != null){
			//일자
			commandMap.put("oDate", oDate);
			//거래처코드(관리자의 경우 사번)
			commandMap.put("bcncCode", admEmpNo);
			//등록사업장
			commandMap.put("registBplc", registBplc);
			//거래처 사업장
			commandMap.put("ordBplc", ordBplc);
			
			List<Map<String, Object>> insertList = new ArrayList<>();
			
			for(int i=0; i< bIcCodeArr.length; i++){
				Map<String, Object> frm =  new HashMap<String,Object>();
				//거래처코드
				frm.put("oBcncCode", bcncCodeArr[i]);
				
				frm.put("oItemCode", bIcCodeArr[i]);
				frm.put("oQuantity", CommonUtils.numReplace(oQuantityArr[i]));
				frm.put("oNewUnitpc", CommonUtils.numReplace(oNewUnitpcArr[i]));
				frm.put("oWt" , CommonUtils.numReplace(oWtArr[i]));
				frm.put("oGrpQy" , CommonUtils.numReplace(oGrpQyArr[i]));
				frm.put("oPieceQy" , CommonUtils.numReplace(oPieceQyArr[i]));
				frm.put("oSplpcAm", CommonUtils.numReplace(oSplpcAmArr[i]));
				frm.put("oVat" , CommonUtils.numReplace(oVatArr[i]));
				frm.put("oSumAm", CommonUtils.numReplace(oSumAm[i]));
				frm.put("oUnitBplc", oUnitBplcArr[i]);
				frm.put("oUnitChrctr", oUnitChrctrArr[i]);
				frm.put("oUntpcUnit", CommonUtils.nullReplace(oUntpcUnitArr[i],""));
				frm.put("oStdrUnitpc", CommonUtils.nullReplace(oStdrUnitpcArr[i],""));
				frm.put("oDlvyEntrps", dlvyEntrpsArr[i]);
				frm.put("oItemDedt", CommonUtils.dateReplace(itemDedtArr[i]));
				frm.put("oRm", oRmArr[i]);
				
				insertList.add(frm);
			}
			
			commandMap.put("logicSe", "INS");
			insResult = commonService.saveList(commandMap.getMap(), insertList, se+folder+".insert");
			commandMap.remove("logicSe");
		}else{
			
			System.out.println("@@@  itemCodeArr==== null  :: ");
			insResult = -1;
			
			/*out = response.getWriter();
			out.append("<script type='text/javascript'>");
 	     	out.append("alert('수량이 입력되지 않았습니다.');"); 
 	     	out.append("location.href=history.back();");
 	      	out.append("</script>");
 	      	out.flush();
 	      	out.close();
			return null;*/
		}
		

		model.addAttribute("insResult",insResult);
		return "jsonView";
	}
}
