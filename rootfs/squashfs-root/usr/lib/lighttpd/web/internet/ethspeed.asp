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
var v_opmode,v_wanspeed,v_lanspeed1,v_lanspeed2,v_lanspeed3,v_lanspeed4;

function initValue(){	
	var f=document.ethspeedCfg;
	v_opmode = responseJson['OperationMode'];
	v_wanspeed = responseJson['wanspeed'];
	v_lanspeed1 = responseJson['lanspeed1'];
	v_lanspeed2 = responseJson['lanspeed2'];
	v_lanspeed3 = responseJson['lanspeed3'];
	v_lanspeed4 = responseJson['lanspeed4'];
	
	if (v_opmode=="3"||v_opmode=="0") 
		supplyValue("div_wanorlan", MM_lan_port);
	else 
		supplyValue("div_wanorlan", MM_wan_port);

	$("#wanspeed").get(0).selectedIndex  = v_wanspeed  == '' ? 0 : v_wanspeed;
	$("#lanspeed1").get(0).selectedIndex = v_lanspeed1 == '' ? 0 : v_lanspeed1;
	$("#lanspeed2").get(0).selectedIndex = v_lanspeed2 == '' ? 0 : v_lanspeed2;
	$("#lanspeed3").get(0).selectedIndex = v_lanspeed3 == '' ? 0 : v_lanspeed3;
	$("#lanspeed4").get(0).selectedIndex = v_lanspeed4 == '' ? 0 : v_lanspeed4;
}

$(function(){
	var postVar = { topicurl : "setting/getEthspeedConfig"};
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
	var postVar ={"topicurl":"setting/setEthspeedConfig"};
	postVar['wanspeed'] = $('#wanspeed').val();
	postVar['lanspeed1'] = $('#lanspeed1').val();
	postVar['lanspeed2'] = $('#lanspeed2').val();
	postVar['lanspeed3'] = $('#lanspeed3').val();
	postVar['lanspeed4'] = $('#lanspeed4').val();

	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form  name="ethspeedCfg" id="ethspeedCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_ethspeed_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_ethspeed_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>
<table border=0 width="100%">
<tr>
<td class="item_left"><span id="div_wanorlan"></span></td>
<td><select id="wanspeed" name="wanspeed">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1">10M <script>dw(MM_half)</script></option>
<option value="2">10M <script>dw(MM_full)</script></option>
<option value="3">100M <script>dw(MM_half)</script></option>
<option value="4">100M <script>dw(MM_full)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_lan_port)</script> 4</td>
<td><select id="lanspeed4" name="lanspeed4">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1">10M <script>dw(MM_half)</script></option>
<option value="2">10M <script>dw(MM_full)</script></option>
<option value="3">100M <script>dw(MM_half)</script></option>
<option value="4">100M <script>dw(MM_full)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_lan_port)</script> 3</td>
<td><select id="lanspeed3" name="lanspeed3">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1">10M <script>dw(MM_half)</script></option>
<option value="2">10M <script>dw(MM_full)</script></option>
<option value="3">100M <script>dw(MM_half)</script></option>
<option value="4">100M <script>dw(MM_full)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_lan_port)</script> 2</td>
<td><select id="lanspeed2" name="lanspeed2">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1">10M <script>dw(MM_half)</script></option>
<option value="2">10M <script>dw(MM_full)</script></option>
<option value="3">100M <script>dw(MM_half)</script></option>
<option value="4">100M <script>dw(MM_full)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_lan_port)</script> 1</td>
<td><select id="lanspeed1" name="lanspeed1">
<option value="0"><script>dw(MM_auto)</script></option>
<option value="1">10M <script>dw(MM_half)</script></option>
<option value="2">10M <script>dw(MM_full)</script></option>
<option value="3">100M <script>dw(MM_half)</script></option>
<option value="4">100M <script>dw(MM_full)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type="button" class=button value="'+BT_apply + '"onClick="doSubmit()" />')</script></td></tr>
</table>
</form>

<script>showFooter()</script>
</body></html>
