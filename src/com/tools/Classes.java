package com.tools;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dao.mysql.ConnectDB;
/**
 * 班级类：对班级进行增删改查
 * @author _
 * 
 */
public class Classes {
	public long id;
	// public int number; // 学生人数
	public Speciality speciality; // 所属专业
	public Department department; // 所属系部
	public Teacher teacher; // 班主任
	
	
	public Classes(long id) {
		this.id = id;
		// number = 0;
		speciality = null;
		department = null;
		teacher = null;
	}
	
	public Classes(ResultSet rs) throws SQLException {
		this.id = rs.getLong("CNo");
		this.speciality = new Speciality(rs.getLong("SNo"));
		this.teacher = new Teacher(rs.getLong("TNo"));
		department = null;
		// number = 0;
	}
	/**
	 * 获取班级的所有学生
	 * @return 返回学生列表
	 */
	public List<Student> getStudents() {
		List<Student> students = new ArrayList<Student>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Student where Student.CNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Student student = new Student(rs);
				students.add(student);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			return null;
		}
		return students;
	}
	/**
	 * 返回班级学生数量
	 * @return 返回班级学生数量
	 */
	public int studentCount() {
		ConnectDB mysql = new ConnectDB();
		int number = 0;
		try {
			String sqlString = "select count(*) from Student where Student.CNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) 
				number = rs.getInt(1);
			mysql.close();
		} catch (Exception e) {
			mysql.close();
		}
		return number;
	}
	
	public void setClassesInfo() {
		// 判断Teacher和Speciality非空
		ConnectDB mysql = new ConnectDB();
		try {
			// 取得班主任的信息
			String sqlString = "select * from Classes where Classes.CNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if(rs != null && rs.next()) {
				if (teacher == null)
					this.teacher = new Teacher(rs.getLong("TNo"));
				else this.teacher.id = rs.getLong("TNo");
				teacher.setTeacherInfo();
				// 获取该班级的专业
				if (this.speciality == null)
					this.speciality = new Speciality(rs.getLong("SNo"));
				else this.speciality.id = rs.getLong("SNo");
				this.speciality.setSpecialityInfo();
			}
			mysql.close();

			// 获取系部的信息
			sqlString = "select * from Speciality where Speciality.SNo = " + this.speciality.id;
			rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				if (this.department == null) 
					this.department = new Department(rs.getLong("DNo"));
				else this.department.id = rs.getLong("DNo");
				this.department.setDepartmentInfo();
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回课程老师信息失败" + e.getMessage());
		}
	}
	/**
	 * get the course from classes
	 * @return 返回班级课程表
	 */
	public List<Course> getClassesCourses() {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from CC where CC.ClassesNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Course cs = new Course(rs.getLong("CourseNo"));
				courses.add(cs);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回班级课程信息失败" + e.getMessage());
		}
		return courses;
	}
	/**
	 * 删除班级
	 * @param message 返回错误信息
	 * @return true or false
	 */
	public boolean deleteClasses(StringBuffer message) {
		// 由于设置了级联删除，故可以直接删除
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "delete from Classes where Classes.CNo = " + this.id;
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("删除失败，请重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("删除失败，错误" + e.getMessage());
			return false;
		}
		return true;
	}
	/**
	 * 将当前的班级信息更改为newClasses内的信息
	 * @param newClasses 新的班级信息
	 * @param message 返回错误消息
	 * @return false或true
	 */
	public boolean updateClasses(Classes newClasses, StringBuffer message) {
		boolean bPassed = true;
		try {
			bPassed &= updateClassesTeacher(newClasses.teacher, message);
			bPassed &= updateClassesSpeciality(newClasses.speciality, message);
			bPassed &= updateClassesID(newClasses.id, message);
		} catch (Exception e) {
			message.append("更新失败，请重试");
		}
		return bPassed;
	}
	
	public boolean updateClassesID(long id, StringBuffer message) {
		String sqlString = "update Classes set Classes.CNo = " + id
				+ " where Classes.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新班级ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新班级ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	/**
	 * 更新班级专业
	 * @param speciality 专业
	 * @param message 错误信息
	 * @return 返回true表示更新成功
	 */
	public boolean updateClassesSpeciality(Speciality speciality, StringBuffer message) {
		String sqlString = "update Classes set Classes.SNo = " + speciality.id
				+ " where Classes.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新班级专业ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新班级ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	/**
	 * 更新数据库中的班级的班主任
	 * @param tec 修改的班主任信息
	 * @param message 错误消息
	 * @return 更新成功返回true否则返回false
	 */
	public boolean updateClassesTeacher(Teacher tec, StringBuffer message) {
		String sqlString = "update Classes set Classes.TNo = " + tec.id
				+ " where Classes.CNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新班级教师ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新班级教师ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	/**
	 * 返回班级所教授的课程和对应的老师
	 * @param message 错误信息
	 * @return 返回班级对应表
	 */
	public List<Map<Course, Teacher>> getCourseMapTeacher(StringBuffer message) {
		List<Map<Course, Teacher>> CTMaps = new ArrayList<Map<Course, Teacher>>();
		String sqlString = "select * from CC where CC.ClassesNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Course cos = new Course(rs.getLong("CourseNo"));
				Teacher cla = new Teacher(rs.getLong("TeacherNo"));
				cos.setCourseInfo(); 
				cla.setTeacherInfo();
				Map<Course, Teacher> ctm = new HashMap<Course, Teacher>();
				ctm.put(cos, cla);
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
