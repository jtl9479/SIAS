<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="box_gray">
	<ul class="srch_list">
		<li>
			<strong>검색어</strong>
			<div class="col">
				<form id="popSearchFrm" name="popSearchFrm" >
					<span class="input_type w_80">
						<input type="text" name="searchData1" placeholder="업체명을 입력해주세요.">
						<input type="hidden" name="popPg" value="1"><!-- filter List.do pg필요 -->
						<input type="hidden" name="popTotalCnt" >
					</span>
					<span class="btn_search w_15"><a href="#"  id="popSearch" class="btn_s btn_white_l">조회</a></span>
				</form>
			</div>
		</li>
	</ul>
</div>
<!-- //box_gray -->	
<div id="popList"></div>

<div class="btn_wrap t_r">
	<span class="text_red" id="unclExAtMsg" style="float:left;"></span>
	<a href="#" class="btn_m btn_white" id="popMoreBtn"onclick="javascript:fn_popContents();"><b>더보기</b></a>
</div>

<script type="text/javascript">
	$(document).ready(function() {
		$("#popSearch").on("click", function(e){
			$("input[name=popPg]").val(1);
		    e.preventDefault();
		    fn_popContents();
		});
	});
	
	function fn_popContents(){
		var data = {};
		var jsOrdBplc = $("#searchBplcCode").val();
		
		if(!gfn_isNull(jsOrdBplc)){
			data.ordBplc = jsOrdBplc;	
		}
		
		comAjax('popSearchFrm', '/popup/popDVRBCNCList.do', data, fn_popContentsCallBack);
		
		/* 처음 거래처클릭시 팝업생성시 거래처리스트 가져와야해서 주석처리
		//더보기 버튼 제어
		$("#popMoreBtn").hide();
		
		//검색어를 입력했을 때만 검색할 수 있도록 변경
		var jsPopSearchData = $("#popSearchFrm > span > input[name=searchData1]").val(); 
		
		if(jsPopSearchData.length > 0){
			comAjax('popSearchFrm', '/popup/popDVRBCNCList.do', '', fn_popContentsCallBack);		
		} 
		*/
	}
	
	function fn_popContentsCallBack(result){
		//목록 초기화
		$("#popList").empty();
		// 검색조건에 대한 목록 처리 부분
		$("#popList").append(result).trigger("create");
		
		//더보기
		$("#popSearchFrm").find("input[name=popPg]").val(Number($("#popSearchFrm").find("input[name=popPg]").val())+1);
		$("input[name=popTotalCnt]").val($("input[name=popListTotalCnt]").val());
		$("input[name=popListTotalCnt]").remove();
		
		var listCnt = Number($("tr[class='PopUcItemRow']").length);
		var totalCnt = Number($("input[name=popTotalCnt]").val());
		
		if (totalCnt <= listCnt) {
			$("#popMoreBtn").hide();
		} else {
			$("#popMoreBtn").show();
		}
	}
</script>
