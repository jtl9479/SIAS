<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.resultMap}">
		<c:forEach items="${requestScope.resultMap }" var="item" varStatus="status" >
			<fmt:formatNumber var="item_OS_QUANTITY" value="${item.OS_QUANTITY}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_OS_UNTPC" value="${item.OS_UNTPC}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_OS_SUMAMOUNT" value="${item.OS_SUMAMOUNT}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_GRP_QUANTITYAM" value="${item.GRP_QUANTITYAM}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_GRP_SUMAM" value="${item.GRP_SUMAM}" pattern="#,###.####"/>
			<tr class="UcItemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.last}">
						<input type="text" id="itemListStartDt" value="${listStartDt}" >
						<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
						<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
						<input type="hidden" id="confirm" value="${confirm}"/>
					</c:if> 
				</td>
				<td><c:out value="${item.OS_DEDT}"/></td>
				<td><c:out value="${item.OS_BCNCCODE }"/></td>
				<td><c:out value="${item.OS_BCNC }"/></td>
				<td><c:out value="${item.OS_ENTRPSCODE }"/></td>
				<td><c:out value="${item.OS_DLVYENTRPS }"/></td>
				<td><c:out value="${item.OS_CODE }"/></td>
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
				<td><c:out value="${item_OS_QUANTITY}"/></td>
				<td><c:out value="${item.OS_UNIT}"/></td>
				<td><c:out value="${item_OS_UNTPC}"/></td>
				<td><c:out value="${item_OS_SUMAMOUNT}"/></td>
				<td class="left"><c:out value="${item.OS_NOTE}"/></td>
			</tr>
			<c:if test="${item.CO eq item.GRP_DTNUMBER}">
				<tr class="total UcAmountRow"><!-- [D] 합계행에는 tr에 클래스 total 추가 -->
					<td></td>
					<td><c:out value="${item.OS_DEDT}"/></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td><c:out value="${item_GRP_QUANTITYAM}"/></td>
					<td></td>
					<td></td>
					<td><c:out value="${item_GRP_SUMAM}"/></td>
					<td></td>
				</tr>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="14" >
				조회된 결과가 없습니다.
				<input type="text" id="itemListStartDt" value="${listStartDt}" >
				<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
				<input type="hidden" id="confirm" value="${confirm}"/>
			</td>
			
		</tr>
	</c:otherwise>
</c:choose>
