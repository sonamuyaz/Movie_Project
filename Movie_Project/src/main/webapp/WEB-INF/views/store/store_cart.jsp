<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
/* 각 상품의 수량 조절 버튼 함수 */
/* forEach의 변수 i의 값을 파라미터 index 로 저장 */
function decreaseQuantity(index) {
	/* 해당 버튼 인덱스와 수정되는 인덱스를 동일하게 적용 시킴 */
	/* 수량(quantity의 id 값에 동일하게 인덱스를 적용시키기위해 index와 함께 저장) */
    var quantity = parseInt($("#product_count" + index).val());

    if (quantity > 1) {
        quantity -= 1;
        $("#product_count" + index).val(quantity);
    }
}
function increaseQuantity(index) {
    var quantity = parseInt($("#product_count" + index).val());

    if (quantity < 99) {
        quantity += 1;
        $("#product_count" + index).val(quantity);
    }
}

/* 수량 변경 버튼 클릭 시 처리되는 작업 */
/* 수량 변경 버튼 클릭 시 그 행에 체크박스 자동 체크 */
// function checkCheckbox(index) {
// 	  var checkbox = document.getElementById("cartCheckbox" + index);
// 	  checkbox.checked = true;
	  
// 	}

 // 전체 체크박스를 자동으로 체크하는 함수
function checkAllCheckboxes() {
  var checkboxes = document.querySelectorAll('input[type="checkbox"]');
  checkboxes.forEach(function (checkbox) {
    checkbox.checked = true;
  });
}
var price = 0;
function quanChange(index) {
	
	let product_count = $("#product_count"+index).val();
	let product_id = $("#product_id"+index).val();
	
	$.ajax({
		type: "post",
		url: "cartQuanUpdate",
		data: {
			product_count: product_count,
			product_id: product_id,
		},
		dataType: "json",
		success: function(data) {
				 let previousCount = data[index].product_count; // 이전 수량 저장
			      let newCount = parseInt(product_count); // 변경된 수량
			      
// 			      checkCheckbox(index); // 수량 변경 버튼 클릭 시 그 행에 체크박스 자동 체크
			      checkAllCheckboxes(); // 수량 변경 버튼 클릭 시 전체 체크박스 자동 체크
			      // 수량이 증가한 경우
			      if (newCount > previousCount) {
			        let quantityDifference = newCount - previousCount;
			        let priceDifference = quantityDifference * data[index].product_price;
			        data[index].cart_total_price += priceDifference;
			      }
			      // 수량이 감소한 경우
			      else if (newCount < previousCount) {
			        let quantityDifference = previousCount - newCount;
			        let priceDifference = quantityDifference * data[index].product_price;
			        data[index].cart_total_price -= priceDifference;
			      }
			      alert("수량 " + data[index].product_count + "개로 변경되었습니다!");
			      alert("총금액 " + data[index].cart_total_price + "원");
			      $("#totalPrice" + index).text(data[index].cart_total_price.toLocaleString() + "원");
				
			      var totalSum = 0; // 총합을 저장할 변수

			      for (var i = 0; i < data.length; i++) {
			        var value = data[i].cart_total_price; // 인덱스에 있는 각 상품의 총금액을 가져옴
			        totalSum += value; // 총합에 더해줌
			      }
			      alert(totalSum);
			      $(".table_box_red").text(totalSum.toLocaleString()+"원");
				
		},
		error: function() {
			alert("수량 변경에 실패했습니다!");
		}
	});
}

/* 바로구매 선택 시 페이징 처리 */

function choiceBuy(index) {
	let product_id = $("#product_id" + index).val();
	let product_count = $("#product_count" + index).val();
	location.href="storePay?product_id=" + product_id + "&product_count=" + product_count;
} 
// 컨텍스트 루트 변수
var contextRoot = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
/* x 버튼 선택 시 해당 상품 삭제 처리 */
function choiceDel(index) {
	if(confirm("해당상품을 삭제하시겠습니까?")) {
		alert("삭제되었습니다!");
		
		let product_id = $("#product_id"+index).val();
		
		$.ajax({
			type: "post",
			url: "cartDelete",
			data: {
				product_id: product_id
			},
			dataType: "json",
			success: function(data) {
				location.href= contextRoot + "/storeCart2";
			},
			error: function() {
				location.href= contextRoot + "/storeCart2";
			}
		});
		
	}
	
}
	
// 체크박스 처리 스크립트
$(function() {
	<%-- 체크박스에 체크된 상품 삭제 --%>
	$("#del_btn").on("click", function() {
		  var checkboxDel = $("input[name='cartCheckbox']:checked");
	
		  checkboxDel.each(function() {
		    alert($(this).data('value'));
		  });
	});
	
});


// function cartProPay() {
	
// 	 var productIds = []; // 체크된 체크박스에 해당하는 상품명들을 저장할 배열
    
