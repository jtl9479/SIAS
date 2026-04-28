package sgis.sys.common;
 
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import sgis.sys.util.CommonUtils;
 
public class CommandMap {
    Map<String,Object> map = new HashMap<String,Object>();
     
    public Object get(String key){
    	return map.get(key);
    }
    
    public void put(String key, Object value){
    	// 문자인경우 공백제거
    	if (value instanceof String ) {
    		String strValue = String.valueOf(value).trim();
    		map.put(key, strValue);
    	}
        map.put(key, value);
    }
     
    public Object remove(String key){
        return map.remove(key);
    }
     
    public boolean containsKey(String key){
        return map.containsKey(key);
    }
     
    public boolean containsValue(Object value){
        return map.containsValue(value);
    }
     
    public void clear(){
        map.clear();
    }
     
    public Set<Entry<String, Object>> entrySet(){
        return map.entrySet();
    }
     
    public Set<String> keySet(){
        return map.keySet();
    }
     
    public boolean isEmpty(){
        return map.isEmpty();
    }
     
    public void putAll(Map<? extends String, ?extends Object> m){
        map.putAll(m);
    }
     
    public Map<String,Object> getMap(){
        return map;
    }
    
    
    public String getStr(String key){
    	return String.valueOf(map.get(key)).trim();
    }
    
    public String getStrNull(String key){
    	return CommonUtils.nullReplace(getStr(key), "");
    }
    
    public Integer getInt(String key){
    	return Integer.parseInt(getStr(key).replace(",", ""));
    }
    
    public Integer getIntNull(String key){
    	String strValue = getStrNull(key);
    	if (strValue.equals("")) {
    		return 0;
    	} else {
    		return getInt(key);
    	}
    }
    
    public Double getDouble(String key){
    	return Double.parseDouble(String.valueOf(map.get(key)).replace(",", ""));
    }

    public Double getDoubleNull(String key){
    	String strValue = getStrNull(key);
    	if (strValue.equals("")) {
    		return 0.0d;
    	} else {
    		return getDouble(key);
    	}
    }
    
    public String[] getStrArr(String key){
    	Object  value = map.get(key);
    	
    	if (value instanceof String[] ) {
			return (String[]) value;
		} else {
			String[] strArray = new String[] {value.toString()};
			return strArray;
		}
    }
    
    public Integer[] getIntArr(String key){
    	Object value = map.get(key);
    	
    	if (value instanceof Integer[] ) {
			return (Integer[]) value;
		} else {
			Integer[] intArray = new Integer[] {(Integer) value};
			return intArray;
		}
    }
    
    public Double[] getDoubleArr(String key){
    	Object value = map.get(key);
    	
    	if (value instanceof Integer[] ) {
			return (Double[]) value;
		} else {
			Double[] doubleArray = new Double[] {(Double) value};
			return doubleArray;
		}
    }
    
    
    
    
    
}