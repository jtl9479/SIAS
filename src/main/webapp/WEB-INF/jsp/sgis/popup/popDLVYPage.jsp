<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="box_gray">
	<ul class="srch_list">
		<li>
			<strong>업체명</strong>
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
		// 검색 조건 처리 위치
		//comAjax('', '/popup/popDLVYList.do', '', fn_popContentsCallBack);
		
		//관리자 유무 판단, 관리자일 경우 선택된 거래처에 관련된 배송지 업체만 나와야 함
		if($("#adminSE").length > 0){
			var jsAdminSe = $("#adminSE").val();
			
			var data = {};
			data.se = jsAdminSe;
			data.bcncCd = $("#searchBcncCode").val();
			data.ordBplc = $("#searchBplcCode").val();
			comAjax('popSearchFrm', '/popup/popDLVYList.do', data, fn_popContentsCallBack);
		}else {
			comAjax('popSearchFrm', '/popup/popDLVYList.do', '', fn_popContentsCallBack); //pg값보내기 위해 사용	
		}
	}
	
	function fn_popContentsCallBack(result){
		var jsAdminSe = $("#adminSE").val();
		//관리자일경우 출고사업장명칭이 보여야하기 때문에 크기 조정
		if(jsAdminSe == "Y"){
			$(".popup_con").css('width','860px');
		}else {
			$(".popup_con").css('width','740px');
		}
		
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
		
		fn_dlvyDeCeck();
	}
	
	/*
	배송요일 체크 : Y    해당 요일에만 Y 표시
	배송요일체크 : N    월~토 Y 표시 
	*/
	function fn_dlvyDeCeck(){
		$("input[name=dlvyEntrps]").each(function(idx){
			if($("#popDlvyDeCeck_"+idx).val() == "Y"){//배송요일체크가 Y인경우
				for(var cnt=1; cnt<7; cnt++){
					if($("#popDlvyDay"+idx+""+cnt+"").text() == "N"){//배송요일 N인경우
						$("#popDlvyDay"+idx+""+cnt+"").text("");
					}
				}
			}else{//배송요일체크가 N인경우
				for(var cnt=1; cnt<7; cnt++){
					$("#popDlvyDay"+idx+""+cnt+"").text("Y");//배송요일 전부 Y변경
				}
			}
		});
	}
</script>
