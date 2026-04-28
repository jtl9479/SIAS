package sgis.mn.excel;

import java.util.List;
import java.util.Map;

public interface MnExcelService {
	public Map<String, Object> osSaveItem(Map<String, Object> map, List<Map<String,Object>> l, String queryPath) throws Exception;
}
