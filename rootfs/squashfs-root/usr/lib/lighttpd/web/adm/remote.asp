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
var responseJson;
function saveChanges(){	
	if ($("#rmEnabled")[0].selectedIndex == 1) {
		if(!checkVaildVal.IsVaildNumberRange($("#port").val(),MM_port,80,65535)) return false;
	}	
	return true;
}
function initValue(){
	$("#rmEnabled")[0].selectedIndex=responseJson['RemoteManagement'];
	$("#port").val(responseJson['RemoteManagementPort']);
	updateState();
}
$(function(){
	var postVar = { topicurl : "setting/getRemoteCfg"};
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
function updateState(){
	if ($("#rmEnabled")[0].selectedIndex == 1)
		$("#div_port").show();
	else
		$("#div_port").hide();
}
function doSubmit(){
	if(saveChanges()==false) return false;	
	var postVar ={"topicurl":"setting/setRemoteCfg"};
	postVar['rmEnabled'] = $('#rmEnabled').val();
	postVar['port'] = $('#port').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="remoteCfg" id="remoteCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_remote_management_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_remote_management)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="rmEnabled" id="rmEnabled" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="div_port" style="display:none">
<td class="item_left"><script>dw(MM_port)</script></td>
<td><input type="text" size="5" id="port" name="port" maxlength="5"> (80-65535)</td>
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