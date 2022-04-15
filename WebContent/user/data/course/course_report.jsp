<%@page import="java.sql.ResultSet"%>
<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="com.tools.College"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>课程报表</title>
</head>
<body>
	<h1 style="text-align: center">课程信息报表</h1>
	<%
		College un = new College();
	
		int course_number = un.getCourseCount();
		int course_major = un.getMajorCourseCount();
		int course_optional = un.getOptionalCourseCount();
		
		
		// 查询更多信息，可以使用ConnectDB类，但记得关闭
		ConnectDB mysql = new ConnectDB();
		String sql = "select count(%s) from %s where %s";
		try{
			// ResultSet rs = mysql.executeQuery(String.format(sql, "*", "Student", "Student.SSex = '男'"));
			// if (rs != null && rs.next()) student_man = rs.getInt(1);
			mysql.close();
		} catch(Exception e) {
			mysql.close();
			// 数据库访问出错的处理
			System.err.println("数据库出错" + e.getMessage());
		}
		
		
	%>
	<p>当前学校“<%= un.name%>”拥有课程数量为：<%= course_number %>，其中选修课有：<%= course_optional %>，必修课有：<%= course_major %></p>
	<form action="course_report.jsp" method="get">
		<input placeholder="搜索课程名" type="search" name="course_name"/>
		<input type="submit">
	</form>

	<%
		String course_name = request.getParameter("course_name");
		if (course_name == null || "".equals(course_name)) return;
	%>
		<table>
		<tr>
			<td>课程号</td><td>课程名</td><td>必修</td><!-- <td>性别</td><td>年龄</td><td>班级</td> -->
			<!-- <td>所在系部</td><td>选修课</td><td>必修课</td> -->
		</tr>
	<%
		String sqlString = "select * from Course where Course.CName like '%" + course_name + "%'";
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				long id = rs.getLong("CNo");
				String name = rs.getString("CName");
				String bMajor = (rs.getBoolean("CMajor") ? "是" : "否");
	%>
			<tr>
				<td><%= id %></td>
				<td><%= name %></td>
				<td><%= bMajor%></td>
				<td><input type="button" value="查看编辑" onclick="window.open('modify_course.jsp?course_id=<%= id%>')"/></td>
				<%-- <td><%= rs.getString("SSex") %></td> --%>
				<%-- <td><%= rs.getInt("SAge") %></td> --%>
				<%-- <td><%= rs.getLong("CNo") %></td> --%>
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