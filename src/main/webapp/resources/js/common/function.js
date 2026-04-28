
$(document).ready(function(){
	$('header').css("display","table-cell");
	
	$(document).keydown(function(e) {
		var jsSrhBtn;
		switch (e.which) {
			case 13: // ENTER 검색
				if($("#searchFrm").find('input').is(":focus")){
					jsSrhBtn = $("#searchBtn")
					if(gfn_isNull(jsSrhBtn)) return false;
					e.preventDefault();
					fn_shortCutKeyEvt(jsSrhBtn);
					break;
				}else if($("#popSearchFrm").find('input').is(":focus")){
					jsSrhBtn = $("#popSearch");
					if(gfn_isNull(jsSrhBtn)) return false;
					e.preventDefault();
					fn_shortCutKeyEvt(jsSrhBtn);
					break;
				}
			case 9:
				$(".readOnly").attr("tabindex", -1);
				//$("input[readonly=readonly]").attr("tabindex", -1);
			default:
				break;
		}
	});
	
	$("._datepick").datepicker();
	//$("._monthpick").monthpicker();
	
	var jsAlertBoxMsg = $("#alertBoxMsg").val();
	var jsAlertAfterUrl = $("#alertAfterUrl").val();
	
	if(!gfn_isNull(jsAlertBoxMsg)) {
		alertBoxUrl(jsAlertBoxMsg,'');
	}
	
	if(!gfn_isNull(jsAlertAfterUrl)) {
		alertBoxUrl('',jsAlertAfterUrl);
	}
	
	if(!gfn_isNull(jsAlertBoxMsg) && !gfn_isNull(jsAlertAfterUrl)) {
		alertBoxUrl(jsAlertBoxMsg,jsAlertAfterUrl);
	}
	
	// 버튼 클릭시 addClass("on")
	$(".gnb li").each(function(index){
		var jsHref = $(".gnb li a").eq(index).attr('href');
		var jsHrefFirst = jsHref.substring(0, jsHref.lastIndexOf("/"));
		var jsLocation = $(location).attr("pathname");
		var jsLocationFirst = jsLocation.substring(0, jsLocation.lastIndexOf("/"));
		
		if(jsHrefFirst.match(jsLocationFirst)){
			$(".gnb li").eq(index).addClass("on");
		}
	});

		/* 위,아래로 스크롤 버튼 */	
	$(".btn_top").click(function() {
		$('html, body').animate({
			scrollTop: 0
		},500);
		return false;
	});

	$(".btn_down").click(function() {
		$('html, body').animate({
			scrollTop: ($(document).height())
		},500);
		return false;
	});
	
	/* 탭 
	$('ul.tab_type li').click(function(){
		var tab_id = $(this).attr('data-tab');
		
		$('ul.tab_type li').removeClass('on');
		$('.tab_con_wrap').removeClass('on');

		$(this).addClass('on');
		$("#"+tab_id).addClass('on');
	})
	*/
});

/*
※ $(document).ready(function(){}에 넣지 마세요. 동작 안 함 
*/
// 스크롤 좌우 이동 시 퀵 메뉴들 위치 고정
/*$(window).on('scroll', function() {
alert("scroll");
var scLeft = $(this).scrollLeft();
var btnCnt = $(".btn_fixed_wrap > .btn_wrap").length;
// 스크롤이 좌우 이동하고 퀵 메뉴가 존재할 경우에 동작
if(scLeft >= 0 && btnCnt > 0){
	// ※ 해당 구조의 클레스에서만 동작 퀵메뉴 수정시 주의 [구조] <div class='btn_fixed_wrap'><span class='btn_wrap'></span></div>
	$(".btn_fixed_wrap > .btn_wrap").attr('style',"margin-left: "+-scLeft+"px");
	//$('.btn_fixed_wrap > .btn_wrap').prop('margin-left', -scLeft+'px');
}
});*/

/* 애매한 화면사이즈에서  처음로드시 스크롤바가 뜨게됨
 * 처음로드시 사이즈랑 데이터를 가지고 오면서 사이즈차이로 인한 오류라고 생각
 */
