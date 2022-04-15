package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		
		 System.out.println("loginServlet.");
			
		// 若登录成功，则会执行该语句，此时设置session，记录当前用户名
		HttpSession session = request.getSession();
		String userName = (String) request.getParameter("username");
		session.setAttribute("username", userName);
		session.setAttribute("password", (String)request.getParameter("password"));
		// 设置session的有效时间为1000s，也可以不设置这条语句
		 session.setMaxInactiveInterval(1000);
		// 设置message
		 session.setAttribute("message", "");
		// 在这里将返回到index.jsp页面
		 //request.getRequestDispatcher("/index.jsp").forward(request, response);
		 response.sendRedirect("./user/index.jsp");
		 System.out.println("forward success!");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
