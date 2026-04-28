package sgis.mn.unDcsnOrd;

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
 * 미확정주문처리
 */
@Controller
@RequestMapping("/mn/unDcsnOrd")
public class MnUnDcsnOrdController extends CommonController{
	public static String  se ="mn/";
	public static String  folder ="unDcsnOrd";
	
	@Resource(name="mnUnDcsnOrdService")
	public MnUnDcsnOrdService mnUnDcsnOrdService;
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		// ** 20.05 시아스 요청 납기일자 기본값으로 변경 및 조회일자 기본값 2주로 변경
		String searchDtFrom = CommonUtils.nullReplace(commandMap.getStr("searchDtFrom"), getCurrentDate_yyyymmdd());
		String searchDtTo = CommonUtils.nullReplace(commandMap.getStr("searchDtTo"), getAddWeekDate(14));
		
		searchDtFrom = CommonUtils.dateReplace(searchDtFrom);
		searchDtTo = CommonUtils.dateReplace(searchDtTo);
		
		commandMap.put("bcncCode", bcncCode);
		// 납기일자
		Map<String, Object> deadLine = (Map<String, Object>) commonService.view(commandMap.getMap(), "common.getDeadLine");
		
		model.addAttribute("view", deadLine);
		model.addAttribute("searchDtFrom", searchDtFrom);
		model.addAttribute("searchDtTo", searchDtTo);
		model.addAttribute("weekAgo", searchDtFrom);
		model.addAttribute("curDedt", searchDtTo);
		model.addAttribute("listStartDt", searchDtTo);
		
