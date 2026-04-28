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
				<tr class="UcItemRow" data-rowNo="${status.index}">
					<td>
						<input type="checkbox" name="selectItem" id="selectItem_${status.index }" data-chkse="sItem" onclick="javascript:fn_selectChk(this, ${status.index});">
						<label for="selectItem_${status.index }"></label>
						<input type="hidden" name="selectYn" id="selectYn_${status.index }" value="N" />
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }" />
						<input type="hidden" name="W_SN" value="${item.W_SN }" />
						<input type="hidden" name="W_PIECE_QY" value="${item.W_PIECE_QY }" />
						<input type="hidden" name="W_GRP_QY" value="${item.W_GRP_QY }" />
						<input type="hidden" name="W_SPLPCAM" value="${item.W_SPLPCAM }"/>
						<input type="hidden" name="W_VAT" value="${item.W_VAT }"/>
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }"/>
						<input type="hidden" name="IC_UNITWT" value="${item.IC_UNITWT }" />
						<input type="hidden" name="IC_UNITQY" value="${item.IC_UNITQY }" />
						<input type="hidden" name="IC_PACKNGUNIT" value="${item.IC_PACKNGUNIT }" />
						<input type="hidden" name="IC_CODE" value="${item.W_CODE }" />
						<input type="hidden" name="UPC_UNTPCUNIT" value="${item.W_UNIT }" />
						<input type="hidden" name="UPC_VATINCLSAT" value="${item.UPC_VATINCLSAT }"/>
						<%-- <input type="hidden" name="minimumQy" value="${item.MUMM_ORDER_QY }"> --%>
						<input type="hidden" name="W_BCNCCODE" value="${item.W_BCNCCODE }"/>
						<input type="hidden" name="W_ENTRPSCODE" value="${item.W_ENTRPSCODE }"/>
						<c:if test="${status.last}">
							<input type="text" id="itemListStartDt" value="${listStartDt}" >
							<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
							<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
							<input type="hidden" id="userSe" value="${userSe}"/>
						</c:if> 
					</td>
					<td>
						<span class="input_type">
							<input type="text" name="W_DEDT" value="${item.W_DEDT}" class="_datepick" data-dedt="${item.W_DEDT}" data-oldDedt="${item.W_DEDT}" data-sttus="DEDT" data-fcs="DEDT" 
									maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
						</span>
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
					<td><!-- 수량(BOX) -->
						<span class="input_type w_100">
							<input type="text" style="text-align: center; padding:0;" name="W_QUANTITY" value="${item_W_QUANTITY}" data-dedt="${item.W_DEDT}"
							data-Qy="${item.W_QUANTITY}" data-oldQy="${item.W_QUANTITY}" data-sttus="QY" data-fcs="QY" data-row="${status.index }" title="<spring:message code='title.quantity' />" 
							onchange="javascript:fn_quanChange(this, 1);" onfocus="this.select()"/>
						</span>
					</td>
					<td><!-- 중량(KG) -->
						<span class="input_type w_100">
							<input type="text" style="text-align: center; padding:0;" name="W_WT" value="${item_W_WT}" data-dedt="${item.W_DEDT}"
							data-Wt="${item.W_WT}" data-oldWt="${item.W_WT}" data-sttus="WT" data-fcs="WT" data-row="${status.index }" title="<spring:message code='title.wt' />" 
							onchange="javascript:fn_quanChange(this, 3);" onfocus="this.select()"/>
						</span>
					</td>
					<td class="i_sttus" data-dedt="${item.W_DEDT }">
						<c:if test="${item.DATE_DIFF le 10}">
							<c:if test="${item.INVNTRY_QY le 0}">
								<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
								<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY}" pattern="###,###.#"/>
								<span class="status_red"><c:out value="${item_INVNTRY_QY}"/></span>
								<input type="hidden" name="IV_COLOR" value="R">
							</c:if>
							<c:if test="${item.INVNTRY_QY gt 0}">
								<%-- <c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) gt 0}">// ** 2019.12.26 재고수량 체크 수정 --%>
								<c:if test="${(item.INVNTRY_QY - item.W_WT) gt 0}">
									<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
									<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY}" pattern="###,###.#"/>
									<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
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
							<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY }" pattern="#.#"/>
							<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
							<input type="hidden" name="IV_COLOR" value="G">
						</c:if>
					</td>
					<td>
						<span class="input_type w_100">
							<input type="text" name="UPC_NEWUNITPC" data-row="${status.index }" value="${item_W_UNTPC}" style="width:100%; text-align: center; padding:0;" data-admse="MN" title="단가" onfocus="this.select()" onchange="fn_newUnitpcChg(this)">
						</span>
					</td>
					<td><c:out value="${item.W_UNIT_CHRCTR}"/></td>
					<td>
						<input type="text" name="W_SUMAMOUNT" data-row="${status.index }" class="t_c readOnly" style="width:100%;" value="<c:out value="${item_W_SUMAMOUNT}"/>" readonly="readonly">
					</td>
					<td>
						<span class="radio_text">
							<input type="radio" name="W_PROGRSSE${status.index }" data-row="${status.index }" onchange="javascript:fn_radioChk(this);"value="Y" id="go_${status.index }"><label for="go_${status.index }">진행</label>
						</span>&nbsp;&nbsp;
						<span class="radio_text">
							<input type="radio" name="W_PROGRSSE${status.index }" data-row="${status.index }" onchange="javascript:fn_radioChk(this);" value="N" id="stop_${status.index }"><label for="stop_${status.index }">중지</label>
						</span>
						<input type="hidden" name="W_PROGRSSE" value="${item.W_PROGRSSE }"/>
	 				</td>
					<td class="left">
						<span class="input_type w_100">
							<input type="text" name="W_NOTE" value="${item.W_NOTE }" style="padding:0;" placeholder="<spring:message code='title.note'/>" maxlength="100" title="<spring:message code='title.note'/>">
						</span>
					</td>
					<td class="left">
						<span class="input_type w_100">
							<input type="text" name="W_ADMINNOTE" value="${item.W_ADMINNOTE }" style="padding:0;" placeholder="<spring:message code='title.adminNote'/>" maxlength="100" title="<spring:message code='title.adminNote'/>">
						</span>
					</td>
				</tr>
				<c:if test="${item.CO eq item.GRP_DTNUMBER}">
					<tr class="total UcAmountRow"><!-- [D] 합계행에는 tr에 클래스 total 추가 -->
						<td><a href="javascript:void(0);" class="under_line" data-del="all" data-row="${status.index }" onclick="javascript:fn_groupSelect(this);">전체선택</a></td>
						<td class="ar_w_dedt">
							<span class="input_type">
								<input type="text" id="AM_W_DEDT${status.index }" name="AM_W_DEDT" class="_datepick" style="text-align: center;" 
											onchange="javascript:fn_setDate(this,${status.index });" value="${item.W_DEDT}" data-dedt="${item.W_DEDT}" data-amrow="${status.index }" maxlength="10" 
											title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
											
								<input type="hidden" name="minimumQy" value="${item.MUMM_ORDER_QY }"/>
							</span>
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
							<%-- <input type="text" id="qySm${status.index }" name="qySm" class="t_c readOnly" style="width:100%;" value="<c:out value="${item_GRP_QUANTITYAM}"/>" readonly="readonly"> --%>
							<input type="text" id="qySm${status.index }" name="qySm" class="t_c readOnly" style="width:100%;" value="" readonly="readonly">
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<input type="text" id="am${status.index }"class="t_c readOnly" style="width:100%;" value="<c:out value="${item_GRP_SUMAM}"/>" readonly="readonly">
						</td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</c:if>
			</c:if>
			
			<c:if test="${pgNum ne 0}">
				<tr class="UcItemRow" data-rowNo="${pgNum+status.index}">
					<td>
						<input type="checkbox" name="selectItem" id="selectItem_${pgNum+status.index }" data-chkse="sItem" onclick="javascript:fn_selectChk(this, ${pgNum+status.index});">
						<label for="selectItem_${pgNum+status.index }"></label>
						<input type="hidden" name="selectYn" id="selectYn_${pgNum+status.index }" value="N" />
						<input type="hidden" name="W_RCEPTDE" value="${item.W_RCEPTDE }" />
						<input type="hidden" name="W_SN" value="${item.W_SN }" />
						<input type="hidden" name="W_PIECE_QY" value="${item.W_PIECE_QY }" />
						<input type="hidden" name="W_GRP_QY" value="${item.W_GRP_QY }" />
						<input type="hidden" name="W_SPLPCAM" value="${item.W_SPLPCAM }"/>
						<input type="hidden" name="W_VAT" value="${item.W_VAT }"/>
						<input type="hidden" name="W_UNIT_BPLC" value="${item.W_UNIT_BPLC }"/>
						<input type="hidden" name="IC_UNITWT" value="${item.IC_UNITWT }" />
						<input type="hidden" name="IC_UNITQY" value="${item.IC_UNITQY }" />
						<input type="hidden" name="IC_PACKNGUNIT" value="${item.IC_PACKNGUNIT }" />
						<input type="hidden" name="IC_CODE" value="${item.W_CODE }" />
						<input type="hidden" name="UPC_UNTPCUNIT" value="${item.W_UNIT }" />
						<input type="hidden" name="UPC_VATINCLSAT" value="${item.UPC_VATINCLSAT }"/>
						<%-- <input type="hidden" name="minimumQy" value="${item.MUMM_ORDER_QY }"> --%>
						<input type="hidden" name="W_BCNCCODE" value="${item.W_BCNCCODE }"/>
						<input type="hidden" name="W_ENTRPSCODE" value="${item.W_ENTRPSCODE }"/>
						<c:if test="${status.last}">
							<input type="text" id="itemListStartDt" value="${listStartDt}" >
							<input type="text" id="itemPgNum" value="${pgNum+status.count}" >
							<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
							<input type="hidden" id="userSe" value="${userSe}"/>
						</c:if> 
					</td>
					<td>
						<span class="input_type">
							<input type="text" name="W_DEDT" value="${item.W_DEDT}" class="_datepick" data-dedt="${item.W_DEDT}" data-oldDedt="${item.W_DEDT}" data-sttus="DEDT" data-fcs="DEDT" 
									maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
						</span>
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
					<td><!-- 수량(BOX) -->
						<span class="input_type w_100">
							<input type="text" style="text-align: center; padding:0;" name="W_QUANTITY" value="${item_W_QUANTITY}" data-dedt="${item.W_DEDT}"
							data-Qy="${item.W_QUANTITY}" data-oldQy="${item.W_QUANTITY}" data-sttus="QY" data-fcs="QY" data-row="${pgNum+status.index}" title="<spring:message code='title.quantity' />" 
							onchange="javascript:fn_quanChange(this, 1);" onfocus="this.select()"/>
						</span>
					</td>
					<td><!-- 중량(KG) -->
						<span class="input_type w_100">
							<input type="text" style="text-align: center; padding:0;" name="W_WT" value="${item_W_WT}" data-dedt="${item.W_DEDT}"
							data-Wt="${item.W_WT}" data-oldWt="${item.W_WT}" data-sttus="WT" data-fcs="WT" data-row="${pgNum+status.index}" title="<spring:message code='title.wt' />" 
							onchange="javascript:fn_quanChange(this, 3);" onfocus="this.select()"/>
						</span>
					</td>
					<%-- <td class="i_sttus" data-dedt="${item.W_DEDT }"> --%>
					<td class="i_sttus" data-dedt="${item.W_DEDT }">
						<c:if test="${item.DATE_DIFF le 10}">
							<c:if test="${item.INVNTRY_QY le 0}">
								<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
								<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY}" pattern="###,###.#"/>
								<span class="status_red"><c:out value="${item_INVNTRY_QY}"/></span>
								<input type="hidden" name="IV_COLOR" value="R">
							</c:if>
							<c:if test="${item.INVNTRY_QY gt 0}">
								<c:if test="${(item.INVNTRY_QY - item.W_QUANTITY) gt 0}">
									<!-- 재고상태 소수점 첫번째 자리 까지만 허용 -->
									<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY}" pattern="###,###.#"/>
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
							<fmt:formatNumber var="item_INVNTRY_QY" value="${item.INVNTRY_QY}" pattern="###,###.#"/>
							<span class="status_green"><c:out value="${item_INVNTRY_QY}"/></span>
							<input type="hidden" name="IV_COLOR" value="G">
						</c:if>
					</td>
					<td>
						<span class="input_type w_100">
							<input type="text" name="UPC_NEWUNITPC" data-row="${pgNum+status.index }" value="${item_W_UNTPC}" style="width:100%; text-align: center; padding:0;" data-admse="MN" title="단가" onfocus="this.select()" onchange="fn_newUnitpcChg(this)">
						</span>
					</td>
					<td><c:out value="${item.W_UNIT_CHRCTR}"/></td>
					<td>
						<input type="text" name="W_SUMAMOUNT" data-row="${pgNum+status.index }" class="t_c readOnly" style="width:100%;" value="<c:out value="${item_W_SUMAMOUNT}"/>" readonly="readonly">
					</td>
					<td>
						<span class="radio_text">
							<input type="radio" name="W_PROGRSSE${pgNum+status.index }" data-row="${pgNum+status.index }" onchange="javascript:fn_radioChk(this);"value="Y" id="go_${pgNum+status.index }"><label for="go_${pgNum+status.index }">진행</label>
						</span>&nbsp;&nbsp;
						<span class="radio_text">
							<input type="radio" name="W_PROGRSSE${pgNum+status.index }" data-row="${pgNum+status.index }" onchange="javascript:fn_radioChk(this);" value="N" id="stop_${pgNum+status.index }"><label for="stop_${pgNum+status.index }">중지</label>
						</span>
						<input type="hidden" name="W_PROGRSSE" value="${item.W_PROGRSSE }"/>
	 				</td>
					<td class="left">
						<span class="input_type w_100">
							<input type="text" name="W_NOTE" value="${item.W_NOTE }" style="padding:0;" placeholder="<spring:message code='title.note'/>" maxlength="100" title="<spring:message code='title.note'/>">
						</span>
					</td>
					<td class="left">
						<span class="input_type w_100">
							<input type="text" name="W_ADMINNOTE" value="${item.W_ADMINNOTE }" style="padding:0;" placeholder="<spring:message code='title.adminNote'/>" maxlength="100" title="<spring:message code='title.adminNote'/>">
						</span>
					</td>
				</tr>
				<c:if test="${item.CO eq item.GRP_DTNUMBER}">
					<tr class="total UcAmountRow"><!-- [D] 합계행에는 tr에 클래스 total 추가 -->
						<td><a href="javascript:void(0);" class="under_line" data-del="all" data-row="${pgNum+status.index }" onclick="javascript:fn_groupSelect(this);">전체선택</a></td>
						<td class="ar_w_dedt">
							<span class="input_type">
								<input type="text" id="AM_W_DEDT${pgNum+status.index }" name="AM_W_DEDT" class="_datepick" style="text-align: center;" 
											onchange="javascript:fn_setDate(this,${pgNum+status.index });" value="${item.W_DEDT}" data-dedt="${item.W_DEDT}" data-amrow="${pgNum+status.index }" maxlength="10" 
											title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
											
								<input type="hidden" name="minimumQy" value="${item.MUMM_ORDER_QY }"/>
							</span>
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
							<%-- <input type="text" id="qySm${status.index }" name="qySm" class="t_c readOnly" style="width:100%;" value="<c:out value="${item_GRP_QUANTITYAM}"/>" readonly="readonly"> --%>
							<input type="text" id="qySm${pgNum+status.index }" name="qySm" class="t_c readOnly" style="width:100%;" value="" readonly="readonly">
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td>
							<input type="text" id="am${pgNum+status.index }"class="t_c readOnly" style="width:100%;" value="<c:out value="${item_GRP_SUMAM}"/>" readonly="readonly">
						</td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</c:if>
			</c:if>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="18" >
				조회된 결과가 없습니다.
				<input type="text" id="itemListStartDt" value="${listStartDt}" >
				<input type="text" id="listTotalCnt" value="${listTotalCnt}"/>
				<input type="hidden" id="userSe" value="${userSe}"/>
			</td>
			
		</tr>
	</c:otherwise>
</c:choose>
