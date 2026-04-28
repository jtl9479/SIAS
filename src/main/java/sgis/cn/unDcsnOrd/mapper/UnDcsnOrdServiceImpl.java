package sgis.cn.unDcsnOrd.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.cn.unDcsnOrd.UnDcsnOrdService;

@Service("unDcsnOrdService")
public class UnDcsnOrdServiceImpl implements UnDcsnOrdService{

	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
