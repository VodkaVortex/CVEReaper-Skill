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
var v_ScheduleEn_wifi,v_Schedule_wifi_num,v_NTPValid;

function initValue(){	
	var rule= new Array();
	setJSONValue({ 
		'ScheduleEn_wifi':responseJson['ScheduleEn_wifi']
	});
	
	rule[0]=responseJson['Schedule_wifi_rule0'];
	rule[1]=responseJson['Schedule_wifi_rule1'];
	rule[2]=responseJson['Schedule_wifi_rule2'];
	rule[3]=responseJson['Schedule_wifi_rule3'];
	rule[4]=responseJson['Schedule_wifi_rule4'];
	rule[5]=responseJson['Schedule_wifi_rule5'];
	rule[6]=responseJson['Schedule_wifi_rule6'];
	rule[7]=responseJson['Schedule_wifi_rule7'];
	rule[8]=responseJson['Schedule_wifi_rule8'];
	rule[9]=responseJson['Schedule_wifi_rule9'];
	
	v_ScheduleEn_wifi=responseJson['ScheduleEn_wifi'];
	v_Schedule_wifi_num=responseJson['Schedule_wifi_num'];
	v_NTPValid=responseJson['NTPValid'];
	$("#SchEn").val(v_ScheduleEn_wifi);
	var strTmp="";
	var weekDay=[MM_week7,MM_week1,MM_week2,MM_week3,MM_week4,MM_week5,MM_week6,MM_all];
	for(var i=0;i<v_Schedule_wifi_num;i++){
		strTmp+="<tr align='center'><td class='item_center2'><font size='2'>\n";
		strTmp+="<input type='hidden' name='Enable_"+i+"' id='Enable_"+i+"'>\n";
		strTmp+="<input type='checkbox' name='wifiOn_"+i+"' id='wifiOn_"+i+"'></font></td>\n";
		strTmp+="<td class='item_center2'><font size='2'>\n";
		strTmp+="<select name='week"+i+"' id='week"+i+"' size='1'>\n";
		strTmp+="<option value='128'>"+weekDay[0]+"</option>\n";
		for(var j=1;j<=6;j++){
			strTmp +="<option value="+Math.pow(2,j)+">"+weekDay[j]+"</option>\n";
		}	
		strTmp+="<option value='255'>"+weekDay[7]+"</option>\n";
		strTmp+="</select> </font></td>\n";
		strTmp+="<td class='item_center2'><font size='2'>\n";
		strTmp+="<select name='time_h1"+i+"' id='time_h1"+i+"' size='1'>\n";
		for(var k=0;k<24;k++){
			if(k<10)
				strTmp +="<option value="+k+">"+"0"+k+"</option>\n";
			else
				strTmp+="<option value="+k+">"+k+"</option>\n";
		}
		strTmp+="</select>&nbsp;:&nbsp;\n";
		strTmp+="<select name='time_m1"+i+"' id='time_m1"+i+"' size='1'>\n";
		for(var h=0;h<60;h++){
			if(h<10)
				strTmp +="<option value="+h+">"+"0"+h+"</option>\n";
			else
				strTmp +="<option value="+h+">"+h+"</option>\n";
		}
		strTmp+="</select></font></td>\n";
		strTmp+="<td class='item_center2'><font size=2'>\n";
		strTmp+="<select name='time_h2"+i+"' id='time_h2"+i+"' size='1'>\n";
		for(var m=0;m<24;m++){
			if(m<10)
				strTmp +="<option value="+m+">"+"0"+m+"</option>\n";
			else
				strTmp+="<option value="+m+">"+m+"</option>\n";
		}	
		strTmp+="</select>&nbsp;:&nbsp;\n";
		strTmp+="<select name='time_m2"+i+"' id='time_m2"+i+"' size='1'>\n";
		for(var n=0;n<60;n++){
			if(n<10)
				strTmp +="<option value="+n+">"+"0"+n+"</option>\n";
			else
				strTmp +="<option value="+n+">"+n+"</option>\n";
		}
		strTmp+="</select></font></td></tr>\n";
	}
	$("#div_schlist").append(strTmp);

	for(var i=0;i<v_Schedule_wifi_num;i++){	
		$("#Schedule_wifi_rule_"+i).val(rule[i]);
		if(rule[i].split(",")[0]==1){
			$("#Enable_"+i).val("1");
			$("#wifiOn_"+i).attr("checked",true);
		}
		else{
			$("#Enable_"+i).val("0");
			$("#wifiOn_"+i).attr("checked",false);
		}
		
		$("#week"+i).val(rule[i].split(",")[1]);
		$("#time_h1"+i).val(rule[i].split(",")[2]);
		$("#time_m1"+i).val(rule[i].split(",")[3]);
		$("#time_h2"+i).val(rule[i].split(",")[4]);
		$("#time_m2"+i).val(rule[i].split(",")[5]);
	}
	if(v_ScheduleEn_wifi==1){
		$("#div_sch_rules").show();
		//if (v_NTPValid == 0){
			//alert(JS_msg31);
			//setDisabled("#apply", true);
		//}
	}else{
		$("#div_sch_rules").hide();
	}
}

