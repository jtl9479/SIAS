<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html>
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>
	<script type="text/javascript">
		var jsCharChk = true;
		var jsAnsChk = true;
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		
		// 내용 글자수 제한
		function fn_cnChk(obj){
			var text = $(obj).val();
			var jsObjId = $(obj).attr("id");
			if(jsObjId == "WI_CN"){
				if(fn_getTextLength(text) < 5001){ //글자수 제한 5000바이트 까지
					jsCharChk = true;
				}else{
					jsCharChk = false;
				}
				return jsAnsChk;
			}else{ // 답변
				if(fn_getTextLength(text) < 5001){ //글자수 제한 5000바이트 까지
					jsAnsChk = true;
				}else{
					jsAnsChk = false;
				}
				return jsAnsChk;
			}
		}
		
		// 바이트 계산
		function fn_getTextLength(str) {
			var len = 0;
			for (var i = 0; i < str.length; i++) {
				if (escape(str.charAt(i)).length == 6) {
					len++;
				}else if(str.charAt(i) == "\n"){
					len++;
				}
				len++;
			}
			return len;
		}
		
		// 등록
		function fn_qnaSave(){
			confirmBox("<spring:message code='confirm.qnaInsert'/>", fn_qnaSaveConfirm, 'listFrm');
		}
		
		//confirm 저장
		function fn_qnaSaveConfirm(){
			var jsBcncNm = $("input[name=searchBcncNm]");
			var jsQnaWrter = $("input[name=WI_BCNCWRTER]");
			var jsQnaTitle = $("input[name=WI_TITLE]");
			var jsQnaCn = $("#WI_CN");
			var jsAnswerCn = $("#WI_ANSWER");
			
			if(gfn_isNull(jsBcncNm.val())){//거래처 공백 확인
				alertBoxFocus(jsBcncNm.attr("title") + jsMsgAlertFocus, jsBcncNm);
				return false;
			}
			/* if(gfn_isNull(jsQnaWrter.val())){//작성자 공백 확인
				alertBoxFocus(jsQnaWrter.attr("title") + jsMsgAlertFocus, jsQnaWrter);
				return false;
			} */
			if(gfn_isNull(jsQnaTitle.val())){//제목 공백 확인
				alertBoxFocus(jsQnaTitle.attr("title") + jsMsgAlertFocus, jsQnaTitle);
				return false;
			}
			if(!jsCharChk){//내용 공백확인
				alertBoxFocus(jsQnaCn.attr("title") + jsMsgAlertFocus, jsQnaCn);
				return false;
			}
			if(!jsAnsChk){//답변 공백확인
				alertBoxFocus(jsAnswerCn.attr("title") + jsMsgAlertFocus, jsAnswerCn);
				return false;
			}
			
			comAjax('listFrm','/mn/qna/ins.do','',fn_qnaSaveCallBack);
		}
		
		//등록CallBack
		function fn_qnaSaveCallBack(data){
			var jsResult = data.resultCnt;
			
			if(jsResult > 0){
				comSubmit('','','page.do');
			}else{
				alertBox("<spring:message code='alert.saveFailed'/>");
			}
		}
		
		//이전으로
		function fn_back() {
			comSubmit('', '', 'page.do');
		}
	</script>
</head>
<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">Q & A</h2>
			
			<form id="listFrm" name="listFrm">
				<div class="tb-type01 write">
					<table>
						<colgroup>
							<col width="15%">
							<col width="*">
						</colgroup>
					<tbody>
						<tr>
							<th>진행상태</th>
							<td class="left">
								<select name="WI_PROGRSSE" id="WI_PROGRSSE">
									<option value="A">미확인</option>
									<option value="B">확인중</option>
									<option value="C">확인완료</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>
								<strong class="tit w_30">
									<a href="#this" class="under_line popOpen" data-popup="BCNC" title="<spring:message code='title.bcnc' />">거래처</a>
								</strong>
							</th>
							<td class="left">
								<span class="input_type w_30 readOnly">
									<input type="text" id="searchBcncNm" data-search="BCNC" name="searchBcncNm" class="readOnly" style="text-align:left;" title="<spring:message code='title.bcnc' />" placeholder="<spring:message code='search.bcnc'/>" readonly="readonly">
									<input type="hidden" id="searchBcnc" data-nm="BCNC" name="searchBcnc">
									<input type="hidden" id="searchBcncCode" data-code="BCNC" name="searchBcncCode">
								</span>
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td class="left">
								<span class="input_type w_30">
									<input type="text" name="WI_BCNCWRTER" title="<spring:message code='title.wrter'/>" placeholder="성명을 입력해주세요." maxlength="25">
								</span>
							</td>
						</tr>
						<tr>
							<th>등록일</th>
							<td class="left">
								<c:out value="${rgsDe }"/>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td class="left">
								<span class="input_type w_100">
									<input type="text" name="WI_TITLE" title="<spring:message code='title.noticeTitle'/>" placeholder="제목을 입력해주세요." maxlength="100">
								</span>
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td class="left">
								<span class="input_type_textarea w_100">
									<textarea name="WI_CN" id="WI_CN" form="listFrm" style="height:180px;" title="<spring:message code='title.noticeCn'/>" placeholder="내용을 입력해주세요." onkeyup="javascript:fn_cnChk(this);"></textarea>
								</span>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
				<!-- // tb-type01 -->
				<!-- 답변 테이블 -->
				<div class="tb-type01 write">
					<table>
						<colgroup>
							<col width="15%">
							<col width="*">
						</colgroup>
					<tbody>
						<tr>
							<th>답변자</th>
							<td class="left">
								<c:out value="${registerNM }"></c:out>
							</td>
						</tr>
						<tr>
							<th>답변</th>
							<td class="left">
								<span class="input_type_textarea w_100">
									<textarea name="WI_ANSWER" id="WI_ANSWER" form="listFrm" style="height:100px;" title="<spring:message code='title.noticeCn'/>" placeholder="내용을 입력해주세요." onkeyup="javascript:fn_cnChk(this);"></textarea>
								</span>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
			</form>
		</div>
		<!-- // con_wrap_one -->
	
		<div class="btn_fixed_wrap">
			<span class="btn_wrap">
				<a href="#" class="btn_list btn_l btn_dgray" onclick="javascript:fn_back();"><span>목록</span></a>
				<a href="#" class="btn_save btn_l btn_red" onclick="javascript:fn_qnaSave();"><span>저장</span></a>
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
