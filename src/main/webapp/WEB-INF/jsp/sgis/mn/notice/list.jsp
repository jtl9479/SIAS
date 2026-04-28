<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
 
 <c:choose>
	<c:when test="${!empty requestScope.noticeList }">
		<c:forEach items="${requestScope.noticeList }" var="item" varStatus="status" begin="${pgNum}">
			<fmt:parseDate  var="item_NOTICEDTFROM" value="${item.NOTICEDTFROM}" pattern="yyyyMMdd" />
			<fmt:formatDate var="noticeDtFrom" value="${item_NOTICEDTFROM}" pattern="yyyy-MM-dd" />
			<fmt:parseDate  var="item_NOTICEDTTO" value="${item.NOTICEDTTO}" pattern="yyyyMMdd" />
			<fmt:formatDate var="noticeDtTo" value="${item_NOTICEDTTO}" pattern="yyyy-MM-dd" />
			<tr class="UcItemRow" style="cursor: pointer;" onclick="javascript:fn_noticeViewPg(${item.NOTICEID});">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" name="listTotalCnt" value="${listTotalCnt }"/>
					</c:if>
				</td>
				<td class="left">
					<c:if test="${item.POPUPUSEAT eq 'Y'}">
						<span class="text_red">
							<c:out value="[팝업전용] "/>
							<c:choose>
								<c:when test="${fn:length(item.NOTICETITLE) > 45}">
									<c:out value="${fn:substring(item.NOTICETITLE,0,45)}"/>...
								</c:when>
								<c:otherwise>
									<c:out value="${item.NOTICETITLE}"/>
								</c:otherwise>
							</c:choose>
						</span>
					</c:if>
					<c:if test="${item.POPUPUSEAT eq 'N'}">
						<c:choose>
							<c:when test="${fn:length(item.NOTICETITLE) > 45}">
								<c:out value="${fn:substring(item.NOTICETITLE,0,45)}"/>...
							</c:when>
							<c:otherwise>
								<c:out value="${item.NOTICETITLE}"/>
							</c:otherwise>
						</c:choose>
					</c:if>
				</td>
				<td><c:out value="${noticeDtFrom}"/> ~ <c:out value="${noticeDtTo}"/></td>
				<td><c:out value="${item.UPDUSRNM}"/></td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="4" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>

