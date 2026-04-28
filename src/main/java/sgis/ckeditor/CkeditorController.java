package sgis.ckeditor;

import java.io.File;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import sgis.cmmn.CommonController;
import sgis.sys.common.CommandMap;

@Controller
@RequestMapping(value = "/ckeditor")
public class CkeditorController extends CommonController {

	private static final Logger logger = LoggerFactory.getLogger(CkeditorController.class);

	@RequestMapping(value = "/imgUpload.do")
	public String editorFile(Model model, CommandMap commandMap, HttpServletRequest request,
			HttpServletResponse response, FileBean fileBean) throws Exception {
		// 세션정보
		// sessionMap(commandMap, request);
		HttpSession session = request.getSession();
		String filePath = "";
		String fileNm = "";
		String rootPath = session.getServletContext().getRealPath("/");
		MultipartFile multipartFile = fileBean.getUpload();
		List<Map<String, Object>> list = fileUtils.parseInsertFileInfo(commandMap.getMap(), request, "editor");
		if (!list.equals(null)) {
			filePath = filePrefixUrl + list.get(0).get("FILE_PATH");
			fileNm = String.valueOf(list.get(0).get("REAL_FILE_NAME"));
			/* Utils의 parseInsertFileInfo에서 multipart 처리 하기 때문에 주석처리 진행
			 * File file = new File(rootPath + filePrefixUrl);
			if(file.exists() == false){
				file.mkdirs();
			}
			file = new File(rootPath+filePath);
			multipartFile.transferTo(file);*/
		}

		PrintWriter pw = null;
		pw = response.getWriter();
		
		// CKEditor 4.9ver 부터 return을 JSON으로 주어야함.
		Gson gson = new Gson();
		JsonObject obj = new JsonObject();
		obj.addProperty("uploaded", "1");
		obj.addProperty("fileName", fileNm);
		obj.addProperty("url", filePath);
		String json = gson.toJson(obj);
		pw.write(json);
		pw.flush();
		pw.close();

		/*model.addAttribute("fileName", fileNm);
		model.addAttribute("filePath", filePath);
		model.addAttribute("CKEditorFuncNum", "1");*/

		return "ckeditor/uploadRtn";
	}

}
