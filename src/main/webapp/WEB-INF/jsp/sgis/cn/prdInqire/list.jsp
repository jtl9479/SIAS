<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${fn:length(prdInqireList) > 0 }">
		<c:forEach items="${prdInqireList }" var="item" varStatus="status" begin="${pgNum}">
			<fmt:formatNumber  var="item_UPC_NEWUNITPC" value="${item.UPC_NEWUNITPC}" pattern="#,###.####" />
			<tr id="itemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.first}">
						<input type="text" name="listTotalCnt" value="${listTotalCnt }"/>
					</c:if>
				</td>
				<td>
					<input type="checkbox" name="selectItem" id="selectItem_${status.index }" data-chkse="sItem" onclick="javascript:fn_selectChk(this, ${status.index});">
					<label for="selectItem_${status.index }"></label>
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
							<!-- <i class="order"><em class="blind">주문생산</em></i>
							<i class="sale"><em class="blind">재고판매</em></i> -->
						</span>
						<em><c:out value="${item.IC_NM}"/></em>
					</div>
				</td>
				<td><c:out value="${item.IC_STNDRD}"/></td>
				<td>
					<input type="hidden" name="selectYn" id="selectYn_${status.index }" value="N">
					<input type="hidden" name="IC_CODE" value="${item.IC_CODE}">
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

