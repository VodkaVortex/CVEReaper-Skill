<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
function loadDefaultClick(){
	if ( !confirm(JS_msg85) ) 	return false;
	var postVar ={"topicurl":"setting/LoadDefSettings"};
	$("#show_msg").html(JS_msg84);
	uiPost2(postVar);
}
function waitpage(){
	$("#div_setting").hide();
	$("#div_wait").show();
}
var lanip='',wtime=0;
function uiPost2(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	setTimeout('waitpage()',4000);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=responseJson['wtime'];
		do_count_down();
	});
}
function do_count_down(){
	document.getElementById("show_sec").innerHTML = wtime;
	if(wtime == 0) {parent.location.href='http://'+lanip+'/home.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down()',1000);}
}
</script>
</head>
<body class="mainbody">
<div id="div_setting">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_restore_factory_default)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<form method="post" name="LoadDefaultSettings" action="/goform/LoadDefaultSettings">
<tr>
<td class="item_left"><script>dw(MM_restore_factory_default)</script></td>
<td><script>dw('<input type="button" class=button_big name="restore" value="'+BT_restore+'" onClick="loadDefaultClick()">')</script></td>
</tr>
</form>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
<script>showFooter()</script>
</div>

<div id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><span id=show_msg></span></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</div>
</body></html>