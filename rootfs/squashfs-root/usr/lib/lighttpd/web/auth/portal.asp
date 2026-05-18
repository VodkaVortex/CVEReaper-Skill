<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<title></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript">
var responseJson;

function updateState(){
	if ($('#onoff')[0].selectedIndex== 0){
		setDisabled("#hostname,#gw_id,#path",false);
	}else{
		setDisabled("#hostname,#gw_id,#path",true);
	}
}

function openurl(){
	if($("#hostname").val() == "")
		return ;
	var url = "http://"+$("#hostname").val();
	window.open(url);
}

function initValue() {
	setJSONValue({
		'onoff'		:	responseJson['Enabled'],
		'hostname'	:	responseJson['Hostname'],
		'gw_id'		:   responseJson['GatewayID'],
		'path'		:   responseJson['Path'],
		'mcode'		:   responseJson['Mcode']
	});
	
	var tb_tmp="";
	tb_tmp += '<tr><td class="item_left">'+MM_portal_status+'</td>';
	if ( responseJson['Status'] == "1" )
		tb_tmp += '<td><font color="green">'+MM_connected+'</font></td></tr>';
	else
		tb_tmp += '<td><font color="red">'+MM_not_connection+'</font></td></tr>';

	$("#div_portal_status").html(tb_tmp);
	updateState();
}

$(function() {
	var postVar = {topicurl: "setting/getPortalConf"};
	postVar = JSON.stringify(postVar);
	$.ajax({
		type: "post",
		url: " /cgi-bin/cstecgi.cgi",
		data: postVar,
		async: false,
		success: function(Data) {
			responseJson = JSON.parse(Data);
		}
	});
	initValue();
});

function saveChanges(){
	if (!checkVaildVal.IsVaildPortal($("#hostname").val(),MM_portal_servername))return false;
	if (!checkVaildVal.IsVaildPortal($("#gw_id").val(),MM_portal_gw_id))return false;
	if (!checkVaildVal.IsVaildPortal($("#path").val(),MM_portal_path))return false;	
	return true;
}

function doSubmit(){
	if (saveChanges()==false)
		return false;
				
	var postVar = {"topicurl": "setting/setPortalConf"};
	postVar['WD_ENABLE'] = $("#onoff").val();
	postVar['WD_HOSTNAME'] = $("#hostname").val();
	postVar['WD_GATEWAYID'] = $("#gw_id").val();
	postVar['WD_PATH'] = $("#path").val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post>
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_portal_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_portal_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_portal_onoff)</script></td>
<td><select id="onoff" name="onoff" onChange="updateState()">
<option value="on"><script>dw(MM_enable)</script></option>
<option value="off"><script>dw(MM_disable)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_portal_servername)</script></td>
<td><input type="text" name="hostname" id="hostname" maxlength="32" ><script>dw('&nbsp;&nbsp;&nbsp;<input type=button class=button value="'+MM_portal_jump+'" onClick="openurl()">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_portal_gw_id)</script></td>
<td><input type="text" name="gw_id" id="gw_id" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_portal_path)</script></td>
<td><input type="text" name="path" id="path" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_portal_mcode)</script></td>
<td><input type="text" name="mcode" id="mcode" size="40" disabled="disabled"></td>
</tr>
<tbody id="div_portal_status">&nbsp;</tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>