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
var responseJson;
function initValue(){	
	$("#pingFrmWANFilterEnabled").get(0).selectedIndex=responseJson['WANPingFilter'];
	$("#BlockPortScan").get(0).selectedIndex=responseJson['BlockPortScan'];
}
$(function(){	
	var postVar = { topicurl : "setting/getFirewallAdvCfg"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);							
		}
    });	
	initValue();
});
function doSubmit(){
	var postVar = { topicurl : "setting/setFirewallAdvCfg"};
	postVar['pingFrmWANFilterEnabled'] = $("#pingFrmWANFilterEnabled").val();
	postVar['BlockPortScan'] = $("#BlockPortScan").val();
	uiPost(postVar);
}
</script>
</head>
<body onLoad="initValue()" class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="firewall">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_firewall)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr>
<td class="item_left"><script>dw(MM_wan_ping)</script></td>
<td><select id="pingFrmWANFilterEnabled" name="pingFrmWANFilterEnabled">
<option value="0"><script>dw(MM_enable)</script></option>
<option value="1"><script>dw(MM_disable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_block_port_scan)</script></td>
<td><select id="BlockPortScan" name="BlockPortScan">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>