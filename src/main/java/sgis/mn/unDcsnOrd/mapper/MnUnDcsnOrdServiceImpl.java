package sgis.mn.unDcsnOrd.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import sgis.cmmn.mapper.CommonMapper;
import sgis.mn.unDcsnOrd.MnUnDcsnOrdService;

@Service("mnUnDcsnOrdService")
public class MnUnDcsnOrdServiceImpl implements MnUnDcsnOrdService{
	
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	private CommonMapper commonMapper;
	
	@Override
	public Map<String, Object> listItem(Map<String, Object> map, String queryID) throws Exception {
		Map<String, Object> resultMap = new HashMap<String,Object>();
		List<Map<String, Object>> listItem = new ArrayList<Map<String, Object>>();
		
		listItem = commonMapper.list(map, queryID);
		String listStartDt = "";
		
		if(listItem.size() > 0) {
			
			Map<String, Object> listMap = listItem.get(0);
			listStartDt = String.valueOf(listMap.get("listStartDt")); 

		} else {
			listStartDt = String.valueOf(map.get("searchDtFrom")); 
		}
		
		resultMap.put("list", listItem);
		resultMap.put("listStartDt", listStartDt);
		
		return resultMap;
	}
}