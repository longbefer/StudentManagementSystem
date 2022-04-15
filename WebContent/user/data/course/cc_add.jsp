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
	String course_id = request.getParameter("course_id");
	String classes_id = request.getParameter("classes_id");
	String teacher_id = request.getParameter("teacher_id");
	// String[] teacher_id = request.getParameterValues("teacher_id");
	// String student_sex = request.getParameter("student_sex");
	// String student_classes = request.getParameter("student_classes");
	
	// 这里就不添加班级和老师对应对了，因为太难了。。。
	if (course_id != null && classes_id != null && teacher_id != null
		&& (!"".equals(course_id)) && (!"".equals(classes_id))
		&& (!"".equals(teacher_id))) {
		
		ConnectDB mysql = new ConnectDB();
		String sqlString = "insert CC(CourseNo, ClassesNo, TeacherNo, TeachTimes) values "
						+ "(" + course_id + "," + classes_id + "," + teacher_id + ", " + " 16)";
		
		if (mysql.executeUpdate(sqlString) == 0) {
			mysql.close();
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试。\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		mysql.close();
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加班级课程表 课程ID：" + course_id + " "
				+ "班级ID：" + classes_id + " "
				+ "教师ID" + teacher_id + " "
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
	<form action="cc_add.jsp">
		<table>
			<caption>添加班级课程</caption>
			<tbody>
				<tr>
					<td>请选择班级：</td>
					<td>
						<select name="classes_id">
						 <%
						 	List<Classes> classes = un.getClasses();
						 	for (Classes c : classes){
						 %>
                            <option value="<%= c.id %>"><%= c.id %>班</option>
                         <%
                         	}
                         %>
                        </select>
					</td>
				</tr>
				<tr>
					<td>请选择为该班级添加的课程：</td>
					<td>
						 <!-- <select name="course_id"> -->
						 <%
						 	// List<Course> course = un.getCourses();
						 	// for (Course c : course){
						 	Course courseGet = new Course(Long.parseLong(course_id));
						 	courseGet.setCourseInfo();
						 %>
						 	<input name="course_id" value="<%= courseGet.id%>" type="number" readonly="readonly" style="display: none;"/>
						 	<span><%= courseGet.name %></span>
                            <%-- <option value="<%= c.id %>"><%= c.id %> | <%= c.name %></option> --%>
                         <%
                         	// }
                         %>
                        <!-- </select> -->
					</td>
				</tr>
				<tr>
					<td>请选择上该课程的老师：</td>
					<td>
						 <select name="teacher_id">
						 <%
						 	List<Teacher> teacher = un.getTeachers();
						 	for (Teacher t : teacher){
						 %>
                            <option value="<%= t.id %>"> <%= t.id %> | <%= t.name %> </option>
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