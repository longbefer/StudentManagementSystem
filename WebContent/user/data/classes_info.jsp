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
		<title>班级信息管理</title>
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
			List<Classes> classes = un.getClasses(pageNow, pageSize);
			
		%>
			<table>
				<caption><h1>班级信息管理</h1></caption>
				<tbody>
					<tr>
						<td>班级号</td>
						<td>专业</td>
						<td>班主任</td>
						<td style="width: 50%">班级课表</td>
						<td>班级人数</td>
						<td><input class="btn" type="button" value="添加班级" onclick="window.open('classes/add_classes.jsp')"/></td>
					</tr>
					<%
						for(Classes cls : classes) {
							// 调用setStudentInfo 获取专业名称
							cls.setClassesInfo();
							cls.speciality.setSpecialityInfo();
							cls.teacher.setTeacherInfo();
					%>
					<tr>
						<td><%= cls.id %></td>
						<td><%= cls.speciality.name %></td>
						<td><a href="./teacher/modify_teacher.jsp?teacher_id=<%= cls.teacher.id%>"><%= cls.teacher.name %></a></td>
						<td>
						<%
							List<Course> cos = cls.getClassesCourses();
							for (Course cs : cos) {
								cs.setCourseInfo();
						%>
							<span><a href="./course/modify_course.jsp?course_id=<%= cs.id%>"><%= cs.name %></a></span>,
						<%
							}
						%>
						</td>
						<td><%= cls.studentCount() %>人</td>
						<td><input class="btn" type="button" value="删除班级" onclick="window.open('classes/delete_classes.jsp?classes_id=<%= cls.id %>')"/></td>
						<td><input class="btn" type="button" value="修改班级" onclick="window.open('classes/modify_classes.jsp?classes_id=<%= cls.id %>')"/></td>
					</tr>
					<%
						}
					%>
					<tr></tr>
					<tr>
						<td colspan="6" style="text-align: center">
						<%
							// 获取学生表的数据
							int pageCount = un.getPageCount("Classes", pageSize);
							int end = ((pageNow + 5 >= pageCount) ? pageCount : pageNow + 5); 
							for (int i = pageNow - 5; i <= end; ++i) {
								if (i <= 0) continue;
						%>
								<input class="pageCount <%= i == pageNow ? "active" : "" %>" type="button" value="<%= i %>" onclick="window.location.href=('./classes_info.jsp?page=<%= i %>')"/>
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




