package sgis.cn.ordMod.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import sgis.cmmn.mapper.CommonMapper;
import sgis.cn.ordMod.OrdModService;

public class OrdModServiceImpl implements OrdModService{
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
