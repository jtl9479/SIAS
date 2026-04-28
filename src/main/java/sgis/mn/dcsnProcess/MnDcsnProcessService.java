package sgis.mn.dcsnProcess;

import java.util.Map;

public interface MnDcsnProcessService {
	public Map<String, Object> listItem(Map<String, Object> map, String queryID) throws Exception;
	
	public Map<String, Object> osSaveItem(Map<String, Object> map, String queryPath) throws Exception;
}
