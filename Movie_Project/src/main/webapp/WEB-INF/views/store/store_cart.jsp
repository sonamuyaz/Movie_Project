<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>iTicket 선물가게 - 전부 담아담아</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath }/resources/css/store.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
/* 새로 갱신된 파일 */
/* 각 상품의 수량 조절 버튼 함수 */
/* forEach의 변수 i의 값을 파라미터 index 로 저장 */
function decreaseQuantity(index) {
	/* 해당 버튼 인덱스와 수정되는 인덱스를 동일하게 적용 시킴 */
	/* 수량(quantity의 id 값에 동일하게 인덱스를 적용시키기위해 index와 함께 저장) */
    var quantity = parseInt($("#quantity" + index).val());

    if (quantity > 1) {
        quantity -= 1;
        $("#quantity" + index).val(quantity);
    }
}
function increaseQuantity(index) {
    var quantity = parseInt($("#quantity" + index).val());

    if (quantity < 99) {
        quantity += 1;
        $("#quantity" + index).val(quantity);
    }
}

function quanChange(index) {
	let product_count = $("#quantity"+index).val();
	let product_id = $("#product_id"+index).val();
	
	$.ajax({
		type: "post",
		url: "cartQuanUpdate",
		data: {
			product_count: product_count,
			product_id: product_id
		},
		dataType: "json",
		success: function(data) {
				alert("수량" + data[index].product_count + "개로 변경되었습니다!");
				alert("총금액" + data[index].cart_total_price);
				$("#totalPrice" + index).text(data[index].cart_total_price + "원");
		},
		error: function() {
			alert("수량 변경에 실패했습니다!");
		}
	});
}


$(function() {
	

	
});
	
</script>		
</head>
<body>
	<div id="wrapper">
		<header>
			<jsp:include page="../inc/top.jsp"></jsp:include>
		</header>
		
		<jsp:include page="../inc/menu_nav.jsp"></jsp:include>				

		<section id="content">
			<h1 id="h01">장바구니</h1>
			<hr>
			<form action="storePay" method="post">
				<section id="content">
					<!-- 상단 진행도 상태창 -->
					<!-- 장바구니 페이지 에서는 STEP1 에 빨간색 처리  -->
					<div class="store_progress">
						<div id="prog_img"><img src="${pageContext.request.contextPath }/resources/img/cart2.png"></div><div id="progress_red"><span class="step">STEP 01</span><br>장바구니</div>
						<div> <span class="bracket"> > </span>  </div>
						<div id="prog_img"><img src="${pageContext.request.contextPath }/resources/img/pay1.png"></div><div><span class="step">STEP 02</span><br>결제하기</div>
						<div> <span class="bracket"> > </span> </div>
						<div id="prog_img"><img src="${pageContext.request.contextPath }/resources/img/finish1.png"></div><div><span class="step">STEP 03</span><br>결제완료</div>
					</div>
					
					<!-- 구매 상품 정보 테이블 -->		
					<div class="store_basket">
						<div class="store_basket_box">
							<div class="store_subject">장바구니</div>
							<table class="store_basket_table">
								<tr>
									<!-- 이미지와 상품정보 두칸 합치기 위해 상품명 colspan2 사용 -->
									<th width="40px"><input type="checkbox" name="Allcheckbox" id="Allcheckbox"></th>
									<th width="350px" colspan="2">상품명</th>
									<th>판매금액</th>
									<th>수량</th>
									<th>구매금액</th>
									<th width="140px">선택</th>
								</tr>
								<c:choose>
									<c:when test="${not empty cartList }">
										<c:forEach var="i" begin="0" end="${fn:length(cartList.myCartList1)-1}" >
											<%-- 총금액 계산을 위한 All_tatal_price 변수 정의 --%>
											<%-- 반복문을 통한 모든 상품의 금액을 더하기 위해 반복문 내부에 정의함 --%>
											<c:set var="All_total_price" value="${cart_total_price + cartList.myCartList1[i].cart_total_price * cartList.myCartList1[i].product_count }"/>
											<input type="hidden" id="product_id${i}" name="product_id" value="${cartList.myCartList2[i].product_id}">
											<tr>
												<td><input type="checkbox" name="cartCheckbox" id="cartCheckbox"></td>
												<!-- 상품 이미지 및 내용(패키지는 구성) -->
												<td>
													<img src="${cartList.myCartList2[i].product_img}">
												</td>
												<td>
													<span>${cartList.myCartList2[i].product_name }</span><br>
													<span>${cartList.myCartList2[i].product_txt }</span>
												</td>
												<!-- 상품에 등록된 판매 금액 -->
												<td>${cartList.myCartList2[i].product_price }원</td>
												<!-- 상품 갯수 = 수량 선택 + 누르면 증가 - 누르면 감소 -->
												<td class="product_quantity">
			<!-- 								<button type="button" class="btn_minus" title="수량감소" onclick="product_quantity()">-</button> -->
													<button type="button" id="minus${i}" class="btn_minus" title="수량감소" onclick="decreaseQuantity(${i})">-</button>
													<%-- readonly 하거나 숫자 입력 시 100 이상일 경우 경고메세지 처리 중 어떤게 나을까 --%>
													<input type="text" size="1" title="수량입력" id="quantity${i}" name="quantity" value="${cartList.myCartList1[i].product_count }" min="1" max="99" class="input-text" readonly>
													<button type="button" id="plus${i}" class="btn_minus" title="수량증가" onclick="increaseQuantity(${i})">+</button>
													<input type="button" value="변경" id="btn_quantity${i}" onclick="quanChange(${i})">
												</td>
												<!-- 구매금액 -->
												<!-- 판매 금액 + 선택된 수량 합산 금액 -->
