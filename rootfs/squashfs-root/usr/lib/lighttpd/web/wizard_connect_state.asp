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
<script>
var responseJson,responseJsonConErr;
var languageDiv2_flag=1;
var v_LanguageType,v_MultiLangSupport,v_HelpBuild,v_fmVersion,v_ProductModel,v_Title;
var v_wanConnectStatus;

function backClick(){self.location.href = "wizard.asp";}
function finishClick() {self.location.href = "home.asp";}
function tryAgainClick() {window.location.reload();};

function initValue(){
	v_LanguageType=responseJson['LanguageType'];
	v_MultiLangSupport=responseJson['MultiLangBuilt'];
	v_HelpBuild=responseJson['HelpBuilt'];		
	v_fmVersion=responseJson['fmVersion'];
	v_ProductModel=responseJson['ProductModel'];	
	v_wanConnectStatus=responseJson['wanConnectStatus'];
	
	$("#div_connect_succes, #div_connect_failed").hide();
	if (v_wanConnectStatus == "MM_connected"){
		$("#div_connect_succes").show();
	}else{
		$("#div_connect_failed").show();
	}

	v_Title=responseJson['Title'];	
	if(v_Title!="") top.document.title=v_Title;

	var tmp;
	if(v_ProductModel==""){
		tmp = MM_firmware+"  "+v_fmVersion;
	}else{
		tmp = v_ProductModel+"    ("+MM_firmware+"  "+v_fmVersion+")";
	}
	$("#ProductModel").html(tmp);	
	$("#HelpUrl").attr("href", 'http://'+responseJson['HelpUrl']);	

	if (v_LanguageType == "cn") {
		$("#language_cn").attr("src","style/language_check.gif");
		$("#language_cnt").attr("src","style/language_no_check.gif");
		$("#language_en").attr("src","style/language_no_check.gif");
		$("#language").attr("src","style/language_ch_s.gif");
		$("#help").attr("src","style/help_ch_s.gif");
	}
	else if (v_LanguageType == "cnt") {
		$("#language_cn").attr("src","style/language_no_check.gif");
		$("#language_cnt").attr("src","style/language_check.gif");
		$("#language_en").attr("src","style/language_no_check.gif");
		$("#language").attr("src","style/language_cnt.gif");
		$("#help").attr("src","style/help_cnt.gif");
	}
	else if (v_LanguageType == "en") {
		$("#language_cn").attr("src","style/language_no_check.gif");
		$("#language_cnt").attr("src","style/language_no_check.gif");
		$("#language_en").attr("src","style/language_check.gif");
		$("#language").attr("src","style/language_eng.gif");
		$("#help").attr("src","style/help_eng.gif");
	}

	if (v_MultiLangSupport.split(";").length > 1) $("#div_multi_language").show();
	var MultiLangArr=v_MultiLangSupport.split(";");
	for( var i=0; i<MultiLangArr.length; i++ )
	{
		if (MultiLangArr[i]=="cn"){
			$("#div_languageCn").show();
			$("#div_languageCnTr").show();
		}
		else if (MultiLangArr[i]=="cnt"){
			$("#div_languageCnt").show();
			$("#div_languageCntTr").show();
		}
	}

	
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

	document.getElementById("div_main").style.height = document.body.offsetHeight-181+"px";
	document.getElementById("div_main").style.height = document.body.clientHeight-181+"px";//for firefox
}

$(function(){
	var postVar = { topicurl : "setting/getSysStatusUICfg"};
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
<td class="title_down_right" align="right"><span id="div_multi_language" style="display:none"><img id="language" src="../style/language_ch_s.gif" border="0" align="absmiddle" style="cursor:pointer" >&nbsp;&nbsp;</span>
<span id="div_help" style="display:none"><a id="HelpUrl" href="http://www.totolink.cn" target="_blank"><img id="help" src="../style/help_ch_s.gif" border="0" align="absmiddle"></a></span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table></td>
<td width="6"></td>
</tr>
</table>

<table id="div_main" height="751" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="6"></td>
<td valign="top" class="first_table">
<div id="div_connect_succes" style="display:none" align="center">
<table border=0 align="center">
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><img src="style/easysetup_connect.gif"></td></tr>
<tr><td height="10"></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><span class="wz_title_2"><script>dw(MSG_wizard_info1)</script></span></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="center"><span class="wz_title_1"><script>dw(MSG_wizard_info2)</script></span></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><script>dw('<input type="button" class="button" value="'+BT_back+'" onClick="backClick()">&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_finish+'" onClick="finishClick()">')</script></td></tr>
</table>
</div>

<div id="div_connect_failed" style="display:none" align="center">
<table border=0 align="center">
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><img src="style/easysetup_failed.gif"></td></tr>
<tr><td height="10"></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><span class="wz_title_3"><script>dw(MSG_wizard_info3)</script></span></td></tr>
<tr><td>&nbsp;</td></tr>
<tr><td align="center"><script>dw('<input type="button" class="button" value="'+BT_back+'" onClick="backClick()">&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_try_again+'" onClick="tryAgainClick()">')</script></td></tr>
</table>
</div>
</td>
<td width="6"></td>
</tr>
</table>

<table height="41" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="bottom_left">&nbsp;</td>
<td class="bottom_center1">&nbsp;</td>
<td class="bottom_center1">
<script>
	var curDate = new Date();
	dw(MM_Copyright_Left)+document.write(curDate.getFullYear())+dw(MM_Copyright_Right);
</script>
</td>
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
<tr id="div_languageCnTr" style="display:none"><td colspan=2 height=8></td></tr>
<tr id="div_languageCn" style="display:none"><td class="languageTitle" onClick="switchLanguage('cn')"><script>dw(MM_chinese_simplified)</script></td>
<td><img id=language_cn src="style/language_no_check.gif" border=0></td></tr>
<tr id="div_languageCntTr" style="display:none"><td colspan=2 height=8></td></tr>
<tr id="div_languageCnt" style="display:none"><td class="languageTitle" onClick="switchLanguage('cnt')"><script>dw(MM_chinese_traditional)</script></td>
<td><img id=language_cnt src="style/language_no_check.gif" border=0></td></tr>
</table>
</div>
</form>
</body>
</html>
