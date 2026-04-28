package sgis.sys.util;

import java.math.BigDecimal;
import java.util.UUID;

public class CommonUtils {
	public static String getRandomString(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

	public static String nullReplace(String original, String replacement){
		if(original==null || original.equals("null") || original.equals("")){
			return replacement;
		}
		
		return original;
	}
	
	public static Long nullReplace(String original, Long replacement){
		if(original==null || original.equals("null") || original.equals("")){
			return replacement;
		}
		
		return Long.parseLong(original);
	}
	
	public static Integer nullReplace(String original, int replacement){
		if(original==null || original.equals("null") || original.equals("")){
			return replacement;
		}
		
		return Integer.parseInt(original);
	}
	
	public static double nullReplaceForDouble(String original, double replacement){
		if(original==null || original.equals("null") || original.equals("")){
			return replacement;
		}
		
		return Double.parseDouble(original);
	}
	
	/******************************Function.java 간소화*******************************************/
	//첨부파일 경로
		public static String UPLOAD_PATH = "upload";

		/**
		 * 스트링 인자값이 null일경우 ""값으로 리턴한다.
		 * @param str : check 값
		 * @param result : str이 null일경우 ""리턴.
		 */
		public static String nullCk(String str){
			if(str==null || str.equals("null") || str.equals("")){
				str="";
			}else{
				str = str.trim();
			}
			return str;
		}
		
		/**
		 * 스트링 인자값이 null일경우 ""값으로 리턴한다.
		 * @param str : check 값
		 * @param result : str이 null일경우 ""리턴.
		 */
		public static String nullChk(String str){
			if(str==null || str.equals("null") || str.equals("")){
				str="";
			}else{
				str = fnTagOff(str.trim());
			}
			return str;
		}
	  
		/**
		 * 스트링 인자값이 null일경우 원하는 스트링 결과값으로 리턴한다.
		 * @param str : check 값
		 * @param result : str이 null일경우 원하는 값
		 */
		public static String nullChk(String str, String result){
			if(str==null || str.equals("null") || str.equals("")){
				return result;
			}else{
				str = fnTagOff(str.trim());
				return str;
			}
		}
	  
		/**
		 * 스트링 인자값이 null일경우 원하는 int 결과값으로 리턴한다.
		 * @param str : check 값
		 * @param result : str이 null일경우 원하는 값
		 */
		public static int nullChk(String str, int result){
			if(str==null || str.equals("null") || str.equals("")){
				return result;
			}else{
				str = fnTagOff(str.trim());
				return Integer.parseInt(str);
			}
		}
		
		public static long nullChk(String str, long result){
			if(str==null || str.equals("null") || str.equals("")){
				return result;
			}else{
				str = fnTagOff(str.trim());
				return Long.parseLong(str);
			}
		}
		
		/**
		 * html tag 막기
		 * @param str
		 * @return
		 */
		public static String fnTagOff(String str){
			if(str==null || str.equals("null") || str.equals("")){
				str = "";
			}else{			
				str = str.trim();
				//str = str.replaceAll("&","&amp;");
				str = str.replaceAll("\"","&quot;");
				str = str.replaceAll("<","&lt;");
				str = str.replaceAll(">","&gt;");
				str = str.replaceAll("'","’"); //’는 한글 ㄴ의 특수문자임
			}
			return str;
		}
		
		/**
		 * @param str 넘어온 값 예) 1,000
		 * @return 실패시 0.0  성공시 1000
		 */
		public static Double numReplace(String str) {
			double result = 0.0;
			if(str==null || str.equals("null") || str.equals("") || str.equals("0")) {
				return result;
			}else {
				str = str.replace(",", "");
				return Double.parseDouble(str);
			}
		}
		
		/**
		 * @param str 넘어온 값 예) 2018-12-17
		 * @return 20181217
		 */
		public static String dateReplace(String str) {
			if(str==null || str.equals("null") || str.equals("")) {
				return "";
			}else {
				str = str.replace("-", "");
				return str;
			}
		}
		
		public static BigDecimal getBD(Object value) {
			return BigDecimal.valueOf(Double.valueOf(String.valueOf(value)));
		}
		
	/******************************Function.java 간소화*******************************************/
}
