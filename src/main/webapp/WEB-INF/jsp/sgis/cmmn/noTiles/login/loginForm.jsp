<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
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
 
	<div class="login_wrap"> 
		<div class="login_con">
			<p class="text t_c">맛있고 믿음을 주는</p>
			<h1 class="t_c"><img src="/resources/img/logo.png" alt="sias"></h1>
			
			<form id="loginFrm" action="/login" method="post">
				<!-- <fieldset> -->
	    			<span class="input_type w_100">
		    			<input class="form-control" type="text" name="username" placeholder="Username" value="">
					</span>
					<span class="input_type w_100">
					    <input class="form-control" type="password" placeholder="Password" name="password" value="">
					</span>
					<p class="checkbox_text">
					    <input type="checkbox" id="saveId" name="saveId" value="N"><label for="saveId">ID 저장 </label>
					</p>
					<p id="validId" style="color: white; margin-top: 5px; display: none;"> * 일치하는 정보가 없습니다. 아이디 또는 비밀번호를 다시 확인하세요. </p>
					<div class="btn_wrap">
						<!-- <a href="#" class="btn_red w_100">로그인</a> -->
						<button type="submit" class="btn_red w_100">로그인</button>
					</div>
				<!-- </fieldset> -->
				<input type="hidden" name="loginRedirect" value="${loginRedirect}"/>
			</form>
		</div>
	</div>
	<!-- // login_wrap -->
