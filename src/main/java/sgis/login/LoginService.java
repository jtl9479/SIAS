package sgis.login;

import java.util.Map;

public interface LoginService {
	
	// 상세
	public Map<String, Object> view(Map<String, Object> map, String queryID) throws Exception;
}
