<%@page import="com.tools.Department"%>
<%@page import="com.tools.Speciality"%>
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
	
		int department_num = un.getDepartments().size();
		int speciality_num = un.getSpecialities().size();
		
		
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
	<p>当前学校“<%= un.name%>”拥有系部数量为：<%= department_num %>个，其中专业共有：<%= speciality_num %>个</p>
	<form action="department_report.jsp" method="get">
		<input placeholder="搜索系部名" type="search" name="department_name"/>
		<input type="submit">
	</form>

	<%
		String department_name = request.getParameter("department_name");
		if (department_name == null || "".equals(department_name)) return;
	%>
		<table>
		<tr>
			<td>系号</td><td>系名</td><td>专业数量</td><td>老师数量</td><td>学生数量</td>
			<!-- <td>所在系部</td><td>选修课</td><td>必修课</td> -->
		</tr>
	<%
		String sqlString = "select * from Department where Department.DName like '%" + department_name + "%'";
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				long id = rs.getLong("DNo");
				String name = rs.getString("DName");
				int number = new Department(id).getSpecialities().size();
	%>
			<tr>
				<td><%= id %></td>
				<td><%= name %></td>
				<td><%= number %></td>
				<td><%= un.getTeachers(new Department(id)).size() %></td>
				<td><%= un.getStudents(new Department(id)).size() %></td>
				<td><input type="button" value="查看编辑" onclick="window.open('modify_department.jsp?department_id=<%= id%>')"/></td>
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