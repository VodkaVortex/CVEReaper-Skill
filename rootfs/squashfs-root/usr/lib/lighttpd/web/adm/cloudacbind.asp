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
var v_bind_status;
function doSubmit(index){
	var postVar ={"topicurl":"setting/cloudAcBind"};
	if(index == 1)
		postVar['cloudac_bind'] = "Register";
	else
		postVar['cloudac_bind'] = "Unregister";

	postVar['cloudac_user'] = $("#cloudac_user").val();
	postVar['cloudac_passwd'] = $("#cloudac_passwd").val();
	postVar['cloudac_host'] = $("#cloudac_host").val();
	postVar['cloudac_port'] = $("#cloudac_port").val();

	uiPost(postVar);
}

function initValue(){
setJSONValue({
		'cloudac_user'			  :	responseJson['CloudAc_User'],
		'cloudac_passwd'		  :	responseJson['CloudAc_Passwd'],
		'cloudac_host'			  :	responseJson['CloudAc_Host'],
		'cloudac_port'		  :	responseJson['CloudAc_Port']
	});

	v_bind_status=responseJson['CloudAc_Status'];
	if(v_bind_status == "Register"){
		$("#show_Bind_Status").html(MM_bind);
		$("#rmButton").attr("disabled", false);
	}else{
		$("#show_Bind_Status").html(MM_notbind);
		$("#rmButton").attr("disabled", true);
	}
}

$(function(){
	var postVar = { topicurl : "setting/CloudAcGetUser"};
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
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method="post" name="passwordCfg" id="passwordCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_cloudac_bind)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_cloudac_bind)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(BT_cloud_bindStatus)</script></td>
<td><span id="show_Bind_Status"></span></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_cloudac_user)</script></td>
<td><input type="text" id="cloudac_user" name="cloudac_user" maxlength="32"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_cloudac_passwd)</script></td>
<td><input type="text" id="cloudac_passwd" name="cloudac_passwd" maxlength="32"></td>
</tr>
<td class="item_left"><script>dw(MM_host_ipaddr)</script></td>
<td><input type="text" id="cloudac_host" name="cloudac_host" maxlength="32" value="cloudac.carystudio.com"></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_port)</script></td>
<td><input type="text" id="cloudac_port" name="cloudac_port" maxlength="32" value="80"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_cloud_bind+'" onClick="doSubmit(1)">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" id="rmButton" class="button" value="'+BT_rmbind+'" onClick="doSubmit(0)">')</script></td></tr>

</table>
</form>

<script>showFooter()</script>
</body></html>
