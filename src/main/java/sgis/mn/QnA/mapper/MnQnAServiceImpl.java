package sgis.mn.QnA.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.mn.QnA.MnQnAService;

@Service("mnQnaService")
public class MnQnAServiceImpl implements MnQnAService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
