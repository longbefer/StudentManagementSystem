package com.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tools.Setup;

/**
 * Servlet Filter implementation class RegisterFilter
 */
@WebFilter("/RegisterFilter")
public class RegisterFilter implements Filter {

    /**
     * Default constructor. 
     */
    public RegisterFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here
		System.out.println("Through the registerFilter");
		// 获取传递的参数
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		// 获取session，将用户名和密码保存在session中
		HttpSession session = ((HttpServletRequest)request).getSession();
		
		if (username == null || username.equals("")) {
			// 无效的账号
			session.setAttribute("message", "无效的账号！");
			((HttpServletResponse)response)
			.sendRedirect("register.jsp");
			return; // 转到登录页面
		}
		if (password == null || password.equals("")) {
			// 无效密码
			session.setAttribute("message", "无效的密码！");
			((HttpServletResponse)response)
			.sendRedirect("register.jsp");
			return; // 转到登录页面
		}
		
		try {
			StringBuffer message = new StringBuffer();
			Setup userSetup = new Setup();
			if (!userSetup.registerAccount(username, password, message)) {
				session.setAttribute("message", message.toString());
				((HttpServletResponse)response)
				.sendRedirect("register.jsp");
				System.out.println("账号注册失败" + username + ": " + password);
				return;
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			session.setAttribute("message", "连接数据库发生错误！");
			((HttpServletResponse)response)
			.sendRedirect("register.jsp");
			return;
		}
		session.setAttribute("message", "");
		System.out.println("登录成功" + username + ": " + password);
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
