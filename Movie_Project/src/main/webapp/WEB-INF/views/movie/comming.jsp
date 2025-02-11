<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상영예정작</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/movie.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
</head>
<script type="text/javascript">
	$(function() {
		var sId = "<%= session.getAttribute("sId") %>";  
		if(sId != "null") { <%-- 로그인한 회원인지 판별 --%>
			$.ajax({
				url: "likeShow", <%-- 회원별 찜 정보 가져오기 --%>
				data: {				
					member_id: sId
				},
				dataType: "json",
				success: function(result) {
					if(result.length != 0){ <%-- 찜 정보가 있을 경우 --%>
						for(let i = 0; i < ${fn:length(commingList)}; i++) { // <%-- 상영작 페이지의 목록만큼 반복 --%>
							let movie_id = $("#likeBtn" + i).data("id");
							for(let like of result) {
								if(like.movie_id == movie_id) { <%-- 찜한 영화가 상영작 페이지에 있을 경우 --%>
									console.log(i);
									$("#likeBtn" + i).addClass("likeCheck");
									$("#likeBtn" + i).html("<i class='fa fa-heart'></i>찜하기");
								}
							}
						}
					} else {
// 						console.log("찜한 영화 없음");
					}
				},
				error: function(xhr, textStatus, errorThrown) {
// 					alert("현재 상영작 불러오기를 실패했습니다.\n새로고침을 해주세요.");
				}
			});
		}
		
		// 정렬 방식 변경하기
		$("#sortType").on("change", function() {
			 $("form").submit();
		});
		
	}); <%-- 로그인한 회원의 찜 정보 가져오기 끝 --%>
	
	// 찜하기 버튼
	function likeBtnClick(index) { <%-- 함수를 호출하는 버튼의 인덱스를 파라미터로 사용 --%>
		var sId = "<%= session.getAttribute("sId") %>";
		if(sId != "null") { <%-- 로그인한 회원인지 판별 --%>
			$.ajax({
				url: "likeCheck", <%-- 해당 영화의 찜 정보가 DB에 있는지 판별 --%>
				data: {
					member_id: sId,
					movie_id: $("#likeBtn" + index).data("id")
				},
				success: function(like) {
						$("#likeBtn" + index).toggleClass("likeCheck");
					if(like == 'true') { <%-- 찜을 등록하는 경우 --%>
						$("#likeBtn" + index).html("<i class='fa fa-heart'></i>찜하기");
					} else if(like == 'false') { <%-- 찜을 삭제하는 경우 --%>
						$("#likeBtn" + index).html("<i class='fa fa-heart-o'></i>찜하기");
					}
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("찜하기를 실패했습니다.");
				}
			});
		} else {
			if(confirm("로그인이 필요한 서비스입니다.\n로그인하시겠습니까?")){
				location.href = "memberLogin";
			}
		}
	}
</script>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
						
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>
		
		<section id="content">
			<h1 id="h01">상영예정작</h1>
			<hr>
			<nav class="movie-menu">
				<ul>
					<li class="active"><a href="release">
						<input type="button" value="현재상영작"></a></li>
					<li><a href="comming">
						<input type="button" value="상영예정작"></a></li>
				</ul>
			</nav>
			<section class="movie-section">
				<div class="container">
					<div class="movie-grid">
					<c:forEach var="commingList" items="${commingList}" varStatus="status">
						<div class="movie">
							<a href="detail?movie_id=${commingList.movie_id}">
							<div class="movie-poster">
								<div class="poster">
									<img alt="" src="${commingList.movie_poster}">
								</div>
								<div>
									<p class="title">${commingList.movie_title }</p>
								</div>
							</div>
								<p class="date">${commingList.movie_release_date }</p>
							</a>
							<div class="reserve_area">
								<button id="likeBtn${status.index}" class="likeBtn" data-id="${commingList.movie_id }" data-title="${commingList.movie_title }" onclick="likeBtnClick(${status.index})"><i class="fa fa-heart-o"></i>찜하기</button>
								<a href="movie_select" class="rel_reservBtn">
									<input type="button" value="예매하기"></a>
							</div>
						</div>
					</c:forEach>
					</div>
				</div>
			</section>
		</section>
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>	
		</footer>
	</div>
</body>
</html>