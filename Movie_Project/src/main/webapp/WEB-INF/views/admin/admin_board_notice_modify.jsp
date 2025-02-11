<%-- admin_board_notice_write.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 관리</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources//js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	
	$(function() {
		
		// 지점명 불러오기
		$(function() {
			$.ajax({
				type: "GET",
				url: "getTheater",
				success: function(result) {
					 let selected = ${noticeDetail.theater_id};
				      for (let theater of result) {
						let option = $("<option></option>")
						  .attr("value", theater.theater_id)
						  .text(theater.theater_name);
						
						if (selected == theater.theater_id) {
						  option.attr("selected", "selected");
						}
						
						$("#theater_id").append(option);
				      }
				},
				error: function(xhr, textStatus, errorThrown) {
					alert("지점명 로딩 오류입니다.");
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
			<h1 id="h01">공지사항 관리</h1>
			<hr>		
			<div id="admin_nav">
				<jsp:include page="admin_menubar.jsp"></jsp:include>
			</div>
			<div id="admin_sub">
				<form action="adminNoticeModifyPro" method="post" enctype="multipart/form-data">
					<table border="1">
						<tr>
							<th width="90px">지점</th>
							<td>
								<select name="theater_id" id="theater_id">
									<option value="">전체</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><input type="text" id="id" name="member_id" value="${sessionScope.sId}" readonly> </td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input type="text" id="subject" name="cs_subject" value="${noticeDetail.cs_subject}"></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><textarea id="textarea" name="cs_content">${noticeDetail.cs_content}</textarea></td>
							<input type="hidden" name="cs_type" value="${noticeDetail.cs_type}">
							<input type="hidden" name="cs_type_list_num" value="${noticeDetail.cs_type_list_num}">
						</tr>
					</table>
					<div id="admin_writer"> 
						<input type="submit" value="등록">
						<input type="button" value="돌아가기" onclick="history.back()">
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