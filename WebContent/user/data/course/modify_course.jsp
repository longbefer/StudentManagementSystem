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
	Course oldCourse = null;
	// 获取添加学生的信息
	// String[] student_info;
	String course_id = request.getParameter("course_id");
	if (course_id != null && (!"".equals(course_id))) {
		oldCourse = new Course(Long.parseLong(course_id));
		oldCourse.setCourseInfo();
	}
	
	String course_id_new = request.getParameter("course_id_new");
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
		
		if (!un.updateCourse(oldCourse, course, message)) {
			out.println("<script type=\"text/javascript\">");
			out.println("alert(\"修改失败，请稍后重试，将返回到先前页面。错误信息：" + message + "\")");
	 		out.println("window.opener.location.reload();");
	 		out.println("window.close();");
	 		out.println("</script>");
	 		return;
		}
		session.setAttribute("message", ""); // 成功则清除错误信息
		out.println("<script type=\"text/javascript\">");
		out.println("alert(\"修改后 ID：" + course.id + " "
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
<title>修改课程信息</title>
<link rel="stylesheet" href="../css/form.css" />
</head>
<body>
	<form action="modify_course.jsp">
		<input name="course_id" value="<%= oldCourse.id%>" style="display: none"/>
		<table>
			<caption>修改课程</caption>
			<tbody>
				<tr>
					<td>课程号</td>
					<td><input type="text" placeholder="课程号" name="course_id_new" value="<%= oldCourse.id%>"/></td>
				</tr>
				<tr>
					<td>课程名</td>
					<td><input type="text" placeholder="课程名" name="course_name" value="<%= oldCourse.name%>"/></td>
				</tr>
				<tr>
					<td>必修课</td>
					<td>
						<label>
							<%
								String bCheck = "";
								if (oldCourse.isMajor)
									bCheck = "checked=\"checked\"";
							%>
                            <input type="radio" name="course_major" <%= bCheck %> value="是">是
                        </label>
                        <label>
                        	<%
								bCheck = "";
                        		if (!oldCourse.isMajor) bCheck = "checked=\"checked\"";
                        	%>
                            <input type="radio" name="course_major" <%= bCheck %> value="否">否
                        </label>
					</td>
				</tr>
				<tr><td colspan="2" style="text-align: center;"><input type="submit" value="提交"/></td></tr>
				<tr>
					<td colspan="2">
					<%
						if (oldCourse.isMajor) {
					%>
						<table>
							<caption>班级课程表</caption>
							<tr>
								<td>班级</td>
								<td>老师</td>
								<td><input type="button" value="添加班级课程" onclick="window.open('cc_add.jsp?course_id=<%= oldCourse.id %>')"/></td>
							</tr>
						<% 
							StringBuffer message = new StringBuffer();
							List<Map<Classes, Teacher>> TCM = oldCourse.getClassesMapTeacher(message);
							for (Map<Classes, Teacher> cmt : TCM) {
								for (Map.Entry<Classes, Teacher> entry : cmt.entrySet()) {
						%>
							<tr>
								<td><%= entry.getKey().id %></td>
								<td><%= entry.getValue().name %></td>
								<td><input type="button" value="删除班级课程" onclick="window.open('cc_delete.jsp?course_id=<%= oldCourse.id%>&classes_id=<%= entry.getKey().id%>')"/></td>
							</tr>
						<%
								}
							}
						%>
						</table>
					<%
						} else {
					%>
						<table>
							<caption>选课成绩表</caption>
							<tr>
								<td>学生学号</td>
								<td>学生姓名</td>
								<td>成绩</td>
								<td><input type="button" value="添加选课信息" onclick="window.open('sc_add.jsp?course_id=<%= oldCourse.id %>')"/></td>
							</tr>
						<% 
							String sql = "select Student.SNo, Student.SName, SC.Grade " + 
										"from SC,Course,Student where " + 
										"Student.SNo = SC.SNo and SC.CNo = Course.CNo and " +
										"Course.CNo = " + oldCourse.id; 
							ConnectDB mysql = new ConnectDB();
							ResultSet rs = mysql.executeQuery(sql);
							int choose_number = 0;
							int gradeSum = 0;
							while (rs.next()) {
								long id = rs.getLong("SNo");
								String name = rs.getString("SName");
								float grade = rs.getFloat("Grade");
								
								choose_number++; gradeSum += grade;
						%>
							<tr>
								<td><%= id %></td>
								<td><%= name %></td>
								<td><%= grade %></td>
								<td><input type="button" value="删除学生选课" onclick="window.open('sc_modify.jsp?student_id=<%= id %>&course_id=<%= oldCourse.id %>')"/></td>
							</tr>
						<%
							}
							mysql.close();
						%>
							<tr></tr>
							<tr><td colspan="4">共有<%= choose_number %>个学生选择该课程，平均分为：<%= gradeSum/choose_number %></td></tr>
						</table>
					<%
						}
					%>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
</html>