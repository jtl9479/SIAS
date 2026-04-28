<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<table class="table-hover" id="dlvyTable">
	<tr>
		<th>NO</th>
		<th>착지업체명</th>
		<th>착지업체 주소</th>
		<th style="cursor:pointer;" onclick="javascript:fn_dlvyClose();">X</th>
	</tr>
<c:choose>
	<c:when test="${!empty requestScope.dlvyList }">
		<c:forEach items="${requestScope.dlvyList}" var="item" varStatus="status">
			<tr id="itemRow" style="cursor:pointer;" onclick="javascript:fn_dlvyEntrpsAddress(${status.index});">
				<td id="sn_${status.index }"><c:out value="${item.sn}"/></td>
				<td id="dlvyEntrpsNm_${status.index }"><c:out value="${item.dlvyEntrpsNm}"/></td>
				<td id="dlvyEntrpsAddress_${status.index }"><c:out value="${item.dlvyEntrpsAddress}"/></td>
				<td><input type="hidden" name="dlvyEntrps" value="${item.dlvyEntrps }"></td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="4" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>
</table>

