package com.tools;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.dao.mysql.ConnectDB;
/**
 * 教师类
 * @author NumberFour
 *
 */
public class Teacher {
	public long id;
	public String name;
	public Department department;
	
	/**
	 * 设置老师id，需要调用setTeacherInfo()从数据库中获取老师全部信息
	 * @param id 设置老师必须先获其id
	 */
	public Teacher(long id) {
		this.id = id;
		name = "";
		department = null;
	}
	
	/**
	 * 通过resultset设置老师信息
	 * @param rs 数据库返回的信息
	 * @throws SQLException 若无法读取正确的信息返回报错
	 */
	public Teacher(ResultSet rs) throws SQLException {
		this.id = rs.getLong("TNo");
		this.name = rs.getString("TName");
		this.department = new Department(rs.getLong("DNo"));
	}
	
	/**
	 * 通过查询数据库获取老师的所有信息，使用于更新数据库时需要重新获取老师的数据
	 */
	public void setTeacherInfo() {
		/**
		 * 执行这里时一直出错，排查得到建立的连接次数太多，需要修改mysql软件下
		 * my.ini文件中的 max_connections 提供最大的连接数量
		 */
		ConnectDB mysql = new ConnectDB();
		try {
			// 查询老师所在的部门
			String sqlString = "select Teacher.DNo from Teacher "
					+ "where Teacher.TNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs.next()) 
				if (this.department == null) 
					this.department = new Department(rs.getLong("DNo"));
				else this.department.id = rs.getLong("DNo");
			mysql.close();
			// 调用department的函数设置改内容
			this.department.setDepartmentInfo();
			// 查询老师姓名
			sqlString = "select TName from Teacher where TNo = " + this.id;
			rs = mysql.executeQuery(sqlString);
			if (rs.next()) this.name = rs.getString("TName");
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询教师信息时发生错误" + this.id + "\n" + e.getMessage());
		}
	}
	
