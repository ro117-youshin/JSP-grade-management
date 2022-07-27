<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*, java.io.*"%>
<%@ page errorPage="ErrorOfAllsetDB.jsp" %>
<html>
<head>
	<style>
		body {
				background-image: url('./tablebg.png');
		}
		h1 {
				font-family: 'Times New Roman', Times, serif;
				font-size: 50px;
				text-align: center;
				margin-top: 30%;
		}
	</style>
</head>
<body>
<h1>실습데이터 입력</h1>
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08", "root", "root");
	Statement stmt = conn.createStatement();
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('나연', 209901, 95, 100, 95);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('정연', 209902, 95, 95, 95);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('모모', 209903, 100, 100, 100);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('사나', 209904, 100, 95, 90);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('지효', 209905, 80, 100, 70);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('미나', 209906, 100, 100, 70);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('다현', 209907, 70, 70, 70);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('채영', 209908, 80, 75, 72);");
	stmt.execute("insert into examtable (name, studentid, kor, eng, mat) values ('쯔위', 209909, 78, 79, 82);");
	stmt.close();
	conn.close();
%>
</body>
</html>