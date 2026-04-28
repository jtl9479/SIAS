<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
 
 <c:choose>
	<c:when test="${!empty requestScope.qnaList }">
		<c:forEach items="${requestScope.qnaList }" var="item" varStatus="status" begin="${pgNum}">
			<tr class="UcItemRow" data-se="${item.WI_PROGRSSE }" data-num="${item.WI_ID }" onclick="javascript:fn_qnaViewPg(this);" style="cursor:pointer;">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<input type="hidden" name="WI_PROGRSSE" value="${item.WI_PROGRSSE }"/>
					<c:if test="${status.last }">
						<input type="hidden" name="listTotalCnt" value="${listTotalCnt}"/>
					</c:if>
				</td>
				<td><c:out value="${item.WI_PROGRSSECHG }"/></td>
				<td><c:out value="${item.WI_WRITEDT }"/></td>
				<td class="left"><c:out value="${item.WI_BCNCWRTER }"/></td>
				<td class="left">
					<c:choose>
						<c:when test="${fn:length(item.WI_TITLE) > 45}">
							<c:out value="${fn:substring(item.WI_TITLE,0,45)}"/>...
						</c:when>
						<c:otherwise>
							<c:out value="${item.WI_TITLE}"/>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="5" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>

