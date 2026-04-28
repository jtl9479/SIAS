
var jsInsFailMsg = "등록을 실패하였습니다.";
var jsUdtFailMsg = "저장을 실패하였습니다.";
var jsDelFailMsg = "삭제를 실패하였습니다.";

var jsSubmitFlag = false;

function gfn_isNullLen(str, len) {
    if (str == null) return true;
    if (str == "NaN") return true;
    if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;
    if (chkStr.toString().length < len ) return true;
    
    return false; 
}
	
function gfn_isNull(str) {
    if (str == null) return true;
    if (str == "NaN") return true;
    if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;    
    if (chkStr.toString().length == 0 ) return true;   
    return false; 
}

function gfn_submitCheck() {
	
    if (jsSubmitFlag) { 
    	return jsSubmitFlag;
    } else { 
    	jsSubmitFlag = true;  return false;
    }
}


/**
 * form 전송 공통처리
 */

function comSubmit(opt_formId,reqData,reqUrl) {
	
	var formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	var formMethod = "post";
	
	if(formId == "commonForm"){
		var frm = $("#commonForm");
        if (frm.length > 0) frm.remove(); 
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
	}
	if (!gfn_isNull(reqData)) {
		$.each (reqData, function(key, value) {
			$("#"+formId).find("[name="+key+"]").remove();
			$("#"+formId).append('<input type="hidden" name="'+key+'" id="'+key+'" value="'+value+'" >');
		});	
	}
	
    var frm = $("#"+formId)[0];
	frm.action = reqUrl;
	frm.method = formMethod;
	frm.submit();
}

function comSubmitFile(opt_formId,reqData,reqUrl) {
	var formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	
	if(formId == "commonForm"){
		var frm = $("#commonForm");
        if (frm.length > 0) frm.remove(); 
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
	}
	
	 var fileData = new FormData(frm);
	
	if (!gfn_isNull(reqData)) {
		$.each (reqData, function(key, value) {
			$("#"+formId).find("[name="+key+"]").remove();
			$("#"+formId).append('<input type="hidden" name="'+key+'" id="'+key+'" value="'+value+'" >');
		});
	}
	
	var frm = document.getElementById(formId);
	frm.method = 'POST';
    frm.enctype = 'multipart/form-data';
    frm.action = reqUrl;
	frm.submit();
}



/**
 * JSON 
 */
function comAjax(opt_formId, reqUrl,  reqData, fv_ajaxCallback) {
	
	var formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId,
		postData = "";
	
	if (formId == "commonForm") {
		
        var frm = $("#commonForm");
        if (frm.length > 0) frm.remove(); 
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
    }
	
	if (!gfn_isNull(reqData)) {
		$.each (reqData, function(key, value) {
			$("#"+formId).find("[name="+key+"]").remove();
			postData += "&" + key + "=" + value;
		});	
	}
	
	if (formId != "commonForm") {
		postData += "&" + $("#" + formId).serialize();
	}
	
	// 중복호출 방지
	if (gfn_submitCheck()) return;
	
	// 더블클릭시 중복호출 발생으로 한번 더 추가 20190617_SGIS_KTY
	jsSubmitFlag = true;
	if($(".modal-buttons").length > 0){
		$(".modal-buttons > .btn-light-blue").css("display","none");
	}
	
	$.ajax({
		url : reqUrl,    
		type : "POST",   
		data : postData,
		async : false, 
		beforeSend : function(xhr) {
			 xhr.setRequestHeader("AJAX",true);
		},
		success : function(data, status) {
		  	
			// 중복호출 구분자 초기화
        	jsSubmitFlag = false;
			
			 //var jsSession = '<%=session.getAttribute("sess_kind") %>';
		  	
			 if(typeof(fv_ajaxCallback) == "function"){
				 fv_ajaxCallback(data);
	        	//setTimeout(fv_ajaxCallback(data), 10000);
			 } else {
				 eval(fv_ajaxCallback + "(data);");
				 //setTimeout(fv_ajaxCallback + "(data);", 10000);
			 }
		} 
	});
}

    	
/**
 * FORM SUBMIT 
 */
function comAjaxFile(opt_formId, reqUrl,  reqData, fv_ajaxCallback) {

	var formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	
	if (formId == "commonForm") {
        var frm = $("#commonForm");
        if (frm.length > 0) frm.remove();
        var str = "<form id='commonForm' name='commonForm'></form>";
        $('body').append(str);
    }
	
	var frm = document.getElementById(formId);
	frm.method = 'POST';
    frm.enctype = 'multipart/form-data';

    var fileData = new FormData(frm);
    
    if (!gfn_isNull(reqData)) {
	    $.each (reqData, function(key, value) {
	    	fileData.append(key,  value);
	    });
    }
	// 중복호출 방지
	if (gfn_submitCheck()) return;
	
    var data = {};
    data.action1 = "ww";
    
	$.ajax({
		url : reqUrl,
        type : 'POST',
        //data : data,
        data : fileData,
        async : false,
        cache : false,
        contentType : false,
        processData : false,
        success : function (data, status) {
        	// 중복호출 구분자 초기화
        	jsSubmitFlag = false;
        	
            if (typeof(fv_ajaxCallback) == "function") {
            	
                fv_ajaxCallback(data);
            } else {
            	
                eval(fv_ajaxCallback + "(data);");
            }
        }
    });
}




