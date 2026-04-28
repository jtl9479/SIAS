package sgis.cmmn;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import sgis.sys.common.CommandMap;
import sgis.sys.util.FileUtils;

@Controller
@RequestMapping(value = "/common")
public class CommonController {
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="commonService")
	public CommonService commonService;
	
	@Resource(name="fileUtils")
	public FileUtils fileUtils;
	
	@Value("#{globals['Globals.Service']}")
	public String service;
	
	@Value("#{globals['Globals.file.prefix.url']}")
	public String filePrefixUrl;
	
	/**
	 * 세션변수처리
	 * @param commandMap
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public CommandMap sessionMap(CommandMap commandMap, HttpServletRequest request) throws Exception{
		// 세션정보
		/*HttpSession session = request.getSession();
		@SuppressWarnings("unchecked")
		Map<String,Object> sessionMap = (Map<String, Object>) session.getAttribute("sess_emp");
		Integer empSeq = (Integer) sessionMap.get("ID");	
		Integer empCompSeq = (Integer) sessionMap.get("FK_COMP_ID");	
		
		commandMap.put("sessEmpSeq", empSeq);
		commandMap.put("sessCompSeq", empCompSeq);*/
		
		return commandMap;
	}

	/**
	 * Sub Menu 공지사항 공통 사용
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> subMenu(CommandMap commandMap) throws Exception{
		Map<String,Object> resultMap = commonService.view(commandMap.getMap(), "common"+".subMenu");
		return resultMap;
	}
	
	/**
	 * 재고 상태
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	public Map<String,Object> getInvntrySttus(CommandMap commandMap) throws Exception{
		Map<String,Object> resultMap = commonService.getInvntryMap(commandMap.getMap(), "common"+".getInvntrySttus");
		return resultMap;
	}
	
	
	// 연월일 시분초
	public String getCurrentTimeTypeString(){
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}
	
	// 연월일
	public String getCurrentDate(){
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}

	// 현재일 ±개월수
	public String getAddMonthDate(int addMonth){
		SimpleDateFormat dateFormat     = new SimpleDateFormat("yyyyMMdd",Locale.KOREA);
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, addMonth);
		
		String date = dateFormat.format(calendar.getTime());
		return date;
	}
	
	// 현재일 ±일 수
	public String getAddWeekDate(int addDate){
		SimpleDateFormat dateFormat     = new SimpleDateFormat("yyyyMMdd",Locale.KOREA);
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, addDate);
		
		String date = dateFormat.format(calendar.getTime());
		return date;
	}
	
	//특정일 이전 날짜 구하기
	public String getBeforeDate(String stdrDate, int addDate){
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = Calendar.getInstance();
		Date dt = null;
		String date =null;
		
		try {
			dt = fmt.parse(stdrDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		calendar.setTime(dt);
		calendar.add(Calendar.DATE, addDate);
		date = fmt.format(calendar.getTime());
		
		return date;
	}

	//날짜 비교
	public String getCompareDt(String fromDt, String cpDt) throws ParseException {
		String date = null;
		
		if(cpDt.equals("") || cpDt.equals(null)){
			cpDt=getAddWeekDate(-4);
		}
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
		Date day1 = null, day2 = null;
	
		day1 = fmt.parse(cpDt);
		day2 = fmt.parse(fromDt);

		int compareDay = day1.compareTo(day2);
		if(compareDay > 0){
			date = cpDt;
		}else {
			date = fromDt;
		}
		
		return date;
	}
	
	//날짜 비교 int 값 리턴
	public Integer getCompareIntVal(String fromDt, String cpDt) throws ParseException {
		
		if(cpDt.equals("") || cpDt.equals(null)){
			cpDt=getAddWeekDate(-4);
		}
		
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
		Date day1 = null, day2 = null;
	
		day1 = fmt.parse(cpDt);
		day2 = fmt.parse(fromDt);

		int compareDay = day1.compareTo(day2);
		
		return compareDay;
	}
	
	// 페이징번호 계산
	public static int getRowNum(CommandMap commandMap, String totalCount){		
		int rowNum = (int) ((Integer.parseInt(totalCount)) 
				- ( (Integer.parseInt(commandMap.get("PAGENO").toString()) - 1L )
				* Integer.parseInt(commandMap.get("PAGE_ROW").toString()) ));
		return rowNum;
	}
	
	public static String getCurrentDate_yyyymmdd(){
		SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}
	
	public static String getCurrentDate_hhmmss(){
		SimpleDateFormat formater = new SimpleDateFormat("HH:mm:ss",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}
	
	public static String getCurrentDate_yyyy_mm_dd(){
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}
	
	// 문자배열로 형변환 
	public Object strArr(Object value) throws Exception{
		if (value instanceof String[] ) {
			return value;
		} else {
			String[] strArray = new String[] {value.toString()};
			return strArray;
		}
	}
	
	// 숫자배열로 형변환 
	public Object intArr(Object value) throws Exception{
		
		if (value instanceof Integer[] ) {
			return value;
		} else {
			Integer[] intArray = new Integer[] {(Integer) value};
			return intArray;
		}
	}
	
	/**
	 * 파일다운로드
	 * @param model
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/fileDown.do")
	public String fileDown(Model model, CommandMap commandMap, HttpServletResponse response ) throws Exception{
		fileUtils.downloadFile(response, commandMap.get("FILE_NM").toString(), commandMap.get("FILE_PT").toString());
		return "jsonView";  

	}
	
}
