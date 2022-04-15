<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>学生信息管理系统</title>
		<link rel="stylesheet" type="text/css" href="./css/login.css" />
		<link rel="shortcut icon" href="" type="image/x-icon">
	</head>
	<script type="text/javascript">
		function changeVerifyCode() {
			var str = "";
			for (let i = 0; i < 4; i++) {
				str += String.fromCharCode(
					Math.floor(Math.random() * 26 + 'a'.charCodeAt(0))
				);
			}
			var code = document.getElementById("login_code");
			code.innerHtml = str;
			code.innerText = str;
		}
		function verify() {
			var passed = true;
			var code = document.getElementById("login_code");
			var code_input = document.getElementById("login_verify");
			var account = document.getElementById("account");
			var password = document.getElementById("password");
			var errorTip = document.getElementsByClassName("error-tip");
			if (code_input.value != code.innerHtml) {
				code_input.style.borderBottom = '2px solid red';
				code_input.value = "";
				code_input.text = "";
				code_input.focus();
				errorTip[2].innerHTML = "请输入正确的验证码";
				changeVerifyCode();
				passed = false;
				/* return false; */
			}
			if (password == null || password.value == "") {
				password.style.borderBottom = '2px solid red';
				password.value = "";
				password.focus();
				errorTip[1].innerHTML = "请输入密码";
				changeVerifyCode();
				passed = false;
				/* return false; */
			}
			if (account == null || account.value == "") {
				account.style.borderBottom = '2px solid red';
				account.value = "";
				account.focus();
				errorTip[0].innerHTML = "请输入账号";
				changeVerifyCode();
				passed = false;
				/* return false; */
			}
			return passed;
		}
		
		function inputText(ev) {
			/* console.log(ev); */
			ev.style.borderBottom = "1px solid #999";
			let errorTip = document.getElementsByClassName("error-tip");
			for (let i = 0; i < errorTip.length; i++)
				errorTip[i].innerHTML = "";
		}
	</script>
	<body onload="changeVerifyCode()">
	<%
		String userName = request.getParameter("username");
		String password = request.getParameter("password");
		String messages = "";
		String cssstyle = "";
		
		String message = (String)session.getAttribute("message");
		/* String message = "账号和用户名无效，请重新登录"; */
		if (message == null || "".equals(message)) { 
			messages = "";
			cssstyle = "";
		} else {
			messages = message;
			cssstyle = "mcontainer";
		}
		
		if (userName == null) userName = "";
		if (password == null) password = "";
		// 设置cookie
		
	%>
		<nav class="navbar">
			<div class="container <%=cssstyle %>"><%=messages %></div>
		</nav>
		<div class="login_bg">
			<div class="cover"></div>
			<div class="return-home">
				<a href="./index.jsp">返回首页</a>
				|
				<a href="./register.jsp">注册</a>
			</div>
			<div class="login_box">
				<div class="login_content">
					<h2>学生信息管理系统</h2>
					<p>Student Information Management System</p>
					<form action="<%=request.getContextPath()%>/LoginServlet" method="post" onsubmit="return verify(this)">
						<div class="login_input">
							<input type="text" placeholder="账号" class="login_username" name="username" id="account" oninput="inputText(this)" value="<%=userName %>">
							<p class="error-tip"></p>
						</div>

						<div class="login_input">
							<input type="password" placeholder="密码" class="login_password" name="password" id="password" oninput="inputText(this)" value="<%=password %>">
							<p class="error-tip"></p>
						</div>
						
						<div class="login_input verify_code_box" onselectstart="return false">
							<input type="text" placeholder="验证码" class="login_verify" name="verify_code" id="login_verify" oninput="inputText(this)" maxlength=4>
							<div class="verify" onselectstart="return false"><a id="login_code" onclick="changeVerifyCode()">cege</a></div>
							<p class="error-tip"></p>
						</div>

						<div class="">
							<input class="login_btn sure" type="submit" value="登录">
						</div>
					</form>
				</div>
			</div>
		</div>
	</body>

</html>