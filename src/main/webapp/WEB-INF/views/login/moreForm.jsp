<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<%@include file="../include/header.jsp"%>
<%@include file="../include/sideMenu.jsp"%>

<script>
function submit(){	
	if(document.getElementById("mobile").value == ""){
		alert("핸드폰 번호를 입력해 주세요.");
		return;
	}else if(document.getElementById("sample4_postcode").value == ""
			||document.getElementById("sample4_roadAddress").value == ""
			||document.getElementById("sample4_jibunAddress").value == ""){
		alert("주소를 입력해 주세요.");
		return;
	}else{
		$.ajax({
			type:'post',
			url:'/naverLogin/',
			headers: { 
			      "Content-Type": "application/json",
			      "X-HTTP-Method-Override": "POST" },
			dataType:'text',
			data: JSON.stringify({accessToken:"${param.accessToken}",
				 				  id:"${param.id}",
				  				  pw:"${param.id}",
								  name:"${param.name}",
								  email:"${param.email}",
								  sex:"${param.sex}",
								  birthday:"${param.birthday}",
								  mobile:document.getElementById("mobile").value,
								  addr1:document.getElementById("sample4_postcode").value,
								  addr2:document.getElementById("sample4_roadAddress").value,
								  addr3:document.getElementById("sample4_jibunAddress").value,
								  memberType:"N"}),
			success:function(result){
				if(result == "SUCCESS"){
					alert("가입이 완료되었습니다.");
					loginAction("${param.id}","${param.accessToken}");
				}
			}});	
	}		
}

function loginAction(id,token){
	$.ajax({
		type:'post',
		url:'/login/loginAction',
		headers: { 
		      "Content-Type": "application/json",
		      "X-HTTP-Method-Override": "POST" },
		dataType:'text',
		data: JSON.stringify({id:"N"+id,
			  				  pw:id,
			  				  memberType:"N",
			  				  accessToken:token}),
		success:function(result){
			console.log('loginActionResult => ',"${sessionInfo.getId()}","${sessionInfo.getName()}",result);
			window.location.replace("http://localhost:8080");
		}});
}

/*다음 주소 API*/
function sample4_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 도로명 조합형 주소 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }
            // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
            if(fullRoadAddr !== ''){
                fullRoadAddr += extraRoadAddr;
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample4_postcode').value = data.zonecode; //5자리 새우편번호 사용
            document.getElementById('sample4_roadAddress').value = fullRoadAddr;
            document.getElementById('sample4_jibunAddress').value = data.jibunAddress;

            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
                //예상되는 도로명 주소에 조합형 주소를 추가한다.
                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

            } else if(data.autoJibunAddress) {
                var expJibunAddr = data.autoJibunAddress;
                document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

            } else {
                document.getElementById('guide').innerHTML = '';
            }
        }
    }).open();
}
</script>
<body>
					<div class="box-body">
						<div class="form-group">
							<label for="exampleInputEmail1">전화번호</label> 
							<input type="text" id = "mobile" name='mobile' class="form-control" placeholder="Enter Title">
						</div>
						<div class="form-group">
							<label for="exampleInputPassword1">우편번호</label>						
							<input type="text" id ="sample4_postcode"  name="addr1" class="form-control" placeholder="Enter Writer">
							<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
						</div>
						<div class="form-group">
							<label for="exampleInputEmail1">도로명주소</label> 
							<input type="text" id = "sample4_roadAddress"  name="addr2" class="form-control" placeholder="Enter Writer">
						</div>
						<div class="form-group">
							<label for="exampleInputEmail1">상세주소</label> 
							<input type="text"  id = "sample4_jibunAddress" name="addr3" class="form-control" placeholder="Enter Writer">
							<span id="guide" style="color:#999"></span>
						</div>
					</div>
					<!-- /.box-body -->

					<div class="box-footer">
						<button class="btn btn-primary" onclick="submit()">완료</button>
					</div>

</body>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

</html>