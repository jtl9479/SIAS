<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 팝업 OutLine -->
<!-- <div id="popOutLine" class="popup_wrap" style="display:block;"> -->
<div id="popOutLine" class="popup_wrap" style="display:none;">
	<div class="popup_con" style="width:740px;">
		<h1 class="pop_tit"><!-- 팝업명 --></h1>
		<a href="#" class="btn_close" id="popClose" tabindex="0" ><span class="blind">닫기</span></a>
		
		<div class="popup_con_in" >
			<div id="popPage">
			
			</div>
		</div>
		
	</div>
</div>
<script type="text/javascript">
	var jsPopId ="";

	$(document).ready(function() {
		$(".popOpen").on("click", function(e){
			e.preventDefault();
			jsPopId = $(this).attr("data-popup");
			$("#popOutLine .popup_con .pop_tit").text($(this).text())
			if (!gfn_isNull(jsPopId)) {
				var jsOrdBplc = $("#searchBplcCode").val();
				if(jsPopId =="DVRBCNC"){
					if(gfn_isNull(jsOrdBplc)){
						alertBox("사업장을 선택해주세요.");
						return;
					}
				}
				
				$("#popPage").empty();
				$("#popOutLine").css("display", "block");
				//$( "body" ).css("overflow","hidden"); 팝업에서 값 선택시 스크롤 사라짐
				//$(".popup_con").append("<div class='popup_con_in' id='popPage'>");
				
				var data = {};
				data.name = jsPopId;
				comAjax('', '/popup/popPage.do', data, fn_popupCallBack);
			}
		});
		
		$("#popClose").on("click", function(e){
		    e.preventDefault();
		    $("#popOutLine").css("display", "none");
		    $( "body" ).css("overflow","");
		    $(".popup_con").css("height" ,""); // 비밀번호 변경에서 사이즈 변경해서 닫을시 초기화
		    $(".popup_con").css("width" ,"740px"); // 비밀번호 변경에서 사이즈 변경해서 닫을시 초기화
		});
	});
	
	function fn_popupCallBack(result){
		$("#popPage").append(result).trigger("create");
		fn_popContents();
		//fn_dlvyDeCeck();
	}

</script>