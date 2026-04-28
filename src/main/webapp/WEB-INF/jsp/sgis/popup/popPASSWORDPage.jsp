<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form name="popSearchFrm" id="popSearchFrm">
	<input type="hidden" name="popPg" value="1"><!-- filter List.do pg필요 -->
	<div id="popList">
		<div class="tb-type01" style="margin-top: 30px; height:180px;">
			<table class="table-hover" style="height:130px;">
				<colgroup>
					<col width="40%">
					<col width="*%">
				</colgroup>
				<tr>
					<td>변경 비밀번호 입력</td>
					<td>
						<span class="input_type w_100">
							<input type="password" name="password"/>
						</span>
					</td>
				</tr>
				<tr>
					<td>변경 비밀번호 입력 확인</td>
					<td>
						<span class="input_type w_100">
							<input type="password" name="passwordChk"/>
						</span>
					</td>
				</tr>
				<tr>
					<td style="border-bottom: 0px;" colspan="2">
						<span id="pwMsg" style="float:left;">*비밀번호는 8자리 이상으로 변경 가능 합니다.</span>
					</td>
				</tr>
			</table>
			<div class="btn_wrap t_r">
				<a href="#" class="btn_m btn_white" id="popUdtBtn"onclick="javascript:fn_popPWChg();"><b>변경</b></a>
			</div>
		</div>
	</div>
</form>

<script type="text/javascript">

	$(document).ready(function() {
		$("input[name=popPg]").val(1);
		fn_popContents();
	});
	
	function fn_popContents(){
		$(".popup_con").css("width", "370px");
		$(".popup_con").css("height", "300px");
	}
	
	// 유효성 확인
	function fn_popPWChg(){
		var jsPw = $.trim($("input[name=password]").val().replace(/\s+/g, ' '));
		var jsPwChk = $.trim($("input[name=passwordChk]").val().replace(/\s+/g, ' '));
		
		$("#pwMsg").removeClass("text_red");
		if(jsPw.length < 8){
			$("#pwMsg").addClass("text_red");
			$("#pwMsg").text("*비밀번호는 8자리이상 입력해주세요.");
			return false;
		}
		if(jsPwChk.length < 8){
			$("#pwMsg").addClass("text_red");
			$("#pwMsg").text("*비밀번호 확인은 8자리이상으로 입력해주세요.");
			return false;
		}
		if(jsPw != jsPwChk){
			$("#pwMsg").addClass("text_red");
			$("#pwMsg").text("*비밀번호가 일치하지 않습니다.");
			return false;
		}else{
			// popSearchFrm 임시로 id,name설정
			comAjax('popSearchFrm', '/popup/popPassword.do', '', fn_popPWChgCallback);
		}
		
		function fn_popPWChgCallback(data){
			var jsResult = data.result;
			
			if(jsResult > 0){
				$("#popClose").trigger("click");
				alertBox("비밀번호가 변경되었습니다.");
			}else{
				console.log("변경실패");
			}
		}
	}
</script>
