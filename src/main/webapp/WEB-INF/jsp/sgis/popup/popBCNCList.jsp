<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<div class="tb-type01">
	<table class="table-hover">
		<colgroup>
			<col width="10%">
			<col width="15%">
			<col width="*%">
			<col width="20%">
			<col width="15%">
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>거래처코드</th>
				<th>업체명</th>
				<th>사업자번호</th>
				<th>대표자</th>
			</tr>
		</thead>
		<tbody>
			<c:choose>
				<c:when test="${fn:length(bcncList) > 0 }">
					<c:forEach items="${bcncList}" var="item" varStatus="status">
						<tr class="PopUcItemRow" style="cursor:pointer;" onclick="javascript:fn_bcncNm(${status.index});">
							<td>
								<!-- count-> 1부터, index -> 0 부터 -->
								<c:out value="${status.count}"/>
								<c:if test="${status.first}">
									<input type="hidden" name="popListTotalCnt" value="${totalCnt }"/>
								</c:if>
							</td>
							<td id="bcncCode${status.index}"><c:out value="${item.WC_BCNC_CODE}"/></td>
							<td id="bcncNm${status.index}"><c:out value="${item.CM_ENTRPS_NM}"/></td>
							<td><c:out value="${item.CM_BIZR_NO}"/></td>
							<td><c:out value="${item.CM_CEO_NM}"/></td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="5" >조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>
</div>

<script type="text/javascript">
	// 본페이지에 대한 함수 처리는 여기에 존재한다.
	function fn_bcncNm(idx){
		$("#searchEntrpsNm").val("");
		$("#dlvyEntrps").val("");
		
		var jsBcncNm = $("#bcncNm"+idx).text();
		var jsBcncCode = $("#bcncCode"+idx).text();
		
		$("#searchBcnc").val(jsBcncNm);
		$("#searchBcncNm").val(jsBcncNm);
		$("#searchBcncCode").val(jsBcncCode);
		
		$("#popOutLine").css("display","none");
		
		//거래처 선택 완료 후 해당 거래처에 맞는 배송지 업체 조회
		if(jsBcncCode.length > 0){
			if(typeof fn_bcncDlvyList =='function'){//함수 존재여부
				fn_bcncDlvyList(jsBcncCode);
			}
		}
	}
</script>


