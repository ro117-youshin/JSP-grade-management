<meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<html>
<head>
	<style>
		h1 {
			font-family: 'Times New Roman', Times, serif;
			font-size: 50px;
			text-align: center;
			margin-top: 30%;
		}
		p {
			text-align: right;
			margin-top: 30%;
		}
		body {
			background-image: url('./tablebg.png');
		}
	</style>
</head>
<body>
<h1> JSP Database 실습 1</h1>
<%
   String data; //문자열 변수 선언
   int cnt=0; // 카운트 변수 선언한다.
   
   FileReader fl = new FileReader("/home/cnt.txt"); //서버상의 파일을 실행한다.
   StringBuffer sb = new StringBuffer();
   int ch = 0;
   while((ch = fl.read()) != -1){ //파일을 다 읽어내면 -1을 반환한다.
      sb.append((char)ch); //읽어들인 파일을 캐릭터타입으로 버퍼에 더해준다.
   }
   // 개행문자를 공백으로 바꿔주고, 트림으로 지운다음 문자열로 변환해서 변수에 담는다.
   data=sb.toString().trim().replace("\n","");
   fl.close(); //fileReader객체 닫아준다.
   
   cnt=Integer.parseInt(data); //받은 문자 정수로 변환해서 숫자로 담는다.
   cnt++; //숫자 1 올려준다.
   data=Integer.toString(cnt); //올린 숫자 다시 문자로 변환하고 변수에 담는다.
   // 받아진 문자열 출력해 준다.
   //out.println("<p><strong>현재 홈페이지 방문조회수는 ["+data+"] 입니다.</strong></p>");
   // FileWriter객체로 txt파일 불러온다.
   FileWriter fl2 = new FileWriter("/home/cnt.txt",false);
   fl2.write(data);//1 올라간 data로 저장된 문자열 저장해 준다.
   fl2.close(); //사용후 객체 닫아준다.
%>
<%
   Class.forName("com.mysql.cj.jdbc.Driver"); // 드라이버 객체 생성
   Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08", "root", "root");
   Statement stmt1 = conn.createStatement(); // statement 객체 생성
   Statement stmt2 = conn.createStatement(); // statement 객체 생성
   stmt1.executeUpdate("insert into countTable values("+data+");");   // 올려진 숫자문자열 쿼리로 데이터 저장;
   ResultSet rset = stmt2.executeQuery("select * from countTable;"); // resultSet에 데이터 담아주기
   String count = ""; // 쿼리값 받아올 변수 선언
   while (rset.next()) { // 반복문으로 resultset 데이터 불러들인다.
      count = Integer.toString(rset.getInt(1)); // 첫번째 칼럼 데이터 변수에 저장한다.
   }
   // 받아온 변수로 출력해준다.
      out.println("<p><strong>현재 홈페이지 방문조회수는 ["+count+"] 입니다.</strong></p>");
   stmt1.close(); // 사용후 객체 닫아준다
   stmt2.close(); // 사용후 객체 닫아준다
   rset.close(); // 사용후 객체 닫아준다
   conn.close(); // 사용후 객체 닫아준다
%>

</body>
</html>