package sgis.security.mapper;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import sgis.security.dto.user;

@Mapper("securityMapper")
public interface SecurityMapper {
	
	user selectUserDetailInfo(String username) throws Exception;
}
