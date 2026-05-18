<html>
<head>
<title></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link href="style/style.css" rel="stylesheet" type="text/css">
<link href="style/line.css" rel="stylesheet" type="text/css">
<link rel="shortcut icon" href="">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var languageDiv2_flag=1;
var v_LanguageType,v_MultiLangSupport,v_HelpBuild,v_fmVersion,v_ProductModel,v_Title;

if(top!=self)top.location.href = self.location.href;
window.onerror=function(){return true;};

var lanip='',wtime=0;
function uiPost2(postVar){
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		var responseJson = JSON.parse(Data);
		lanip=responseJson['lan_ip'];
		wtime=responseJson['wtime'];
		do_count_down();
	});
}

function do_count_down(){
	if(wtime == 0) {parent.location.href='http://'+lanip+'/home.asp'; return false;}
	if(wtime > 0) {wtime--;setTimeout('do_count_down()',1000);}
}

function clickAdvanced(){window.location.href="/home.asp?timestamp="+(new Date()).valueOf();}

function updateState(){
	if ($('#onoff')[0].selectedIndex== 0){
		setDisabled("#hostname,#gw_id,#path",false);
	}else{
		setDisabled("#hostname,#gw_id,#path",true);
	}
}

function initValue() {
	v_LanguageType=responseJson['LanguageType'];
	v_MultiLangSupport=responseJson['MultiLangBuilt'];
	v_HelpBuild=responseJson['HelpBuilt'];		
	v_fmVersion=responseJson['fmVersion'];
	v_ProductModel=responseJson['ProductModel'];
	
	setJSONValue({
		'onoff'		:	responseJson['Enabled'],
		'hostname'	:	responseJson['Hostname'],
		'gw_id'		:   responseJson['GatewayID'],
		'path'		:   responseJson['Path'],
		'mcode'		:   responseJson['Mcode']
	});
	
	updateState();

	v_Title=responseJson['Title'];
 	if(v_Title!="")	top.document.title=v_Title;

	var tmp;
	if(v_ProductModel==""){
		tmp = MM_firmware+"  "+v_fmVersion;
	}else{
		tmp = v_ProductModel+"    ("+MM_firmware+"  "+v_fmVersion+")";
	}
	$("#ProductModel").html(tmp);	
	$("#HelpUrl").attr("href", 'http://'+responseJson['HelpUrl']);	

	if (v_LanguageType == "cn") {
		$("#language_cn").attr("src", "style/language_check.gif");
		$("#language_en").attr("src", "style/language_no_check.gif");
		$("#language").attr("src", "style/language_ch_s.gif");
		$("#help").attr("src", "style/help_ch_s.gif");
	}
	else {
		$("#language_cn").attr("src", "style/language_no_check.gif");
		$("#language_en").attr("src", "style/language_check.gif");
		$("#language").attr("src", "style/language_eng.gif");
		$("#help").attr("src", "style/help_eng.gif");
	}

	if (v_MultiLangSupport == "1") $("#div_multi_language").show();
	if (v_HelpBuild == "1") $("#div_help").show();

	$("#language").click(function(){
		if(languageDiv2_flag == "1"){
			$("#languageDiv2").show();
			languageDiv2_flag=0;
		}else{
			$("#languageDiv2").hide();
			languageDiv2_flag=1;
		}
	});
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
	postVar['Enabled'] = $("#onoff").val();
	postVar['Hostname'] = $("#hostname").val();
	postVar['GatewayID'] = $("#gw_id").val();
	postVar['Path'] = $("#path").val();
	uiPost2(postVar);
}
</script>
</head>
<body style="overflow-x:hidden">
<form method=post>
<table height="96" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="top_left">&nbsp;</td>
<td class="top_center">&nbsp;</td>
<td class="top_right" align="right">&nbsp;</td>
</tr>
</table>

<table height="44" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td class="first_table"><table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="ProductModel"></td>
<td class="title_down_center">&nbsp;</td>
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><img id="language" src="style/language_ch_s.gif" border="0" align="absmiddle" style="cursor:pointer" >&nbsp;&nbsp;</span>
<span id="div_help" style="display:none"><a id="HelpUrl" href="http://www.totolink.cn" target="_blank"><img id="help" src="style/help_ch_s.gif" border="0" align="absmiddle"></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table id="div_main" height="751" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">
<table border=0 width="700" align="center">
<tr><td colspan="2" height="45"></td></tr>
<tr><td colspan="2" class="content_title"><script>dw(MM_portal_setting)</script></td></tr>
<tr>
<td class="content_help"><script>dw(MSG_portal_setting)</script></td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_advanced_setup+'" onClick="clickAdvanced()">')</script></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div align="center">
<fieldset>
<legend><script>dw(MM_portal_setting)</script></legend>
<table border=0 width="100%">
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_portal_onoff)</script></td>
<td>&nbsp;&nbsp;<select id="onoff" name="onoff" onChange="updateState()">
<option value="on"><script>dw(MM_enable)</script></option>
<option value="off"><script>dw(MM_disable)</script></option>
</select></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_portal_servername)</script></td>
<td>&nbsp;&nbsp;<input type="text" name="hostname" id="hostname" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_portal_gw_id)</script></td>
<td>&nbsp;&nbsp;<input type="text" name="gw_id" id="gw_id" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_portal_path)</script></td>
<td>&nbsp;&nbsp;<input type="text" name="path" id="path" maxlength="32"></td>
</tr>
<tr>
<td width="60">&nbsp;</td>
<td class="item_left2"><script>dw(MM_portal_mcode)</script></td>
<td>&nbsp;&nbsp;<input type="text" name="mcode" id="mcode" size="32" disabled="disabled"></td>
</tr>
</table>
</fieldset>
</div>

<table border=0 width="700" align="center">
<tr><td height="10"></td></tr>
<tr>
<td class="content_help">&nbsp;</td>
<td align="right"><script>dw('<input type=button class=button_big value="'+BT_apply+'" name="save" onClick="doSubmit()">')</script></td>
</tr>
</table>
</td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_right">&nbsp;</td>
</tr>
</table>
</form>

<form action=/goform/setLanguage method=POST name="langCfg" target="_top">
<input type="hidden" name="langType">
<div id="languageDiv2" style="display:none">
<table width=172 border=0 cellpadding=3 cellspacing=0>
<tr><td colspan=2 height=22></td></tr>
<tr><td class="languageTitle" onClick="clickEnglish()"><script>dw(MM_english)</script></td>
<td><img id=language_en src="style/language_check.gif" border=0></td></tr>
<tr><td colspan=2 height=8></td></tr>
<tr><td class="languageTitle" onClick="clickChinese()"><script>dw(MM_chinese_simplified)</script></td>
<td><img id=language_cn src="style/language_no_check.gif" border=0></td></tr>
</table>
</div>
</form>
</div>
</body>
</html>
