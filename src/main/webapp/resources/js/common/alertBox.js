function alertBoxJson(txt, callbackMethod, jsonData){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            if(callbackMethod){
                callbackMethod(jsonData);
            }
        }
    });
}
 
function alertBoxFocus(txt, obj){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            //console.log(result, obj)
            obj.focus();
        }
    });
}

/*
 * 수량 오류 알림
 * 수량오류시에 수량을 0으로 변경후 합계금액이랑 총합계를 변경해줌
 */
function alertBoxQuanFocus(txt, obj, idx){
	modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            //console.log(result, obj)
        	obj.focus();
        	obj.val(0); //수량 초기화
        	
        	if($("input[name=W_SUMAMOUNT]").length > 0){
        		var fn_sum = $("input[name=W_SUMAMOUNT]").eq(idx).val().replace(/,/gi,""); // , 합계금액 제거
        		var fn_total = $("input[name=totalAm]").val().replace(/,/gi,""); // ,총합계 제거
        		var fn_new = fn_total - fn_sum; 

        		$("input[name=W_SUMAMOUNT]").eq(idx).val(0); // 합계금액 초기화
        		$("input[name=totalAm").val(gfn_replaceAdd(fn_new)); // 총합계
        	}
        }
    });
}

function alertBoxUrl(txt, obj){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            //console.log(txt, obj)
        	if(obj != '' && obj != null){
        		location.replace(obj);
        	}        	 
        }
    });
}

function alertBoxFocusArr(txt, obj, idx){
    modal({
        type: 'alert',
        title: '알림',
        text: txt,
        callback: function(result){
            //console.log(result, obj)
            obj.eq(idx).focus();
        }
    });
}

function alertBox(txt){
    modal({
        type: 'alert',
        title: '알림',
        text: txt
    });
}
    
function confirmBox(txt, callbackMethod, jsonData){
    modal({
        type: 'confirm',
        title: '확인',
        text: txt,
        callback: function(result) {// 예, 아니오 위치 변경으로 함수위치변경
            if(!result){// 예 선택시콜백이동
                callbackMethod(jsonData);
            }
        }
    });
}

function yesBox(txt, callbackMethod, cancleCallBackMethod, jsonData){
    modal({
        type: 'confirm',
        title: '확인',
        text: txt,
        callback: function(result) {// 예, 아니오 위치 변경으로 함수위치변경
        	if(result){// 아니오
        		cancleCallBackMethod(jsonData);
            }else{//예
            	callbackMethod(jsonData);
            }
        }
    });
}
 
function promptBox(txt, callbackMethod, jsonData){
    modal({
        type: 'prompt',
        title: 'Prompt',
        text: txt,
        callback: function(result) {
            if(result){
                callbackMethod(jsonData);
            }
        }
    });
}
 
function successBox(txt){
    modal({
        type: 'success',
        title: '성공',
        text: txt
    });
}
 
function warningBox(txt){
    modal({
        type: 'warning',
        title: '주의',
        text: txt,
        center: false
    });
}
 
function infoBox(txt){
    modal({
        type: 'info',
        title: '알림',
        text: txt
    });
}
 
function errorBox(txt){
    modal({
        type: 'error',
        title: 'Error',
        text: txt
    });
}
 


