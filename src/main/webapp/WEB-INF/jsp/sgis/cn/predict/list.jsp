<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.predictList }">
		<c:forEach items="${requestScope.predictList }" var="item" varStatus="status">
			<fmt:parseDate var="item_W_DEDT" value="${item.W_DEDT}" pattern="yyyyMM" />
			<fmt:formatDate var="W_DEDT" value="${item_W_DEDT}" pattern="yyyy-MM" />
			<fmt:formatNumber var="item_W_PREDICTWT1" value="${item.W_PREDICTWT1}" pattern="#,###.####" /><%-- 예상수량 --%>
			<fmt:formatNumber var="item_W_PREDICTWT2" value="${item.W_PREDICTWT2}" pattern="#,###.####" />
			<fmt:formatNumber var="item_W_PREDICTWT3" value="${item.W_PREDICTWT3}" pattern="#,###.####" />
			<fmt:formatNumber var="item_W_DCSNWT1" value="${item.W_DCSNWT1}" pattern="#,###.####" /><%-- 확정수량 --%>
			<fmt:formatNumber var="item_W_DCSNWT2" value="${item.W_DCSNWT2}" pattern="#,###.####" />
			<fmt:formatNumber var="item_W_DCSNWT3" value="${item.W_DCSNWT3}" pattern="#,###.####" />
			<tr class="UcItemRow">
				<td>
					<c:out value="${pgNum+status.count}"/>
					<c:if test="${status.first}">
						<input type="text" name="listTotalCnt" value="${listTotalCnt }"/>
					</c:if>
				</td>
				<td><c:out value="${W_DEDT }"/></td>
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
				<td><c:out value="KG"/></td><%-- 단위 CASE문사용 --%>
				<c:set var="now" value="<%=new java.util.Date()%>" /> 
				<c:set var="sysYYMM"><fmt:formatDate value="${now}" pattern="yyyy-MM" /></c:set>
				<c:set var="sysDD"><fmt:formatDate value="${now}" pattern="dd" /></c:set>
				<!-- 구간 -->
				<td><c:out value="${item_W_PREDICTWT1 }"/></td>
				<td>
					<span class="input_type w_90">
						<input type="text" name="W_DCSNWT1" id="W_DCSNWT${status.index }1" value="${item_W_DCSNWT1 }" data-fcs="WT" style="text-align:center;" data-row="${status.index }" data-col="1" title="<spring:message code='title.wt'/>" onchange="javascript:fn_quanChk(this, 3);" onfocus="this.select()"/>
					</span>
				</td>
				<td><c:out value="${item_W_PREDICTWT2 }"/></td>
				<td>
					<span class="input_type w_90">
						<input type="text" name="W_DCSNWT2" id="W_DCSNWT${status.index }2" value="${item_W_DCSNWT2 }" data-fcs="WT" style="text-align:center;" data-row="${status.index }" data-col="2" title="<spring:message code='title.wt'/>" onchange="javascript:fn_quanChk(this, 3);" onfocus="this.select()"/>
					</span>
				</td>
				<td><c:out value="${item_W_PREDICTWT3 }"/></td>
				<td>
					<span class="input_type w_90">
						<input type="text" name="W_DCSNWT3" id="W_DCSNWT${status.index }3" value="${item_W_DCSNWT3 }" data-fcs="WT" style="text-align:center;" data-row="${status.index }" data-col="3" title="<spring:message code='title.wt'/>" onchange="javascript:fn_quanChk(this, 3);" onfocus="this.select()"/>
					</span>
				</td>
				<!-- 구간 -->
				<td>
					<span class="input_type w_90">
						<input type="text" name="W_NOTE" value="${item.W_NOTE }" placeholder="<spring:message code='title.note'/>" maxlength="100" title="<spring:message code='title.note'/>">
					</span>
					<input type="hidden" name="updateYn1" id="updateYn${status.index }1" value="N"> <!-- update확인 -->
					<input type="hidden" name="updateYn2" id="updateYn${status.index }2" value="N"> 
					<input type="hidden" name="updateYn3" id="updateYn${status.index }3" value="N"> 
					<input type="hidden" name="W_DEDT" id="W_DEDT${status.index }" value="${W_DEDT }"/><!-- 년월 -->
					<input type="hidden" name="IC_CODE" value="${item.IC_CODE }"/><!-- 품목코드 -->
					<input type="hidden" name="UPC_UNTPCUNIT" value="${item.UPC_UNTPCUNIT }"/><!-- 단가단위 -->
					<input type="hidden" name="IC_UNITWT" value="${item.IC_UNITWT }"/><!-- 단위중량 -->
					<input type="hidden" name="IC_PACKNGUNIT" value="${item.IC_PACKNGUNIT }"/><!-- 포장단위 -->
					<input type="hidden" name="IC_UNITQY" value="${item.IC_UNITQY }"/><!-- 단위당수량 -->
					<input type="hidden" name="sysDD" value="${sysDD }"/>
					<input type="hidden" name="sysYYMM" value="${sysYYMM }"/>
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<td colspan="12" >조회된 결과가 없습니다.</td> 
	</c:otherwise>
</c:choose>
