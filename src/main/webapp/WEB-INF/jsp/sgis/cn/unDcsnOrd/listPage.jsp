<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
	<head>
		<script type="text/javascript">
			var jsListUrl = "list.do";
			var jsPageUrl = "page.do";
			var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
			
			$(document).ready(function(){
				fn_listMore();
				fn_indictLmtt();
			});
			
			function fn_listMore(){
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//조회
			function fn_searchList(){
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
				
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			
			//테이블리스트 CallBack
			function fn_listCallBack(data){
				$("#listBody").html(data).trigger("create");
				$("input[name=totalCnt]").val($("input[name=listTotalCnt]").val());
				$("input[name=listTotalCnt]").remove();
				fn_tabAddOn();
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
			
			//도착지 업체
			function fn_dlvyList(idx){
				var jsAlocEntrps = $("input[name=W_ALOCENTRPS]").eq(idx).val();
				$("input[name=ALOCENTRPS]").val(jsAlocEntrps);
				
				comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
			}
			//재고상태 표시 제한
			function fn_indictLmtt(){
				var jsTbody = $("#listBody").find("table > tbody");
				var jsUcItemRow = $(jsTbody).find("tr.UcItemRow");
				var jsAmRow = $(jsTbody).find("tr.UcAmountRow");
				var jsIvColor = $("input[name=IV_COLOR]"); //재고상태 색상값
				var qySm = 0;
				
				//오늘 날짜
				var jsDate = new Date(); 
				var jsNewDate = new Date(jsDate); 
				jsNewDate.setDate(jsNewDate.getDate()); 
				var jsNowDate = new Date(jsNewDate).toISOString().split("T")[0].replace(/-/gi, "");
				
				//jsBdate="이전일", jsCdate="현재일"
				var jsBdate="", jsCdate="";
				
				$(jsUcItemRow).each(function(index){
					//첫번째 행에서는 Bdate와 Cdate에 동일한 값을 부여한다.
					if(index == 0) jsBdate = $("input[name=W_DEDT]").eq(index).val();
					jsCdate = $("input[name=W_DEDT]").eq(index).val();	
					
					//날짜변경시에는 그룹중량합계에 값 설정
					if(jsBdate != jsCdate){
						$("#qySm"+(index-1)).val(gfn_replaceAdd(qySm));
						qySm = 0;
						jsBdate = jsCdate;
					}
					
					//재고상태가 녹생인 경우에만 중량합계 누적계산
					if(jsIvColor.eq(index).val().toUpperCase() == "G"){
						qySm += parseFloat($("input[name=W_WT]").eq(index).val().replace(/,/gi,""));
					}
					
					//마지막 행일 경우 index 번호 그대로 값 설정
					if(index == ($(jsUcItemRow).length -1)){
						$("#qySm"+index).val(gfn_replaceAdd(qySm));	
					}
					
				});
				 
				//그룹합계 행 체크
				$(jsAmRow).each(function(idx){
					if($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("input[name=AM_W_DEDT]").val().replace(/-/gi, "") < jsNowDate){
						fn_findDedt($(jsAmRow).find("td.ar_w_dedt").eq(idx).find("input[name=AM_W_DEDT]").val());
					}
				});
			}
			
			//표시 제한할 재고상태 체크
			function fn_findDedt(dedtDate){
				var jsTbody = $("#listBody").find("table > tbody");
				var jsUcItemRow = $(jsTbody).find("tr.UcItemRow");
				
				$(jsUcItemRow).each(function(idx){
					if($(jsUcItemRow).find("td.i_sttus").eq(idx).data("dedt") == dedtDate){
						$(jsUcItemRow).find("td.i_sttus").eq(idx).find("span").removeClass();
					}
				});
			}
			
			//저장
			function fn_saveItem(){
				//체크박스없어서 갯수여부안함
				if($("#listFrm .UcItemRow").length < 1){
					return;
				}else{
					confirmBox("<spring:message code='confirm.noteSave'/>", fn_saveItemConfirm, 'listFrm');
				}
			}
			
			//confirm 저장
			function fn_saveItemConfirm(){
				comAjax('listFrm', '/unDcsnOrd/update.do', '', fn_saveItemCallBack);
			}
			
			//저장CallBack
			function fn_saveItemCallBack(data){
				var jsResult = data.udtResult;
				
				if(Number(jsResult < 0)){
					alertBox("<spring:message code='alert.orderFailed'/>");
				}
			}
			
			//해당업체 클래스on추가
			function fn_tabAddOn(){
				var jsAlocEntrps = $("input[name=ALOCENTRPS]").val();
				
				$(".dlvyList").parent().removeClass("on");
				$("input[name=W_ALOCENTRPS]").each(function(idx){
					if(gfn_isNull(jsAlocEntrps)){
						$(".dlvyList").parent().eq(0).addClass("on");
					}else if($("input[name=W_ALOCENTRPS]").eq(idx).val() == jsAlocEntrps){
						$(".dlvyList").parent().eq(idx).addClass("on");
					}
				});
				
				//재고상태 표시 제한
				fn_indictLmtt();
			}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="con_wrap_one">
				<h2 class="title">주문 접수 진행중...</h2>
				<form id="searchFrm" name="searchFrm" method="POST">
					<input type="hidden" name="ALOCENTRPS">
					<input type="hidden" name="pg" value="1">
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<div class="col w_35">
									<span class="input_type w_30">
										<select name="searchDtGroup" id="searchDtGroup">
											<option value="orderDe" selected>주문일자</option>
											<option value="dedt">납기일자</option>
										</select>
									</span>
									<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
									<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
									<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
									<span class="input_type w_25">
										<input type="text" name="searchDtFrom" value="${dtFrom}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />"/> 
									</span>
									&nbsp;~&nbsp;
									<span class="input_type w_25">
										<input type="text" name="searchDtTo" value="${dtTo}" class="_datepick" maxlength="10" onchange="javascript:fn_searchItemDedt();" 
											onkeydown="javascript:fn_searchKeydown();" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
									</span>
								</div>
								<strong class="tit w_5">제품</strong>
								<div class="col w_60">
									<span class="input_type w_80">
										<input type="text" id="searchItemNm" name="searchItemNm" value="${searchItemNm}" title="<spring:message code='title.itemNm' />" placeholder="<spring:message code='search.itemNm' />" maxlength="40"/>
									</span>
									<span class="btn_search w_15">
										<a href="#" id="searchBtn" class="btn_s btn_white_l" onclick="javascript:fn_searchList();">조회</a>
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
				
				<form id="listFrm" name="listFrm">
					<input type="hidden" name="totalCnt" value="${totalCnt }">
					<input type="hidden" name="weekAgo" value="${weekAgo }">
					<input type="hidden" name="curDedt" value="${curDedt }">
					<div id="listBody">
						
					</div>
				</form>
			</div>
			<!-- // con_wrap_one -->
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" class="btn_save btn_l btn_red" onclick="javascript:fn_saveItem();"><span>저장</span></a>
					<a href="#" class="btn_top btn_white"><span>TOP</span></a>
					<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
				</span>
			</div>
			<!-- 	// btn_fixed_wrap -->
		</div>
		<hr>
	</body>
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->
<!-- </html> -->
