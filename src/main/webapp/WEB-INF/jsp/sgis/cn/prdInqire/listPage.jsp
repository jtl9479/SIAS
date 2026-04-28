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
		
		//해당 납기일이 아닌데  제품등록을 할 경우 (Y:유효하지 않은 납기일자, N:정상납기일자)
		var jsDedtChk = "N";
	
		$(document).ready(function(){
			$("input[name=pg]").val(1);
			
			fn_listMore();
			fn_popNotice();
			fn_dateInit();
		});
		
		function fn_popNotice(){
			var jsNoticeCn = $("#noticeCn").text();
			$("#noticeCn").html(jsNoticeCn);
			if ($.cookie("popNotice") != "Y") {  //쿠키 값이 Y가 아니면(체크하지 않았다면)
				$("#popNotice").show();
			}
			$(".closeBtn").on("click", function(e){
				e.preventDefault();
				if($("input[name=popStop]").is(":checked")){
					var date = new Date();
					date.setTime(date.getTime() + 24*60*60*1000); // 60분설정
					$.cookie("popNotice", "Y", { expires: date });
				}
				$("#popNotice").hide();
			});
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
		
		// 납기일자 체크
		function fn_itemDedt(idx){
			var jsDeadLine = $("input[name=DEADLINE]");//최소납기일자
			var jsItemDedt = $("input[name=itemDedt]").eq(idx);//납기일자
			
			var validChk = fn_validDedt(jsItemDedt);
			var jsAlertDay = "";
			
			if(!validChk){
				$("input[name=itemDedt]").eq(idx).val(jsDeadLine.val());
				return false;
			}else{
				if(gfn_dtReplace(jsItemDedt) < gfn_dtReplace(jsDeadLine)){// 납기일자가 최소납기일자 이전경우
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/><br><br>"+jsDeadLine.val()+" 이후 입력가능합니다.", jsItemDedt);
					$("input[name=itemDedt]").eq(idx).val(jsDeadLine.val());
					return false;
				}else if(gfn_dtReplace(jsItemDedt) > gfn_dtReplace($("input[name=maxItemDedt]"))){
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", jsItemDedt)
					$("input[name=itemDedt]").eq(idx).val(jsDeadLine.val());
					return false;
				}
				var jsHolidayValid = true;
				//공휴일 확인
				$("input[name=CLDR_DEDT]").each(function(idx){
					jsHoliday = $("input[name=CLDR_DEDT]").eq(idx).val();
					if(gfn_dtReplace($("input[name=itemDedt]").eq(idx)) == jsHoliday){
						jsHolidayValid = false;
					}
				});
				if(!jsHolidayValid){
					alertBoxFocus("배송휴무일 입니다.", jsItemDedt);
					$("input[name=itemDedt]").eq(idx).val(jsDeadLine.val());
					return false;
				}
				var jsGetDay = new Date($("input[name=itemDedt]").eq(idx).val()).getDay();//요일값
				if(jsGetDay == "0" || jsGetDay == "6"){
					alertBoxFocus("<spring:message code='title.itemDt'/><spring:message code='alert.alertFocus'/>", jsItemDedt);
					$("input[name=itemDedt]").eq(idx).val(jsDeadLine.val());
					return false;
				}
				if(typeof fn_itemDlvyDay =='function'){//함수 존재여부
					jsAlertDay = fn_itemDlvyDay(idx);
					if(!gfn_isNull(jsAlertDay)){ //공백이 아닐경우
						alertBoxFocus("<spring:message code='alert.deCeckValid'/><br><br>"+jsAlertDay, jsItemDedt);
						jsDedtChk = "Y";						
						return false;
					}else {
						jsDedtChk = "N";
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
			$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
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
		
		//납기일자 선택 조건 제한
		function fn_dateInit(){
			//+1일부터
			var date = new Date(); 
			var newdate = new Date(date); 
			newdate.setDate(newdate.getDate()); 
			
			var jsMinDtFrom = new Date(newdate).toISOString().split("T")[0];
			
			//+60일까지
			newdate.setDate(newdate.getDate() + 60);
			var jsMaxDtTo = new Date(newdate).toISOString().split("T")[0];			
			
			$("._datepick").datepicker("option", "minDate", jsMinDtFrom);
			$("._datepick").datepicker("option", "maxDate", jsMaxDtTo);
			$("input[name=maxItemDedt]").val(jsMaxDtTo);
		}
		
		//keydown이벤트 jquery-ui.js 보다 먼저실행하기위해 설정
		function fn_dedtKeydown(){
			if(event.keyCode == 13){
				fn_itemDedt(0);
			}
		}
		
		// 선택제품등록
		function fn_prdReg(){
			var jsChkItem = $("input:checkbox[name=selectItem]:checked").length
			
			if(Number(jsChkItem) < 1){
				alertBox("<spring:message code='alert.selectNum'/>");
				return;
			}else {
				var jsValid=false;
				var dlvyChk = $("#searchEntrpsNm");
				
				if(jsDedtChk == 'N'){ 
					jsValid=true; 
				} else {
					alertBox("유효하지 않은 납기일자입니다.");
					return;
				}
				
				if(dlvyChk.val() != null && dlvyChk.val().length > 0){ 
					jsValid=true; 
				} else {
					alertBox("<spring:message code='title.dlvy'/>" + "<spring:message code='alert.alertFocus'/>");
					return;
				}
				
				if(jsValid){
					comAjax('listFrm', '/prdInqire/prdInfo.do', '', fn_prdRegCallBack);
				}
			}
		}
		
		// 선택제품등록 Callback
		function fn_prdRegCallBack(data){
			var jsAddRow = "";
			var jsEntrpsNm = $("#searchEntrpsNm").val(), 
				jsDlvyEntrps = $("#dlvyEntrps").val(),
				jsItemDedt = $("#itemDedt").val();
			
			//comma 찍어주기
			var jsCommaVal="";
			
			//업체전용, 생산 구분추가를 위한 변수
			var jsAddBlind="<td class='left'> <span class='type_wrap'>";
			
			$.each(data, function(idx, value) {
				var $table = $("#prdDtlTable");
				var jsTrIdx = $table.find("tbody:last").find("tr").length,
					jsAddIdxNum = (Number(jsTrIdx)+1);
				
				if(value.IC_ENT_DVR_SE == 2){
					jsAddBlind = jsAddBlind + "<i class='common'><em class='blind'>전용</em></i>";		
				}
				if(value.IC_PRDCTN_SE == 2){
					jsAddBlind = jsAddBlind + "<i class='only'><em class='blind'>주문생산</em></i>";
				}
				jsAddBlind = jsAddBlind +"</span> ";
				
				jsCommaVal = fn_comma(value.UPC_NEWUNITPC);
				
				jsAddRow = "<tr>";
				jsAddRow += "<td>";
				 jsAddRow += "<span>"+jsAddIdxNum+"</span>";
				 jsAddRow += "<input type='hidden' name='basketIcCode' value='"+value.IC_CODE+"'/>";
				 jsAddRow += "<input type='hidden' name='UPC_VATINCLSAT' value='"+value.UPC_VATINCLSAT+"'/>";
				 jsAddRow += "<input type='hidden' name='UPC_BPLC' value='"+value.UPC_BPLC+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_UNITWT' value='"+value.IC_UNITWT+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_UNITQY' value='"+value.IC_UNITQY+"'/>";
				 jsAddRow += "<input type='hidden' name='IC_PACKNGUNIT' value='"+value.IC_PACKNGUNIT+"'/>";
				 jsAddRow += "<input type='hidden' name='W_SPLPCAM' />";
				 jsAddRow += "<input type='hidden' name='W_VAT' />";
				 jsAddRow += "<input type='hidden' name='W_PIECE_QY' />";
				 jsAddRow += "<input type='hidden' name='W_GRP_QY' />";
				jsAddRow += "</td>";
				jsAddRow += "<td>"+"<input type='checkbox' id='selectPrdItem_"+jsLastIdNum+"' name='selectPrdItem' onclick='javascript:fn_selectChk(this,"+idx+");'/>"+"<label for='selectPrdItem_"+jsLastIdNum+"'></label>"+"</td>";
				jsAddRow += jsAddBlind + value.IC_NM+"</td>";
				jsAddRow += "<td>"+value.IC_STNDRD+"</td>";
				jsAddRow += "<td>"+"<span class='input_type'>"+"<input type='text' name='W_QUANTITY' style='width:100%; text-align:center;' class='input_type' title='<spring:message code='title.quantity'/>' data-fcs='QY' onfocus='this.select()' onchange='javascript:fn_quanChk(this,1);'/>";
				 jsAddRow += "<input type='hidden' name='UPC_NEWUNITPC' value='"+jsCommaVal+"' style='width:100%;' class='readOnly' readonly='readonly' />";
				 jsAddRow += "<input type='hidden' name='UPC_UNTPCUNIT' value='"+value.UPC_UNTPCUNIT+"'/>";
				 jsAddRow += "<input type='hidden' name='UPC_UNIT_CHRCTR' value='"+value.UPC_UNIT_CHRCTR+"'/>";
				jsAddRow += "</span>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='W_WT' class='t_c readOnly' style='width:60px;' readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='W_SUMAMOUNT' class='t_c readOnly' style='width:60px;' readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' name='W_DEDT' class='t_c readOnly' value='"+jsItemDedt+"' style='width:60px;'  readonly='readonly'/>"+"</td>";
				jsAddRow += "<td>"+"<input type='text' value='"+jsEntrpsNm+"' class='readOnly' readonly='readonly'/>"+"<input type='hidden' name='dlvyEntrps' value='"+jsDlvyEntrps+"'/>"+"</td>";
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
				jsTr.eq(i).find("input[name=W_QUANTITY]").data("row", i);
				jsTr.eq(i).find("input[name=W_QUANTITY]").attr("onchange","fn_quanChk(this,1)");
			}
			
			$("#siBtn").attr("onclick", "fn_allChkBox(this, 'selectItem')");
			$("#spiBtn").attr("onclick", "fn_allChkBox(this, 'selectPrdItem')");
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
		
		// 장바구니 등록
		function fn_basketReg(){
			var jsValidChk = true;
			var jsMsg = "<spring:message code='title.quantity'/>"+"<spring:message code='alert.alertFocus'/>";
			/* var jsChkItem = $("input:checkbox[name=selectPrdItem]:checked"),
			jsChkLen=jsChkItem.length; */
			
			if($("#dlivyStopAt").val() == '1'){
				alertBox("관리자에게 문의해주세요.");
				return false;
			}

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
							jsValidChk = fn_quanChk($(dom),1);
							if(!jsValidChk) {
								return false;
							}
						}
					});
				});
				
				if(jsValidChk){
					confirmBox('주문 등록 하시겠습니까?', fn_insertConfirm, 'prdDtlListFrm');
					//comAjax('prdDtlListFrm', '/prdInqire/insert.do', '', fn_insertCallBack);//yesBox이용시
				}
			}else {
				alertBox("<spring:message code='alert.selectNone'/>")
			}
		}
		
		// 유효성 체크 후 insert 결과
		function fn_insertConfirm(data) {
			var jsBilLmt = '<c:out value="${sessionScope.sess_bilLmt}"/>'; //어음한도
			var jsCrdtLmt = '<c:out value="${sessionScope.sess_crdtLmt}"/>'; //외상한도
			var jsSumAM =0; //주문합계
			var jsFrm =$("#prdDtlListFrm");
			
			$.each(jsFrm, function(index, frmObj) {
				$.each(frmObj, function(idx, dom){
					if($(dom).attr("name") == "W_SUMAMOUNT"){
						jsSumAM += Number(fn_uncomma($(dom).val()));
					};
				});
			});
			
			jsSumAM =  jsSumAM + Number(jsCrdtLmt);
			if(Number(jsBilLmt) == '1' ){
				var jsUnColectMoneyAm = '<c:out value="${sessionScope.sess_unColectMoneyAm}"/>'; //미수금액
				jsSumAM =  jsSumAM + Number(jsUnColectMoneyAm);
				if(Number(jsCrdtLmt) < Number(jsSumAM)){
					alert("미수금이 존재하여 주문하실 수 없습니다. <br/> 관리자에게 문의해주세요.");
					return false;
				}
			}
			
			comAjax('prdDtlListFrm', '/prdInqire/insert.do', '', fn_insertCallBack); //원본
		}
		
		//저장CallBack
		function fn_insertCallBack(data){
			var jsResult = data.insResult;
			
			if(Number(jsResult < 0)){
				alertBox("<spring:message code='alert.saveFailed'/>");
				return;
			}else{
				comSubmit('', '', '/ordMod/page.do');
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
			comSubmit('', '', '/ordMod/page.do');
		}
		
		// '아니오' CallBack Method
		function fn_falseFnc(data){
			//$( '#prdDtlTable > tbody:last').empty();
		}*/
		
		</script>
	</head>
	<body>
		<div class="container">
			<div class="con_wrap_left">
				<h2 class="title">제품 조회 및 주문 등록</h2>
				<form id="searchFrm" name="searchFrm">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<strong class="tit">주문기간</strong>
								<div class="col">
							    	<span class="sel_btn">
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt(-3);">최근 3개월</a>
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt(-1);">최근 1개월</a>
							    		<a href="#" class="btn_s btn_gray" onclick="javascript:fn_rcvordDedt('ALL');">전체</a>
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
								    <input type="hidden" name="dlvyEntrps" id="dlvyEntrps" value="${dlvyView.ENTRPS_CODE }">
   								    <input type="hidden" name="dlivyStopAt" id="dlivyStopAt" value="${sessionScope.sess_dlivyStopAt}">
								</div>
							</li>
						</ul>
					</div> <!-- //box_gray -->
				</form>
				
				<div class="tb-type01">
					<form id="listFrm" name="listFrm">
						<table>
							<colgroup>
								<col width="5%">
								<col width="10%">
								<col width="*">
								<col width="15%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th><a href="#" id="siBtn" onclick="javascript:fn_allChkBox(this, 'selectItem');"> * 선택</a></th>
									<th>제품</th>
									<th>규격</th>
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
						<fmt:parseDate  var="dlvyView_DEADLINE" value="${dlvyView.DEADLINE}" pattern="yyyyMMdd" />
						<fmt:formatDate var="DEADLINE" value="${dlvyView_DEADLINE}" pattern="yyyy-MM-dd" />   
						<li>
							<strong>
								<label>
									<a href="#this" class="under_line popOpen" data-popup="DLVY" title="<spring:message code='title.dlvy' />">도착지업체</a>
								</label>
							</strong>
							<span class="input_type w_100">
								<input type="text" id="searchEntrpsNm" name="searchEntrpsNm" placeholder="<spring:message code='search.dlvyChoice'/>" value="${dlvyView.DLVY_ENTRPS_NM}"/>
								<input type="hidden" name="dlvyMon" id="dlvyDay01" title="<spring:message code='title.monday'/>" value="${dlvyView.DLVY_MON }"> 
					    		<input type="hidden" name="dlvyTue" id="dlvyDay02" title="<spring:message code='title.tuesday'/>" value="${dlvyView.DLVY_TUE }"> 
					    		<input type="hidden" name="dlvyWen" id="dlvyDay03" title="<spring:message code='title.wednesday'/>" value="${dlvyView.DLVY_WEN }"> 
					    		<input type="hidden" name="dlvyThur" id="dlvyDay04" title="<spring:message code='title.thursday'/>" value="${dlvyView.DLVY_THUR }"> 
					    		<input type="hidden" name="dlvyFri" id="dlvyDay05" title="<spring:message code='title.friday'/>" value="${dlvyView.DLVY_FRI }"> 
					    		<input type="hidden" name="dlvyDeCeck" id="dlvyDeCeck_0" value="${dlvyView.DLVY_DE_CECK }">
					    		<!-- 공휴일 -->
								<c:forEach items="${holidayList }" var="day" varStatus="status">
									<input type="hidden" name="CLDR_DEDT" value="${day.CLDR_DEDT}">
								</c:forEach>
							</span>
							<strong>
								<a href="#">납기일자</a>
							</strong>
							<span class="input_type  w_100" >
								<input type="text" id="itemDedt" name="itemDedt" value="${DEADLINE }" class="_datepick" onkeydown="javascript:fn_dedtKeydown();" onchange="javascript:fn_itemDedt(0);" maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
								<input type="hidden" name="DEADLINE" value="${DEADLINE }"/>
								<input type="hidden" name="maxItemDedt" />
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
						<table id="prdDtlTable" style="table-layout:fixed;">
							<colgroup>
								<col width="5%">
								<col width="5%">
								<col style="min-width: 80px;" >
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="15%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th><a href="#" id="spiBtn" onclick="javascript:fn_allChkBox(this, 'selectPrdItem');" data-se="DTL">*삭제</a></th>
									<th>제품</th>
									<th>규격</th>
									<th>수량(BOX)</th>
									<th>중량(KG)</th>
									<th>금액</th>
									<th>납기일자</th>
									<th>도착지업체</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</form>
				</div> <!-- //tb-type01 -->
				<div class="btn_wrap t_r">
					<a href="#" class="btn_m btn_dgray" onclick="javascript:fn_basketReg();"><b>주문등록</b></a>	
				</div>
			</div> <!-- // con_wrap_rigft -->
		
		</div> <!-- //container -->
		<c:if test="${!empty requestScope.noticeView }">
			<div class="popup_wrap" id="popNotice" style="display:none"><!-- popup 오픈시 html,body에 overflow:hidden --> 
				<div class="popup_con" style="width:540px">
					<h1 class="pop_tit"><c:out value="${noticeView.NOTICETITLE}"></c:out></h1>
					<a href="javascript:void(0);" class="btn_close closeBtn" ><span class="blind">닫기</span></a>
					<div class="popup_con_in">
						<p id="noticeCn"><c:out value="${noticeView.NOTICECN}"></c:out></p>
						<!-- 
						<ul class="impor_text">
							<li></li>
						</ul> -->
						<div class="close_text">
							<input type="checkbox" name="popStop" id="close_pop" value="N"><label for="close_pop">&nbsp; 오늘하루 다시보지 않음.</label>
							<a href="javascript:void(0);" class="btn_s btn_white closeBtn">닫기</a>
						</div>
					</div>
				</div>
			</div>
		</c:if>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
</body>
<!-- </html> -->