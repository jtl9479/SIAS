<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="tiles"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<!DOCTYPE html>

<html lang="ko">
	<head>
		<!-- <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <meta name="viewport" content="width=1180px, initial-scale=1">
	    <meta name="description" content="">
	    <meta name="author" content=""> -->
		<meta charset="utf-8">
	    <meta name="viewport" content="width=1180">
	    	
		<meta name="viewport" content="width=device-width, user-scalable=no">
	    <title>SIAS</title>
		
		<link rel="apple-touch-icon-precomposed" href="/resources/img/favicon.png">
		<link rel="shortcut icon"  href="/resources/img/favicon.png">
		
		<link rel='stylesheet' href="https://www.freelancerk.com:443/sub/css/fonts.css">
		<c:if test="${sess_userSe eq 'U'}"><!-- 사용자 -->
			<link href='<c:out value="/resources/css/reset.css"></c:out>' rel="stylesheet" type="text/css"/>
			<script type="text/javascript" src='<c:out value="/resources/js/common/commonCalc.js"></c:out>'></script>
		</c:if>
		<c:if test="${sess_userSe eq 'A'}"><!-- 관리자 -->
			<link href='<c:out value="/resources/css/MnReset.css"></c:out>' rel="stylesheet" type="text/css"/>
			<script type="text/javascript" src='<c:out value="/resources/js/common/mnCalc.js"></c:out>'></script>
		</c:if>
		<link href='<c:out value="/resources/css/sgisReset.css"></c:out>' rel="stylesheet" type="text/css"/>
			
	    <!-- DatePicker Css -->
	    <link href='<c:out value="/resources/js/jquery-ui-1.12.1.custom/jquery-ui.css"></c:out>' rel="stylesheet" type="text/css">
	    
	    <script type="text/javascript" src='<c:out value="/resources/js/jquery-3.3.1.min.js"></c:out>'></script>
	    
	    <!-- DatePicker -->
		<script type="text/javascript" src='<c:out value="/resources/js/jquery-ui-1.12.1.custom/jquery-ui.js"></c:out>'></script>
		<script type="text/javascript" src='<c:out value="/resources/js/jquery-monthpicker.js"></c:out>'></script>
	    
	    <!-- Cookie -->
	    <script type="text/javascript" src='<c:out value="/resources/js/jquery.cookie.js"></c:out>'></script>
	    
	    <!-- Modal -->
	    <script type="text/javascript" src='<c:out value="/resources/js/jquery.modal.min.js"></c:out>'></script>
	    
	    <!-- editor-->
	    <script type="text/javascript" src='<c:out value="/resources/ckeditor/ckeditor.js"></c:out>'></script>
	    
	    <script type="text/javascript" src='<c:out value="/resources/js/common/alertBox.js"></c:out>'></script>
		<script type="text/javascript" src='<c:out value="/resources/js/common/common.js"></c:out>'></script>
		<%-- <script type="text/javascript" src='<c:out value="/resources/js/common/commonCalc.js"></c:out>'></script> --%>
		<script type="text/javascript" src='<c:out value="/resources/js/common/function.js"></c:out>'></script>
	    
	</head>
	
	<body>
		<div class="wrap">
			<tiles:insertAttribute name="header"/>
			<%-- <tiles:insertAttribute name="left"/> --%>
		
			<tiles:insertAttribute name="content"/>
		
			<tiles:insertAttribute name="footer"/>
		</div>
	    <!-- /#wrapper -->
	</body>
</html>