	/**
	 * 获取教师教授的课程
	 * @return 返回老师教授的课程
	 */
	public List<Course> getTeacherCourses() {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 判断是否老师有课程
			String sqlString = "select distinct Course.CNo,Course.CName "
					+ "from CC, Course "
					+ "where Course.CNo = CC.CourseNo and "
					+ "CC.TeacherNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Course course = new Course(rs.getLong("CNo"));
				course.name = rs.getString("CName");
				courses.add(course);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询教师课程信息时发生错误" + this.id + "\n" + e.getMessage());
		}
		return courses;
	}
	
	/**
	 * 返回教师所带领的班级
	 * @return 作为那个班级的班主任
	 */
	public List<Classes> getTeacherClasses() {
		List<Classes> classes = new ArrayList<Classes>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 首先查看该老师是否有带班级
			String sqlString = "select Classes.CNo from classes "
					+ "where classes.TNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while (rs.next()) {
				classes.add(new Classes(rs.getLong("CNo")));
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询教师班级信息时发生错误" + this.id + "\n" + e.getMessage());
		}
		return classes;
	}
	
	/**
	 * 返回教师所带领的专业
	 * @return 返回教师所带领的专业
	 */
	public List<Speciality> getTeacherSpecialities() {
		List<Speciality> specialities = new ArrayList<Speciality>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 其次判断该老师是否带领专业
			String sqlString = "select Speciality.SNo from speciality "
					+ "where speciality.TNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				specialities.add(new Speciality(rs.getLong("SNo")));
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("查询教师专业信息时发生错误" + this.id + "\n" + e.getMessage());
		}
		return specialities;
	}
	
	/**
	 * 删除老师信息，成功返回true失败返回false，传递的message参数可知错误信息
	 * @param message 返回删除失败的消息，对应的外键依赖的表在:（英文冒号后）可通过字符spilit获取到该表
	 * @return 成功返回true，失败返回false
	 */
	public boolean deleteTeacher(StringBuffer message) {
		// 删除老师，注意需要必须要先设置班级的老师，专业的老师才能删除该老师
		// 由于设置级联时无法设置老师的级联删除，故只能先提示了
		
		// 建立数据库连接
		ConnectDB mysql = new ConnectDB();
		try {
			// 查询班级是否存在该老师
			String sqlString = "select * from Classes where Classes.TNo = " + this.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				message.append("若删除老师，请更改该老师所带领的班级:" 
							+ rs.getLong("CNo"));
				mysql.close();
				return false;
			}
			mysql.close();
			
			// 查询专业是否存在该老师
			sqlString = "select * from Speciality where Speciality.TNo = " + this.id;
			rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				message.append("若删除老师，请更改该老师管理的专业:" 
							+ rs.getLong("SNo") + " " 
							+ rs.getString("SName"));
				mysql.close();
				return false;
			}
			mysql.close();
			
			// 查询班级课程表是否存在该老师
			sqlString = "select * from CC where CC.TeacherNo = " + this.id;
			rs = mysql.executeQuery(sqlString);
			if (rs != null && rs.next()) {
				message.append("若删除老师，请更改该老师所教授的课程:" 
							+ rs.getLong("CourseNo"));
				mysql.close();
				return false;
			}
			mysql.close();
			
			// 该老师无外键依赖
			sqlString = "delete from Teacher where Teacher.TNo = " + this.id;
			if (mysql.executeUpdate(sqlString) == 0) {
				// 删除失败
				message.append("删除失败，请稍后重试。");
				mysql.close();
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("删除教师信息失败，请稍后重试");
			System.err.println("删除老师" + this.id + "信息失败，请稍后重试\n" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 传递需要更改的教师信息，将老师信息更改为传递的教师信息
	 * @param teacher 教师信息
	 * @param message 返回错误信息
	 * @return 更改成功返回true否则返回false
	 */
	public boolean updateTeacherInfo(Teacher teacher, StringBuffer message) {
		// 通过取得teacher的内容更改教师信息
		// 首先先给当前Teacher赋值
		boolean bPassed = true;
		
		// 访问数据库更改教师信息
		try {
			// 更新教师姓名
			if (this.name != teacher.name) {
				bPassed &= updateTeacherName(teacher.name, message);
			}
			// 更新教师系部
			if (this.department == null || this.department.name != teacher.department.name) {
				bPassed &= updateTeacherDepartment(teacher.department, message);
			}
			// 是否更新ID
			if (this.id != teacher.id) { 
				bPassed &= updateTeacherID(teacher.id, message);
			}
			if (!bPassed) {
				System.err.println("在更新教师信息出现问题\n");
				message.append("更新教师出错:" + this.id);
			}
		} catch (Exception e) {
			System.err.println("更新教师出现问题" + e.getMessage());
			message.append("错误：" + e.getMessage());
		}
		return bPassed;
	}
	
	/**
	 * 更新教师ID，若不存在相同教师ID将成功修改，返回true，否则返回false
	 * @param oldID 原老师id
	 * @param newID 现老师id
	 * @param message 若出错返回错误信息
	 * @return 成功修改返回true失败返回false
	 */
	public boolean updateTeacherID(long newID, StringBuffer message) {
		String sqlString = "update Teacher set Teacher.TNo = " + newID
				+ " where Teacher.TNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新老师ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新老师失败，可能存在相同ID，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 更新教师姓名，需要传递一个新的姓名，将连接数据库更改姓名
	 * @param name 更改教师的姓名
	 * @param message 返回错误的信息
	 * @return 修改成功返回true否则返回false
	 */
	public boolean updateTeacherName(String name, StringBuffer message) {
		String sqlString = "update Teacher set Teacher.TName = '" + name
				+ "' where Teacher.TNo = " + this.id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新老师姓名可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("更新老师姓名失败" + e.getMessage());
			message.append("更新老师失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 更新老师所在部门，需要传递部门的名称
	 * @param name 部门名称
	 * @param message 返回错误信息
	 * @return 更新成功为true否则为false
	 */
	public boolean updateTeacherDepartment(String name, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			long newID = 0;
			ResultSet rs = mysql.executeQuery("select DNo from Department where Department.DName = '" + name + "'");
			if (rs != null && rs.next()) newID = rs.getLong("DNo");
			mysql.close();
			
			String modifyString = "update Teacher set Teacher.DNo = " +  newID
					+ " where Teacher.TNo = " + this.id; 
			int value = mysql.executeUpdate(modifyString);
			if (value == 0) {
				mysql.close();
				message.append("更新老师部门ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("更新老师部门失败"+ e.getMessage());
			message.append("更新老师部门失败，可能不存在该部门，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 更新老师的部门id，需要传递部门id
	 * @param id 部门id，需要在部门表中可以找到
	 * @param message 返回错误信息
	 * @return 若更改成功返回true，否则返回false
	 */
	public boolean updateTeacherDepartment(long id, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String modifyString = "update Teacher set Teacher.DNo = " +  id
					+ " where Teacher.TNo = " + this.id; 
			int value = mysql.executeUpdate(modifyString);
			if (value == 0) {
				mysql.close();
				message.append("更新老师部门ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("更新老师部门失败"+ e.getMessage());
			message.append("更新老师部门失败，可能不存在该部门，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 更新老师所在部门，需要传递部门类，通过调用updateTeacherDepartment(long, StringBuffer)
	 * @param dept 更新教师的部门
	 * @param message 返回错误消息
	 * @return 更新成功返回true否则返回false
	 */
	public boolean updateTeacherDepartment(Department dept, StringBuffer message) {
		return updateTeacherDepartment(dept.id, message); 
	}
	
}
