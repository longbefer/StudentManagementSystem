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
			List<Course> courses = un.getCourses(pageNow, pageSize);
			
		%>
			<table>
				<caption><h1>课程信息管理</h1></caption>
				<tbody>
					<tr>
						<td>课程号</td>
						<td>课程名</td>
						<td>是否选修</td>
						<td>教授老师ID</td>
						<td>教授的班级</td>
						<td><input class="btn" type="button" value="添加课程" onclick="window.open('course/add_course.jsp')"/></td>
					</tr>
					<%
						// while (rs != null && rs.next()) {
						String bMajor = "否";
						for(Course cou : courses) {
							// 调用setStudentInfo 获取专业名称
							cou.setCourseInfo();
							if (cou.isMajor) bMajor = "是";
							else bMajor = "否";
					%>
					<tr>
						<td><%= cou.id %></td>
						<td><%= cou.name %></td>
						<td><%= bMajor %></td>
						<td>
						<%
							List<Teacher> tes = cou.getCourseTeachers();
							for (Teacher ts : tes) {
						%>
							<span><a href="./teacher/modify_teacher.jsp?teacher_id=<%= ts.id%>"><%= ts.id %></a></span>,
						<%
							}
						%>
						</td>
						<td>
						<%
							List<Classes> cos = cou.getCourseClasses();
							for (Classes cs : cos) {
						%>
							<span><a href="./classes/modify_classes.jsp?classes_id=<%= cs.id%>"><%= cs.id %>班</a></span>,
						<%
							}
						%>
						</td>
						<td><input class="btn" type="button" value="删除课程" onclick="window.open('course/delete_course.jsp?course_id=<%= cou.id %>')"/></td>
						<td><input class="btn" type="button" value="修改课程" onclick="window.open('course/modify_course.jsp?course_id=<%= cou.id %>')"/></td>
					</tr>
					<%
						}
					%>
					<tr></tr>
					<tr>
						<td colspan="6" style="text-align: center">
						<%
							// 获取学生表的数据
							int pageCount = un.getPageCount("Course", pageSize);
							int end = ((pageNow + 5 >= pageCount) ? pageCount : pageNow + 5); 
							for (int i = pageNow - 5; i <= end; ++i) {
								if (i <= 0) continue;
						%>
								<input class="pageCount <%= i == pageNow ? "active" : "" %>" type="button" value="<%= i %>" onclick="window.location.href=('./course_info.jsp?page=<%= i %>')"/>
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




