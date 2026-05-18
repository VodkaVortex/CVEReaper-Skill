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
var languageType='cn';
var responseJson;
var v_opmode,v_current_time,v_ntp_client_enabled,v_tz,v_NTPHostFlag;
function getLeapYearState(year){
	if ( (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) )
		return 1;
	else
		return 0;
}
function getMonthLength(mm, leap){
	if (mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10 || mm == 12)
		return 31;
	else if (mm == 4 || mm == 6 || mm == 9 || mm == 11)
		return 30;
	else {
		if (leap == 1)
			return 29;
		else
			return 28;	
	}
}
function getDateString(str){
	var month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	var yy, mo, dd, hh, mi, ss;	
	var s1, s2;
	if ((str.substring(8,9)) == " "){
		s1=str.substring(0,8);
		s2=str.substring(9,str.length);
		str=s1.concat(s2);
	}else {
		str = str;
	}	
	
	var p = str.split(" ");
	yy = p[5];
	for (var j=0; j<12; j++) {
		if (p[1] == month[j]) 
			mo = j + 1;
	}

	dd = p[2];
	hh = p[3].split(":")[0];
	mi = p[3].split(":")[1];
	ss = p[3].split(":")[2];

	setJSONValue({
		'cn_yy'			:	yy,
		'cn_mo'			:	mo,
		'cn_dd'         :   dd,
		'cn_hh'         :   hh,
		'cn_mi'         :	mi,
		'cn_ss'         :	ss,
		'en_yy'			:	yy,
		'en_mo'			:	mo,
		'en_dd'         :   dd,
		'en_hh'         :   hh,
		'en_mi'         :	mi,
		'en_ss'         :	ss
	});
}
function saveChanges(){
	$("#NTPClientEnabled").focus();
	var ntpserverNum = 0;
	if ($("#NTPClientEnabled").is(':checked')) {
		if (($("#NTPServerIP1").val()).length==0){
			alert(MM_ntp_server + "1" + JS_msg1);
			return false;
		}
		if (!checkVaildVal.isString( $("#NTPServerIP1").val())){
			alert(MM_ntp_server + JS_msg98);
			return false;
		}else{
			NTPServerIP = $("#NTPServerIP1").val();
 		}
		if($("#NTPServerIP2").val()!=""){	
			if(!checkVaildVal.isString($("#NTPServerIP2").val())){
				alert(MM_ntp_server + "2" + JS_msg98);
				return false;
			}else{
				NTPServerIP += " -h "+$("#NTPServerIP2").val();
			}
		}
		if($("#NTPServerIP3").val()!=""){
			if($("#NTPServerIP2").val().length==0){
				alert(MM_ntp_server + "2" + JS_msg1);
				return false;
			}
			if(!checkVaildVal.isString($("#NTPServerIP3").val())){
				alert(MM_ntp_server + "3" + JS_msg98);
				return false;
			}else{
				NTPServerIP += " -h "+$("#NTPServerIP3").val();
			}
		}
	}
	return true;
}
function updateState(){	
	if ($("#NTPClientEnabled").is(':checked')){
		$("#NTPServerIP1,#NTPServerIP2,#NTPServerIP3").attr('disabled',false);
		$("#NTPClientEnabled").val("ON");
	}
	else{
		$("#NTPServerIP1,#NTPServerIP2,#NTPServerIP3").attr('disabled',true)
		$("#NTPClientEnabled").val("");
	}
}
function initValue(){	
	v_tz=responseJson['TZ'];
	v_opmode=responseJson['OperationMode'];
	v_current_time=responseJson['CurrentTime'];
	v_ntp_client_enabled=responseJson['NTPClientEnabled'];
	
	setJSONValue({
		"ntpcurrenttime"	: v_current_time,
		"NTPSync"	   		: responseJson['NTPSync'],
		"time_zone"         : v_tz
	});
	v_NTPServerIP=responseJson['NTPServerIP'];
			var substringArray = v_NTPServerIP.split(" -h ");
			$("#NTPServerIP1").val(substringArray[0]);
			$("#NTPServerIP2").val(substringArray[1]);
			$("#NTPServerIP3").val(substringArray[2]);
	if (v_ntp_client_enabled == 1)
		$("#NTPClientEnabled").attr('checked',true);
	
	if (languageType == 'cn') {
		$("#div_date_cn").show();
		$("#div_date_en").hide();
		getDateString(v_current_time);
	}else {
		$("#div_date_cn").hide();
		$("#div_date_en").show();
		getDateString(v_current_time);
	}

	updateState();
}
$(function(){
	var postVar = {topicurl : "setting/getNTPCfg"};
	postVar = JSON.stringify(postVar);
	$.when( $.post("/cgi-bin/cstecgi.cgi", postVar))
    .done(function( Data) {
		responseJson = JSON.parse(Data);
		initValue();
	})
	.fail(function(){
		resetForm();
	});
	return;
});
function doSubmit(){
	if(saveChanges()==false) return false;
	var postVar ={"topicurl":"setting/setNTPCfg"};
	postVar['time_zone'] = $("#time_zone").val();
	postVar['NTPSync'] = $("#NTPSync").val();
	postVar['NTPServerIP']=NTPServerIP;
	postVar['NTPClientEnabled'] = $("#NTPClientEnabled").val();
	uiPost(postVar);
}
function syncWithHost(){
	var currentTime = new Date();
	var seconds = currentTime.getSeconds();
	var minutes = currentTime.getMinutes();
	var hours = currentTime.getHours();
	var month = currentTime.getMonth() + 1;
	var day = currentTime.getDate();
	var year = currentTime.getFullYear();

	var seconds_str = " ";
	var minutes_str = " ";
	var hours_str = " ";
	var month_str = " ";
	var day_str = " ";
	var year_str = " ";

	if(seconds < 10)
		seconds_str = "0" + seconds;
	else
		seconds_str = ""+seconds;

	if(minutes < 10)
		minutes_str = "0" + minutes;
	else
		minutes_str = ""+minutes;

	if(hours < 10)
		hours_str = "0" + hours;
	else
		hours_str = ""+hours;

	if(month < 10)
		month_str = "0" + month;
	else
		month_str = ""+month;

	if(day < 10)
		day_str = "0" + day;
	else
		day_str = day;

	setJSONValue({
		'cn_yy'			:	year,
		'cn_mo'			:	month_str,
		'cn_dd'         :   day_str,
		'cn_hh'         :   hours_str,
		'cn_mi'         :	minutes_str,
		'cn_ss'         :	seconds_str,
		'en_yy'			:	year,
		'en_mo'			:	month_str,
		'en_dd'         :   day_str,
		'en_hh'         :   hours_str,
		'en_mi'         :	minutes_str,
		'en_ss'         :	seconds_str
	});

    //2007-08-03 14:15:34
	var tmp =year + '-' + month_str + '-' + day_str + ' ' + hours_str + ':' + minutes_str  + ':' + seconds_str;
	return tmp;
}
function postWithHost(){
	var tmp=syncWithHost();
	var postVar ={"topicurl":"setting/NTPSyncWithHost"};
	postVar['host_time'] = tmp;	
	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method="post" name="ntpCfg" id="ntpCfg">
<input type="hidden" name="ntpcurrenttime" id="ntpcurrenttime" >
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_ntp_setting)</script></td></tr>
<tr id="div_content_help"><td class="content_help"><script>dw(MSG_ntp_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr id="div_date_cn">
<td class="item_left"><script>dw(MM_current_time)</script></td>
<td><input type="text" style="width:44px" maxlength="4" name="cn_yy" readonly> -
<input type="text" style="width:28px" maxlength="4" name="cn_mo" readonly> -
<input type="text" style="width:28px" maxlength="2" name="cn_dd" readonly>&nbsp;&nbsp;
<input type="text" style="width:28px" maxlength="2" name="cn_hh" readonly> :
<input type="text" style="width:28px" maxlength="2" name="cn_mi" readonly> :
<input type="text" style="width:28px" maxlength="2" name="cn_ss" readonly><br> (<script>dw(MM_date_chinese)</script>)</td>
</tr>
<tr id="div_date_en" style="display:none">
<td class="item_left"><script>dw(MM_current_time)</script></td>
<td><input type="text" style="width:28px" maxlength="2" name="en_mo" readonly> -
<input type="text" style="width:28px" maxlength="2" name="en_dd" readonly> -
<input type="text" style="width:44px" maxlength="4" name="en_yy" readonly>&nbsp;&nbsp;
<input type="text" style="width:28px" maxlength="2" name="en_hh" readonly> :
<input type="text" style="width:28px" maxlength="2" name="en_mi" readonly> :
<input type="text" style="width:28px" maxlength="2" name="en_ss" readonly><br> (<script>dw(MM_date_english)</script>)</td>
</tr>
<tr>
<td class="item_left">&nbsp;</td>
<td><script>dw('<input type="button" value="'+BT_copy_pc_time+'" name="manNTPSyncWithHost" onClick="postWithHost()">')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_time_zone)</script></td>
<td><select name="time_zone" id="time_zone">
<option value="UTC+12">(UTC-12:00)<script>dw(MM_ntp1)</script></option>
<option value="UTC+11">(UTC-11:00)<script>dw(MM_ntp2)</script></option>
<option value="UTC+10">(UTC-10:00)<script>dw(MM_ntp3)</script></option>
<option value="UTC+9">(UTC-09:00)<script>dw(MM_ntp4)</script></option>
<option value="UTC+8">(UTC-08:00)<script>dw(MM_ntp5)</script></option>
<option value="UTC+7">(UTC-07:00)<script>dw(MM_ntp6)</script></option>
<option value="UTC+6">(UTC-06:00)<script>dw(MM_ntp7)</script></option>
<option value="UTC+5">(UTC-05:00)<script>dw(MM_ntp8)</script></option>
<option value="UTC+4">(UTC-04:00)<script>dw(MM_ntp9)</script></option>
<option value="UTC+3">(UTC-03:00)<script>dw(MM_ntp10)</script></option>
<option value="UTC+2">(UTC-02:00)<script>dw(MM_ntp11)</script></option>
<option value="UTC+1">(UTC-01:00)<script>dw(MM_ntp12)</script></option>
<option value="UTC+0">(UTC+0)<script>dw(MM_ntp13)</script></option>
<option value="UTC-1">(UTC+01:00)<script>dw(MM_ntp14)</script></option>
<option value="UTC-2">(UTC+02:00)<script>dw(MM_ntp15)</script></option>
<option value="UTC-3">(UTC+03:00)<script>dw(MM_ntp16)</script></option>
<option value="UTC-4">(UTC+04:00)<script>dw(MM_ntp17)</script></option>
<option value="UTC-5">(UTC+05:00)<script>dw(MM_ntp18)</script></option>
<option value="UTC-6">(UTC+06:00)<script>dw(MM_ntp19)</script></option>
<option value="UTC-7">(UTC+07:00)<script>dw(MM_ntp20)</script></option>
<option value="UTC-8">(UTC+08:00)<script>dw(MM_ntp21)</script></option>
<option value="UTC-9">(UTC+09:00)<script>dw(MM_ntp22)</script></option>
<option value="UTC-10">(UTC+10:00)<script>dw(MM_ntp23)</script></option>
<option value="UTC-11">(UTC+11:00)<script>dw(MM_ntp24)</script></option>
<option value="UTC-12">(UTC+12:00)<script>dw(MM_ntp25)</script></option>
</select></td>
</tr>
<tr>
<td class="item_left">&nbsp;</td>
<td><input type="checkbox" name="NTPClientEnabled"  id="NTPClientEnabled" onClick="updateState()"> <script>dw(MM_ntp_client_update)</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ntp_server+" 1")</script></td>
<td><input type="text" maxlength="32"  id="NTPServerIP1">&nbsp;&nbsp;<font color="#808080">ex:&nbsp;pool.ntp.org</font></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ntp_server+" 2")</script></td>
<td><input type="text" maxlength="32" name="NTPServerIP" id="NTPServerIP2">&nbsp;&nbsp;</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_ntp_server+" 3")</script></td>
<td><input type="text" maxlength="32" name="NTPServerIP" id="NTPServerIP3">&nbsp;&nbsp;</td>
</tr>
<tr style="display:none">
<td class="item_left"><script>dw(MM_ntp_time)</script></td>
<td><input type="text" size="4" maxlength="3" name="NTPSync" id="NTPSync" value="24"> <script>dw(MM_hour)</script></td></tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</form>
<script>showFooter()</script>
</body></html>
