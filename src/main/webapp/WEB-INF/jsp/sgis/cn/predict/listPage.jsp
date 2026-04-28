<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
			var jsListUrl = "list.do";
			var jsPageUrl = "page.do";
			var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
			var jsMsgDecimalsError = "<spring:message code='alert.decimalsError'/>";
			
			$(document).ready(function(){
				fn_listMore();
			});
			
			function fn_listMore(){
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//구간 readonly
			function fn_sectionReadonly(){
				var jsSysDD = $("input[name=sysDD]");// 오늘날짜기준 - 일
				var jsSysYYMM = $("input[name=sysYYMM]");// 오늘날짜기준 - 년월
				var jsNoteLength = $("input[name=W_NOTE]").length;// 전체행개수
				var jsDcsnWt1 = $("input[name=W_DCSNWT1]");// 확정수량
				var jsDcsnWt2 = $("input[name=W_DCSNWT2]");
				var jsDcsnWt3 = $("input[name=W_DCSNWT3]");
				var jsDedt = $("input[name=W_DEDT]");// 검색한 년월
				
				//비고칸 개수로 for문
				for(var idx=0; idx<jsNoteLength; idx++){
					if(1 <= jsSysDD.val() && jsSysDD.val() <= 10){
					/*오늘 기준으로 날짜가 조건사이경우에서 년월이 같은경우에만 readonly idx번째의 확정1, 확정2*/
						if(jsSysYYMM.val() == jsDedt.eq(idx).val()){
							jsDcsnWt1.eq(idx).parent().css("border","0px");
							jsDcsnWt2.eq(idx).parent().css("border","0px");
							jsDcsnWt1.eq(idx).attr("readonly", "readonly");
							jsDcsnWt2.eq(idx).attr("readonly", "readonly");
							jsDcsnWt1.eq(idx).addClass("readOnly");
							jsDcsnWt2.eq(idx).addClass("readOnly");
						}
					}else if(11 <= jsSysDD.val() && jsSysDD.val() <= 20){
					/*오늘 기준으로 날짜가 조건사이경우에서 년월이 같은경우에만 readonly idx번째의 확정1, 확정2, 확정3*/
						if(jsSysYYMM.val() == jsDedt.eq(idx).val()){
							jsDcsnWt1.eq(idx).parent().css("border","0px");
							jsDcsnWt2.eq(idx).parent().css("border","0px");
							jsDcsnWt3.eq(idx).parent().css("border","0px");
							jsDcsnWt1.eq(idx).attr("readonly", "readonly");
							jsDcsnWt2.eq(idx).attr("readonly", "readonly");
							jsDcsnWt3.eq(idx).attr("readonly", "readonly");
							jsDcsnWt1.eq(idx).addClass("readOnly");
							jsDcsnWt2.eq(idx).addClass("readOnly");
							jsDcsnWt3.eq(idx).addClass("readOnly");
						}
					}else{
					/*오늘 기준으로 날짜가 조건사이경우에서 년월이 같은경우에만 readonly idx번째의 확정1, 확정2, 확정3, 다음년월의 확정1*/
						if(jsSysYYMM.val() == jsDedt.eq(idx).val()){
							jsDcsnWt1.parent().css("border","0px");
							jsDcsnWt2.eq(idx).parent().css("border","0px");
							jsDcsnWt3.eq(idx).parent().css("border","0px");
							jsDcsnWt1.attr("readonly", "readonly");
							jsDcsnWt2.eq(idx).attr("readonly", "readonly");
							jsDcsnWt3.eq(idx).attr("readonly", "readonly");
							jsDcsnWt1.addClass("readOnly");
							jsDcsnWt2.eq(idx).addClass("readOnly");
							jsDcsnWt3.eq(idx).addClass("readOnly");
						}
					}
				}
			}
			
			//조회
			function fn_searchList(){
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//조회Callback
			function fn_listCallBack(data){
				$("#listBody").html(data).trigger("create");
				$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
				$("input[name=totalCnt]").val($("input[name=listTotalCnt]").val());
				$("input[name=listTotalCnt]").remove();
				fn_sectionReadonly(); // 구간 readonly
			}
			
			//저장
			function fn_saveItem(){
				if($("#listFrm .UcItemRow").length < 1){
					return;
				}else{
					confirmBox("<spring:message code='confirm.save'/>", fn_saveItemConfirm, 'listFrm');
				}
			}
			
			//confirm 저장
			function fn_saveItemConfirm(){
				//수량 유효성검사
				var jsRowLength = $("input[name=W_NOTE]").length;
				var jsValidChk = true;
				for(var row=0; row<jsRowLength; row++){
					for(var col=1; col<4; col++){
						if(typeof $("#W_DCSNWT"+row+col).attr("readonly") == "undefined"){
							jsValidChk = fn_quanChk($("#W_DCSNWT"+row+col), $("input[name=UPC_UNTPCUNIT]").eq(row).val());
							$("#updateYn"+row+col).val("Y");
						}
						if(!jsValidChk) return false;
					}
				}
				if(jsValidChk){
					comAjax('listFrm', '/predict/update.do', '', fn_saveItemCallBack);
				}
			}
			
			//저장CallBack
			function fn_saveItemCallBack(data){
				var jsResult = data.udtResult;
				
				if(Number(jsResult < 0)){
					alertBox("<spring:message code='alert.saveFailed'/>");
				}else{
					comSubmit('', '', jsPageUrl);
				}
			}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="con_wrap_one">
				<h2 class="title">수요 예측</h2>
				<form id="searchFrm" name="searchFrm" method="POST">
					<input type="hidden" name="pg" value="1">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<strong class="tit w_10">제품</strong>
								<div class="col w_90">
									<span class="input_type w_85">
										<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" maxlength="40"/>
									</span>
									<span class="btn_search w_10">
										<a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a>
									</span>
								</div>
							</li>
						</ul>
					</div>
					<!-- //box_gray -->
				</form>
				
				<ul class="impor_text">
					<c:if test="${subMenu.A_USE_AT eq 'Y' }">
						${subMenu.MENU_A}
					</c:if>
					<c:if test="${subMenu.B_USE_AT eq 'Y' }">
						${subMenu.MENU_B}
					</c:if>
				</ul>
				
				<form id="listFrm" name="listFrm">
					<div class="tb-type01">
						<table>
							<colgroup>
								<col width="4%">
								<col width="6%">
								<col width="*">
								<col width="6%">
								<col width="4%">
								<col width="6%">
								<col width="6%">
								<col width="6%">
								<col width="6%">
								<col width="6%">
								<col width="6%">
								<col width="14%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th style="min-width:60px;">년월</th>
									<th style="min-width:180px;">제품</th>
									<th style="min-width:40px;">규격</th>
									<th style="min-width:30px;">단위</th>
									<th style="min-width:60px;">01~10일<br>예상중량</th>
									<th style="min-width:60px;">01~10일<br>확정중량</th>
									<th style="min-width:60px;">11~20일<br>예상중량</th>
									<th style="min-width:60px;">11~20일<br>확정중량</th>
									<th style="min-width:60px;">21~말일<br>예상중량</th>
									<th style="min-width:60px;">21~말일<br>확정중량</th>
									<th style="min-width:120px;">비고</th>
								</tr>
							</thead>
							<tbody id="listBody"></tbody>
						</table>
					</div>
					<!-- // tb-type01 -->
				</form>
			</div>
			<!-- // con_wrap_one -->
			
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" id="saveBtn" class="btn_save btn_l btn_red" onclick="javascript:fn_saveItem();"><span>저장</span></a>
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
