package sgis.cmmn;

import java.util.List;
import java.util.Map;

public interface CommonService {
		
		// 목록
		public Map<String, Object> list(Map<String, Object> map, String queryID) throws Exception;
		
		// 페이징 카운트
		public int listCnt(Map<String, Object> map, String queryID) throws Exception;
		
		// String return 값
		public String strVal(Map<String, Object> map, String queryID) throws Exception;
		
		// 상세
		public Map<String, Object> view(Map<String, Object> map, String queryID) throws Exception;
		
		// 등록
		public int insert(Map<String, Object> map, String queryID) throws Exception;
		
		// 수정
		public int update(Map<String, Object> map, String queryID) throws Exception;
		
		// 삭제
		public int delete(Map<String, Object> map, String queryID) throws Exception;
		
		// 등록 리스트
		public int insertList(Map<String, Object> map, String[] itemList, String queryID) throws Exception;
		
		// 등록 & 수정 & 삭제 공통 사용
		public int saveList(Map<String, Object> map,  List<Map<String, Object>> itemList, String queryID) throws Exception;
		
		// 재고상태 Map return
		public Map<String, Object> getInvntryMap(Map<String, Object> map, String queryID) throws Exception;
		
}