$(function(){
	var postVar = { topicurl : "setting/getWiFiScheduleConfig"};
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

function updateState(){

	var postVar ={"topicurl":"setting/setWiFiScheduleConfig"};
	postVar['ScheduleEn_wifi']= $("#ScheduleEn_wifi").val();
	postVar['addEffect']= "1";
		
	uiPost(postVar);
}	

function doSubmit(){	
	if($("#ScheduleEn_wifi").val() == 1){	
			
		for(var i=0;i<v_Schedule_wifi_num;i++){
			if((parseInt($("#time_h1"+i).val())>parseInt($("#time_h2"+i).val())) || 
				(((parseInt($("#time_h1"+i).val())==parseInt($("#time_h2"+i).val()))&&
				(parseInt($("#time_m1"+i).val())>parseInt($("#time_m2"+i).val()))))){
				alert(JS_msg33);
				return false;
			}
					
			if($("#wifiOn_"+i).is(':checked'))
				$("#Enable_"+i).val("1");
			else
				$("#Enable_"+i).val("0");
		}		
	}			
	
	var postVar ={"topicurl":"setting/setWiFiScheduleConfig"};
	for(var i=0;i<10;i++){
		postVar['Enable_'+i] = $("#Enable_"+i).val();
		postVar['week'+i] = $("#week"+i).val();
		postVar['time_h1'+i] = $("#time_h1"+i).val();
		postVar['time_m1'+i] = $("#time_m1"+i).val();
		postVar['time_h2'+i] = $("#time_h2"+i).val();
		postVar['time_m2'+i] = $("#time_m2"+i).val();
	}
	postVar['addEffect']= "0";

	uiPost(postVar);
}	
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form name="wirelessSchedule" id="wirelessSchedule">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_wlsch_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_schedule_wifi)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select name="ScheduleEn_wifi" id="ScheduleEn_wifi"onChange="updateState();">
<option value=0><script>dw(MM_disable)</script></option>
<option value=1><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>

<div id="div_sch_rules" style="display:none">
<table border=0 width="100%" id="div_schlist">
<tr><td class="item_head" colspan="8"><script>dw(MM_wlsch_rule)</script></td></tr>
<tr><td colspan="8"><hr size=1 noshade align=top></td></tr>
<tr align="center">
<td class="item_center"><b><script>dw(MM_enable)</script></b></td>
<td class="item_center"><b><script>dw(MM_week)</script></b></td>
<td class="item_center"><b><script>dw(MM_start_time)</script>&nbsp;(<script>dw(MM_hour)</script>:<script>dw(MM_min)</script>)</b></td>
<td class="item_center"><b><script>dw(MM_end_time)</script>&nbsp;(<script>dw(MM_hour)</script>:<script>dw(MM_min)</script>)</b></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button id="apply" value="'+BT_apply+'" onClick="doSubmit()">')</script></td></tr>
</table>
</div>
</form>

<script>showFooter()</script>
</body></html>
