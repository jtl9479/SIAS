 package sgis.cn.prdInqire;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.ListUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import aj.org.objectweb.asm.Type;
import net.sf.json.JSONObject;
import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;

/**
 * 제품 조회 및 주문 등록
 */
@Controller
@RequestMapping("/prdInqire")
public class PrdInqireController extends CommonController{
	public static String se = "cn/";
	public static String folder = "prdInqire";
	public static String subMenuCode = "CNP01";
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		
		String itemName = commandMap.getStrNull("searchItemNm");
		
		commandMap.put("menuSe", subMenuCode);
		commandMap.put("bcncCode", bcncCode);
		commandMap.put("searchItemNm", itemName);
		commandMap.put("registBplc", registBplc);
		
		// 납기일자
		Map<String, Object> deadLine = (Map<String, Object>) commonService.view(commandMap.getMap(), "common.getDeadLine");
		// 최근 배송지업체
		Map<String, Object> dlvyView = (Map<String, Object>)commonService.view(commandMap.getMap(), se+folder+".dlvyView");
		// 팝업
		Map<String, Object> noticeView = (Map<String, Object>)commonService.view(commandMap.getMap(), "cn/notice.noticeTopOneRead");
		//공휴일 날짜 리스트
		Map<String, Object> holiday = (Map<String, Object>)commonService.list(commandMap.getMap(), "common.getHoliday");
				
		model.addAttribute("view", deadLine);
		model.addAttribute("noticeView", noticeView);
		model.addAttribute("searchItemNm", itemName);
		model.addAttribute("dlvyView", dlvyView);
		model.addAttribute("holidayList", holiday.get("list"));
		model.addAttribute("subMenu", subMenu(commandMap));
		
		return se+folder+"/listPage.tiles";
	}
	
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int pg = commandMap.getIntNull("pg");
		int pgCnt = 30;
		String itemName = commandMap.getStrNull("searchItemNm");
		String rcvordDedt = commandMap.getStrNull("rcvordDedt");
		
		rcvordDedt = rcvordDedt.toUpperCase();
		
		if(rcvordDedt.equals(null) || rcvordDedt.equals("") || rcvordDedt.equals("ALL")) {
			rcvordDedt = ""; // 수주일자가 초기상태랑 전체일경우
		}
		
		commandMap.put("pg", pg);
		commandMap.put("pgCnt", pgCnt);
		commandMap.put("bcncCode", request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("registBplc", request.getSession().getAttribute("sess_registBplc"));
		commandMap.put("rcvordDedt", rcvordDedt);
		
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
		ArrayList<String> icCodeList = new ArrayList<>();
		
		if(chkArr != null){
			for(int i=0; i<chkArr.length; i++){
				if(chkArr[i].equals("Y")){
					icCodeList.add(itemArr[i].toString());
				}
			}
		}
		
		commandMap.put("IC_CODE", icCodeList);
		commandMap.put("bcncCode", request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("registBplc", request.getSession().getAttribute("sess_registBplc"));
		
		Map<String, Object> resultMap = (Map<String, Object>)commonService.list(commandMap.getMap(), se+folder+".prdInfoList");
		
		return resultMap.get("list");
	}
	
	// 주문 접수 등록
	@RequestMapping("/insert.do")
	public String basketInsert(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		int insResult = 0;
		
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String bizrNo = String.valueOf(request.getSession().getAttribute("sess_bizrNo"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String oDate = getCurrentDate_yyyymmdd();
		
		//String[] chkArr = commandMap.getStrArr("selectPrdItem");	//체크박스
		String[] dlvyEntrps = commandMap.getStrArr("dlvyEntrps");		//착지업체
		String[] oDedtArr = commandMap.getStrArr("W_DEDT");		//납기일자
		String[] bIcCode = commandMap.getStrArr("basketIcCode");	//품목코드
		String[] oQuantity = commandMap.getStrArr("W_QUANTITY");		//수량
		String[] oNewUnitpcArr = commandMap.getStrArr("UPC_NEWUNITPC"); 	//단가
		String[] oWtArr = commandMap.getStrArr("W_WT");	//중량
		String[] oGrpQyArr = commandMap.getStrArr("W_GRP_QY");	//그룹수량
		String[] oPieceQyArr = commandMap.getStrArr("W_PIECE_QY");	//낱개수량
		String[] oSplpcAmArr = commandMap.getStrArr("W_SPLPCAM");	//공급가액
		String[] oVatArr = commandMap.getStrArr("W_VAT");	//부가세
		String[] oSumAmArr = commandMap.getStrArr("W_SUMAMOUNT");	//금액
		String[] oUnitBplcArr = commandMap.getStrArr("UPC_BPLC");	//단가사업장
		String[] oUntpcUnitArr = commandMap.getStrArr("UPC_UNTPCUNIT");	//단위
		String[] oUnitChrctrArr = commandMap.getStrArr("UPC_UNIT_CHRCTR");	//단위문자
		
		if(bIcCode != null){
			//일자
			commandMap.put("oDate", oDate);
			//거래처코드
			commandMap.put("bcncCode", bcncCode);
			//사업자번호
			commandMap.put("bizrNo", bizrNo);
			//등록사업장
			commandMap.put("registBplc", registBplc);
			
			List<Map<String, Object>> insertList = new ArrayList<>();
			
			for(int i=0; i< bIcCode.length; i++){
				Map<String, Object> frm =  new HashMap<String,Object>();
				frm.put("itemCode", bIcCode[i]);
				frm.put("oQuantity", CommonUtils.numReplace(oQuantity[i]));
				frm.put("oNewUnitpc", CommonUtils.numReplace(oNewUnitpcArr[i]));
				frm.put("oWt" , CommonUtils.numReplace(oWtArr[i]));
				frm.put("oGrpQy" , CommonUtils.numReplace(oGrpQyArr[i]));
				frm.put("oPieceQy" , CommonUtils.numReplace(oPieceQyArr[i]));
				frm.put("oSplpcAm", CommonUtils.numReplace(oSplpcAmArr[i]));
				frm.put("oVat" , CommonUtils.numReplace(oVatArr[i]));
				frm.put("oSumAm", CommonUtils.numReplace(oSumAmArr[i]));
				frm.put("oUnitBplc", oUnitBplcArr[i]);
				frm.put("oUntpcUnit", oUntpcUnitArr[i]);
				frm.put("oUnitChrctr", oUnitChrctrArr[i]);
				frm.put("dlvyEntrps", dlvyEntrps[i]);
				frm.put("oDedt", CommonUtils.dateReplace(oDedtArr[i]));
				
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
