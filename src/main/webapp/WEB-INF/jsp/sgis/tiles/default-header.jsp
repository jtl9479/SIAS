<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/sgis/cmmn/config.jsp" %>

	<!-- 레프트 메뉴 -->
   <header>
		<h1>
			<a href="#"><img src="/resources/img/logo.png" alt=""></a>
		</h1>
			
		<div class="con_wrap">
			<div class="wrap_my">
				<strong class="name">
					<c:set var="nm"/>
					<c:choose>
						<c:when test="${sess_userSe eq 'U'}">
							<c:set var="nm" value="${sessionScope.sess_cmpNm}"/>
						</c:when>
						<c:otherwise>
							<c:set var="nm" value="${sessionScope.sess_userName}"/>
						</c:otherwise>
					</c:choose>
					<c:out value="${nm}" />
				</strong>
				<a href="/login/logOut.do" class="btn_m btn_white w_100">로그아웃</a>
			</div>
			
			<c:set var="sess_userSe" value="${sessionScope.sess_userSe}"></c:set>
			
			<c:choose>
        		<c:when test="${sess_userSe eq 'U'}">
					<ul class="gnb">
						<li class="sel_btn">
							<a href="/notice/page.do"> 공지사항</a>
						</li>
						<li class="sel_btn">
							<a href="/prdInqire/page.do"> 제품 조회 및 주문 등록</a>
						</li>
						<li class="sel_btn">
							<a href="/ordMod/page.do"> 주문 내역 수정</a>
						</li>
						<li class="sel_btn">
							<a href="/unDcsnOrd/page.do"> 주문 접수 진행중...</a>
						</li>
						<li class="sel_btn">
							<a href="/dcsnOrd/page.do"> 주문 완료 조회</a>
						</li>
						<li class="sel_btn">
							<a href="/ordCnslt/page.do"> 주문 불가 처리내역</a>
						</li>
						<li class="sel_btn">
							<!-- <a href="/dlivyInqire/page.do"><i class="fa fa-files-o fa-fw"></i> 출고조회</a> -->
		                    <a href="/wrhousInq/page.do"><i class="fa fa-files-o fa-fw"></i> 입고 조회</a>
						</li>
						<li class="sel_btn">
							<a href="/predict/page.do"> 수요 예측</a>
						</li>
						<li class="sel_btn">
							<a href="/qna/page.do"> Q & A</a>
						</li>
						<li class="sel_btn">
							<a href="#this" class="popOpen" data-popup="PASSWORD"> 비밀번호 변경</a>
						</li>
					</ul>
        		</c:when>
        		<c:when test="${sess_userSe eq 'A'}">
        			<ul class="gnb">
		                <li class="sel_btn">
		                    <a href="/mn/notice/page.do"> 공지사항</a>
		                </li>
		                <li class="sel_btn">
		                    <a href="/mn/prdInqire/page.do"> 제품조회 및 주문접수</a>
		                </li>
		                <li class="sel_btn">
		                    <a href="/mn/unDcsnOrd/page.do"> 미확정주문조회</a>
		                </li>
		                <li class="sel_btn">
		                    <a href="/mn/dcsnProcess/page.do"> 주문확정처리</a>
		                </li>
		                <li class="sel_btn">
		                    <a href="/mn/excel/page.do"> 엑셀업로드</a>
		                </li>
		                <li class="sel_btn">
		                    <a href="/mn/qna/page.do"> Q & A</a>
		                </li>
		            </ul>
        		</c:when>
        	</c:choose>
		</div>
	</header>
    