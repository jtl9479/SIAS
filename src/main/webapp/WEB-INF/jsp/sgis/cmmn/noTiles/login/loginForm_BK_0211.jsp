<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- <title>SB Admin 2 - Bootstrap Admin Theme</title> -->

    <!-- Bootstrap Core CSS -->
    <link href="/bootstrap/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/bootstrap/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/bootstrap/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/bootstrap/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

<script type="text/javascript">
	$(document).ready(function(){
		fn_userInfoChk();
		
		if($.cookie("CusID")){
			$("input[name=username]").val($.cookie("CusID"));
			$/$("input[name=saveId]").prop("checked",true);
		}
		
		$("#saveId").change(function(){
			if($("#saveId").is(":checked")){
				$("#saveId").val("Y");
			}else{
				$("#saveId").val("N");
		  	}
		});
		
	});
	
	//현재 url에 login실패 param이 있을 경우
	function fn_userInfoChk(){
		var currentUrl = window.location.href;
		
		if(currentUrl.indexOf('fail') != -1){
			$("#validId").css("display","");
		}else {
			$("#validId").css("display","none");
		}
	}
	
</script>
</head>

<body>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">로그인 페이지 입니다.</h3>
                    </div>
                    <div class="panel-body">
                    	<!-- <form action="/login" method="post"> -->
                    	<form id="loginFrm" action="/login" method="post">
                            <fieldset>
                                <div class="form-group">
                                	<!-- value="1051035972" -->
                                    <input class="form-control" type="text" name="username" value="4108546710">
                                </div>
                                <div class="form-group">
                                    <input class="form-control" type="password" placeholder="Password" name="password" value="123456">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" id="saveId" name="saveId" value="N">ID 저장
                                    </label>
                                </div>
                                <p id="validId" style="color: red; display: none;"> * 일치하는 정보가 없습니다.</p>
                                <button type="submit" class="btn btn-lg btn-success btn-block">로그인</button>
                            </fieldset>
                            <input type="hidden" name="loginRedirect" value="${loginRedirect}"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Core JavaScript -->
    <script src="/bootstrap/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/bootstrap/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/bootstrap/dist/js/sb-admin-2.js"></script>

</body>

</html>



