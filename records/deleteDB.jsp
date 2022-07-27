<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.sql.*, java.io.*" %>
<%@ page errorPage="ErrorOfdeleteDB.jsp" %>
 <html>
 <head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<style>
		#list{
			width: 1000;
			font-size: 30px;
			margin-left: auto;
			margin-right: auto;
			margin-top: 7%;
			background-color: white;
			font-family: 'Times New Roman', Times, serif;
		}
		#nextButton{
			width: 1000;
			font-size: 40px;
			margin-left: auto;
			margin-right: auto;
			margin-top: 7%;
			font-family: 'Times New Roman', Times, serif;
		}
		body {
				background-image: url('./tablebg.png');
		}
		h1 {
			margin-top: 5%;
			font-family: 'Times New Roman', Times, serif;
			font-size: 50px;
			text-align: center;
		}
	</style>
 </head>
 <body>
   <br>
   <%   
      String name1 = request.getParameter("studentname");
      String name = new String(name1.getBytes("8859_1"),"utf-8");
      int studentid = Integer.parseInt(request.getParameter("studentid"));
      int kor = Integer.parseInt(request.getParameter("korean"));
      int eng = Integer.parseInt(request.getParameter("english"));
      int mat = Integer.parseInt(request.getParameter("math"));
         
      // 데이터베이스 연결 // 데이터베이스 접근
      Class.forName("com.mysql.cj.jdbc.Driver");      //JDBC 드라이버 로드
      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/kopo08","root","root");
                                          
      // 삭제하기 (DELETE) : -> 학번 기준으로 데이터 찾아 삭제
      Statement stmt0 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
      String QueryTxt0 = String.format("delete from examtable where studentid ="+studentid+";"); 
      stmt0.execute(QueryTxt0);   
      
      // 삭제 결과 조회하기 (전체 데이터)
      Statement stmt1 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
      String QueryTxt1 = String.format("select *, (select count(*)+1 from examtable as a where (a.kor+a.eng+a.mat) > (b.kor+b.eng+b.mat)) from examtable as b order by studentid asc;");
      ResultSet rset1 = stmt1.executeQuery(QueryTxt1);
      
      // 삭제 결과 조회하기 (데이터 수)
      Statement stmt2 = conn.createStatement();      // Statement(sql 쿼리 전달) 변수에 database연결-명령어 저장;
      ResultSet rset2 = stmt2.executeQuery("select count(*) from examtable;");
                                          // sql 쿼리 실행하여 나온 결과(ResultSet) 저장;
   %>
   
   <%   // 데이터베이스 테이블에서 읽어온 데이터 준비
      int dataPerPage = 10;         // 한 페이지당 출력 개수 결정;
      int IndexLength = 10;         // 목록 번호 출력 개수 결정;
      int LineCnt = 0;             // 데이터 번호 카운트 위한 변수;
      int fromPT;                  // 첫 번째 데이터 ResultSet (Parameter로 받아서 계산);
      int countPT;               // 한 페이지당 출력 개수 (Paramater로 받아서 계산);
      int first_pageNum = 0;         // 목록 번호 중 가장 첫 번째 (가장 작은) 숫자; 
      int lastPage = 0;            // 마지막 페이지 번호 확인 위한 변수;
      int totalData = 0;            // 총 데이터 수 (ResultSet Row);
      
      // 목록의 첫 페이지 번호 계산 (목록 번호 출력용)
      String dataNum = request.getParameter("from");
      
      if (dataNum == null) {   // 접속 시 first_pageNum 결정 ==> Parameter로 값 받기 전
         first_pageNum = 1;
      } else {            // first_pageNum (총 출력 시작 데이터 번호 / (목록 길이 * 페이지당 데이터 개수))의 몫 * 목록 길이 + 1;
         first_pageNum = (Integer.parseInt(dataNum)/(IndexLength*dataPerPage))*IndexLength+1;
      }
      
      // 현재 페이지에 출력할 데이터의 번호 결정 (데이터 출력용)
      String fromPT01 = request.getParameter("from");
      if (fromPT01 == null) {   // 접속 시 첫 번째 출력 데이터 번호 결정 ==> Parameter로 값 받기 전
         fromPT = 1;
      } else {
         fromPT = Integer.parseInt(request.getParameter("from"));
      }
      
      // 현재 페이지 번호
      int currentPage = fromPT / dataPerPage + 1;
      
      // 한 페이지당 출력 데이터 개수 (Parameter로 값 받아옴)
      String countPT01 = request.getParameter("count");
      if (countPT01 == null) {
         countPT = dataPerPage;
      } else {
         countPT = Integer.parseInt(request.getParameter("count"));
      }
      
      // 마지막 페이지 번호 계산
      if(rset2.next()) {
         totalData = rset2.getInt(1);
         if (totalData % dataPerPage == 0) {
            lastPage = (totalData / dataPerPage);
         } else {
            lastPage = (totalData / dataPerPage) + 1;
         }
      }
   %>
   
   <%
      // ##########출력 시작##########

      // ##1. 페이지 번호
      out.println("<h1>성적 조회 후 삭제 완료<br>현재 페이지 : "+currentPage+"</h1>");
      
      // ##########출력 시작##########
      out.print("<table id=list cellspacing=1 width=600 border=1>");
      
      // 테이블 항목 출력 -> 배경색 lightblue로 지정하고, 내용 가운데 정렬
      out.println("<tr>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"이름"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"학번"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"국어"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"영어"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"수학"+"</p></td>");
	  out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"합계"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"평균"+"</p></td>");
      out.println("<td width=50 bgcolor=lightgreen><p align=center>"+"등수"+"</p></td>");
      out.println("</tr>");
   
   
      while (rset1.next()) {         // ResultSet 한 줄씩 읽어가며 --> 공백이 아닌 경우 출력
      
         LineCnt++;                        // ResultSet 번호 부여 (1~last)
         if (LineCnt < fromPT) continue;         // LineCnt가 시작점보다 작은 경우 while문 처음으로 돌아가 반복
         if (LineCnt >= fromPT+countPT) break;   // LineCnt가 마지막 점보다 큰 경우 while문 빠져나가기
      
         out.println("<tr>");      // 출력 칸 형식 : 가로길이 50, 가운데정렬(align)
         out.println("<td width=50><p align=center>"+rset1.getString(1)+"</p></td>");
         out.println("<td width=50><p align=center><a href='./oneviewDB.jsp?key="+Integer.toString(rset1.getInt(2))+"'>"+Integer.toString(rset1.getInt(2))+"</a></p></td>");
            // '학번' 클릭 시, 해당 학생의 데이터만 출력되도록 하기 위해 (1) anchor 태그로 1명 학생 정보만 조회할 페이지 연결
            // '학번'을 key로 지정하여 연결 페이지에 정보를 넘겨줌 (?key=학번)
         out.println("<td width=50><p align=center>"+Integer.toString(rset1.getInt(3))+"</p></td>");
         out.println("<td width=50><p align=center>"+Integer.toString(rset1.getInt(4))+"</p></td>");
         out.println("<td width=50><p align=center>"+Integer.toString(rset1.getInt(5))+"</p></td>");
		 out.println("<td width=50><p align=center>" + Integer.toString(rset1.getInt(3)+rset1.getInt(4)+rset1.getInt(5)) + "</p></td>");
		 out.println("<td width=50><p align=center>" + Integer.toString((rset1.getInt(3)+rset1.getInt(4)+rset1.getInt(5))/3) + "</p></td>");
		 out.println("<td width=50><p align=center>" + Integer.toString(rset1.getInt(6)) + "</p></td>");
         out.println("</tr>");
      }
      
      
      // << 화살표 클릭 시, 페이지 번호 결정 (Page List의 첫 번째 번호)
      int backward;   // 변수 : << 화살표 클릭 시의 목록 첫 번째 번호 결정
      int backward1 = first_pageNum - IndexLength;
      if (backward1 < (1+ IndexLength)) {                     // 리스트 목록 두 번째 시작점보다 작으면, 1
         backward = 1;                     
      } else {                                       // 리스트 목록 두 번째 시작점보다 작지 않으면, 계산한 숫자.
         backward = first_pageNum - IndexLength;
      }
      
      // >> 화살표 클릭 시, 페이지 번호 결정 (Page List의 첫 번째 번호)
      int forward;   // 변수 : >> 화살표 클릭 시의 목록 첫 번째 번호 결정
      int forward1 = first_pageNum + IndexLength;                           // 페이지 리스트의 시작점 + 목록 길이
      if (forward1 > ((totalData/(dataPerPage*IndexLength))*IndexLength + 1)) {   
                                                               // 페이지 리스트 시작점이 마지막 페이지 리스트 시작점보다 크면,
         forward = (totalData/(dataPerPage*IndexLength))*IndexLength + 1;         // 마지막 페이지 리스트 시작점 값 대입.
      } else {                                                   // 아닌 경우,
         forward = first_pageNum + IndexLength;                           // first_pageNum에 IndexLength 더하기
      }
      
      // ##4. 목록 출력 
      out.println("<table id=nextButton border=0><br><br>");
      out.println("<tr>");
      
      // 4-1. << 화살표
      out.println("<td width=50><p align=center><a href='./AllviewDB.jsp?from="+((backward-1)*dataPerPage+1)
                        +"&count="+dataPerPage+"'>"+"<<"+"</a></p></td>");
      
      // 4-2. 목록 번호
      for (int i = 0; i < IndexLength; i++) {      
         // 목록 번호가 lastPage보다 작거나 같은 경우만 출력
         if ( (first_pageNum+i) <= lastPage) {
            if ( (first_pageNum+i) == currentPage) {
               out.println("<td width=50 id=current><p align=center><a href='./AllviewDB.jsp?from="+((first_pageNum+i-1)*dataPerPage+1)
                        +"&count="+dataPerPage+"'>"+(first_pageNum+i)+"</a></p></td>");
            } else {
               out.println("<td width=50 id=other<p align=center><a href='./AllviewDB.jsp?from="+((first_pageNum+i-1)*dataPerPage+1)
                        +"&count="+dataPerPage+"'>"+(first_pageNum+i)+"</a></p></td>");
            }
         }
      };   
      
      // 4-3. >> 화살표 
      // 페이지 이동 화살표 클릭 시의 Parameter 결정 (데이터 출력 시작점)
      if (currentPage < totalData/(IndexLength*dataPerPage)*IndexLength+1) {
         out.println("<td width=50><p align=center><a href='./AllviewDB.jsp?from="
                     +((forward-1)*dataPerPage+1)+"&count="+dataPerPage+"'>"+">>"+"</a></p></td>");
      // 더 이상 뒤로 갈 페이지가 없는 경우 --> 마지막 페이지 출력
      } else {
         out.println("<td width=50><p align=center><a href='./AllviewDB.jsp?from="
                     +((lastPage-1)*dataPerPage+1)+"&count="+dataPerPage+"'>"+">>"+"</a></p></td>");
      }
      
      out.println("</tr></table>");
      
      out.println("</table>");
      // ##########출력 종료##########
      
      
      rset1.close();
      rset2.close();
      stmt0.close();
      stmt1.close();
      stmt2.close();
      conn.close();
   %>


</BODY>
</HTML>
