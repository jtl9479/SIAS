<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>


<c:choose>
	<c:when test="${fn:length(dlivyInqireList) > 0}">
		<c:forEach items="${requestScope.dlivyInqireList }" var="item" varStatus="status" >
			<fmt:parseDate  var="item_dlivyDe" value="${item.dlivyDe}" pattern="yyyyMMdd" />
			<fmt:formatDate var="fmtDlivyDe" value="${item_dlivyDe}" pattern="yyyy-MM-dd" />
			<tr id="itemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" id="itemListEndDt" value="${listEndDt}" >
						<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
					</c:if> 
				</td>
				<td><c:out value="${item.icNm}"/></td>
				<td><c:out value="${item.icStndrd}"/></td>
				<td><c:out value="${fmtDlivyDe}"/></td>
				<td><c:out value="${item.qy}"/></td>
				<td><c:out value="${item.dlivyUntpc}"/></td>
				<td><c:out value="${item.dlivyDetailAm}"/></td>
				<td><c:out value="${item.dlvyEntrpsNm}"/></td>
				<td><c:out value="${item.rm}"/></td>
			</tr>
			<c:if test="${item.co  eq item.GRP_DTNUMBER}">
				<tr style="background: yellow;">
					<td></td>
					<td></td>
					<td></td>
					<td><c:out value="${fmtDlivyDe}"/></td>
					<td><c:out value="${item.qySm}"/></td>
					<td></td>
					<td><c:out value="${item.am}"/></td>
					<td></td>
					<td></td>
				</tr>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="9" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>
