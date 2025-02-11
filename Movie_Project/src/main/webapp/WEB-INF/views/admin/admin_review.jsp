<%-- admin_review.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 관리</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
<script src="../js/jquery-3.7.1.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	.ajax({
		url:"adminReview",
		type:"GET",
		data:{
        	review_content : review_content,
        	member_id : member_id,
        	movie_id : movie_id
		},
		success: function(data){
			$("#review_no").append(
				+ "<td>" + movie_title + "</td>"	
				+ "<td>" + review_rating + "</td>"	
				+ "<td>" + member_id  + "</td>"	
				+ "<td>" + review_content  + "</td>"	
		},
		error: function() {
			${"#review_no"}.html("AJAX 요청 실패");
		}
	});//ajax끝
	
});//ready 끝
	$(function() { //검색기능
		$('#searchButton').on('click', function() {
		var searchKeyword = $('#searchInput').val(); // 입력된 단어 가져오기
			$('#review_SearchTable tr').each(function(index, element) {
			var rowText = $(element).text().toLowerCase(); // 행의 텍스트 가져오기 (소문자로 변환)
				if (rowText.includes(searchKeyword.toLowerCase())) {
					$(element).show(); // 일치하는 단어가 포함된 행 보이기
					alert("일치하는 단어");
				} else {
					$(element).hide(); // 일치하지 않는 단어가 포함된 행 숨기기
					alert("일치하는 단어가 없습니다");
				}
			});
		});
	});
</script>

</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top_admin.jsp"></jsp:include>
		</header>
	
		<jsp:include page="../inc/menu_nav_admin.jsp"></jsp:include>
		
		<section id="content">
			<h1 id="h01">리뷰 관리</h1>
			<hr>
			<div id="admin_nav">
				<jsp:include page="admin_menubar.jsp"></jsp:include>
			</div>
			
			<div id="admin_main">
				<div id="review_Search">
					<input type="text" id="searchInput" placeholder="아이디 또는 영화명 입력">
					<input type="button" id="searchButton" value="조회">
				</div>
				<form action="reviewDlt" method="post">
					<table border="1" width="1100">
						<tr>
							<th>영화명</th>
							<th>평점</th>
							<th>아이디</th>
							<th>내용</th>
							<th>리뷰 삭제하기</th>
						</tr>
						<tr id="review_no">
							<td>${review.movie_title}</td>
							<td>${review.review_rating}</td>
							<td>${review.member_id}</td>
							<td>${review.review_content}</td>
							<td>
							<input type="submit" value="삭제">
							</td>
						</tr>
					</table>
					<div class="pagination">
						<a href="#">&laquo;</a>
						<a href="#">1</a>
						<a class="active" href="#">2</a>
						<a href="#">3</a>
						<a href="#">4</a>
						<a href="#">5</a>
						<a href="#">&raquo;</a>
					</div>
				</form>
			</div>
			<footer>
				<jsp:include page="../inc/bottom_admin.jsp"></jsp:include>
			</footer>
		</section>
	</div>
</body>
</html>
