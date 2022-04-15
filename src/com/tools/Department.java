package com.tools;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.dao.mysql.ConnectDB;

public class Department {
	public long id;
	public String name; 
	// public List<Long> specialities;
	
	public Department(long id) {
		this.id = id;
		this.name = "";
		// specialities = new ArrayList<Long>();
	}
	
	public Department(String name) throws Exception {
		this.name = name;
		// this.specialities = new ArrayList<Long>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "select DNo from Department where Department.DName = '" + this.name + "'";
			ResultSet sr = mysql.executeQuery(sql);
			if (sr.next()) this.id = sr.getLong("DNo");
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("该name非法：" + this.name + e.getMessage());
			throw e;
		}
	}
	
	public Department(ResultSet rs) throws SQLException {
		this.id = rs.getLong("DNo");
		this.name = rs.getString("DName");
		// this.specialities = new ArrayList<Long>();
	}
	
	public void setDepartmentInfo() {
		// 通过读取数据库访问到该部门的specialties信息和teacher信息
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "select Department.DName from Department where Department.DNo = " + this.id;
			ResultSet sr = mysql.executeQuery(sql);
			if (sr != null && sr.next()) this.name = sr.getString("DName");
			mysql.close();
		} catch (Exception e) {
			System.err.println("设置部门信息出错" + e.getMessage());
			mysql.close();
		}
	}
	
	/**
	 * 返回该系的所有学生，包含不同专业的学生
	 * @return 返回该系的所有学生
	 */
	public List<Student> getStudents() {
		List<Student> students = new ArrayList<Student>();

		return students;
	}
	
	public int getStudentsCount() {
		int value = 0;
		ConnectDB mysqlConnectDB = new ConnectDB();
		try {
			String sql = "select count(*) from Department,Speciality,Classes,Student "
					+ "where Student.CNo = Classes.CNo and "
					+ "Classes.SNo = Speciality.SNo and "
					+ "Speciality.DNo = Department.DNo and "
					+ "Department.DNo = " + this.id;
			ResultSet rs = mysqlConnectDB.executeQuery(sql);
			if (rs != null && rs.next())
				value = rs.getInt(1);
			mysqlConnectDB.close();
		} catch (Exception e) {
			mysqlConnectDB.close();
			System.err.println(e.getMessage());
		}
		return value;
	}
	
	public int getTeachersCount() {
		int value = 0;
		String sqlString = "select count(*) from Teacher where Teacher.DNo = " + this.id;
		ConnectDB mysqlConnectDB = new ConnectDB();
		try {
			ResultSet rs = mysqlConnectDB.executeQuery(sqlString);
			if (rs != null && rs.next()) 
				value = rs.getInt(1);
			mysqlConnectDB.close();
		} catch (Exception e) {
			mysqlConnectDB.close();
			System.err.println("获取老师数量出错" + e.getMessage());
		}
		return value;
	}
	
	/**
	 * 获取所有专业的名称
	 * @return 返回该系所有的专业名称
	 */
	public List<Speciality> getSpecialities() {
		List<Speciality> specialities = new ArrayList<Speciality>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Speciality where Speciality.DNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Speciality spec = new Speciality(rs);
				specialities.add(spec);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回部门专业信息失败" + e.getMessage());
		}
		return specialities;
	}
	
	public List<Teacher> getTeachers() {
		List<Teacher> teachers = new ArrayList<Teacher>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Teacher where Teacher.DNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Teacher te = new Teacher(rs);
				teachers.add(te);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("返回班级课程信息失败" + e.getMessage());
		}
		return teachers;
	}
	/**
	 * 更新部门
	 * @param newDepartment 新的部门信息
	 * @param message 返回错误信息
	 * @return false or true
	 */
	public boolean updateDepartment(Department newDepartment, StringBuffer message) {
		boolean bPassed = true;
		try {
			bPassed &= updateDepartmentName(newDepartment.name, message);
			bPassed &= updateDepartmentID(newDepartment, message);
			if (!bPassed) {
				message.append("更新系部发生错误，请稍后重试");
			}
		} catch (Exception e) {
			message.append("严重错误" + e.getMessage());
		}
		return bPassed;
	}
	
	public boolean updateDepartmentID(Department department, StringBuffer message) {
		String sqlString = "update Department set Department.DNo = " + department.id
				+ " where Department.DNo = " + this.id;
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
	
	public boolean updateDepartmentName(String name, StringBuffer message) {
		String sqlString = "update Department set Department.DName = '" + name
				+ "' where Department.DNo = " + this.id;
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
	
}
