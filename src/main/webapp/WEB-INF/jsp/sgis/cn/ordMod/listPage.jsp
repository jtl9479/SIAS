<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html>
<html> -->
	<head>
		<script type="text/javascript">
			var jsMsg = "<spring:message code='alert.alertFocus'/>";
			var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
			var jsMsgDecimalsError = "<spring:message code='alert.decimalsError'/>";
			var jsListUrl = "list.do",
				jsPageUrl = "page.do";
			var jsMinSearchDtFrom,
				jsMaxSearchDtTo;
			
			var jsCheckBox = "N";
			
			//해당 납기일이 아닌데  확정을 할 경우 (Y:유효하지 않은 납기일자, N:정상납기일자)
			var jsDedtChk = "N";
			
			//선택제품 확정 버튼 클릭시 납기일자가 변경된 내용이 있는경우 값 지정 ("":Default, "CHG":변경)
			var jsChgDedt = "";
			
			$(document).ready(function(){
				$("input[name=pg]").val(1);
				fn_listMore();
				fn_pageInit();
				fn_indictLmtt();
				
				// 납기일자 변경시 재고상태가져오는 event 
				$(document).on("change", "[data-sttus = DEDT]", function(e) {
					e.preventDefault();
					fn_changeOrdInfo(this);
				});
				
				//keyup으로 재고상태 
				$(document).on("keyup", "input", function(e) {
					e.preventDefault();
					if(e.keyCode == 13){
						$(this).focus();
					}
				});
				
				// 조회
				$("#searchBtn").on("click", function(e) {   
					e.preventDefault();
					var jsDtFrom = gfn_dtReplace($("input[name=searchDtFrom]")),
						jsDtTo = gfn_dtReplace($("input[name=searchDtTo]"));
					
					if (!gfn_isNull(jsDtFrom) && !gfn_isNull(jsDtTo)) {
						if (jsDtFrom > jsDtTo) {
							alertBoxFocus("<spring:message code='alert.searchDtError'/>", $("input[name=searchDtFrom]")); return;
						} 
					}
					if ( (!gfn_isNull(jsDtFrom) &&  gfn_isNull(jsDtTo)) ||  
						 ( gfn_isNull(jsDtFrom) && !gfn_isNull(jsDtTo)) ) {
						alertBoxFocus("<spring:message code='title.itemDt'/>"+"를 다시 확인해주세요.", $("input[name=searchDtFrom]")); return;
					}
					
					fn_searchList();
				});
				
			});
			
			//수량입력시 재고상태 조회 후 그룹중량합계 계산 진행
			function fn_quanChange(obj, se){ 
				fn_quanChk(obj,se);
				fn_changeOrdInfo(obj);
			}
			
			function fn_pageInit(){
				fn_dateInit();
				fn_ivsInit();
				
				//switching tabs datepicker trouble Shooting
				$("._datepick").datepicker();
			}
			
			// 체크박스 전체 선택 공통화로 진행할 function
			function fn_allChkBox(chkBoxNm){
				var jsChkBoxNm = $("input[name='"+chkBoxNm+"']");
				
				if(jsCheckBox == "N") {
					$(jsChkBoxNm).prop("checked",true);
					jsCheckBox = "Y";
					
					if(chkBoxNm == 'selectItem'){
						$("input[name=selectYn]").val("Y");						
					}else{
						jsChkBoxNm.val("Y");
					}
					
				} else {
					$(jsChkBoxNm).prop("checked",false);
					jsCheckBox = "N";
					
					if(chkBoxNm == 'selectItem'){
						$("input[name=selectYn]").val("N");						
					}else{
						jsChkBoxNm.val("N");
					}
				}
				
			}
			
			// 조회
			function fn_searchList(){
				//$("input[name=ALOCENTRPS]").val("");
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			// 목록(더보기)
			function fn_listMore(){
				var pg = Number($("input[name=pg]").val());
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			// List CallBack
			function fn_listCallBack(data){
				$("#listBody").html(data).trigger("create");
				
				$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
				
				if($("#firstLoadAt").val() == 'Y'){
					$("#listBody").find("table > tbody > tr > td.UcFirstRow > input:checkbox[name=selectItem]").prop("checked",false);
				}
				
				fn_tabAddOn();
				
				if(jsChgDedt == 'CHG'){
					var jsMinQyAt="";
					jsMinQyAt = fn_minimumQyChk();
					//최소 주문량 체크 
					if(jsMinQyAt){
						jsChgDedt="";
						fn_dcsnYFnc();
					}
				}
				
			}
			
			//해당업체 클래스on추가
			function fn_tabAddOn(){
				var jsAlocEntrps = $("input[name=ALOCENTRPS]").val();
				
				$("input[name=H_ALOCENTRPS]").each(function(idx){
					if(gfn_isNull(jsAlocEntrps)){
						$(".dlvyList").parent().eq(0).addClass("on");
					}else if($("input[name=H_ALOCENTRPS]").eq(idx).val() == jsAlocEntrps){
						$(".dlvyList").parent().eq(idx).addClass("on");
					}
				});
				
				fn_pageInit();
				fn_indictLmtt();
			}
			
			//도착지 업체
			function fn_dlvyList(idx){
				var jsFrm = $("#listFrm");
				var jsAlocEntrps = $(jsFrm).find("input[name=H_ALOCENTRPS]").eq(idx).val();
				$("#searchFrm").find("input[name=ALOCENTRPS]").val(jsAlocEntrps);
				
				//탭 이동할 때 마다 searchForm의 첫 페이지 로드 값 초기화
				$("#firstLoadAt").val("Y");
				
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			// 검색 조건 및 납기일자 선택 조건 제한
			function fn_dateInit(){
				jsMinSearchDtFrom = $("input[name=searchDtFrom]").val(); 
				jsMaxSearchDtTo = $("input[name=searchDtTo]").val();
				
				$("._datepick").datepicker({beforeShowDay: fn_deadLine});
				$("._datepick").datepicker("option", "minDate", jsMinSearchDtFrom);
				$("._datepick").datepicker("option", "maxDate", jsMaxSearchDtTo);
				//$("input[name=W_DEDT]").datepicker("option", "minDate", 0); // 납기일자 오늘날짜이전 비활성화
				//$("input[name=AM_W_DEDT]").datepicker("option", "minDate", 0);// 납기일자 오늘날짜이전 비활성화
				//$("input[name=W_DEDT]").datepicker("option", "minDate", jsMinSearchDtFrom); // 납기일자 오늘날짜이전 비활성화
				//$("input[name=AM_W_DEDT]").datepicker("option", "minDate", jsMinSearchDtFrom);// 납기일자 오늘날짜이전 비활성화
				
				//선택 checkbox의 data 속성 추가(그룹합계 계산용)
				var jsAmWdedtRow = "";
				$("input[name=AM_W_DEDT]").each(function (i){
					jsAmWdedtRow = $("input[name=AM_W_DEDT]").eq(i).data("amrow");
					$("input:checkbox[name=selectItem]").eq(i).attr("data-amrow", jsAmWdedtRow);
				})
				
			}
			
			//deadLine설정
			function fn_deadLine(date){
				var jsGetDay = date.getDay() != 0 && date.getDay() != 6;
				var jsValid = true;
				if($("input[name=dlvyDeCeck]").val() == "Y"){
					if($("#dlvyDay0"+date.getDay()).val() == "N"){
						if(!jsValid){
							jsGetDay += jsGetDay && (date.getDay() != date.getDay());
						}else{
							jsGetDay = date.getDay() != date.getDay();
						}
					}
				}else{
					return [jsGetDay];
				}
				return [jsGetDay];
			}
			
			//검색납기일 유효성
			function fn_searchItemDedt(){
				var jsWeekAgo = $("input[name=weekAgo]");
				var jsCurDedt = $("input[name=curDedt]");
				var jsDtFrom = fn_validDedt($("input[name=searchDtFrom]"));
				var jsDtTo = fn_validDedt($("input[name=searchDtTo]"));
				
				if(!jsDtFrom){
					$("input[name=searchDtFrom]").val(gfn_dtSubString(jsWeekAgo));
				}else{
					if(gfn_dtReplace($("input[name=searchDtFrom]")) < jsWeekAgo.val()){// 시작일이 min시작일보다 작은경우
						$("input[name=searchDtFrom]").val(gfn_dtSubString(jsWeekAgo));
					}else if(gfn_dtReplace($("input[name=searchDtFrom]")) > jsCurDedt.val()){// 시작일이 max종료일보다 큰경우
						$("input[name=searchDtFrom]").val(gfn_dtSubString(jsWeekAgo));
					}
				}
				if(!jsDtTo){
					$("input[name=searchDtTo]").val(gfn_dtSubString(jsCurDedt));
				}else{
					if(gfn_dtReplace($("input[name=searchDtTo]")) > jsCurDedt.val()){// 종료일이 max종료일보다 큰경우
						$("input[name=searchDtTo]").val(gfn_dtSubString(jsCurDedt));
					}else if(gfn_dtReplace($("input[name=searchDtTo]")) < jsWeekAgo.val()){// 종료일이 min시작일보다 작은경우
						$("input[name=searchDtTo]").val(gfn_dtSubString(jsCurDedt));
					}
				}
			}
			
			// 납기일자 체크
			function fn_itemDedt(obj, idx){
				var jsDeadLine = $("input[name=DEADLINE]");//최소납기일자
				//var jsItemDedt = $("input[name=W_DEDT]").eq(idx);
				var jsItemDedt = "";//납기일자
				
				//그룹합계 납기일자일경우
				if($(obj).attr("name") != "W_DEDT"){
					jsItemDedt = $(obj);
				}else{
					jsItemDedt = $("input[name=W_DEDT]").eq(idx);
				}
				
				var validChk = fn_validDedt(jsItemDedt);
				var jsAlertDay = "";
				
				if(!validChk){
					$("input[name=W_DEDT]").eq(idx).val(jsItemDedt.data("dedt"));
					return false;
				}else{
					if(gfn_dtReplace(jsItemDedt) < gfn_dtReplace(jsDeadLine)){// 납기일자가 최소납기일자 이전경우
						alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", $(jsItemDedt))
						
						//$("input[name=W_DEDT]").eq(idx).val(jsDeadLine.val());
						$(jsItemDedt).val(jsItemDedt.data("dedt"));
						return false;
					}else if(gfn_dtReplace(jsItemDedt) > $("input[name=maxItemDedt]").val()){
						alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", $(jsItemDedt))
						
						$(jsItemDedt).val(jsItemDedt.data("dedt"));
						return false;
					}
					var jsHolidayValid = true;
					//공휴일 확인
					$("input[name=CLDR_DEDT]").each(function(idx){
						jsHoliday = $("input[name=CLDR_DEDT]").eq(idx).val();
						if(gfn_dtReplace(jsItemDedt) == jsHoliday){
							jsHolidayValid = false;
						}
					});
					if(!jsHolidayValid){
						alertBoxFocus("배송휴무일 입니다.", $(jsItemDedt));
						$(jsItemDedt).val(jsItemDedt.data("dedt"));
						return false;
					}
					var jsGetDay = new Date(jsItemDedt.val()).getDay();//요일값
					if(jsGetDay == "0" || jsGetDay == "6"){
						alertBoxFocus("배송휴무일 입니다.", $(jsItemDedt));
						$(jsItemDedt).val(jsItemDedt.data("dedt"));
						return false;
					}
					
					if(typeof fn_itemDlvyDay =='function'){//함수 존재여부
						//그룹합계 행일 경우
						if(jsItemDedt.attr("name") != "W_DEDT"){
							jsAlertDay = fn_itemGrpDlvyDay(idx);
						}else{
							//일반 행일 경우
							jsAlertDay = fn_itemDlvyDay(idx);
						}
					
						if(!gfn_isNull(jsAlertDay)){ //공백이 아닐경우
							alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, $(jsItemDedt));
							jsDedtChk = "Y";
							$("input[name=W_DEDT]").eq(idx).attr("data-dedtchk","Y")
							return false;
						}else {
							jsDedtChk = "N";
							$("input[name=W_DEDT]").eq(idx).attr("data-dedtchk","N")
						}
					}
				}
				return true;
			}
			
			//배송요일체크
			function fn_itemDlvyDay(idx){
				var jsWdedt = $("input[name=W_DEDT]").eq(idx);
				var jsOriginDedt = $(jsWdedt).data("dedt");
				var jsGetDay = new Date($(jsWdedt).val()).getDay();//요일값
				var jsAlertDay = "";//배송요일 alert변수
				
				idx=0;
				
				if($("#dlvyDeCeck_"+idx).val() == "Y"){
					if($("#dlvyDay"+idx+""+jsGetDay).val() != "Y"){// 배송요일 확인
						jsAlertDay = "배송요일은 ";
						for(var cnt=1; cnt<7; cnt++){
							if($("#dlvyDay"+idx+""+cnt).val() == "Y"){
								jsAlertDay += $("#dlvyDay"+idx+""+cnt).attr("title")+", ";//배송요일 title가져오기
							}
						}
						jsAlertDay = jsAlertDay.substr(0, jsAlertDay.length-2);
						//$(jsWdedt).val(jsOriginDedt);
						return jsAlertDay;
					}
				}
				
				return jsAlertDay;//리턴값 메시지
			}
			
			//배송요일체크 (그룹합계)
			function fn_itemGrpDlvyDay(idx){
				var jsWdedt =  $("#AM_W_DEDT"+idx);
				var jsOriginDedt = $(jsWdedt).data("dedt");
				var jsGetDay = new Date($(jsWdedt).val()).getDay();//요일값
				var jsAlertDay = "";//배송요일 alert변수
				
				idx=0;
				if($("#dlvyDeCeck_"+idx).val() == "Y"){
					if($("#dlvyDay"+idx+""+jsGetDay).val() != "Y"){// 배송요일 확인
						jsAlertDay = "배송요일은 ";
						for(var cnt=1; cnt<7; cnt++){
							if($("#dlvyDay"+idx+""+cnt).val() == "Y"){
								jsAlertDay += $("#dlvyDay"+idx+""+cnt).attr("title")+", ";//배송요일 title가져오기
							}
						}
						jsAlertDay = jsAlertDay.substr(0, jsAlertDay.length-2);
						return jsAlertDay;
					}
				}
				
				return jsAlertDay;//리턴값 메시지
			}
			
			// 납기일자, 수량 상태 변경 정보
			function fn_changeOrdInfo(obj){
				var jsObjNm = $(obj).attr("name");
				//납기 일자가 변경된 경우
				if(jsObjNm == "W_DEDT"){
					if(fn_validDedt($(obj))){
						var jsTr = $(obj).parents().parents().parents();
						var jsRow = $(jsTr).data("rowno");
						
						if(fn_itemDedt($(obj), jsRow)){
							//재고상태 조회
							fn_invntrySttus(obj);	
						}
					}else{
						$(obj).val($(obj).data("dedt"));
					}
				}
			
				//수량이 변경된 경우	
				if(jsObjNm == "W_QUANTITY"){
					if(Number($(obj).val().replace(/,/gi,"")) > 0){
						//재고상태 조회
						fn_invntrySttus(obj);
					}else {
						//새로 입력한 값이 0보다 작을경우 공백처리
						$("input[name=I_STTUS]").val("공백");
					} 
				}
				
			}
			
			// 재고 상태 조회
			function fn_invntrySttus(obj){
				var jsTr = $(obj).parents().parents().parents();
				//재고상태 변경 할 tr의 행 번호
				var jsRow  = $(jsTr).data("rowno");
				var jsDedt, jsIcCode, jsInqireSe, jsDe, jsSn, jsWunitBplc;
				
				jsDedt  = $("input[name=W_DEDT]").eq(jsRow).val(); //납기일자
				jsIcCode = $("input[name=IC_CODE]").eq(jsRow).val(); //품목코드				
				jsInqireSe  = 'B' //조회구분
				jsDe  = $("input[name=W_DE]").eq(jsRow).val(); //일자
				jsSn = $("input[name=W_SN]").eq(jsRow).val(); //일련번호
				jsWunitBplc  = $("input[name=W_UNIT_BPLC]").eq(jsRow).val(); //단가단위사업장
				jsWt = $("input[name=W_WT]").eq(jsRow).val(); //중량
				
				var data = {};
				data.W_DEDT = jsDedt.replace(/-/gi, "");
				data.IC_CODE = jsIcCode;
				data.INQIRE_SE = jsInqireSe;
				data.W_DE = jsDe;
				data.W_SN = jsSn;
				data.W_UNIT_BPLC = jsWunitBplc;
				data.ROW = jsRow;
				data.W_WT = jsWt.replace(/,/gi, "");
				
				comAjax('', '/ordMod/invntrySttus.do', data, fn_invntrySttusCallBack);
			}
			
			// 재고 상태 조회 CallBack
			function fn_invntrySttusCallBack(data){
				//data에 해당하는 index에 set value 해줘야함.
				var jsColor;
				var jsIsttus = $("#listBody").find("table > tbody > tr.UcItemRow").eq(data.row).find(".i_sttus > span");
				var jsIvColor = $("#listBody").find("table > tbody > tr.UcItemRow").eq(data.row).find(".i_sttus > input[name=IV_COLOR]");
				var jsReturunIv = Math.floor(data.invntryWt)+"("+gfn_replaceAdd(data.orgInvntryWt)+")";
				jsIsttus.removeClass();
				jsIsttus.html("");
				
				switch(data.color){
					case "R" : 
						jsColor="status_red";
						break;
					case "G" : 
						jsColor="status_green";
						jsIsttus.html(jsReturunIv);
						break;
					case "Y" : 
						//var jsReturunIv = Math.floor(data.invntryWt)+"("+gfn_replaceAdd(data.orgInvntryWt)+")";
						jsColor="status_yellow";
						//jsIsttus.html(Math.floor(data.invntryWt));
						jsIsttus.html(jsReturunIv);
						break;
				}
				jsIsttus.addClass(jsColor);
				jsIvColor.val(data.color);
				
				// 그룹중량합계 재계산
				if($("input[name=qySm]").length > 0){
					if(typeof fn_indictLmtt =='function'){
						fn_indictLmtt();
					}
				}
			}
			
			//재고상태 색이 "Red" 일 경우 중량합계에 계산을 포함하지 않는다.
			function fn_indictLmtt(){
				var jsFrm =$("#listFrm"); 
				var jsUcItemTr = $(jsFrm).find("table > tbody >tr.UcItemRow");
				var jsAmRow = $(jsFrm).find("table > tbody > tr.UcAmountRow");
				var jsIvColor = $("input[name=IV_COLOR]"); //재고상태 색상값
				var jsMinimumQyObj = $("input[name=minimumQy]"); //최소 주문량
				var qySm = 0;
				
				//jsBdate="이전일", jsCdate="현재일"
				var jsBdate="", jsCdate="";
				
				$(jsUcItemTr).each(function(index){
					//첫번째 행에서는 Bdate와 Cdate에 동일한 값을 부여한다.
					if(index == 0) jsBdate = $("input[name=W_DEDT]").eq(index).val();
					jsCdate = $("input[name=W_DEDT]").eq(index).val();					
					
					//날짜변경시에는 그룹중량합계에 값 설정
					if(jsBdate != jsCdate){
						$("#qySm"+(index-1)).val(gfn_replaceAdd(qySm));
						qySm = 0;
						jsBdate = jsCdate;
					}
					
					//재고상태가 녹생인 경우에만 중량합계 누적계산
					if(jsIvColor.eq(index).val() == "G"){
						qySm += parseFloat($("input[name=W_WT]").eq(index).val().replace(/,/gi,""));
					}
					
					//마지막 행일 경우 index 번호 그대로 값 설정
					if(index == ($(jsUcItemTr).length -1)){
						$("#qySm"+index).val(gfn_replaceAdd(qySm.toFixed(3)));	
					}
					
				});
				
				//오늘 날짜
				var jsDate = new Date(); 
				var jsNewDate = new Date(jsDate); 
				jsNewDate.setDate(jsNewDate.getDate()); 
				var jsNowDate = new Date(jsNewDate).toISOString().split("T")[0].replace(/-/gi, "");
				
				//이전납기일자가 오늘날짜보다 작을때 변경한경우 yesBox메시지
				var data = {};
				$("input[name=W_DEDT]").each(function(index){
					if($("input[name=W_DEDT]").eq(index).val() != $("input[name=W_DEDT]").eq(index).data("olddedt")){
						if($("input[name=W_DEDT]").eq(index).val().replace(/-/gi, "") > jsNowDate
								&& $("input[name=W_DEDT]").eq(index).data("olddedt").replace(/-/gi, "") < jsNowDate){
							var jsMsg = "이전납기일자를 변경하시겠습니까?";
							
							data.originDedt = $("input[name=W_DEDT]").eq(index).data("olddedt");
							data.dedt = $("input[name=W_DEDT]").eq(index).val();
							data.amDedtId = $("input[name=W_DEDT]").eq(index).attr("id");
							data.index = index;
							data.name = $("input[name=W_DEDT]").attr("name");
							
							yesBox(jsMsg, fn_dateYFnc, fn_dateNFnc, data);
						}
					}
				});
				
				//그룹합계 행 체크
				$(jsAmRow).each(function(idx){
					var jsQySmObj  = $(jsAmRow).eq(idx).find("input[name=qySm]");
					/*  //그룹합계 중량이 0일경우 금액 초기화 필요할지 몰라서 일단 넣어둠
					if($(jsAmRow).eq(idx).find("td > input[name=qySm]").val() == 0){
						$(jsAmRow).eq(idx).find("td > input[name=am]").val(0);
					} */
					
					//로그인한 업체의 최소주문량 css 설정
					if(Number(jsMinimumQyObj.val().replace(/,/gi,"")) >= 0){
						if(Number(jsMinimumQyObj.val().replace(/,/gi,"")) > Number(jsQySmObj.val().replace(/,/gi,""))){
							jsQySmObj.css("color","red");
						}else{
							jsQySmObj.css("color","black");
						}
					}
					
					if($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("span > input[name=AM_W_DEDT]").val().replace(/-/gi, "") < jsNowDate){
						fn_findDedt($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("span > input[name=AM_W_DEDT]").val());
					}
				});
				
			}
			
			//재고상태가 수량(재고중량) display
			function fn_ivsInit(){
				var jsFrm =$("#listFrm"); 
				var jsUcItemRow = $(jsFrm).find("table > tbody >tr.UcItemRow");
				var jsIvColor="", jsIclass=""; 
				
				$(jsUcItemRow).each(function(idx){
					jsIclass = $(jsUcItemRow).find("td.left > div.product_name").eq(idx).find("i").attr("class");
					jsIvColor = $(jsUcItemRow).eq(idx).find(".i_sttus > input[name=IV_COLOR]").val();
					
					//재고상태가 녹색이어도 수량(재고중량) 표시
					if(jsIvColor == 'G'){
						if(jsIclass != 'undefined'){
							if(jsIclass == 'common'){
								$(jsUcItemRow).eq(idx).find(".i_sttus > span").html($("input[name=IV_COMBINE]").eq(idx).val());
							}
						}
					}
					
				});
			}
			
			//표시 제한할 재고상태 체크
			function fn_findDedt(dedtDate){
				var jsFrm =$("#listFrm"); 
				var jsUcItemRow = $(jsFrm).find("table > tbody >tr.UcItemRow");
				
				$(jsUcItemRow).each(function(idx){
					if($(jsUcItemRow).find("td.i_sttus").eq(idx).data("dedt") == dedtDate){
						$(jsUcItemRow).find("td.i_sttus").eq(idx).find("span").removeClass();
					}
				});
			}
			
			// 납기일자 일괄 선택
			function fn_setDate(obj, idx){
				
				if(fn_itemDedt(obj,idx)){
					//변경 하기 전 값
					var jsOriginDedt = $(obj).data("dedt");
					//변경할 값
					var jsDedt = $(obj).val();
		
					if(jsOriginDedt != jsDedt){
						var jsMsg = jsDedt + " 로 납기일자를 변경하시겠습니까?";
						
						var data = {};
						data.originDedt = jsOriginDedt;
						data.dedt = jsDedt;
						data.amDedtId = $(obj).attr("id");
						data.name = $(obj).attr("name");
						
						yesBox(jsMsg, fn_dateYFnc, fn_dateNFnc, data);
					}
				}
			}
			
			function fn_dateYFnc(data){
				var jsWdedt = $("input[name=W_DEDT]");
				
				$.each(jsWdedt, function(idx){
					if(data.originDedt == jsWdedt.eq(idx).data("dedt")){
						if(data.name == "W_DEDT"){// 한개적용
							jsWdedt.eq(data.index).val(data.dedt);
							jsWdedt.eq(data.index).data("dedt", data.dedt);
						}else{ //일괄적용
							jsWdedt.eq(idx).val(data.dedt);
							jsWdedt.eq(idx).data("dedt", data.dedt);
						}
					}
				});
				
				$("#"+data.amDedtId).data("dedt",data.dedt);
				fn_prdUdt("FNC");
			}
			
			function fn_dateNFnc(data){
				//false 일 경우 업무 처리 확인 필요
				$("input[name=W_DEDT]").each(function(idx){
					if(data.originDedt == $("input[name=W_DEDT]").eq(idx).data("dedt")){
						$("input[name=W_DEDT]").eq(idx).val(data.originDedt);
						$("#AM_W_DEDT"+idx).val(data.originDedt);
					}
				});
			}
			
			//선택 체크박스 선택시 값 set
			function fn_chkSetValue(chkBox, idx){
				/* var jsTr = $("#listBody tr.UcItemRow");
				var jsFirstTd = $("#listBody > tr > td.UcFirstRow"), */
				var jsTr = $("#listBody").find("table > tbody > tr.UcItemRow");
				var jsFirstTd = $("#listBody").find("table > tbody > tr.UcItemRow > td.UcFirstRow"),
					 jsFirstTdCnt = $(jsFirstTd).length;
				var jsSelectItem = $(jsFirstTd).find("input:checkbox[name=selectItem]"),
					jsSelectItemCnt = $(jsSelectItem).length; 
				
				for(var i=0; i < jsSelectItemCnt; i++){
					if(jsSelectItem.eq(i).is(":checked")){
						for(var j=0; j <jsTr.length; j++){
							if(jsSelectItem.eq(i).data("dedt") == jsTr.eq(j).data("dedt")){
								$("input[name=cfrmItem]").eq(j).val("Y");
							}
						}
					}else {
						for(var j=0; j <jsTr.length; j++){
							if(jsSelectItem.eq(i).data("dedt") == jsTr.eq(j).data("dedt")){
								$("input[name=cfrmItem]").eq(j).val("N");
							}
						}
					}
				}
				//체크박스 개별 선택 
				fn_selectChk(chkBox, idx);
			}
			
			//체크박스 전체 선택시 값 set
			function fn_allChkSetValue(chkBoxNm){
	
				if(chkBoxNm == "selectItem"){
					if(jsCheckBox == "N"){
						$("input[name=cfrmItem]").val("Y");
					}else {
						$("input[name=cfrmItem]").val("N");
					}
				}
				
				//체크박스 전체 선택 
				fn_allChkBox(chkBoxNm);
			}
			
			// 주문 내역 수정 저장
			function fn_prdUdt(txt){
				/*
					PRD : 저장 Action
					FNC : 그룹합계행 납기일자 일괄 변경 시  저장 Action 
					CHG : 선택제품확정 시 납기일자 변경된 행이 있을 경우 저장 후 확정 처리 
				*/

				//주문내역 수정 저장 시 유효하지 않은 납기일자 체크
				var jsAlertDay="";
				var jsNotValidIdx = 0;
				$("input[name=W_DEDT]").each(function (i){
					jsAlertDay = fn_itemDlvyDay(i);
					if(!gfn_isNull(jsAlertDay)){
						jsNotValidIdx = i;
						return false;
					}
				});
				
				if(!gfn_isNull(jsAlertDay)){
					alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, $("input[name=W_DEDT]").eq(jsNotValidIdx));
				}else{
					var jsFrm =$("#listFrm");
					var jsTr = $(jsFrm).find("table > tbody >tr.UcItemRow"),
						jsTrCnt = $(jsTr).length ;
					
					var jsSelectArr = [];
					
					$("input[name=cfrmItem]").each(function(i){
						if(txt == "PRD"){
							$("input[name=cfrmItem]").eq(i).val("N")
						}
						jsSelectArr.push($("input[name=cfrmItem]").eq(i).val());
					});
					var data = {};
					data.selItem = jsSelectArr;
					data.udtSe = txt;
					
					if(jsTrCnt > 0){
						comAjax('listFrm', '/ordMod/update.do', data, fn_prdUdtCallBack);	
					}else {
						alertBox("<spring:message code='dc.save'/>"+"할 "+"<spring:message code='alert.noItem'/>");
					}
				}
			}
			
			// 주문 내역 수정 저장 CallBack
			function fn_prdUdtCallBack(data){
				var jsFrm =$("#listFrm");
				if(Number(data.result) > 0){
					if(data.udtSe == 'PRD'){
						alertBox("<spring:message code='dc.save'/>"+" "+"<spring:message code='alert.complete'/>");
						fn_indictLmtt();
					}else if(data.udtSe == 'CHG'){
						// 저장 후 목록 재조회
						jsChgDedt = "CHG";
						fn_listMore();
					}
					
					if($(jsFrm).find("table > tbody >tr").empty()){
						$("#firstLoadAt").val("N");
						fn_listMore();
					}	
				}
			}
			
			// 선택제품확정
			function fn_prdDcsn(){
				var jsMinQyAt = true;
				
				var jsFrm =$("#listFrm"); 
				var jsTr = $(jsFrm).find("table > tbody >tr.UcItemRow"),
					jsTrCnt = $(jsTr).length ;
				
				if($("#dlivyStopAt").val() == '1'){
					alertBox("관리자에게 문의해주세요.");
					return false;
				}
				
				// 확정할 행이 존재해야함.
				if(Number(jsTrCnt) >0){
					var jsSelChkBox = $(jsTr).find("td > input[name=selectItem]:checked"),
						jsSelChkBoxCnt = $(jsSelChkBox).length;
					
					//선택 체크박스값이 선택된 경우
					if(Number(jsSelChkBoxCnt) > 0){
						
						//납기일자가 변경된 제품이 있는 경우
						var jsWdedt = $("input[name=W_DEDT]");
						var jsMsg = "납기일자가 변경되었습니다. 변경된 내용을 저장하시겠습니까?"
						var jsChgDedt = false;
						var jsDeadLineChk = true;
						
						$(jsSelChkBox).each(function (i){
							$.each($(jsWdedt), function(idx){
								if($("input[name=cfrmItem]").eq(idx).val() == "Y"){
									if(gfn_dtReplace($("input[name=W_DEDT]").eq(idx)) < gfn_dtReplace($("input[name=DEADLINE]"))){
										jsDeadLineChk = false;
									}
								}
								if($(jsWdedt).eq(idx).data("dedt") != $(jsWdedt).eq(idx).val()){
									$("input[name=cfrmItem]").eq(idx).val("N");
									jsChgDedt = true;
								}
								if(jsTr.find("input[name=W_QUANTITY]").eq(idx).val() > jsTr.find("input[name=I_STTUS_BOX]").eq(idx).val()){
									alertBox("입력한 수량이 재고수량보다 많습니다.");
									return;
								}
								
							});
						});
						
						if(jsDeadLineChk){ // 납기일자 이전경우
							if(jsChgDedt){//납기일자가 변경된 제품이 있는 경우 저장 진행
								yesBox(jsMsg, fn_udtYFnc, fn_udtNFnc, '');
							}else {
								jsMinQyAt = fn_minimumQyChk();
								
								//최소 주문량 체크 
								if(jsMinQyAt){
									yesBox("<spring:message code='confirm.itemDcsn'/>", fn_dcsnYFnc, fn_dcsnNFnc, '');
								}
							}
						}else{
							alertBox("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>");
						}
					}else {
						alertBox("<spring:message code='alert.selectNone'/>");
					}
					
				}else {
					alertBox("<spring:message code='alert.selectNone'/>");
				}
			}
						
			//납기일자 변경  true function
			function fn_udtYFnc(data){
				fn_prdUdt("CHG");
			}
			
			//납기일자 변경  false function
			function fn_udtNFnc(data){
				$("input[name=selectItem]").prop("checked", false);
				$("input[name=selectYn]").val("N");
			}
			
			//최소 주문 량 체크 분리
			function fn_minimumQyChk(){
				var jsMinQyAt = true;
				var jsFrm =$("#listFrm"); 
				var jsTr = $(jsFrm).find("table > tbody >tr.UcItemRow"),
					jsTrCnt = $(jsTr).length ;
				
				var jsSelChkBox = $(jsTr).find("td > input[name=selectItem]:checked"),
					jsSelChkBoxCnt = $(jsSelChkBox).length;
				
				//최소 주문량 확인
				var jsMinimumQy = $("input[name=minimumQy]").val();
				
				//그룹 합계 행
				var jsAmTr = $(jsFrm).find("table > tbody >tr.UcAmountRow"),
				jsAmTrCnt = $(jsAmTr).length ;
				
				//최소 주문량이 0 보다 클 경우
				if(Number(jsMinimumQy) >= 0){
					$(jsSelChkBox).each(function (i){
						//tr의 rowno을 가져올 경우 선택 checkbox와 합계행의 id 값과 매칭되지 않아 수정함.
						//var jsRowNo = $(jsSelChkBox).eq	(i).parents().parents().data("rowno");
						
						var jsRowNo = $(jsSelChkBox).eq	(i).data("amrow");
						//선택된 체크박스와 같은 index를 가진 합계 행의 값과 최소 주문량 비교
						if(Number(jsMinimumQy) > Number($(jsAmTr).find("td").find("#qySm"+jsRowNo).val())){
							alertBox($(jsSelChkBox).eq(i).data("dedt")+"납기일자의 합계중량이 "+ jsMinimumQy +"미만입니다. 주문수량을 확인해주시기 바랍니다.");
							$(jsAmTr).find("td").find("#qySm"+jsRowNo).css("color","red");
							
							jsMinQyAt = false;
							return false;
						}else {
							$(jsAmTr).find("td").find("#qySm"+jsRowNo).css("color","#333");
						}
					});
				}else {
					alertBox("최소주문량을 확인해주시기 바랍니다.");
					jsMinQyAt = false;
					return false;
				}
				
				return jsMinQyAt;
			}
			
			// 확정 진행
			function fn_dcsnYFnc(data){
				var jsFrm =$("#listFrm"); 
				var jsTr = $(jsFrm).find("table > tbody >tr.UcItemRow"),
					jsTrCnt = $(jsTr).length;
				
				var jsSelChkBox = $(jsTr).find("td > input[name=selectItem]:checked"),
				jsSelChkBoxCnt = $(jsSelChkBox).length;
				
				var jsSelectArr = [];
				if(Number(jsSelChkBoxCnt) > 0){
					$("input[name=cfrmItem]").each(function(i){
						jsSelectArr.push($("input[name=cfrmItem]").eq(i).val());
					});
				}
				
				var data = {};
				data.selItem = jsSelectArr;
				
				comAjax('listFrm', '/ordMod/ordRceptInsert.do', data, fn_prdDcsnCallBack);
			}
			
			// 확정 미 진행
			function fn_dcsnNFnc(data){
				return;
			}
			
			// 선택제품 확정 CallBack
			function fn_prdDcsnCallBack(data){
				var jsFrm =$("#listFrm");
				
				if(Number(data.result) > 0){
					//alertBox("주문"+"<spring:message code='dc.dcsn'/>"+"이 "+ "<spring:message code='alert.complete'/>");
					
					//선택주문 확정 후  페이지 reload
					fn_listMore();
				}else {
					alertBox("주문"+"<spring:message code='dc.dcsn'/>"+"에 "+ "<spring:message code='alert.failed'/>");
				}
			}
			
			// 선택제품삭제
			function fn_prdDel(obj){
				var jsFrm =$("#listFrm");
				var jsTr = $(jsFrm).find("table > tbody >tr.UcItemRow"),
					jsTrCnt = $(jsTr).length ;
				var jsDelType = $(obj).data("del");
				var row = $(obj).data("row");
				
				// 삭제할 행이 존재해야함.
				if(Number(jsTrCnt) >0){
					//삭제 종류 판별
					if(jsDelType == "one"){
						$("input[name=delItem]").eq(row).val("Y");
						yesBox("제품을 삭제하시겠습니까?", fn_delYFnc, fn_delNFnc, '');
					}else if(jsDelType == "all"){
						$("input[name=delItem]").each(function(index){
							if($("#AM_W_DEDT"+row).val() == $("input[name=cfrmItem]").eq(index).data("dedt")){
								$("input[name=delItem]").eq(index).val("Y")
							}
						});
						yesBox($("#AM_W_DEDT"+row).val()+"의 제품을 전체삭제 하시겠습니까?", fn_delYFnc, fn_delNFnc, '');
					}else {
						alertBox("<spring:message code='dc.delete'/>"+"할 "+"<spring:message code='alert.noItem'/>");
					}
				}else {
					alertBox("<spring:message code='dc.delete'/>"+"할 "+"<spring:message code='alert.noItem'/>");
				}
			}
			
			// 삭제 진행
			function fn_delYFnc(data){
				var jsDeleteArr = [];
				var jsSelectArr = [];
				
				$("input[name=delItem]").each(function(i){
					jsDeleteArr.push($("input[name=delItem]").eq(i).val());
				});
				
				$("input[name=cfrmItem]").each(function(i){
					jsSelectArr.push($("input[name=cfrmItem]").eq(i).val());
				});
				
				var data = {};
				data.delItem = jsDeleteArr;
				data.selItem = jsSelectArr;
				
				comAjax('listFrm', '/ordMod/delete.do', data, fn_prdDelCallBack);
			}
			
			// 삭제 미 진행
			function fn_delNFnc(data){
				$("input[name=delItem]").val("N");
			}
			
			// 선택제품 삭제 CallBack
			function fn_prdDelCallBack(data){
				// 변경 여부 값이 Y 인 경우 "선택" 부분 체크박스 체크된 상태로 변경
				var jsFrm =$("#listFrm");
				
				if(Number(data.result) > 0){
					alertBox("<spring:message code='dc.delete'/>"+"가 "+ "<spring:message code='alert.complete'/>");
					
					if($(jsFrm).find("table > tbody >tr").empty()){
						$("#firstLoadAt").val("N");
						fn_listMore();
					}	
				}else {
					alertBox("<spring:message code='alert.deleteFailed'/>");
				}
			}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="con_wrap_one">
				<h2 class="title">주문 내역 수정</h2>
				<form id="searchFrm" name="searchFrm">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<strong class="tit w_10">납기일자</strong>
								<div class="col w_20">
									<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
									<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
									
									<span class="input_type w_40">
										<input type="text" name="searchDtFrom" value="${dtFrom}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
										&nbsp;~&nbsp;
									<span class="input_type w_40">
										<input type="text" name="searchDtTo" value="${dtTo}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
								</div>
			    	
								<strong class="tit w_10">제품</strong>
								<div class="col w_60">
									<span class="input_type w_85">
										<input type="text" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" size="50px"/>
									</span>
									<!-- <span class="btn_search w_10"><a href="#"  class="btn_s btn_white_l"onclick="javascript:fn_searchList();">조회</a></span> -->
									<span class="btn_search w_10"><a href="#"  id="searchBtn" class="btn_s btn_white_l">조회</a></span>
			    					
			    					<input type="hidden" name="pg" value="1">
			    					<input type="hidden" name="ALOCENTRPS">
			    					<input type="hidden" id="firstLoadAt" value="Y">
			    					<input type="hidden" name="maxItemDedt" value="${maxItemDedt }">
			    					<input type="hidden" name="dlivyStopAt" id="dlivyStopAt" value="${sessionScope.sess_dlivyStopAt}">
								</div>
							</li>
						</ul>
					</div> <!-- //box_gray -->
					<!-- </form> -->
					
					<ul class="impor_text">
						<c:if test="${subMenu.A_USE_AT eq 'Y' }">
							${subMenu.MENU_A}
						</c:if>
						<c:if test="${subMenu.B_USE_AT eq 'Y' }">
							${subMenu.MENU_B}
						</c:if>
					</ul>
				</form>
				
				<form id="listFrm">
					<input type="hidden" name="weekAgo" value="${weekAgo }">
					<input type="hidden" name="curDedt" value="${curDedt }">
					<div id="listBody">
						
					</div>
				</form>
			
			</div> <!-- // con_wrap_one -->
			
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" class="btn_decide btn_l btn_red" onclick="javascript:fn_prdDcsn();"><span>선택제품 <br>확정</span></a>
					<a href="#" class="btn_save btn_l btn_dgray" onclick="javascript:fn_prdUdt('PRD');"><span>임시저장</span></a>
					<a href="#this" class="btn_top btn_white"><span>TOP</span></a>
					<a href="#this" class="btn_down btn_white"><span>DOWN</span></a>
				</span>
			</div>
			<!-- 	// btn_fixed_wrap -->
		</div> <!-- // container -->
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
<!-- </html> -->