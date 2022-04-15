<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="com.tools.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>老师信息报表</title>
</head>
<body>
	<h1 style="text-align: center">教师信息报表</h1>
	<!-- 统计学生的人数、性别 -->
	<%
		College un = new College();
		
		int teacher_count = un.getTeacherNumber();
		
		ConnectDB mysql = new ConnectDB();
		
	%>
	<p>当前学校“<%= un.name%>”教师人数共有：<%= teacher_count %>人</p>
	<%
		// ResultSet rs 
		//List<Department>  department = un.getDepartments();
		//for (Department dept : department) {
		//	int size = un.getTeachers(dept).size();
	%>
	<%-- <span>当前“<%= dept.name %>”共有教师：<%= size %>人</span><br/> --%>
	<%
		//}
	%>
	<form action="teacher_report.jsp" method="get">
		<input placeholder="搜索教师姓名" type="search" name="teacher_name"/>
		<input type="submit">
	</form>

	<%
		String teacher_name = request.getParameter("teacher_name");
		if (teacher_name == null || "".equals(teacher_name)) return;
	%>
		<table>
		<tr>
			<td>ID</td><td>姓名</td><td>系部</td><td></td><!-- <td>年龄</td><td>班级</td> -->
			<!-- <td>所在系部</td><td>选修课</td><td>必修课</td> -->
		</tr>
	<%
		String sqlString = "select * from Teacher where Teacher.TName like '%" + teacher_name + "%'";
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
	%>
			<tr>
				<td><%= rs.getLong("TNo") %></td>
				<td><%= rs.getString("TName") %></td>
				<%-- <td><%= rs.getString("SSex") %></td> --%>
				<%-- <td><%= rs.getInt("SAge") %></td> --%>
				<td><%= rs.getLong("DNo") %></td>
				<td><input value="查看编辑" onclick="window.open('../teacher/modify_teacher.jsp?teacher_id=<%= rs.getLong("TNo") %>')" type="button"/></td>
			</tr>
	<%
			}
			mysql.close();
		} catch(Exception e) {
			mysql.close();
			System.out.println("在教师信息报表中发生错误" + e.getMessage());
		}
	%>
	</table>
</body>
</html>