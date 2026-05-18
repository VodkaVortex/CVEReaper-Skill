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
var responseJson,responseJsonShow;
function clearLogClick(){
	var postVar ={"topicurl":"setting/clearSyslog"};
	uiPost(postVar);
}
function refreshLogClick(){
	window.location.reload();
}
function initValue(){	
	var syslog=responseJsonShow['Syslog'];
	if (responseJson['syslogEnabled'] == 1) {
		$("#syslogEnbl")[0].selectedIndex = 1;
		$("#div_log").show();
		if(navigator.userAgent.indexOf("MSIE")>0) 
			if(navigator.userAgent.indexOf("MSIE 10.0")<0) 
				syslog=syslog.replace(/\n/g,"<br/>");
		$("#syslog").html(syslog);
	}else{
		$("#syslogEnbl")[0].selectedIndex = 0;
		$("#div_log").hide();
	}
}
$(function(){
	var postVar = { topicurl : "setting/getSyslogCfg"};
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
	
	var postVarShow = { topicurl : "setting/showSyslog"};
	postVarShow = JSON.stringify(postVarShow);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarShow,  
        async : false,  
        success : function(Data){
			responseJsonShow = JSON.parse(Data);
		}
    });
	initValue();
});
function doSubmit(){
	var postVar ={"topicurl":"setting/setSyslogCfg"};
	postVar['syslogEnbl']  = $('#syslogEnbl').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="syslog">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_syslog)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_syslog)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="syslogEnbl" name="syslogEnbl">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>

<div id="div_log" style="display:none">
<form method="post" name="clearLog" >
<table border=0 width="100%">
<tr><td><textarea name="syslog" id="syslog" style="font-size:9pt;width:100%" rows="20" wrap="off" readonly></textarea></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type="button" class=button value="'+BT_clear+'" onClick="clearLogClick()"> &nbsp; &nbsp;\
<input type="button" class=button value="'+BT_refresh+'" onClick="return refreshLogClick()">')</script></td></tr>
</table>
</form>
</div>
<script>showFooter()</script>
</body></html>
