<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.ordCnsltList}">
		<c:forEach items="${requestScope.ordCnsltList }" var="item" varStatus="status">
			<fmt:formatNumber var="item_W_WT" value="${item.W_WT}" pattern="#,###.####" />
			<fmt:formatNumber var="item_W_QUANTITY" value="${item.W_QUANTITY}" pattern="#,###.####" />
			<fmt:formatNumber var="item_W_SUMAMOUT" value="${item.W_SUMAMOUT}" pattern="#,###.####" />
			<tr class="UcItemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" id="itemListStartDt" value="${listStartDt}" >
						<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
						<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
					</c:if>
				</td>
				<td><c:out value="${item.W_DEDT }"/></td>
				<td><c:out value="${item.W_ORDERDE }"/></td>
				<td class="left">
					<div class="product_name">
						<span class="type_wrap">
							<c:if test="${item.IC_ENT_DVR_SE eq '2'}">
								<i class="common"><em class="blind">공용</em></i>
							</c:if>
							<c:if test="${item.IC_PRDCTN_SE eq '2'}">
								<i class="only"><em class="blind">전용</em></i>
							</c:if>
						</span>
						<em><c:out value="${item.IC_NM}"/></em>
					</div>
				</td>
				<td><c:out value="${item.IC_STNDRD }"/></td>
				<td><c:out value="${item_W_QUANTITY }"/></td>
				<td><c:out value="${item_W_WT }"/></td>
				<td><c:out value="${item_W_SUMAMOUT }"/></td>
				<td><c:out value="${item.DLVYENTRPSNM }"/></td>
				<td class="left"><c:out value="${item.W_NOTE }"/></td>
				<td class="left"><c:out value="${item.W_ADMINNOTE }"/></td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<td colspan="11" >조회된 결과가 없습니다.</td>
	</c:otherwise>
</c:choose>