<%@page import="com.tools.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>删除课程信息</title>
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
		String dID = (String)request.getParameter("department_id");
		if (dID == null || "".equals(dID)) {
			out.println("<script type=\"text/javascript\">");
	 		out.println("alert('无法删除，请传递参数！');");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		} 
		long id = Long.parseLong(dID);
		// out.println(id);
		College un = new College();
		StringBuffer message = new StringBuffer();
		Department depart = new Department(id);

		if (!un.deleteDepartments(depart, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"删除失败。错误信息：" + message + "\");");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"删除部门 ID：" + depart.id + " "
				+ "部门名：" + depart.name + " "
				+ "成功\");");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
	%>
</body>
</html>