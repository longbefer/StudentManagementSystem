/**
 * 
 */
package com.tools;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.dao.mysql.ConnectDB;

/**
 * 大学，包含各种的增加删除接口
 * @author NumberFour
 * 
 */
public class College {
	// List<Department> departments;
	public String name;
	
	public College() {
		this.name = "太原工业学院";
	}
	
	// 以下是部门的增删改查
	/**
	 * 添加系部，需要访问部门类的ID
	 * @param department 部门类
	 * @param message 返回错误消息
	 * @return 若添加成功返回true否则返回false，其中message中保存错误信息
	 */
	public boolean addDepartments(Department department, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "insert Department(DNo, DName) values"
					+ "(" + department.id + ",'" + department.name + "' )";
			int value = mysql.executeUpdate(sql);
			if (value == 0) {
				mysql.close();
				message.append("添加系部失败");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("添加系部失败" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 通过系部id删除系部，该函数调用传递部门类删除函数
	 * @param id 部门id
	 * @param message 返回错误信息
	 * @return 若成功返回true否则返回false
	 */
	public boolean deleteDepartments(long id, StringBuffer message) {
		Department department = new Department(id);
		department.setDepartmentInfo();
		return deleteDepartments(department, message);
	}
	
	/**
	 * 删除系部，注意删除时需要保证该系的学生和老师为空，否则不允许删除
	 * 由于存在外键依赖，故删除时数据库报错 
	 * @param department 需要部门类信息
	 * @param message 返回错误信息
	 * @return 删除成功返回true否则返回false
	 */
	public boolean deleteDepartments(Department department, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			if (department.getStudentsCount() > 0 ) {
				mysql.close();
				message.append("由于该系部存在学生，故该系不能撤销");
				return false;
			}
			if (department.getTeachersCount() > 0) {
				mysql.close();
				message.append("由于该系部存在教师，故该系不能撤销");
				return false;
			}
			String sql = "delete from Department where Department.DNo = " + department.id;
			int value = mysql.executeUpdate(sql);
			if (value == 0) {
				mysql.close();
				message.append("删除系部失败");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("删除系部失败" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 更新部门信息，通过调用old部门信息的updateDepartment函数来更i性能newDepartment的信息
	 * 更新成功返回true否则返回false
	 * @param old 旧的系部信息
	 * @param newD 新的系部信息
	 * @param message 返回错误信息
	 * @return 若更新成功返回true否则返回false
	 */
	public boolean updateDepartment(Department old, Department newD, StringBuffer message) {
		return old.updateDepartment(newD, message);
	}
	
	
	// 以下是专业的增删改查
	/**
	 * 对专业进行添加，若添加失败返回false添加成功返回true，需要传递参数Speciality
	 * 其中必须保证添加的该参数的Teacher和Department的参数被赋值，否则会出现错误
	 * @param speciality 需要添加的专业
	 * @param message 返回错误的消息
	 * @return 若成功返回true否则返回false
	 */
	public boolean addSpeciality(Speciality speciality, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "insert Speciality(SNo, SName, DNo, TNo) values"
					+ "("+ speciality.id + ", '" + speciality.name + "', "
					+ speciality.department.id + ", "
					+ speciality.teacher.id + ")";
			int value = mysql.executeUpdate(sql);
			if (value == 0) {
				mysql.close();
				message.append("添加专业失败，发生错误，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("添加发生错误" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 删除专业，通过传递转专业类，通过查找其id来删除该专业，注意，在删除该专业之前，必须保证
	 * 该专业内的学生被清空，否则会发生错误，同时，也可以提示
	 * 用户该专业下存在未删除的班级，删除专业将会导致班级表被清空（注：由于班级表和学生
	 * 表之间不存在级联删除，故该班级若存在一个学生，该程序都将报错，故保险的做法是将学生转移到
	 * 另外的班级，该班级不能是要被删除的专业下的班级）
	 * @param speciality 需要传递的删除专业的信息
	 * @param message 返回错误的消息，此消息一般可能作用不太大，但错误消息一般包含：存在外键依赖不能删除
	 * @return 若删除失败返回false,否则返回true
	 */
	public boolean deleteSpeciality(Speciality speciality, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			if (speciality.getStudentNumber() > 0) {
				mysql.close();
				message.append("存在班级的学生人数不为零，无法删除该专业，请先将该专业的学生转移至其他专业");
				return false;
			}
			String sqlString = "delete from Speciality where Speciality.SNo = " + speciality.id;
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("删除失败，请注意该班级不能存在学生才可以删除");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("错误，请检查是否设置正确的班级");
			return false;
		}
		return true;
	}
	
	/**
	 * 更新专业信息，通过调用旧的专业的信息更新为新的专业信息
	 * @param old 旧的系部信息
	 * @param newC 新的系部信息
	 * @param message 返回错误消息
	 * @return 成功返回true否则返回false
	 */
	public boolean updateSpeciality(Speciality old, Speciality newC, StringBuffer message) {
		return old.updateSpeciality(newC, message);
	}
	
	// 以下是班级的增删改查
	/**
	 * 添加班级，调用数据库添加班级信息，包含班级号，教师号，专业号
	 * @param classes 需要一个班级信息
	 * @param message 返回错误信息
	 * @return 若成功返回true否则返回false
	 */
	public boolean addClasses(Classes classes, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "insert Classes(CNo, TNo, SNo) values "
					+ "(" + classes.id + ", '" + classes.teacher.id + "', "
					+ classes.speciality.id + ")";
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("添加课程失败，可能具有相同的课程ID");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("添加课程失败" + e.getMessage());
			System.err.println("设置课程信息失败" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 更新班级信息，通过调用旧的班级的更新函数更新为新的信息，若更新成功返回true否则返回false
	 * @param oldClasses 旧的班级信息
	 * @param newClasses 新的班级信息
	 * @param message 返回错误信息
	 * @return 更改成功返回true否则返回false
	 */
	public boolean updateClasses(Classes oldClasses, Classes newClasses, StringBuffer message) {
		return oldClasses.updateClasses(newClasses, message);
	}
	
	/**
	 * 删除班级，注意删除班级时必须保证班级的学生为空，否则不允许删除，保留班级信息
	 * 由于学生对班级存在外键依赖，故无法只删除班级
	 * @param classes 传递班级信息
	 * @param message 返回错误信息
	 * @return 若删除成功返回true否则返回false
	 */
	public boolean deleteClasses(Classes classes, StringBuffer message) {
		// 包含级联更新、删除，SC表中对应的数据将会自动删除
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "delete from Classes where Classes.CNo = " + classes.id;
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("删除失败，请注意该班级不能存在学生才可以删除");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("错误，请检查是否设置正确的班级");
			return false;
		}
		return true;
	}

	// 以下是课程的增删改查
	/**
	 * 添加课程信息
	 * @param course 课程信息
	 * @param message 错误消息
	 * @return 成功true失败false
	 */
	public boolean addCourse(Course course, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "insert Course(CNo, CName, CMajor) values "
					+ "(" + course.id + ", '" + course.name + "', "
					+ course.isMajor + ")";
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("添加课程失败，可能具有相同的课程ID");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			message.append("添加课程失败" + e.getMessage());
			System.err.println("设置课程信息失败" + e.getMessage());
			return false;
		}
		return true;
	}
	
	/**
	 * 删除课程信息
	 * @param course 课程信息
	 * @param message 错误信息
	 * @return 成功返回true失败返回false
	 */
	public boolean deleteCourse(Course course, StringBuffer message) {
		// 若需要删除一门课程，若该课程为必修课，则必须取消所有班级选的课程才可以
		// 删除该课程，若该课程为选修课，直接删除，选课表中设置了级联删除
		
		
		// 在CC表中设置了班级、老师、课程组成的，而且设置了级联删除，怎么不行？
		// 应该要直接删掉！！！
		ConnectDB mysql = new ConnectDB();
		if (course.isMajor) // 若为必修课
		{
			/*
			 * if (course.getCourseClasses().size() != 0 ||
			 * course.getCourseTeachers().size() != 0) { mysql.close();
			 * message.append("无法删除当前课程，由于该课程存在外部依赖，请确认该课程" + course.name +
			 * "在课程信息中不存在班级课程表中后重试"); return false; }
			 */
			
			String sqlString = "delete from Course where Course.CNo = " + course.id;
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				message.append("非常抱歉，删除失败");
				mysql.close();
				return false;
			}
			mysql.close();
		} else { // 为选修课
			String sqlString = "delete from Course where Course.CNo = " + course.id;
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("删除选修课失败，请稍后重试");
				return false;
			}
			mysql.close();
		}
		return true;
	}
	
	/**
	 * 通过调用oldCourse的更新信息函数更新当前数据
	 * @param oldCourse 原来的课程信息
	 * @param newCourse 更改的课程信息
	 * @param message 返回错误信息
	 * @return 若更改成功为true否则为false
	 */
	public boolean updateCourse(Course oldCourse, Course newCourse, StringBuffer message) {
		return oldCourse.updateCourse(newCourse, message);
	}
	
	// 以下是学生的增删改查
	/** 不提倡的用法了
	 * 添加学生必须了解学生的id和需要进入的班级id，若插入成功返回true，否则反false
	 * @param stu 添加的学生信息
	 * @param cla 添加的班级信息
	 * @param message 若出现错误，则包含错误信息
	 * @return 插入成功返回true否则返回false
	 */
	public boolean addStudent(Student stu, Classes cla, StringBuffer message) {
		String sqlString = "insert Student"
				+ "(SNo, SName, SSex, SAge, SData, CNo) values"
				+ "(" + stu.id + ", '" + stu.name + "', '" + stu.sex
				+ "', " + stu.age + ", '" + new java.sql.Date(new Date().getTime()) 
				+ "', " + cla.id + ")";
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("插入学生可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("插入学生失败\n" + e.getMessage());
			message.append("插入学生失败，请检查是否有包含相同学号\n" + e.getMessage());
		}
		return true;
	}
	
	/**
	 * 删除学生，若删除学生失败则返回false
	 * @param id 学生的ID
	 * @param message 返回的错误信息
	 * @return 若删除学生成功则返回true否则返回false
	 */
	public boolean deleteStudent(long id, StringBuffer message) {
		String sql = "delete from Student where Student.SNo = " + id;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sql);
			if (value == 0) {
				mysql.close();
				message.append("删除学生可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("删除学生失败，可能存在级联删除问题，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 删除学生，通过传递学生类，该函数调用deleteStudent(long,StringBuffer)来删除
	 * @param stu 传递的学生类
	 * @param message 返回的错误消息
	 * @return 若删除成功返回true否则返回false
	 */
	public boolean deleteStudent(Student stu, StringBuffer message) {
		return deleteStudent(stu.id, message);
	}
	
	/**
	 * 更新学生信息，通过传递学生（注意：学生的学号不会修改，若需要修改学生学号请使用updateStudentID）
	 * @param stu 修改的学生信息
	 * @param message 返回修改失败时的信息
	 * @return 返回是否成功修改，成功为true，失败为false
	 */
	public boolean updateStudent(Student stu, StringBuffer message) {
		String sqlString = "update Student set "
				+ " Student.SName = '" + stu.name + "',"
				+ " Student.SSex = '" + stu.sex + "',"
				+ " Student.SAge = " + stu.age + ","
				+ " Student.CNo = " + stu.classes.id
				+ " where Student.SNo = " + stu.id;
		// System.out.println(sqlString);
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新学生可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新学生失败，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	/**
	 * 更新学生信息，此函数特别用来更新学生的ID，需要传递学神ID
	 * @param oldID 学生原来的ID
	 * @param newID 学生新的ID
	 * @param message 返回错误的信息
	 * @return 若更新成功返回true，否则返回false
	 */
	public boolean updateStudentID(long oldID, long newID, StringBuffer message) {
		String sqlString = "update Student set Student.SNo = " + newID
				+ " where Student.SNo = " + oldID;
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("更新学生ID可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			message.append("更新学生失败，可能存在相同学号，请检查\n" + e.getMessage());
			mysql.close();
			return false;
		}
		return true;
	}
	
	// 以下是老师的增删改查
	/**
	 * 添加老师到Teacher表中
	 * @param teacher 老师类，包含老师的基本信息
	 * @param dept 部门类，老师所处的部门，必须包含dept的id
	 * @param message 返回错误的信息
	 * @return 若成功返回true，失败返回false
	 */
	public boolean addTeacher(Teacher teacher, Department dept, StringBuffer message) {
		String sqlString = "insert Teacher"
				+ "(TNo, TName, DNo) values"
				+ "(" + teacher.id + ", '" + teacher.name + "', " 
				+ dept.id + ")";
		ConnectDB mysql = new ConnectDB();
		try {
			int value = mysql.executeUpdate(sqlString);
			if (value == 0) {
				mysql.close();
				message.append("插入老师可能失败，请稍后重试");
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("插入学生失败\n" + e.getMessage());
			message.append("插入学生失败，请检查是否有包含相同ID\n" + e.getMessage());
		}
		return true;
	}
	
	/**
	 * 删除老师，通过调用Teacher的删除函数，来删除老师信息
	 * @param id 教师id
	 * @param message 若出现错误，则返回错误信息
	 * @return 若删除成功返回true，否则返回false
	 */
	public boolean deleteTeacher(long id, StringBuffer message) {
		Teacher tec = new Teacher(id);
		return tec.deleteTeacher(message);
	}
	
	/**
	 * 删除老师信息，删除老师成功返回true
	 * @param tec 老师类，老师
	 * @param message 返回错误消息
	 * @return 若删除成功返回true，否则返回false
	 */
	public boolean deleteTeacher(Teacher tec, StringBuffer message) {
		return tec.deleteTeacher(message);
	}
	
	/**
	 * 更新教师的信息
	 * @param teacher 需要更新的教师的信息
	 * @param message 返回错误信息
	 * @return 若成功返回true失败返回false
	 */
	public boolean updateTeacher(Teacher oldTeacher, Teacher newTeacher, StringBuffer message) {
		return oldTeacher.updateTeacherInfo(newTeacher, message);
	}
	
	/**
	 * 该函数必须保证教师id有效
	 * @param teacher 需要更新的教师信息
	 * @param depet 教师的部门
	 * @param message 返回的错误信息
	 * @return 更新成功返回true，否则为false
	 */
	public boolean updateTeacher(Teacher oldTeacher, Teacher newTeacher, Department depet, StringBuffer message) {
		boolean bPassed = true;
		try {
			bPassed &= oldTeacher.updateTeacherName(newTeacher.name, message);
			bPassed &= oldTeacher.updateTeacherDepartment(depet.id, message);
			bPassed &= oldTeacher.updateTeacherID(newTeacher.id, message);
			if (!bPassed) {
				message.append("更新教师信息失败，请检查老师是否包含相同ID");
			}
		} catch (Exception e) {
			System.err.println("更新失败，请稍后重试" + e.getMessage());
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
	public boolean updateTeacherID(long oldID, long newID, StringBuffer message) {
		String sqlString = "update Teacher set Teacher.TNo = " + newID
				+ " where Teacher.TNo = " + oldID;
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
	
	// 部分有用的函数
	/**
	 * 获取分页时页面的数量
	 * @param table 需要获取的表
	 * @param pageSize 每页的大小
	 * @return 页面的数量
	 */
	public int getPageCount(String table, int pageSize) {
		if (pageSize <= 0) return -1; 
		int pageCount = 0; // 共多少页
		int rowCount = 1; // 总共的页数（数据库获取）

		ConnectDB mysql = new ConnectDB();
		try {
			ResultSet rs = mysql.executeQuery("select count(*) from " + table);
			if(rs != null && rs.next()) rowCount = rs.getInt(1);
			pageCount = (rowCount - 1) / pageSize + 1;
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取表" + table + "的页数时发送错误\n" + e.getMessage());
		}
		return pageCount;
	}
	
	/**
	 * 获取table数据表的数据个数，table 必须为数据库中存在的表 Student,Teacher,SC,Classes,Specialtiy,Department,Course
	 * @param table 数据库中的表名
	 * @return 返回表中的数据项
	 */
	public int getTableCount(String table) {
		ConnectDB mysql = new ConnectDB();
		ResultSet rs = mysql.executeQuery("select count(*) from " + table);
		int rowNumber = 0;
		try {
			if(rs != null && rs.next()) rowNumber = rs.getInt(1);
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println(e.getMessage());
			// e.printStackTrace();
		} // 返回多少条记录 
		return rowNumber;
	}
	
	/*
	 * public <T> List<T> getTables(String table) { List<T> tables = new
	 * ArrayList<T>(); ConnectDB mysql = new ConnectDB(); try { String sqlString =
	 * "select * from " + table; ResultSet rs = mysql.executeQuery(sqlString);
	 * while(rs.next()) { T tableInfo = new T(rs); tables.add(tableInfo); }
	 * mysql.close(); } catch (Exception e) { System.err.println("获取" + table +
	 * "失败/n" + e.getMessage()); mysql.close(); return null; } return tables; }
	 */
	
	// 以下是获取所有学生信息的函数
	/**
	 * 获取全校学生，若需要分页，请参加其重载函数
	 * @return 返回全校学生，若失败返回null
	 */
	public List<Student> getStudents() {
		List<Student> students = new ArrayList<Student>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select * from Student";
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Student stu = new Student(rs);
				students.add(stu);
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("获取所有学生信息失败/n" + e.getMessage());
			mysql.close();
			return null;
		}
		return students;
	}
	
	/**
	 * 返回全校学生的信息列表，以每页pageSize的形式发送
	 * @param pageNow 现在的页面
	 * @param pageSize 每个页面的数量
	 * @return 学生列表
	 */
	public List<Student> getStudents(int pageNow, int pageSize) {
		List<Student> students = new ArrayList<Student>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from student limit " + pageSize * (pageNow - 1) + "," + pageSize;
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Student stu = new Student(rs);
				students.add(stu);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取学生每页数量出错\n" + e.getMessage());
		}
		
		return students;
	}
	
	/**
	 * 获取全校学生的信息，若需要班级学生信息请使用Classes的getStudentNumber()
	 * @return 返回全校学生的数量，若出错则返回0
	 */
	public int getStudentNumber() {
		// 返回学生数量
		ConnectDB mysql = new ConnectDB();
		ResultSet rs = mysql.executeQuery("select count(*) from Student");
		int rowNumber = 0;
		try {
			if(rs != null && rs.next()) rowNumber = rs.getInt(1);
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println(e.getMessage());
			// e.printStackTrace();
		} // 返回多少条记录 
		return rowNumber;
	}
	
	/**
	 * 获取系部的所有学生
	 * @param department 需要传递的系部
	 * @return 返回系部的所有学生
	 */
	public List<Student> getStudents(Department department) {
		List<Student> students = new ArrayList<Student>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sqlString = "select Student.SNo, Student.SName, "
					+ "Student.SSex, Student.SAge, Student.CNo"
					+ " from Student,Classes,Speciality,Department "
					+ "where Student.CNo = Classes.CNo and "
					+ "Classes.SNo = Speciality.SNo and "
					+ "Speciality.DNo = Department.DNo and "
					+ "Department.DNo = " + department.id;
			ResultSet rs = mysql.executeQuery(sqlString);
			while(rs.next()) {
				Student stu = new Student(rs);
				students.add(stu);
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("获取所有学生信息失败/n" + e.getMessage());
			mysql.close();
			return null;
		}
		return students;
		
	}
	
	// 以下是获取所有老师信息的函数
	/**
	 * 获取全校老师列表
	 * @return 返回全校老师数据
	 */
	public List<Teacher> getTeachers() {
		List<Teacher> teachers = new ArrayList<Teacher>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from teacher";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Teacher teacher = new Teacher(rs);
				teachers.add(teacher);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取老师每页数量出错\n" + e.getMessage());
		}
		
		return teachers;
	}
	
	/**
	 * 读取某个系部的所有老师
	 * @param department 某个系部
	 * @return 该系部的老师
	 */
	public List<Teacher> getTeachers(Department department) {
		List<Teacher> teachers = new ArrayList<Teacher>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from teacher where DNo = " + department.id;
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Teacher teacher = new Teacher(rs);
				teachers.add(teacher);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取部门老师每页数量出错\n" + e.getMessage());
		}
		
		return teachers;
	}
	
	/**
	 * 读取每页的老师数量
	 * @param pageNow 当前页面
	 * @param pageSize 页面大小
	 * @return 返回当前也的老师数量
	 */
	public List<Teacher> getTeachers(int pageNow, int pageSize) {
		List<Teacher> teachers = new ArrayList<Teacher>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from teacher limit " + pageSize * (pageNow - 1) + "," + pageSize;
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Teacher teacher = new Teacher(rs);
				teachers.add(teacher);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取老师每页数量出错\n" + e.getMessage());
		}
		
		return teachers;
	}

	/**
	 * 获取全校老师的数量，也可以使用getTableCount("Teacher");来获取教师数量
	 * @return 返回教师数量
	 */
	public int getTeacherNumber() {
		ConnectDB mysql = new ConnectDB();
		ResultSet rs = mysql.executeQuery("select count(*) from Teacher");
		int rowNumber = 0;
		try {
			if(rs != null && rs.next()) rowNumber = rs.getInt(1);
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println(e.getMessage());
			// e.printStackTrace();
		} // 返回多少条记录 
		return rowNumber;
	}
	
	// 以下是获取所有课程的信息
	/**
	 * 获取所有的课程信息
	 * @return 获取所有的课程信息
	 */
	public List<Course> getCourses() {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from Course";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Course course = new Course(rs);
				courses.add(course);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取课程数量出错\n" + e.getMessage());
		}
		
		return courses;
	}
	
	/**
	 * 获取课程的每页数量
	 * @param pageNow 当前page页
	 * @param pageSize 每页数目的个数
	 * @return 返回每页的课程
	 */
	public List<Course> getCourses(int pageNow, int pageSize) {
		List<Course> courses = new ArrayList<Course>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from course limit " + pageSize * (pageNow - 1) + "," + pageSize;
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Course course = new Course(rs);
				courses.add(course);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取课程每页数量出错\n" + e.getMessage());
		}
		
		return courses;
	}
	
	/**
	 * 返回课程的数量
	 * @return 返回课程的数量
	 */
	public int getCourseCount() {
		int value = 0;
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select count(*) from course";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			if (rs.next()) {
				value = rs.getInt(1);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取课程每页数量出错\n" + e.getMessage());
		}
		return value;
	}
	/**
	 * 返回主修课程的数量
	 * @return 返回主修课程的数量
	 */
	public int getMajorCourseCount() {
		int value = 0;
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select count(*) from course where Course.CMajor = 1";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			if (rs.next()) {
				value = rs.getInt(1);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取课程每页数量出错\n" + e.getMessage());
		}
		return value;
	}
	
	/**
	 * 获取选修课数量
	 * @return 返回选修课程的数量
	 */
	public int getOptionalCourseCount() {
		int value = 0;
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select count(*) from course where Course.CMajor = 0";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			if (rs.next()) {
				value = rs.getInt(1);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取课程每页数量出错\n" + e.getMessage());
		}
		return value;
	}
	
	// 以下是获取所有班级信息
	/**
	 * 获取班级信息
	 * @return 获取所有班级信息
	 */
	public List<Classes> getClasses() {
		List<Classes> classes = new ArrayList<Classes>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from Classes";
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Classes cl = new Classes(rs);
				classes.add(cl);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取班级出错\n" + e.getMessage());
		}
		return classes;
	}
	
	/**
	 * 获取分页的班级信息
	 * @param pageNow 当前页面
	 * @param pageSize 每页大小
	 * @return 返回班级的分页信息
	 */
	public List<Classes> getClasses(int pageNow, int pageSize) {
		List<Classes> classes = new ArrayList<Classes>();
		ConnectDB mysql = new ConnectDB();
		try {
			// 到数据库中查找对应的数据
			String executeSql = "select * from classes limit " + pageSize * (pageNow - 1) + "," + pageSize;
			// System.out.printf(executeSql);
			ResultSet rs = mysql.executeQuery(executeSql);
			while (rs != null && rs.next()) {
				Classes cls = new Classes(rs);
				classes.add(cls);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("读取班级每页数量出错\n" + e.getMessage());
		}
		
		return classes;
	}
	
	// 以下是获取所有专业信息
	/**
	 * 返回专业信息，可以使用Speciality::setSpecialityInfo获取更多信息
	 * @return 返回所有专业信息
	 */
	public List<Speciality> getSpecialities() {
		List<Speciality> specialities = new ArrayList<Speciality>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "select * from Speciality";
			ResultSet rs = mysql.executeQuery(sql);
			while (rs.next()) {
				Speciality speciality = new Speciality(rs);
				specialities.add(speciality);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取所有专业失败/n" + e.getMessage());
			return null;
		}
		return specialities;
	}
	
	/**
	 * 获取系部的分页信息
	 * @param pageNow 当前也
	 * @param pageSize 每页大小
	 * @return 返回当前页面的专业列表
	 */
	public List<Speciality> getSpecialities(int pageNow, int pageSize) {
		List<Speciality> specialities = new ArrayList<Speciality>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "select * from Speciality limit " + pageSize * (pageNow - 1) + "," + pageSize;
			ResultSet rs = mysql.executeQuery(sql);
			while (rs.next()) {
				Speciality speciality = new Speciality(rs);
				specialities.add(speciality);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取所有专业每页失败/n" + e.getMessage());
			return null;
		}
		return specialities;
	}
	// 以下是获取所有系部信息
	/**
	 * 获取所有系部的信息并返回成为数组
	 * @return 返回系部的数组列表
	 */
	public List<Department> getDepartments() {
		List<Department> departments = new ArrayList<Department>();
		ConnectDB mysql = new ConnectDB();
		try {
			String sql = "select * from Department";
			ResultSet rs = mysql.executeQuery(sql);
			while (rs.next()) {
				Department department = new Department(rs);
				departments.add(department);
			}
			mysql.close();
		} catch (Exception e) {
			mysql.close();
			System.err.println("获取所有系部失败/n" + e.getMessage());
			return null;
		}
		return departments;
	}
	

}