		return se+folder+"/listPage.tiles";
	}
	
	@RequestMapping("/list.do")
	public String list(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		
		int pg = commandMap.getIntNull("pg");
		int pgNum = commandMap.getIntNull("pgNum");
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		String searchDtGroup = commandMap.getStrNull("searchDtGroup");//일자분류
		String searchDtFrom = CommonUtils.dateReplace(commandMap.getStr("searchDtFrom"));
		String searchDtTo = CommonUtils.dateReplace(commandMap.getStr("searchDtTo"));
		String userSe = commandMap.getStrNull("userSe");//관리자 A,거래처(사용자) U
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
		String searchBfUdo = commandMap.getStrNull("beforeUDO"); // 이전 미확정 주문건
		
		
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
		commandMap.put("searchBfUdo", searchBfUdo);//이전 미확정 주문건
		commandMap.put("listStartDt", listStartDt);
		commandMap.put("userSe", userSe);
		
		// ** 20.05 시아스 요청 이전 주문 조회 건 설정시 6개월 전 내역 가져옴
		if(searchBfUdo.equals("Y")){
			commandMap.put("searchDtFrom", getAddWeekDate(-180));
			commandMap.put("searchDtTo", getCurrentDate_yyyymmdd());
		}
		

		Map<String,Object> resultMap;
		String returnStr;
		
		String maxDate = commonService.strVal(commandMap.getMap(), se+folder+".maxDate");
		commandMap.put("listStartDt", maxDate);
		
		long listTotalCnt = commonService.listCnt(commandMap.getMap(), se+folder+".unDcsnOrdListCnt");
		
		if(userSe.equals("A")) {//관리자
			resultMap = mnUnDcsnOrdService.listItem(commandMap.getMap(), se+folder+".unDcsnOrdList");
			returnStr = se+folder+"/list";
		}else {//거래처(사용자)
			resultMap = mnUnDcsnOrdService.listItem(commandMap.getMap(), se+folder+".unDcsnOrdUserList");
			returnStr = se+folder+"/userList";
		}
		
		model.addAttribute("listTotalCnt", listTotalCnt);
		model.addAttribute("pg", pg);
		model.addAttribute("pgNum", pgNum);
		model.addAttribute("resultMap", resultMap.get("list"));
		model.addAttribute("listStartDt",resultMap.get("listStartDt"));
		model.addAttribute("userSe", userSe);
		
		return returnStr;
	}
	
	@RequestMapping("/update.do")
	public String update(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		commandMap.put("bcncCode", bcncCode);
		
		int result = allUpdate(commandMap);
		
		model.addAttribute("result", result);
		model.addAttribute("udtSe", commandMap.getStr("udtSe"));
		
		return "jsonView";
	}
	
	//선택제품확인
	public int allUpdate(CommandMap commandMap) throws Exception{
		int udtResult = 0;
		
		String userSe = commandMap.getStrNull("userSe");//관리자유무
		String[] wRceptdeArr = commandMap.getStrArr("W_RCEPTDE"); // 접수일자
		String[] wSnArr = commandMap.getStrArr("W_SN"); // 일련번호
		String[] wDedtArr = commandMap.getStrArr("W_DEDT"); // 납기일자
		String[] wQuantityArr = commandMap.getStrArr("W_QUANTITY"); // 수량
		String[] wUntpcArr = commandMap.getStrArr("UPC_NEWUNITPC"); // 단가
		String[] wNoteArr = commandMap.getStrArr("W_NOTE"); // 비고
		String[] wWtArr = commandMap.getStrArr("W_WT"); // 중량
		String[] wGrpQyArr = commandMap.getStrArr("W_GRP_QY");	//그룹수량
		String[] wPieceQyArr = commandMap.getStrArr("W_PIECE_QY");	//낱개수량
		String[] wSplpCamArr = commandMap.getStrArr("W_SPLPCAM"); // 공급가액
		String[] WVatArr = commandMap.getStrArr("W_VAT"); // 부가세
		String[] wSumAmountArr = commandMap.getStrArr("W_SUMAMOUNT"); // 합계금액
		String[] wProgrsseArr = null;
		String[] wAdminNoteArr = null;
		
		if(userSe.equals("U")) {
			wProgrsseArr = commandMap.getStrArr("W_PROGRSSE");
			wAdminNoteArr = commandMap.getStrArr("W_ADMINNOTE");
		}
		
		if (wDedtArr != null) {
			List<Map<String, Object>> udtList = new ArrayList<>();
			Map<String, Object> frm = null;
			commandMap.put("logicSe", "UDT");
			for (int i = 0; i < wDedtArr.length; i++) {
				frm = new HashMap<String, Object>();
				frm.put("wRceptde", CommonUtils.dateReplace(wRceptdeArr[i]));
				frm.put("wSn", wSnArr[i]);
				frm.put("wDedt", CommonUtils.dateReplace(wDedtArr[i]));
				frm.put("wQuantity", CommonUtils.numReplace(wQuantityArr[i]));
				frm.put("wUntpc", CommonUtils.numReplace(wUntpcArr[i]));
				frm.put("wNote", wNoteArr[i]);
				frm.put("wWt", CommonUtils.numReplace(wWtArr[i]));
				frm.put("wGrpQy" , CommonUtils.numReplace(wGrpQyArr[i]));
				frm.put("wPieceQy" , CommonUtils.numReplace(wPieceQyArr[i]));
				frm.put("wSplpCam", CommonUtils.numReplace(wSplpCamArr[i]));
				frm.put("WVat", CommonUtils.numReplace(WVatArr[i]));
				frm.put("wSumAmount", CommonUtils.numReplace(wSumAmountArr[i]));
				if(userSe.equals("U")) {
					frm.put("wProgrsse", wProgrsseArr[i]);
					frm.put("wAdminNote", wAdminNoteArr[i]);
				}
				udtList.add(frm);
			}
			udtResult = commonService.saveList(commandMap.getMap(), udtList, se+folder+".unDcsnOrdUpdate");
			commandMap.remove("logicSe");
		} else {
			System.out.println("wDedtArr == null");
			udtResult = -1;
		}
		
		return udtResult;
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
			delResult = commonService.saveList(commandMap.getMap(), udtList, se+folder+".unDcsnOrdDelete");
			commandMap.remove("logicSe");
		} else {
			System.out.println("selectYnArr == null");
			delResult = -1;
		}
		model.addAttribute("delResult", delResult);
		
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
		
		System.out.println(this.getClass() + "  ::  " + commandMap.getMap());
		
		Map<String, Object> rMap = getInvntrySttus(commandMap);
		
		model.addAttribute("color",rMap.get("color"));
		model.addAttribute("invntryWt",rMap.get("invntryWt"));
		model.addAttribute("row",commandMap.getInt("ROW"));
		
		return "jsonView";
	}
}
