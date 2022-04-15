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
	String speciality_name = request.getParameter("speciality_name");
	String department_id = request.getParameter("department_id");
	String teacher_id = request.getParameter("teacher_id");
	String speciality_id = request.getParameter("speciality_id");
	
	// 这里就不添加班级和老师对应对了，因为太难了。。。
	if (department_id != null && teacher_id != null && speciality_id != null &&
		speciality_name != null && (!"".equals(department_id)) && 
		(!"".equals(teacher_id)) && (!"".equals(speciality_id)) && 
		(!"".equals(speciality_name))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Speciality speciality = new Speciality(Long.parseLong(speciality_id));
		speciality.name = speciality_name;
		
		speciality.teacher = new Teacher(Long.parseLong(teacher_id));
		speciality.teacher.setTeacherInfo();
		
		speciality.department = new Department(Long.parseLong(department_id));
		speciality.department.setDepartmentInfo();
		
		if (!un.addSpeciality(speciality, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加班级 ID：" + speciality.id + " "
				+ "专业名：" + speciality.name + " "
				+ "指导老师： " + speciality.teacher.name + " "
				+ "系部" + speciality.department.name + " "
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
	<form action="add_speciality.jsp">
		<table>
			<caption>添加专业</caption>
			<tbody>
				<tr>
					<td>专业号</td>
					<td><input type="text" placeholder="专业号" name="speciality_id"/></td>
				</tr>
				<tr>
					<td>专业名</td>
					<td><input type="text" placeholder="专业名" name="speciality_name"/></td>
				</tr>
				<tr>
					<td>指导老师</td>
					<td>
						<select name="teacher_id">
					<%
						List<Teacher> teachers = un.getTeachers();
						for (Teacher tec : teachers) {
							// tec.setTeacherInfo();	
					%>
							<option value="<%= tec.id %>"><%= tec.id %> | <%= tec.name %></option>
					<%
						}
					%>
						</select>
					</td>
				</tr>
				<tr>
					<td>系别</td>
					<td>
						<select name="department_id">
					<%
						List<Department> depart = un.getDepartments();
						for (Department dep : depart) {
							// spec.setSpecialityInfo();	
					%>
							<option value="<%= dep.id %>"><%= dep.id %> | <%= dep.name %></option>
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