<%-- 												<td>${cartList.myCartList1[i].cart_total_price * cartList.myCartList1[i].product_count }원</td> --%>
												<td id="totalPrice${i}">${cartList.myCartList1[i].product_count * cartList.myCartList2[i].product_price}원</td>
												<!-- 선택 -->
												<td>
												<!-- 바로 구매 버튼 입력 시 해당하는 상품만 개별구매 -->
													<input type="button" value="바로구매">
													<input type="button" value="x">
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<!-- 상품을 어떻게 받아와야 할지? -->
											<!-- 상품에 따른 상품명 및 구성 자동 입력 -->
											<!-- 상품이 없을 경우 "장바구니에 상품이 없습니다" 화면에 출력 -->
											<!-- 상품 정보 없음 -->
											<td colspan="7" align="center">장바구니에 상품이 없습니다</td>
											<!-- 상품이 여러가지 상품을 장바구니에 넣을 방법  -->
											<!-- 상품이 추가될때마다 행 추가<tr> 추가 -->
											<!-- c if 로 상품이 있는지 없는지 판별 후 forEach 사용해서 장바구니에 담은 상품 추가 -->
											<!-- 상품의 총 가격 계산 -->
										</tr>
									</c:otherwise>
								</c:choose>
							</table>
							<div id="msg">
								장바구니에 담긴 상품은 30일까지 보관됩니다.
							</div>
							<div id="del_btn">
								<!-- 삭제할 체크박스 선택 시 추가 될 때 마다 숫자 추가 -->
								<input type="button" value="선택상품 삭제">
							</div>
							
							<br id="clear">
							<br><br>
							<!-- 상품 결제예정 정보 화면 -->
							<div class="store_subject">결제금액</div>
							<table class="store_sum_table">
								<tr class="store_table_box03">
											<th>총 상품 금액</th>
											<th></th>
											<th>할인금액</th>
											<th></th>
											<th>총 결제 예정금액</th>
								</tr>
								<tr class="store_table_box04">
									<!-- 선택된 모든 상품의 가격과 갯수의 합산된 금액 자동 입력-->
									<td>
										${All_total_price}원
									 </td>
									<td><img src="${pageContext.request.contextPath }/resources/img/-.png" width="35px" height="35px"></img> </td>
									<!-- 할인 기능 미구현 -->
									<!-- 구현하게 된다면 할인 기능에 따라 할인 가격 책정 -->
									<td> 0원 </td>
									<td><img src="${pageContext.request.contextPath }/resources/img/=.png" width="35px" height="35px"></img></td>
									<!-- 총 가짓수 상품의 가격 및 갯수의 합산금액에서 할인 가격이 차감된 금액 -->
									<td class="table_box_red">${All_total_price}원</td>
								</tr>
							</table>
						</div>
						<br>
						<div id="store_submit">
							<input type="submit" value="결제하기">
						</div>
					</div>
				</section>
			</form>
		</section>
		
		<footer>
			<jsp:include page="../inc/bottom.jsp"></jsp:include>
		</footer>
	</div>
</body>
</html>