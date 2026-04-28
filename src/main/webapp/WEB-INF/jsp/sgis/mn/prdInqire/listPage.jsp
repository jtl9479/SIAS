<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html>
<html> -->
	<head>
		<script type="text/javascript">
		var jsListUrl = "list.do",
			jsPageUrl = "page.do";
		var jsMsg = "<spring:message code='alert.alertFocus'/>";
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		var jsMsgDecimalsError = "<spring:message code='alert.decimalsError'/>";
		var jsMoreAt= "";
		var jsLastIdNum=1;
	
		$(document).ready(function(){
			$("input[name=pg]").val(1);
			fn_listMore();
			fn_dateInit();
			
			// 재고상태 체크 이벤트
			$(document).on("change", "[data-sttus = DEDT]", function(e) {
				e.preventDefault();
				fn_changeOrdInfo(this);
			});
			
			//keyup
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
		
		//keydown이벤트 jquery-ui.js 보다 먼저실행하기위해 설정
		function fn_dedtKeydown(idx){
			if(event.keyCode == 13){
				fn_itemDedt(idx);
			}
		}
		
		// 납기일자 체크
		function fn_itemDedt(idx){
			var jsItemDedt = "";
			var jsData = "";
			
			if(idx == 0){
				jsItemDedt = $("input[name=itemDedt]").eq(idx);//납기일자
				jsData = $("input[name=itemDedt]").eq(idx).data("dedt");
			}else{
				jsItemDedt = $("input[name=W_DEDT]").eq(idx-1);//납기일자
				jsData = $("input[name=W_DEDT]").eq(idx-1).data("dedt");
			}
			
			var validChk = fn_validDedt(jsItemDedt);
			var jsAlertDay = "";
			
			if(!validChk){
				jsItemDedt.val(jsData);
				return false;
			}else{
				if(gfn_dtReplace(jsItemDedt) < jsData.replace(/-/gi, "")){// 납기일자가 최소납기일자 이전경우
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", jsItemDedt);
					jsItemDedt.val(jsData);
					return false;
				} else if(gfn_dtReplace(jsItemDedt) > gfn_dtReplace($("input[name=itemDedtMaxDt]"))){
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", jsItemDedt);
					jsItemDedt.val(jsData);
					return false;
				}
				if(typeof fn_itemDlvyDay =='function'){//함수 존재여부
					jsAlertDay = fn_itemDlvyDay(idx);
					if(!gfn_isNull(jsAlertDay)){ //공백이 아닐경우
						alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, jsItemDedt);
						return false;
					}
				}
			}
			return true;
		}
		
		//배송요일체크
		function fn_itemDlvyDay(idx){
			var jsGetDay = new Date($("input[name=itemDedt]").eq(idx).val()).getDay();//요일값
			var jsAlertDay = "";//배송요일 alert변수
			
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
		
		// 검색 조건 및 납기일자 선택 조건 제한
		function fn_dateInit(){
			//+1일부터
			var jsDate = new Date(); 
			var jsNewDate = new Date(jsDate); 
			jsNewDate.setDate(jsNewDate.getDate() + 1); 
			
			var jsMinSearchDtFrom = new Date(jsNewDate).toISOString().split("T")[0];
			
			//+60일까지
			var jsMaxSearchDtTo = $("input[name=itemDedtMaxDt]").val();			
			
			$("._datepick").datepicker("option", "minDate", jsMinSearchDtFrom);
			$("._datepick").datepicker("option", "maxDate", jsMaxSearchDtTo);
		}
		
		// 조회
		function fn_searchList(){
			jsMoreAt = "NOT";
			$("input[name=pg]").val(1);
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//최근 몇 개월전 조회
		function fn_rcvordDedt(dedt){
			jsMoreAt = "NOT";
			$("input[name=pg]").val(1);
			$("input[name=rcvordDedt]").val(dedt);
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		// 목록(더보기)
		function fn_listMore(){
			jsMoreAt = "";
			var pg = Number($("input[name=pg]").val());
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		// List CallBack
		function fn_listCallBack(data){
			if(!gfn_isNull(jsMoreAt)){
				$("#listBody").html(data).trigger("create");	
			}else {
				$("#listBody").append(data).trigger("create");
			}
			//$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
			$("#searchFrm").find("input[name=pg]").val((Number($("#searchFrm").find("input[name=pg]").val())+1));
			
			$("input[name=totalCnt]").val($("input[name=listTotalCnt]").val());
			$("input[name=listTotalCnt]").remove();
			
			// 주문기간 페이지 생성시 on클래스 제거후 on클래스 추가부분
			$("#searchFrm .sel_btn .btn_gray").removeClass("on");
			if($("input[name=rcvordDedt]").val() == -3){
				$("#searchFrm .sel_btn .btn_gray").eq(0).addClass("on");
			}else if($("input[name=rcvordDedt]").val() == -1){
				$("#searchFrm .sel_btn .btn_gray").eq(1).addClass("on");
			}else{
				$("#searchFrm .sel_btn .btn_gray").eq(2).addClass("on");
			}
			
			var listCnt = Number($("tr[id='itemRow']").length);
			var totalCnt = Number($("input[name=totalCnt]").val());
			
			if (totalCnt <= listCnt ) {
				$("#moreBtn").hide();
			} else {
				$("#moreBtn").show();
			}
		}
		
		//팝업에서 거래처 선택 시 배송지업체정보 기본값 변경
		function fn_bcncDlvyList(bcncCode){
			var data = {};
			data.bcncCd = bcncCode;
			data.ordBplc = $("#searchBplcCode").val();
			comAjax('listFrm', '/mn/prdInqire/dlvy.do', data, fn_bcncDlvyListCallBack);
		}
		
		function fn_bcncDlvyListCallBack(data){
			$("#searchEntrpsNm").val(data.DLVY_ENTRPS_NM);
			$("#dlvyEntrps").val(data.DLVY_ENTRPS);
			$("#listBody").empty();
			
			if($("#moreBtn").is(":visible")){
				$("#moreBtn").css("display","none");
			}
			
		}
		
		// 납기일자, 수량 상태 변경 정보
		function fn_changeOrdInfo(obj){
			var jsObjNm = $(obj).attr("name");
			
			//납기 일자가 변경된 경우
			if(jsObjNm == "W_DEDT"){
				if(fn_validDedt($(obj))){
					//재고상태 조회
					var jsRow = $(obj).data("row");
					
					if(fn_itemDedt(jsRow)){
						fn_invntrySttus($(obj));	
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
					var jsRow = $(obj).data("row");
					//새로 입력한 값이 0보다 작을경우 공백처리
					$("input[name=I_STTUS]").eq(jsRow).val("0");
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
		
		//단가 변경
		function fn_newUnitpcChg(obj){
			var jsReturnVal;
			var jsRegNum =/^[\d]*$/; //정수정규식
			
			var row = $(obj).data("row");
			$(obj).val($(obj).val().replace(/,/gi,""))
			
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
		
		// 재고 상태 조회
		function fn_invntrySttus(obj){
			//재고상태 변경 할 tr의 행 번호
			var jsRow = $(obj).data("row");
			if($(obj).attr("name") == "W_DEDT"){
				jsRow = jsRow-1; 
			}
			var jsDedt, jsIcCode, jsInqireSe, jsDe, jsSn, jsWunitBplc;
			
			jsDedt = $("#prdDtlListFrm").find("input[name=W_DEDT]").eq(jsRow).val().replace(/-/gi, "");						//납기일자
			jsIcCode = $("#prdDtlListFrm").find("input[name=IC_CODE]").eq(jsRow).val(); 					//품목코드
			jsWunitBplc  = $("#prdDtlListFrm").find("input[name=UPC_BPLC]").eq(jsRow).val();				//단가단위사업장				
			jsInqireSe  = 'B'																												//조회구분
			jsDe  = $("#prdDtlListFrm").find("input[name=GET_DATE]").eq(jsRow).val();								//접수일자
			jsWt  = $("#prdDtlListFrm").find("input[name=W_WT]").eq(jsRow).val();								//주문중량
			jsWuntpcUnit  = $("#prdDtlListFrm").find("input[name=UPC_UNTPCUNIT]").eq(jsRow).val();	//주문단위
			jsSn = 0 								//일련번호
			
			var data = {};
			data.W_DEDT = jsDedt;
			data.IC_CODE = jsIcCode;
			data.INQIRE_SE = jsInqireSe;
			data.W_WT = jsWt.replace(/,/gi, "");
			data.W_DE = jsDe.replace(/-/gi, "");
			data.W_SN = jsSn;
			data.W_UNIT_BPLC = jsWunitBplc;
			data.W_UNTPCUNIT = jsWuntpcUnit;
			data.ROW = jsRow;
			
			comAjax('', '/mn/prdInqire/invntrySttus.do', data, fn_invntrySttusCallBack);
		}
		
		// 재고 상태 조회 CallBack
		function fn_invntrySttusCallBack(data){
			var jsColor;
			
			switch(data.color){
				case "R" : 
					jsColor="#ea3d45";
					break;
				case "G" : 
					jsColor="#69bb7a";
					break;
				case "Y" : 
					jsColor="#fdb900";
					break;
			}
			$("input[name=I_STTUS]").eq(data.row).val(gfn_replaceAdd(data.invntryWt)).css("color",jsColor);
		}
		
		// 선택제품등록
		function fn_prdReg(){
			var jsChkItem = $("input:checkbox[name=selectItem]:checked").length,
				jsOrdBplc = $("#searchBplcCode").val();
			
			//사업장 정보 확인(주문사업장)
			if(gfn_isNull(jsOrdBplc)){
				alertBox("<spring:message code='search.bplc'/>");
				return;
			}
			
			if(Number(jsChkItem) < 1){
				alertBox("<spring:message code='alert.selectNum'/>");
				return;
			}else {
				var dlvyChk = $("#searchEntrpsNm");
				if(dlvyChk.val() != null && dlvyChk.val().length > 0){
					var data = {};
					data.bcncCd = $("#searchBcncCode").val();
					data.ordBplc = jsOrdBplc;
					comAjax('listFrm', '/mn/prdInqire/prdInfo.do', data, fn_prdRegCallBack);	
				}else {
					alertBox("<spring:message code='title.dlvy'/>" + "<spring:message code='alert.alertFocus'/>");
				}
			}
		}
		
		// 선택제품등록 Callback
		function fn_prdRegCallBack(data){
			var jsAddRow = "";
			var jsEntrpsNm = $("#searchEntrpsNm").val(), 
				jsDlvyEntrps = $("#dlvyEntrps").val(),
				jsItemDedt = $("#itemDedt").val(),
				jsBcncNm = $("#searchBcncNm").val(),
				jsBcncCode =  $("#searchBcncCode").val()
				;
			
			//업체전용, 생산 구분추가를 위한 변수
			var jsAddBlind="<td class='left'> <span class='type_wrap'>";
			
			$.each(data, function(idx, value) {
				var $table = $("#prdDtlTable");
				var jsTrIdx = $table.find("tbody:last").find("tr").length,
					jsAddIdxNum = (Number(jsTrIdx)+1);
				
				if(value.IC_ENT_DVR_SE == 2){
					jsAddBlind = jsAddBlind + "<i class='common'><em class='blind'>공용</em></i>";		
				}
				if(value.IC_PRDCTN_SE == 2){
					jsAddBlind = jsAddBlind + "<i class='only'><em class='blind'>공용</em></i>";
				}
				jsAddBlind = jsAddBlind +"</span> ";
				
				jsAddRow = "<tr>";
				jsAddRow += "<td>";
				 jsAddRow += "<span>"+jsAddIdxNum+"</span>";
				 jsAddRow += "<input type='hidden' name='UPC_VATINCLSAT' value='"+value.UPC_VATINCLSAT+"'/>";
				 jsAddRow += "<input type='hidden' name='UPC_BPLC' value='"+value.UPC_BPLC+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_UNITWT' value='"+value.IC_UNITWT+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_UNITQY' value='"+value.IC_UNITQY+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_PACKNGUNIT' value='"+value.IC_PACKNGUNIT+"'/>";
				 jsAddRow += "<input type='hidden' name='W_PIECE_QY' />";
				 jsAddRow += "<input type='hidden' name='W_GRP_QY' />";
				 jsAddRow += "<input type='hidden' name='W_SPLPCAM' />";
				 jsAddRow += "<input type='hidden' name='W_VAT' />";
				 jsAddRow += "<input type='hidden' name='GET_DATE' value='"+value.GET_DATE+"'/>";
				jsAddRow += "</td>";
				jsAddRow += "<td>"+"<input type='checkbox' id='selectPrdItem_"+jsLastIdNum+"' name='selectPrdItem' onclick='javascript:fn_selectChk(this,"+idx+");'/>"+"<label for='selectPrdItem_"+jsLastIdNum+"'></label>"+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>"+"<input type='text' name='W_DEDT' class='t_c _datepick' value='"+jsItemDedt+"' data-dedt='"+jsItemDedt+"' style='width:100%;' maxlength='10' title='<spring:message code='title.itemDt'/>' data-sttus='DEDT' placeholder='<spring:message code='search.dtFormat'/>' />"+"</span>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='BCNC_CODE' class='t_c readOnly' value='"+jsBcncCode+"' style='width:100%;'  readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+jsBcncNm+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='DLVY_ENTRPS' class='t_c readOnly' value='"+jsDlvyEntrps+"' style='width:100%;'  readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+jsEntrpsNm+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='IC_CODE' class='t_c readOnly' value='"+value.IC_CODE+"' style='width:100%;'  readonly='readonly'/>"+"</td>";
				jsAddRow += jsAddBlind + value.IC_NM+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>"+"<input type='text' name='W_QUANTITY' style='width:100%; text-align: center; padding:0;' data-sttus='QY' data-fcs='QY' class='input_type' title='<spring:message code='title.quantity'/>' onfocus='this.select()' onchange='javascript:fn_quanChange(this, 1);'/>";
				jsAddRow += "</span>"+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>"+"<input type='text' name='W_WT' style='width:100%; text-align: center; padding:0;' data-sttus='WT' data-fcs='WT' class='input_type' title='<spring:message code='title.wt'/>' onfocus='this.select()' onchange='javascript:fn_quanChange(this, 3);'/>";
				jsAddRow += "</span>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='I_STTUS' class='t_c readOnly' value='"+''+"' style='width:100%;'  readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>";
				 jsAddRow += "<input type='text' name='UPC_NEWUNITPC' value='"+value.UPC_NEWUNITPC+"' style='width:100%; text-align: center; padding:0;' data-admse='MN' title='<spring:message code='title.untpc'/>' onfocus='this.select()' onchange='javascript:fn_newUnitpcChg(this);'/>";
				 jsAddRow += "<input type='hidden' name='UPC_UNTPCUNIT' value='"+value.UPC_UNTPCUNIT+"'/>";
				 jsAddRow += "<input type='hidden' name='STDR_UPC_NEWUNITPC' value='"+value.UPC_NEWUNITPC+"'/>";
				jsAddRow += "</span>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='UPC_UNIT_CHRCTR' class='t_c readOnly' value='"+value.UPC_UNIT_CHRCTR+"' style='width:100%;'  readonly='readonly'/>"+"</td>";			
				jsAddRow += "<td>"+"<input type='text' name='W_SUMAMOUNT' class='t_c readOnly' style='width:100%;' readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>"+"<input type='text' name='RM' style='width:100%; padding:0;'/>"+"</span>"+"</td>";
				jsAddRow += "</tr>";
				
				$('#prdDtlTable > tbody:last').append(jsAddRow);
				
				//id 중복 방지
				jsLastIdNum++;
				
				jsAddBlind="<td class='left'> <span class='type_wrap'>";
			});
			
			// 선택 제품 조회 완료 후 제품 조회 체크박스 해제
			$("input[name=selectItem]").prop("checked",false);
			$("input[name*=selectYn]").val("N");
			
			// 제품 tr 생성 후에 idx 값 재정렬
			fn_idxInit();
		}
		
		function fn_idxInit(){
			var $table = $("#prdDtlTable") ,
				jsTr = $table.find("tbody:last").find("tr"),
				jsTrLen = $table.find("tbody:last").find("tr").length ;
			
			for(var i=0; i<jsTrLen; i++) {
				
				/**함수명변경, data-row추가**/
				//수량
				jsTr.eq(i).find("input[name=W_QUANTITY]").removeData("data-row");
				jsTr.eq(i).find("input[name=W_QUANTITY]").data("row",i); //주석해제
				jsTr.eq(i).find("input[name=W_QUANTITY]").attr("data-row", i);
				jsTr.eq(i).find("input[name=W_QUANTITY]").attr("onchange","fn_quanChange(this, 1)");
				// 중량
				jsTr.eq(i).find("input[name=W_WT]").removeData("data-row");
				jsTr.eq(i).find("input[name=W_WT]").data("row",i); //주석해제
				jsTr.eq(i).find("input[name=W_WT]").attr("data-row", i);
				jsTr.eq(i).find("input[name=W_WT]").attr("onchange","fn_quanChange(this,3)");
				//단가 변경
				jsTr.eq(i).find("input[name=UPC_NEWUNITPC]").removeData("data-row");
				jsTr.eq(i).find("input[name=UPC_NEWUNITPC]").data("row",i); //주석해제
				jsTr.eq(i).find("input[name=UPC_NEWUNITPC]").attr("data-row", i);
				jsTr.eq(i).find("input[name=UPC_NEWUNITPC]").attr("onchange","fn_newUnitpcChg(this)");
				
				//납기일자
				jsTr.eq(i).find("input[name=W_DEDT]").data("row",i+1);
				jsTr.eq(i).find("input[name=W_DEDT]").attr("data-row", i+1);
			}
			
			$("#siBtn").attr("onclick", "fn_allChkBox(this, 'selectItem')");
			$("#spiBtn").attr("onclick", "fn_allChkBox(this, 'selectPrdItem')");
			
			$("._datepick").datepicker();
			fn_dateInit();
		}
		
		// 선택제품 삭제
		function fn_prdDel(){
			var jsChkItem = $("input:checkbox[name=selectPrdItem]:checked"),
				jsChkLen=jsChkItem.length,
				jsObjTr;
			
			if(Number(jsChkLen) < 1){
				alertBox("<spring:message code='alert.selectNum'/>");
				return;
			}else{
				$(jsChkItem).each(function(idx) {
						jsObjTr = $(jsChkItem).eq(idx).parent().parent();
						jsObjTr.remove();
				});
				
				// 삭제시 NO 재 정렬
				var $table = $("#prdDtlTable");
				var jsTrIdx = $table.find("tbody:last").find("tr").length;
				
				for(var i=0; i<jsTrIdx; i++) {
					$("#prdDtlTable > tbody > tr").eq(i).find(" td:first > span").html((Number(i)+1));
				}
				
				// 제품 tr 생성 후에 idx 값 재정렬
				fn_idxInit();
				
			}
		}
		
		// 주문 접수 등록
		function fn_basketReg(){
			var jsValidChk = true;
			var jsMsg = "<spring:message code='title.quantity'/>"+"<spring:message code='alert.alertFocus'/>",
				jsMsg2 = "<spring:message code='title.itemDt'/>"+"<spring:message code='alert.alertFocus'/>",
				jsMsg3 = "<spring:message code='title.wt'/>"+"<spring:message code='alert.alertFocus'/>";
			/* var jsChkItem = $("input:checkbox[name=selectPrdItem]:checked"),
			jsChkLen=jsChkItem.length; */
			
			var jsTrCnt = $("#prdDtlTable > tbody > tr").length;
			// 장바구니 insert 전 유효성 체크
			if(jsTrCnt >0){
				var jsFrm =$("#prdDtlListFrm");
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
						
						if($(dom).attr("name") == "W_DEDT"){
							if(gfn_isNull($(dom).val())){
								alertBoxFocus(jsMsg2, $(dom));
								jsValidChk = false;	
								return false;
							}
						}
					});
				});
				
				if(jsValidChk){
					confirmBox('주문 등록 하시겠습니까?', fn_insertConfirm, 'prdDtlListFrm');
					//comAjax('prdDtlListFrm', '/mn/prdInqire/insert.do', '', fn_insertCallBack);	
				}
			}else {
				alertBox("<spring:message code='alert.selectNone'/>")
			}
		}
		
		// 유효성 체크 후 insert 결과
		function fn_insertConfirm(data) {
			var jsOrdBplc = $("#searchBplcCode").val();
			var data = {};
			data.ordBplc = jsOrdBplc;
			
			comAjax('prdDtlListFrm', '/mn/prdInqire/insert.do', data, fn_insertCallBack);
		}
		
		//저장CallBack
		function fn_insertCallBack(data){
			var jsResult = data.insResult;
			
			if(Number(jsResult < 0)){
				alertBox("<spring:message code='alert.saveFailed'/>");
				return;
			}else{
				comSubmit('', '', '/mn/unDcsnOrd/page.do');
			}
		}
		
		/* 주문등록 버튼 클릭시 바로 insert되므로 confirmBox이용해서 수정
		// 유효성 체크 후 insert 결과
		function fn_insertCallBack(data) {
			var jsResult = data.insResult;
			
			if(Number(jsResult < 0 )){
				alertBox("<spring:message code='alert.saveFailed'/>");
				return;
			}else {
				yesBox('등록 성공, 이동하시겠습니까?', fn_trueFnc, fn_falseFnc, '');
			}
		}
		
		// '예' CallBack Method
		function fn_trueFnc(data){
			comSubmit('', '', '/mn/unDcsnOrd/page.do');
		}
		
		// '아니오' CallBack Method
		function fn_falseFnc(data){
			$( '#prdDtlTable > tbody:last').empty();
		} */
		
		</script>
	</head>
	<body>
		<div class="container">
			<div class="con_wrap_left">
				<h2 class="title">제품조회 및 주문접수</h2>
				<form id="searchFrm" name="searchFrm">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<strong>
									<a href="#this" class="under_line popOpen" data-popup="BPLC" title="<spring:message code='title.ordBplc' />">사업장</a>
								</strong>
								<div class="col">
									<span class="input_type w_70">
										<input type="text" id="searchBplcNm" data-search="BPLC" name="searchBplcNm" class="readOnly" style="text-align: left;" 
											placeholder="<spring:message code='search.bplc'/>" readonly="readonly">
										<input type="hidden" id="searchBplc" data-nm="BPLC" name="searchBplc">
										<input type="hidden" id="searchBplcCode" data-code="BPLC" name="searchBplcCode">
										<!-- <input type="hidden" data-codeSe="BPLC" name="searchBplcSe" value="Y"> -->
									</span>
								</div>
							</li>
							<li>
								<strong>
									<a href="#this" class="under_line popOpen" data-popup="DVRBCNC" title="<spring:message code='title.bcnc' />">거래처</a>
								</strong>
								<div class="col">
									<span class="input_type w_70">
										<input type="text" id="searchBcncNm" name="searchBcncNm" placeholder="<spring:message code='search.bcnc'/>" readonly="readonly">
										<input type="hidden" id="searchBcncCode" name="searchBcncCode">
									</span>
								</div>
							</li>		
							<li>
								<strong class="tit">주문기간</strong>
								<div class="col">
							    	<span class="sel_btn">
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt(-3);">최근 3개월</a>
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt(-1);">최근 1개월</a>
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt('ALL');">전체제품</a>
							    		<input type="hidden" name="rcvordDedt" value="${rcvordDedt}"><br>
							    	</span>
								</div>
							</li>
							<li>
								<strong>제품</strong>
								<div class="col">
									<span class="input_type w_70">
										<input type="text" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" size="50px"/>
									</span>
									<span class="btn_search w_20"><a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a></span>
									<input type="hidden" name="pg" value="1">
								    <input type="hidden" name="dlvyEntrps" id="dlvyEntrps" value="${dlvyView.DLVY_ENTRPS }">
								    <input type="hidden" id="adminSE" value="Y">
								    <input type="hidden" id="menuSe" value="PRDI">
								</div>
							</li>
						</ul>
					</div> <!-- //box_gray -->
				</form>
				
				<div class="tb-type01">
					<form id="listFrm" name="listFrm">
						<table>
							<colgroup>
								<col width="4%">
								<col width="40px">
								<col width="50px">
								<col width="*">
								<col width="40px">
								<col width="25px">
								<col width="40px">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<!-- <th><a href="#" onclick="javascript:fn_allChkBox('selectItem');"> * 선택</a></th> -->
									<th><a href="#" id="siBtn" onclick="javascript:fn_allChkBox(this, 'selectItem');"> * 선택</a></th>
									<th>제품코드</th>
									<th>제품</th>
									<th>규격</th>
									<th>단위</th>
									<th>단가</th>
								</tr>
							</thead>
							<tbody id="listBody"></tbody>
						</table>
					</form>
				</div> <!-- //tb-type01 -->
				<div class="btn_wrap t_r">
					<input type="hidden" name="totalCnt" value="${listTotalCnt}" >
					<a href="javascript:void(0);" id="moreBtn" class="btn_m btn_white" onclick="javascript:fn_listMore();"><b>더보기</b></a>
				</div>
				
			</div> <!-- //con_wrap_left -->
			
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" onclick="javascript:fn_prdReg();" class="btn_regist btn_l btn_dgray"><span>선택제품 <br>등록</span></a>
					<a href="#" onclick="javascript:fn_prdDel();" class="btn_delete btn_l btn_white"><span>선택제품 <br>삭제</span></a>
					<a href="#" class="btn_top btn_white"><span>TOP</span></a>
					<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
				</span>
			</div> <!-- 	// btn_fixed_wrap -->
		
			<div class="con_wrap_right" style="_display:none">
				<div class="box_gray">
					<ul class="srch_list">
						<%-- <fmt:parseDate  var="view_DEADLINE" value="${view.DEADLINE}" pattern="yyyyMMdd" />
						<fmt:formatDate var="DEADLINE" value="${view_DEADLINE}" pattern="yyyy-MM-dd" /> --%>
						<fmt:parseDate  var="view_DEADLINE" value="${deadLine.DEADLINE}" pattern="yyyyMMdd" />
						<fmt:formatDate var="DEADLINE" value="${view_DEADLINE}" pattern="yyyy-MM-dd" />
						<fmt:parseDate  var="view_MINDEADLINE" value="${minDeadLine}" pattern="yyyyMMdd" />
						<fmt:formatDate var="MINDEADLINE" value="${view_MINDEADLINE}" pattern="yyyy-MM-dd" />
						<fmt:parseDate  var="view_MAXDEADLINE" value="${maxDeadLine}" pattern="yyyyMMdd" />
						<fmt:formatDate var="MAXDEADLINE" value="${view_MAXDEADLINE}" pattern="yyyy-MM-dd" />
						<li>
							<strong>
								<label>
									<a href="#this" class="under_line popOpen" data-popup="DLVY" title="<spring:message code='title.dlvy' />">도착지업체</a>
								</label>
							</strong>
							<span class="input_type w_100">
								<input type="text" id="searchEntrpsNm" name="searchEntrpsNm" placeholder="<spring:message code='search.dlvyChoice'/>" value="${dlvyView.DLVY_ENTRPS_NM}" readonly="readonly"/>
								<input type="hidden" name="dlvyMon" id="dlvyDay01" title="<spring:message code='title.monday'/>" value="${dlvyView.DLVY_MON }"> 
					    		<input type="hidden" name="dlvyTue" id="dlvyDay02" title="<spring:message code='title.tuesday'/>" value="${dlvyView.DLVY_TUE }"> 
					    		<input type="hidden" name="dlvyWen" id="dlvyDay03" title="<spring:message code='title.wednesday'/>" value="${dlvyView.DLVY_WEN }"> 
					    		<input type="hidden" name="dlvyThur" id="dlvyDay04" title="<spring:message code='title.thursday'/>" value="${dlvyView.DLVY_THUR }"> 
					    		<input type="hidden" name="dlvyFri" id="dlvyDay05" title="<spring:message code='title.friday'/>" value="${dlvyView.DLVY_FRI }"> 
					    		<input type="hidden" name="dlvyDeCeck" id="dlvyDeCeck_0" value="${dlvyView.DLVY_DE_CECK }">
							</span>
							<strong>
								<a href="#">납기일자</a>
							</strong>
							<span class="input_type w_100" >
								<%-- <input type="text" id="itemDedt" name="itemDedt" value="${DEADLINE }" class="_datepick" onchange="javascript:fn_itemDedt(0);" maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/> --%>
								<input type="text" id="itemDedt" name="itemDedt" value="${DEADLINE }" data-dedt="${DEADLINE }" class="_datepick" onkeydown="javascript:fn_dedtKeydown(0);" onchange="javascript:fn_itemDedt(0);" maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
								<input type="hidden" name="DEADLINE" value="${MINDEADLINE }"/>
								<input type="hidden" id="itemDedtMaxDt" name="itemDedtMaxDt" value="${MAXDEADLINE}"/>
							</span>
						</li>
					</ul>
				</div><!-- //box_gray -->
				
				<ul class="impor_text">
					<c:if test="${subMenu.A_USE_AT eq 'Y' }">
						${subMenu.MENU_A}
					</c:if>
					<c:if test="${subMenu.B_USE_AT eq 'Y' }">
						${subMenu.MENU_B}
					</c:if>
				</ul>
				
				<div class="tb-type01">
					<form id="prdDtlListFrm" name="prdDtlListFrm">
						<table id="prdDtlTable">
							<colgroup>
								<col width="2%">
								<col width="40px">
								<col width="70px">
								<col width="45px">
								<col width="10%">
								
								<col width="55px">
								<col width="10%">
								<col width="50px">
								<col width="10%">
								<col width="40px">
								<col width="40px">
								
								<col width="50px">
								<col width="50px">
								<col width="25px">
								<col width="60px">
								<col width="7%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<!-- <th><a href="#" onclick="javascript:fn_allChkBox('selectPrdItem');" data-se="DTL">*삭제</a></th> -->
									<th><a href="#" id="spiBtn" onclick="javascript:fn_allChkBox(this, 'selectPrdItem');" data-se="DTL">*삭제</a></th>
									<th>납기일자</th>
									<th>거래처<br>코드</th>
									<th>거래처</th>
									
									<th>도착지<br>업체코드</th>
									<th>도착지<br>업체</th>
									<th>제품<br>코드</th>
									<th>제품</th>
									<th>수량<br>(BOX)</th>
									<th>중량<br>(KG)</th>
									
									<th>재고상태<br>(KG)</th>
									<th>단가</th>
									<th>단위</th>
									<th>금액</th>
									<th>비고</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</form>
				</div> <!-- //tb-type01 -->
				<div class="btn_wrap t_r">
					<a href="#" class="btn_m btn_dgray" onclick="javascript:fn_basketReg();"><b>등록</b></a>	
				</div>
			</div> <!-- // con_wrap_rigft -->
		
		</div> <!-- //container -->
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
</body>
<!-- </html> -->