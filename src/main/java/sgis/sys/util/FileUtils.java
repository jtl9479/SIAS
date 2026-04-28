package sgis.sys.util;

import java.awt.AlphaComposite;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.util.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Component("fileUtils")
public class FileUtils {
	@Value("#{globals['Globals.DevFilePrefixPath']}")
	public String devFilePrefixPath;
	
	@Value("#{globals['Globals.ServiceFilePrefixPath']}")
	public String serviceFilePrefixPath;
	
	@Value("#{globals['Globals.Service']}")
	public String service;
	
	public String imgPrefixPath = "";
	
	private static String filePath = "C:\\fileTest\\";
	
	/**
	 * 물리적인 파일 등록
	 * @param map
	 * @param request
	 * @param folder
	 * @return
	 * @throws Exception
	 */
	public List<Map<String,Object>> parseInsertFileInfo(Map<String,Object> map, HttpServletRequest request, String folder) throws Exception{
		
		System.out.println("service  :: " +  service);
		System.out.println("devFilePrefixPath  :: " +  devFilePrefixPath);
		System.out.println("serviceFilePrefixPath  :: " +  serviceFilePrefixPath);
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;
        Iterator<String> iterator = multipartHttpServletRequest.getFileNames();
        
		MultipartFile multipartFile = null;
        String originalFileName = null;
        String originalFileExtension = null;
        String storedFileName = null;
        String ymd = getCurrentDate_yyyy_mm_dd();
        String fileDetilPath = null;
        String fileRealPath = null;
        String requestName = null;
        String idx = null;
        
        String[] imgFileTypeArr = new String[]{".JPG",".JPEG"};
        String[] docFileTypeArr = new String[]{".GIF",".PNG",".JPG",".JPEG",".TXT",".PPT",".PPTX",".XLSX",".XLS",".DOC",".DOCX",".PDF",".HWP",".HWT"};
        boolean resizeYN = false;
        String re_storedFileName = null;
        boolean fileChkYN = false;
        
        imgPrefixPath = devFilePrefixPath;
        
        if(service.equals("true")) imgPrefixPath = serviceFilePrefixPath;
		
        filePath = imgPrefixPath;
        
        // 파일저장경로 (기본경로 + 분류 + 년 + 월)
        if(service.equals("true"))
		{
        	fileDetilPath = "/" + folder + "/" + ymd.substring(0,4) + "/" + ymd.substring(5,7) + "/";
		}
		else
		{
			fileDetilPath = "\\" + folder + "\\" + ymd.substring(0,4) + "\\" + ymd.substring(5,7) + "\\";
		}
        
        
        filePath = filePath + fileDetilPath;
        
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        Map<String, Object> listMap = null; 
        
        File file = new File(filePath);
        if(file.exists() == false){
            file.mkdirs();
        }
        while(iterator.hasNext()){
            multipartFile = multipartHttpServletRequest.getFile(iterator.next());
            if(multipartFile.isEmpty() == false){
                originalFileName = multipartFile.getOriginalFilename();
                originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                storedFileName = CommonUtils.getRandomString() + originalFileExtension;
                fileRealPath = fileDetilPath + storedFileName;
                resizeYN = false;
                fileChkYN = false;

                // 파일확장자 체크
                for(String chk :  docFileTypeArr){
        			if(chk.equals(originalFileExtension.toUpperCase())){ 
        				fileChkYN = true;
        			}
        		}
                
                if (fileChkYN) {
                    
                    // input="file" 태그에서 name 가져와서 _부분으로 숫자(인덱스) 찾기
                    // 파일전송
                    requestName = multipartFile.getName();
                    idx = requestName.substring(requestName.lastIndexOf("_")+1);
                    
                    file = new File(filePath + storedFileName);
                    multipartFile.transferTo(file);
                
                	// 이미지파일인지 확인
                	for(String chk :  imgFileTypeArr){
            			if(chk.equals(originalFileExtension.toUpperCase())){ 
            				resizeYN =true;
            			}
            		}

                    //이미지 리사이즈 (JPG, JPEG 파일만 변환) 
                	// PNG는 투명부분 반전문제 발생, PNG, GIF는 회전각 정보 없음
                    if (resizeYN) {
                    	
                    	BufferedImage img = null;
                    	BufferedImage cnvImg = null;
                    	img = ImageIO.read(new File(filePath + storedFileName));
                    	
                    	// 모바일인경우에만 회전각 체크하여 이미지파일 회전
                    	//if(CommonController.getCurrentDevice(request).equals("mobile")) img = getOrientation(file);
                    	
                    	cnvImg = resizeImage(img, img.getWidth(), img.getHeight() ,1000);
                    	re_storedFileName = "re_"+storedFileName;
                    	
                    	file = new File(filePath + re_storedFileName);
                    	ImageIO.write(cnvImg, originalFileExtension.replace(".", ""), file);
       
                    	//원본이미지 삭제
                    	File delfile = new File(filePath + storedFileName);
                    	delfile.delete();
                    	
                    	storedFileName = re_storedFileName;
                    	fileRealPath = fileDetilPath + storedFileName;
                    }

                    listMap = new HashMap<String,Object>();
                    
                    listMap.put("ORG_FILE_NAME", originalFileName);
                    listMap.put("REAL_FILE_NAME", storedFileName);
                    listMap.put("FILE_SIZE", multipartFile.getSize());
                    listMap.put("FILE_ABS_PATH", filePath);
                    listMap.put("FILE_EXT", storedFileName.substring(storedFileName.lastIndexOf(".")+1,storedFileName.length()));
                    listMap.put("FILE_PATH", fileRealPath.toString().replace("\\", "/"));
                    listMap.put("FILE_IDX", idx);
                    listMap.put("FILE_INPUT_ATTR", requestName);
                   
                    list.add(listMap);
                }
            }
        }
        return list;
		
    }
	
