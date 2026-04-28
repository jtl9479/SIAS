<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${fn:length(dlivyInqireList) > 0}">
		<c:forEach items="${requestScope.dlivyInqireList }" var="item" varStatus="status" >
			<fmt:formatNumber var="item_DD_QY" value="${item.DD_QY}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_DLIVYUNTPC" value="${item.DD_DLIVYUNTPC}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_DLIVYDETAIL_AM" value="${item.DD_DLIVYDETAIL_AM}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_SPLPCAM" value="${item.DD_SPLPCAM}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_VAT_AM" value="${item.DD_VAT_AM}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_QYSM" value="${item.DD_QYSM}" pattern="#,###.####" />
			<fmt:formatNumber var="item_DD_AM" value="${item.DD_AM}" pattern="#,###.####" />
			<tr class="UcItemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" id="itemListStartDt" value="${listStartDt}" >
						<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
						<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
					</c:if> 
				</td>
				<td>
					<!-- 입고일자 -->
					<c:out value="${item.DD_DLIVYDE}"/>
				</td>
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
				<td><c:out value="${item.IC_STNDRD}"/></td>
				<td><c:out value="${item_DD_QY}"/></td>
				<td><c:out value="${item.DD_SE}"/></td>
				<td><!-- true일때만 보이기 -->
					<c:if test="${item.CM_PRDCTN eq true}">
						<c:out value="${item_DD_DLIVYUNTPC}"/>
					</c:if>
				</td>
				<td><c:out value="${item_DD_SPLPCAM }"/></td>
				<td><c:out value="${item_DD_DLIVYDETAIL_AM}"/></td>
				<td><c:out value="${item_DD_VAT_AM }"/></td>
				<td><c:out value="${item.CM_DLVYENTRPSNM}"/></td>
				<td><c:out value="${item.DD_RM}"/></td>
			</tr>
			<c:if test="${item.DD_CO  eq item.GRP_DTNUMBER}">
				<tr class="total UcAmountRow">
					<td></td>
					<td><c:out value="${item.DD_DLIVYDE}"/></td>
					<td></td>
					<td></td>
					<td><c:out value="${item_DD_QYSM}"/></td>
					<td>KG</td>
					<td></td>
					<td></td>
					<td><c:out value="${item_DD_AM}"/></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="13" >조회된 결과가 없습니다.</td>
		</tr>
	</c:otherwise>
</c:choose>
