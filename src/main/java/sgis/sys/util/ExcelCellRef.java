package sgis.sys.util;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellValue;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.util.CellReference;

public class ExcelCellRef {
	 /**
	 * Cell에 해당하는 Column Name을 가젼온다(A,B,C..)
	 * 만약 Cell이 Null이라면 int cellIndex의 값으로
	 * Column Name을 가져온다.
	 * @param cell
	 * @param cellIndex
	 * @return
	 */
	public static String getName(Cell cell, int cellIndex) {
	    int cellNum = 0;
	    if(cell != null) cellNum = cell.getColumnIndex();
	    else cellNum = cellIndex;
	    
	    return CellReference.convertNumToColString(cellNum);
	}
	
	
	/**
	 * Cell의 값을 얻어온다
	 * formulaEval -> 엑셀 수식 읽기 위해 필요
	 * @param cell
	 * @param formulaEval
	 * @return
	 */
	public static String getValue(Cell cell, FormulaEvaluator formulaEval, String cellName) {
	   String value = "";
	   
	   //if(cell == null) value = "";
	    
	   //System.out.println("cell  ==>> " + cell + "    cellType>>  " + cell.getCellType());
	    
	   try{
		   if(cell == null || cell.getCellType() == Cell.CELL_TYPE_BLANK) {
			   value = "";
		   }else{
			   switch (cell.getCellType()) {
			   case Cell.CELL_TYPE_FORMULA:
				   //value = cell.getCellFormula();
				   /*CellValue evaluate = formulaEval.evaluate(cell);
		            	if( evaluate != null ) value = evaluate.formatAsString();*/

				   if(!cell.toString().equals("")){
					   if(formulaEval.evaluateFormulaCell(cell) == Cell.CELL_TYPE_NUMERIC){
						  /* 아래의 로직으로 처리 할 경우 "." 안됨
						   * Integer iVal = (int)cell.getNumericCellValue(); 
						  value = iVal.toString();*/
						   
						  /* cell.setCellType(Cell.CELL_TYPE_STRING);
						  value =cell.getStringCellValue();*/
						  
						  // 수주량 || 수주중량의 경우
						  if(cellName.equals("C") || cellName.equals("D")){
							  //". 소숫점 포함된 값을 뽑아내야한다."
							  cell.setCellType(Cell.CELL_TYPE_STRING);
							  value =cell.getStringCellValue();
							  
						  }else {
							  // 수주량 또는 수주량이 아닌경우 문자열 그대로 뽑아내야하기 때문에 아래의 값 사용
							  Integer iVal = (int)cell.getNumericCellValue(); 
							  value = iVal.toString();
							  
							  if(cellName.equals("A") || cellName.equals("B") || cellName.equals("E")){
								  //case : 푸드머스의 경우 5.7104E7 이런식의 값이 나올 때가 있음
								  if(value.contains(".")){
									  //위의 case 처럼 "."이 포함될 경우 여기서 String형으로 잡아준 뒤 Value값 셋팅
									  cell.setCellType(Cell.CELL_TYPE_STRING);
									  value =cell.getStringCellValue();
								  }
							  }
						  }
						  
					   }else if(formulaEval.evaluateFormulaCell(cell) ==Cell.CELL_TYPE_STRING){
						   value = cell.getStringCellValue();
					   }else if(formulaEval.evaluateFormulaCell(cell) == Cell.CELL_TYPE_BOOLEAN){
						   value = String.valueOf(cell.getBooleanCellValue());
					   }
				   }

				   break;
			   case Cell.CELL_TYPE_NUMERIC:
				   /*
				    *  Cell.CELL_TYPE_NUMERIC: 데이터 타입이 숫자인경우
				    * if (DateUtil.isCellDateFormatted(cell)) {
						    //날짜  
						    value = String.valueOf(cell.getDateCellValue());
						} else {
						    //수치  
						    value = String.valueOf(cell.getNumericCellValue());  
						}*/

				   /* 20190527 SGIS_TY
				    * CellType 이 숫자형이지만 소숫점처리를 하지 못해 읽어온 
				    * Cell 값 자체를 String형으로 변경 진행 
				    *Integer iVal = (int)cell.getNumericCellValue(); 
						value = iVal.toString();*/

				   cell.setCellType(Cell.CELL_TYPE_STRING);
				   value =cell.getStringCellValue();

				   break;
			   case Cell.CELL_TYPE_STRING:
				   //value= "STRING :::  " + cell.getStringCellValue()+"";
				   value = cell.getStringCellValue();
				   break;
			   case Cell.CELL_TYPE_BOOLEAN :
				   //value = cell.getBooleanCellValue() + "";
				   if(!cell.getBooleanCellValue()){
					   value = "";
				   }else{
					   value = cell.getBooleanCellValue() + "";
				   }
				   break;
			   case Cell.CELL_TYPE_BLANK:
				   //value= "CELL_TYPE_BLANK :::  " + cell.getBooleanCellValue()+"";
				   //value= cell.getBooleanCellValue()+"";
				   if(!cell.getBooleanCellValue()){
					   value = "";
				   }else{
					   value = cell.getBooleanCellValue() + "";
				   }
				   break;
			   case Cell.CELL_TYPE_ERROR:
				   value= cell.getErrorCellValue()+"";
				   break;
			   default:
				   value = cell.getStringCellValue();
				   break;
			   }
		   }
		   
	    }catch(NullPointerException e){
	    	//e.printStackTrace();
	    }
	    
	    return value;
	}
}
