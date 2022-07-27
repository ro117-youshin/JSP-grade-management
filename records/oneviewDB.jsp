<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ page contentType = "text/html; charset=utf-8" %>
<%@ page import="java.sql.*,javax.sql.*, java.net.*, java.io.*"%>
<html>
<head>
	<style>
	table{
		width: 1000;
		font-size: 30px;
		 margin-left: auto;
         margin-right: auto;
		 background-color: white;
		 font-family: 'Times New Roman', Times, serif;
	}
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
<%
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08", "root", "root");
	Statement stmt = conn.createStatement();
	Statement stmt1 = conn.createStatement();
	String ckey = request.getParameter("key");
	ResultSet rset1 = stmt1.executeQuery("select *, (select count(*)+1 from examtable as a where (a.kor+a.eng+a.mat) > (b.kor+b.eng+b.mat)) from examtable as b where studentid = '"+ckey+"';");
	ResultSet rset = stmt.executeQuery("select * from examtable where studentid = '"+ckey+"';");
%>
<h1><strong><%= ckey %>번 학생 조회</strong></h1>
<table cellspacing=1 width=600 border=1>
	<tr>
		<td width=50 bgcolor=lightgreen><p align=center>이름</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>학번</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>국어</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>영어</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>수학</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>합계</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>평균</p></td>
		<td width=50 bgcolor=lightgreen><p align=center>등수</p></td>
	</tr>
<%
	while (rset.next()) {
		out.println("<tr>");
		out.println("<td width=50><p align=center>" + rset.getString(1) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString(rset.getInt(2)) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString(rset.getInt(3)) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString(rset.getInt(4)) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString(rset.getInt(5)) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString(rset.getInt(3)+rset.getInt(4)+rset.getInt(5)) + "</p></td>");
		out.println("<td width=50><p align=center>" + Integer.toString((rset.getInt(3)+rset.getInt(4)+rset.getInt(5))/3) + "</p></td>");
	}
	while(rset1.next()){
		out.println("<td width=50><p align=center>" + Integer.toString(rset1.getInt(6)) + "</p></td>");
		out.println("</tr>");
	}
	rset.close();
	stmt.close();
	conn.close();
%>
</body>
</html>