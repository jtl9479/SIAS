<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		var jsListUrl = "list.do";
		var jsPageUrl = "page.do";
		var jsMsg = "<spring:message code='alert.alertFocus'/>";
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		var jsMsgDecimalsError = "<spring:message code='alert.decimalsError'/>";
		var jsMoreAt= "";
		var jsCheckBox = "N";
		
		$(document).ready(function(){
			fn_listMore();
			fn_indictLmtt();
			
			// 재고상태 체크 이벤트
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
		});
		
		//수량입력시 재고상태 조회 후 그룹중량합계 계산 진행
		function fn_quanChange(obj, se){
			fn_quanChk(obj,se);
			fn_changeOrdInfo(obj);
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
		
		// 단일 선택
		function fn_selectChk(chkBox, idx){
			var jsChkBoxId = "selectYn_"+idx,
			jsPrdChkBoxId = chkBox.id;
			
			if(!gfn_isNull(jsPrdChkBoxId)){
				if($(chkBox).data("chkse") != "sItem"){
					jsChkBoxId = jsPrdChkBoxId;
				}
			}
			
			if(chkBox.checked == true ){//체크된 경우조사
				$("#"+jsChkBoxId).val("Y");
			}else {
				$("#"+jsChkBoxId).val("N");
			}
		}
		
		function fn_beforeUnDcsnOrd(chkBox){
			var jsChkBoxObj = $("#beforeUDO");
			if(chkBox.checked == true ){//체크된 경우조사
				jsChkBoxObj.val("Y");
			}else {
				jsChkBoxObj.val("N");
			}
		}
		
		//조회
		function fn_searchList(){
			jsMoreAt = "NOT";
			var jsDtFrom = $("input[name=searchDtFrom]").val();
			var jsDtTo = $("input[name=searchDtTo]").val();
			
			var jsMaxDt = new Date(Date.parse(jsDtFrom) + (364*24*60*60*1000)); //시작일 기준 1년후
			var jsParseFrom = new Date(Date.parse(jsDtFrom));
			var jsParseTo = new Date(Date.parse(jsDtTo));
			
			if(jsParseTo.getTime() < jsParseFrom.getTime()){ //시작일이 종료일보다 큰경우
				alertBoxFocus("<spring:message code='alert.searchDtError'/>", $("input[name=searchDtFrom]"));
				return false;
			}else if(jsMaxDt.getTime() < jsParseTo.getTime()){ //1년후 날짜가 종료일보다 큰경우
				alertBox("<spring:message code='alert.searchMaxDt'/>");
				jsMaxDt = jsMaxDt.getFullYear() +"-"+
						(jsMaxDt.getMonth()+1 < 10 ? "0" : "") + (jsMaxDt.getMonth()+1) +"-"+
						(jsMaxDt.getDate() < 10 ? "0" : "") + jsMaxDt.getDate();
				jsDtTo = jsMaxDt;
			}
			
			$("input[name=searchDtFrom]").val(jsDtFrom);
			$("input[name=searchDtTo]").val(jsDtTo);
			$("input[name=pg]").val(1); //초기화
			$("input[name=pgNum]").val(0); //초기화
			$("input[name=listStartDt]").val(""); //초기화
			
			//팝업으로 선택한 출고사업장 정보의 경우 명칭을 지울경우 Code값이 남아있어서 제거 추가
			if($.trim($("#searchBplcNm").val()).length < 1 ){
				//searchBplcCode 초기화
				if(!gfn_isNull($("#searchBplcCode").val())){
					$("#searchBplcCode").val("");
					$("input[name=searchBplcSe]").val("Y");
				}
			}
			
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		};
		
		//더보기
		function fn_listMore(){
			jsMoreAt = "";
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//더보기 CallBack
		function fn_listCallBack(data){
			if(!gfn_isNull(jsMoreAt)){
				$("#listBody").html(data).trigger("create");
			}else{
				$("#listBody").append(data).trigger("create");
			}
			
			// 행번호, 조회종료일자 searchFrm 에 set
			var jsListStartDt =  $("#itemListStartDt").val();	
			var jsListPgNum =  $("#itemPgNum").val();
			var jsListTotalCnt = $("#listTotalCnt").val();
			var jsUserSe = $("#userSe").val();
			
			if (!gfn_isNull(jsListStartDt)) $("input[name=listStartDt]").val(jsListStartDt);
			if (!gfn_isNull(jsListPgNum)) $("input[name=pgNum]").val(jsListPgNum);
			if (!gfn_isNull(jsListTotalCnt)) $("input[name=totalCnt]").val(jsListTotalCnt);
			if (!gfn_isNull(jsUserSe)) $("input[name=userSe]").val(jsUserSe);
			
			$("#itemListStartDt").remove();
			$("#itemPgNum").remove();
			$("#listTotalCnt").remove();
			
			//관리자, 거래처 구분
			//var jsTable
			if($("input[name=userSe]").val() =="U"){
				$(".tbRow_U").css("display","");
				$(".tbRow_A").css("display","none");
			}else{
				$(".tbRow_U").css("display","none");
				$(".tbRow_A").css("display","");
			}
			
			var listCnt = Number($("tr[class='UcItemRow']").length);
			var totalCnt = Number($("input[name=totalCnt]").val());
			
			//동적으로 생성된 datepick제거 후 
			$("input[name=W_DEDT]").removeClass('hasDatepicker').datepicker();//납기일자
			$("input[name=AM_W_DEDT]").removeClass('hasDatepicker').datepicker();//납기일자 합계
			
			if($("input[name=W_PROGRSSE]").length > 0){
				$("input[name=W_QUANTITY]").each(function(index){
					if($("input[name=W_PROGRSSE]").eq(index).val() =="Y"){
						$("#go_"+index).prop("checked", true);
					}else{
						$("#stop_"+index).prop("checked", true);
					}
				});
			}
			
			if (totalCnt <= listCnt) {
				$("#moreBtn").hide();
			} else {
				$("#moreBtn").show();
			}
			fn_tabAddOn();
			fn_indictLmtt();
		}
		
		//검색납기일 유효성
		function fn_searchItemDedt(){
			var jsWeekAgo = $("input[name=weekAgo]");
			var jsCurDedt = $("input[name=curDedt]");
			var jsDtFrom = fn_validDedt($("input[name=searchDtFrom]"));
			var jsDtTo = fn_validDedt($("input[name=searchDtTo]"));
			
			if(!jsDtFrom){
				$("input[name=searchDtFrom]").val(gfn_dtSubString(jsWeekAgo));
			}
			if(!jsDtTo){
				$("input[name=searchDtTo]").val(gfn_dtSubString(jsCurDedt));
			}
		}
		
		//해당업체 클래스on추가
		function fn_tabAddOn(){
			var jsUserSe = $("input[name=userSe]").val();
			
			$(".tab_type li").removeClass("on");
			if(jsUserSe == "U"){
				$(".tab_type li").eq(0).addClass("on");
			}else{
				$(".tab_type li").eq(1).addClass("on");
			}
		}
		
		//관리자, 거래처 버튼
		function fn_userSe(str){
			jsMoreAt = "NOT";
			$("input[name=userSe]").val(str);// 탭종류
			$("input[name=listStartDt]").val(""); //초기화
			$("input[name=pg]").val(1); //초기화
			$("input[name=pgNum]").val(0); //초기화
			
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//선택제품 삭제
		function fn_delItem(){
			var jsChkItem = $("input:checkbox[name=selectItem]:checked").length;
			
			if(Number(jsChkItem) < 1){
				alertBox("<spring:message code='alert.selectNum'/>");
				return;
			}else{
				confirmBox("<spring:message code='confirm.itemDelete'/>", fn_delItemConfirm, 'listFrm');
			}
		}
		
		//confirm 삭제
		function fn_delItemConfirm(){
			comAjax('listFrm', '/mn/unDcsnOrd/delete.do', '', fn_delItemCallBack);
		}
		
		//삭제CallBack
		function fn_delItemCallBack(data){
			var jsResult = data.delResult;
			
			if(Number(jsResult < 0)){
				alertBox("<spring:message code='alert.deleteFailed'/>");
			}else{
				comSubmit('','',jsPageUrl);
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
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", jsItemDedt);
					//$("input[name=W_DEDT]").eq(idx).val(jsDeadLine.val());
					jsItemDedt.val(jsItemDedt.data("dedt"));
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
						alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, jsItemDedt);
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
				}
			}
			
			//중량이 변경된 경우	
			if(jsObjNm == "W_WT"){
				if(Number($(obj).val().replace(/,/gi,"")) > 0){
					//재고상태 조회
					fn_invntrySttus(obj);
				}
			}
			
		}
		
		// 재고 상태 조회
		function fn_invntrySttus(obj){
			var jsTr = $(obj).parents().parents().parents();
			//재고상태 변경 할 tr의 행 번호
			var jsRow  = $(jsTr).data("rowno");
			var jsDedt, jsIcCode, jsInqireSe, jsDe, jsSn, jsWunitBplc;
			
			jsDedt = $("input[name=W_DEDT]").eq(jsRow).val(); //납기일자
			jsIcCode = $("input[name=IC_CODE]").eq(jsRow).val(); //품목코드
			jsWunitBplc  = $("input[name=W_UNIT_BPLC ]").eq(jsRow).val(); //단가단위사업장				
			jsInqireSe  = 'C' //조회구분
			jsDe  = $("input[name=W_RCEPTDE]").eq(jsRow).val(); //접수일자
			jsSn = $("input[name=W_SN]").eq(jsRow).val(); //일련번호
			jsWt = $("input[name=W_WT]").eq(jsRow).val(); //중량
			jsUntpcUnit = $("input[name=UPC_UNTPCUNIT]").eq(jsRow).val(); //단가단위
			
			var data = {};
			data.W_DEDT = jsDedt.replace(/-/gi, "");
			data.IC_CODE = jsIcCode;
			data.INQIRE_SE = jsInqireSe;
			data.W_DE = jsDe.replace(/-/gi, "");
			data.W_SN = jsSn;
			data.W_UNIT_BPLC = jsWunitBplc;
			data.ROW = jsRow;
			data.W_WT = jsWt.replace(/,/gi, "");
			data.W_UNTPCUNIT = jsUntpcUnit;
			
			comAjax('', '/mn/unDcsnOrd/invntrySttus.do', data, fn_invntrySttusCallBack);
		}
		
		// 재고 상태 조회 CallBack
		function fn_invntrySttusCallBack(data){
			//data에 해당하는 index에 set value 해줘야함.
			var jsColor;
			var jsIsttus = $("#listBody").find("tr.UcItemRow").eq(data.row).find(".i_sttus > span");
			var jsIvColor = $("#listBody").find("tr.UcItemRow").eq(data.row).find(".i_sttus > input[name=IV_COLOR]");
			jsIsttus.removeClass();
			switch(data.color){
				case "R" : 
					jsColor="status_red";
					break;
				case "G" : 
					jsColor="status_green";
					break;
				case "Y" : 
					jsColor="status_yellow";
					break;
			}
			jsIsttus.html(gfn_replaceAdd(data.invntryWt));
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
			var jsListBody =$("#listBody"); 
			var jsUcItemRow = $(jsListBody).find("tr.UcItemRow");
			var jsAmRow = $(jsListBody).find("tr.UcAmountRow");
			var jsIvColor = $("input[name=IV_COLOR]"); //재고상태 색상값
			var qySm = 0;
			
			//오늘 날짜
			var jsDate = new Date(); 
			var jsNewDate = new Date(jsDate); 
			jsNewDate.setDate(jsNewDate.getDate()); 
			var jsNowDate = new Date(jsNewDate).toISOString().split("T")[0].replace(/-/gi, "");
			
			//jsBdate="이전일", jsCdate="현재일"
			var jsBdate="", jsCdate="";
			
			// jsBdlvyEnt="직전 거래처코드", jsCdlvyEnt="현재 거래처코드"
			var jsBbplcCode="", jsCbplcCode="";
			
			// jsBdlvyEnt="직전 착지업체", jsCdlvyEnt="현재 착지업체"
			var jsBdlvyEnt="", jsCdlvyEnt="";
			
			var data = {};
			
			$(jsUcItemRow).each(function(index){
				//첫번째 행에서는 Bdate와 Cdate에 동일한 값을 부여한다.
				if(index == 0) jsBdate = $("input[name=W_DEDT]").eq(index).val();
				jsCdate = $("input[name=W_DEDT]").eq(index).val();					
				
				//날짜변경시에는 그룹중량합계에 값 설정
				if(jsBdate != jsCdate){
					$("#qySm"+(index-1)).val(gfn_replaceAdd(qySm));
					qySm = 0;
					jsBdate = jsCdate;
				}else{
					//전 그룹행의 날짜와 현 그룹행의 날짜가 같지만 거래처 코드가 다를 경우 값 설정
					if(index > 0){
						jsBbplcCode=$("input[name=W_BCNCCODE]").eq(index-1).val();
						jsCbplcCode=$("input[name=W_BCNCCODE]").eq(index).val();
						jsBdlvyEnt=$("input[name=W_ENTRPSCODE]").eq(index-1).val();
						jsCdlvyEnt=$("input[name=W_ENTRPSCODE]").eq(index).val();
					}
					
					//거래처코드는 같지만
					if(jsBbplcCode !=jsCbplcCode){
						$("#qySm"+(index-1)).val(gfn_replaceAdd(qySm));
						qySm = 0;
					}else{
						//착지업체가 다를경우 값 설정
						if(jsBdlvyEnt != jsCdlvyEnt){
							$("#qySm"+(index-1)).val(gfn_replaceAdd(qySm));
							qySm = 0;	
						}
					}
				}
				
				//재고상태가 녹생인 경우에만 중량합계 누적계산
				if(jsIvColor.eq(index).val().toUpperCase() == "G"){
					qySm += parseFloat($("input[name=W_WT]").eq(index).val().replace(/,/gi,""));
				}
				
				//마지막 행일 경우 index 번호 그대로 값 설정
				if(index == ($(jsUcItemRow).length -1)){
					$("#qySm"+index).val(gfn_replaceAdd(qySm));	
				}
				
				//이전납기일자가 오늘날짜보다 작을때 변경한경우 yesBox메시지
				if($("input[name=W_DEDT]").eq(index).val() != $("input[name=W_DEDT]").eq(index).data("olddedt")){
					if($("input[name=W_DEDT]").eq(index).val().replace(/-/gi, "") > jsNowDate
							&& $("input[name=W_DEDT]").eq(index).data("olddedt").replace(/-/gi, "") < jsNowDate){
						var jsMsg = "이전납기일자를 변경하시겠습니까?";
						
						data.originDedt = $("input[name=W_DEDT]").eq(index).data("olddedt");
						data.dedt = $("input[name=W_DEDT]").eq(index).val();
						data.amDedtId = $("input[name=W_DEDT]").eq(index).attr("id");
						data.index = index;
						data.name = $("input[name=W_DEDT]").attr("name");
						data.bcncCode = $("input[name=W_BCNCCODE]").eq(index).val();
						data.entrpsCode = $("input[name=W_ENTRPSCODE]").eq(index).val();
						
						yesBox(jsMsg, fn_dateYFnc, fn_dateNFnc, data);
					}
				}
			});
			
			//그룹합계 행 체크
			$(jsAmRow).each(function(idx){
				var jsMinimumQyObj  = $(jsAmRow).find("td.ar_w_dedt").eq(idx).find("input[name=minimumQy]");
				var jsQySmObj  = $(jsAmRow).eq(idx).find("input[name=qySm]");
				
				//"도착지업체" 의 최소주문량보다 작을 경우 css 설정
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
		
		//표시 제한할 재고상태 체크
		function fn_findDedt(dedtDate){
			var jsTbody = $("#listBody");
			var jsUcItemRow = $(jsTbody).find("tr.UcItemRow");
			
			$(jsUcItemRow).each(function(idx){
				if($(jsUcItemRow).find("td.i_sttus").eq(idx).data("dedt") == dedtDate){
					$(jsUcItemRow).find("td.i_sttus").eq(idx).find("span").text("").removeClass();
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
					data.bcncCode = $("input[name=W_BCNCCODE]").eq(idx).val();
					data.entrpsCode = $("input[name=W_ENTRPSCODE]").eq(idx).val();
					
					yesBox(jsMsg, fn_dateYFnc, fn_dateNFnc, data);
				}					
			}
		}
		
		function fn_dateYFnc(data){
			var jsWdedt = $("input[name=W_DEDT]");
			
			$.each(jsWdedt, function(idx){
				// 이전 납기일자 == 납기일자 data값 && data.거래처코드 == 거래처코드 && data.도착지코드 == 도착지코드
				if(data.originDedt == jsWdedt.eq(idx).data("dedt")
						&& data.bcncCode == $("input[name=W_BCNCCODE]").eq(idx).val()
						&& data.entrpsCode == $("input[name=W_ENTRPSCODE]").eq(idx).val()){
					if(data.name == "W_DEDT"){
						jsWdedt.eq(data.index).val(data.dedt);
						jsWdedt.eq(data.index).data("dedt", data.dedt);
					}else{
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
				if(typeof fn_itemDlvyDay == "function"){
					jsAlertDay = fn_itemDlvyDay(i);
				}
				if(!gfn_isNull(jsAlertDay)){
					jsNotValidIdx = i;
					return false;
				}
			});
			
			if(!gfn_isNull(jsAlertDay)){
				alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, $("input[name=W_DEDT]").eq(jsNotValidIdx));
			}else{
				var jsFrm =$("#listFrm");
				var jsTrCnt = $(jsFrm).find("table > tbody >tr.UcItemRow").length;
				var jsValidChk = true;
				
				$.each(jsFrm, function(index, frmObj) {
					$.each(frmObj, function(idx, dom){
						if($(dom).attr("name") == "W_QUANTITY"){
							if(gfn_isNull($(dom).val())){
								alertBoxFocus(jsMsg, $(dom));
								jsValidChk = false;	
								return false;
							}
							/**유효성추가**/
							jsValidChk = fn_quanChk($(dom), 1);
							if(!jsValidChk) return false;
						}
						if($(dom).attr("name") == "W_WT"){
							if(gfn_isNull($(dom).val())){
								alertBoxFocus(jsMsg3, $(dom));
								jsValidChk = false;	
								return false;
							}
							/**유효성추가**/
							jsValidChk = fn_quanChk($(dom), 3);
							if(!jsValidChk) return false;
						}
					});
				});
				
				if(jsValidChk){
					var jsSelectArr = [];
					
					$("input[name=cfrmItem]").each(function(i){
						jsSelectArr.push($("input[name=cfrmItem]").eq(i).val());
					});
					
					var data = {};
					data.selItem = jsSelectArr;
					data.udtSe = txt;
					
					if(jsTrCnt > 0){
						comAjax('listFrm', '/mn/unDcsnOrd/update.do', data, fn_prdUdtCallBack);
					}else {
						alertBox("<spring:message code='dc.save'/>"+"할 "+"<spring:message code='alert.noItem'/>");
					}
				}
				
			}
		}
		
		// 주문 내역 수정 저장 CallBack
		function fn_prdUdtCallBack(data){
			var jsFrm =$("#listFrm");
			
			if(Number(data.result) > 0){
				if(data.udtSe == 'PRD'){
					alertBox("<spring:message code='dc.save'/>"+" "+"<spring:message code='alert.complete'/>");	
				}else if(data.udtSe == 'CHG'){
					//확정처리 진행
					var jsMinQyAt = true;
					
					var timerTest = setTimeout(function() {
						jsMinQyAt = fn_minimumQyChk();
					}, 2000);
					
					//최소 주문량 체크 
					if(jsMinQyAt){
						//yesBox("<spring:message code='confirm.itemDcsn'/>", fn_dcsnYFnc, fn_dcsnNFnc, '');
						fn_dcsnYFnc();
						clearTimeout(timerTest);
					}
					
				}
				
				if($(jsFrm).find("table > tbody >tr").empty()){
					if(data.udtSe == "FNC" || data.udtSe == "PRD"){
						fn_searchList();
					}else{
						fn_listMore();
					}
				}
			}
		}
		
		//단가 변경
		function fn_newUnitpcChg(obj){
			var jsReturnVal;
			var jsRegNum =/^[\d]*$/; //정수정규식
			
			var row = $(obj).data("row");
			$(obj).val($(obj).val().replace(/,/gi,""));
			
			if(jsRegNum.test($(obj).val())){//정수정규식
				jsReturnVal = true;
			}else{//정수정규식 오류
				alertBoxFocus($(obj).attr("title")+jsMsgAlertFocus, $(obj))
				$(obj).val(0);
				fn_sumAmount($("input[name=W_QUANTITY]").eq(row), row, 1);
				jsReturnVal = false;
			}
			
			if(jsReturnVal){
				//(수량,1)
				var jsNewUnitpcChk = fn_quanChk($("input[name=W_QUANTITY]").eq(row), 1);
				if(jsNewUnitpcChk){
					$(obj).val(gfn_replaceAdd($(obj).val()));
					alertBoxFocus("'"+$("input[name=IC_CODE]").eq(row).val()+"'의 단가를 변경하였습니다.", obj);
				}
			}
		}
		
		// 진행유무
		function fn_radioChk(obj){
			var row = $(obj).data("row");
			
			if($(obj).val() == "Y"){
				$("input[name=W_PROGRSSE]").eq(row).val("Y");
			}else{
				$("input[name=W_PROGRSSE]").eq(row).val("N");
			}
		}
		
		//조회 keyup
		function fn_searchKeyup(obj){
			var jsData = $(obj).data("search");
			var jsDataNm = $("input[data-nm="+jsData+"]");
			var jsDataCode = $("input[data-code="+jsData+"]");
			var jsDataSe = $("input[data-codeSe="+jsData+"]");
			
			if($(obj).val() == jsDataNm.val()){
				jsDataSe.val("Y");
			}else{
				jsDataSe.val("N");
			}
			
			//팝업으로 선택한 출고사업장 정보의 경우 명칭을 지울경우 Code값이 남아있어서 제거 추가
			if($.trim($("#searchBplcNm").val()).length < 1 ){
				//searchBplcCode 초기화
				if(!gfn_isNull($("#searchBplcCode").val())){
					$("#searchBplcCode").val("");
					$("input[name=searchBplcSe]").val("Y");
				}
			}
		}
		
		//전체선택
		function fn_groupSelect(obj){
			var row = $(obj).data("row");
			
			$("input[name=selectItem]").each(function(idx){
				//그룹납기일자 == 납기일자 && 그룹마지막 거래처코드 == 거래처코드 && 그룹마지막 도착지코드 == 도착지코드
				if($("#AM_W_DEDT"+row).val() == $("input[name=W_DEDT]").eq(idx).val() 
						&& $("input[name=W_BCNCCODE]").eq(row).val() == $("input[name=W_BCNCCODE]").eq(idx).val()
						&& $("input[name=W_ENTRPSCODE]").eq(row).val() == $("input[name=W_ENTRPSCODE]").eq(idx).val()) {
					if($("input[name=selectYn]").eq(row).val() == "N"){ // 끝행의 체크여부에따라 달라짐
						$("input[name=selectItem]").eq(idx).prop("checked",true);
						$("input[name=selectYn]").eq(idx).val("Y");
					}else{
						$("input[name=selectItem]").eq(idx).prop("checked",false);
						$("input[name=selectYn]").eq(idx).val("N");
					}
				}
			});
		}
	</script>
</head>
<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">미확정주문조회</h2>
			
			<form id="searchFrm" name="searchFrm" method="POST">
				<input type="hidden" name="pg" value="1" />
				<input type="hidden" name="pgNum" value="0" />
				<input type="hidden" name="listStartDt" value="${listStartDt }"/>
				<input type="hidden" name="totalCnt"/>
				<input type="hidden" name="userSe" value="U">
				<input type="hidden" name="weekAgo" value="${weekAgo }">
				<input type="hidden" name="curDedt" value="${curDedt }">
				<input type="hidden" name="DEADLINE" value="${view.DEADLINE }">
				<div class="box_gray">
					<ul class="srch_list">
						<li>
							<div class="col w_30">
								<strong class="tit w_10">
									<a href="#this" class="under_line popOpen" data-popup="BPLC" title="<spring:message code='title.bplc' />">출고사업장</a>
								</strong>
								<div class="col w_90">
									<span class="input_type w_100">
										<input type="text" id="searchBplcNm" data-search="BPLC" name="searchBplcNm" placeholder="<spring:message code='search.bplc'/>" onkeyup="javascript:fn_searchKeyup(this);">
										<input type="hidden" id="searchBplc" data-nm="BPLC" name="searchBplc">
										<input type="hidden" id="searchBplcCode" data-code="BPLC" name="searchBplcCode">
										<input type="hidden" data-codeSe="BPLC" name="searchBplcSe" value="Y">
									</span>
								</div>
							</div>
							<div class="col w_55">
								<strong class="tit w_5">
									<a href="#this" class="under_line popOpen" data-popup="BCNC" title="<spring:message code='title.bcnc' />">거래처</a>
								</strong>
								<div class="col w_95">
									<span class="input_type w_100">
										<input type="text" id="searchBcncNm" data-search="BCNC" name="searchBcncNm" placeholder="<spring:message code='search.bcnc'/>" onkeyup="javascript:fn_searchKeyup(this);">
										<input type="hidden" id="searchBcnc" data-nm="BCNC" name="searchBcnc">
										<input type="hidden" id="searchBcncCode" data-code="BCNC" name="searchBcncCode">
										<input type="hidden" data-codeSe="BCNC" name="searchBcncSe" value="Y">
									</span>
								</div>
								<strong class="tit w_5">도착지업체</strong>
								<div class="col w_40">
									<span class="input_type w_100">
										<input type="text" id="searchEntrpsNm" data-search="DLVY" name="searchEntrpsNm" placeholder="<spring:message code='search.dlvyInput'/>" maxlength="25" onkeyup="javascript:fn_searchKeyup(this);">
										<input type="hidden" id="searchEntrps" data-nm="DLVY" name="searchEntrps">
										<input type="hidden" id="searchDlvyEntrps" data-code="DLVY" name="searchDlvyEntrps" />
										<input type="hidden" data-codeSe="DLVY" name="searchDlvySe" value="Y">
									</span>
								</div>
							</div>
							<div class="col w_15"></div>
						</li>
	
						<li>
							<div class="col w_30">
								<strong class="tit w_10">
									<span class="input_type">
										<select name="searchDtGroup" id="">
											<option value="dedt">납기일자</option>
											<option value="orderDe">주문일자</option>
										</select>
									</span>
								</strong>
								<div class="col w_80">
									<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
									<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
									&nbsp;
									<span class="input_type w_35">
										<input type="text" name="searchDtFrom" value="${dtFrom}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />">
									</span>
									&nbsp;~&nbsp;
									<span class="input_type w_35">
										<input type="text" name="searchDtTo" value="${dtTo}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
								</div>
							</div>
							<div class="col w_55">					
								<strong class="tit w_5">제품</strong>
								<div class="col w_95">
									<span class="input_type w_100">
										<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" maxlength="40"/>
									</span>
								</div>
								
								<strong class="tit w_5">이전 주문건</strong>
								<div class="col w_5">
									<input type="checkbox" name="beforeUDO" id="beforeUDO" onclick="javascript:fn_beforeUnDcsnOrd(this);" value=""/>
									<label for="beforeUDO" style="vertical-align: middle;"></label>
								</div>
							</div>
							<div class="col w_15">		
								<span class="btn_search w_100">
									<a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a>
								</span>
							</div>
						</li>
					</ul>
				</div>
				<!-- //box_gray -->
				<ul class="tab_type">
					<li>
						<a href="#" onclick="javascript:fn_userSe('U');">거래처</a>
					</li>
					<li>
						<a href="#" onclick="javascript:fn_userSe('A');">관리자</a>
					</li>
				</ul>
			</form>
			
			<form id="listFrm" name="listFrm">
				<input type="hidden" name="userSe" /> 
				<div id="tab-1" class="tab_con_wrap on">
					<div class="tb-type01">
						<table >
							<colgroup class="tbRow_A">
								<col width="50px">
								<col width="80px">
								<col width="40px">
								<col width="12%">
								<col width="50px">
								<col width="12%">
								<col width="50px">
								<col width="12%">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="25px">
								<col width="60px">
								<col width="*">
							</colgroup>	
							<colgroup class="tbRow_U" style="display:none;">	
								<col width="50px">
								<col width="80px">
								<col width="40px">
								<col width="10%">
								<col width="50px">
								<col width="10%">
								<col width="50px">
								<col width="10%">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="50px">
								<col width="25px">
								<col width="60px">
								<col width="120px">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<thead>
								<tr class="tbRow_A">
									<th><a href="#" onclick="javascript:fn_allChkBox('selectItem');">*삭제</a></th>
									<th style="min-width: 80px">납기일자</th>
									<th>거래처<br>코드</th>
									<th style="min-width:100px;">거래처</th>
									<th>도착지<br>업체코드</th>
									<th style="min-width:100px;">도착지<br>업체</th>
									<th>제품코드</th>
									<th style="min-width:100px;">제품</th>
									<th>규격</th>
									<th>수량<br>(BOX)</th>
									<th>중량<br>(KG)</th>
									<th>재고상태<br>(KG)</th>
									<th>단가</th>
									<th>단위</th>
									<th>금액</th>
									<th style="min-width:100px;">비고</th>
								</tr>
								<tr class="tbRow_U" style="display:none;">
									<th><a href="#" onclick="javascript:fn_allChkBox('selectItem');">*삭제</a></th>
									<th style="min-width: 80px">납기일자</th>
									<th>거래처<br>코드</th>
									<th style="min-width:100px;">거래처</th>
									<th>도착지<br>업체코드</th>
									<th style="min-width:100px;">도착지<br>업체</th>
									<th>제품코드</th>
									<th style="min-width:100px;">제품</th>
									<th>규격</th>
									<th>수량<br>(BOX)</th>
									<th>중량<br>(KG)</th>
									<th>재고상태<br>(KG)</th>
									<th>단가</th>
									<th>단위</th>
									<th>금액</th>
									<th>진행</th>
									<th style="min-width:100px;">비고</th>
									<th style="min-width:100px;">상담내용</th>
								</tr>
							</thead>
							<tbody id="listBody"></tbody>
						</table>
					</div>
					<!-- // tb-type01 -->
				</div><!-- // tab_con -->
			</form>

			<div class="btn_wrap t_r">
				<a href="javascript:void(0);" id="moreBtn" class="btn_m btn_white" onclick="javascript:fn_listMore();"><b>더보기</b></a>
			</div>
		</div>
		<!-- // con_wrap_one -->
	
		<div class="btn_fixed_wrap">
			<span class="btn_wrap">
				<a href="#" class="btn_save btn_l btn_red" onclick="javascript:fn_prdUdt('PRD');"><span>저장</span></a>
				<a href="#" class="btn_delete btn_l btn_white" onclick="javascript:fn_delItem()"><span>선택제품 <br>삭제</span></a>
				<a href="#" class="btn_top btn_white"><span>TOP</span></a>
				<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
			</span>
		</div>
		<!-- 	// btn_fixed_wrap -->
	
	</div>
	<hr>
	<!-- // container -->
</body>
<!-- 팝업 시작-->
<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
<!-- 팝업 종료-->
<!-- </html> -->
