<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
			var jsListUrl = "list.do";
			var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
			var jsMoreAt= "";
			
			$(document).ready(function(){
				fn_listMore();
			});
			
			//더보기
			function fn_listMore(){
				jsMoreAt = "";
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//조회
			function fn_searchList(){
				jsMoreAt = "NOT";
				var jsSearchGroup = $("select[name=searchDtGroup]").val();
				var jsDtFrom = $("input[name=searchDtFrom]").val();
				var jsDtTo = $("input[name=searchDtTo]").val();
				
				var jsMaxDt = new Date(Date.parse(jsDtFrom) + (364*24*60*60*1000)); //시작일 기준 1년후
				var jsParseFrom = new Date(Date.parse(jsDtFrom));
				var jsParseTo = new Date(Date.parse(jsDtTo));
				
				if(jsParseTo.getTime() < jsParseFrom.getTime()){ //시작일이 종료일보다 큰경우
					alertBoxFocus("<spring:message code='alert.searchDtError'/>", $("input[name=searchDtFrom]"));
					return false;
				}else if(jsMaxDt.getTime() < jsParseTo.getTime()){ //1년후 날짜가 종료일보다 큰경우
					alertBox("<spring:message code='alert.searchMaxDt'/>");
					jsMaxDt = jsMaxDt.getFullYear() +"-"+
							(jsMaxDt.getMonth()+1 < 10 ? "0" : "") + (jsMaxDt.getMonth()+1) +"-"+
							(jsMaxDt.getDate() < 10 ? "0" : "") + jsMaxDt.getDate();
					jsDtTo = jsMaxDt;
				}
				
				$("input[name=searchDtFrom]").val(jsDtFrom);
				$("input[name=searchDtTo]").val(jsDtTo);
				$("input[name=pg]").val(1);
				$("input[name=totalCnt]").val(0);
				$("input[name=pgNum]").val(0); //초기화
				$("input[name=listStartDt]").val(""); //초기화
				
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//더보기Callback
			function fn_listCallBack(data){
				if(!gfn_isNull(jsMoreAt)){
					$("#listBody").html(data).trigger("create");
				}else{
					$("#listBody").append(data).trigger("create");
				}
				var jsListStartDt =  $("#itemListStartDt").val();	
				var jsListPgNum =  $("#itemPgNum").val();
				var jsListTotalCnt = $("#listTotalCnt").val();
				
				if (!gfn_isNull(jsListStartDt)) $("input[name=listStartDt]").val(jsListStartDt);
				if (!gfn_isNull(jsListPgNum)) $("input[name=pgNum]").val(jsListPgNum);
				if (!gfn_isNull(jsListTotalCnt)) $("input[name=totalCnt]").val(jsListTotalCnt);
				
				$("#itemListStartDt").remove();
				$("#itemPgNum").remove();
				$("#listTotalCnt").remove();
				
				var listCnt = Number($("tr[class='UcItemRow']").length);
				var totalCnt = Number($("input[name=totalCnt]").val());
				
				if (totalCnt <= listCnt ) {
					$("#moreBtn").hide();
				} else {
					$("#moreBtn").show();
				}
			}
			
			//검색납기일 유효성
			function fn_searchItemDedt(){
				var jsWeekAgo = $("input[name=weekAgo]");
				var jsCurDedt = $("input[name=curDedt]");
				var jsDtFrom = fn_validDedt($("input[name=searchDtFrom]"));
				var jsDtTo = fn_validDedt($("input[name=searchDtTo]"));
				
				if(!jsDtFrom){
					$("input[name=searchDtFrom]").val(gfn_dtSubString(jsWeekAgo));
				}
				if(!jsDtTo){
					$("input[name=searchDtTo]").val(gfn_dtSubString(jsCurDedt));
				}
			}
			
		</script>
	</head>
	<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">주문 완료 조회</h2>
			<form id="searchFrm" name="searchFrm" method="POST">
				<input type="hidden" name="pg" value="1">
				<input type="hidden" name="pgNum" value="0" />
				<input type="hidden" name="listStartDt" value="${listStartDt }"/>
				<input type="hidden" name="totalCnt"/>
				<input type="hidden" name="weekAgo" value="${weekAgo }">
				<input type="hidden" name="curDedt" value="${curDedt }">
				<div class="box_gray">
					<ul class="srch_list">
						<li>
							<div class="col w_35">
								<span class="input_type w_30">
									<select name="searchDtGroup" id="">
										<option value="orderDe">주문일자</option>
										<option value="dedt">납기일자</option>
									</select>
								</span>
								<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
								<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
								<span class="input_type w_25">
									<input type="text" name="searchDtFrom" value="${dtFrom}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
										onkeydown="javascript:fn_searchKeydown();"title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />">
								</span>
								&nbsp;~&nbsp;
								<span class="input_type w_25">
									<input type="text" name="searchDtTo" value="${dtTo}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
										onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
								</span>
							</div>
	
							<strong class="tit w_10">도착지업체</strong>
							<div class="col w_20">
								<span class="input_type w_100">
									<input type="text" id="searchEntrpsNm" name="searchEntrpsNm" value="${searchEntrpsNm}" placeholder="<spring:message code='search.dlvyInput'/>" maxlength="25">
									<input type="hidden" id="searchDlvyEntrps" name="searchDlvyEntrps" value="${searchDlvyEntrps}"/>
								</span>
							</div>
	
							<strong class="tit w_10">제품</strong>
							<div class="col w_25">
								<span class="input_type w_70">
									<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" maxlength="40"/>
								</span>
								<span class="btn_search w_25"><a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a></span>
							</div>
						</li>
					</ul>
				</div>
			</form>
			<!-- //box_gray -->
			
			<ul class="impor_text">
				<c:if test="${subMenu.A_USE_AT eq 'Y' }">
					${subMenu.MENU_A}
				</c:if>
				<c:if test="${subMenu.B_USE_AT eq 'Y' }">
					${subMenu.MENU_B}
				</c:if>
			</ul>
			
			<form id="listFrm" name="listFrm">
				<div class="tb-type01">
					<table>
						<colgroup>
							<col width="4%">
							<col width="8%">
							<col width="*">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="6%">
							<col width="12%">
							<col width="14%">
						</colgroup>
						<thead>
							<tr>
								<th>NO</th>
								<th style="min-width:70px;">납기일자</th>
								<th style="min-width:180px;">제품</th>
								<th style="min-width:50px;">규격</th>
								<th style="min-width:50px;">수량</th>
								<th style="min-width:50px;">중량(KG)</th>
								<th style="min-width:30px;">단위</th>
								<th>금액</th>
								<th style="min-width:120px;">도착지업체</th>
								<th style="min-width:120px;">비고</th>
							</tr>
						</thead>
						<tbody id="listBody"></tbody>
					</table>
				</div>
			</form>
			<!-- // tb-type01 -->
			<div class="btn_wrap t_r">
				<a href="javascript:void(0);" class="btn_m btn_white" id="moreBtn" name="moreBtn" onclick="javascript:fn_listMore();"><b>더보기</b></a>
			</div>
		</div>
		<!-- // con_wrap_one -->
		<hr>
		<div class="btn_fixed_wrap">
			<span class="btn_wrap">
				<a href="#" class="btn_top btn_white"><span>TOP</span></a>
				<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
			</span>
		</div>
		<!-- 	// btn_fixed_wrap -->
	</div>
	<!-- // container -->
	<hr>
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
<!-- </html> -->
