<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 获取session用户名
 	String userName = (String)session.getAttribute("username");
	String password = (String)session.getAttribute("password");
	// System.out.println(userName);
	if( userName == null || "".equals(userName)) 
	{
		session.setAttribute("message", "请先登录");
		// 未设置用户名，即非正常登录，则返回login.jsp
		response.sendRedirect("../login.jsp");
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>欢迎使用学生管理系统</title>
		<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js"></script>
		<link rel="stylesheet" href="css/index.css" />
		<link rel="stylesheet" type="text/css" href="css/user.css"/>
		<script>
			window.onload = function() {
				setXML('menu', 'menu.jsp');
			}

			function loadData(ev) {
				console.log("click the info");
				console.log($(ev).data('src'));
				// 移除原先的.active
				$('.active').removeClass('active');
				// 为当前添加.active
				$(ev).addClass('active');
				// 设置frame的路径为a的路径
				$('iframe').attr("src",$(ev).data('src'));
			}

			function setXML(domin, file) {
				var xmlHttp;
				if (window.XMLHttpRequest) {
					// IE7, Chrome ect. Browser use
					xmlHttp = new XMLHttpRequest();
				} else {
					// for IE6, IE5
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				}
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
						var std = xmlHttp.responseText;
						// console.log(std);
						document.getElementById(domin).innerHTML = std;
					}
				}
				xmlHttp.open('GET', file, true);
				xmlHttp.send();
			}
		</script>
	</head>
	<body>
		<!-- 主要的页面设计 -->
		<nav>
			<!--头部栏-->
			<a href="index.jsp" class="fl">
				<img src="../resource/college.jpg" alt="主页" height="30px"/>
			</a>
			<div class="profit fr">
				<div class="profit-img"><img src="../resource/default.png"/></div>
				<div class="text"><%=userName %></div>
			</div>
			<div class="clearfix"></div>
		</nav>
		<div class="main">
			<!-- 占位符 -->
			<div class="side fl scrool-style" id='side'>
				<!-- 侧边栏，通过ajax加载进来 -->
				<div id="menu">
				<!-- 将菜单栏加载进来 -->
				</div>
			</div>
			<div class="option fr">
				<div class="card scrool-style" id="content">
					<!-- 加载内容控件 -->
					<iframe src="welcome.html"></iframe>
					<!-- <img src="../resource/pexels-shamit-jangra-3013788.jpg"/> -->
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
	</body>
</html>
