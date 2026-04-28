package sgis.cmmn.mapper;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.CommonService;

@Service("commonService")
public class CommonServiceImpl implements CommonService{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
	
	/*
	 * 나눌 수
	 * 5(test)
	 * 50(real)
	 * 추후 변경 예정
	 */
	Integer GlobalDivideNum = 50;
	
	
	protected void printQueryId(String queryId) {
		if(logger.isInfoEnabled()){
			logger.info("\t QueryId  \t:  " + queryId);
		}
	}

	@Override
	public Map<String, Object> list(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("list", commonMapper.list(map, queryID));
		return resultMap;
	}

	@Override
	public int listCnt(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.listCnt(map, queryID);
	}
	
	@Override
	public String strVal(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.strVal(map, queryID);
	}

	@Override
	public Map<String, Object> view(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.view(map, queryID);
	}

	@Override
	public int insert(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.insert(map, queryID);
	}
	
	@Override
	public int update(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.update(map, queryID);
	}
	
	@Override
	public int delete(Map<String, Object> map, String queryID) throws Exception {
		//printQueryId(queryID);
		return commonMapper.delete(map, queryID);
	}
	
	@Override
	public int insertList(Map<String, Object> map, String[] itemList, String queryID) throws Exception {
		//printQueryId(queryID);
		int result = 0;
		List<Map<String,Object>> arrList = new ArrayList<>();
		
		for(int i=0; i < itemList.length; i++){
			Map<String, Object> frm = new HashMap<String, Object>();
			frm.put("itemCode", String.valueOf(itemList[i]));
			arrList.add(frm);
		}
		
		//나눌수
		int divideNum = GlobalDivideNum;
		//몫
		int rmndrNum = arrList.size() / divideNum;
		//나머지
		int portionNum = arrList.size() % divideNum;
		
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
			map.put("frm", arrList.subList(startNum, endNum));
			
			result = commonMapper.insert(map, queryID);
		}
		
