<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>

	<script type="text/javascript">
		$(document).ready(function(){
			var jsNoticeCn = $("#noticeCn").text();
			$("#noticeCn").html(jsNoticeCn);
		});
		
		//이전으로
		function fn_back() {
			comSubmit('', '', 'page.do');
		}
		
	</script>
</head>
<body>
	
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">공지사항</h2>
			
			<div class="tb-type01">
				<table>
					<colgroup>
						<col width="10%">
						<col width="*">
					</colgroup>
					<thead>
						<tr>
							<th class="left"><c:out value="${view.NOTICETITLE}"/></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2" class="con left" id="noticeCn">
								<c:out value="${view.NOTICECN}"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- // tb-type01 -->
		</div>
		<!-- // con_wrap_one -->
				
		<div class="btn_fixed_wrap">
			<span class="btn_wrap">
				<a href="#" class="btn_list btn_l btn_dgray" onclick="javascript:fn_back();"><span>목록</span></a>
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
