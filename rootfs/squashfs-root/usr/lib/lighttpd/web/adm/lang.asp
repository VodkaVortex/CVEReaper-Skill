<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/menu.css" type="text/css">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/ajax.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript" src="../js/spec.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript">
var v_langType,responseJson;
function doSubmit(){
	var postVar ={"topicurl":"setting/setLanguageCfg"};
	postVar['langType']  = $('#langType').val();
	postVar = JSON.stringify(postVar);
	$(":input").attr('disabled',true);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		window.location.reload(true);
	});

}
function initValue(){
	var f=document.langCfg;
	v_langType=responseJson['LanguageType'];
	if (v_langType == "cn") {
		$("#langType")[0].selectedIndex = 1;
	}
	else {
		$("#langType")[0].selectedIndex = 0;
	}
}
$(function(){
	var postVar = { topicurl : "setting/getLanguageCfg"};
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
<form method=post name="langCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_lang_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_lang_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_lang_select)</script></td>
<td><select id="langType" name="langType" onChange="doSubmit()">
<option value="en"><script>dw(MM_english)</script></option>
<option value="cn"><script>dw(MM_chinese_simplified)</script></option>
</select></td>
</tr>
<tr style="display:none"><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
