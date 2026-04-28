/*계산식 적용 js*/
var jsReturnValue = true;

// '-' 문자 제거 
function gfn_dtReplace(obj){
	return obj.val().replace(/-/gi,"");
}
// 날짜 형태 YYYY-MM-DD 변환
function gfn_dtSubString(obj){
	return obj.val().substring(0,4)+"-"+obj.val().substring(4,6)+"-"+obj.val().substring(6,8);
}
// 돈에 ,를 추가해주는 함수 예) 1,000,000
function gfn_replaceAdd(num){
	var jsRegChar = /\B(?=(\d{3})+(?!\d))/g; // ,정규식
	var jsReplaceNum = num.toString().replace(jsRegChar,',');//,추가
	return jsReplaceNum;
}

/*
 * 계산 관련해서 체크박스 전체 체크시에
 * 각 단가들의 합이 총합계에 나타나는 함수
 * 전체 체크시 selectYn의 value=Y
 * 전체 해제시 selectYn의 value=N
 */
function fn_allCheck(){
	var jsSumAmount = $("input[name=W_SUMAMOUNT]"); // 합계금액
	var jsTotalAm = 0; // 총합계
	
	/*
	 * 전체 체크를 하는경우로
	 * 체크박스 전체 체크시 체크박스 체크
	 * selectYn의 value=Y변경
	 * 단가들로 반복문을 돌려서
	 * 해당 인덱스의 ,제거후 총합계에 더해줌
	 * gfn_replaceAdd함수이용하여 ,추가후 총합계에 출력
	 */
	if(jsCheckBox == "N") {
		$("input[name=selectItem]").prop("checked",true);
		jsCheckBox = "Y";
		
		//checkBox 삭제 Flag 값 업데이트
		$("input[name=selectYn]").val("Y");
		jsSumAmount.each(function(index){
			var unit = jsSumAmount.eq(index).val().replace(/,/gi,"");
			jsTotalAm += parseFloat(unit);
		});
		$("input[name=totalAm]").val(gfn_replaceAdd(jsTotalAm));
	} else {
		/*
		 * 전체 해제이므로 체크박스 해제
		 * selectYn의 value=N변경
		 * 총합계는 0으로 초기화 
		 */
		$("input[name=selectItem]").prop("checked",false);
		jsCheckBox = "N";
		
		//checkBox 삭제 Flag 값 업데이트
		$("input[name=selectYn]").val("N");
		$("input[name=totalAm]").val(0);
	}
}

/*
 * 계산 관련해서 체크박스 각각 체크시
 * 해당 단가들의 합이 총합계에 출력
 * 체크시 selectYn의 value=Y
 * 해제시 selectYn의 value=N
 */
function fn_setChkVal(chkBox, idx){
	var jsChkBoxId = "selectYn_"+idx // 체크박스인덱스
	var jsTotalAm = $("input[name=totalAm]").val().replace(/,/gi,""); // ,총합계 제거 
	var jsUnit = $("input[name=W_SUMAMOUNT]").eq(idx).val().replace(/,/gi,""); //,합계금액 제거
	
	/*
	 * 총합계의 유효성검사, 총합계가 0보다작을 경우 
	 * 총합계에 0을 치환
	 */
	if(gfn_isNull(jsTotalAm) || jsTotalAm <= 0 ){
		jsTotalAm = 0;
	}
	
	jsTotalAm = parseFloat(jsTotalAm); //실수로 형변환
	
	/*
	 * 체크박스 체크시 
	 * selectYn의 value=Y변경
	 * 합계금액을 형변환후 총합계에 더해줌
	 * gfn_replaceAdd함수이용하여 ,추가후 총합계 출력
	 */
	if(chkBox.checked == true ){
		$("#"+jsChkBoxId).val("Y");
		//체크시 총합계에 해당 값 추가
		jsTotalAm += parseFloat(jsUnit);
		$("input[name=totalAm]").val(gfn_replaceAdd(jsTotalAm)); //총합계
	}else {
		/*
		 * 체크박스 해제시 
		 * selectYn의 value=N변경
		 * 합계금액을 형변환후 총합계에 빼줌
		 * gfn_replaceAdd함수이용하여 ,추가후 총합계 출력
		 */
		$("#"+jsChkBoxId).val("N"); //체크해제된 상태
		//미체크시 총합계에 해당 값 삭제
		jsTotalAm -= parseFloat(jsUnit);
		$("input[name=totalAm]").val(gfn_replaceAdd(jsTotalAm)); //총합계
	}
}

