<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="style/normal_ws.css" rel="stylesheet" type="text/css">
<link href="style/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script language="javascript">
var responseJson;
var v_LanguageType,v_MultiLangSupport,v_HelpBuild,v_fmVersion,v_ProductModel,v_OperationMode;
var tmp_parent=parent.frames["view"];

window.onerror=function(){return true;}

function openEasysetup(){

	top.location.href = "wizard.asp";

}
function initValue(){	
	v_LanguageType=responseJson['LanguageType'];
	v_MultiLangSupport=responseJson['MultiLangBuilt'];
	v_HelpBuild=responseJson['HelpBuilt'];
	v_fmVersion=responseJson['fmVersion'];
	v_ProductModel=responseJson['ProductModel'];
	v_OperationMode=responseJson['OperationMode'];
		
	var tmp;
	if(v_ProductModel==""){
		tmp = MM_firmware+"  "+v_fmVersion;
	}else{
		tmp = v_ProductModel+"    ("+MM_firmware+"  "+v_fmVersion+")";
	}
	$("#ProductModel").html(tmp);
	$("#HelpUrl").attr("href",'http://'+responseJson['HelpUrl']);

	if (v_MultiLangSupport.split(";").length > 1) $("#div_multi_language").show();
	
	if (v_OperationMode == 1) 
		$("#div_easysetup").show();
	else
		$("#div_easysetup").hide();
	if (v_HelpBuild == "1") $("#div_help").show();
}

$(function(){
	responseJson = _globalCfg_;
	initValue();
	showLanguageOption();
})
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="title_down_left" id="ProductModel"></td>
<!-- <td class="title_down_center" align="right">&nbsp;</td> -->
<td class="title_down_right" align="right">
	<span id="div_help" style="display:none;float: right;margin-right:8px;"><a id="HelpUrl" href="http://www.totolink.cn" target="_blank" style="position: relative;"><img id="help" src="../style/help_custom.gif" border="0" align="absmiddle"><span style="position: absolute;right: 12px;bottom:-2px;color: #fff;font-weight: bold;"><script>dw(MM_help)</script></span></a></span>
	<span id="div_multi_language" style="display:none;float: right;margin-right:8px;"><select id="languageOption"></select></span>
	<span id="div_easysetup" style="display:none;"><div style="width: 130px;height: 30px;background: #171717;float: right;border-radius: 8px;margin-right:8px;color: #fff;font-weight: bold;text-align: center;line-height: 30px;cursor: pointer;" onclick="openEasysetup()"><script>dw(MM_wizard)</script></div>
	</span></td>
</tr>
</table>
</body>
</html>
