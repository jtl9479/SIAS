package sgis.mn.excel;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;
import sgis.sys.util.CommonUtils;
import sgis.sys.util.ExcelCellRef;
import sgis.sys.util.ExcelCommonUtils;
import sgis.sys.util.ExcelReadOption;
import sgis.sys.util.ExcelValidUtils;
import sgis.sys.util.MakeExcel;
/**
 * 엑셀업로드
 */
@Controller
@RequestMapping("/mn/excel")
public class MnExcelController extends CommonController{
	
	@Resource(name="excelValidUtils")
	public ExcelValidUtils excelValidUtils;
	
	@Resource(name="mnExcelService")
	public MnExcelService mnExcelService;
	
	public static String se = "mn/";
	public static String folder = "excel";
	public static String fileExt = "", fileInfo = "";
	
	public static Workbook wb = null;
	public static Sheet sheet = null;
	public static Row row = null;
	public static Cell cell = null;
	
	@RequestMapping("/page.do")
	public String page(CommandMap commandMap, HttpServletRequest request, Model model) throws Exception{
		Map<String, Object> getResultMap =  new HashMap<>();
		String ordBplcNm = String.valueOf(request.getSession().getAttribute("sess_ordBplcNm"));
		String registBplc = String.valueOf(request.getSession().getAttribute("sess_registBplc"));
		String ordDate = getCurrentDate();
		
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
		if(flashMap !=null) { 
			getResultMap = (Map<String, Object>) flashMap.get("resultMap");
		}
			
		if(getResultMap.containsKey("excelResult")){
			ordBplcNm =  String.valueOf(getResultMap.get("BPLC_NM"));
			registBplc = String.valueOf(getResultMap.get("registBplc"));
			ordDate = String.valueOf(getResultMap.get("ORD_DE"));
			model.addAttribute("alertBoxMsg", String.valueOf(getResultMap.get("alertBoxMsg")));
		}
		
		commandMap.put("ordBplcNm", ordBplcNm);
		commandMap.put("registBplc", registBplc);
		commandMap.put("ordDate", ordDate);
		
		model.addAttribute("ordBplcNm", ordBplcNm);
		model.addAttribute("registBplc", registBplc);
		model.addAttribute("ordDate", ordDate);
		
		return se+folder+"/listPage.tiles"; 
	}
	