// 오류메시지 알림,포커스
function alertFocus(obj){
//	obj.focus();
	jsReturnValue = false; 
}

/*
 * 수량 오류 알림
 * 수량오류시에 수량을 0으로 변경후 합계금액이랑 총합계를 변경해줌
*/
function alertQuanFocus(obj, idx){
	alertBox(obj.attr("title") + jsMsgAlertFocus); // 메시지
	obj.eq(idx).focus();
	obj.eq(idx).val(0); //수량 초기화
	
	if($("input[name=W_SUMAMOUNT]").length > 0){
		var fn_sum = $("input[name=W_SUMAMOUNT]").eq(idx).val().replace(/,/gi,""); // , 합계금액 제거
		var fn_total = $("input[name=totalAm]").val().replace(/,/gi,""); // ,총합계 제거
		var fn_new = fn_total - fn_sum; 

		$("input[name=W_SUMAMOUNT]").eq(idx).val(0); // 합계금액 초기화
		$("input[name=totalAm").val(gfn_replaceAdd(fn_new)); // 총합계
	}
}

//날짜유효성 검사
function fn_validDedt(obj){
	var jsRegexp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
	var jsDedt = gfn_dtReplace(obj);// 입력된 날짜에서 -리플레이스
	
	if(gfn_isNull(obj.val())){// 날짜 미입력
		alertBoxFocus(obj.attr("title") + jsMsgAlertFocus,obj);
		return false;
	}
	if(jsDedt.length == 8){// 납기일 길이가 8이여야함
		jsDedt = jsDedt.substring(0,4)+"-"+jsDedt.substring(4,6)+"-"+jsDedt.substring(6,8);//날짜 형태 2019-01-04
		if(!jsRegexp.test(jsDedt)){// 납기일 정규식에 벗어날 경우
			alertBoxFocus(obj.attr("title") + jsMsgAlertFocus,obj);
			return false;
		}else{// 납기일 정상입력되면 값입력
			obj.val(jsDedt);
			return true;
		}
	}else{
		alertBoxFocus(obj.attr("title") + jsMsgAlertFocus,obj);
		return false;
	}
}

// 선택한 품목을 저장, 주문시에 유효성 검사
function fn_inputValid(){
	var jsRegexp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; //(2018-11-29)
	var jsDeadLine = $("input[name=DEADLINE]"); // 최소납기일
	var jsItemValid;
	jsDeadLine = gfn_dtReplace(jsDeadLine);
	jsReturnValue = true;
	
	$("input[name=selectItem]").each(function(idx){
		var jsQuantity = $("input[name=W_QUANTITY]").eq(idx); //수량
		var jsItemDedt = $("input[name=itemDedt]").eq(idx); // 납기일
		
		if($("#selectYn_"+idx).val() == "Y"){// 체크된 품목인 경우
			if(Number(jsQuantity.val()) == 0){// 수량이 0개인 경우
				alertBoxFocus(jsQuantity.attr("title") + jsMsgAlertFocus, jsQuantity);
				jsReturnValue = false;
				return false;
			}
			jsItemValid = fn_validDedt(jsItemDedt);
			if(!jsItemValid){
				jsDeadLine = jsDeadLine.substring(0,4)+"-"+jsDeadLine.substring(4,6)+"-"+jsDeadLine.substring(6,8);//날짜 형태 2019-01-04
				jsItemDedt.val(jsDeadLine);
				jsReturnValue = false;
				return false;
			}
			var jsDedt = gfn_dtReplace(jsItemDedt);
			if(jsDedt < jsDeadLine){//납기일이 최소납기일 이전경우
				alertBoxFocus(jsItemDedt.attr("title") + jsMsgAlertFocus, jsItemDedt);
				jsReturnValue = false;
				return false;
			}
		}
	});
	return jsReturnValue;
}

