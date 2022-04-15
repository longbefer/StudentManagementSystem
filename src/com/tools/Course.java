package com.tools;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dao.mysql.ConnectDB;

/**
 * 课程信息：包含课程名，课程号，是否主修
 * 
 * @author _
 * 
 */
public class Course {
	public long id;
	public String name;
	public boolean isMajor;
	// public List<Teacher> teachers;
	// public List<Classes> classes;
	// public long previous;
	public float grade;

	public Course(long id) {
		this.id = id;
	}

	/**
	 * 通过ResultSet设置课程信息，注意必须是直接读取课程表
	 * 
	 * @param rs rs集合
	 * @throws SQLException 返回读取错误的信息
	 */
	public Course(ResultSet rs) throws SQLException {
		this.id = rs.getLong("CNo");
		this.name = rs.getString("CName");
		this.isMajor = rs.getBoolean("CMajor");
		// this.previous = 0;
		this.grade = 0;
		// teachers = new ArrayList<Teacher>();
		// classes = new ArrayList<Classes>();
	}

	/**
	 * 设置课程的信息，通过调用数据库获取课程类中所有成员的信息
	 */
	public void setCourseInfo() {
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Course where Course.CNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				this.id = rs.getLong("CNo");
				this.name = rs.getString("CName");
				this.isMajor = rs.getBoolean("CMajor");
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("设置课程信息失败" + e.getMessage());
		}
	}

	/**
	 * 返回授课的老师，指当前课程的所有授课老师
	 * 
	 * @return 返回授课老师列表
	 */
	public List<Teacher> getCourseTeachers() {
		List<Teacher> teachers = new ArrayList<Teacher>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select distinct CC.TeacherNo from CC where CC.CourseNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Teacher teacher = new Teacher(rs.getLong("TeacherNo"));
				teachers.add(teacher);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回课程老师信息失败" + e.getMessage());
		}
		return teachers;
	}

	/**
	 * 获取班级课表，代替course中的获取，即教授该科的班级
	 * 
	 * @return 返回班级
	 */
	public List<Classes> getCourseClasses() {
		List<Classes> classes = new ArrayList<Classes>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from CC where CC.CourseNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Classes cls = new Classes(rs.getLong("ClassesNo"));
				classes.add(cls);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回课程班级信息失败" + e.getMessage());
		}
		return classes;
	}

	/**
	 * 更新课程
	 * 
	 * @param course  更新所有信息，将更新程该课程信息
	 * @param message 返回错误信息
	 * @return 更新成功返回true
	 */
	public boolean updateCourse(Course course, StringBuffer message) {
		boolean bPassed = true;
		try {
			bPassed &= updateCourseName(course.name, message);
			bPassed &= updateCourseMajor(course.isMajor, message);
			if (course.id != this.id)
				bPassed &= updateCourseID(course.id, message);
			if (!bPassed) {
				message.append("更新课程信息失败");
			}
		} catch (Exception e) {
			message.append("执行过程中出现错误\n" + e.getMessage());
		}
		return bPassed;
	}

	/**
	 * 更新课程名
	 * 
	 * @param name    课程名
	 * @param message 错误信息
	 * @return 返回true或false 成功-失败
	 */
	public boolean updateCourseName(String name, StringBuffer message) {
		String sqlString = "update Course set Course.CName = '" + name + "' where Course.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新课程姓名可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新课程姓名失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}

	/**
	 * 更新课程id
	 * 
	 * @param id      新的课程id
	 * @param message 错误信息
	 * @return 返回true或false
	 */
	public boolean updateCourseID(long id, StringBuffer message) {
		String sqlString = "update Course set Course.CNo = " + id + " where Course.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新课程ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新课程ID失败，请检查是否存储相同ID\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}

	/**
	 * 更新课程主修
	 * 
	 * @param bMajor  是否主修
	 * @param message 错误信息
	 * @return 更新成功返回true否则返回false
	 */
	public boolean updateCourseMajor(boolean bMajor, StringBuffer message) {
		String sqlString = "update Course set Course.CMajor = " + bMajor + " where Course.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新课程姓名可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新课程姓名失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}

	/**
	 * 设置班级和老师的对应表，班级可以拥有多门课程，每门课程可有多个老师
	 * 
	 * @param message 返回错误信息
	 * @return 返回 班级-老师 对应的集合 使用Map<value, key> 代替C++中的Pair<>
	 */
	public List<Map<Classes, Teacher>> getClassesMapTeacher(StringBuffer message) {
		List<Map<Classes, Teacher>> CTMaps = new ArrayList<Map<Classes, Teacher>>();
		String sqlString = "select * from CC where CC.CourseNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Classes cls = new Classes(rs.getLong("ClassesNo"));
				Teacher cla = new Teacher(rs.getLong("TeacherNo"));
				cls.setClassesInfo();
				cla.setTeacherInfo();
				Map<Classes, Teacher> ctm = new HashMap<Classes, Teacher>();
				ctm.put(cls, cla);
				CTMaps.add(ctm);
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新课程姓名失败，请检查\n" + e.getMessage());
			mysql.close();
			return null;
		}

		return CTMaps;
	}

}
