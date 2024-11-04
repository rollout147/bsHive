<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석입력(교수용)</title>

<style type="text/css">
	body {
        width: 1920px !important; /* body 폭 설정 */
        margin: 0; /* 기본 여백 제거 */
        padding: 0; /* 기본 패딩 제거 */
        box-sizing: border-box; /* 박스 모델 설정 */
    }
    
	.container1 {
        display: grid;
        grid-template-columns: 410px 1180px; /* 왼쪽 메뉴와 오른쪽 콘텐츠 영역 비율 */
        grid-gap: 15px; /* 좌우 간격 */
        width: 1700px; /* 콘텐츠 영역 폭 */
        margin: 50px auto; /* 가운데 정렬 및 상단 여백 */
    }
    
    .main {
        width: 1180px; /* 오른쪽 콘텐츠 영역 폭 */
    }
	
	a {
		color: black;	/* 글자 색상 설정 */
		text-decoration: none;	/* 밑줄제거 */
	}
	
	a:hover {
		font-weight: bold;
	}
</style>
</head>
<header>
	<%@ include file="../header.jsp" %>
</header>
<script type="text/javascript">
	// 아작스로 주차 별 list 불러오기
	$(document).ready(function () {
		$('#lctrWeekSelect').change(function() {
			let lctr_weeks = $(this).val();
			$('#lctrWeeksHidden').val(lctr_weeks); // 선택된 주차를 hidden input에 설정
			
			$.ajax({
				url: "<%=request.getContextPath()%>/hs/lecWeekProf",
				type: "POST",
				dataType: "JSON",
				data: {lctr_weeks : lctr_weeks},
				success:function(lecWeekAttend) {
					console.log('AJAX 호출 성공:', lecWeekAttend);
					
					// 기존 출결 데이터 초기화
					$('tbody#attendList').empty();
					
					// 서버에서 받은 데이터로 새로운 행 추가
					$.each(lecWeekAttend, function(index, hs_attend) {
						console.log('현재 처리 중인 학생: ',hs_attend);	//속성 확인
						console.log('학번:', hs_attend.unq_num, '이름:', hs_attend.stdnt_nm);
						console.log('학번 타입:', typeof hs_attend.unq_num); // 타입 확인
						
						let studentId = hs_attend.unq_num;
			            let studentName = hs_attend.stdnt_nm;
			            let atndc_type = hs_attend.atndc_type; // 출결 상태
			            let index1 = index+1;
			            console.log('each 학번:', studentId, 'each 이름:', studentName);
						console.log('index', index);
						let row = `
							<tr>
								<td>`+index1+`</td>
								<td>`+studentId+`</td>
								<td>`+studentName+`</td>
								<td>
									<input type="radio" class="btn-check" name="atndc_type_`+studentId+`" id="option100_`+studentId+`" autocomplete="off" value="100" ` + (atndc_type === "100" ? 'checked' : '') + `>
									<label class="btn btn-outline-primary btn-sm" for="option100_`+studentId+`">출석</label>
									
									<input type="radio" class="btn-check" name="atndc_type_`+studentId+`" id="option110_`+studentId+`" autocomplete="off" value="110" ` + (atndc_type === "110" ? 'checked' : '') + `>
									<label class="btn btn-outline-primary btn-sm" for="option110_`+studentId+`">지각</label>
									
									<input type="radio" class="btn-check" name="atndc_type_`+studentId+`" id="option120_`+studentId+`" autocomplete="off" value="120" ` + (atndc_type === "120" ? 'checked' : '') + `>
									<label class="btn btn-outline-primary btn-sm" for="option120_`+studentId+`">결석</label>
								</td>
							</tr>
						`;
						
						// 130이면 100 체크
				        /* if (atndc_type === "130") {
				            row = row.replace(`value="100"`, `value="100" checked`);
				        } */
						
						console.log('추가된 행 :', row);	//추가된 행 확인
						$('tbody#attendList').append(row);
					});
				}, 
				error: function(xhr, status, error) {
					console.error('Error fetching data:', error);
				}
			});
		});
		
		// 폼 제출 시 데이터 수집
        $('#attendFormUpd').on('submit', function(event) {
            event.preventDefault(); // 기본 제출 방지

            let attendanceData = [];
            
            $('tbody#attendList tr').each(function() {
                let studentId = $(this).find('td:nth-child(2)').text();
                let attendanceType = $(this).find('input[type="radio"]:checked').val();
                attendanceData.push({ unq_num: studentId, atndc_type: attendanceType });
            });
			
            if ($('#attendFormUpd input[name="lctr_weeks"]').length === 0) {
            
	         	// lctr_weeks 값을 추가
	            $('<input>').attr({
	                type: 'hidden',
	                name: 'lctr_weeks',
	                value: $('#lctrWeeksHidden').val() // 현재 hidden input의 값을 사용
	            }).appendTo('#attendFormUpd');
            }
            
            // 데이터를 JSON 문자열로 변환
            $('<input>').attr({
                type: 'hidden',
                name: 'attendanceData',
                value: JSON.stringify(attendanceData)
            }).appendTo('#attendFormUpd');
            
            // 폼 제출
            this.submit();
        });
	})
</script>
<body>
	<div class="container1">
		<div class="sideLeft">
			<%@ include file="../sidebarLctr.jsp" %>
		</div>
		<div class="main">
		<form action="AttendUpdate" id="attendFormUpd">
			<h1>출결관리</h1>
			<table>
				<tr>
					<th>
						<select class="form-select" id="lctrWeekSelect" aria-label="Default select example">
							<option>주차 선택</option>
							<c:forEach var="hs_attend" items="${weekList }">
								<option value="${hs_attend.lctr_weeks }"
								<c:if test="${hs_attend.lctr_weeks == defaultWeek}">selected</c:if>>
									${hs_attend.lctr_weeks } 주차 (${hs_attend.lctr_ymd })
								</option>
							</c:forEach>
						</select>
					</th>
					<th></th>
					<th></th>
				</tr>
				<tr list="lctr_weeks"></tr>
				<tr>
					<th></th>
					<th>학번</th>
					<th>이름</th>
					<th>출결상태</th>
				</tr>
				<tbody id="attendList"><!-- 출결 목록이 여기에 동적으로 추가됩니다. --></tbody>
			</table>
			<input type="hidden" id="lctrWeeksHidden" name="lctr_weeks" value="">
			<button type="submit" class="btn btn-outline-secondary">등록</button>
		</form>
		</div>
	</div>
</body>
<footer>
	<%@ include file="../footer.jsp" %>
</footer>
</html>