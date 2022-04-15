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
			
			// 获取大学的部门
			College un = new College();
			List<Department> department = un.getDepartments();
			
		%>
			<table>
				<caption><h1>系部信息管理</h1></caption>
				<tbody>
					<tr>
						<td>系号</td>
						<td>系名</td>
						<td style="width: 57%">系部老师</td>
						<td>系部专业</td>
						<td><input class="btn" type="button" value="添加系部" onclick="window.open('department/add_department.jsp')"/></td>
					</tr>
					<%
						for(Department depart : department) {
							// 调用setStudentInfo 获取专业名称
							// depart.setDepartmentInfo();
							// spec.department.setDepartmentInfo();
							// spec.teacher.setTeacherInfo();
					%>
					<tr>
						<td><%= depart.id %></td>
						<td><%= depart.name %></td>
						<td>
						<%
							List<Teacher> teacher = depart.getTeachers();
							for (Teacher tec : teacher) {
								// tec.setTeacherInfo();
						%>
							<span><a href="./teacher/modify_teacher.jsp?teacher_id=<%= tec.id %>"><%= tec.name %></a>,</span>
						<%
							}
						%>
						</td>
						<td>
						<%
							List<Speciality> speciality = depart.getSpecialities();
							for (Speciality spec : speciality) {
								spec.setSpecialityInfo();
						%>
							<p><a href="./speciality/modify_speciality.jsp?speciality_id=<%= spec.id%>"><%= spec.name %>,</a></p>
						<%
							}
						%>
						</td>
						<td><input class="btn" type="button" value="删除系部" onclick="window.open('department/delete_department.jsp?department_id=<%= depart.id %>')"/></td>
						<td><input class="btn" type="button" value="修改系部" onclick="window.open('department/modify_department.jsp?department_id=<%= depart.id %>')"/></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</form>
<%
	// 获取学生表的数据
	/* int pageCount = un.getPageCount("Speciality", pageSize); */
	/* int end = ((pageNow + 5 >= pageCount) ? pageCount : pageNow + 5); */ 
	/* for (int i = pageNow - 5; i <= end; ++i) { */
		/* if (i <= 0) continue; */
%>
		<%-- <input class="pageCount <%= i == pageNow ? "active" : "" %>" type="button" value="<%= i %>" onclick="window.location.href=('./speciality_info.jsp?page=<%= i %>')"/> --%>
<%
	/* } */
%> 
		<%-- <p>共<%= pageCount%>页，当前第<%= pageNow %>页</p> --%>
	</body>

</html>




