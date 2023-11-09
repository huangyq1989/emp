//1、使用 window.locaion.href 获得项目的根路径
var curWwwPath = window.location.href;
//2、获得主机地址之后 的目录
var pathname = window.location.pathname;
var pos = curWwwPath.indexOf(pathname);
//3、获得主机地址
var sitePath = curWwwPath.substring(0,pos);

var CONFIG = {
	//API: 'http://172.16.10.199:8081/emp'
	API: sitePath + '/emp'
}
