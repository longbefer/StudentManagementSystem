<%@page import="com.dao.mysql.ConnectDB"%>
<%@page import="com.tools.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>删除CC信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<%	
		// 获取session用户名
	 	String userName = (String)session.getAttribute("username");
		String password = (String)session.getAttribute("password");
		// System.out.println(userName);
		if( userName == null || "".equals(userName)) 
		{
			session.setAttribute("message", "请先登录");
			// 未设置用户名，即非正常登录，则返回login.jsp
			response.sendRedirect("../../../login.jsp");
			return;
		}
		// 在删除学生时，获取学生的id
		String courseID = (String)request.getParameter("course_id");
		String classID = (String)request.getParameter("classes_id");
		if (courseID == null || "".equals(courseID) &&
			classID == null || "".equals(classID)) {
			out.println("<script type=\"text/javascript\">");
	 		out.println("alert('无法删除，请传递参数！');");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		} 
		long courseid = Long.parseLong(courseID);
		long classesid = Long.parseLong(classID);
		// out.println(id);
		String sqlString = "delete from CC where CC.CourseNo = " 
					+ courseid + " and CC.ClassesNo = " + classesid;
		ConnectDB mysql = new ConnectDB();
		if (mysql.executeUpdate(sqlString) == 0) {
			mysql.close();
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"删除失败。\");");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		mysql.close();
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"删除课程 ID：" + courseid + " "
				+ "班级ID：" + classesid + " "
				+ "成功\");");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
	%>
</body>
</html>