	@RequestMapping(value="/resultPage.do")
	public String resultPage(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
		Map<String, Object> getResultMap = new HashMap<>();
		
		if(flashMap !=null) { 
			getResultMap = (Map<String, Object>) flashMap.get("resultMap");
		}
		
		commandMap.put("alertBoxMsg", getResultMap.get("alertBoxMsg"));
		commandMap.put("excelResult", getResultMap.get("excelResult"));
		
		model.addAttribute("alertBoxMsg", String.valueOf(getResultMap.get("alertBoxMsg")));
	 
		//return "jsonView";
		//return page(commandMap, request, model);
		return se+folder+"/listPage.tiles"; 
	}
	
	
	//엑셀 업로드
	@SuppressWarnings("finally")
	@Autowired(required = false)
	@RequestMapping(value="/excelUpload.do")
	public String excelUpload(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {//real
	//public String excelUpload(CommandMap commandMap, MultipartHttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		String S_result = "F";
		String alertBoxMsg = "";
		boolean B_result = false;
		//파일 업로드 실행후 해당 업로드 파일의 정보를 가져옴
		commandMap= (CommandMap)fileSet(commandMap, request, "excel");
		
		//엑셀 readOption 설정, A~F까지 컬럼만 읽옴, 시작행-> 2 번째 
        ExcelReadOption excelReadOption = new ExcelReadOption();
        excelReadOption.setOutputColumns("A","B","C","D","E","F");
        excelReadOption.setStartRow(2);
        
        //엑셀업로드 구분값
		String excelTySe = commandMap.getStr("UP_TY_SE");
		//주문 사업장
		String registBplc = commandMap.getStr("REGIST_BPLC");
		//주문 일자
		String ordDe = commandMap.getStr("ORD_DE");
		//거래처코드
		String bcncCode = String.valueOf(request.getSession().getAttribute("sess_bcncCode"));
		
		//업체에 따라서 중량의 위치기 달라지기 때문에 업체별 값 지정
		int cellSeVal = 0;
		try {
			switch (excelTySe) {
				case "WT":
					cellSeVal = 3;
					break;
				case "QY":
					cellSeVal = 2;
					break;
				default:
					break;
			}
			commandMap.put("cellSeVal", cellSeVal);
			commandMap.put("registBplc", registBplc);
			commandMap.put("ordDe", CommonUtils.dateReplace(ordDe));
			commandMap.put("bcncCode", bcncCode);
			
			//Excel File read and valid check
			B_result = commonExcelData(excelReadOption, commandMap); //real
			//B_result = commonExcelData(excelReadOption, commandMap, response);
			if(B_result){
				S_result = "T";
				//commandMap.put("alertBoxMsg", "엑셀업로드 성공"); //real
				alertBoxMsg = "엑셀업로드 성공";
			}else {
				S_result = "F";
				excelValidUtils.returnFailText(response, commandMap);// ==>> 이거 때문인듯
				//commandMap.put("alertBoxMsg", "엑셀업로드 실패"); //real
				alertBoxMsg = "엑셀업로드 실패";
			}
		}catch(Exception e){
			e.printStackTrace();
		} finally {
			//model.addAttribute("excelResult",S_result); //real
			commandMap.put("excelResult", S_result);
			commandMap.put("alertBoxMsg", alertBoxMsg);
			
			FlashMap fm = RequestContextUtils.getOutputFlashMap(request);
			fm.put("resultMap", commandMap.getMap());
			
			if(S_result.equals("T")){
				return "redirect:/mn/excel/page.do";
			}else{
				//return resultPage(commandMap, request, response, model); 
				return "jsonView";
				//return "redirect:/mn/excel/resultPage.do";
			}
			 
			//return  "redirect:/mn/excel/page.do"; -->>> Cannot call sendRedirect() after the response has been committed
		}
		
	}
	
	
	//엑셀 다운로드
	@RequestMapping(value="/excelDown.do")
    public String excelDown(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
        MakeExcel me = new MakeExcel();
        me.download(request, response, "templete_match_1.xls");
        
        return "jsonView";  
	}
	
	//파일 업로드
	public CommandMap fileSet(CommandMap commandMap, HttpServletRequest request, String menu) throws Exception {
		String fileInputAttr = "";
		List<Map<String,Object>> list = fileUtils.parseInsertFileInfo(commandMap.getMap(), request, "excel");
		
		for (int i=0, size=list.size(); i<size; i++) {
			fileInputAttr = list.get(i).get("FILE_INPUT_ATTR").toString();
			commandMap.put(fileInputAttr + "_PT", list.get(i).get("FILE_PATH"));
			fileInputAttr = fileInputAttr.substring(fileInputAttr.indexOf("_")+1);
			commandMap.put(fileInputAttr + "_NM", list.get(i).get("ORG_FILE_NAME"));
			
			//파일 삭제 및 read용 추가
			commandMap.put(fileInputAttr + "_EXT", list.get(i).get("FILE_EXT"));
			/*commandMap.put(fileInputAttr + "_ABS_PT", list.get(i).get("FILE_ABS_PATH"));
			commandMap.put(fileInputAttr + "_REAL_NM", list.get(i).get("REAL_FILE_NAME"));*/
			commandMap.put("FILE_ABS_PT", list.get(i).get("FILE_ABS_PATH"));
			commandMap.put("FILE_REAL_NM", list.get(i).get("REAL_FILE_NAME"));
		}
		return commandMap;
	}
	
	/**************************************************************************************/
	
	/**
	 *엑셀 업로드 공통 method 
	 * */
	public Boolean commonExcelData(ExcelReadOption excelReadOption, CommandMap commandMap) throws Exception{
	//public Boolean commonExcelData(ExcelReadOption excelReadOption, CommandMap commandMap, HttpServletResponse response) throws Exception{
		
		//업로드 된 엑셀 파일의 정보를 읽어서 workbook을 읽어온다.
		//fileInfo = commandMap.getStr("EXCEL_FILE_1_ABS_PT")+commandMap.getStr("EXCEL_FILE_1_REAL_NM");
		fileInfo = commandMap.getStr("FILE_ABS_PT")+commandMap.getStr("FILE_REAL_NM");
		wb = ExcelCommonUtils.getWorkbook(fileInfo);
		sheet = wb.getSheetAt(0);
		
		Boolean finalResult = true;
		Boolean validResult = true;
		Boolean mapResult = false;
		
		//행의 수
		int numOfRows=sheet.getPhysicalNumberOfRows();
		int numOfCells = 0;
		int cellVal = commandMap.getInt("cellSeVal"); 
		
		//cell 유효성 체크
		int cellValChk =0;
		
		String cellName = "", excelValue="", cellTitle="";
		StringBuffer excelError = new StringBuffer();
        
		Map<String, Object> map = null;
        List<Map<String, Object>> excelList = new ArrayList<Map<String, Object>>();
        
        Row titleRow = null;
        
        titleRow =  sheet.getRow(0);
        
        //각 Row만큼 반복을 한다.
        for(int rowIndex = excelReadOption.getStartRow() - 1; rowIndex < numOfRows; rowIndex++) {
        	row = sheet.getRow(rowIndex);
        	if(row != null) {
				numOfCells = row.getPhysicalNumberOfCells(); 
				map = new HashMap<>();
				mapResult = false; validResult = true;
				
				//업체별 수주량, 중량 값
				cell = row.getCell(cellVal);
				FormulaEvaluator formulaEval = wb.getCreationHelper().createFormulaEvaluator();
				
				if(cellVal == 2) cellName = "C";
				else cellName = "D";
				excelValue = ExcelCellRef.getValue(cell, formulaEval, cellName);
				
				//초기화 진행
				cellName = "";
				
				//중량(수주량)이 있는 경우
				if(ExcelValidUtils.excelValidChk(excelValue)){
					mapResult = true;
					map.put("rowNum", rowIndex);
					
					//중량 또는 수주량에 따른 단가단위 수주중량 = 단가단위3, 수주량 = 단가단위2
					if(cellVal == 3) map.put("untpcunit", 3);
					else map.put("untpcunit", 2);
					
					//사업장추가
					//for(int cellIndex = 0; cellIndex < numOfCells; cellIndex++) {
					for(int cellIndex = 0; cellIndex < 6; cellIndex++) {
						
						// 해당 row의 첫번째  cell 부터 다시 시작
						cell = row.getCell(cellIndex);
						
						// 추출 대상 컬럼 확인
						cellName = ExcelCellRef.getName(cell, cellIndex);
						if( !excelReadOption.getOutputColumns().contains(cellName)) {
						    continue;
						}
						
						excelValue = ExcelCellRef.getValue(cell, formulaEval, cellName);
						
						//해당 cell 유효성 체크
						if(cellName.equals("A") || cellName.equals("B") || cellName.equals("E")){
							if(!ExcelValidUtils.excelValidChk(excelValue)){
								cellTitle = ExcelCellRef.getValue(titleRow.getCell(cellIndex), formulaEval, cellName);
								excelError.append("\r\n["+ (row.getRowNum()+1) + "] "+cellTitle+ " 정보가 없습니다. ");
								validResult = false;
							}
						}
						
						//if(!validResult) mapResult = validResult; -> 원본
						if(!validResult) {
							mapResult = validResult;
							cellValChk++;
						}
						
						//엑셀에서 읽어온 값에 "(double quotation) 이 존재하기 때문에 replace 시킴
						map.put(cellName, excelValue.replace("\"", ""));
					} //cell for end
				}else {
					//continue;
					
					// ** 2019.07 엑셀업로드시 수주량, 수주중량을 잘못 눌러서 업로드 진행함 
					validResult = false;
					excelError.append("[수주량, 수주중량을 확인해주세요.]");
				}
				
				//만들어진 Map객체를 List로 넣는다.
				if(mapResult){
					excelList.add(map);
				}
	        }
        } //row for end
		
        // 검증이 완료된 파일을 삭제한다.
        ExcelCommonUtils.fileDelete(fileInfo);
        
        //cellValChk  ==>> 엑셀 체크 값이 이상없을 경우
        if(cellValChk < 1) { 
        	boolean dbResult = true;
        	boolean dedtChk = true;
        	
        	//납기일자 유효성 검사 진행
        	for(int a=0; a<excelList.size(); a++){
        		dedtChk = excelDedtChk(excelList.get(a).get("E"));
        		if(!dedtChk) break;
        	}
        	
        	if(dedtChk){
        		//mapper 에서 동적인 쿼리 생성 (UNION ALL)을 위해  foreach index 사용 
            	commandMap.put("lastNum", excelList.size()-1);
            	
            	//DataBase 조회 및 유효성 검증
            	dbResult = excelDbInqire(commandMap, excelList); 
            	
            	//db 조회 및 유효성 검증이 true 일 경우
            	if(dbResult){
            		//수식 계산 위해 값 뽑아옴
            		//List<Map<String,Object>>untpcList = calcAndCnvrsn(commandMap, excelList);
            		List<Map<String,Object>>untpcList = calcAndCnvrsn(commandMap);
            		
            		//수식계산용 기존의 excelList 값과 untpcList의 값을 합쳐줄 list 생성
            		List<Map<String,Object>>newList = new ArrayList<Map<String, Object>>();
            		Map<String, Object> untpcMap = new HashMap<>();
            		for(int j=0; j <untpcList.size(); j++){
            			untpcMap = new HashMap<>();
            			untpcMap.put("IC_PACKNGUNIT", untpcList.get(j).get("IC_PACKNGUNIT"));
            			untpcMap.put("IC_UNITQY", untpcList.get(j).get("IC_UNITQY"));
            			untpcMap.put("UPC_UNTPCUNIT", untpcList.get(j).get("UPC_UNTPCUNIT"));
            			untpcMap.put("UPC_VATINCLSAT", untpcList.get(j).get("UPC_VATINCLSAT"));
            			untpcMap.put("UPC_NEWUNITPC", untpcList.get(j).get("UPC_NEWUNITPC"));
            			untpcMap.put("BPLC_CODE", excelList.get(j).get("A"));
            			untpcMap.put("IC_CODE", excelList.get(j).get("B"));
            			untpcMap.put("EXCEL_QY", excelList.get(j).get("C"));
            			untpcMap.put("EXCEL_WT", excelList.get(j).get("D"));
            			untpcMap.put("EXCEL_DEDT", excelList.get(j).get("E"));
            			untpcMap.put("EXCEL_RN", excelList.get(j).get("F"));
            			untpcMap.put("EXCEL_UNTPCUNIT", excelList.get(j).get("untpcunit"));
            			
            			//excelList.add(j, untpcMap); //-> 96개 리턴
            			newList.add(j, untpcMap);
            		}
            		
            		if(newList.size() > 0){
            			// 수주명세서 INSERT 및 UPDATE service로 Logic 이동.
            			List<Map<String, Object>> calList = calAndCnvrsnList(newList);
            			
            			if(calList.size() > 0){
            				Map<String, Object> m = mnExcelService.osSaveItem(commandMap.getMap(), calList, se+folder);
                			finalResult = (Boolean) m.get("result");
            			}else{
            				finalResult = false;
            			}
            		}else{
            			finalResult = false;
            			String msg = "단가계산이 맞지 않습니다";
            			commandMap.put("msg", msg);
            		}
            		
            	}else {
            		finalResult = dbResult;
            		// 에러메세지 내역
            		String dbErrorMsg = commandMap.getStr("excelErrorMsg");
                    commandMap.put("excelErrorMsg", dbErrorMsg);
            	}
        	}else {
        		finalResult = false;
        		// 에러메세지 내역
        		String dbErrorMsg = "납기일자가 유효하지 않습니다.";
                commandMap.put("excelErrorMsg", dbErrorMsg);
        	}
        	
        	
        }else {
        	finalResult = false;
        	// 에러메세지 내역
            commandMap.put("excelErrorMsg", excelError);
        }
		
		return finalResult;
	}
	
	/*납기일자 유효성 체크
	 * 윤년 체크, 숫자만 허용, 자리수 체크(8자리만 허용)
	 */
	public boolean excelDedtChk(Object obj){
		boolean chkResult = false;
		
		Pattern DATE_PATTERN = Pattern.compile(
			      "^((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))0229)$"
			      + "|^(((19|2[0-9])[0-9]{2})02(0[1-9]|1[0-9]|2[0-8]))$"
			      + "|^(((19|2[0-9])[0-9]{2})(0[13578]|10|12)(0[1-9]|[12][0-9]|3[01]))$"
			      + "|^(((19|2[0-9])[0-9]{2})(0[469]|11)(0[1-9]|[12][0-9]|30))$");
		
		chkResult = DATE_PATTERN.matcher(obj.toString()).matches();
		
		return chkResult;
	}
	
	//DB 조회 및 유효성 검사
	//public Map<String, Object> excelDbInqire (CommandMap commandMap, List<Map<String, Object>> l) throws Exception{
	public boolean excelDbInqire (CommandMap commandMap, List<Map<String, Object>> l) throws Exception{
		System.out.println("excelDbInqire.run()  :: " + commandMap.getMap());
		boolean result = true;
		int errCnt = 0;
		StringBuffer excelError = new StringBuffer();
		
		commandMap.put("frm", l);
		Map<String, Object> dataList =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".dataList");
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> dbList = ((List<Map<String, Object>>) dataList.get("list"));
		
		if(dbList.size() > 0){
			for(int i=0; i < dbList.size(); i++){
        		if(String.valueOf(dbList.get(i).get("BPLC_CNT")).trim().equals("0") || Integer.valueOf(dbList.get(i).get("BPLC_CNT").toString().trim()) == 0){
        			excelError.append("\r\n["+ (Integer.valueOf(dbList.get(i).get("RNUM").toString())+1) + "] "+ " 거래처 정보가 유효하지 않습니다. ");
        			errCnt++;
        		}
        		
				if(String.valueOf(dbList.get(i).get("ITEM_CNT")).trim().equals("0") || Integer.valueOf(dbList.get(i).get("ITEM_CNT").toString().trim()) == 0){
					excelError.append("\r\n["+ (Integer.valueOf(dbList.get(i).get("RNUM").toString())+1) + "] "+ " 품목코드 정보가 유효하지 않습니다. ");
					errCnt++;
				}
				
				if(String.valueOf(dbList.get(i).get("UNTPC_CNT")).trim().equals("0") || Integer.valueOf(dbList.get(i).get("UNTPC_CNT").toString().trim()) == 0){
					excelError.append("\r\n["+ (Integer.valueOf(dbList.get(i).get("RNUM").toString())+1) + "] "+ " 단가 정보가 유효하지 않습니다. ");
					errCnt++;
				}
        	}
		}
		
		
		if(errCnt >0) result=false;
		
		if(result){
			commandMap.put("dbList", dbList);
		}else{
			commandMap.put("excelErrorMsg", excelError);
		}
		
		return result;
	}
	
