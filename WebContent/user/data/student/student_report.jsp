<%@page import="java.sql.ResultSet"%>
<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="com.tools.College"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>学生报表</title>
</head>
<body>
	<h1 style="text-align: center">学生信息报表</h1>
	<!-- 统计学生的人数、性别 -->
	<%
		College un = new College();
		
		int student_count = un.getStudentNumber();
		int student_man = 0;
		int student_feman = 0;
		// 成绩占比
		int passed = 0;
		int unpassed = 0;
		int nobad = 0;
		int good = 0;
		
		// 查询更多信息，可以使用ConnectDB类，但记得关闭
		ConnectDB mysql = new ConnectDB();
		String sql = "select count(%s) from %s where %s";
		try{
			ResultSet rs = mysql.executeQuery(String.format(sql, "*", "Student", "Student.SSex = '男'"));
			if (rs != null && rs.next()) student_man = rs.getInt(1);
			mysql.close();
			
			rs = mysql.executeQuery(String.format(sql, "*", "Student", "Student.SSex = '女'"));
			if (rs != null && rs.next()) student_feman = rs.getInt(1);
			mysql.close();
			
			rs = mysql.executeQuery(String.format(sql, "distinct SC.SNo", "SC", "SC.Grade < 60"));
			if (rs != null && rs.next()) unpassed = rs.getInt(1);
			mysql.close();
			
			rs = mysql.executeQuery(String.format(sql, "distinct SC.SNo", "SC", "SC.Grade >= 60 and SC.Grade <= 80"));
			if (rs != null && rs.next()) passed = rs.getInt(1);
			mysql.close();
			
			rs = mysql.executeQuery(String.format(sql, "distinct SC.SNo", "SC", "SC.Grade > 80 and SC.Grade <= 90"));
			if (rs != null && rs.next()) nobad = rs.getInt(1);
			mysql.close();
			
			rs = mysql.executeQuery(String.format(sql, "distinct SC.SNo", "SC", "SC.Grade > 90 and SC.Grade <= 100"));
			if (rs != null && rs.next()) good = rs.getInt(1);
			mysql.close(); 
		} catch(Exception e) {
			mysql.close();
			// 数据库访问出错的处理
			System.err.println("数据库出错" + e.getMessage());
		}
		
		float ratio_man = student_man / (float)(student_count);
		float ratio_feman = student_feman / (float)(student_count);
		
	%>
	<p>当前学校“<%= un.name%>”学生人数为：<%= student_count %>，其中男性占比：<%= ratio_man%>，女性占比：<%= ratio_feman %></p>
	<p>成绩不及格的有：<%= unpassed %>人，及格的有：<%= passed %>人，良好的有：<%= nobad %>人，优秀的有：<%= good %>人</p>
	<form action="student_report.jsp" method="get">
		<input placeholder="搜索学生姓名" type="search" name="student_name"/>
		<input type="submit">
	</form>

	<%
		String student_name = request.getParameter("student_name");
		if (student_name == null || "".equals(student_name)) return;
	%>
		<table>
		<tr>
			<td>学号</td><td>姓名</td><td>性别</td><td>年龄</td><td>班级</td><td></td>
			<!-- <td>所在系部</td><td>选修课</td><td>必修课</td> -->
		</tr>
	<%
		String sqlString = "select * from Student where Student.SName like '%" + student_name + "%'";
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
	%>
			<tr>
				<td><%= rs.getLong("SNo") %></td>
				<td><%= rs.getString("SName") %></td>
				<td><%= rs.getString("SSex") %></td>
				<td><%= rs.getInt("SAge") %></td>
				<td><%= rs.getLong("CNo") %></td>
				<td><input type="button" value="查看详情" onclick="window.open('student_detail.jsp?student_id=<%= rs.getLong("SNo") %>')"/></td>
			</tr>
	<%
			}
			mysql.close();
		} catch(Exception e) {
			mysql.close();
			System.out.println("在学生信息报表中发生错误" + e.getMessage());
		}
	%>
	</table>
</body>
</html>