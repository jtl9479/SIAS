<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<div class="tb-type01">
	<table class="table-hover">
		<colgroup>
			<col width="15%">
			<col width="*">
		</colgroup>
		<thead>
			<tr>
				<th>사업장코드</th>
				<th>사업장명칭</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${!empty requestScope.bplcList }">
					<c:forEach items="${requestScope.bplcList}" var="item" varStatus="status">
						<tr class="PopUcItemRow" style="cursor:pointer;" onclick="javascript:fn_bplcNm(${status.index});">
							<td id="bplcCode${status.index }">
								<c:out value="${item.BPLC_CODE}"/>
								<c:if test="${status.first}">
									<input type="hidden" name="popListTotalCnt" value="${totalCnt }"/>
								</c:if>
							</td>
							<td id="bplcNm${status.index }"><c:out value="${item.BPLC_NM}"/></td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="2" >조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
</div>

<script type="text/javascript">
	// 본페이지에 대한 함수 처리는 여기에 존재한다.
	function fn_bplcNm(idx){
		var jsBplcCode = $.trim($("#bplcCode"+idx).text());
		var jsBplcNm = $.trim($("#bplcNm"+idx).text());
		
		$("#searchBplc").val(jsBplcNm);
		$("#searchBplcNm").val(jsBplcNm);
		$("#searchBplcCode").val(jsBplcCode);
		
		if($("#menuSe").length > 0){
			//관리자 제품조회 화면
			if($("#menuSe").val() == "PRDI"){
				//사업장 정보를 변경하면서 정보 초기화
				// 거래처 정보
				$("#searchBcncNm").val("");
				$("#searchBcncCode").val("");
				//도착지 업체 정보
				$("#dlvyEntrps").val("");
				$("#searchEntrpsNm").val("");
				//테이블 초기화
				$("#listFrm > table > #listBody").empty();
			}
		}
		
		$("#popOutLine").css("display","none");
	}
</script>


