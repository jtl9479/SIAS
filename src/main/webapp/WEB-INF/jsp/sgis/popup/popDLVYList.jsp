<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<div class="tb-type01">
	<table class="table-hover">
		<c:if test="${sess_userSe eq 'U'}">
			<colgroup>
				<col width="6%">
				<col width="22%">
				<col width="*">
				<col width="4%">
				<col width="4%">
				<col width="4%">
				<col width="4%">
				<col width="4%">
			</colgroup>
			<thead>
				<tr>
					<th>NO</th>
					<th>도착지업체</th>
					<th>주소</th>
					<th>월</th>
					<th>화</th>
					<th>수</th>
					<th>목</th>
					<th>금</th>
				</tr>
			</thead>
		</c:if>
		<c:if test="${sess_userSe eq 'A'}">
			<colgroup>
				<col width="6%">
				<col width="18%">
				<col width="18%">
				<col width="*">
				<col width="4%">
				<col width="4%">
				<col width="4%">
				<col width="4%">
				<col width="4%">
			</colgroup>
			<thead>
				<tr>
					<th>NO</th>
					<th>출고사업장</th>
					<th>도착지업체</th>
					<th>주소</th>
					<th>월</th>
					<th>화</th>
					<th>수</th>
					<th>목</th>
					<th>금</th>
				</tr>
			</thead>
		</c:if>
		<tbody>
			<c:choose>
				<c:when test="${!empty requestScope.dlvyList }">
					<c:forEach items="${requestScope.dlvyList}" var="item" varStatus="status">
						<fmt:parseDate  var="item_DEADLINE" value="${item.DEADLINE}" pattern="yyyyMMdd" />
						<fmt:formatDate var="DEADLINE" value="${item_DEADLINE}" pattern="yyyy-MM-dd" />
						<tr class="PopUcItemRow" style="cursor:pointer;" onclick="javascript:fn_dlvyEntrps(${status.index});">
							<td>
								<c:out value="${status.count}"/>
								<c:if test="${status.first}">
									<input type="hidden" name="popListTotalCnt" value="${totalCnt }"/>
								</c:if>
							</td>
							<c:if test="${sess_userSe eq 'A'}">
								<td id="edrDlvyEntrpsNm_${status.index }"><c:out value="${item.EDR_DLVY_ENTRPS_NM}"/></td>		
							</c:if>
							<td id="dlvyEntrpsNm_${status.index }"><c:out value="${item.DLVY_ENTRPS_NM}"/></td>
							<td id="dlvyEntrpsAddress_${status.index }" style="text-align: left;"><c:out value="${item.DLVY_ENTRPS_ADDRESS}"/></td>
							<td id="popDlvyDay${status.index }1"><c:out value="${item.DLVY_MON}"/></td>
							<td id="popDlvyDay${status.index }2"><c:out value="${item.DLVY_TUE}"/></td>
							<td id="popDlvyDay${status.index }3"><c:out value="${item.DLVY_WEN}"/></td>
							<td id="popDlvyDay${status.index }4"><c:out value="${item.DLVY_THUR}"/></td>
							<td id="popDlvyDay${status.index }5"><c:out value="${item.DLVY_FRI}"/></td>
							<td>
								<input type="hidden" name="dlvyDeCeck" id="popDlvyDeCeck_${status.index }" value="${item.DLVY_DE_CECK }">
								<input type="hidden" name="dlvyEntrps" id="dlvyEntrps_${status.index }"value="${item.DLVY_ENTRPS }">
								<input type="hidden" name="dlvyDeadLine" id="dlvyDeadLine_${status.index }"value="${DEADLINE }">
							</td>
							
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="8" >조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

</div>

<script type="text/javascript">
	// 본페이지에 대한 함수 처리는 여기에 존재한다.
	//선택한 착지업체값
	function fn_dlvyEntrps(idx){
		var jsDlvyEntrpsNm = $("#dlvyEntrpsNm_"+idx).text();// 착지업체명
		var jsDlvyEntrps = $("#dlvyEntrps_"+idx).val();//착지업체코드
		var jsDlvyDeadLine = $("#dlvyDeadLine_"+idx).val();
		//선택된 해당 요일값
		var jsDlvyMon = $("#popDlvyDay"+idx+"1").text();
		var jsDlvyTue = $("#popDlvyDay"+idx+"2").text();
		var jsDlvyWen = $("#popDlvyDay"+idx+"3").text();
		var jsDlvyThur = $("#popDlvyDay"+idx+"4").text();
		var jsDlvyFri = $("#popDlvyDay"+idx+"5").text();
		var jsDlvyDeCeck = $("#popDlvyDeCeck_"+idx).val(); //배송요일체크
		
		$("#dlvyDay01").val(jsDlvyMon);
		$("#dlvyDay02").val(jsDlvyTue);
		$("#dlvyDay03").val(jsDlvyWen);
		$("#dlvyDay04").val(jsDlvyThur);
		$("#dlvyDay05").val(jsDlvyFri);
		$("#dlvyDeCeck_0").val(jsDlvyDeCeck);
		
		//$("#dlvyEntrpsNm").text(jsDlvyEntrpsNm);
		$("#searchEntrps").val(jsDlvyEntrpsNm);
		$("#searchEntrpsNm").val(jsDlvyEntrpsNm);
		$("#dlvyEntrps").val(jsDlvyEntrps);
		$("#searchDlvyEntrps").val(jsDlvyEntrps);
		$("input[name=dlvyNo]").val(idx);
		$("input[name=itemDedt]").val(jsDlvyDeadLine);
		$("input[name=DEADLINE]").val(jsDlvyDeadLine);
		
		$("#popOutLine").css("display","none");
	}
</script>


