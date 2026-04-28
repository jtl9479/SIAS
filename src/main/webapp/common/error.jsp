<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/sgis/sample.css'/>" />
<title>SIAS</title>
</head>

<body>
    <div style="padding-top:50px;">
    	<c:set var="requestURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
		<c:set var="statusCode" value="${requestScope['javax.servlet.error.status_code']}" />
		<c:set var="userSe" value="${sessionScope.sess_userSe}" />
		
		<div class="form-wrap">
			<header> 
				<h2> 오류가 발생하였습니다. </h2>
			</header>
			
			<br>
				${statusCode}, [ ${requestURI} ]
			</br>
			
			<c:choose>
				<c:when test="${statusCode eq '400'}">
					Bad Request, 요청 실패
				</c:when>
				<c:when test="${statusCode eq '403'}">
					Forbidden, 금지
				</c:when>
				<c:when test="${statusCode eq '404'}">
					Not Found, 페이지 찾을 수 없음
				</c:when>
				<c:when test="${statusCode eq '500'}">
					Internal Server Error, 서버가 요청사항을 수행할 수 없음
				</c:when>
			</c:choose>
			
			<c:if test="${fn:length(requestURI) > 3}">
				<c:if test="${ fn:substring(requestURI,0,3) eq '/mn'}">
					<c:choose>
						<c:when test="${userSe eq 'A'}">
							<c:set var="moveURL" value="/mn/prdInqire/page.do" />
						</c:when>
						<c:otherwise>
							<c:set var="moveURL" value="/prdInqire/page.do" />
						</c:otherwise>
					</c:choose>
				</c:if>
				
				<c:if test="${ fn:substring(requestURI,0,3) ne '/mn'}">
					<c:choose>
						<c:when test="${userSe eq 'A'}">
							<c:set var="moveURL" value="/mn/prdInqire/page.do" />
						</c:when>
						<c:otherwise>
							<c:set var="moveURL" value="/prdInqire/page.do" />
						</c:otherwise>
					</c:choose>
				</c:if>
			</c:if>
			
			<a href="${moveURL}" style="margin-left:50%"> 페이지 이동 </a>
			
		</div>
		
		
    </div>
</body>
</html>