$(window).resize(fn_scrollReSize);
$(window).scroll(fn_scrollReSize);
function fn_scrollReSize(){
	var jsDivFixed = $(".btn_fixed_wrap").offset().left;
	
	$(".btn_fixed_wrap .btn_wrap").offset({
		left : jsDivFixed
	});
}

//체크박스 단일 선택
function fn_selectChk(chkBox, idx){
	var jsChkBoxId = "selectYn_"+idx,
	jsPrdChkBoxId = chkBox.id;
	
	if(!gfn_isNull(jsPrdChkBoxId)){
		if($(chkBox).data("chkse") != "sItem"){
			jsChkBoxId = jsPrdChkBoxId;
		}
	}
	
	if(chkBox.checked == true ){//체크된 경우조사
		$("#"+jsChkBoxId).val("Y");
	}else {
		$("#"+jsChkBoxId).val("N");
	}
}

//체크박스 전체 선택
function fn_allChkBox(obj , chkBoxNm){
	var jsChkBoxNm = $("input[name='"+chkBoxNm+"']");

	$(jsChkBoxNm).prop("checked",true);
	$(jsChkBoxNm).trigger("change");
	$(obj).attr("onclick", "fn_allUnChkBox(this, '" +chkBoxNm+ "')");
	
	if(chkBoxNm == 'selectItem'){
		$("input[name=selectYn]").val("Y");	
	}else{
		jsChkBoxNm.val("Y");
	}
	
}

//체크박스 전체 선택 해제
function fn_allUnChkBox(obj, chkBoxNm) {
	var jsChkBoxNm = $("input[name='"+chkBoxNm+"']");
	
	$(jsChkBoxNm).prop("checked",false);
	$(jsChkBoxNm).trigger("change");
	$(obj).attr("onclick", "fn_allChkBox(this, '" +chkBoxNm+ "')");
	
	if(chkBoxNm == 'selectItem'){
		$("input[name=selectYn]").val("N");	
	}else{
		jsChkBoxNm.val("N");
	}
}


// 단축키 이벤트
function fn_shortCutKeyEvt(jsBtn) {
	if (gfn_isNull(jsBtn)) return;
	if($(jsBtn).is(":visible") == false) return
	$(jsBtn).trigger("click");
}

/* datepicker */
$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    showOtherMonths: true,
    selectOtherMonths: true,
    changeYear: true,
    yearSuffix: '년'
});

// 날짜형식
function fn_dateFormat(format, date)
{
	var date = new Date(date);
	var week = new Array('일', '월', '화', '수', '목', '금', '토');
	var dayWeek = week[date.getDay()];
	
	var year  = date.getFullYear();
	var month = date.getMonth() + 1;
	var day   = date.getDate();
	var returnVal = "";

	if(parseInt(month) <= 9)
	{
		month = "0"+month;
	}
	
	if(parseInt(day) <= 9)
	{
		day = "0"+day;
	}
	if(format == "YM") {
		returnVal = year+"."+month;
	} else if (format == "YMD") {
		returnVal = year+"."+month+"."+day+".";
	} else if (format == "YMDW") {
		returnVal = year+"."+month+"."+day+"("+dayWeek+")";
	}
	return returnVal;
}


//현재날짜
function fn_currentDate(format)
{
	var date = new Date();
	return fn_dateFormat(format, date);
}

// 이미지 파일 확장자체크
function fn_inputImgFileChk(fileName)
{
	var ext = fileName.split('.').pop().toUpperCase();
	if($.inArray(ext, ['GIF','PNG','JPG','JPEG']) == -1) {	
		alertBox('이미지 파일만 업로드 할 수 있습니다.');
		return false;
	} else {
		return true;
	}
}

//파일 확장자체크
function fn_inputFileChk(fileName)
{
	var ext = fileName.split('.').pop().toUpperCase();
	//if($.inArray(ext, ['GIF','PNG','JPG','JPEG','TXT','PPT','PPTX','XLSX','XLS','DOC','DOCX','PDF','HWP','HWT']) == -1) {	
	if($.inArray(ext, ['XLSX','XLS']) == -1) {
		//alertBox('이미지 파일 및 문서파일만 업로드 할 수 있습니다.');
		alertBox('엑셀파일 형식만 업로드 할 수 있습니다.');
		return false;
	} else {
		return true;
	}
}

