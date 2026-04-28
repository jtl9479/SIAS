<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="tiles"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="utf-8">
	    <meta name="viewport" content="width=1180">
	    
	    <title>SIAS</title>
		
		<link rel="apple-touch-icon-precomposed" href="/resources/img/favicon.png">
		<link rel="shortcut icon"  href="/resources/img/favicon.png">
		<link rel='stylesheet' href="https://www.freelancerk.com:443/sub/css/fonts.css">
		<link href='<c:out value="/resources/css/reset.css"></c:out>' rel="stylesheet" type="text/css"/>
		<link href='<c:out value="/resources/css/sgisReset.css"></c:out>' rel="stylesheet" type="text/css"/>
		

			
		<!-- Modal CSS -->
<%-- 		<link href='<c:out value="/resources/css/jquery.modal.css"></c:out>' rel="stylesheet"/> --%>
		
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
		<script type="text/javascript" src='<c:out value="/resources/js/common/commonCalc.js"></c:out>'></script>
		<script type="text/javascript" src='<c:out value="/resources/js/common/function.js"></c:out>'></script>
	    
	</head>
	<body>
		<div class="wrap">
			<tiles:insertAttribute name="body"/>
		</div>
	</body>
</html>
