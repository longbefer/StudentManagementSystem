/**
 * 
 */
package com.tools;

import java.sql.ResultSet;
import com.dao.mysql.ConnectDB;

/**
 * @author NumberFour
 *
 */

/**
 * Setup类：主要用于设置账号、密码、删除删号等操作的
 * @author NumberFour
 *
 */
public class Setup {	
	/**
	 * 数据库操作语句
	 */
	static private String selectString = "select * from user_login where _user_name = '%s' and _user_delete_account = 0";
	static private String insertString = "insert user_login(_user_name, _user_password) values ('%s', '%s')";
	static private String loginString = "select * from user_login where _user_name = '%s' and _user_password = '%s' and _user_delete_account = 0";
	static private String deleteString = "update user_login set _user_delete_account = 1 where _user_name = '%s' and _user_password = '%s' and _user_delete_account = 0";
	static private String updataString = "update user_login set %s where _user_name = '%s' and _user_password = '%s' and _user_delete_account = 0"; 
	
	/**
	 * login类用于登录，需要传递账号密码，同时需要一个StringBuffer用于存放错误信息，
	 * 该函数将通过连接数据库来判断账号密码是否存在，存在则返回true，否则返回false
	 * @param account 用户账号 user account
	 * @param password 用户密码 user password
	 * @param message 保存错误信息 save the error infomation
	 * @return 若为账号密码登录成功，返回true，否则返回false
	 */
	public boolean login(String account, String password, StringBuffer message) {
		ConnectDB mysql = new ConnectDB();
		try {
			String connString = String.format(loginString, account, password);
			ResultSet resultSet = mysql.executeQuery(connString);
			if (resultSet == null || resultSet.next() == false) { 
				message.append("账号或密码输入错误");
				mysql.close();
				return false;
			}
			mysql.close();
		} catch (Exception e) {
			System.err.println("登录时出现错误，登录账户：" + account + "登录密码： " + password + "\n" + e.getMessage());
			message.append("登陆时发生错误，请重试");
			return false;
		}
		return true;
	}
	
	/**
	 * 删除账号，传递需要删除的账号和密码，该函数会先验证是否存在该账号，
	 * 若存在，则删除该账号并返回true，若失败返回false
	 * @param account 需要删除的账号
	 * @param password 该账号的密码，验证是否为本人
	 * @param message 返回操作信息
	 * @return 若删除成功，则返回true，否则返回false
	 */
	public boolean deleteAccount(String account, String password, StringBuffer message) {
		if (!login(account, password, message)) return false;
		ConnectDB mysql = new ConnectDB();
		String conString = String.format(deleteString, account, password);
		int value = mysql.executeUpdate(conString);
		mysql.close();
		if (value != 0) return true;
		message.append("暂时无法删除账号");
		return false;
	}
	
	/**
	 * 注册一个账号，需要传递该账号的账号名和密码，函数将会验证是否存在相同用户名，
	 * 若存在，则不允许创建，若创建成功返回true，否则返回false
	 * @param account 需要创建的账号名
	 * @param password 该账号的密码
	 * @param message 返回操作信息
	 * @return 创建成功返回true，否则返回false
	 */
	public boolean registerAccount(String account, String password, StringBuffer message) {
		String find = String.format(selectString, account);
		ConnectDB mysql = new ConnectDB();
		try {
			// 查找是否已存在账号
			ResultSet rt = mysql.executeQuery(find);
			if (rt != null && rt.next() != false) {
				message.append("当前用户名已存在，请更换用户名");
				mysql.close();
				return false;
			}
			
			// 插入当前账号
			String insert = String.format(insertString, account, password);
			int staus = mysql.executeUpdate(insert);
			mysql.close();
			if (staus != 0) return true;
			// 更新失败，返回
			message.append("创建账户失败，请检查账号密码不要超出最大长度");
		} catch (Exception e) {
			System.err.println("未知错误");
			message.append("注册错误，请尝试登录");
			mysql.close();
			return false;
		}	
		return false;
	}
	
	/**
	 * 更改用户密码，需要传递账户，先前密码，新密码以及返回一串操作信息
	 * 该函数先判断账户是否可登录，然后再进行更改密码
	 * @param account 更改密码的账户
	 * @param oldPassword 账户的旧密码
	 * @param newPassword 账户设置的新密码
	 * @param message 返回的操作信息
	 * @return 若更改成功返回true，更改失败返回false，并在message中可以得到失败信息
	 */
	public boolean changePassword(String account, String oldPassword, String newPassword, StringBuffer message) {
		if (!login(account, oldPassword, message)) return false;
		ConnectDB mysql = new ConnectDB();
		String conString = String.format(updataString, "_user_password = \'" + newPassword + "\'", account, oldPassword);
		int value = mysql.executeUpdate(conString);
		mysql.close();
		if (value != 0) return true;
		message.append("暂时无法更改密码");
		return false;
	}
	
	/**
	 * 更改用户账号名，需要传递账户、密码以及新的账户名，若修改成功将返回true，失败返回false
	 * @param account 需要更改的账户
	 * @param password 账户的密码
	 * @param newAccount 新的账户名
	 * @param message 返回操作信息
	 * @return 若更改成功返回true，更改失败返回false，并在message中可以得到失败信息
	 */
	public boolean changeAccount(String account, String password, String newAccount, StringBuffer message) {
		if (!login(account, password, message)) return false;
		ConnectDB mysql = new ConnectDB();
		String conString = String.format(updataString, "_user_account = \'" + newAccount + "\'", account, password);
		int value = mysql.executeUpdate(conString);
		mysql.close();
		if (value != 0) return true;
		message.append("暂时无法更改账号");
		return false;
	}
	
	/**
	 * 返回数据的数量（需要传递表的名称，用于查询数据库）
	 * 即 table 必须为 Student, Teacher, Course, SC, CC, Department, Classes, Specialty 
	 * @param table 需要数据库查询的表的数据
	 * @return 返回总共的数据数量
	 */
	public int getRowNumber(String table) {
		ConnectDB mysql = new ConnectDB();
		ResultSet rs = mysql.executeQuery("select count(*) from " + table);
		int rowNumber = 0;
		try {
			if(rs != null && rs.next()) rowNumber = rs.getInt(1);
			rs.close();
		} catch (Exception e) {
			System.err.println(e.getMessage());
			// e.printStackTrace();
		} // 返回多少条记录 
		return rowNumber;
	}
}



