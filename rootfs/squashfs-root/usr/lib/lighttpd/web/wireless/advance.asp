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
var responseJson,WiFiOff,v_HideSSID,v_NoForwarding;
function initValue(){
	v_WiFiOff = responseJson['WiFiOff'];
	v_HideSSID = responseJson['HideSSID'].split(";");
	v_NoForwarding = responseJson['NoForwarding'].split(";");
	
	setJSONValue({
		'hssid'               : v_HideSSID[0],
		'NoForwarding'		  :	v_NoForwarding[0]
	});

	if (v_WiFiOff==1){
		$(":input").attr('disabled',true);
	}
}
var WiFiIdx = "0";
var responseJsonIdx;
var wifiFlag=0;
$(function(){
	var postVarBuilt = { "topicurl" : "setting/getWebWlanIdx"};
    postVarBuilt = JSON.stringify(postVarBuilt);
	$.ajax({  
       	type : "post",  
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVarBuilt,  
        async : false,  
        success : function(Data){
			responseJsonIdx = JSON.parse(Data);
			wifiFlag=responseJsonIdx['webWlanIdx'];
		}
    }); 
	
	if(top.frames[0].wifiSelect == 1 || wifiFlag == 1)
		WiFiIdx = "1";

	var postVar = { topicurl : "setting/getWiFiAdvancedConfig"};
	postVar['WiFiIdx']=WiFiIdx;
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);	
			initValue();				
		}
    });	
});
function doSubmit(){
	var postVar ={"topicurl":"setting/setWiFiAdvancedConfig"};
	postVar['HideSSID'] = $("#hssid").val()+";"+v_HideSSID[1]+";"+v_HideSSID[2];
	postVar['NoForwarding'] = $('#NoForwarding').val()+";"+NoForwarding[1]+";"+NoForwarding[2];	
	postVar['WiFiIdx']=WiFiIdx;
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessAdvanced" id="wirelessAdvanced">
<input type="hidden" name="HideSSID" id="HideSSID">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_advanced_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_broadcast_ssid)</script></td>
<td><select name="hssid" id="hssid">
<option value="1"><script>dw(MM_disable)</script></option>
<option value="0"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr> 
<td class="item_left"><script>dw(MM_ap_isolated)</script></td>
<td><select name="NoForwarding" id="NoForwarding">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="right"><script>dw('<input type=button class=button id="apply" value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</span>
</body></html>