	// 연월일
	public String getCurrentDate_yyyy_mm_dd(){
		SimpleDateFormat formater = new SimpleDateFormat("yyyy-MM-dd",Locale.KOREA);
		Date current = new Date();
		String date = formater.format(current);
		return date;
	}
	
	// 물리적인 파일전체삭제
	public boolean fileDel(List<Map<String,Object>> commandMapList) throws Exception{
		boolean delReturn = false;
		
		for(int i=0; i < commandMapList.size(); i++) {
			Map<String, Object> map = commandMapList.get(i);
			
			if (i<1) {
				delReturn = fileDel(map);
			} else {
				if (delReturn) delReturn = fileDel(map);
			}
		}

	    return delReturn;
	}

	// 물리적인 파일삭제
	public boolean fileDel(Map<String, Object> map) {
		 
		if(service.equals("true"))
		{
			imgPrefixPath = serviceFilePrefixPath;
		}
		else
		{
			imgPrefixPath = devFilePrefixPath;
		}
		filePath = imgPrefixPath;
		
		boolean delReturn = false;

		String realFileName = String.valueOf(map.get("REAL_FILE_NAME"));
	    String saveFilePath = String.valueOf(map.get("FILE_PATH"));
	    //File file = new File(filePath+saveFilePath+realFileName);
	    File file = new File(filePath+saveFilePath);
	    
	    System.out.println("file : "+filePath+saveFilePath);
	    
	    delReturn = file.delete();
	    
	    System.out.println("delReturn==="+delReturn);
		
		return delReturn;
	}
	
	// 이미지리사이즈
		public BufferedImage resizeImage(final Image image, int w, int h, int width) {
			
		    int height = h;

		    if (w <= width) {
		        width = w;
		        height = h;
		    }
		    else {
		        float per = (float)width / (float)w;
		        height = (int)(h * per);
		    }

		    final BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		    final Graphics2D graphics2D = bufferedImage.createGraphics();
		    graphics2D.setComposite(AlphaComposite.Src);
		    graphics2D.setRenderingHint(RenderingHints.KEY_INTERPOLATION,RenderingHints.VALUE_INTERPOLATION_BILINEAR);
		    graphics2D.setRenderingHint(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_QUALITY);
		    graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
		    graphics2D.drawImage(image.getScaledInstance(width, height, Image.SCALE_SMOOTH), 0, 0, width, height, null);
		    graphics2D.dispose();

		    return bufferedImage;
		}
	
		
		// 파일 다운로드
		public void downloadFile(HttpServletResponse response, String saveFileName, String saveFilePath) throws Exception{

			if(service.equals("true"))
			{
				imgPrefixPath = serviceFilePrefixPath;
			}
			else
			{
				imgPrefixPath = devFilePrefixPath;
			}
			filePath = imgPrefixPath;
			InputStream fileIs = new FileInputStream(filePath+saveFilePath);
			byte[] fileByte = IOUtils.toByteArray(fileIs);
		     
		    response.setContentType("application/octet-stream");
		    response.setContentLength(fileByte.length);
		    response.setHeader("Content-Disposition", "attachment; fileName=\"" + URLEncoder.encode(saveFileName,"UTF-8").replace("+", " ")+"\";");
		    response.setHeader("Content-Transfer-Encoding", "binary");
		    response.getOutputStream().write(fileByte);
		     
		    response.getOutputStream().flush();
		    response.getOutputStream().close();
		    fileIs.close();
		}
}