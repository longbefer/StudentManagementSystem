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
	if (student_id != null && (!"".equals(student_id))) {
		stu = new Student(Long.parseLong(student_id));
		stu.setStudentInfo();
	}
	
	// 新的学生信息
	String student_id_new = request.getParameter("student_id_new");
	String student_name = request.getParameter("student_name");
	String student_age = request.getParameter("student_age");
	String student_sex = request.getParameter("student_sex");
	String student_classes = request.getParameter("student_classes");
	if (student_id_new != null && student_name != null 
		&& student_age != null && student_sex != null 
		&& student_classes != null && (!"".equals(student_id)) 
		&& (!"".equals(student_id_new)) && (!"".equals(student_name)) 
		&& (!"".equals(student_sex)) && (!"".equals(student_classes))) {
		
		// 更新学生信息
		StringBuffer message = new StringBuffer();
		
		long new_id = Long.parseLong(student_id_new);
		long old_id = Long.parseLong(student_id);
		// Student stu = new Student(old_id); // 先使用旧ID更改信息
		stu.name = student_name;
		stu.sex = student_sex;
		stu.age = Integer.parseInt(student_age);
		stu.classes = new Classes(Integer.parseInt(student_classes));
		if ((!un.updateStudent(stu, message)) || (!un.updateStudentID(old_id, new_id, message))) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"修改失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"更改学生为 学号：" + new_id + " "
				+ "姓名：" + stu.name + " "
				+ "班级" + stu.classes.id + " "
				+ "成功\");");
 		out.println("window.opener.location.reload();");
 		out.println("window.close();");
		out.println("</script>");
		return;
	}
	session.setAttribute("message", "必须将所有项目填完整才能修改");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改学生信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="modify_student.jsp" method="get">
		<input name="student_id" value="<%= student_id %>" style="display: none"/>
		<table>
			<caption>修改学生信息</caption>
			<tbody>
				<tr>
					<td>学生学号</td>
					<td><input type="text" placeholder="学号" name="student_id_new" value="<%= stu.id %>"/></td>
				</tr>
				<tr>
					<td>学生姓名</td>
					<td><input type="text" placeholder="姓名" name="student_name" value="<%= stu.name %>"/></td>
				</tr>
				<tr>
					<td>学生性别</td>
					<td>
						<label>
							<%
								String checked = "";
								if (stu.sex.equals("男")) checked="checked=\"checked\"";
							%>
                            <input type="radio" name="student_sex" <%= checked %> value="男">男
                        </label>
                        <label>
                        	<%
                        		checked = "";
                        		if (stu.sex.equals("女")) checked="checked=\"checked\"";
                        	%>
                            <input type="radio" name="student_sex" <%= checked %> value="女">女
                        </label>
					</td>
				</tr>
				<tr>
					<td>学生年龄</td>
					<td><input type="number" placeholder="年龄" name="student_age" value="<%= stu.age %>"/></td>
				</tr>
				<tr>
					<td>学生班级</td>
					<td>
						 <select name="student_classes">
						 <%
						 	List<Classes> classes = un.getClasses();
						 	String selected = "";
						 	for (Classes c : classes){
						 		if (c.id == stu.classes.id) selected = "selected=\"selected\"";
						 		else selected = "";
						 %>
                            <option value="<%= c.id %>" <%= selected %>><%= c.id %>班</option>
                         <%
                         	}
                         %>
                        </select>
					</td>
				</tr>
				<tr>
					<td></td><td><input type="submit" value="提交"/></td>
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
								List<Course> optionalCourse = stu.getElectiveCourses();
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