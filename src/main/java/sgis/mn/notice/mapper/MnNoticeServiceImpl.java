package sgis.mn.notice.mapper;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.mn.notice.MnNoticeService;

@Service("mnNoticeService")
public class MnNoticeServiceImpl implements MnNoticeService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
}
