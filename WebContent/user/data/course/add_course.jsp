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
	String course_name = request.getParameter("course_name");
	String course_major = request.getParameter("course_major");
	// String[] teacher_id = request.getParameterValues("teacher_id");
	// String student_sex = request.getParameter("student_sex");
	// String student_classes = request.getParameter("student_classes");
	
	// 这里就不添加班级和老师对应对了，因为太难了。。。
	if (course_id != null && course_name != null && course_major != null
		&& (!"".equals(course_id)) && (!"".equals(course_name))
		&& (!"".equals(course_major))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Course course = new Course(Long.parseLong(course_id));
		course.name = course_name;
		course.isMajor = ("是".equals(course_major) ? true : false);
		
		if (!un.addCourse(course, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加班级 ID：" + course.id + " "
				+ "课程名：" + course.name + " "
				+ "是否选修" + course.isMajor + " "
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
	<form action="add_course.jsp">
		<table>
			<caption>添加课程</caption>
			<tbody>
				<tr>
					<td>课程号</td>
					<td><input type="text" placeholder="课程号" name="course_id"/></td>
				</tr>
				<tr>
					<td>课程名</td>
					<td><input type="text" placeholder="课程名" name="course_name"/></td>
				</tr>
				<tr>
					<td>必修课</td>
					<td>
						<label>
                            <input type="radio" name="course_major" checked="checked" value="是">是
                        </label>
                        <label>
                            <input type="radio" name="course_major" value="否">否
                        </label>
					</td>
				</tr>
				<tr><td><input type="submit" value="提交"/></td></tr>
			</tbody>
		</table>
	</form>
</body>
</html>