//     // 체크된 체크박스에 해당하는 행을 찾아서 각 행의 product_name을 추출합니다.
//     $("[id^='cartCheckbox']:checked").each(function() {
//         var index = $(this).attr("id").replace("cartCheckbox", "");
//         var productId = $("#product_id" + index).val();
//         // push 배열에 추가하는 메서드
//         productIds.push(productId); // 상품명을 배열에 추가합니다.
//     });
	
//     // 추출된 상품명들을 이용하여 URL 매개변수를 생성합니다.
//     var queryString = "";
//     for (var i = 0; i < productIds.length; i++) {
//         var paramId = "product_id";
//         var paramValue = encodeURIComponent(productIds[i]);
//         queryString += paramId + "=" + paramValue;
//         if (i < productIds.length - 1) {
//             queryString += "&";
//         }
//     }
    
//     // 기존의 매개변수들과 새로운 매개변수를 합쳐서 전달
//     var existingParams = location.search.substring(1); // 기존의 URL 매개변수들을 가져옴
//     var newParams = queryString;
    
//     if (existingParams) {
//         var url = "storePay2?" + existingParams + "&" + newParams;
//     } else {
//         var url = "storePay2?" + newParams;
//     }
    
//     location.href = url; 
	 
// }





// ---------------------------------------------------------------------------------------------

// 체크박스 선택 시 가격 추가
function addPrice(i) {
  // 체크박스 요소 가져오기
  var checkbox = document.getElementById("cartCheckbox" + i);
  // 상품 가격 가져오기
//   var price = parseInt(document.getElementById("totalPrice" + i).innerText);
  
  var price = document.getElementById("totalPrice" + i).innerText;
  price = parseInt(price.replace(",", ""));
  // 전체 가격 가져오기
//   var totalPrice = parseInt(document.getElementById("All_total_price").innerText);
  var totalPrice = document.getElementById("All_total_price2").innerText;
  totalPrice = totalPrice.replace(/,/g, "").replace("원", "");
  totalPrice = parseInt(totalPrice);
  console.log(totalPrice);
  // 체크박스의 선택 여부에 따라 가격 추가 또는 제거
  if (checkbox.checked) {
    totalPrice += price; // 가격 추가
  } else {
    totalPrice -= price; // 가격 제거
  }

  // 전체 가격이 음수일 경우 0으로 설정
  if (totalPrice < 0) {
    totalPrice = 0;
  }

  // 변경된 전체 가격을 화면에 업데이트
  totalPrice =  totalPrice.toLocaleString();
  document.getElementById("All_total_price2").innerText = totalPrice + "원";
//   document.getElementById("All_total_price1").innerText = totalPrice.toLocaleString() + "원";
  document.getElementById("All_total_price1").innerText = totalPrice + "원";
}


// 모든 체크박스 체크하기
function checkAll() {
  var checkboxes = document.getElementsByName("product_id") // product_id로 된 이름을 가진 체크박스들을 가져오기
  var checkAllCheckbox = document.getElementById("Allcheckbox");// 전체 선택 체크박스를 가져옴.
  var totalPrice = 0;
  
  
  checkboxes.forEach(function (checkbox) {
    checkbox.checked = checkAllCheckbox.checked;
    var i = checkbox.id.replace("cartCheckbox", "");
    addPrice(i);
    var price = document.getElementById("totalPrice" + i).innerText;
    price = parseInt(price.replace(",", ""));
    
    if (checkbox.checked) {
      totalPrice += price;
    }
  });
  
  var totalPriceElement = document.getElementById("All_total_price2");
  totalPriceElement.innerText = totalPrice.toLocaleString() + "원";
  document.getElementById("All_total_price1").innerText = totalPriceElement.innerText;
}

// ----------------------------------------------------------------------------------
// 체크박스에 체크가 하나도 안되어있을시 돌려보내기

function validateCheckbox() {
    var checkboxes = document.getElementsByName("product_id");
    var checkedCount = 0;

    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].checked) {
        checkedCount++;
      }
    }
    if (checkedCount === 0) {
        alert("1개 이상 체크 하셔야됩니다");
        return false;
    }
    return true;
}
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
			<!-- 체크박스와 버튼 -->
			<hr>
			<form action="storePay2" method="post" onsubmit="return validateCheckbox();">
<!-- 				<form action="storePay2" method="GET" onsubmit="return submitForm()"> -->
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
										<th width="40px"><input type="checkbox" name="Allcheckbox" id="Allcheckbox" checked onclick="checkAll()"></th>
										<th width="350px" colspan="2">상품명</th>
										<th>판매금액</th>
										<th>수량</th>
										<th>구매금액</th>
										<th width="140px">선택</th>
									</tr>
									
									<c:if test="${not empty cartList}">
										<c:forEach var="i" begin="0" end="${fn:length(cartList)-1}" >
	<!-- 											총금액 계산을 위한 All_tatal_price 변수 정의 -->
	<!-- 											반복문을 통한 모든 상품의 금액을 더하기 위해 반복문 내부에 정의함 -->
											<c:set var="All_total_price" value="${All_total_price + cartList[i].cart_total_price }"/>
											<fmt:formatNumber var="formatted_price" value="${All_total_price}" pattern="###,###,###"/>