/*
divId : 페이징 태그가 그려질 div
pageIndx : 현재 페이지 위치가 저장될 input 태그 id
recordCount : 페이지당 레코드 수
totalCount : 전체 조회 건수 
eventName : 페이징 하단의 숫자 등의 버튼이 클릭되었을 때 호출될 함수 이름
*/
var gfv_pageIndex = null;
var gfv_eventName = null;
function gfn_renderPaging(params){
    var divId = params.divId; //페이징이 그려질 div id
    gfv_pageIndex = params.pageIndex; //현재 위치가 저장될 input 태그
    var totalCount = parseInt(params.totalCount); //전체 조회 건수
    var currentIndex = parseInt($("#"+params.pageIndex).val()); //현재 위치
    var pagePrint = 5;
    
    if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
        currentIndex = 1;
    }
     
    var recordCount = params.recordCount; //페이지당 레코드 수
    if(gfn_isNull(recordCount) == true){
        recordCount = 10;
    }
    if(recordCount < 1) {
    	recordCount = 1;
    }
    
    var totalIndexCount = Math.ceil(totalCount / recordCount); // 전체 인덱스 수
    gfv_eventName = params.eventName;
     
    $("#"+divId).empty();
    var preStr = "";
    var postStr = "";
    var str = "";
     
    var first = (parseInt((currentIndex-1) / pagePrint) * pagePrint) + 1;
    var last = pagePrint; //(parseFloat(totalIndexCount/pagePrint) == parseFloat(currentIndex/pagePrint)) ? totalIndexCount%pagePrint : pagePrint;
    var prev = (parseFloat((currentIndex-1)/pagePrint)*pagePrint) - 4 > 0 ? (parseInt((currentIndex-1)/pagePrint)*pagePrint) - 4 : 1; 
    var next = (parseFloat((currentIndex-1)/pagePrint)+1) * pagePrint + 1 < totalIndexCount ? (parseInt((currentIndex-1)/pagePrint)+1) * pagePrint + 1 : totalIndexCount;
    
    if(pagePrint > totalIndexCount) last= totalIndexCount;
    if((first+last) > totalIndexCount) last= totalIndexCount-first+1;
    
    /*alert("totalIndexCount==="+totalIndexCount);
    alert("first==="+first);
    alert("last==="+last);
    alert("prev==="+prev);
    alert("next==="+next);*/
    
    if(totalIndexCount > pagePrint){ //전체 인덱스가 10이 넘을 경우, 맨앞, 앞 태그 작성
        preStr += "<li><a href='#this' onclick='_movePage(1, this)' class='page page-first'><span class='a11y'>처음</span></a></li>" +
                "<li><a href='#this' onclick='_movePage("+prev+", this)' class='page page-prev'><span class='a11y'>이전</span></a></li>";
    }
    else if(totalIndexCount <=pagePrint && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨앞 태그 작성
        preStr += "<li><a href='#this' onclick='_movePage(1, this)' class='page page-first'><span class='a11y'>처음</span></a></li>";
    }
     
    if(totalIndexCount > pagePrint){ //전체 인덱스가 10이 넘을 경우, 맨뒤, 뒤 태그 작성
        postStr += "<li><a href='#this' onclick='_movePage("+next+", this)' class='page page-next'><span class='a11y'>다음</span></a></li>" +
                    "<li><a href='#this' onclick='_movePage("+totalIndexCount+", this)' class='page page-last' ><span class='a11y'>마지막</span></a></li>";
    }
    else if(totalIndexCount <=pagePrint && totalIndexCount > 1){ //전체 인덱스가 10보다 작을경우, 맨뒤 태그 작성
        postStr += "<li><a href='#this' onclick='_movePage("+totalIndexCount+", this)' class='page page-last' ><span class='a11y'>마지막</span></a></li>";
    }
    
    for(var i=first; i<(first+last); i++){
        if(i != currentIndex){
            str += "<li><a href='#this' onclick='_movePage("+i+", this)' class='page' >"+i+"</a><li>";
        }
        else{
            str += "<li><b><a href='#this' onclick='_movePage("+i+", this)' class='page _active'>"+i+"</a></b><li>";
        }
    }
    // 실행 될 함수명칭, 선택 된 페이징번호에 대한 내역을 작성 (다수 페이징 존재 시 중복방지를 위함)
    /*
     * 기존코드 
     * 	$("#"+divId).append("<ul class='paging'>"+preStr + str + postStr+"</ul>"); 
     * 
     */
    $("#"+divId).append("<ul class='paging'>" +
							"<input type='hidden' name='pagingFn'  value="+ gfv_eventName +">" +
							"<input type='hidden' name='pagingIdx' value="+ gfv_pageIndex +">" +
								preStr + str + postStr+
						"</ul>");
}
 
function _movePage(value, that) {
	// 호출된 페이징의 메인영역호출
	var pageInfo = $(that).closest("div");
	// 실행 될 함수명칭
	var fn_name  = pageInfo.find("[name=pagingFn]").val();
	// 페이징번호를 저장할 태그명칭
	var tag_name = pageInfo.find("[name=pagingIdx]").val();
	$("#"+tag_name).val(value);
    if (typeof(fn_name) == "function") {
    	fn_name(value);
    } else {
        eval(fn_name + "(value);");
    }
    
    /* 기존코드
     *
	 *	$("#"+gfv_pageIndex).val(value);
	 *	if(typeof(gfv_eventName) == "function"){
	 *	    gfv_eventName(value);
	 *	}
	 *	else {
	 *  	eval(gfv_eventName + "(value);");
	 *	}
	 */
}