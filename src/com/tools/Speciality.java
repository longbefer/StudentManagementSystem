package com.tools;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.mysql.ConnectDB;

public class Speciality {
	public long id;
	public String name;
	public Department department;
	public Teacher teacher;
	
	public Speciality(ResultSet rs) throws Exception {
		this.id = rs.getLong("SNo");
		this.name = rs.getString("SName");
		this.department = new Department(rs.getLong("DNo"));
		this.teacher = new Teacher(rs.getLong("TNo"));
	}
	
	public Speciality(long id) {
		this.id = id;
		this.teacher = null;
		this.department = null;
		this.name = "";
	}
	// 设置部门
	/**
	 * 设置部门信息
	 */
	public void setSpecialityInfo() {
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Speciality where Speciality.SNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				this.name = rs.getString("SName");
				if (this.department == null)
					this.department = new Department(rs.getLong("DNo"));
				else this.department.id = rs.getLong("DNo");
				if (this.teacher == null)
					this.teacher = new Teacher(rs.getLong("TNo"));
				else this.teacher.id = rs.getLong("TNo");
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("设置专业信息失败" + e.getMessage());
		}
	}
	// 获取学生
	/**
	 * 返回学生信息
	 * @return 返回学生信息
	 */
	public List<Student> getStudents() {
		List<Student> students = new ArrayList<Student>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select Student.SNo, Student.SName from"
					+ "Student, Speciality, Classes where "
					+ "Student.CNo = Classes.CNo and Classes.SNo = Speciality.SNo "
					+ "and Speciality.SNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				Student student = new Student(rs.getLong("SNo"));
				student.name = rs.getString("SName");
				students.add(student);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回专业学生失败： " + e.getMessage());
		}
		return students;
	}
	// 获取班级学生数量
	/**
	 * 返回学生数量
	 * @return 返回学生数量
	 */
	public int getStudentNumber() {
		ConnectDB mysql = new ConnectDB();
		int value = 0;
		try {
			ResultSet rs = mysql.executeQuery("select count(*) from "
					+ "Student,Speciality,Classes where "
					+ "Student.CNo = Classes.CNo and "
					+ "Classes.SNo = Speciality.SNo and Speciality.SNo = " + this.id);
			if (rs != null && rs.next()) 
				value = rs.getInt(1);
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取学生数量出错" + e.getMessage());
		}
		return value;
	}
	// 更新专业
	/**
	 * 更新专业
	 * @param newC 新的专业
	 * @param message 错误信息
	 * @return 返回是否更新成功
	 */
	public boolean updateSpeciality(Speciality newC, StringBuffer message) {
		boolean bPassed = true;
		try {
			bPassed &= updateSpecialityName(newC.name, message);
			bPassed &= updateSpecialityDepartment(newC.department, message);
			bPassed &= updateSpecialityTeacher(newC.teacher, message);
			bPassed &= updateSpecialityID(newC.id, message);
		} catch (Exception e) {
			System.err.println(e.getMessage());
			message.append("发生错误在专业更新时");
		}
		return bPassed;
	}
	// 更新专业ID
	/**
	 * 更新专业ID
	 * @param specID 新的id
	 * @param message 错误信息
	 * @return 返回true或false表示更新成功
	 */
	public boolean updateSpecialityID(long specID, StringBuffer message) {
		String sqlString = "update Speciality set Speciality.SNo = " + specID
				+ " where Speciality.SNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新专业ID可能失败，请稍后确保该专业不存在老师或班级及其学生");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("专业更新失败： " + e.getMessage());
			message.append("更新专业ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	// 更新专业名称
	/**
	 * 更新专业名称
	 * @param specName 专业名称
	 * @param message 错误信息
	 * @return 返回更新成功
	 */
	public boolean updateSpecialityName(String specName, StringBuffer message) {
		String sqlString = "update Speciality set Speciality.SName = '" + specName
				+ "' where Speciality.SNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新专业名称可能失败，请稍后确保该专业不存在老师或班级及其学生");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("专业更新失败： " + e.getMessage());
			message.append("更新专业名称失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	// 更新专业系
	/**
	 * 更新专业系
	 * @param department 新的系
	 * @param message 错误信息
	 * @return 更新成功
	 */
	public boolean updateSpecialityDepartment(Department department, StringBuffer message) {
		String sqlString = "update Speciality set Speciality.DNo = " + department.id
				+ " where Speciality.SNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新专业系部ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("专业更新失败： " + e.getMessage());
			message.append("更新专业系部ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	// 更新专业老师
	/**
	 * 更新专业老师
	 * @param teacher 新的老师
	 * @param message 错误信息
	 * @return 返回更新成功与否
	 */
	public boolean updateSpecialityTeacher(Teacher teacher, StringBuffer message) {
		String sqlString = "update Speciality set Speciality.TNo = " + teacher.id
				+ " where Speciality.SNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新专业教师ID可能失败。");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("专业更新失败： " + e.getMessage());
			message.append("更新专业ID失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
}
