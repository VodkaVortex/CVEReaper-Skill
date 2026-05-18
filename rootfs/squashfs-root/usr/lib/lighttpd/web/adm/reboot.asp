<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<title></title>
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
function rebootClick(){
	if ( !confirm(JS_msg82) ) 	return false;
	return true;
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_reboot)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_reboot)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<form method="post" name="rebootSystem" action="/goform/RebootSystem">
<tr>
<td class="item_left"><script>dw(MM_reboot_system)</script></td>
<td><script>dw('<input type="submit" class=button_big value="'+BT_reboot+'" name="reboot" onClick="return rebootClick()">')</script></td>
</tr>
</form>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
<script>showFooter()</script>
</body></html>