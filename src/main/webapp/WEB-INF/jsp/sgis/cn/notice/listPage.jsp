<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>

	<script type="text/javascript">
		var jsListUrl = "list.do";
		var jsViewUrl = "view.do";
	
		$(document).ready(function(){
			$("input[name=pg]").val(1);
			
			//공지사항 초기 load
			fn_listMore();
		});
		
		//더보기
		function fn_listMore(){
			//더보기 처리
			comAjax('listFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//더보기 콜백
		function fn_listCallBack(data){
			$("#listBody").append(data).trigger("create");
			$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
			
			var listCnt = Number($("tr[class='UcItemRow']").length);
			var totalCnt = Number($("input[name=totalCnt]").val());
			
			if (totalCnt <= listCnt ) {
				$("#moreBtn").hide();
			} else {
				$("#moreBtn").show();
			}
		}			
		
		function fn_noticeViewPg(num) {
			//json 파싱 데이터 배열
			var data = {};
			data.SEQNO = num;
			comSubmit('', data, jsViewUrl);
		} 
	</script>
</head>
<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">공지사항</h2>
			
			<form id="listFrm">
				<input type="hidden" name="pg" value="1">
				<div class="tb-type01">
					<table>
						<colgroup>
							<col width="10%">
							<col width="*">
						</colgroup>
						<thead>
							<tr>
								<th>NO</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody id="listBody"></tbody>
					</table>
				</div>
				<!-- // tb-type01 -->
			</form>
			<div class="btn_wrap t_r">
				<input type="hidden" name="totalCnt" value="${totalCnt}" >
				<a href="#" id="moreBtn" class="btn_m btn_white" onclick="fn_listMore();"><b>더보기</b></a>
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
