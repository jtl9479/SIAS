<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${!empty requestScope.resultMap}">
		<c:forEach items="${requestScope.resultMap }" var="item" varStatus="status" >
			<fmt:formatNumber var="item_W_QUANTITY" value="${item.W_QUANTITY}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_W_WT" value="${item.W_WT}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_W_UNTPC" value="${item.W_UNTPC}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_W_SUMAMOUNT" value="${item.W_SUMAMOUNT}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_GRP_QUANTITYAM" value="${item.GRP_QUANTITYAM}" pattern="#,###.####"/>
			<fmt:formatNumber var="item_GRP_SUMAM" value="${item.GRP_SUMAM}" pattern="#,###.####"/>
			<c:if test="${pgNum eq 0}">
				<tr class="UcItemRow">
					<td>
						<input type="checkbox" name="selectItem" id="selectItem_${status.index }" data-chkse="sItem" onclick="javascript:fn_selectChk(this, ${status.index});">
						<label for="selectItem_${status.index }"></label>
						<c:if test="${status.last}">
							<input type="text" id="itemListStartDt" value="${listStartDt}" >
							<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
							<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
							<input type="hidden" id="confirm" value="${confirm}"/>
						</c:if> 
					</td>
					<td><c:out value="${item.W_REGISTSE }"/></td>
					<td>
						<%-- <c:out value="${item.W_DEDT}"/> --%>
						<input type="text" name="W_DEDT" value="${item.W_DEDT}" class="w_100 readOnly" readonly="readonly"/>
					</td>
					<td><c:out value="${item.W_BCNCCODE }"/></td>
					<td><c:out value="${item.CM_BCNC }"/></td>
					<td><c:out value="${item.W_ENTRPSCODE }"/></td>
					<td><c:out value="${item.CM_DLVYENTRPS }"/></td>
					<td><c:out value="${item.W_CODE }"/></td>
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
					<td>
						<%-- <c:out value="${item_W_QUANTITY}"/> --%>
						<input type="text" name="W_QUANTITY" class="w_80 readOnly" style="text-align: center;" 
						readonly="readonly" value="<c:out value="${item_W_QUANTITY}"/>">
						
						
						<input type="hidden" name="W_PIECE_QY" value="<c:out value="${item.W_PIECE_QY}"/>">
						<input type="hidden" name="W_GRP_QY" value="<c:out value="${item.W_GRP_QY}"/>">
					</td>
					<td>
						<%-- <c:out value="${item_W_WT}"/> --%>
						<input type="text" class="w_80 readOnly" name="W_WT" value="<c:out value="${item_W_WT}"/>"readonly="readonly"/>
					</td>
					<td class="i_sttus" data-dedt="${item.W_DEDT }">
						<c:if test="${item.DATE_DIFF le 10}">
							<c:if test="${item.INVNTRY_QY le 0}">
								<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
								<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
								<span class="status_red"><c:out value="${item_INVNTRY_QY}"/></span>
								<input type="hidden" name="IV_COLOR" value="R">
							</c:if>
							<c:if test="${item.INVNTRY_QY gt 0}">
								<c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) gt 0}">
									<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
									<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
									<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
									<input type="hidden" name="IV_COLOR" value="G">
								</c:if>
								<c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) le 0}">
									<!-- 재고상태 정수만 허용-->
									<fmt:parseNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" integerOnly="true"/>
									<span class="status_yellow"><c:out value="${item_INVNTRY_QY}"/></span>
									<input type="hidden" name="IV_COLOR" value="Y">
								</c:if>
							</c:if>
						</c:if>
						<c:if test="${item.DATE_DIFF gt 10}">
							<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
							<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
							<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
							<input type="hidden" name="IV_COLOR" value="G">
						</c:if>
					</td>
					<td><c:out value="${item_W_UNTPC}"/></td>
					<td><c:out value="${item.W_UNIT_CHRCTR}"/></td>
					<td><c:out value="${item_W_SUMAMOUNT}"/></td>
					<td class="left">
						<c:out value="${item.W_NOTE}"/>
						<input type="hidden" name="selectYn" id="selectYn_${status.index }" value="N">
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }">
						<input type="hidden" name="W_SN" value="${item.W_SN }">
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }">
						<input type="hidden" name="INVNTRY_QY" value="${item.INVNTRY_QY }">
						<input type="hidden" name="W_BCNCCODE" value="${item.W_BCNCCODE }"/>
						<input type="hidden" name="W_ENTRPSCODE" value="${item.W_ENTRPSCODE }"/>
					</td>
					<%-- <td>
						<input type="hidden" name="selectYn" id="selectYn_${status.index }" value="N">
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }">
						<input type="hidden" name="W_SN" value="${item.W_SN }">
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }">
						<input type="hidden" name="INVNTRY_QY" value="${item.INVNTRY_QY }">
					</td> --%>
				</tr>
				<c:if test="${item.CO eq item.GRP_DTNUMBER}">
					<tr class="total UcAmountRow"><!-- [D] 합계행에는 tr에 클래스 total 추가 -->
						<td><a href="javascript:void(0);" class="under_line" data-del="all"  data-row="${status.index }" onclick="javascript:fn_groupSelect(this);">전체선택</a></td>
						<td></td>
						<td class="ar_w_dedt">
							<%-- <c:out value="${item.W_DEDT}"/> --%>
							<input type="text" id="AM_W_DEDT${status.index }" name="AM_W_DEDT" value="<c:out value="${item.W_DEDT}"/>" class="w_100 readOnly" readonly="readonly"/>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<%-- <c:out value="${item_GRP_QUANTITYAM}"/> --%>
							<input type="text" id="qySm${status.index}" class="w_80 readOnly" name="qySm" 
							style="text-align: center;" readonly="readonly" value="">
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td><c:out value="${item_GRP_SUMAM}"/></td>
						<td></td>
					</tr>
				</c:if>
			</c:if>
			<c:if test="${pgNum ne 0}">
				<tr class="UcItemRow">
					<td>
						<input type="checkbox" name="selectItem" id="selectItem_${pgNum+status.index }" data-chkse="sItem" onclick="javascript:fn_selectChk(this, ${pgNum+status.index});">
						<label for="selectItem_${pgNum+status.index }"></label>
						<c:if test="${status.last}">
							<input type="text" id="itemListStartDt" value="${listStartDt}" >
							<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
							<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
							<input type="hidden" id="confirm" value="${confirm}"/>
						</c:if> 
					</td>
					<td><c:out value="${item.W_REGISTSE }"/></td>
					<td>
						<%-- <c:out value="${item.W_DEDT}"/> --%>
						<input type="text" name="W_DEDT" value="${item.W_DEDT}" class="w_100 readOnly" readonly="readonly"/>
					</td>
					<td><c:out value="${item.W_BCNCCODE }"/></td>
					<td><c:out value="${item.CM_BCNC }"/></td>
					<td><c:out value="${item.W_ENTRPSCODE }"/></td>
					<td><c:out value="${item.CM_DLVYENTRPS }"/></td>
					<td><c:out value="${item.W_CODE }"/></td>
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
					<td>
						<%-- <c:out value="${item_W_QUANTITY}"/> --%>
						<input type="text" name="W_QUANTITY" class="w_80 readOnly" style="text-align: center;" 
						readonly="readonly" value="<c:out value="${item_W_QUANTITY}"/>">
						<input type="hidden" name="W_PIECE_QY" value="<c:out value="${item.W_PIECE_QY}"/>">
						<input type="hidden" name="W_GRP_QY" value="<c:out value="${item.W_GRP_QY}"/>">
					</td>
					<td>
						<%-- <c:out value="${item_W_WT}"/> --%>
						<input type="text" class="w_80 readOnly" name="W_WT" value="<c:out value="${item_W_WT}"/>" readonly="readonly"/>
					</td>
					<td class="i_sttus" data-dedt="${item.W_DEDT }">
						<c:if test="${item.DATE_DIFF le 10}">
							<c:if test="${item.INVNTRY_QY le 0}">
								<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
								<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
								<span class="status_red"><c:out value="${item_INVNTRY_QY}"/></span>
								<input type="hidden" name="IV_COLOR" value="R">
							</c:if>
							<c:if test="${item.INVNTRY_QY gt 0}">
								<%-- <c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) gt 0}">// ** 2019.12.26 재고수량 체크 수정 --%>
								<c:if test="${(item.INVNTRY_QY - item.W_WT) gt 0}">
									<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
									<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
									<span class="status_green"><c:out value="${item_INVNTRY_QY }"/></span>
									<input type="hidden" name="IV_COLOR" value="G">
								</c:if>
								<%-- <c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) le 0}">// ** 2019.12.26 재고수량 체크 수정 --%>
								<c:if test="${(item.INVNTRY_QY - item.W_WT) le 0}">
									<!-- 재고상태 정수만 허용-->
									<fmt:parseNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" integerOnly="true"/>
									<span class="status_yellow"><c:out value="${item_INVNTRY_QY}"/></span>
									<input type="hidden" name="IV_COLOR" value="Y">
								</c:if>
							</c:if>
						</c:if>
						<c:if test="${item.DATE_DIFF gt 10}">
							<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
							<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="###,###.#"/>
							<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
							<input type="hidden" name="IV_COLOR" value="G">
						</c:if>
					</td>
					<td><c:out value="${item_W_UNTPC}"/></td>
					<td><c:out value="${item.W_UNIT_CHRCTR}"/></td>
					<td><c:out value="${item_W_SUMAMOUNT}"/></td>
					<td class="left">
						<c:out value="${item.W_NOTE}"/>
						<input type="hidden" name="selectYn" id="selectYn_${pgNum+status.index }" value="N">
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }">
						<input type="hidden" name="W_SN" value="${item.W_SN }">
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }">
						<input type="hidden" name="INVNTRY_QY" value="${item.INVNTRY_QY }">
						<input type="hidden" name="W_BCNCCODE" value="${item.W_BCNCCODE }"/>
						<input type="hidden" name="W_ENTRPSCODE" value="${item.W_ENTRPSCODE }"/>
					</td>
					<%-- <td>
						<input type="hidden" name="selectYn" id="selectYn_${pgNum+status.index }" value="N">
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }">
						<input type="hidden" name="W_SN" value="${item.W_SN }">
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }">
						<input type="hidden" name="INVNTRY_QY" value="${item.INVNTRY_QY }">
					</td> --%>
				</tr>
				<c:if test="${item.CO eq item.GRP_DTNUMBER}">
					<tr class="total UcAmountRow"><!-- [D] 합계행에는 tr에 클래스 total 추가 -->
						<td><a href="javascript:void(0);" data-del="all" class="under_line" data-row="${pgNum+status.index }" onclick="javascript:fn_groupSelect(this);">전체선택</a></td>
						<td></td>
						<td class="ar_w_dedt">
							<input type="text" id="AM_W_DEDT${pgNum+status.index }" name="AM_W_DEDT" value="<c:out value="${item.W_DEDT}"/>" class="w_100 readOnly" readonly="readonly"/>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<%-- <c:out value="${item_GRP_QUANTITYAM}"/> --%>
							<input type="text" id="qySm${pgNum+status.index}" class="w_80 readOnly" name="qySm" 
								style="text-align: center;" readonly="readonly" value="">
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td><c:out value="${item_GRP_SUMAM}"/></td>
						<td></td>
					</tr>
				</c:if>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="17" >
				조회된 결과가 없습니다.
				<input type="text" id="itemListStartDt" value="${listStartDt}" >
				<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
			</td>
		</tr>
	</c:otherwise>
</c:choose>
