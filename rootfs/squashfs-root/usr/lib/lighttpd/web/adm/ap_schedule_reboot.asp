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
var JsonSchd;

function initValue(){
	var time=JsonSchd['sysTime'].split(';');
	var tmp=time[0];
	if (time[0]>1)
		tmp+=MM_days+", ";
	else
		tmp+=MM_day+", ";
		
	tmp+=time[1];
	if (time[1]>1)
		tmp+=MM_hours+", ";
	else
		tmp+=MM_hour+", ";
	
	tmp+=time[2];
	if (time[2]>1)
		tmp+=MM_mins+", ";
	else
		tmp+=MM_min+", ";
		
	tmp+=time[3];
	if (time[3]>1)
		tmp+=MM_secs;
	else
		tmp+=MM_sec;
	$("#div_systime").html(tmp);
	$('#ScheEn').val(JsonSchd['day']);
}


$(function(){
	var postVar = { topicurl : "setting/getRebootScheCfg"};
	postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : false,  
        success : function(Data){
			JsonSchd = JSON.parse(Data);
		}
    });	
	initValue();
});
function doSubmit(){
	var postVar ={"topicurl":"setting/setRebootScheCfg"};
	postVar['day'] = $('#ScheEn').val();
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="sche_reboot" >
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_rebootsch_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_k7schedule_reboot)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="ScheEn"id="ScheEn" >
<option value=0><script>dw(MM_disable)</script></option>
<option value=3>3</option>
<option value=4>4</option>
<option value=5>5</option>
<option value=6>6</option>
</select>&nbsp;&nbsp;
<script>dw(MM_day)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_rebootsch_countdown)</script></td>
<td><span id="div_systime"></span></td>
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
