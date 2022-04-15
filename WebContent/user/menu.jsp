<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head></head>
	<body>
		<h4>信息管理</h4>
		<ul>
			<!-- 学生信息所有的学生信息 -->
			<li><a data-src='data/student_info.jsp?page=1' onclick='loadData(this)'>学生信息管理</a></li>
			<!-- 所有的教师信息 -->
			<li><a data-src='data/teacher_info.jsp?page=1' onclick='loadData(this)'>教师信息管理</a></li>
			<!-- 所有的课程信息 -->
			<li><a data-src='data/course_info.jsp?page=1' onclick='loadData(this)'>课程信息管理</a></li>
			<!-- 所有的班级信息 -->
			<li><a data-src='data/classes_info.jsp?page=1' onclick='loadData(this)'>班级信息管理</a></li>
			<!-- 所有专业信息 -->
			<li><a data-src='data/speciality_info.jsp?page=1' onclick='loadData(this)'>专业信息管理</a></li>
			<!-- 所有系部信息 -->
			<li><a data-src='data/department_info.jsp?page=1' onclick='loadData(this)'>系部信息管理</a></li>
		</ul>
		<h4 style="margin-top: 5px;">数据报表</h4>
		<ul>
			<!-- 获取学生信息统计（包含学生性别、年龄、成绩统计） -->
			<li><a data-src='data/student/student_report.jsp' onclick='loadData(this)'>学生信息报表</a></li>
			<!-- 获取教师的课程表、所教授的班级统计 -->
			<li><a data-src='data/teacher/teacher_report.jsp' onclick='loadData(this)'>教师信息报表</a></li>
			<!-- 获取课程信息（包含选课人数等） -->
			<li><a data-src='data/course/course_report.jsp' onclick='loadData(this)'>课程信息报表</a></li>
			<!-- 获取专业、系部学生人数 -->
			<li><a data-src='data/department/department_report.jsp' onclick='loadData(this)'>学校信息报表</a></li>
		</ul>
	</body>
</html>

