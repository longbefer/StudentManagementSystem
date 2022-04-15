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
	String teacher_id = request.getParameter("teacher_id");
	String teacher_name = request.getParameter("teacher_name");
	String teacher_department = request.getParameter("department_id");
	
	if (teacher_id != null && teacher_name != null && teacher_department != null 
		&& (!"".equals(teacher_id)) && (!"".equals(teacher_name)) && (!"".equals(teacher_department))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Teacher tec = new Teacher(Long.parseLong(teacher_id));
		tec.name = teacher_name;
		Department dept = new Department(Long.parseLong(teacher_department));
		dept.setDepartmentInfo();
		if (!un.addTeacher(tec, dept, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加教师 学号：" + tec.id + " "
				+ "姓名：" + tec.name + " "
				+ "部门 " + dept.name + " "
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
<title>添加学生信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="add_teacher.jsp">
		<table>
			<caption>添加教师</caption>
			<tbody>
				<tr>
					<td>教师ID</td>
					<td><input type="number" placeholder="ID" name="teacher_id"/></td>
				</tr>
				<tr>
					<td>教师姓名</td>
					<td><input type="text" placeholder="姓名" name="teacher_name"/></td>
				</tr>
				<tr>
					<td>所属系部</td>
					<td>
						 <select name="department_id">
						 <%
						 	List<Department> departments = un.getDepartments();
						 	for (Department d : departments){
						 %>
                            <option value="<%= d.id %>"><%= d.id %>系<%= d.name %></option>
                         <%
                         	}
                         %>
                        </select>
					</td>
				</tr>
				<tr><td><input type="submit" value="提交"/></td></tr>
			</tbody>
		</table>
	</form>
</body>
</html>