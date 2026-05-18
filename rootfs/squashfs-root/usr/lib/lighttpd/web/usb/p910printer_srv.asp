<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/jcommon.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script language="javascript">
var responseJson;
function initValue(){
	$("#enabled").get(0).selectedIndex=responseJson['PrinterSrvEnabled'];
}
$(function(){
	var postVar = { topicurl : "setting/getPrinterSrvCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : "/cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			responseJson = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(parm){		
	var postVar ={"topicurl":"setting/setPrinterSrv"};
	postVar['enabled']  = $('select[name="enabled"]').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name=printerCfg action="/goform/printersrv">
<input type="hidden" name="submit-url" value="/usb/p910printer_srv.asp">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_printer_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_printer_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%"> 
<tr> 
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="enabled" id="enabled">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button onclick="doSubmit()" value="'+BT_apply+'">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>