		return result;
	}

	@Override
	public int saveList(Map<String, Object> map, List<Map<String, Object>> itemList, String queryID) throws Exception {
		//printQueryId(queryID);
		int result = 0;
		
		//나눌 수
		int divideNum = GlobalDivideNum;
		//몫
		int rmndrNum = itemList.size() / divideNum;
		//나머지
		int portionNum = itemList.size() % divideNum;
		
		//나머지가 0보다 클경우 몫++
		if(portionNum>0) rmndrNum++;
		
		if(map.get("logicSe")!=null){
			
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
				map.put("frm", itemList.subList(startNum, endNum));
				
				switch (String.valueOf(map.get("logicSe"))) {
				case "INS":
					result = commonMapper.insert(map, queryID);
					break;
				case "UDT":
					result = commonMapper.update(map, queryID);
					break;
				case "DEL":
					result = commonMapper.delete(map, queryID);
					break;
				default:
					break;
				}
			}
		}else {
			result = -1;
		}
		
		return result;
	}

	@Override
	public Map<String, Object> getInvntryMap(Map<String, Object> map, String queryID) throws Exception {		
		//재고상태 map
		Map<String, Object> m = new HashMap<>();
		//return map 
		Map<String, Object> resultMap = new HashMap<>();
		
		BigDecimal big_invntryWt = new BigDecimal(0);
		BigDecimal org_big_invntryWt = new BigDecimal(0);
		String invntryColor = "";
	
		/**********************************날짜계산*************************/
		Date current = new Date();
		SimpleDateFormat fm = new SimpleDateFormat("yyyyMMdd",Locale.KOREA);
		String date1 = String.valueOf(map.get("W_DEDT")), date2 = fm.format(current); 
		Date FirstDate = fm.parse(date1), SecondDate = fm.parse(date2);
		long calDate = FirstDate.getTime() - SecondDate.getTime();
		long calDateDays = calDate / ( 24*60*60*1000); 
		
	    /**********************************날짜계산*************************/
	    
	    /*****************************수식계산기준***************************/
	    /*
	     * 입력한 납기일자가 10일 이후에는 녹색으로 강제 변경 
	     * Red : 가져온 재고중량이 1보다 작거나 같을 경우
	     * Yellow : 입력한 중량이 재고중량보다 클경우 
	     * Green : 입력한 중량이 재고중량보다 작을 경우 
	     */
	    /*****************************************************************/
	    
	    if(calDateDays > 9){
	    	invntryColor = "G";
	    	
	    	// 관리자일 경우 재고도 계산
	    	if("A".equals(String.valueOf(map.get("userSe")))){
	    		m = commonMapper.getInvntryMap(map, queryID);
	    		big_invntryWt = BigDecimal.valueOf(Double.valueOf(String.valueOf(m.get("INVNTRY_WT"))));
	    		org_big_invntryWt = BigDecimal.valueOf(Double.valueOf(String.valueOf(m.get("INVNTRY_WT"))));
	    		//가져온 재고 수량이 0보다 작거나 같을경우(업무 미정)
	        	/*if(big_invntryWt.compareTo(BigDecimal.ONE) <= 0) {
	        		invntryColor = "R";
	        	}*/
	    	}
	    }else {
	    	m = commonMapper.getInvntryMap(map, queryID);
	    	big_invntryWt = BigDecimal.valueOf(Double.valueOf(String.valueOf(m.get("INVNTRY_WT"))));
	    	org_big_invntryWt = BigDecimal.valueOf(Double.valueOf(String.valueOf(m.get("INVNTRY_WT"))));
	    	
	    	//가져온 재고 중량이 1보다 작거나 같을경우
	    	if(big_invntryWt.compareTo(BigDecimal.ONE) <= 0) {
	    		invntryColor = "R";
	    	}
	    	else {
	    		//재고중량과 입력한 중량 비교(입력한 중량이 재고중량보다 작을 경우)
	    		//if (Double.valueOf(String.valueOf(map.get("W_WT"))) < invntryWt) invntryColor = "G";
	    		if (BigDecimal.valueOf(Double.valueOf(String.valueOf(map.get("W_WT")))).compareTo(big_invntryWt) <= 0 ) {
	    			invntryColor = "G";
	    		}else{
	    			invntryColor = "Y";
	    		}
				
	    	}
	    }
	    
	    //단가단위
	    String untpcUnit = String.valueOf(map.get("W_UNTPCUNIT"));
	    
	    /*
	     * 거래처의 경우 box로 강제로 지정해놨기 때문에 무조건 1번을 탄다.
	     * 관리자는 중량 3번
	     * 거래처는 박스, 관리자는 중량 ==>> 20190417 1320 SGIS_KSK
	     * */
	    if("U".equals(String.valueOf(map.get("userSe")))){
	    	untpcUnit = "1";
	    }else if("A".equals(String.valueOf(map.get("userSe")))){
	    	untpcUnit = "3";
	    }
	    
	    if(m.size() > 0){
	    	//단가 단위에 따라 화면에 표시할 재고수량이 달라짐.
	        switch (untpcUnit) {
				case "1":
					System.out.println("case 1 >> ");
					//invntryWt = invntryWt / (Double.valueOf(String.valueOf(m.get("IC_UNITQY"))) * Double.valueOf(String.valueOf(m.get("IC_PACKNGUNIT"))));
					BigDecimal multipleBigVar = BigDecimal.valueOf((Double.valueOf(String.valueOf(m.get("IC_UNITQY")))) * Double.valueOf(String.valueOf(m.get("IC_PACKNGUNIT"))));
					if(multipleBigVar.compareTo(BigDecimal.ONE) > 0){
						big_invntryWt = big_invntryWt.divide(multipleBigVar,BigDecimal.ROUND_FLOOR).setScale(0, BigDecimal.ROUND_FLOOR);
					}else{
						big_invntryWt = multipleBigVar.setScale(0, BigDecimal.ROUND_FLOOR);
					}
					
					break;
				case "2":
					System.out.println("case 2 >> ");
					big_invntryWt = big_invntryWt.divide(BigDecimal.valueOf((Double.valueOf(String.valueOf(m.get("IC_UNITQY"))))),BigDecimal.ROUND_FLOOR);
					big_invntryWt = big_invntryWt.setScale(1, BigDecimal.ROUND_FLOOR);
					break;
				case "3":
					System.out.println("case 3 >> ");
					big_invntryWt = big_invntryWt.setScale(1, BigDecimal.ROUND_FLOOR);
					break;
				default:
					break;
			}
			
	    	//단가단위 3인경우로
	    	//big_invntryWt = big_invntryWt.setScale(1, BigDecimal.ROUND_FLOOR);
	    }
	    System.out.println("big_invntryWt  ::: " + big_invntryWt);
	    
	    //재고상태 색상, 재고중량, 계산 전 재고중량 return
	    resultMap.put("color", invntryColor);
	    resultMap.put("invntryWt", big_invntryWt);
	    
	    //소수점 버림처리 (20190423_SGIS_KTY
	    resultMap.put("orgInvntryWt", org_big_invntryWt.setScale(0, BigDecimal.ROUND_FLOOR));
	    
		return resultMap;
	}
}
