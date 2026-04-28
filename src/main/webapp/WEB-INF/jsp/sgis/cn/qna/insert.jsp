<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html>
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>
	<script type="text/javascript">
		var jsCharChk = true;
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		
		// 내용 글자수 제한
		function fn_wiCn(){
			var text = $('#WI_CN').val();
			if(fn_getTextLength(text) < 5001){ //글자수 제한 5000바이트 까지
				jsCharChk = true;
			}else{ // 글자수 5001바이트부터 
				jsCharChk = false;
			}
			return jsCharChk;
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
			var jsQnaWrter = $("input[name=WI_BCNCWRTER]");
			var jsQnaTitle = $("input[name=WI_TITLE]");
			var jsQnaCn = $("#WI_CN");
			
			if(gfn_isNull(jsQnaWrter.val())){//작성자 공백 확인
				alertBoxFocus(jsQnaWrter.attr("title") + jsMsgAlertFocus, jsQnaWrter);
				return false;
			}
			if(gfn_isNull(jsQnaTitle.val())){//제목 공백 확인
				alertBoxFocus(jsQnaTitle.attr("title") + jsMsgAlertFocus, jsQnaTitle);
				return false;
			}
			if(!jsCharChk){//내용 공백확인
				alertBoxFocus(jsQnaCn.attr("title") + jsMsgAlertFocus, jsQnaCn);
				return false;
			}
			
			comAjax('listFrm','/qna/ins.do','',fn_qnaSaveCallBack);
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
									<textarea name="WI_CN" id="WI_CN" form="listFrm" style="height:300px;" onkeyup="javascript:fn_wiCn();" title="<spring:message code='title.noticeCn'/>" placeholder="내용을 입력해주세요."></textarea>
								</span>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
				<!-- // tb-type01 -->
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