/*			
< 단가계산 >			
- 부가세포함유무 = UPC_VATINCLSAT			
- 신단가  		 = UPC_NEWUNITPC	
- 수량 			 = W_QUANTITY
- 공급가액 		 = W_SPLPCAM
- 부가세 		 = W_VAT
- 합계금액 		 = W_SUMAMOUNT
			
1. 부가세포함유무 : 0			
	//수식 변경으로 기존 수식 더이상 사용 안함 (SGIS_TY 20190709)
	//공급가액 	: 신단가 * 수량	
	//부가세 		: 공급가액 * 0.1
	//합계금액 	: 공급가액 + 부가세
	
	//아래 수식 사용
	부가세 : 버림(단가 * 수량 * 0.1)
	수주공가 : 버림(단가 * 수량)
	합계금액 : 버림(단가 * 수량) + 버림(단가 * 수량 * 0.1)
	
2. 부가세포함유무 : 1
	//수식 변경으로 기존 수식 더이상 사용 안함 (SGIS_TY 20190709)
	//합계금액	: 신단가 * 수량	
	//공급가액	: (신단가 * 수량) - (합계금액 *0.1)	
	//부가세		: 합계금액 - 공급가액
	
	//아래 수식 사용
	부가세 : 버림(단가 * 수량 / 11)
	공급가액 : 버림(단가 * 수량) - 버림(단가 * 수량 / 11)
	합계금액 : 버림(단가 * 수량)
	
	
			
< 중량계산 >			
- 단가단위 : UPC_UNTPCUNIT
- 포장단위 : IC_PACKNGUNIT			
- 단위당수량 : IC_UNITQY			
- 수량 : W_QUANTITY			
- 중량 : W_WT			
			
1. 단가단위 : 1			
	중량 : 포장단위 * 단위당수량 * 수량		
2. 단가단위 : 2			
	중량 : 단위당수량 * 수량		
3. 단가단위 : 3			
	중량 : 수량		
*/
// 단가와 중량을 계산해주는 함수
function fn_unitPCCALC(idx){
	var jsRegNum=/^[0-9]*$/; //정수정규식
	
	var jsQuantity = $("input[name=W_QUANTITY]").eq(idx); //수량
	var jsNewUnitPC = $("input[name=UPC_NEWUNITPC]").eq(idx).val().replace(/,/gi,""); //신단가
	var jsVatIncl = $("input[name=UPC_VATINCLSAT]").eq(idx).val(); //부가세포함유무
	var jsUntPCUnit = $("input[name=UPC_UNTPCUNIT]").eq(idx).val(); //단가단위
	var jsUnitQY = $("input[name=IC_UNITQY]").eq(idx).val(); //단위당수량
	var jsPackNGUnit = $("input[name=IC_PACKNGUNIT]").eq(idx).val(); //포장단위
	var jsIcUnitWt = $("input[name=IC_UNITWT]").eq(idx).val();//단위중량
	
	var jsTotalAm = 0; //총합계
	var jsSplpCam; //공급가액
	var jsVat; //부가세
	var jsSumAmount; //합계금액
	var jsWt; //중량
	
	//단가 * 수량 정보 담을 변수
	var jsUnitPcXQy = "";
	
	if(gfn_isNull(jsQuantity.val())){// 수량유효성 검사 미입력경우
		alertBoxQuanFocus(jsQuantity.attr("title") + jsMsgAlertFocus, jsQuantity ,idx);
		return false;
	}else if(jsQuantity.val() < 0){// 수량이 0보다 작은 경우
		alertBoxQuanFocus(jsQuantity.attr("title") + jsMsgAlertFocus, jsQuantity, idx);
		return false;
	}else if(!jsRegNum.test(jsQuantity.val())){// 정수인지 유효성 검사
		if(jsUntPCUnit==3){
			/*
			 * 단가단위가 3인경우에만 단위중량의 단위배수로 입력
			 * 소수 입력가능
			 */
			if(jsQuantity.val()%jsIcUnitWt != 0){ // 단가중량의 배수인지 확인 
				alertBox("해당 단위중량은 "+jsIcUnitWt+"입니다. <br><br>해당 단위중량의 배수로 입력해주세요.");
				jsQuantity.focus();
				jsQuantity.val(0); //수량 초기화
				return false;
			}
		}else{
			alertBoxQuanFocus(jsQuantity.attr("title") + jsMsgAlertFocus, jsQuantity, idx); // 정수로 입력되어 있지 않은경우
			return false;
		}
	}
	
	/*
	 * 부가세포함유무 : 0
	 * 수주공가 : 버림(단가 * 수량)
	 * 부가세 : 버림(단가 * 수량 * 0.1)
	 * 합계금액 : 버림(단가 * 수량) + 버림(단가 * 수량 * 0.1)
	 */
	if(jsVatIncl == 0){		
		jsUnitPcXQy = jsQuantity.val() * jsNewUnitPC;
		jsSplpCam = Math.floor(jsUnitPcXQy);
		$("input[name=W_SPLPCAM]").eq(idx).val(jsSplpCam);
		jsVat = Math.floor(jsUnitPcXQy * 0.1);
		$("input[name=W_VAT]").eq(idx).val(jsVat);
		jsSumAmount = jsSplpCam + jsVat;
		$("input[name=W_SUMAMOUNT]").eq(idx).val(gfn_replaceAdd(jsSumAmount));
	}else{
		/*
		 * 부가세포함유무 : 1
		 * 부가세 : 버림(단가 * 수량 / 11)
		 * 공급가액 : 버림(단가 * 수량) - 버림(단가 * 수량 / 11)
		 * 합계금액 : 버림(단가 * 수량)
		 */
		jsUnitPcXQy = jsQuantity.val() * jsNewUnitPC;
		jsVat = Math.floor(jsUnitPcXQy / 11);
		$("input[name=W_VAT]").eq(idx).val(jsVat);
		jsSplpCam = Math.floor(jsUnitPcXQy) - jsVat;
		$("input[name=W_SPLPCAM]").eq(idx).val(jsSplpCam);		
		jsSumAmount = Math.floor(jsUnitPcXQy); 
		$("input[name=W_SUMAMOUNT]").eq(idx).val(gfn_replaceAdd(jsSumAmount));
		
	}
	
	//중량계산
	/*
	 * 단가단위 = 1
	 * 중량 = 포장단위 * 단위당수량 * 수량
	 */
	if(jsUntPCUnit == 1){
		jsWt = jsPackNGUnit * jsUnitQY * jsQuantity.val();
	}else if(jsUntPCUnit == 2){
		/*
		 * 단가단위 = 2
		 * 중량 = 단위당수량 * 수량
		 */
		jsWt = jsUnitQY * jsQuantity.val();
	}else if(jsUntPCUnit == 3){
		/*
		 * 단가단위 = 3
		 * 중량 = 수량
		 */
		jsWt = jsQuantity.val();
	}
	$("input[name=W_WT]").eq(idx).val(jsWt); //중량
	
	/*
	 * 단가 전체를 반복문을 돌려서 
	 * 체크박스에 체크된 부분의 단가를 리플레이스해서 ,제거
	 * 제거된 단가 총합계에 더해준다
	 * 더해준 총합계에 gfn_replaceAdd함수 사용하여 ,추가하여
	 * 총합계에 출력
	 */
	$("input[name=W_SUMAMOUNT]").each(function(index){
		if($("#selectYn_"+index).val() == "Y"){
			var sum = $("input[name=W_SUMAMOUNT]").eq(index).val().replace(/,/gi,"");
			jsTotalAm += parseFloat(sum);
		}
	});
	$("input[name=totalAm]").val(gfn_replaceAdd(jsTotalAm));
}







