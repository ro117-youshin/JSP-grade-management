<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>

<%
   // inputForm1.html 에서 받아오는 입력값들을 정리
   String name = request.getParameter("name");
   String studentname = new String(name.getBytes("8859_1"), "utf-8");
   Integer koreanscore = Integer.parseInt(request.getParameter("korean"));
   Integer englishscore = Integer.parseInt(request.getParameter("english"));
   Integer mathscore = Integer.parseInt(request.getParameter("math"));
%>
<html>
<head>
   <title>insertDB</title>
   <style>
   table {
			width:700;
			text-align: center;
			margin-left: auto;
			margin-right: auto;
			font-family: 'Times New Roman', Times, serif;
			font-size: 30px;
			margin-top: 5%;
			border: 1px, black;
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
		#submit{
			border: 1px solid yellowgreen;
			font-size: 30px;
		}
	</style>
</head>
<body>
	<h1>성적 입력 추가 완료</h1>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
	Statement stmt = conn.createStatement();
	// 학번 자동입력 부분, select쿼리문으로 중간에 학번이 비어 있다면 추가시 그 번호 부터 추가한다.
	// 추가할 기호 자동 부여
    // 데이터 읽기
	ResultSet rset = stmt.executeQuery("select studentid from examtable order by studentid asc;");   
	int studentid_number = 0;         // 최종 부여할 기호
    int number_min = 209901;         // 기호 최솟값
	 while (rset.next()) {
        if (rset.getInt(1) == number_min) {
            number_min = number_min + 1;
        } else {
            break;
        }
    }
    studentid_number = number_min;
	// 학번은 위의 쿼리문으로 나머지 컬럼은 inputForm1.jsp에서 받아온 입력값으로 데이터 입력
	String QueryTxt = String.format("insert into examtable (name, studentid, kor, eng, mat)"
						+ "values ('"+
						studentname+"',"+
						studentid_number+","+
						koreanscore+","+
						englishscore+","+
						mathscore+");");
	stmt.execute(QueryTxt); 

	rset.close();
	stmt.close();
	conn.close();
%>
	<form method = "post" action = "inputForm1.html">
		<table cellspacing=1 width = 400>
		<tr>
			<td width = 300></td>
			<td width = 100><input type = "submit" id = "submit" value = "뒤로가기" /></td>
		</tr>
		</table>
		<!-- insert문으로 입력한 데이터의 값들을 그대로 테이블에 보여준다. -->
		<table>
			<tr>
				<td width = 100>이름</td>
				<td width = 300><%=studentname%></td>
			</tr>
			<tr>
				<td width = 100>학번</td>
				<td width = 300><%=studentid_number%></td>
			</tr>
			<tr>
				<td width = 100>국어</td>
				<td width = 300><%=koreanscore%></td>
			</tr>
			<tr>
				<td width = 100>영어</td>
				<td width = 300><%=englishscore%></td>
			</tr>
			<tr>
				<td width = 100>수학</td>
				<td width = 300><%=mathscore%></td>
			</tr>
		</table>
	</form>
</body>
</html>