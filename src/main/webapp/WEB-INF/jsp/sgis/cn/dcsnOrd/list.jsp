<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.dcsnOrdList}">
		<c:forEach items="${requestScope.dcsnOrdList }" var="item" varStatus="status">
			<fmt:formatNumber var="item_OS_QUANTITY" value="${item.OS_QUANTITY}" pattern="#,###.####" />
			<fmt:formatNumber var="item_OS_WT" value="${item.OS_WT}" pattern="#,###.####" />
			<fmt:formatNumber var="item_OS_SUMAMOUNT" value="${item.OS_SUMAMOUNT}" pattern="#,###.####" />
			<fmt:formatNumber var="item_QYSM" value="${item.QYSM}" pattern="#,###.####" />
			<fmt:formatNumber var="item_AM" value="${item.AM}" pattern="#,###.####" />
			<tr class="UcItemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" id="itemListStartDt" value="${listStartDt}" >
						<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
						<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
					</c:if>
				</td>
				<td><c:out value="${item.OS_DEDT }"/></td>
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
				<td><c:out value="${item_OS_QUANTITY }"/></td>
				<td><c:out value="${item_OS_WT }"/></td>
				<td><c:out value="${item.OS_UNIT_CHRCTR }"/></td>
				<td><c:out value="${item_OS_SUMAMOUNT }"/></td>
				<td><c:out value="${item.DLVYENTRPSNM }"/></td>
				<td class="left">
					<c:out value="${item.OS_NOTE }"/>
				</td>
			</tr>
			<c:if test="${item.CO eq item.GRP_DTNUMBER}">
				<tr class="total UcAmountRow">
					<td></td>
					<td><c:out value="${item.OS_DEDT}"/></td>
					<td></td>
					<td></td>
					<td></td>
					<td><c:out value="${item_QYSM}"/></td>
					<td>KG</td>
					<td><c:out value="${item_AM}"/></td>
					<td></td>
					<td></td>
				</tr>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<td colspan="10" >조회된 결과가 없습니다.</td>
	</c:otherwise>
</c:choose>
