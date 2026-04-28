package sgis.mn.dcsnProcess.mapper;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.mn.dcsnProcess.MnDcsnProcessService;
import sgis.sys.util.CommonUtils;
import sun.java2d.HeadlessGraphicsEnvironment;

@Service("mnDcsnProcessService")
public class MnDcsnProcessServiceImpl implements MnDcsnProcessService {
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
	
	@Override
	public Map<String, Object> listItem(Map<String, Object> map, String queryID) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		List<Map<String, Object>> listItem = new ArrayList<Map<String, Object>>();
		
		listItem = commonMapper.list(map, queryID);
		String listStartDt = "";
		
		if(listItem.size() > 0) {
			
			Map<String, Object> listMap = listItem.get(0);
			listStartDt = String.valueOf(listMap.get("listStartDt")); 

		} else {
			listStartDt = String.valueOf(map.get("searchDtFrom")); 
		}
		
		resultMap.put("list", listItem);
		resultMap.put("listStartDt", listStartDt);
		
		return resultMap;
	}
	
	/**
	 * 수주명세서 ISNERT 및 UPDATE 진행 Logic
	 * 순서)
	 *   1. 일마감관리 마감일자 조회
	 *   2. 주문접수 단가사업장 비교 하여 동일한 사업장에 CHG_NUM(일마감관리 INSERT, UPDATE 값) ++
	 *   3. 일마감관리 INSERT OR UPDATE
	 *   4. 수주명세서 INSERT AND UPDATE
	 **/
	@Override
	public Map<String, Object> osSaveItem(Map<String, Object> map, String queryPath){
		//결과 return map
		Map<String, Object> resultMap = new HashMap<String,Object>();
		//일마감관리 ListMap
		List<Map<String, Object>> deClosList = new ArrayList<Map<String, Object>>();
		
		try{
			//일마감관리 마감일자조회
			deClosList = commonMapper.list(map, queryPath+".deClosList");
			
			//String[] selectYnArr = (String[]) map.get("selectYn");
			//배열에 1개의 값만 있을경우 캐스팅 문제가 발생하여 commandMap의 getStrArr을 별도로 생성해서 배열처리 해줌 SGIS_TY_0530 
			String[] selectYnArr = getStrArr(map.get("selectYn"));
			String[] wRceptdeArr = getStrArr(map.get("W_RCEPTDE"));
			String[] wSnArr = getStrArr(map.get("W_SN"));
			String[] wUnitBplcArr = getStrArr(map.get("W_UNIT_BPLC"));
			String[] wInvntryQyArr = getStrArr(map.get("INVNTRY_QY"));
			
			int osInsNo = 0;
			int deClosResult = 0;
			int udtResult = 0;
			int insResult = 0;
			
			//retrun 결과값
			String rtMsg = "";
			Boolean rtValue = true;
			
			if(selectYnArr != null){
				List<Map<String, Object>> udtList = new ArrayList<>();
				Map<String, Object> frm = null;
				
				for(int a=0; a < selectYnArr.length; a++){
					frm = new HashMap<String, Object>();
					//체크박스가 선택된 경우에만 진행
					if(selectYnArr[a].equals("Y")){
						for(int b=0; b<deClosList.size(); b++){
							osInsNo = 0;
							//선택된 체크박스의 단가사업장과 일마감관리의 단가사업장이 같은경우
							//해당 단가사업장의 수주최종번호 ++ 이후 다시 CHG_NUM에 값 INSERT
							if(wUnitBplcArr[a].equals(deClosList.get(b).get("BPLC_CODE"))){
								osInsNo = (Integer.valueOf(deClosList.get(b).get("CHG_NUM").toString()))+1;
								deClosList.get(b).put("CHG_NUM", osInsNo);
								break;
							}
						}
						
						//동일 INDEX의 map에 값 put
						frm.put("wRceptde", CommonUtils.dateReplace(wRceptdeArr[a])); //접수일자
						frm.put("wSn", wSnArr[a]); //접수일련번호
						frm.put("osInsNo",osInsNo);	 //수주일련번호
						frm.put("wInvntryQy", wInvntryQyArr[a]); //재고상태
						
						udtList.add(frm);
					}
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
					//나눌 수
					int divideNum = 50;
					
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
						
						//update sql에서 INSERT, UPDATE 함께 진행
						insResult = commonMapper.update(map, queryPath+".dcsnProcessInsert");
						
						if(insResult < 1){
							logger.error("수주명세서 INSERT 실패.");
							rtValue = false;
							rtMsg = "주문확인을 실패하였습니다. ";
						}else {
							udtResult = commonMapper.update(map, queryPath+".dcsnProcessUpdate");
							
							if(udtResult < 1) {
								logger.error("웹주문접수 Update 실패.");
								rtValue = false;
								rtMsg = "주문확인을 실패하였습니다. ";
							}
						}
					}
					
				}else {
					rtValue = false;
					rtMsg = "입력할 수 있는 수주일련번호가 없습니다.";
				}
				
			}else{
				rtValue = false;
				rtMsg ="선택된 제품이 없습니다.";
			}
			
			//결과 return
			resultMap.put("result",rtValue);
			resultMap.put("resultMsg",rtMsg);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return resultMap;
	}
	
	
	public String[] getStrArr(Object key){
    	Object  value = key;
    	
    	if (value instanceof String[] ) {
			return (String[]) value;
		} else {
			String[] strArray = new String[] {value.toString()};
			return strArray;
		}
    }
}
