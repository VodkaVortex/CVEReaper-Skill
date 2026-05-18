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
	$("#l2tpPT").get(0).selectedIndex=responseJson['l2tpPassThru'];
	$("#pptpPT").get(0).selectedIndex=responseJson['pptpPassThru'];
	$("#ipsecPT").get(0).selectedIndex=responseJson['ipsecPassThru'];	
	$("#ipv6PT").get(0).selectedIndex=responseJson['ipv6PassThru'];
}
$(function(){	
	var postVar = { topicurl : "setting/getVpnPassCfg"};
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
	var postVar = { topicurl : "setting/setVpnPassCfg"};
	postVar['pingFrmWANFilterEnabled'] = $("#pingFrmWANFilterEnabled").val();
	postVar['l2tpPT'] = $("#l2tpPT").val();
	postVar['pptpPT'] = $("#pptpPT").val();
	postVar['ipsecPT'] = $("#ipsecPT").val();
	postVar['ipv6PT'] = $("#ipv6PT").val();
	postVar['week_all'] = "ON";
	postVar['time_all'] = "ON";
	uiPost(postVar);
}
</script>
</head>
<body onLoad="initValue()" class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="vpnpass">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_vpnpass_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_vpnpass_setting)</script></td></tr>
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
<td class="item_left"><script>dw(MM_l2tp_pass)</script></td>
<td><select id="l2tpPT" name="l2tpPT">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_pptp_pass)</script></td>
<td><select id="pptpPT" name="pptpPT">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ipsec_pass)</script></td>
<td><select id="ipsecPT" name="ipsecPT">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_ipv6" style="display:none">
<td class="item_left" ><script>dw(MM_ipv6_pass)</script></td>
<td><select id="ipv6PT" name="ipv6PT">
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