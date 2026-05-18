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
var opmode,apcli_enable_2G,apcli_enable_5G,wispInterface,wifiDualband,opModeSupport;
function initValue(){
	opmode = responseJson['OperationMode'];
	wispInterface = responseJson['wispInterface'];
	apcli_enable_2G = responseJson['ApCliEnable'];
	wifiDualband = responseJson['wifiDualband'];
	opModeSupport = responseJson['OpModeSupport'];
	
	if (opModeSupport.indexOf("GW")>-1){
		$("#div_gateway_mode").show();
	}
	if (opModeSupport.indexOf("BR")>-1){
		$("#div_bridge_mode").show();
	}
	if (opModeSupport.indexOf("RPT")>-1){
		$("#div_repeater_mode").show();
	}
	if (opModeSupport.indexOf("WISP")>-1){
		$("#div_wisp_mode").show();
	}
	if (opModeSupport.indexOf("SALE")>-1){
		$("#div_sale_mode").show();
	}
	
	$("#wispInterface").attr("disabled",true);
	if (opmode==0){
		supplyValue('opmode','0');
	}else if (opmode==1){				                                  
		supplyValue('opmode','1');	
	}else if (opmode==2){
		supplyValue('opmode','2');
	}else if (opmode==3){
		supplyValue('opmode','3');
		$("#wispInterface").attr("disabled",false).val(wispInterface);
		if (wifiDualband==1) $("#div_wifi_if_mode").show();
	}else if (opmode==4){
		supplyValue('opmode','4');
	}
}
$(function(){
	var postVar = { topicurl : "setting/getOpMode"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "POST",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
		}
    });

	$(":radio[name=opmode]").click(function(){
		if(3==this.value){
			$("#wispInterface").attr("disabled",false);
			if (wifiDualband==1) 
				$("#div_wifi_if_mode").show();
		}else{
			$("#wispInterface").attr("disabled",true);
			$("#div_wifi_if_mode").hide();
		}
	});
	
	initValue();
});
function doSubmit(){
	var postVar ={"topicurl":"setting/setOpMode"};
	var opmodeval = $(':radio[name=opmode]:checked').val();
	if(opmodeval ==2||opmodeval==3){
		if(opmodeval == 3){
			var wispInterface = $('#wispInterface').val();
			top['view'].location.href = '../wireless/repeater.asp?'+opmodeval+":"+wispInterface;
		}
		else
		{
			top['view'].location.href = '../wireless/repeater.asp?'+opmodeval;
		}
	}
	else{
		postVar['OperationMode'] = opmodeval;
		uiPost3(postVar);
	}
}
</script>
</head>
<body class="mainbody">
<span id="div_body_setting">
<script>showToper()</script>
<script>showContainer()</script>
<form method="post" name="opmode">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_opmode)</script></td></tr>
<tr><td class="content_help" ><script>dw(MSG_opmode_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr id="div_gateway_mode" style="display:none">
<td class="item_left"><input type="radio" value="1" name="opmode"><b><script>dw(MM_gateway_mode)</script></b></td>
<td><script>dw(MSG_gateway_mode)</script></td>
</tr>
<tr id="div_bridge_mode" style="display:none">
<td class="item_left"><input type="radio" value="0" name="opmode"><b><span><script>dw(MM_bridge_mode)</script></span></b></td>
<td><script>dw(MSG_bridge_mode)</script></td>
</tr>
<tr id="div_repeater_mode" style="display:none">
<td class="item_left"><input type="radio" value="2" name="opmode"><b><script>dw(MM_repeater_mode)</script></b></td>
<td><script>dw(MSG_repeater_mode)</script></td>
</tr>
<tr id="div_wisp_mode" style="display:none">
<td class="item_left"><input type="radio" value="3" name="opmode"><b><script>dw(MM_wisp_mode)</script></b></td>
<td><script>dw(MSG_wisp_mode)</script></td>
</tr>
<tr id="div_sale_mode" style="display:none">
<td class="item_left"><input type="radio" value="4" name="opmode"><b><script>dw(MM_marketing_mode)</script></b></td>
<td><script>dw(MSG_marketing_mode)</script></td>
</tr>
<tr id="div_wifi_if_mode" style="display:none">
<td class="item_left">&nbsp;</td>
<td><b><script>dw(MM_wan_interface)</script></b> <select id="wispInterface" name="wispInterface">
<option value="0">2.4G</option>
<option value="1">5G</option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit();">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</span>

<span id="div_wait" style="display:none">
<table width=700><tr><td><table border=0 width="100%">
<tr><td style="font-weight:bold; font-size:14px;"><script>dw(MM_change_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table><table border=0 width="100%">
<tr><td rowspan=2 width=100 align=center><img src="/style/load.gif" /></td>
<td class=msg_title><script>dw(JS_msg75)</script></td></tr>
<tr><td><script>dw(MM_please_wait)</script>&nbsp;<span id=show_sec></span>&nbsp;<script>dw(MM_seconds)</script> ...</td></tr>
<tr><td colspan=2><hr size=1 noshade align=top class=bline></td></tr>
</table></td></tr></table>
</span>
</body></html>
