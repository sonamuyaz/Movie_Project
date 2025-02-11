<%-- admin_board_one_on_one.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1 : 1 문의 관리</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
</head>
<body>
	<%-- pageNum 파라미터 가져와서 저장(없을 경우 기본값 1 로 저장) --%>
	<c:set var="pageNum" value="1" />
	<c:if test="${not empty param.pageNum }">
		<c:set var="pageNum" value="${param.pageNum }" />
	</c:if>
	
	
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top_admin.jsp"></jsp:include>
		</header>
	
		<jsp:include page="../inc/menu_nav_admin.jsp"></jsp:include>
		
		<section id="content">
			<h1 id="h01">1 : 1 문의 관리</h1>
			<hr>
			<div id="admin_nav">
				<jsp:include page="admin_menubar.jsp"></jsp:include>
			</div>
			
			<div id="admin_main">
				<table border="1">
					<tr>
						<th width="60">번호</th>
						<th width="120">유형</th>
						<th>제목</th>
						<th width="100">작성자</th>
						<th width="120">등록일</th>
						<th width="95">답변상태</th>
					</tr>
					
					<c:forEach var="oneOnOne" items="${oneOnOneList }">
						<tr>
							<td>${oneOnOne.cs_id }</td>
							<td>${oneOnOne.cs_type_detail }</td>
							<td class="post_name"><a href="OneOnOneDetail?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }">${oneOnOne.cs_subject }</a></td>
							<td>${oneOnOne.member_id }</td>
							<td>${oneOnOne.cs_date }</td>
							<c:choose>
								<c:when test="${empty oneOnOne.cs_reply }">
									<td><a href="OneOnOneMoveToRegister?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }"><input type="button" value="답변등록" id="ok"></a></td>
								</c:when>
								<c:otherwise>
									<td><a href="OneOnOneDetail?cs_id=${oneOnOne.cs_id }&pageNum=${pageNum }"><input type="button" value="답변완료" id="ok"></a></td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:forEach>
				</table>
			</div>
			
			<footer>
				<jsp:include page="../inc/bottom_admin.jsp"></jsp:include>
			</footer>
		</section>
		<section class="pagination">
			<input type="button" value="이전" 
				onclick="location.href='adminOneOnOne?pageNum=${pageNum - 1}'"
				<c:if test="${pageNum <= 1 }">disabled</c:if>
			>
			<c:forEach var="i" begin="${pageInfo.startPage }" end="${pageInfo.endPage }">
				<c:choose>
					<c:when test="${pageNum eq i }">
						<b>${i }</b>
					</c:when>
					<c:otherwise>
						<a href="adminOneOnOne?pageNum=${i }">${i }</a>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<input type="button" value="다음" 
				onclick="location.href='adminOneOnOne?pageNum=${pageNum + 1}'"
				<c:if test="${pageNum >= pageInfo.maxPage }">disabled</c:if>
			>
		</section>		
	</div>
</body>
</html>