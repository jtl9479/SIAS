<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){
		
	});
	
	//파일 다운로드
	function fn_fileDownload(arg){
		//comAjax('', '/mn/excel/excelDown.do', '', fn_fileDownloadCallBack());
		comSubmit('', '', '/mn/excel/excelDown.do');
	}
	
	//파일 다운로드 callback
	function fn_fileDownloadCallBack(data){
	}
	
	/*
		파일 확인
		arg1[upFileSe] : upload file 종류
		arg2[typeSe] : 수주량, 수주중량 구분
	*/
	function fn_selectFile(upFileSe, typeSe){
		if(gfn_isNull(upFileSe)){ return; }
		if(gfn_isNull(typeSe)){ return; }
		
		var jsBplcNm = $("input[name=searchBplcNm]");
		var jsBplcDate = $("input[name=searchDtFrom]");
		
		if(gfn_isNull($(jsBplcNm).val())){
			alertBox($(jsBplcNm).attr("title") + "이 유효하지 않습니다.");
			return false;
		} 
		
		if(gfn_isNull($(jsBplcDate).val())){
			alertBox($(jsBplcDate).attr("title") + "가 유효하지 않습니다.");
			return false;
		}
		
		$("#inputFile_"+upFileSe+"_"+typeSe).click();
	} 
	
	// 파일선택체크
	function fn_fileChk(upFileSe, typeSe) {
		var jsFileValue = $("#inputFile_"+upFileSe+"_"+typeSe).val().split("\\");
		var jsFileName = jsFileValue[jsFileValue.length-1]; // 파일명
		// 확장자체크
		if (!fn_inputFileChk(jsFileName)) return;
		if (jsFileName.length > 0) {
			$("#" + upFileSe + "_NM_"+typeSe).val(jsFileName);
			fn_fileUpload(typeSe);
			return;
		}
	}
		
	//파일 업로드
	function fn_fileUpload(typeSe){
		var data = {};
		data.UP_TY_SE = typeSe;
		data.BPLC_NM = $("#searchBplcNm").val();
		data.REGIST_BPLC = $("#searchBplcCode").val();
		data.ORD_DE = $("input[name=searchDtFrom]").val();
		
		//comAjaxFile('uploadFrm', '/mn/excel/excelUpload.do', data, fn_fileUploadCallBack);
		comSubmitFile('uploadFrm', data, '/mn/excel/excelUpload.do');
	}
	
	//파일  업로드 callback
	function fn_fileUploadCallBack(data){
		var jsMsg = "";
		if(data.result == 'T'){
			jsMsg = "업로드에 성공하였습니다.<br> 주문접수 등록 메뉴로 이동하시겠습니까? ";
			yesBox(jsMsg, fn_trueFnc, fn_falseFnc, '');
		}else{
			jsMsg = "업로드에 실패하였습니다.";
			alertBox(jsMsg);
			//지정된 서식으로 업로드 진행이 실패되면, 실패 메시지가 뜨고 행,열 사유 정보를 텍스트파일로 다운로드 됨
		}
	}
	
	/*********************************************************************************/
	//업로드 성공시 예
	function fn_trueFnc(data){
		//'예'버튼을 누르면 주문접수등록메뉴로 이동됨
		//comSubmit('', '', '/mn/prdInqire/page.do');
	}
	
	//업로드 성공시 아니오
	function fn_falseFnc(data){
		//'아니오'버튼을 누르면 현재 페이지에 남아있음
		return;
	}
	
	/*********************************************************************************/
	</script>
		
		<div class="container">
			<div class="con_wrap_one">
				<h2 class="title">엑셀업로드</h2>
				<form id="searchFrm" name="searchFrm" method="POST">
					<input type="hidden" name="pg" value="1" />
					<div class="box_gray">
						<ul class="srch_list">
							<li>
								<div class="col w_30">
									<strong class="tit w_10">
										<a href="#this" class="under_line popOpen" data-popup="BPLC" title="<spring:message code='title.bplc' />">주문사업장</a>
									</strong>
									<div class="col w_90">
										<span class="input_type w_100">
											<input type="text" id="searchBplcNm" data-search="BPLC" name="searchBplcNm" value="${ordBplcNm}" class="readOnly"
												title="주문사업장" placeholder="주문사업장을 선택해주세요." onkeyup="javascript:fn_searchKeyup(this);" readonly="readonly">
											<input type="hidden" id="searchBplc" data-nm="BPLC" name="searchBplc">
											<input type="hidden" id="searchBplcCode" data-code="BPLC" name="searchBplcCode" value="${registBplc}">
											<input type="hidden" data-codeSe="BPLC" name="searchBplcSe" value="Y">
										</span>
									</div>
								</div>
								
								<div class="col w_30">
									<strong class="tit w_10">주문일자</strong>
									<div class="col w_90">
										<%-- <fmt:parseDate  var="item_searchDtFrom" value="${searchDtFrom}" pattern="yyyyMMdd" />
										<fmt:formatDate var="dtFrom" value="${item_searchDtFrom}" pattern="yyyy-MM-dd" /> --%>
										<span class="input_type w_100">
											<input type="text" name="searchDtFrom" value="${ordDate}" class="_datepick"
											maxlength="10" title="주문일자" placeholder="<spring:message code='search.dtFormat' />">
										</span>
									</div>
								</div>
							</li>
						</ul>
					</div>
				</form>
				
				<form id="uploadFrm" name="uploadFrm">
					<div class="box_gray">
						<ul class="list_upload">
							<li>
								<strong class="tit">수주량<br/><span>(풀무원, 홈플러스, 뉴이마트)</span></strong>
								<div class="btn_wrap t_r">
									<!-- <a href="#" class="btn_download btn_m btn_white_l" onclick="javascript:fn_fileDownload('EXCEL_FILE');"><span>다운로드</span></a> -->
									<a href="#" class="btn_upload btn_m btn_white_l" onclick="javascript:fn_selectFile('EXCEL_FILE', 'QY');"><span>업로드</span></a>
								</div>
								<div style="display:none;">
									<input type="file" accept="*" id="inputFile_EXCEL_FILE_QY" name="inputFile_EXCEL_FILE_QY" onchange="fn_fileChk('EXCEL_FILE', 'QY');" >
									<input type="text" id="EXCEL_FILE_NM_QY" name="EXCEL_FILE_NM_QY">
								</div>
							</li>
							
							<li>
								<strong class="tit">수주중량<br/><span>(삼성웰스토리, 생협, 롯데마트, 빅마켓)</span></strong>
								<div class="btn_wrap t_r">
									<!-- <a href="#" class="btn_download btn_m btn_white_l" onclick="javascript:fn_fileDownload('EXCEL_FILE');"><span>다운로드</span></a> -->
									<a href="#" class="btn_upload btn_m btn_white_l" onclick="javascript:fn_selectFile('EXCEL_FILE', 'WT');"><span>업로드</span></a>
								</div>
								<div style="display:none;">
									<input type="file" accept="*" id="inputFile_EXCEL_FILE_WT" name="inputFile_EXCEL_FILE_WT" onchange="fn_fileChk('EXCEL_FILE', 'WT');" >
									<input type="text" id="EXCEL_FILE_NM_WT" name="EXCEL_FILE_NM_WT">
								</div>
							</li>
							
						</ul>
					</div>
					<!-- // box_gray -->
				</form>
			</div>
			<!-- // con_wrap_one -->
		
			<div class="btn_fixed_wrap">
				<span class="btn_wrap">
					<a href="#" class="btn_top btn_white"><span>TOP</span></a>
					<a href="#" class="btn_down btn_white"><span>DOWN</span></a>
				</span>
			</div><!-- 	// btn_fixed_wrap -->
		</div>
	<hr><!-- // container -->
	<!-- 팝업 시작-->
	<%@ include file="/WEB-INF/jsp/sgis/popup/popComm.jsp" %>
	<!-- 팝업 종료-->