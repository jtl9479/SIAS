<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html>
<html> -->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>웹 수발주 시스템</title>
	
		<script type="text/javascript">
			var jsListUrl = "list.do";
			var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
			var jsMoreAt= "";
			
			$(document).ready(function(){
				$("input[name=pg]").val(1);
				fn_listMore();
			});
			
			
			// 조회
			function fn_searchList(){
				jsMoreAt = "NOT";
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
			
			// 목록(더보기)
			function fn_listMore(){
				jsMoreAt = "";
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			function fn_listCallBack(data){
				if(!gfn_isNull(jsMoreAt)){
					$("#listBody").html(data).trigger("create");
				}else{
					$("#listBody").append(data).trigger("create");
				}
				
				// 행번호, 조회종료일자 searchFrm 에 set
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
				<h2 class="title">입고 조회</h2>
				<form id="searchFrm" name="searchFrm">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<strong class="tit w_10">입고일자</strong>
								<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
								<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
								<div class="col w_20">
									<span class="input_type w_40" >
										<input type="text" id="searchDtFrom" name="searchDtFrom" class="_datepick" value="${dtFrom}" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
									&nbsp;~&nbsp;
									<span class="input_type w_40">
										<input type="text" id="searchDtTo" name="searchDtTo" class="_datepick" value="${dtTo}" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
								</div>
		
								<%-- 도착지업체 팝업 
								<strong class="tit w_10">
									<label>
										<a href="#this" class="popOpen" data-popup="DLVY" title="<spring:message code='title.dlvy' />">도착지업체</a>
									</label>
								</strong> --%>
								<strong class="tit w_10">도착지업체</strong>
								<div class="col w_20">
									<span class="input_type w_80">
										<input type="text" id="searchEntrpsNm" name="searchEntrpsNm" value="${searchEntrpsNm}"  placeholder="<spring:message code='search.dlvyInput'/>" maxlength="25"/>
										<input type="hidden" id="searchDlvyEntrps" name="searchDlvyEntrps" value="${searchDlvyEntrps}"/>
									</span>
								</div>
		
								<strong class="tit w_10">제품</strong>
								<div class="col w_30">
									<span class="input_type w_70">
										<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" maxlength="40"/>
									</span>
									<span class="btn_search w_25">
										<a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a>
										<input type="hidden" name="pg" value="1">
										<input type="hidden" name="pgNum" value="0">
										<input type="hidden" name="weekAgo" value="${weekAgo }">
										<input type="hidden" name="curDedt" value="${curDedt }">
										<input type="hidden" name="listStartDt" value="${listStartDt}">
									</span>
								</div>
							</li>
						</ul>
					</div>
					<!-- //box_gray -->
				</form>
				
				<ul class="impor_text">
					<c:if test="${subMenu.A_USE_AT eq 'Y' }">
						${subMenu.MENU_A}
					</c:if>
					<c:if test="${subMenu.B_USE_AT eq 'Y' }">
						${subMenu.MENU_B}
					</c:if>
				</ul>
				
				<form id="listFrm">
					<input type="hidden" name="totalCnt" value="${totalCnt}" >
					<div class="tb-type01">
						<table>
							<colgroup>
								<col width="5%">
								<col width="60px">
								<col width="*">
								<col width="40px;">
								<col width="40px;">
								<col width="40px;">
								<col width="60px;">
								<col width="60px;">
								<col width="6%">
								<col width="60px;">
								<col width="15%">
								<col width="20%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th>입고일자</th>
									<th style="min-width:150px;">제품</th>
									<th>규격</th>
									<th>수량</th>
									<th>단위</th>
									<th>단가</th>
									<th>공급가액</th>
									<th>금액</th>
									<th>부가세</th>
									<th style="min-width:150px;">도착지업체</th>
									<th style="min-width:100px;">비고</th>
								</tr>
							</thead>
							<tbody id="listBody"></tbody>
						</table>
					</div>
					<!-- // tb-type01 -->
				</form>
				<div class="btn_wrap t_r">
					<a href="javascript:void(0)" class="btn_m btn_white" id="moreBtn" onclick="javascript:fn_listMore();"><b>더보기</b></a>
				</div>
			</div>
			<!-- // con_wrap_one -->
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" class="btn_top btn_white"><span>TOP</span></a>
					<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
				</span>
			</div>
			<!-- 	// btn_fixed_wrap -->
		</div>
		<hr>
		<!-- // container -->
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
<!-- </html> -->
