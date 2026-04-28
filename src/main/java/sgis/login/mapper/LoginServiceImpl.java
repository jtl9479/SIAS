package sgis.login.mapper;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import sgis.login.LoginService;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name="loginMapper")
	LoginMapper loginMapper;

	@Override
	public Map<String, Object> view(Map<String, Object> map, String queryID) 
		throws Exception {
		
		logger.debug("LoginServiceImpl.view.map  :: " + map);
		logger.debug("LoginServiceImpl.view.queryID  :: " + queryID);
		
		
		Map<String, Object> resultMap = new HashMap<String,Object>();
		resultMap.put("view", loginMapper.view(map, queryID));
		return resultMap;
	}
	
	
}
