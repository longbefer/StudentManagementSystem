<%@page import="java.sql.ResultSet"%>
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
	
	// 获取旧的教师信息
	String teacher_id = request.getParameter("teacher_id");
	Teacher tec = null;
	// Department dept = null;
	if (teacher_id != null && (!"".equals(teacher_id))) {
		tec = new Teacher(Long.parseLong(teacher_id));
		tec.setTeacherInfo();
		// dept = new Department(tec.department);
	}
	
	// 获取新的教师的信息
	String teacher_id_new = request.getParameter("teacher_id_new");
	String teacher_name = request.getParameter("teacher_name");
	String teacher_department = request.getParameter("department_id");
	
	if (teacher_id_new != null && teacher_name != null && teacher_department != null 
		&& (!"".equals(teacher_id_new)) && (!"".equals(teacher_name)) && (!"".equals(teacher_department))) {
		
		// 若存在教师信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		long new_id = Long.parseLong(teacher_id_new);
		long old_id = Long.parseLong(teacher_id);
		
		// 修改老师的信息为nTec
		Teacher nTec = new Teacher(new_id);
		nTec.name = teacher_name;
		nTec.department = new Department(Long.parseLong(teacher_department));
		nTec.department.setDepartmentInfo();
		
		if (!un.updateTeacher(tec, nTec, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"更新教师为 ID：" + nTec.id + " "
				+ "姓名：" + nTec.name + " "
				+ "部门 " + nTec.department.name + " "
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
<title>修改教师信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="modify_teacher.jsp">
		<input name="teacher_id" value="<%= teacher_id%>" style="display: none"/>
		<table>
			<caption>修改教师信息</caption>
			<tbody>
				<tr>
					<td>教师ID</td>
					<td><input type="number" placeholder="ID" name="teacher_id_new" value="<%= tec.id %>"/></td>
				</tr>
				<tr>
					<td>教师姓名</td>
					<td><input type="text" placeholder="姓名" name="teacher_name" value="<%= tec.name %>"/></td>
				</tr>
				<tr>
					<td>所属系部</td>
					<td>
						 <select name="department_id">
						 <%
						 	List<Department> departments = un.getDepartments();
						 	String selected = "";
						 	for (Department d : departments){
						 		if (d.id == tec.department.id) selected = "selected=\"selected\"";
						 		else selected = "";
						 %>
                            <option value="<%= d.id %>" <%= selected %>><%= d.id %>系<%= d.name %></option>
                         <%
                         	}
                         %>
                        </select>
					</td>
				</tr>
				<tr><td colspan="2" style="text-align: center"><input type="submit" value="提交"/></td></tr>
				<tr></tr>
				<tr>
					<td colspan="2">
						<table>
							<caption>教授课程表</caption>
							<tbody>
								<tr>
									<td>班级</td>
									<td>课程</td>
									<td><input value="添加班级课程" type="button" onclick="window.open('cc_add.jsp?teacher_id=<%= tec.id %>')"/></td>
								</tr>
								<%
									String sql = "select CC.ClassesNo, Course.CName, Course.CNo " + 
												"from Course,CC where Course.CNo = CC.CourseNo and " + 
												"CC.TeacherNo = " + tec.id;
									ConnectDB mysql = new ConnectDB();
									ResultSet rs = mysql.executeQuery(sql);
									while (rs.next()) {
										long classes_id = rs.getLong("ClassesNo");
										long course_id = rs.getLong("CNo");
										String course_name = rs.getString("CName");
 								%>
 									<tr>
 										<td><%= classes_id %>班</td>
 										<td><%= course_id %> | <%= course_name %></td>
 										<td><input value="删除班级课程" type="button" onclick="window.open('cc_delete.jsp?course_id=<%= course_id%>&classes_id=<%= classes_id %>')"/></td>
 									</tr>
 								<%
									}
									mysql.close();
 								%>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
</html>