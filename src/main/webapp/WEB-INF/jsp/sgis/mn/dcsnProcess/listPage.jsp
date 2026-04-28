<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript">
		var jsListUrl = "list.do";
		var jsPageUrl = "page.do";
		var jsMsg = "<spring:message code='alert.alertFocus'/>";
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		var jsMoreAt= "";
		var jsCheckBox = "N";
		
		$(document).ready(function(){
			fn_listMore();
			fn_indictLmtt();
		});
		
		// 체크박스 전체 선택 공통화로 진행할 function
		function fn_allChkBox(chkBoxNm){
			//selectItem
			//selectPrdItem
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
			var jsConfirm = $("#confirm").val();
			
			if (!gfn_isNull(jsListStartDt)) $("input[name=listStartDt]").val(jsListStartDt);
			if (!gfn_isNull(jsListPgNum)) $("input[name=pgNum]").val(jsListPgNum);
			if (!gfn_isNull(jsListTotalCnt)) $("input[name=totalCnt]").val(jsListTotalCnt);
			if (!gfn_isNull(jsConfirm)) $("input[name=confirm]").val(jsConfirm);
			
			$("#itemListStartDt").remove();
			$("#itemPgNum").remove();
			$("#listTotalCnt").remove();
			
			//확인, 미확인 구분
			//var jsTable
			if($("input[name=confirm]").val() =="N"){
				$(".tbRow_N").css("display","");
				$(".tbRow_Y").css("display","none");
				if($(".btn_delete").length < 1){
					$(".btn_fixed_wrap .btn_wrap").prepend('<a href="#" class="btn_delete btn_l btn_white" onclick="javascript:fn_delItem()"><span>선택제품 <br>삭제</span></a>');
					$(".btn_fixed_wrap .btn_wrap").prepend('<a href="#" class="btn_decide btn_l btn_dgray" onclick="javascript:fn_saveItem();"><span>선택제품 <br>확인</span></a>');
				}
			}else{
				$(".tbRow_N").css("display","none");
				$(".tbRow_Y").css("display","");
				$(".btn_delete").remove();
				$(".btn_decide").remove();
			}
			
			fn_tabAddOn();
			
			var listCnt = Number($("tr[class='UcItemRow']").length);
			var totalCnt = Number($("input[name=totalCnt]").val());
			
			if (totalCnt <= listCnt) {
				$("#moreBtn").hide();
			} else {
				$("#moreBtn").show();
			}
			
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
			var jsConfirm = $("input[name=confirm]").val();
			
			$(".tab_type li").removeClass("on");
			if(jsConfirm == "N"){
				$(".tab_type li").eq(0).addClass("on");
			}else{
				$(".tab_type li").eq(1).addClass("on");
			}
			
			//재고상태 표시 제한
			fn_indictLmtt();
		}
		
		//확인, 미확인 버튼
		function fn_confirm(str){
			jsMoreAt = "NOT";
			$("input[name=confirm]").val(str);// 탭종류
			$("input[name=listStartDt]").val(""); //초기화
			$("input[name=pg]").val(1); //초기화
			$("input[name=pgNum]").val(0); //초기화
			
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//선택제품 확인
		function fn_saveItem(){
			var jsChkItem = $("input:checkbox[name=selectItem]:checked").length;
			
			if(Number(jsChkItem) < 1){
				alertBox("<spring:message code='alert.selectNum'/>");
				return;
			}else{
				confirmBox("<spring:message code='confirm.itemSave'/>", fn_saveItemConfirm, 'listFrm');
			}
		}
		
		//재고상태 표시 제한
		function fn_indictLmtt(){
			var jsTbody = $("#listBody");
			var jsUcItemRow = $(jsTbody).find("tr.UcItemRow");
			var jsAmRow = $(jsTbody).find("tr.UcAmountRow");
			var jsIvColor = $("input[name=IV_COLOR]"); //재고상태 색상값
			var qySm = 0;
				
			//탭 구분
			var jsConfirm = $("input[name=confirm]").val();
			
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
			
			if(jsConfirm == "N"){
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
					
				});
				
				
				//그룹합계 행 체크
				$(jsAmRow).each(function(idx){
						if($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("input[name=AM_W_DEDT]").val().replace(/-/gi, "") < jsNowDate){
						fn_findDedt($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("input[name=AM_W_DEDT]").val());
					}
				});
			}
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
		
		//confirm 저장
		function fn_saveItemConfirm(){
			comAjax('listFrm', '/mn/dcsnProcess/update.do', '', fn_saveItemCallBack);
		}
		
		//저장CallBack
		function fn_saveItemCallBack(data){
			var jsResult = data.result;
			
			if(!jsResult){
				if(!gfn_isNull(data.resultMsg)){
					alertBox(data.resultMsg);	
				}
			}else{
				comSubmit('','',jsPageUrl);
			}
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
			comAjax('listFrm', '/mn/dcsnProcess/delete.do', '', fn_delItemCallBack);
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
				// ** 2019.11 전체선택 누적 조건문 추가
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
			<h2 class="title">주문확정처리</h2>
			
			<form id="searchFrm" name="searchFrm" method="POST">
				<input type="hidden" name="pg" value="1" />
				<input type="hidden" name="pgNum" value="0" />
				<input type="hidden" name="listStartDt" value="${listStartDt }"/>
				<input type="hidden" name="totalCnt"/>
				<input type="hidden" name="confirm" value="N">
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
								<div class="col w_90">
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
						<a href="#" onclick="javascript:fn_confirm('N');">미확인</a>
					</li>
					<li>
						<a href="#" onclick="javascript:fn_confirm('Y');">확인</a>
					</li>
				</ul>
			</form>
			
			<form id="listFrm" name="listFrm">
				<div id="tab-1" class="tab_con_wrap on">
					<div class="tb-type01">
						<table>
							<colgroup class="tbRow_Y">
								<col width="4%">
								<col width="60px">
								<col width="40px">
								<col width="10%">
								<col width="40px">
								<col width="10%">
								<col width="40px">
								<col width="10%">
								<col width="40px">
								<col width="40px">
								<col width="25px">
								<col width="40px">
								<col width="60px">
								<col width="10%">
							</colgroup>	
							<colgroup class="tbRow_N" style="display:none;">	
								<col width="45px">
								<col width="40px">
								<col width="60px">
								<col width="40px">
								<col width="12%">
								<col width="50px">
								<col width="12%">
								<col width="40px">
								<col width="12%">
								<col width="40px">
								<col width="40px">
								<col width="40px">
								<col width="80px">
								<col width="40px">
								<col width="25px">
								<col width="60px">
								<col width="*">
							</colgroup>
							<thead>
								<tr class="tbRow_Y">
									<th>NO</th>
									<th>납기일자</th>
									<th>거래처<br>코드</th>
									<th style="min-width:100px;">거래처</th>
									<th>도착지<br>업체코드</th>
									<th style="min-width:100px;">도착지<br>업체</th>
									<th>제품<br>코드</th>
									<th style="min-width:100px;">제품</th>
									<th>규격</th>
									<th>수량</th>
									<th>단위</th>
									<th>단가</th>
									<th>금액</th>
									<th>비고</th>
								</tr>
								<tr class="tbRow_N" style="display:none;">
									<th style="min-width:45px;"><a href="#" onclick="javascript:fn_allChkBox('selectItem');">*선택</a></th>
									<th style="min-width:40px;">등록<br>구분</th>
									<th style="min-width:60px;">납기일자</th>
									<th>거래처<br>코드</th>
									<th style="min-width:100px;">거래처</th>
									<th>도착지<br>업체코드</th>
									<th style="min-width:100px;">도착지<br>업체</th>
									<th>제품<br>코드</th>
									<th style="min-width:100px;">제품</th>
									<th>규격</th>
									<th style="min-width:40px;">수량<br>(BOX)</th>
									<th style="min-width:40px;">중량<br>(KG)</th>
									<th style="min-width:80px;">재고상태<br>(KG)</th>
									<th>단가</th>
									<th>단위</th>
									<th>금액</th>
									<th style="min-width:100px;">비고</th>
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
