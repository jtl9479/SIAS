<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
		<script type="text/javascript">
			var jsListUrl = "list.do";
		
			$(document).ready(function(){
				$("input[name=pg]").val(1);
				fn_listMore();
			});
			
			
			// 조회
			function fn_searchList(){
				$("input[name=pg]").val(1);				
				comSubmit('searchFrm', '', 'page.do');
			}
			
			// 목록(더보기)
			function fn_listMore(){
				var pg = Number($("input[name=pg]").val());
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);

			}
			
			function fn_listCallBack(data){
				$("#listBody").append(data).trigger("create");
				
				// 행번호, 조회종료일자 searchFrm 에 set
				var jsListEndDt =  $("#itemListEndDt").val();	
				var jsListPgNum =  $("#itemPgNum").val();
				if (!gfn_isNull(jsListEndDt)) $("input[name=listEndDt]").val(jsListEndDt);
				if (!gfn_isNull(jsListPgNum)) $("input[name=pgNum]").val(jsListPgNum);
				
				$("#itemListEndDt").remove();
				$("#itemPgNum").remove();
				
				var listCnt = Number($("tr[id='itemRow']").length);
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
				data.viewSeq = num;
				comSubmit('', data, jsViewUrl);
			} 
		</script>
	</head>
	<body>
		<div id="page-wrapper">
			<div class="row">
		        <div class="col-lg-12">
		            <h1 class="page-header">출고조회</h1>
		        </div>
		    </div>
		    <form id="searchFrm" name="searchFrm">
		    	<div style="width: 100px;">
		    		<p>출고일자</p>
		    		<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
					<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
					<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
					<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
		    		<input type="text" id="searchDtFrom" name="searchDtFrom" class="_datepick" value="${dtFrom}" onchange="javascript:fn_searchItemDedt();" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />"/> ~ 
		    		<input type="text" id="searchDtTo" name="searchDtTo" class="_datepick" value="${dtTo}" onchange="javascript:fn_searchItemDedt();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
		    	</div>
		    	<div class="dlvyDiv">
		    		<label>
		    			<a href="#this" class="popOpen" data-popup="DLVY" title="<spring:message code='title.dlvy' />">배송지업체</a>
		    			<input type="text" id="searchEntrpsNm" name="searchEntrpsNm" value="${searchEntrpsNm}"/>
		    			<input type="hidden" id="searchDlvyEntrps" name="searchDlvyEntrps" value="${searchDlvyEntrps}"/>
		    		</label>
		    	</div>
		    	<div>
		    		<p>제품명</p>
		    		<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />"/>
		    	</div>
		    	<a onclick="javascript:fn_searchList();">조회</a>
		    	<input type="hidden" name="pg" value="1">
		    	<input type="hidden" name="pgNum" value="0">
		    	<input type="hidden" name="listEndDt" value="${listEndDt}">
		    </form>
		    
		    <div class="row">
		    	<form id="listFrm">
					<table>
						<colgroup>
							<col style="width:30px;">
							<col style="width:200px;">
							<col style="width:100px;">
							<col style="width:100px;">
							<col style="width:100px;">
							<col style="width:100px;">
							<col style="width:100px;">
							<col style="width:200px;">
							<col style="width:150px;">
						</colgroup>
						<tr>
						    <th>NO</th>
						    <th>제품명</th>
						    <th>규격</th>
						    <th>출고일자</th>
						    <th>수량</th>
						    <th>단가</th>
						    <th>금액</th>
						    <th>배송지업체</th>
						    <th>비고</th>
						</tr>
						<tbody id="listBody"></tbody>
					</table>
				</form>
				<div id="moreBtn">
					<input type="hidden" name="totalCnt" value="${totalCnt}" >
					<a id="moreBtn" onclick="fn_listMore();">더보기</a>	
				</div>
		    </div>
		</div>
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
</html>
