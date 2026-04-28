<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> -->
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>웹 수발주 시스템</title>
	<script type="text/javascript">
		var jsListUrl = "list.do";
		var jsInsertUrl = "insPg.do";
		var jsUpdateUrl = "udtPg.do";
		var jsMsgAlertFocus = "<spring:message code='alert.alertFocus'/>";
		var jsMoreAt= "";
		
		$(document).ready(function(){
			$("input[name=pg]").val(1);
			
			//공지사항 초기 load
			fn_listMore();
		});
		
		//조회
		function fn_searchList(){
			jsMoreAt = "SEARCH";
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
		};
		
		//더보기
		function fn_listMore(){
			jsMoreAt = "";
			comAjax('searchFrm', jsListUrl, '', fn_listCallBack);
		}
		
		//더보기 CallBack
		function fn_listCallBack(data){
			if(!gfn_isNull(jsMoreAt)){
				$("#listBody").html(data).trigger("create");	
			}else {
				$("#listBody").append(data).trigger("create");
			}
			$("input[name=pg]").val(Number($("input[name=pg]").val())+1);
			$("input[name=totalCnt]").val($("input[name=listTotalCnt]").val());
			$("input[name=listTotalCnt]").remove();
			
			var listCnt = Number($("tr[class='UcItemRow']").length);
			var totalCnt = Number($("input[name=totalCnt]").val());
			//글자수 체크 처음로드시 필요하므로 CallBack에서 호출
			
			if (totalCnt <= listCnt ) {
				$("#moreBtn").hide();
			} else {
				$("#moreBtn").show();
			}
		}			
		
		//검색납기일 유효성
		function fn_searchItemDedt(){
			var from = $("input[name=dtFrom]");
			var to = $("input[name=dtTo]");
			var jsDtFrom = fn_validDedt($("input[name=searchDtFrom]"));
			var jsDtTo = fn_validDedt($("input[name=searchDtTo]"));
			
			if(!jsDtFrom){
				$("input[name=searchDtFrom]").val(gfn_dtSubString(from));
			}
			if(!jsDtTo){
				$("input[name=searchDtTo]").val(gfn_dtSubString(to));
			}
		}
		
		//공지사항 등록
		function fn_noticeInsert(){
			comSubmit('', '', jsInsertUrl);
		}
		
		//공지사항 상세보기
		function fn_noticeViewPg(num) {
			//json 파싱 데이터 배열
			var data = {};
			data.SEQNO = num;
			comSubmit('', data, jsUpdateUrl);
		}
		
		
	</script>
</head>
<body>
	<div class="container">
		<div class="con_wrap_one">
			<h2 class="title">공지사항</h2>
			
			<form id="searchFrm" name="searchFrm">
				<input type="hidden" name="pg" value="1">
				<div class="box_gray">
					<ul class="srch_list">
						<li>
							<strong class="tit w_10">공지시작일자</strong>
							<div class="col w_20">
								<fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" />
								<fmt:parseDate  var="item_searchDtTo" value="${searchDtTo}" pattern="yyyyMMdd" />
								<fmt:formatDate var="dtTo" value="${item_searchDtTo}" pattern="yyyy-MM-dd" />
								<span class="input_type w_40">
									<input type="text" class="_datepick" name="searchDtFrom" value="${dtFrom}" onchange="javascript:fn_searchItemDedt();" 
										onkeydown="javascript:fn_searchKeydown();" maxlength="10" title="<spring:message code='title.dtFrom' />" placeholder="<spring:message code='search.dtFormat' />"/>
								</span>
								&nbsp;~&nbsp;
								<span class="input_type w_40">
									<input type="text" class="_datepick" name="searchDtTo" value="${dtTo}" onchange="javascript:fn_searchItemDedt();" 
										onkeydown="javascript:fn_searchKeydown();" maxlength="10" title="<spring:message code='title.dtTo' />" placeholder="<spring:message code='search.dtFormat' />"/>
								</span>
							</div>
							<strong class="tit w_10">검색어</strong>
							<div class="col w_55">
								<span class="input_type w_80">
									<input type="text" name="searchTitle" value="${searchTitle}" title="<spring:message code='title.searchTitle' />" placeholder="<spring:message code='search.title' />" maxlength="100"/>
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
			
			<form id="listFrm">
				<input type="hidden" name="dtFrom" value="${searchDtFrom }">
				<input type="hidden" name="dtTo" value="${searchDtTo }">
				<div class="tb-type01">
					<table>
						<colgroup>
							<col width="4%">
							<col width="*">
							<col width="15%">
							<col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th>NO</th>
								<th>제목</th>
								<th>공지기간</th>
								<th>작성자</th>
							</tr>
						</thead>
						<tbody id="listBody"></tbody>
					</table>
				</div>
				<!-- // tb-type01 -->
			</form>
			<div class="btn_wrap t_r">
				<input type="hidden" name="totalCnt" value="${totalCnt}" >
				<a href="#" id="moreBtn" class="btn_m btn_white" onclick="javascript:fn_listMore();"><b>더보기</b></a>
			</div>
		</div>
		<!-- // con_wrap_one -->
		
		<div class="btn_fixed_wrap">
			<span class="btn_wrap">
				<a href="#" class="btn_decide btn_l btn_dgray" onclick="javascript:fn_noticeInsert();"><span>등록</span></a>
				<a href="#" class="btn_top btn_white"><span>TOP</span></a>
				<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
			</span>
		</div>
		<!-- 	// btn_fixed_wrap -->
	
	</div>
	<hr>
	<!-- // container -->
</body>
<!-- </html> -->
