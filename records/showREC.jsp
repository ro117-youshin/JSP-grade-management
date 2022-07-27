<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*, java.net.*, java.io.*"%>
<html>
<head>
	<style>
		table {
			width:700;
			text-align: center;
			margin-left: auto;
			margin-right: auto;
			font-family: 'Times New Roman', Times, serif;
			font-size: 30px;
			margin-top: 5%;
		}
		body {
			background-image: url('./tablebg.png');
		}
		h1 {
			font-family: 'Times New Roman', Times, serif;
			font-size: 50px;
			text-align: center;
			margin-top: 20%;
		}
		#submit, #update, #delete{
			border: 1px solid yellowgreen;
			font-size: 30px;
		}
	</style>
	<script>    
		function characterCheck(obj){
			var reg = /[a-z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣\{\}\[\]\/?.,;:|\-_+<>@\#$%&\'\"\\\()\=`~!^*\s]/gi;
			if (reg.test(obj.value)){
				alert("특수문자나 숫자, 띄어쓰기는 입력하실수 없습니다.");
				obj.value = obj.value.substring(0,0);
			}
		}
		function characterCheck2(obj){
			var reg = /[\{\}\[\]\/?.,;:|\-_+<>@\#$%&\'\"\\\()\=`~!^*123456789\s]/gi;
			if (reg.test(obj.value)){
				alert("특수문자나 숫자, 띄어쓰기는 입력하실수 없습니다.");
				obj.value = obj.value.substring(0,0);
			}
		}
		window.onload = function() {
		document.getElementById('formid').addEventListener('submit', function(e){
			if(document.getElementById('name').value == '' || document.getElementById('korean').value == '' || document.getElementById('english').value == '' || document.getElementById('math').value == ''){
				e.preventDefault()//이름 미입력을 방지
				alert('입력란을 모두 입력하세요')} 
		});
		}
	</script>
</head>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
	Statement stmt = conn.createStatement();
	// inputForm2.jsp에서 name요소의 search값을 받아와 변수에 저장
	Integer id = Integer.parseInt(request.getParameter("search"));
	// 받아온 학번을 변수에 저장하고 그 변수를 select문에 삽입하여 데이터 추출
	ResultSet rset = stmt.executeQuery("select * from examtable where studentid = "+id); 
	// 해당 학번을 기준으로 나머지 컬럼의 데이터를 저장할 변수들 생성 및 초기화
	String printName = "";
	Integer printKor = 0;
	Integer printEng = 0;
	Integer printMat = 0;
	// 각 변수에 해당 데이터 넣는 반복문
	while (rset.next()) {
		printName = rset.getString(1);
		printKor = rset.getInt(3);
		printEng = rset.getInt(4);
		printMat = rset.getInt(5);
	}
	// search로 받아온 학번이 없을 경우를 위한 조건문
	if (printName == "" || printName == null) {
		printName = "해당학번없음";
	}
	rset.close();
	stmt.close();
	conn.close();
%>
<body>
	<h1>성적 조회후 정정/삭제</h1>
	<!-- 조회를 한 번하고 또 다시 조회를 누를때를 위한 form태그 -->
	<form id = "searchformid" method = "post" action = "showREC.jsp">
		<table width = 400>
			<tr>
				<td>조회할 학번</td>
				<td><input id = "searchid" type = text name = "search" min="229001" onkeyup = "characterCheck(this)" required /></td>
				<td><input type = "submit" id = "submit" value = "조회" /></td>
			</tr>
		</table>
	</form>
	<form id = "formid" method = "post" action = "updateDB.jsp">
	<%
		// search값에서 학번이 없을 경우 보여지는 테이블을 위한 조건문
		if (printName == "해당학번없음" || printName == "" || printName == null) {
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<td width=100>이름</td>");
			out.println("<td width=300><input type=text name=studentname value="+printName+"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>학번</td>");
			out.println("<td><input type=number readonly name=id></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>국어</td>");
			out.println("<td><input type=number readonly name=korean></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>영어</td>");
			out.println("<td><input type=number readonly name=english></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>수학</td>");
			out.println("<td><input type=number readonly name=math></td>");
			out.println("</tr>");
			out.println("</table>");   
		} else { // search값에서 해당 학번에 대한 테이블을 출력하는 조건문
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("<td width=100>이름</td>");
			out.println("<td width=300><input type=text id=name name=studentname onkeyup = characterCheck2(this) value="+printName+"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>학번</td>");
			out.println("<td><input type=number name=studentid readonly min=0 max=100 value="+id+"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>국어</td>");
			out.println("<td><input type=number id=korean name=korean min=0 max=100 value="+printKor+"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>영어</td>");
			out.println("<td><input type=number id=english name=english min=0 max=100 value="+printEng+"></td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>수학</td>");
			out.println("<td><input type=number id=math name=math min=0 max=100 value="+printMat+"></td>");
			out.println("</tr>");   
			out.println("</table>");         
		}
   %>
	<!-- 수정을 클릭하면 updateDB.jsp로, 삭제를 클릭하면 deleteDB.jsp로 이동 -->
		<table>
			<tr>
				<td width="350" align="right"><input id="update" type = "submit" value = "수정" onclick = "updateDB.jsp" /></td>
				<td width="50"><input type = "submit" id="delete" value = "삭제" onclick = "deleteDB.jsp" formaction="deleteDB.jsp" /></td>
			</tr>
		</table>
	</form>
</body>
</html>