	//단위 환산 및 중량 계산을 위해 값을 가져옴
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> calcAndCnvrsn (CommandMap commandMap) throws Exception{
		List<Map<String, Object>> listMap = (List<Map<String, Object>> )commandMap.get("dbList");
		List<Map<String, Object>> untpcList = new ArrayList<Map<String, Object>>(); 
		
		if(listMap.size() > 0){
			commandMap.put("lastNum", listMap.size()-1);
			commandMap.put("frm", listMap);
			
			Map<String, Object> untpcMap =(Map<String, Object>) commonService.list(commandMap.getMap(), se+folder+".untpcList");
			untpcList = ((List<Map<String, Object>>) untpcMap.get("list"));
			
		}
		return untpcList;
	} 
	
	//중량, 금액 계산  후 List 생성
	public List<Map<String, Object>> calAndCnvrsnList(List<Map<String, Object>>list ) throws Exception{
		//BigDecimal icPackngUnit;// 포장단위
		double double1;// double변수
		BigDecimal icUnitQy;// 단위당수량
		BigDecimal upcUntpcUnit;//단가단위
		BigDecimal upcVatInclsat;//부가세포함유무
		BigDecimal upcNewUnitpc;//신단가
		BigDecimal osWt;//수주중량
		BigDecimal osQy;//수량
		String bplcCode;
		String icCode;
		String excelDedt;
		String excelRn;
		int excelUntpcUnit;
		BigDecimal splpCam;//공급가액
		BigDecimal vat;//부가세
		BigDecimal sumAmount;//합계금액
		
		BigDecimal unitPcXQy; // 단가 * 수량
		
		List<Map<String, Object>> newList = new ArrayList<>();
		
		for(int i=0; i <list.size(); i++){
			Map<String, Object> frm = new HashMap<String,Object>();
			
			excelUntpcUnit = Integer.valueOf((int) list.get(i).get("EXCEL_UNTPCUNIT")) ;//2,3
			
			/* double1 = Double.valueOf((double) list.get(i).get("IC_UNITQY")); 
		 	 * icUnitQy = icUnitQy.setScale(1, BigDecimal.ROUND_HALF_UP);
			 * 0523 이전엔 가져와서 소숫점 한자리에서 반올림 진행으로 문제 발생
			 * IC_UNITQY(단위당수량)값을 DB에서 가져올 때 numeric으로 가져와서 그대로 사용으로 변경
			 */ 
			icUnitQy = (BigDecimal) list.get(i).get("IC_UNITQY");

			upcUntpcUnit = new BigDecimal(String.valueOf(list.get(i).get("UPC_UNTPCUNIT")));
			upcVatInclsat = new BigDecimal(String.valueOf(list.get(i).get("UPC_VATINCLSAT")));
			/* 소숫점 문제로 인해 Double 형이 아닌 String 형으로 data 처리
			 * double1 = Double.valueOf((double)list.get(i).get("UPC_NEWUNITPC"));
			upcNewUnitpc = new BigDecimal(double1);*/
			upcNewUnitpc = new BigDecimal(String.valueOf(list.get(i).get("UPC_NEWUNITPC")));
			bplcCode = String.valueOf(list.get(i).get("BPLC_CODE"));
			icCode = String.valueOf(list.get(i).get("IC_CODE"));
			
			if(excelUntpcUnit == 2) {
				osWt = new BigDecimal(String.valueOf(list.get(i).get("EXCEL_QY")));
			}else {
				osWt = new BigDecimal(String.valueOf(list.get(i).get("EXCEL_WT")));
			}
			excelDedt = String.valueOf(list.get(i).get("EXCEL_DEDT"));
			excelRn = String.valueOf(list.get(i).get("EXCEL_RN"));
			
			if(excelUntpcUnit == 2) {// 수주량
				if(upcUntpcUnit.compareTo(new BigDecimal("1")) == 0) {//포장단위 필요시 변경
					osQy = osWt.divide(new BigDecimal("6"), 1,BigDecimal.ROUND_HALF_UP);
				}else if(upcUntpcUnit.compareTo(new BigDecimal("2")) == 0) {
					osQy = osWt;
				}else {
					osQy = osWt.multiply(icUnitQy);
				}
				osWt = osWt.multiply(icUnitQy);// 중량
			}else {//수주중량
				if(upcUntpcUnit.compareTo(new BigDecimal("1")) == 0) {//포장단위 필요시 변경
					osQy = osWt.divide(new BigDecimal("6"), 1,BigDecimal.ROUND_HALF_UP).divide(icUnitQy, 1,BigDecimal.ROUND_HALF_UP);
				}else if(upcUntpcUnit.compareTo(new BigDecimal("2")) == 0) {
					osQy = osWt.divide(icUnitQy, 1,BigDecimal.ROUND_HALF_UP);
				}else {
					osQy = osWt;
				}
			}
			
			if(upcVatInclsat.compareTo(new BigDecimal("0")) == 0) {
				unitPcXQy = upcNewUnitpc.multiply(osQy).setScale(0, BigDecimal.ROUND_FLOOR);
				splpCam = unitPcXQy;
				vat = unitPcXQy.multiply(new BigDecimal("0.1")).setScale(0, BigDecimal.ROUND_FLOOR);
				sumAmount = unitPcXQy.add(vat);
			}else {
				unitPcXQy = upcNewUnitpc.multiply(osQy).setScale(0, BigDecimal.ROUND_FLOOR);
				vat = unitPcXQy.divide(new BigDecimal("11"), 0, BigDecimal.ROUND_FLOOR);
				splpCam = unitPcXQy.subtract(vat);
				sumAmount = splpCam;
			}
			frm.put("IC_UNITQY",icUnitQy);
			frm.put("UPC_UNTPCUNIT",upcUntpcUnit);
			frm.put("UPC_VATINCLSAT",upcVatInclsat);
			frm.put("UPC_NEWUNITPC",upcNewUnitpc);
			frm.put("BPLC_CODE",bplcCode);
			frm.put("IC_CODE",icCode);
			frm.put("EXCEL_UNTPCUNIT",excelUntpcUnit);
			frm.put("EXCEL_WT",osWt);// 중량
			frm.put("EXCEL_QY",osQy);// 수주수량
			frm.put("EXCEL_DEDT",excelDedt);
			frm.put("EXCEL_RN",excelRn);
			frm.put("SUMAMOUNT",sumAmount);
			frm.put("SPLPCAM",splpCam);
			frm.put("VAT",vat);
			
			newList.add(frm);
		}
		
		return newList;
	} 
	
}
