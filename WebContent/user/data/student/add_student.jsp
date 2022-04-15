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
	String student_id = request.getParameter("student_id");
	String student_name = request.getParameter("student_name");
	String student_age = request.getParameter("student_age");
	String student_sex = request.getParameter("student_sex");
	String student_classes = request.getParameter("student_classes");
	if (student_id != null && student_name != null && student_age != null 
		&& student_sex != null && student_classes != null 
		&& (!"".equals(student_id)) && (!"".equals(student_name))
		&& (!"".equals(student_sex)) && (!"".equals(student_classes))) {
		
		// 若存在学生信息，则将其添加到数据库中
		StringBuffer message = new StringBuffer();
		
		Student stu = new Student(Long.parseLong(student_id));
		stu.name = student_name;
		stu.sex = student_sex;
		stu.age = Integer.parseInt(student_age);
		stu.classes = new Classes(Integer.parseInt(student_classes));
		if (!un.addStudent(stu, stu.classes, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"添加失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"添加学生 学号：" + stu.id + " "
				+ "姓名：" + stu.name + " "
				+ "班级" + stu.classes.id + " "
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
	<form action="add_student.jsp">
		<table>
			<caption>添加学生</caption>
			<tbody>
				<tr>
					<td>学生学号</td>
					<td><input type="text" placeholder="学号" name="student_id"/></td>
				</tr>
				<tr>
					<td>学生姓名</td>
					<td><input type="text" placeholder="姓名" name="student_name"/></td>
				</tr>
				<tr>
					<td>学生性别</td>
					<td>
						<label>
                            <input type="radio" name="student_sex" checked="checked" value="男">男
                        </label>
                        <label>
                            <input type="radio" name="student_sex" value="女">女
                        </label>
					</td>
				</tr>
				<tr>
					<td>学生年龄</td>
					<td><input type="number" placeholder="年龄" name="student_age"/></td>
				</tr>
				<tr>
					<td>学生班级</td>
					<td>
						 <select name="student_classes">
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
				<tr><td><input type="submit" value="提交"/></td></tr>
			</tbody>
		</table>
	</form>
</body>
</html>