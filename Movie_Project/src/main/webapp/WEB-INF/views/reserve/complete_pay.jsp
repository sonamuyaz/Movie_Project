<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>iTicket 선물가게 - 구매는 언제나 옳다</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath }/resources/css/store.css" rel="stylesheet" type="text/css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
	#sec01{
		height: 400px;
		position: relative;
	}
	.store_pay_table{
		width: 700px!important;
	}
	.cnt{
		height: 50px;
		position:absolute;
		left: 50%;
		top:30%;
		transform:translate(-50%,-50%);
		text-align: center;
		line-height: 50px;
	}
	#orderTable{
		width: 300px;
	}
	.effect{
		color: green;
		animation-name: example;
		animation-duration: 2s;
	}
	
	@keyframes example {
		from {color: black;}
		to {color: green;}
	}
	
	.store_table_box01{
/* 		background-color: #17b75e!important; */
	}
</style>

<script>

</script>
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
						
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>	
		
			<div class="store_progress">
				<div id="prog_img"><img src="${pageContext.request.contextPath}/resources/img/pay1.png"></div><div><span class="step">STEP 01</span><br>결제하기</div>
				<div> <span class="bracket"> > </span> </div>
				<div id="prog_img"><img src="${pageContext.request.contextPath}/resources/img/finish2.png"></div><div id="progress_red"><span class="step">STEP 02</span><br>예매완료</div>
			</div>
			<section id="sec01">
			<div class ="cnt">
			<i class="material-icons effect" style="font-size:40px;">check_circle</i><b style="font-size: 40px;">예매가 완료되었습니다.</b><br>
			<b class="effect">Thank You for Your Order!</b><br>
			<table class="store_pay_table">
				<tr class="store_table_box01">
					<th>예매번호</th>
					<th>결제시간</th>
					<th>결제금액</th>
					<th>비고</th>
				</tr>
				<tr class="effect">
					<td></td>
					<td>${map.payment_total_price}</td>
					<td>2</td>
					<td>2</td>
				</tr>
			</table>
			<div class="paybtn">
			<a href="movie_select"><input type="button" value="추가 예매하기 "></a>
			<a href="./" ><input type="button" value="  홈으로  "></a>
			<a href="movie_select"><input type="button" value="예매내역조회 "></a>
			</div>
			</div>
			</section>
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>
		</footer>
	</div>
</body>
</html>