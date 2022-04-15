package com.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

/**
 * Servlet Filter implementation class CharacterEncodingFilter
 */
/* @WebFilter("/*") */
public class CharacterEncodingFilter implements Filter {
	// 字符编码
	protected String encoding = null;
	// FilterConfig对象
	protected FilterConfig filterConfig = null;
    /**
     * Default constructor. 
     */
    public CharacterEncodingFilter() {
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
		// 在此设置字符编码
		System.out.println("Through the characterEncodingFilter.");
		if (encoding != null) {
			request.setCharacterEncoding(encoding);
			// response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset="+encoding);
		}
		// pass the request along the filter chain
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
		this.filterConfig = fConfig;
		this.encoding = filterConfig.getInitParameter("encoding");
	}

}
