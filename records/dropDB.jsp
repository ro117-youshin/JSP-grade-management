<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*,java.io.*"%>
<%@ page errorPage="ErrorOfdropDB.jsp" %>
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
<h1>해당 테이블을 삭제했습니다.</h1>

<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08", "root", "root");
	
	Statement stmt = conn.createStatement();
	stmt.execute("drop table examtable;");
	stmt.close();
	conn.close();
%>
</body>
</html>