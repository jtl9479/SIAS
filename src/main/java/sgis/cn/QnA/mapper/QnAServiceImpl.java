package sgis.cn.QnA.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.cn.QnA.QnAService;

@Service("qnaService")
public class QnAServiceImpl implements QnAService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
