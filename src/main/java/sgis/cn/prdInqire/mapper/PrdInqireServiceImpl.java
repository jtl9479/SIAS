package sgis.cn.prdInqire.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.cn.prdInqire.PrdInqireService;

@Service("prductInqireService")
public class PrdInqireServiceImpl implements PrdInqireService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
