package com.tools;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dao.mysql.ConnectDB;

/**
 * 学生类，用于保存学生信息
 * @author NumberFour
 *
 */
public class Student {
	public long id;
	public String name;
	public String sex;
	public int age;
	public Classes classes;
	public Speciality speciality;
	public String address;
	
	/**
	 * 构造函数，必须设定学生id
	 * @param id 学生id
	 */
	public Student(long id) {
		this.id = id;
		this.name = "";
		this.sex = "";
		this.age = 0;
		this.classes = null;
		this.speciality = null;
		this.address = "";
	}
	
	/**
	 * 用于设置学生信息，通过ResultSet来设置，注意必须具有学生的所有信息
	 * @param rs 结果集合
	 * @throws SQLException 若结果集合为空或其他情况抛出异常
	 */
	public Student(ResultSet rs) throws SQLException {
		this.id = rs.getLong("SNo");
		this.name = rs.getString("SName");
		this.sex = rs.getString("SSex");
		this.age = rs.getInt("SAge");
		this.classes = new Classes(rs.getInt("CNo"));
		this.speciality = null;
		this.address = "";
	}
	
	/**
	 * 返回当前学生的课程的成绩，需要传递课程信息
	 * @param course 课程信息
	 * @return 课程成绩
	 */
	public float getGrade(Course course) {
		float grade = 0.0f;
		String gradeQueue = "select SC.Grade "
				+ "from Student, Course, SC"
				+ "where Course.CNo = " + course.id
				+ "and Course.CNo = SC.CNo"
				+ "and SC.SNo = Student.SNo"
				+ "and Student.SNo = " + this.id;
		// String sql = String.format(gradeQueue, course.id, this.id);
		ConnectDB mysql = new ConnectDB();
		try {
			ResultSet rs = mysql.executeQuery(gradeQueue);
			if (rs.next()) grade = rs.getFloat("Grade");
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			e.printStackTrace();
			System.err.println("获取学生成绩失败\n" + e.getMessage());
		}
		return grade;
	}
	
	/**
	 * 设置当前学生信息，必须设置过该学生的id（若有修改，可调用该函数更新）
	 */
	public void setStudentInfo() {
		// 将学生信息赋值给当前学生
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select Student.SName 学生名, "
					+ "Student.SSex 性别, Student.SAge 年龄, "
					+ "Speciality.SNo 专业号, Classes.CNo 班级号 "
					+ "from Student,Classes,Speciality "
					+ "where Speciality.SNo = Classes.SNo "
					+ "and Classes.CNo = Student.CNo "
					+ "and Student.SNo = " + this.id;
			// System.out.println(sqlString);
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				this.name = rs.getString("学生名");
				this.sex = rs.getString("性别");
				this.age = rs.getInt("年龄");
				if (classes == null)
					this.classes = new Classes(rs.getInt("班级号"));
				else this.classes.id = rs.getLong("班级号");
				if (this.speciality == null) 
					this.speciality = new Speciality(rs.getLong("专业号"));
				else this.speciality.id = rs.getLong("专业号");
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取学生信息失败\n" + e.getMessage());
		}
	}
	
	/**
	 * 获取学生专业
	 * @return 学生专业名称
	 */
	public Speciality getSpeciality() {
		setStudentInfo();
		this.speciality.setSpecialityInfo();
		return this.speciality;
	}
	
	/**
	 * 获取学生的专业ID
	 * @return 返回学生的专业ID
	 */
	public long getSpecialityID() {
		ConnectDB mysql = new ConnectDB();
		long specialityID = 0;
		try {
			String sqlString = "select Speciality.SNo "
					+ "from Speciality,Classes,Student "
					+ "where Speciality.SNo = Classes.SNo and "
					+ "Classes.CNo = Student.CNo and "
					+ "Student.SNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) specialityID = rs.getLong("SNo");
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询学生专业id时出错：" + this.id + "\n" + e.getMessage());
		}
		return specialityID;
	}
	
	/**
	 * 获取学生班级id
	 * @return 学生班级id
	 */
	public Classes getClasses() {
		setStudentInfo();
		this.classes.setClassesInfo();
		return this.classes;
	}
	
	/**
	 * 获取学生的必修课
	 * @return 返回学生的必修课，若出错返回null 
	 */
	public List<Course> getMajorCourses() {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			String queueCourse = "select Course.CNo, Course.CName, Course.CMajor "
					+ "from Student, Course, CC "
					+ "where Course.CNo = CC.CourseNo and "
					+ "	  CC.ClassesNo = Student.CNo and "
					+ "	  Student.SNo = " + this.id;
			ResultSet rs = mysql.executeQuery(queueCourse);
			while(rs.next()) {
				Course course = new Course(rs);
				courses.add(course);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询学生必修课时出错: " + this.id + "\n" + e.getMessage());
			return null;
		}
		return courses;
	}
	
	/**
	 * 获取学生的选修课程
	 * @return 返回学生的选修课，出错返回null
	 */
	public List<Course> getElectiveCourses() {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 选择学生的选修课程表
			String queueCourse = "select Course.CNo, Course.CName, Course.CMajor, SC.Grade "
					+ "from Student, Course, SC "
					+ "where Course.CNo = SC.CNo and "
					+ "	  SC.SNo = Student.SNo and "
					+ "	  Student.SNo = " + this.id;
			ResultSet rs = mysql.executeQuery(queueCourse);
			while (rs.next()) {
				Course course = new Course(rs);
				course.grade = rs.getFloat("Grade");
				courses.add(course);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询学生选修课时出错：" + this.id + "\n" + e.getMessage());
			return null;
		}
		return courses;
	}
	
	/**
	 * 获取学生的选修课和必修课课程
	 * @return 返回学生的选修课和必修课
	 */
	public List<Course> getCourses() {
		List<Course> courses = new ArrayList<Course>();
		courses.addAll(getMajorCourses());   // 添加必修课
		courses.addAll(getElectiveCourses()); // 添加选修课
		return courses;
	}
	
}
