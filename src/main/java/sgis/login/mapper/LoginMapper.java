package sgis.login.mapper;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("loginMapper")
public interface LoginMapper {
	Map<String, Object> view(Map<String, Object> map, String queryID) throws Exception;
}
