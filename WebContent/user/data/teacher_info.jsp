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
		<title>教师信息管理</title>
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
			
			// 获取大学的教师
			College un = new College();
			List<Teacher> teachers = un.getTeachers(pageNow, pageSize);
			
		%>
			<table>
				<caption><h1>教师信息管理</h1></caption>
				<tbody>
					<tr>
						<td>教师ID</td>
						<td>教师姓名</td>
						<td>所属系部</td>
						<td>管理班级</td>
						<td>管理专业</td>
						<td>教授课程</td>
						<td><input class="btn" type="button" value="添加教师" onclick="window.open('teacher/add_teacher.jsp')"/></td>
					</tr>
					<%
						// while (rs != null && rs.next()) {
						for(Teacher t : teachers) {
							// 调用setStudentInfo 获取专业名称
							t.setTeacherInfo();
					%>
					<tr>
						<td><%= t.id %></td>
						<td><%= t.name %></td>
						<td><a href="./department/modify_department.jsp?department_id=<%= t.department.id%>"><%= t.department.name %></a></td>
						<td>
						<%
							List<Classes> tCls = t.getTeacherClasses();
							for (Classes c : tCls) {
						%>
								<span><a href="./classes/modify_classes.jsp?classes_id=<%= c.id%>"><%= c.id %>班,</a></span>
						<%	} %>
						</td>
						<td>
						<%
							List<Speciality> tSpe = t.getTeacherSpecialities();
							for (Speciality c : tSpe) {
						%>
								<span><a href="./speciality/modify_speciality.jsp?speciality_id=<%= c.id%>"><%= c.id %>,</a></span>
						<%	} %>
						</td>
						<td>
						<%
							List<Course> tCou = t.getTeacherCourses();
							for (Course c : tCou) {
						%>
								<span><a href="./course/modify_course.jsp?course_id=<%= c.id %>"><%= c.name %>, </a></span>
						<%	} %>
						</td>
						<td><input class="btn" type="button" value="删除教师" onclick="window.open('teacher/delete_teacher.jsp?teacher_id=<%= t.id %>')"/></td>
						<td><input class="btn" type="button" value="修改信息" onclick="window.open('teacher/modify_teacher.jsp?teacher_id=<%= t.id %>')"/></td>
					</tr>
					<%
						}
					%>
					<tr></tr>
					<tr>
						<td colspan="7" style="text-align: center">
						<%
							// 获取学生表的数据
							int pageCount = un.getPageCount("Teacher", pageSize);
							int end = ((pageNow + 5 >= pageCount) ? pageCount : pageNow + 5); 
							for (int i = pageNow - 5; i <= end; ++i) {
								if (i <= 0) continue;
						%>
								<input class="pageCount <%= i == pageNow ? "active" : "" %>" type="button" value="<%= i %>" onclick="window.location.href=('./teacher_info.jsp?page=<%= i %>')"/>
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




