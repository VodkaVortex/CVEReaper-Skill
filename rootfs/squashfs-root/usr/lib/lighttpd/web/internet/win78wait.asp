<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/jcommon.js"></script>
<script>
var lanIp=Cookie.Get("lanIP");
var count = 58;
function do_count_down(){
	document.getElementById("show_sec").innerHTML = count;
	if(count == 0) {
		loadLogin(); 
		return false;
	}
	if(count > 0) {
		count--;
		setTimeout('do_count_down()',1000);
	}
}
function loadLogin(){
	var ifm=document.getElementById("lansetting");
    ifm.src="http://"+lanIp+"/goLogin.htm?t="+(new Date()).valueOf();
	setTimeout(function(){loadLogin();},"5000");
}
</script>
</head>
<body onLoad="do_count_down()" class="mainbody">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg57)</script></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
<iframe name="lansetting" id="lansetting" style="display:none;"></iframe>
</body>
</html>
