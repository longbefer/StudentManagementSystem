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
		response.sendRedirect("../../../login.jsp");
		return;
	}
	
	College un = new College();
	
	// 由于post请求乱码，需要使用String转换一下
	// String nameStr=new String(request.getParameter("name").getBytes("ISO-8859-1"),"UTF-8");
	
	// 获取旧的学生的信息
	String student_id = request.getParameter("student_id");
	Student stu = null;
	if (student_id == null || ("".equals(student_id))) {
		// session.setAttribute("message", "请先登录");
		// 未设置用户名，即非正常登录，则返回login.jsp
		// response.sendRedirect("../../../login.jsp");
		out.println("<script type=\"text/javascript\">");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
		return;
	}
	stu = new Student(Long.parseLong(student_id));
	stu.setStudentInfo();
	stu.classes.setClassesInfo();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>学生信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="" method="get">
		<input name="student_id" value="<%= student_id %>" style="display: none"/>
		<table>
			<caption>学生信息详情</caption>
			<tbody>
				<tr>
					<td>学生学号</td>
					<td><input type="text" placeholder="学号" name="student_id_new" value="<%= stu.id %>" readonly="readonly"/></td>
				</tr>
				<tr>
					<td>学生姓名</td>
					<td><input type="text" placeholder="姓名" name="student_name" value="<%= stu.name %>" readonly="readonly"/></td>
				</tr>
				<tr>
					<td>学生性别</td>
					<td>
						<%
							String checked = "checked=\"checked\"";
							if (stu.sex.equals("男")) {
						%>
						<label>
                            <input type="radio" name="student_sex" <%= checked %> value="男" readonly="readonly">男
                        </label>
                        <%
							} else if (stu.sex.equals("女")) {
                        %>
                        <label>
                            <input type="radio" name="student_sex" <%= checked %> value="女" readonly="readonly">女
                        </label>
                        <%
							}
                        %>
					</td>
				</tr>
				<tr>
					<td>学生年龄</td>
					<td><input type="number" placeholder="年龄" name="student_age" value="<%= stu.age %>" readonly="readonly"/></td>
				</tr>
				<tr>
					<td>学生班级</td>
					<td>
						 <!-- <select name="student_classes"> -->
						 <%
						 	// List<Classes> classes = un.getClasses();
						 	// String selected = "";
						 	// for (Classes c : classes){
						 	//	if (c.id == stu.classes.id) selected = "selected=\"selected\"";
						 	// 	else selected = "";
						 %>
						 <input value="<%= stu.classes.id%>班" readonly="readonly" />
                            <%-- <option value="<%= c.id %>" <%= selected %>><%= c.id %>班</option> --%>
                         <%
                         	// }
                         %>
                        <!-- </select> -->
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table>
							<caption>学生必修课课表</caption>
							<tr>
								<td>课程号</td>
								<td>课程名</td>
								<!-- <td>指导老师</td> -->
							</tr>
							<%
								List<Course> majorCourse = stu.getMajorCourses();
								List<Course> optionalCourse = stu.getElectiveCourses();
								for (Course c : majorCourse) {
							%>
							<tr>
								<td><%= c.id %></td>
								<td><%= c.name %></td>
							</tr>
							<% 
								}
							%>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table>
							<caption>学生选修课课表</caption>
							<tr>
								<td>课程号</td>
								<td>课程名</td>
								<td>成绩</td>
								<!-- <td>指导老师</td> -->
							</tr>
							<%
								for (Course c : optionalCourse) {
							%>
							<tr>
								<td><%= c.id %></td>
								<td><%= c.name %></td>
								<td><%= c.grade %></td>
							</tr>
							<% 
								}
							%>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
</html>