<%-- 											<input type="checkbox" id="product_id${i}" name="product_id" value="${storeList[i].product_id}"> --%>
											<input type="hidden" id="product_id${i}" name="product_id1" value="${storeList[i].product_id}">
											<tr>
											<td><input type="checkbox" name="product_id" id="cartCheckbox${i}" value="${storeList[i].product_id }" checked onclick="addPrice(${i})"></td>
<%-- 												<td><input type="checkbox" name="cartCheckbox${i}" id="cartCheckbox${i}" value="${storeList[i].product_id }" checked></td> --%>
	<!-- 												상품 이미지 및 내용(패키지는 구성) -->
												<td>
													<img src="${storeList[i].product_img}">
												</td>
												<td>
													<span>${storeList[i].product_name }</span><br>

													<span>${storeList[i].product_txt }</span>
												</td>
	<!-- 												상품에 등록된 판매 금액 -->
												<td><fmt:formatNumber value="${storeList[i].product_price }" pattern="###,###"/>원</td>
<%-- 												<td>${storeList[i].product_price }원</td> --%>
	<!-- 												상품 갯수 = 수량 선택 + 누르면 증가 - 누르면 감소 -->
												<td class="product_quantity">
			<!-- 								<button type="button" class="btn_minus" title="수량감소" onclick="product_quantity()">-</button> -->
													<button type="button" id="minus${i}" class="btn_minus" title="수량감소" onclick="decreaseQuantity(${i})">-</button>
	<!-- 													readonly 하거나 숫자 입력 시 100 이상일 경우 경고메세지 처리 중 어떤게 나을까 -->
													<input type="text" size="1" title="수량입력" id="product_count${i}" name="product_count[]" value="${cartList[i].product_count }" min="1" max="99" class="input-text" readonly>
													<button type="button" id="plus${i}" class="btn_minus" title="수량증가" onclick="increaseQuantity(${i})">+</button>
													<input type="button" value="변경" id="btn_quantity${i}" onclick="quanChange(${i})">
												</td>
	<!-- 												구매금액 -->
	<!-- 												판매 금액 + 선택된 수량 합산 금액 -->
	<%-- 												<td>${cartList.myCartList1[i].cart_total_price * cartList.myCartList1[i].product_count }원</td> --%>
<%-- 												<td id="totalPrice${i}">${cartList[i].cart_total_price}원</td> --%>
												<td id="totalPrice${i}"><fmt:formatNumber value="${cartList[i].cart_total_price}" pattern="###,###"/>원</td>
	<!-- 												선택 -->
												<td>
	<!-- 												바로 구매 버튼 입력 시 해당하는 상품만 개별구매 -->
													<input type="button" id="buyNow${i}" value="바로구매" onclick="choiceBuy(${i})">
													<input type="button" id="choiceDel${i}" value="x" onclick="choiceDel(${i})">
												</td>
											</tr>
										</c:forEach>
									</c:if>
									<c:if test="${empty cartList}">
										<tr> 
	<!-- 											상품을 어떻게 받아와야 할지? -->
	<!-- 											상품에 따른 상품명 및 구성 자동 입력 -->
	<!-- 											상품이 없을 경우 "장바구니에 상품이 없습니다" 화면에 출력 -->
	<!-- 											상품 정보 없음 -->
											<td colspan="7" align="center">장바구니에 상품이 없습니다</td>
	<!-- 											상품이 여러가지 상품을 장바구니에 넣을 방법  -->
	<!-- 											상품이 추가될때마다 행 추가<tr> 추가 -->
	<!-- 											c if 로 상품이 있는지 없는지 판별 후 forEach 사용해서 장바구니에 담은 상품 추가 -->
	<!-- 											상품의 총 가격 계산 -->
										</tr>
									</c:if>
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
<%-- 										<td class="table_box_red" id="All_total_price2">${All_total_price }원</td> --%>
										<td class="table_box_red" id="All_total_price2"><fmt:formatNumber value="${All_total_price}" pattern="###,###"/>원</td>
										<td><img src="${pageContext.request.contextPath }/resources/img/-.png" width="35px" height="35px"></img> </td>
										<!-- 할인 기능 미구현 -->
										<!-- 구현하게 된다면 할인 기능에 따라 할인 가격 책정 -->
										<td>
										</td>
										<td><img src="${pageContext.request.contextPath }/resources/img/=.png" width="35px" height="35px"></img></td>
										<!-- 총 가짓수 상품의 가격 및 갯수의 합산금액에서 할인 가격이 차감된 금액 -->
										 <td class="table_box_red" id="All_total_price1"><fmt:formatNumber value="${All_total_price }" pattern="###,###"/>원</td>
<%-- 										 <td class="table_box_red" id="All_total_price1">${All_total_price }원</td> --%>
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