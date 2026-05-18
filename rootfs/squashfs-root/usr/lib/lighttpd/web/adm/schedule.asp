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
var v_NTPValid,v_week,v_hour,v_minute,v_ScheEn;
function updateStateSchReboot(){
	if ($("#ScheEn")[0].selectedIndex == 1)
		$("#week,#time").show();
	else
		$("#week,#time").hide();

	var postVar ={"topicurl":"setting/setRebootScheCfg"};
	postVar['ScheEn'] = $('#ScheEn').val();
	postVar['time_h'] = $('#time_h').val();
	postVar['time_m'] = $('#time_m').val();
	postVar['reSchWeek'] = $('#reSchWeek').val();
	uiPost(postVar);
}
function initValue(){
	v_NTPValid=responseJson['NTPValid'];
	v_week=responseJson['Scheduleweek_reboot'];
	v_hour=responseJson['Schedulehour_reboot'];
	v_minute=responseJson['Schedulemm_reboot'];
	v_ScheEn=responseJson['ScheduleEn_reboot'];
	$("#ScheEn")[0].selectedIndex=v_ScheEn;
	
	if ($("#ScheEn")[0].selectedIndex == 1)
		$("#week,#time").show();
	else
		$("#week,#time").hide();

	if(v_week==255)
		$("#reSchWeek")[0].selectedIndex = 0;
	else if(v_week == 128)
		$("#reSchWeek")[0].selectedIndex = 1;
	else
		$("#reSchWeek")[0].selectedIndex = Math.log(v_week)/Math.log(2)+1;

	$("#time_h")[0].selectedIndex = v_hour;
	$("#time_m")[0].selectedIndex = v_minute;
}
function dispalyFromHourOption(){
	var strTmp;
	for(var i = 0; i < 24; i++){
		if(i<10)
			strTmp ="<OPTION value="+i+">"+0+i;
		else
			strTmp ="<OPTION value="+i+">"+i;
		document.write(strTmp);
	}	
}
function dispalyFromMinOption(){
	var strTmp;
	for(var i = 0; i < 60; i++){
		if(i<10)
			strTmp ="<OPTION value="+i+">"+0+i;
		else
			strTmp ="<OPTION value="+i+">"+i;
		document.write(strTmp);
	}	
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
			responseJson = JSON.parse(Data);
		}
    });	
	initValue();
});
function doSubmit(){
	if (v_NTPValid == 0){
		alert(JS_msg31);
		return false;
	}
	
	var postVar ={"topicurl":"setting/setRebootScheCfg"};
	postVar['ScheEn'] = $('#ScheEn').val();
	postVar['time_h'] = $('#time_h').val();
	postVar['time_m'] = $('#time_m').val();
	postVar['reSchWeek'] = $('#reSchWeek').val();
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
<tr><td class="content_help"><script>dw(MSG_schedule_reboot)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="ScheEn"id="ScheEn" onChange="updateStateSchReboot()">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr id="week" style="display:none">
<td class="item_left"><script>dw(MM_week)</script></td>
<td><select name="reSchWeek" id="reSchWeek">
<option value="255"><script>dw(MM_all)</script></option>
<option value="128"><script>dw(MM_week7)</script></option>
<option value="2"><script>dw(MM_week1)</script></option>
<option value="4"><script>dw(MM_week2)</script></option>
<option value="8"><script>dw(MM_week3)</script></option>
<option value="16"><script>dw(MM_week4)</script></option>
<option value="32"><script>dw(MM_week5)</script></option>
<option value="64"><script>dw(MM_week6)</script></option>
</select></td>
</tr>
<tr id="time" style="display:none">
<td class="item_left"><script>dw(MM_time)</script></td>
<td><select name="time_h" id="time_h"><script>dispalyFromHourOption();</script></select>&nbsp;:&nbsp;
<select name="time_m" id="time_m"><script>dispalyFromMinOption();</script></select>&nbsp;
(<script>dw(MM_hour)</script>:<script>dw(MM_min)</script>)</td>
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
