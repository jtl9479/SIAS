<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.dlvyList}">
		<ul class="tab_type">
			<c:forEach items="${requestScope.dlvyList }" var="item" varStatus="status">
				<li data-tab="tab-${status.count }">
					<a href="#"  class="dlvyList" onclick="javascript:fn_dlvyList(${status.index});">${item.DLVY_ENTRPS_NM }</a>
					<input type="hidden" name="W_ALOCENTRPS" value="${item.W_ALOCENTRPS }"/>
				</li>
			</c:forEach>
		</ul>
	</c:when>
</c:choose>

<div class="tab_con_wrap on">
	<div class="tb-type01">
		<table>
			<colgroup>
				<col width="4%">
				<col width="65px">
				<col width="60px">
				<col width="*">
				<col width="40px;">
				<col width="40px;">
				<col width="40px;">
				<col width="60px;">
				<col width="60px;">
				<col width="15%">
				<col width="15%">
			</colgroup>
			<thead>
				<tr>
					<th>NO</th>
					<th>납기일자</th>
					<th>주문일자</th>
					<th style="min-width:150px;">제품</th>
					<th>규격</th>
					<th>수량<br>(BOX)</th>
					<th>중량<br>(KG)</th>
					<th>재고상태<br>BOX(KG)</th>
					<th>금액</th>
					<th style="min-width:150px;">도착지업체</th>
					<th style="min-width:100px;">비고</th>
				</tr>
			</thead>
			<tbody>
				<c:choose>
					<c:when test="${!empty requestScope.unDcsnOrdList}">
						<c:forEach items="${requestScope.unDcsnOrdList }" var="item" varStatus="status">
							<fmt:formatNumber var="item_W_WT" value="${item.W_WT}" pattern="#,###.####" />
							<fmt:formatNumber var="item_W_QUANTITY" value="${item.W_QUANTITY}" pattern="#,###.####" />
							<fmt:formatNumber var="item_W_SUMAMOUNT" value="${item.W_SUMAMOUNT}" pattern="#,###.####" />
							<fmt:formatNumber var="item_QYSM" value="${item.QYSM}" pattern="#,###.####" />
							<fmt:formatNumber var="item_AM" value="${item.AM}" pattern="#,###.####" />
							<!-- 재고상태 -->
							<fmt:parseNumber var="INVNTRY" value="${(item.INVNTRY_QY / item.IC_PACKNGUNIT / item.IC_UNITQY)}" integerOnly="true" />
							<fmt:parseNumber var="ORG_INVNTRY" value="${item.INVNTRY_QY}" integerOnly="true" />
							<fmt:formatNumber  var="ITEM_INVNTRY" value="${ORG_INVNTRY}" pattern="###,###" />
							
							<tr class="UcItemRow">
								<td>
									<c:out value="${pgNum+status.count}"/>
									<c:if test="${status.first}">
										<input type="text" name="listTotalCnt" value="${listTotalCnt }"/>
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
								<td><c:out value="${item_W_QUANTITY }"/></td><!-- 재고상태값이랑 수량 어떻게 변하는지여부확인 -->
								<td>
									<%-- <c:out value="${item_W_WT }"/> --%>
									<input type="text" class="readOnly" name="W_WT" value="<c:out value="${item_W_WT}"/>"readonly="readonly"/>
								</td>
								<td class="i_sttus" data-dedt="${item.W_DEDT }">
									<c:if test="${item.DATE_DIFF le 10}">
										<c:if test="${item.INVNTRY_QY le 0}">
											<span class="status_red"></span>
											<input type="hidden" name="IV_COLOR" value="R">
										</c:if>
										<c:if test="${item.INVNTRY_QY gt 0}">
											<c:if test="${(item.INVNTRY_QY - item.W_WT) gt 0}">
												<span class="status_green">
													<c:out value="${INVNTRY}(${ORG_INVNTRY})"/>
												</span>
												<input type="hidden" name="IV_COLOR" value="G">
											</c:if>
											<c:if test="${(item.INVNTRY_QY - item.W_WT) le 0}">
												<span class="status_yellow">
													<c:out value="${INVNTRY}(${ORG_INVNTRY})"/>
												</span>
												<input type="hidden" name="IV_COLOR" value="Y">
											</c:if>
										</c:if>
									</c:if>
									<c:if test="${item.DATE_DIFF gt 10}">
										<span class="status_green">
											<c:out value="${INVNTRY}(${ORG_INVNTRY})"/>
										</span>
										<input type="hidden" name="IV_COLOR" value="G">
									</c:if>
								</td>
								<td><c:out value="${item_W_SUMAMOUNT }"/></td>
								<td><c:out value="${item.DLVYENTRPSNM }"/></td>
								<td>
									<span class="input_type w_100">
										<input type="text" name="W_NOTE" value="${item.W_NOTE }" placeholder="<spring:message code='title.note'/>" maxlength="100" title="<spring:message code='title.note'/>">
									</span>
								</td>
								<td>
									<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }"/>
									<input type="hidden" name="W_SN" value="${item.W_SN }"/>
									<input type="hidden" name="W_DEDT" value="${item.W_DEDT }"/>
									<input type="hidden" name="IC_CODE" value="${item.IC_CODE }"/>
								</td>
							</tr>
							<c:if test="${item.CO eq item.GRP_DTNUMBER}">
								<tr class="total UcAmountRow" data-dedt="${item_W_DEDT}">
									<td></td>
									<td class="ar_w_dedt">
										<%-- <c:out value="${item.W_DEDT}"/> --%>
											<input type="text" id="AM_W_DEDT${status.index }" name="AM_W_DEDT"  class="w_100 readOnly" 
											value="${item.W_DEDT}" data-dedt="${item_W_DEDT}" readonly="readonly"/>
									</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td>
										<%-- <c:out value="${item_QYSM}"/> --%>
										<input type="text" id="qySm${status.index}" class="w_80 readOnly" name="qySm" style="text-align: center;" readonly="readonly">
									</td>
									<td></td>
									<td><c:out value="${item_AM}"/></td>
									<td></td>
									<td></td>
								</tr>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<td colspan="11" >조회된 결과가 없습니다.</td>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>
