<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="java.util.*" %>
<%@page import="com.tools.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 获取session用户名
	String userName = (String)session.getAttribute("username");
	String password = (String)session.getAttribute("password");
	// System.out.println(userName);
	if( userName == null || "".equals(userName))  {
		session.setAttribute("message", "请先登录");
		// 未设置用户名，即非正常登录，则返回login.jsp
		// response.sendRedirect("../../../login.jsp");
		out.println("<script type=\"text/javascript\">");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
		return;
	}
	
	College un = new College();
	
	// 获取添加学生的信息
	// String[] student_info;
	String department_name = request.getParameter("department_name");
	String department_id = request.getParameter("department_id");
	String department_id_new = request.getParameter("department_id_new");
	
	// 原来系部信息
	Department department_old = null;
	if (department_id != null && (!"".equals(department_id))) {
		department_old = new Department(Long.parseLong(department_id));
		department_old.setDepartmentInfo();
	}
	
	if (department_id_new != null && department_name != null && 
		(!"".equals(department_id_new)) && (!"".equals(department_name))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		
		Department department = new Department(Long.parseLong(department_id_new));
		department.name = department_name;
		
		if (!un.updateDepartment(department_old,  department, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加班级 ID：" + department.id + " "
				+ "专业名：" + department.name + " "
				+ "成功\");");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
		return;
	}
	session.setAttribute("message", "必须将所有项目填完整才能添加");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>添加专业信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="modify_department.jsp">
		<input value="<%= department_old.id %>" style="display: none;" name="department_id"/>
		<table>
			<caption>修改系部</caption>
			<tbody>
				<tr>
					<td>系号</td>
					<td><input type="text" placeholder="系号" name="department_id_new" value="<%= department_old.id%>"/></td>
				</tr>
				<tr>
					<td>系名</td>
					<td><input type="text" placeholder="系名" name="department_name" value="<%= department_old.name%>"/></td>
				</tr>
				<tr>
					<td colspan="2">
						<table>
							<caption>系部专业表</caption>
							<tr>
								<td>专业ID</td>
								<td>专业名</td>
								<td><input type="button" value="添加专业" onclick="window.open('../speciality/add_speciality.jsp')"/></td>
							</tr>
						<% 
							StringBuffer message = new StringBuffer();
							List<Speciality> specialities = department_old.getSpecialities();
							for (Speciality spec : specialities) {
						%>
							<tr>
								<td><%= spec.id %></td>
								<td><%= spec.name %></td>
								<td><input type="button" value="删除当前专业" onclick="window.open('../speciality/delete_speciality.jsp?speciality_id=<%= spec.id %>')"/></td>
							</tr>
						<%
							}
						%>
						</table>
					</td>
				</tr>
				<tr><td><input type="submit" value="提交"/></td></tr>
			</tbody>
		</table>
	</form>
</body>
</html>