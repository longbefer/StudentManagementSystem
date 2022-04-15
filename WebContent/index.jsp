<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<script src="https://apps.bdimg.com/libs/jquery/2.1.4/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="./css/index.css"/>
		<title>学生信息管理系统</title>
	</head>
	<body>
		<nav id="source" style="display: none;">/* STUDENT INFOMATION MANAMAGEMENT SYSTEM */</nav>
		<section>
			<div class="cover"></div>
			<div class="title">
				<h1>学生信息管理系统</h1>
				<p id="output"></p>
			</div>
			<div class="button-group">
				<input type="button" class="button" value="注册" onclick="location='./register.jsp'"></input>
				<input type="button" class="button" value="登录" onclick="location='./login.jsp'"></input>
			</div>
			<div class="scroll-down-div">
				<div class="triangle"></div>
			</div>
		</section>
		<!--<div style="height: 600px;"></div>-->
		<script type="text/javascript">
			class Typing {
				constructor(opts) {
					this.opts = opts || {};
					this.source = opts.source;
					this.output = opts.output;
					this.delay = opts.delay || 120;
					this.chain = {
						parent: null,
						dom: this.output,
						val: []
					};
					if(!(typeof this.opts.done === 'function')) this.opts.done = function() {};
				}
		
				init() {
					//初始化函数
					this.chain.val = this.convert(this.source, this.chain.val);
				}
		
				convert(dom, arr) {
					//将dom节点的子节点转换成数组，
					let children = Array.from(dom.childNodes)
					for(let i = 0; i < children.length; i++) {
						let node = children[i]
						if(node.nodeType === 3) {
							arr = arr.concat(node.nodeValue.split('')) //将字符串转换成字符串数组，后面打印时才会一个一个的打印
						} else if(node.nodeType === 1) {
							let val = []
							val = this.convert(node, val)
							arr.push({
								'dom': node,
								'val': val
							})
						}
					}
					return arr
				}
		
				print(dom, val, callback) {
					setTimeout(function() {
						dom.appendChild(document.createTextNode(val));
						callback();
					}, this.delay);
				}
		
				play(ele) {
					//当打印最后一个字符时，动画完毕，执行done
					if(!ele.val.length) {
						if(ele.parent) this.play(ele.parent);
						else this.opts.done();
						return;
					}
					let current = ele.val.shift() //获取第一个元素，同时删除数组中的第一个元素
					if(typeof current === 'string') {
						this.print(ele.dom, current, () => {
							this.play(ele); //继续打印下一个字符
						})
					} else {
						let dom = current.dom.cloneNode() //克隆节点，不克隆节点的子节点，所以不用加参数true
						ele.dom.appendChild(dom)
						this.play({
							parent: ele,
							dom,
							val: current.val
						})
					}
				}
		
				start() {
					this.init();
					this.play(this.chain);
				}
			}
		</script>
		<script type="text/javascript">
			let source = document.getElementById('source')
			let output = document.getElementById('output')
			let typing = new Typing({
				source,
				output
			})
			typing.start()
		</script>
	</body>
</html>