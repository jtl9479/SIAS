<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>
	<script type="text/javascript">
		var charChk = true; // 공지사항 내용 글자수 체크
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>"; // 메시지
		
		$(document).ready(function(){
			// 초기에 xmp태그에서 내용을 받아서textarea로 내용 입력
			CKEDITOR.replace('noticeCn');
			$("#noticeCn").val($("#textareaNotice").text());
			$("#textareaNotice").remove();
			fn_noticeCn();
		});
		
		//공지사항 내용 글자수 제한
		function fn_noticeCn(){
			CKEDITOR.instances["noticeCn"].on("instanceReady", function(){
				this.document.on("keyup", function(){
					var editor_data = CKEDITOR.instances.noticeCn.getData();
					$("#noticeCn").val(editor_data);
					var text = $('#noticeCn').val();
					/*
					if(fn_getTextLength(text) < 5001){ //글자수 제한 5000바이트 까지 
						charChk = true;
					}else{ // 글자수 5001바이트부터 
						charChk = false;
					}
					*/
				});
			});
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
		
		//시작일
		function fn_noticeDtFrom(){
			var jsNoticeDtFrom = $("input[name=NOTICEDTFROM]");
			
			return fn_validDedt(jsNoticeDtFrom);
		}
		
		//종료일
		function fn_noticeDtTo(){
			var jsNoticeDtTo = $("input[name=NOTICEDTTO]");
			
			return fn_validDedt(jsNoticeDtTo);
		}
		
		//공지사항 변경
		function fn_noticeSave(){
			confirmBox("<spring:message code='confirm.noticeInsert'/>", fn_noticeSaveConfirm, 'listFrm');
		}
		
		//confirm 저장
		function fn_noticeSaveConfirm(){
			
			var jsNoticeTitle = $("input[name=NOTICETITLE]");
			var jsNoticeCn = $("#noticeCn");
			var jsValidDtFrom;
			var jsValidDtTo;
			var data = {}; 
			
			jsNoticeCn.val(CKEDITOR.instances.noticeCn.getData());
			if(gfn_isNull(jsNoticeTitle.val())){//제목 공백 확인
				alertBoxFocus(jsNoticeTitle.attr("title") + jsMsgAlertFocus, jsNoticeTitle);
				return false;
			}
			jsValidDtFrom = fn_noticeDtFrom();//시작일
			if(!jsValidDtFrom){
				return false;
			}
			jsValidDtTo = fn_noticeDtTo();//종료일
			if(!jsValidDtTo){
				return false;
			}
			if(gfn_dtReplace($("input[name=NOTICEDTTO]")) < gfn_dtReplace($("input[name=NOTICEDTFROM]"))){//시작일이 종료일보다 작은경우
				alertBoxFocus("<spring:message code='title.dtFrom'/><spring:message code='alert.alertFocus'/>", $("input[name=NOTICEDTFROM]"));
				return false;
			}
			if(gfn_isNull(jsNoticeCn.val())){//내용 공백 확인
				CKEDITOR.instances.noticeCn.focus();
				alertBoxFocus(jsNoticeCn.attr("title") + jsMsgAlertFocus, jsNoticeCn);
				return false;
			}
			if(charChk == false){
				alertBox("<spring:message code='alert.noticeCn'/>");
				return false;
			}
			//data.SEQNO = $("input[name=NOTICEID]").val();
			
			comAjax('listFrm','/mn/notice/udt.do', '', fn_noticeSaveCallBack);
		}
		
		//저장CallBack
		function fn_noticeSaveCallBack(data){
			var jsResult = data.resultCnt;
			
			if(Number(jsResult) > 0){
				comSubmit('','','page.do');
			}else{
				alertBox("<spring:message code='alert.updateFailed'/>");
			}
		}
		
		//이전으로
		function fn_back() {
			comSubmit('', '', 'page.do');
		}
		
		//삭제
		function fn_noticeDelete(){
			confirmBox("<spring:message code='confirm.noticeDelete'/>", fn_noticeDeleteConfirm, 'listFrm');
		}
		
		//삭제 confirm
		function fn_noticeDeleteConfirm(){
			var data = {}; 
			//data.SEQNO = $("input[name=NOTICEID]").val();
			comAjax('listFrm','/mn/notice/del.do', '', fn_noticeDeleteCallBack);
		}
		
		//삭제CallBack
		function fn_noticeDeleteCallBack(data){
			var jsResult = data.resultCnt;
			
			if(Number(jsResult) > 0){
				comSubmit('','','page.do');
			}else{
				alertBox("<spring:message code='alert.deleteFailed'/>");
			}
		}
	</script>
</head>
<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">공지사항</h2>
			
			<form id="listFrm" name="listFrm">
				<input type="hidden" name="NOTICEID" value="${notice[0].NOTICEID}">
				<fmt:parseDate  var="item_RGSDE" value="${notice[0].RGSDE}" pattern="yyyyMMdd" /><!-- 등록일자 -->
				<fmt:formatDate var="rgsDe" value="${item_RGSDE}" pattern="yyyy-MM-dd" />
				<fmt:parseDate  var="item_NOTICEDTFROM" value="${notice[0].NOTICEDTFROM}" pattern="yyyyMMdd" /><!-- 공지시작일자 -->
				<fmt:formatDate var="noticeDtFrom" value="${item_NOTICEDTFROM}" pattern="yyyy-MM-dd" />
				<fmt:parseDate  var="item_NOTICEDTTO" value="${notice[0].NOTICEDTTO}" pattern="yyyyMMdd" /><!-- 공지종료일자 -->
				<fmt:formatDate var="noticeDtTo" value="${item_NOTICEDTTO}" pattern="yyyy-MM-dd" />
				<div class="tb-type01 write">
					<table>
						<colgroup>
							<col width="10%">
							<col width="*">
						</colgroup>
					<tbody>
						<tr>
							<th>제목</th>
							<td class="left">
								<span class="input_type w_100">
									<input type="text" name="NOTICETITLE" value="<c:out value="${notice[0].NOTICETITLE}"/>" title="<spring:message code='title.noticeTitle'/>" placeholder="제목을 입력해주세요." maxlength="100">
								</span>
							</td>
						</tr>
						<tr>
							<th>등록일</th>
							<td class="left"><span class="in_block"><c:out value="${rgsDe}"/></span></td>
						</tr>
						<tr>
							<th>작성자 </th>
							<td class="left"><span class="in_block"><c:out value="${notice[0].UPDUSRNM}"/></span></td>
						</tr>
						<tr>
							<th>공지기간</th>
							<td class="left">
								<span class="input_type w_15">
									<input type="text" name="NOTICEDTFROM" class="_datepick" value="${noticeDtFrom}" onchange="javascript:fn_noticeDtFrom();" maxlength="10" title="<spring:message code='title.dtFrom'/>" placeholder="<spring:message code='search.dtFormat' />">
								</span>
								&nbsp;~&nbsp;
								<span class="input_type w_15">
									<input type="text" name="NOTICEDTTO" class="_datepick" value="${noticeDtTo}" onchange="javascript:fn_noticeDtTo();" maxlength="10" title="<spring:message code='title.dtTo'/>" placeholder="<spring:message code='search.dtFormat' />">
								</span>
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td class="left">
								<span class="input_type_textarea w_100">
									<textarea name="NOTICECN" id="noticeCn" form="listFrm" title="<spring:message code='title.noticeCn'/>" placeholder="내용을 입력해주세요."></textarea>
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
				<a href="#" class="btn_save btn_l btn_red" onclick="javascript:fn_noticeSave();"><span>저장</span></a>
				<a href="#" class="btn_delete btn_l btn_white" onclick="javascript:fn_noticeDelete();"><span>삭제</span></a>
				<a href="#" class="btn_top btn_white"><span>TOP</span></a>
				<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
			</span>
		</div>
		<xmp id="textareaNotice">${notice[0].NOTICECN}</xmp>
		<!-- 	// btn_fixed_wrap -->
	</div>
	<hr>
	<!-- // container -->
</body>
<!-- </html> -->
