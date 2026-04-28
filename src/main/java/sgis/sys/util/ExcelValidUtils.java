package sgis.sys.util;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import sgis.sys.common.CommandMap;

@Component("excelValidUtils")
public class ExcelValidUtils {
    
	public static String get_Filename() {
    	SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
    	return ft.format(new Date());
    }

    public static String get_Filename(String pre) {
        return pre + get_Filename();
    }
  	
  	/**
	 * 엑셀 파일 빈값 유효성 체크
	 * @param val
	 * @return
	 * @throws Exception
	 */
  	public static Boolean excelValidChk(String val){
  		boolean result = true;
  		
  		if(val.equals(null) || val.equals("") || val.length() < 0 || val.equals("false") 
  				|| val=="false" || val.equals("-") || val.equals("0.0") ){
			result = false;
		}
  		
  		return result;
  	}
  	
  	/**
	 * 엑셀파일 유효성 체크 실패 시 결과 return text
	 * @param response
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
  	public void returnFailText (HttpServletResponse response, CommandMap commandMap) {
      	String entrpsSe = commandMap.getStr("ENTRPS_SE");
      	String entrpsNm = "";
      	if(entrpsSe.equals("SSW")) entrpsNm = "삼성웰스토리";
      	else if(entrpsSe.equals("PMO")) entrpsNm = "풀무원";
  		else if(entrpsSe.equals("ICP")) entrpsNm = "생협";
		else if(entrpsSe.equals("LTM")) entrpsNm = "롯데마트";
		else if(entrpsSe.equals("VMK")) entrpsNm = "빅마켓";
		else if(entrpsSe.equals("HPS")) entrpsNm = "홈플러스";
		else if(entrpsSe.equals("NEM")) entrpsNm = "뉴이마트";
      	
      	String textFileNm = entrpsNm+"업로드결과_";
      	textFileNm = get_Filename(textFileNm)+".txt";
		try {
			String errorTxt = String.valueOf(commandMap.get("excelErrorMsg"));
 			String line = System.getProperty("line.separator");
 			errorTxt = errorTxt.replace("\r\n", line);
 			response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(textFileNm,"UTF-8").replace("+", " ")+"\";");
 			response.setHeader("Content-Transfer-Encoding", "binary");
 			response.setContentType("application/octet-stream");
		   
 			byte[] fileByte = errorTxt.getBytes();
 			response.setContentLength(fileByte.length);
 			response.getOutputStream().write(fileByte);
 			response.getOutputStream().flush();
 			response.getOutputStream().close();
 			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
      }
  	
}