/**************************(사용자)************************************/
function fn_quanChk(obj, untPCUnit){
	var jsReturnVal;
	var jsWt; // 중량
	var row = $(obj).data("row"); //행 idx는 row로 사용 -> data-row
	var col = $(obj).data("col"); //열
	
	if(!gfn_isNull(row) && !gfn_isNull(col)){
		jsWt = $("#W_DCSNWT"+row+col);// 중량
	} else if(!gfn_isNull(row)){
		jsWt = $("input[name=W_WT]").eq(row);// 중량
	}
	
	if($(obj).data("admse") !=  'MN'){
		jsReturnVal = fn_qyValid($(obj), row, untPCUnit); // 수량 유효성,중량
	}
	if($("input[name=UPC_NEWUNITPC]").length > 0){ // 단가계산 하기위해 단가존재여부로 확인
		fn_sumAmount($(obj), row, untPCUnit);//합계금액
	}
	
	return jsReturnVal;
}

//수량유효성, 중량계산 
//2019.10.21 SGIS_KTY SIAS SCM팀 김정우사원 요청으로 거래처 중량의 경우 소수점 3자리까지 표시 되도록 변경 진행 및 반영
function fn_qyValid(obj, row, untPCUnit){//WT
	var jsReturnVal = true;
	var jsWt;// 중량
	var jsQy;// 수량
	var jsRegNum =/^[\d]*$/; //정수정규식
	var jsRegDecimals =/^[\d]*(\.?\d{2})$/; // 소수정규식
	var jsUnitWt = $("input[name=IC_UNITWT]").eq(row); //단위중량
	var jsUnitQY = $("input[name=IC_UNITQY]").eq(row); //단위당수량
	var jsPackNGUnit = $("input[name=IC_PACKNGUNIT]").eq(row); //포장단위
	var jsGrpQy = $("input[name=W_GRP_QY]").eq(row); //그룹수량
	var jsPiectQy = $("input[name=W_PIECE_QY]").eq(row); //낱개수량
	obj.val(obj.val().replace(/,/gi,""));
	
	if(gfn_isNull(obj.val())){
		alertBoxFocus(obj.attr("title")+jsMsgAlertFocus, obj);
		obj.val(0);
		$("input[name=W_QUANTITY]").eq(row).val(0);
		$("input[name=W_WT]").eq(row).val(0);
		jsGrpQy.val(0);
		jsPiectQy.val(0);
		jsReturnVal = false;
	}
	
	if(Number(obj.val()) > 100000){// 중량 추가이므로 제거할수도 있음
		alertBoxFocus(obj.attr("title")+jsMsgAlertFocus, obj);
		obj.val(0);
		$("input[name=W_QUANTITY]").eq(row).val(0);
		$("input[name=W_WT]").eq(row).val(0);
		jsGrpQy.val(0);
		jsPiectQy.val(0);
		jsReturnVal = false;
	}
	/*if(obj.val().charAt(0) == "."){ 
		alertBoxFocus(jsMsgDecimalsError, obj);
		obj.val(0);
		$("input[name=W_QUANTITY]").eq(row).val(0);
		$("input[name=W_WT]").eq(row).val(0);
		jsGrpQy.val(0);
		jsPiectQy.val(0);
		jsReturnVal = false;
	}*/
	if(jsRegDecimals.test(obj.val()) || jsRegNum.test(obj.val())){// 참일경우 
		if(untPCUnit == 3){
			// ** 19.10.21 변경 진행
			var jsFixNum = (obj.val()/jsUnitWt.val()).toFixed(3);
			// ** 19.10.21 변경 진행
			if(jsFixNum.substring(jsFixNum.indexOf(".")) == ".000"){
				jsReturnVal = true;
			}else{// 단위중량의 배수가 아니므로 단위중량 알려준다
				alertBoxFocus("해당 단위중량은 "+jsUnitWt.val()+"입니다. <br><br>해당 단위중량의 배수로 입력해주세요.", obj);
				obj.val(0);
				$("input[name=W_QUANTITY]").eq(row).val(0);
				$("input[name=W_WT]").eq(row).val(0);
				jsGrpQy.val(0);
				jsPiectQy.val(0);
				jsReturnVal = false;
			}
		}
	}else{// 정규식 오류
		alertBoxFocus(obj.attr("title")+jsMsgAlertFocus,obj);
		obj.val(0);
		$("input[name=W_QUANTITY]").eq(row).val(0);
		$("input[name=W_WT]").eq(row).val(0);
		jsGrpQy.val(0);
		jsPiectQy.val(0);
		jsReturnVal = false;
	}
	
	//중량계산
	if(jsReturnVal){ //returnValue로 확인하여 중량계산
		if(untPCUnit == 1){//BOX경우
			jsQy = obj.val(); //수량
			// ** 19.10.21 변경 진행
			jsWt = (jsPackNGUnit.val() * jsUnitQY.val() * obj.val()).toFixed(3); //중량
			jsGrpQy.val(obj.val());// 그룹수량
			jsPiectQy.val((jsPackNGUnit.val()*obj.val()).toFixed(1));// 낱개수량
		}else if(untPCUnit == 2){
			//jsQy = obj.val(); //수량
			// ** 19.10.21 변경 진행
			jsWt = (jsUnitQY.val() * obj.val()).toFixed(3); //중량
			jsGrpQy.val(jsQy);// 그룹수량
			jsPiectQy.val(obj.val());// 낱개수량
		}else{
			// ** 19.10.21 변경 진행
			jsQy = (obj.val()/(jsPackNGUnit.val()*jsUnitQY.val())).toFixed(3);//수량
			jsWt = obj.val();//중량
			jsGrpQy.val(jsQy);// 그룹수량
			jsPiectQy.val((obj.val()/jsUnitQY.val()).toFixed(1));// 낱개수량
		}
		
		if(obj.data("fcs") == "QY"){
			obj.val(gfn_replaceAdd(obj.val())); //수량
			if(jsWt.substring(jsWt.indexOf(".")) == ".0"){
				$("input[name=W_WT]").eq(row).val(gfn_replaceAdd(jsWt.substring(0, jsWt.indexOf(".")))); //중량
			}else{
				$("input[name=W_WT]").eq(row).val(gfn_replaceAdd(jsWt)); //중량
			}
		}else{
			obj.val(gfn_replaceAdd(obj.val())); //중량
			if(jsQy.substring(jsQy.indexOf(".")) == ".0"){
				$("input[name=W_QUANTITY]").eq(row).val(gfn_replaceAdd(jsQy.substring(0, jsQy.indexOf(".")))); //중량
			}else{
				$("input[name=W_QUANTITY]").eq(row).val(gfn_replaceAdd(jsQy)); //수량	
			}
		}
	}
	//합계중량
	var qySm = 0;
	var jsIvColor = $("input[name=IV_COLOR]"); //재고상태 색상값
	$("input[name=W_QUANTITY]").each(function(index){
		if(jsIvColor.eq(index).val() == "G"){
			qySm += parseFloat($("input[name=W_WT]").eq(index).val().replace(/,/gi,""));//중량
			if($("input[name=W_DEDT]").eq(index).val() == $("#AM_W_DEDT"+index).val()){ // input태그 id값 사용
				$("#qySm"+index).val(gfn_replaceAdd(qySm));
				qySm = 0;
			}
		}
	});
	
	return jsReturnVal;
}

