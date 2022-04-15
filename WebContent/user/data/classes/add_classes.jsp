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
	String classes_id = request.getParameter("classes_id");
	String teacher_id = request.getParameter("teacher_id");
	String speciality_id = request.getParameter("speciality_id");
	
	// 这里就不添加班级和老师对应对了，因为太难了。。。
	if (classes_id != null && teacher_id != null && speciality_id != null
		&& (!"".equals(classes_id)) && (!"".equals(teacher_id))
		&& (!"".equals(speciality_id))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Classes classes = new Classes(Long.parseLong(classes_id));
		classes.speciality = new Speciality(Long.parseLong(speciality_id));
		classes.speciality.setSpecialityInfo();
		
		classes.teacher = new Teacher(Long.parseLong(teacher_id));
		classes.teacher.setTeacherInfo();
		
		if (!un.addClasses(classes, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加班级 ID：" + classes.id + " "
				+ "班主任：" + classes.teacher.name + " "
				+ "系部" + classes.speciality.id + " "
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
<title>添加班级信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="add_classes.jsp">
		<table>
			<caption>添加班级</caption>
			<tbody>
				<tr>
					<td>班级号</td>
					<td><input type="text" placeholder="班级号" name="classes_id"/></td>
				</tr>
				<tr>
					<td>班主任</td>
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
					<td>所属专业</td>
					<td>
						<select name="speciality_id">
					<%
						List<Speciality> speciality = un.getSpecialities();
						for (Speciality spec : speciality) {
							// spec.setSpecialityInfo();	
					%>
							<option value="<%= spec.id %>"><%= spec.id %> | <%= spec.name %></option>
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