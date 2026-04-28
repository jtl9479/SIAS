<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<c:choose>
	<c:when test="${fn:length(dlvyList) > 0 }">
		<ul class="tab_type">
			<c:forEach items="${dlvyList }" var="item" varStatus="status">
				<li data-tab="tab">
					<a href="#" class="dlvyList" onclick="javascript:fn_dlvyList(${status.index});"> ${item.DLVY_ENTRPS_NM }</a>
					<input type="hidden" name="H_ALOCENTRPS" value="${item.W_ALOCENTRPS }"/>
				</li>			
			</c:forEach>
		</ul>
	</c:when>
</c:choose>

<div id="tab-1" class="tab_con_wrap on">
	<div class="tb-type01">
		<!-- 태영 format추가 -->
		<fmt:parseDate  var="dlvyView_DEADLINE" value="${dlvyView.DEADLINE}" pattern="yyyyMMdd" />
		<fmt:formatDate var="DEADLINE" value="${dlvyView_DEADLINE}" pattern="yyyy-MM-dd" />
		
		<input type="hidden" name="dlvyMon" id="dlvyDay01" title="<spring:message code='title.monday'/>" value="${dlvyView.DLVY_MON }"> 
   		<input type="hidden" name="dlvyTue" id="dlvyDay02" title="<spring:message code='title.tuesday'/>" value="${dlvyView.DLVY_TUE }"> 
   		<input type="hidden" name="dlvyWen" id="dlvyDay03" title="<spring:message code='title.wednesday'/>" value="${dlvyView.DLVY_WEN }"> 
   		<input type="hidden" name="dlvyThur" id="dlvyDay04" title="<spring:message code='title.thursday'/>" value="${dlvyView.DLVY_THUR }"> 
   		<input type="hidden" name="dlvyFri" id="dlvyDay05" title="<spring:message code='title.friday'/>" value="${dlvyView.DLVY_FRI }"> 
   		<input type="hidden" name="dlvyDeCeck" id="dlvyDeCeck_0" value="${dlvyView.DLVY_DE_CECK }">
   		<input type="hidden" name="minimumQy" value="${dlvyView.MUMM_ORDER_QY }">
		<input type="hidden" name="DEADLINE" value="${DEADLINE}" />
		<!-- 공휴일 -->
		<c:forEach items="${holidayList }" var="day" varStatus="status">
			<input type="hidden" name="CLDR_DEDT" value="${day.CLDR_DEDT}">
		</c:forEach>
		<table>
			<colgroup>
				<col width="4%">
				<col width="80px">
				<col >
				<col width="80px">
				<col width="60px">
				<col width="60px">
				<col width="60px">
				<col width="65px">
				<col width="15%">
				<col >
				<col width="4%">
			</colgroup>
			<thead>
				<tr>
					<th><a href="#" onclick="javascript:fn_allChkSetValue('selectItem');">*선택</a></th>
					<th>납기일자</th>
					<th>제품</th>
					<th>규격</th>
					<th>수량<br>(BOX)</th>
					<th>중량<br>(KG)</th>
					<th>재고상태<br>BOX(KG)</th>
					<th>금액</th>
					<th>도착지업체</th>
					<th>비고</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
				<c:set var="itemDATE" value=""/>
				<c:choose>
					<c:when test="${fn:length(basketList) > 0 }">
						<c:forEach items="${basketList }" var="item" varStatus="status">
							<fmt:parseDate  var="W_DEDT" value="${item.W_DEDT}" pattern="yyyyMMdd" />
							<fmt:formatDate var="item_W_DEDT" value="${W_DEDT}" pattern="yyyy-MM-dd" />
							<fmt:formatNumber  var="item_UPC_NEWUNITPC" value="${item.UPC_NEWUNITPC}" pattern="#,###.####" />
							<!--영완 format추가-->
							<fmt:formatNumber  var="item_W_SUMAMOUNT" value="${item.W_SUMAMOUNT}" pattern="#,###.####" />
							<fmt:formatNumber  var="item_W_QUANTITY" value="${item.W_QUANTITY}" pattern="#,###.####" />
							<fmt:formatNumber  var="item_W_WT" value="${item.W_WT}" pattern="#,###.####" />
							<fmt:formatNumber  var="item_GRP_QUANTITYAM" value="${item.GRP_QUANTITYAM}" pattern="#,###.####" />
							<fmt:formatNumber  var="item_GRP_SUMAM" value="${item.GRP_SUMAM}" pattern="#,###.####" />
							<!-- 재고상태 -->
							<fmt:parseNumber var="INVNTRY" value="${(item.INVNTRY_QY / item.IC_PACKNGUNIT / item.IC_UNITQY)}" integerOnly="true" />
							<fmt:parseNumber var="ORG_INVNTRY" value="${item.INVNTRY_QY}" integerOnly="true" />
							<fmt:formatNumber  var="ITEM_INVNTRY" value="${ORG_INVNTRY}" pattern="###,###" />
							
							<tr class="UcItemRow" data-dedt="${item_W_DEDT}" data-rowNo="${status.index}">
								<c:if test="${itemDATE ne item.W_DEDT}">
									<td class="UcFirstRow" rowspan="${item.CO}" data-dedt="${item_W_DEDT}">
										<input type="checkbox" name="selectItem" id="selectItem_${item_W_DEDT}" data-dedt="${item_W_DEDT}" data-chkse="sItem"
										onclick="javascript:fn_chkSetValue(this, ${status.index});" <c:if test="${item.W_CHOISE_AT eq 'Y'}"> checked </c:if>/>
										
										<label for="selectItem_${item_W_DEDT}"></label>
										<input type="hidden"  id="selectYn_${status.index }" name="selectYn" value="${item.W_CHOISE_AT}">
										
										<c:set var="itemDATE" value="${item.W_DEDT}"/>
									</td>
								</c:if>
								<td class="center">
									<span class="input_type">
										<input type="text" name="W_DEDT" value="${item_W_DEDT}" class="_datepick" data-dedt="${item_W_DEDT}" data-oldDedt="${item_W_DEDT}"  data-sttus="DEDT" data-fcs="DEDT" 
											maxlength="10" title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
								</td>
								<td class="left">
									<div class="product_name">
										<span class="type_wrap">
											<c:if test="${item.IC_ENT_DVR_SE eq '2'}">
												<i class="common"><em class="blind">전용</em></i>
											</c:if>
											<c:if test="${item.IC_PRDCTN_SE eq '2'}">
												<i class="only"><em class="blind">주문생산</em></i>
											</c:if>
											<!-- <i class="order"><em class="blind">주문생산</em></i>
											<i class="sale"><em class="blind">재고판매</em></i> -->
										</span>
										<em><c:out value="${item.IC_NM}"/></em>
									</div>
								</td>
								<td><c:out value="${item.IC_STNDRD}"/></td>
								<td>
									<span class="input_type w_80">
										<input type="text" style="text-align: center;" name="W_QUANTITY" value="${item_W_QUANTITY}" data-dedt="${item_W_DEDT}"
										data-Qy="${item.W_QUANTITY}" data-oldQy="${item.W_QUANTITY}" data-sttus="QY" data-fcs="QY" data-row="${status.index }"
										title="<spring:message code='title.quantity' />" onchange="javascript:fn_quanChange(this, 1);" onfocus="this.select()"/>
									</span>
								</td>
								<td>
									<input type="text" class="readOnly" name="W_WT" value="<c:out value="${item_W_WT}"/>"readonly="readonly"/>
								</td>
								<td class="i_sttus" data-dedt="${item_W_DEDT }">
									<input type ="hidden" name="I_STTUS_BOX" value="${INVNTRY}">
									<c:if test="${item.DATE_DIFF le 10}">
										<c:if test="${item.INVNTRY_QY le 0}">
											<span class="status_red"></span>
											<input type="hidden" name="IV_COLOR" value="R">
										</c:if>
										<c:if test="${item.INVNTRY_QY gt 0}">
											<c:if test="${(item.INVNTRY_QY - item.W_WT) gt 0}">
												<span class="status_green">
													<c:out value="${INVNTRY}(${ITEM_INVNTRY})"/>
												</span>
												<input type="hidden" name="IV_COLOR" value="G">
											</c:if>
											<c:if test="${(item.INVNTRY_QY - item.W_WT) le 0}">
												<span class="status_yellow">
													<%-- <c:out value="${INVNTRY}"/>(${ITEM_INVNTRY}) --%>
													<c:out value="${INVNTRY}(${ITEM_INVNTRY})"/>
												</span>
												<input type="hidden" name="IV_COLOR" value="Y">
											</c:if>
										</c:if>
									</c:if>
									<c:if test="${item.DATE_DIFF gt 10}">
										<span class="status_green">
											<c:out value="${INVNTRY}(${ITEM_INVNTRY})"/>
										</span>
										<input type="hidden" name="IV_COLOR" value="G">
									</c:if>
								</td>
								<td>
									<!--영완 합계 -->
									<input type="text" style="width: 80px;" class="readOnly" name="W_SUMAMOUNT" value="${item_W_SUMAMOUNT}" readonly="readonly">
								</td>
								<td>
									<c:out value="${item.CM_ENTRPSNM}"/>
								</td>
								<td>
									<span class="input_type w_100">
										<input type="text" name="W_NOTE" value="${item.W_NOTE}" data-fcs="NOTE" placeholder="<spring:message code='title.note'/>">
									</span>
								</td>
								<td>
									<a href="javascript:void(0);" class="under_line" data-del="one" data-row="${status.index }" onclick="javascript:fn_prdDel(this);">삭제</a>
									<input type="hidden" id="delItem_${status.index}" name="delItem" value="N">
									
									<!-- hidden -->
									<input type="hidden" name="cfrmItem" value="${item.W_CHOISE_AT eq 'Y' ? item.W_CHOISE_AT : 'N'}" data-dedt="${item_W_DEDT}">
									
									<input type="hidden" name="IC_CODE" value="<c:out value="${item.IC_CODE}"/>">
									<input type="hidden" name="IC_UNITWT" value="<c:out value="${item.IC_UNITWT}"/>">
								 	<input type="hidden" name="IC_UNITQY" value="<c:out value="${item.IC_UNITQY}"/>">
									<input type="hidden" name="IC_PACKNGUNIT" value="<c:out value="${item.IC_PACKNGUNIT}"/>">
									<input type="hidden" name="UPC_VATINCLSAT" value="<c:out value="${item.UPC_VATINCLSAT}"/>">
								 	<input type="hidden" name="UPC_NEWUNITPC" value="<c:out value="${item.UPC_NEWUNITPC}"/>">
								 	<input type="hidden" name="UPC_UNTPCUNIT" value="<c:out value="${item.W_UNTPCUNIT}"/>">
									<input type="hidden" name="W_UNIT_BPLC" value="<c:out value="${item.W_UNIT_BPLC}"/>">
									<input type="hidden" name="W_DLIVY_BPLC" value="<c:out value="${item.W_DLIVY_BPLC}"/>">
									<input type="hidden" name="W_ALOCENTRPS" value="<c:out value="${item.W_ALOCENTRPS}"/>">
									<input type="hidden" name="W_UNIT_CHRCTR" value="<c:out value="${item.W_UNIT_CHRCTR}"/>">
									
									<input type="hidden" name="W_DE" value="<c:out value="${item.W_DE}"/>">
									<input type="hidden" name="W_SN" value="<c:out value="${item.W_SN}"/>">
									<input type="hidden" name="W_PIECE_QY" value="<c:out value="${item.W_PIECE_QY}"/>">
									<input type="hidden" name="W_GRP_QY" value="<c:out value="${item.W_GRP_QY}"/>">
									<input type="hidden" name="W_SPLPCAM" value="<c:out value="${item.W_SPLPCAM}"/>"/>
									<input type="hidden" name="W_VAT" value="<c:out value="${item.W_VAT}"/>"/>
									
									<input type="hidden" name="IV_COMBINE" value="<c:out value="${INVNTRY}(${ITEM_INVNTRY})"/>">
									
								</td>
							</tr>
							<c:if test="${item.CO  eq item.GRP_DTNUMBER}">
								<tr class="UcAmountRow total" data-dedt="${item_W_DEDT}">
									<td></td>
									<td class="ar_w_dedt">
										<span class="input_type">
											<input type="text" id="AM_W_DEDT${status.index }" name="AM_W_DEDT" class="_datepick" style="text-align: center;" 
											onchange="javascript:fn_setDate(this,${status.index });" value="${item_W_DEDT}" data-dedt="${item_W_DEDT}" data-amrow="${status.index }" maxlength="10" 
											title="<spring:message code='title.itemDt' />" placeholder="<spring:message code='search.dtFormat' />"/>
										</span>
									</td>
									<td></td>
									<td></td>
									<td></td>
									<td>
										<%-- <input type="text" id="qySm${status.index}" class="w_80 readOnly" name="qySm" style="text-align: center;" value="${item_GRP_QUANTITYAM}" readonly="readonly"> --%>
										<input type="text" id="qySm${status.index}" class="w_80 readOnly" name="qySm" style="text-align: center;" readonly="readonly">
									</td>
									<td></td>
									<td><input type="text" id="am${status.index}"   class="w_100 readOnly" name="am"style="text-align: center;" value="${item_GRP_SUMAM}" readonly="readonly"></td>
									<td></td>
									<td></td>
									<td><a href="javascript:void(0);" class="under_line" data-del="all" data-row="${status.index }" onclick="javascript:fn_prdDel(this);">전체삭제</a></td>
								</tr>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
					<tr>
						<td colspan="11" >조회된 결과가 없습니다.</td>
					</tr>
				</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div> <!-- // tb-type01 -->
</div><!-- // tab_con_wrap on -->
