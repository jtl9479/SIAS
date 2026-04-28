<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
 
 <c:choose>
	<c:when test="${!empty requestScope.noticeList }">
		<c:forEach items="${requestScope.noticeList }" var="item" varStatus="status" begin="${pgNum}">
			<fmt:parseDate  var="item_RGSDE" value="${item.RGSDE}" pattern="yyyyMMdd" />
			<fmt:formatDate var="rgsDe" value="${item_RGSDE}" pattern="yyyy-MM-dd" />
			<tr class="UcItemRow" onclick="javascript:fn_noticeViewPg(${item.NOTICEID});" style="cursor:pointer;">
				<td><c:out value="${pgNum+status.count}"/></td>
				<td class="left">
					<c:if test="${item.POPUPUSEAT eq 'Y'}">
						<span class="text_red">
							<c:out value="[팝업전용] "/>
							<c:choose>
								<c:when test="${fn:length(item.NOTICETITLE) > 70}">
									<c:out value="${fn:substring(item.NOTICETITLE,0,70)}"/>...
								</c:when>
								<c:otherwise>
									<c:out value="${item.NOTICETITLE}"/>
								</c:otherwise>
							</c:choose>
						</span>
					</c:if>
					<c:if test="${item.POPUPUSEAT eq 'N'}">
						<c:choose>
							<c:when test="${fn:length(item.NOTICETITLE) > 70}">
								<c:out value="${fn:substring(item.NOTICETITLE,0,70)}"/>...
							</c:when>
							<c:otherwise>
								<c:out value="${item.NOTICETITLE}"/>
							</c:otherwise>
						</c:choose>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="4" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>

