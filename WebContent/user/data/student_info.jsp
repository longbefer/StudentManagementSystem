<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="com.tools.*" %>
<%@page import="java.lang.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html class="scrool-style">

	<head>
		<meta charset="UTF-8">
		<title>学生信息管理</title>
		<link rel="stylesheet" href="css/form.css" />
	</head>

	<body>
		<form>
		<%
			// 获取session用户名
		 	String userName = (String)session.getAttribute("username");
			String password = (String)session.getAttribute("password");
			// System.out.println(userName);
			if( userName == null || "".equals(userName)) 
			{
				session.setAttribute("message", "请先登录");
				// 未设置用户名，即非正常登录，则返回login.jsp
				response.sendRedirect("../../login.jsp");
				return;
			}
			Setup mysql = new Setup();
			StringBuffer message = new StringBuffer();
			// 判断该账号是否可以登录
			if (!mysql.login(userName, password, message)) {
				session.setAttribute("message", message.toString());
				response.sendRedirect("../../login.jsp");
				return;
			}
			// 可以登录，查询数据库将学生的信息调用出来
			
			// 对数据库使用分页
			int pageSize = 30; // 每页的数量
			
			int pageNow = 1; // 当前所在的页
			String pageString = request.getParameter("page");
			if (pageString != null && (!pageString.equals("")))
				pageNow = Integer.parseInt(pageString);
			
			// 获取大学的学生
			College un = new College();
			List<Student> stus = un.getStudents(pageNow, pageSize);
			
		%>
			<table>
				<thead><h1 style="text-align: center">学生信息管理</h1></thead>
				<tbody>
					<tr>
						<td>学生学号</td>
						<td>学生姓名</td>
						<td>学生性别</td>
						<td>学生年龄</td>
						<td>学生班级</td>
						<td><input class="btn" type="button" value="添加学生" onclick="window.open('student/add_student.jsp')"/></td>
					</tr>
					<%
						// while (rs != null && rs.next()) {
						for(Student stu : stus) {
							// 调用setStudentInfo 获取专业名称
							stu.setStudentInfo();
					%>
					<tr>
						<td><%= stu.id %></td>
						<td><a href="./student/student_detail.jsp?student_id=<%= stu.id %>"><%= stu.name %></a></td>
						<td><%= stu.sex %></td>
						<td><%= stu.age %></td>
						<td><a href="./classes/modify_classes.jsp?classes_id=<%= stu.classes.id%>"><%= stu.classes.id %>班</a></td>
						<%-- <td><%= stu.speciality %></td> --%>
						<%-- <td><%= rs.getInt("SNo") %></td> --%>
						<%-- <td><%= rs.getString("SName") %></td> --%>
						<%-- <td><%= rs.getString("SSex") %></td> --%>
						<%-- <td><%= rs.getInt("SAge") %></td> --%>
						<%-- <td><%= rs.getInt("CNo") %></td> --%>
						<td><input class="btn" type="button" value="删除学生" onclick="window.open('student/delete_student.jsp?student_id=<%= stu.id %>')"/></td>
						<td><input class="btn" type="button" value="修改信息" onclick="window.open('student/modify_student.jsp?student_id=<%= stu.id %>')"/></td>
					</tr>
					<%
						}
					%>
					<tr></tr>
					<tr>
						<td colspan="7" style="text-align: center">
						<%
							// 获取学生表的数据
							int pageCount = un.getPageCount("Student", pageSize);
							int end = ((pageNow + 5 >= pageCount) ? pageCount : pageNow + 5); 
							for (int i = pageNow - 5; i <= end; ++i) {
								if (i <= 0) continue;
						%>
								<input class="pageCount <%= i == pageNow ? "active" : "" %>" type="button" value="<%= i %>" onclick="window.location.href=('./student_info.jsp?page=<%= i %>')"/>
						<%
							}
						%> 
								<p>共<%= pageCount%>页，当前第<%= pageNow %>页</p>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</body>

</html>