//합계금액 
function fn_sumAmount(obj, row, untPCUnit){
	var jsChgNum; //변환
	var jsNewUnitPC = $("input[name=UPC_NEWUNITPC]").eq(row).val().replace(/,/gi,""); //신단가
	var jsVatIncl = $("input[name=UPC_VATINCLSAT]").eq(row).val(); //부가세포함유무
	var jsUntPCUnit = $("input[name=UPC_UNTPCUNIT]").eq(row).val();// 단가단위
	var jsUnitQY = $("input[name=IC_UNITQY]").eq(row); //단위당수량
	var jsPackNGUnit = $("input[name=IC_PACKNGUNIT]").eq(row); //포장단위
	
	var jsSplpCam; //공급가액
	var jsVat; //부가세
	var jsSumAmount; //합계금액	
	obj.val(obj.val().replace(/,/gi,""));
	
	//단가 * 수량 정보 담을 변수
	var jsUnitPcXQy = "";
	
	//단가단위에대한 수량 
	if(untPCUnit == 1){//수량(BOX) 등록 경우
		if(jsUntPCUnit == 1){// BOX경우
			jsChgNum = obj.val();
		}else if(jsUntPCUnit == 2){// ea경우
			jsChgNum = obj.val()*jsPackNGUnit.val();
		}else{// kg경우
			jsChgNum = obj.val()*jsPackNGUnit.val()*jsUnitQY.val();
		}
	}else{// 중량(KG) 등록경우
		if(jsUntPCUnit == 1){// BOX경우
			jsChgNum = (obj.val()/jsPackNGUnit.val()/jsUnitQY.val()).toFixed(1);
		}else if(jsUntPCUnit == 2){// ea경우
			jsChgNum = (obj.val()/jsUnitQY.val()).toFixed(1);
		}else{// kg경우
			jsChgNum = obj.val();
		}
	}
	
	/*
	 * 부가세포함유무 : 0
	 * 수주공가 : 버림(단가 * 수량)
	 * 부가세 : 버림(단가 * 수량 * 0.1)
	 * 합계금액 : 버림(단가 * 수량) + 버림(단가 * 수량 * 0.1)
	 */
	if(jsVatIncl == 0){		
		jsUnitPcXQy = jsChgNum * jsNewUnitPC;
		jsSplpCam = Math.floor(jsUnitPcXQy);
		$("input[name=W_SPLPCAM]").eq(row).val(jsSplpCam);
		jsVat = Math.floor(jsUnitPcXQy * 0.1);
		$("input[name=W_VAT]").eq(row).val(jsVat);
		jsSumAmount = jsSplpCam + jsVat;
		$("input[name=W_SUMAMOUNT]").eq(row).val(gfn_replaceAdd(jsSumAmount));
		
	}else{
		/*
		 * 부가세포함유무 : 1
		 * 부가세 : 버림(단가 * 수량 / 11)
		 * 공급가액 : 버림(단가 * 수량) - 버림(단가 * 수량 / 11)
		 * 합계금액 : 버림(단가 * 수량)
		 */
		jsUnitPcXQy = jsChgNum * jsNewUnitPC;
		jsVat = Math.floor(jsUnitPcXQy / 11);
		$("input[name=W_VAT]").eq(row).val(jsVat);
		jsSplpCam = Math.floor(jsUnitPcXQy) - jsVat;
		$("input[name=W_SPLPCAM]").eq(row).val(jsSplpCam);
		jsSumAmount = Math.floor(jsUnitPcXQy);
		$("input[name=W_SUMAMOUNT]").eq(row).val(gfn_replaceAdd(jsSumAmount));
		
	}
	
	/*
	 * 단가 전체를 반복문을 돌려서 
	 * 체크박스에 체크된 부분의 단가를 리플레이스해서 ,제거
	 * 제거된 단가 총합계에 더해준다
	 * 더해준 총합계에 gfn_replaceAdd함수 사용하여 ,추가하여
	 * 총합계에 출력
	 */
	var am = 0;
	$("input[name=W_SUMAMOUNT]").each(function(index){
		am += parseInt($("input[name=W_SUMAMOUNT]").eq(index).val().replace(/,/gi,""));
		if($("input[name=W_DEDT]").eq(index).val() == $("#AM_W_DEDT"+index).val()){ // input태그 id값 사용
			$("#am"+index).val(gfn_replaceAdd(Math.floor(am)));
			am = 0;
		}
	});
	//$("input[name=W_QUANTITY]").eq(row).val(gfn_replaceAdd(QY.val()))
	obj.val(gfn_replaceAdd(obj.val()));
	$("input[name=W_SUMAMOUNT]").eq(row).val(gfn_replaceAdd(jsSumAmount));
}
/**************************(사용자)************************************/
