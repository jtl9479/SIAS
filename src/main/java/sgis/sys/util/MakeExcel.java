package sgis.sys.util;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFCreationHelper;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.util.IOUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;
import sgis.sys.common.CommandMap;
public class MakeExcel {
	
	private static final Logger logger = LoggerFactory.getLogger(MakeExcel.class);
	
    public MakeExcel() {}

    public String get_Filename() {
    	SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
    	return ft.format(new Date());
    }

    public String get_Filename(String pre) {
        return pre + get_Filename();
    }
    
    /**
     * Make Excel & Download. 
     * @throws UnsupportedEncodingException 
     */
    
    public void download(HttpServletRequest request, HttpServletResponse response, String templateFile) throws FileNotFoundException, UnsupportedEncodingException, InvalidFormatException {
        //Templete 위치
    	String tempPath = request.getSession().getServletContext().getRealPath("/WEB-INF/templete") ;
        //파일명
        String filename = URLEncoder.encode("test","UTF-8");
        
        try { 
            InputStream is = new BufferedInputStream(new FileInputStream(tempPath + "/" + templateFile));
            
            //xls, xlsx 관련 없이 적절한 workBook을 생성해준다.
            Workbook resultWorkbook = WorkbookFactory.create(is);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
            OutputStream os = response.getOutputStream();
            resultWorkbook.write(os);
            resultWorkbook.close();
            
            try
			{
				is.close();
				os.flush();
				os.close();
			}
			catch (Exception e)
			{
				System.out.println("닫기 실패" + e);
			}
            
        } catch (ParsePropertyException | IOException ex) {
        	logger.error("MakeExcel.download fail");
        }
    }
}
