package sgis.mn.excel.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.mn.excel.MnExcelService;

@Service("mnExcelService")
public class MnExcelServiceImpl implements MnExcelService{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
	
	/**
	 * 수주명세서, 일마감관리 ISNERT 및 UPDATE 진행 Logic
	 * 순서)
	 *   1. 일마감관리 마감일자 조회
	 *   2. 주문접수 단가사업장 비교 하여 동일한 사업장에 CHG_NUM(일마감관리 INSERT, UPDATE 값) ++
	 *   3. 일마감관리 INSERT OR UPDATE
	 *   4. 수주명세서 INSERT AND UPDATE
	 **/
	@Override
	public Map<String, Object> osSaveItem(Map<String, Object> map, List<Map<String,Object>> l, String queryPath) throws Exception {
		
		//결과 return map
		Map<String, Object> resultMap = new HashMap<String,Object>();
		//일마감관리 ListMap
		List<Map<String, Object>> deClosList = new ArrayList<Map<String, Object>>();
		try{
			//일마감관리 마감일자조회
			deClosList = commonMapper.list(map, queryPath+".deClosList");
			
			int osInsNo = 0;
			int deClosResult = 0;
			int udtResult = 0;
			
			String unitInfo = "";
			
			//retrun 결과값
			String rtMsg = "";
			Boolean rtValue = true;
			
			String registBplc = String.valueOf(map.get("registBplc"));
			
			/* EXCEL_FILE_NM 공통화 사용하기위해
			 EXCEL_FILE_NM_WT(중량)으로된 엑셀파일 이름이 공백이 아닐시 중량값 
			 공백일시 수량값을 담아줌 */ 
			if(!map.get("EXCEL_FILE_NM_WT").equals("")) { 
				map.put("EXCEL_FILE_NM", map.get("EXCEL_FILE_NM_WT")); // 중량
			}else {
				map.put("EXCEL_FILE_NM", map.get("EXCEL_FILE_NM_QY")); // 수량
			}
			
			commonMapper.insert(map, queryPath + ".excellFileInsert");
			
			if(l.size() > 0){
				List<Map<String, Object>> udtList = new ArrayList<>();
				Map<String, Object> frm = null;
				for(int a=0; a< l.size(); a++){
					frm = new HashMap<String, Object>();
					
					for(int b=0; b<deClosList.size(); b++){
						osInsNo = 0;
						//선택된 체크박스의 단가사업장과 일마감관리의 단가사업장이 같은경우
						//해당 단가사업장의 수주최종번호 ++ 이후 다시 CHG_NUM에 값 INSERT
						if(registBplc.equals(deClosList.get(b).get("BPLC_CODE"))){
							osInsNo = (Integer.valueOf(deClosList.get(b).get("CHG_NUM").toString()))+1;
							deClosList.get(b).put("CHG_NUM", osInsNo);
							break;
						}
					}
					
					//동일 INDEX의 map에 값 put
					frm.put("osInsNo",osInsNo);	 //수주일련번호
					frm.put("IC_UNITQY", l.get(a).get("IC_UNITQY"));
					//frm.put("UPC_UNTPCUNIT", l.get(a).get("UPC_UNTPCUNIT"));
					
					//수주명세서  >  단가단위 insert 할때 변환 작업 실시
					if(l.get(a).get("UPC_UNTPCUNIT").toString().equals("1")){
						unitInfo = "BOX";
					}else if(l.get(a).get("UPC_UNTPCUNIT").toString().equals("2")){
						unitInfo = "EA";
					}else {
						unitInfo = "KG";
					}
					frm.put("UPC_UNTPCUNIT", unitInfo);
					frm.put("UPC_VATINCLSAT", l.get(a).get("UPC_VATINCLSAT"));
					frm.put("UPC_NEWUNITPC", l.get(a).get("UPC_NEWUNITPC"));
					frm.put("BPLC_CODE", l.get(a).get("BPLC_CODE"));
					frm.put("IC_CODE", l.get(a).get("IC_CODE"));
					frm.put("EXCEL_UNTPCUNIT", l.get(a).get("EXCEL_UNTPCUNIT"));
					frm.put("EXCEL_WT", l.get(a).get("EXCEL_WT"));
					frm.put("EXCEL_QY", l.get(a).get("EXCEL_QY"));
					frm.put("EXCEL_DEDT", l.get(a).get("EXCEL_DEDT"));
					frm.put("EXCEL_RN", l.get(a).get("EXCEL_RN"));
					frm.put("SUMAMOUNT", l.get(a).get("SUMAMOUNT"));
					frm.put("SPLPCAM", l.get(a).get("SPLPCAM"));
					frm.put("VAT", l.get(a).get("VAT"));
					frm.put("EX_NO", map.get("EX_NO"));// 웹일련번호

					udtList.add(frm);
				}
				
				//일마감관리 INSERT OR UPDATE용 map 생성
				Map<String, Object> deClosMap = new HashMap<String, Object>();
				for(int k=0; k <deClosList.size(); k++){
					//해당 단가 사업장의 초기 MAX_NUM과 CHG_NUM이 변경되어 다른경우
					if(deClosList.get(k).get("MAX_NUM") != deClosList.get(k).get("CHG_NUM")){
						/* 구분값 SE = "I, U"
						 * 일마감관리 조회 시 데이터가 없을 경우 I, 있을 경우 U
						 */
						if(deClosList.get(k).get("SE").equals("I")){
							deClosMap.put("bplcCode", deClosList.get(k).get("BPLC_CODE"));
							deClosMap.put("chgNum", deClosList.get(k).get("CHG_NUM"));
							deClosResult = commonMapper.insert(deClosMap, queryPath+".deClosInsert");
						}else {
							deClosMap.put("bplcCode", deClosList.get(k).get("BPLC_CODE"));
							deClosMap.put("chgNum", deClosList.get(k).get("CHG_NUM"));
							deClosResult = commonMapper.update(deClosMap, queryPath+".deClosUpdate");
						}
						
						if(deClosResult < 1){
							logger.error("일마감관리 수주최종번호 정보 INSERT 또는 UPDATE 실패");
							rtValue = false;
							rtMsg = "수주일련번호를 생성할 수 없습니다.";
							break;
						}
					}
				}
				
				//일마감관리 수주최종번호가 생성이 완료시
				if(deClosResult > 0){

					//LIST 자체를 나눠서 해당 list 에 index 번호를 부여해야함(현재 전달받은 list로 ==>newList )
					//나눌 수
					int divideNum = 5;
					//몫
					int rmndrNum = udtList.size() / divideNum;
					//나머지
					int portionNum = udtList.size() % divideNum;
					
					//나머지가 0보다 클경우 몫++
					if(portionNum>0) rmndrNum++;
					
					for(int a=0; a <rmndrNum; a++){
						int startNum = 0; 
						int endNum = 0;
						
						startNum = a*divideNum;
						endNum = (a+1)*divideNum;

						if(a == (rmndrNum-1)){
							if(portionNum==0) portionNum=divideNum;
							endNum = (startNum + portionNum) ;
						}
						
						map.remove("frm");
						map.put("frm", udtList.subList(startNum, endNum));
						
						udtResult = commonMapper.insert(map, queryPath+".insert");
						
						if(udtResult < 1){
							logger.error("수주명세서 INSERT 실패.");
							rtValue = false;
							rtMsg = "수주할 수 없습니다.";
						}
					}
					
				}else {
					rtValue = false;
					rtMsg = "입력할 수 있는 수주일련번호가 없습니다.";
				}
				
			}else {
				rtValue = false;
				rtMsg ="등록할 수 없습니다.";
			}
			
			//결과 return
			resultMap.put("result",rtValue);
			resultMap.put("resultMsg",rtMsg);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return resultMap;
	}
	
	
}
