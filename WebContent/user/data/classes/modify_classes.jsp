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
	Classes classes = null;
	if (classes_id != null && (!"".equals(classes_id))) {
		classes = new Classes(Long.parseLong(classes_id));
		classes.setClassesInfo();
	}
	
	String new_classes_id = request.getParameter("new_classes_id");
	String teacher_id = request.getParameter("teacher_id");
	String speciality_id = request.getParameter("speciality_id");
	
	// 这里就不添加班级和老师对应对了，因为太难了。。。
	if (classes_id != null && teacher_id != null && speciality_id != null
		&& (!"".equals(classes_id)) && (!"".equals(teacher_id))
		&& (!"".equals(speciality_id))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Classes new_classes = new Classes(Long.parseLong(new_classes_id));
		new_classes.speciality = new Speciality(Long.parseLong(speciality_id));
		new_classes.speciality.setSpecialityInfo();
		new_classes.teacher = new Teacher(Long.parseLong(teacher_id));
		new_classes.teacher.setTeacherInfo();
		
		if (!un.updateClasses(classes, new_classes, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"更改班级为 ID：" + new_classes.id + " "
				+ "班主任：" + new_classes.teacher.name + " "
				+ "系部" + new_classes.speciality.id + " "
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
<title>修改班级信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="modify_classes.jsp">
		<input value="<%= classes.id %>" name="classes_id" style="display: none"/>
		<table>
			<caption>修改班级</caption>
			<tbody>
				<tr>
					<td>班级号</td>
					<td><input type="text" placeholder="班级号" name="new_classes_id" value="<%=  classes_id%>"/></td>
				</tr>
				<tr>
					<td>班主任</td>
					<td>
						<select name="teacher_id">
					<%
						String selected = "";
						List<Teacher> teachers = un.getTeachers();
						for (Teacher tec : teachers) {
							// tec.setTeacherInfo();
							if (tec.id == classes.teacher.id) 
								selected = "selected=\"selected\"";
							else selected = "";
					%>
							<option value="<%= tec.id %>" <%= selected %>><%= tec.id %> | <%= tec.name %></option>
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
						selected = "";
						List<Speciality> speciality = un.getSpecialities();
						for (Speciality spec : speciality) {
							if (spec.id == classes.speciality.id) 
								selected = "selected=\"selected\"";
							else selected = "";
							// spec.setSpecialityInfo();	
					%>
							<option value="<%= spec.id %>" <%= selected %>><%= spec.id %> | <%= spec.name %></option>
					<%
						}
					%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table>
							<caption>班级课程表</caption>
							<tr>
								<td>课程</td>
								<td>老师</td>
								<td><input type="button" value="添加班级课程" onclick="window.open('cc_add.jsp?classes_id=<%= classes.id %>')"/></td>
							</tr>
						<% 
							StringBuffer message = new StringBuffer();
							List<Map<Course, Teacher>> TCM = classes.getCourseMapTeacher(message);
							for (Map<Course, Teacher> cmt : TCM) {
								for (Map.Entry<Course, Teacher> entry : cmt.entrySet()) {
						%>
							<tr>
								<td><%= entry.getKey().name %></td>
								<td><%= entry.getValue().name %></td>
								<td><input type="button" value="删除班级课程" onclick="window.open('cc_delete.jsp?classes_id=<%= classes.id%>&course_id=<%= entry.getKey().id%>')"/></td>
							</tr>
						<%
								}
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