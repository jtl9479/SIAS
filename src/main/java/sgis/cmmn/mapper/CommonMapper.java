package sgis.cmmn.mapper;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Repository("commonMapper")
public class CommonMapper extends EgovAbstractMapper{
	
	protected void printQueryId(String queryId) {
		if(logger.isDebugEnabled()){
			logger.debug("\t QueryID  \t:  " + queryId);
		}
	}
	
	public List<Map<String, Object>> list(Map<String, Object> map, String queryID) throws Exception {
		printQueryId(queryID);
		return selectList(queryID, map);
	}
	
	public int listCnt (Map<String, Object> map, String queryID) throws Exception {
		printQueryId(queryID);
		return selectOne(queryID, map);
	}
	
	public String strVal (Map<String, Object> map, String queryID) throws Exception {
		printQueryId(queryID);
		return selectOne(queryID, map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> view (Map<String, Object> map, String queryID) throws Exception {
		printQueryId(queryID);
		return (Map<String, Object>)selectOne(queryID, map);
	}
	
	public int insert(Map<String, Object> map, String queryID) {
		printQueryId(queryID);
		return insert(queryID, map);
	}
	
	public int update(Map<String, Object> map, String queryID) {
		printQueryId(queryID);
		return update(queryID, map);
	}
	
	public int delete(Map<String, Object> map, String queryID) {
		printQueryId(queryID);
		return delete(queryID, map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getInvntryMap (Map<String, Object> map, String queryID) throws Exception {
		printQueryId(queryID);
		return (Map<String, Object>)selectOne(queryID, map);
	}
}
