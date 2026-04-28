package sgis.cmmn.mapper;


import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import sgis.cmmn.UserDetailsVO;

@Mapper("userDetailsMapper")
public interface UserDetailsMapper {

	UserDetailsVO selectUserDetailInfo(String id) throws Exception;
	
	EgovMap userDetailInfo(String id) throws Exception;
	
}