//숫자유효성(이벤트, 소수점)
function isNumberKey(evt, point) {
	 var charCode = (evt.which) ? evt.which : event.keyCode;
	 var jsPoint = parseInt(point);
	 if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57))
	     return false;
	
	 // Textbox value       
	 var _value = event.srcElement.value;       
	
	 // 소수점(.)이 두번 이상 나오지 못하게
	 var _pattern0 = /^\d*[.]\d*$/; // 현재 value값에 소수점(.) 이 있으면 . 입력불가
	 if (_pattern0.test(_value)) {
	     if (charCode == 46) {
	         return false;
	     }
	 }

	 // 소수점 지정자리까지만 입력가능
	 var _pattern2 = null;
	 
	 if (jsPoint == 0) {
	 	_pattern2 = /^\d*[.]\d{0}$/; 
	 } else if (jsPoint == 1) {
	 	_pattern2 = /^\d*[.]\d{2}$/; 
		} else if (jsPoint == 2) {
			_pattern2 = /^\d*[.]\d{3}$/; 
		} else if (jsPoint == 6) {
			_pattern2 = /^\d*[.]\d{7}$/; 
		}
			
	 if (_pattern2.test(_value)) {
	     //alert("소수점 둘째자리까지만 입력가능합니다.");
	     return false;
	 }     
	 return true;
}

// 날짜입력 포맷셋팅(Y-M-D)
function fn_ymdInput(obj){
	var jsIndex = $("input[name='"+obj.name+"']").index(obj);
	var jsDate = $("input[name='"+obj.name+"']").eq(jsIndex).val();
	jsDate = jsDate.replace(/\./g, '');
	var jsReDate = "";

	if (jsDate.length == 0) return; 
	if (!isValidNumber(jsDate)) {
		 alertBoxFocus("숫자만 입력가능합니다.", $("input[name='"+obj.name+"']").eq(jsIndex) );
		 $("input[name='"+obj.name+"']").eq(jsIndex).val(jsReDate);
		 return;
	 }

	if ( !isValidDate(jsDate) ) {
        //alert('에러');
        alertBoxFocus("유효하지 않은 날짜입니다.", $("input[name='"+obj.name+"']").eq(jsIndex) );
        $("input[name='"+obj.name+"']").eq(jsIndex).val(jsReDate);
        return;
    } else {
    	jsReDate = jsDate.substr(0,4)+'.'+ jsDate.substr(4,2)+'.'+ jsDate.substr(6,2);
    	$("input[name='"+obj.name+"']").eq(jsIndex).val(jsReDate);
    	return;
    }
}

// 숫자입력 체크
function isValidNumber(param) {
	if (param.length == 0) return true; 
	var pattern = new RegExp(/^[0-9-+]+$/);
	if (pattern.test(param)) {
		 return true;
	 } else {
		 return false;
	 }
}
// 날짜유효성 체크 
function isValidDate(param) {
    try
    {
        param = param.replace(/-/g,'');
        // 자리수가 맞지않을때
        if( isNaN(param) || param.length!=8 ) {
            return false;
        }
         
        var year = Number(param.substring(0, 4));
        var month = Number(param.substring(4, 6));
        var day = Number(param.substring(6, 8));

        var dd = day / 0;
  
        if( month<1 || month>12 ) {
            return false;
        }
         
        var maxDaysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        var maxDay = maxDaysInMonth[month-1];s
         
        // 윤년 체크
        if( month==2 && ( year%4==0 && year%100!=0 || year%400==0 ) ) {
            maxDay = 29;
        }
         
        if( day<=0 || day>maxDay ) {
            return false;
        }
        return true;

    } catch (err) {
        return false;
    }                       
}


//숫자포맷
function fn_numberFormat(obj) {
	obj.value = fn_comma(fn_uncomma(obj.value));
}

//숫자 콤마 찍기
function fn_comma(str) {
  str = String(str);
  return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}


//숫자 콤마 풀기
function fn_uncomma(str) {
  str = String(str);
  return str.replace(/[^\d]+/g, '');
}

//keydown이벤트 jquery-ui.js 보다 먼저실행하기위해 설정
function fn_searchKeydown(){
	if(event.keyCode == 13){
		fn_searchItemDedt();
	}
}