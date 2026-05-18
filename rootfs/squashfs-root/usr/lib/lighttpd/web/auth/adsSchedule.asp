<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script type="text/javascript">

var adstimetbl = "";//"<% getCustomization_List(); %>";
var showAdsList = ""//"<% getADSWebs_List(); %>";
function addClick()
{	
	var timestr="";
	var week;
	var countWeekdays=0;
	var weekdaysItem=getElements("weekdays");
	var timeItem=getElements("timeItem");
	var objSelect = document.getElementById("chooseRule");
	if(objSelect.options.length==0){
		alert(JS_choose_modePage);
		return false;
	}
	
	if(getElements('timeAllowed')[0].checked){//alway
		timestr="255,00:00,23:59";
	}
	else{
		for(var i=0;i< weekdaysItem.length;i++){
			if(weekdaysItem[i].checked){
			//	timestr += weekdaysItem[i].value+","
				week |= (0x1<<weekdaysItem[i].value);
			}
			else{
				countWeekdays++
			}
		}
		timestr=week;
		timestr += ","+timeItem[0].value+":"+timeItem[1].value;
		timestr += "-"+timeItem[2].value+":"+timeItem[3].value;
	}
	
	$("ScheduleTime").value=timestr;
	if(getElements('timeAllowed')[1].checked){//manual
		if(countWeekdays==7){
			alert(JS_choose_schedule_week);
			return false;
		}
		if(timeItem[0].value=="" || timeItem[1].value=="" || timeItem[2].value=="" || timeItem[3].value==""){
			alert(JS_choose_schedule_time);
			return false;
		}

		if (!validateDigitKey(timeItem[0].value) || !validateDigitKey(timeItem[1].value) || !validateDigitKey(timeItem[2].value) || !validateDigitKey(timeItem[3].value)) {
			alert(JS_choose_schedule_time_value);
			return false;
		}

		var time1 = parseInt(timeItem[0].value);
		var time2 = parseInt(timeItem[1].value);
		var time3 = parseInt(timeItem[2].value);
		var time4 = parseInt(timeItem[3].value);

		if (time1 > 23 || time2 >59 || time3 > 23 || time4 > 59) {
			alert(JS_choose_schedule_time_value);
			return false;
		}

		if (time1 > time3) {
			alert(JS_choose_schedule_hour);
			return false;
		}
		
		if (time1== time3)  {
			if (time2 > time4) {
				alert(JS_choose_schedule_minute);
				return false;
			}
		}		
	}	
	var stoptime=$("adsStopTime").value;
	if(!isEmpty(stoptime)){
		alert(MM_stop_time+JS_115);
		return false;
	}	
	if(!isNumberMsg(stoptime,MM_stop_time))
		return false;
		
	getAllItemValues("chooseRule",timestr);	
	if(!checkTime()) return false;
  	return true;
}

function selectToSelect(fromObjSelectId, toObjectSelectId) 
{  
 	var objSelect = document.getElementById(fromObjSelectId);
	var rightNode = document.getElementById("chooseRule");
 	var delNum = 0;
    if (null != objSelect && typeof(objSelect) != "undefined") {
    	for(var i=0;i<objSelect.options.length;i=i+1) {  
            if(objSelect.options[i].selected) {  
                addItemToSelect(toObjectSelectId,objSelect.options[i].text,objSelect.options[i].value)
                objSelect.options.remove(i);
                i = i - 1;
            }
			if(rightNode.length==1){
				document.getElementById("operationtor").disabled = true;
				break;
			}	
			else 
				document.getElementById("operationtor").disabled = false;
        }         
  	} 
}

function addItemToSelect(objSelectId,objItemText,objItemValue) 
{  
 	var objSelect = document.getElementById(objSelectId);
    if (null != objSelect && typeof(objSelect) != "undefined") {
     	if(0) {  //isSelectItemExit(objSelectId,objItemValue)
         	alert(JS_choose_schedule_rule);
     	}  
		else  {
         	var varItem = new Option(objItemText,objItemValue);  
         	objSelect.options.add(varItem);  
     	}  
    } 
}

function isSelectItemExit(objSelectId,objItemValue)  
{  
 	var objSelect = document.getElementById(objSelectId);
    var isExit = false;  
    if (null != objSelect && typeof(objSelect) != "undefined") {
     	for(var i=0;i<objSelect.options.length;i++) {  
         	if(objSelect.options[i].value == objItemValue) {  
             	isExit = true;  
             	break;  
         	}  
     	}  
    }
    return isExit; 
}
 
function clearSelect(objSelectId) 
{  
 	var objSelect = document.getElementById(objSelectId);
   	if (null != objSelect && typeof(objSelect) != "undefined") {
        for(var i=0;i<objSelect.options.length;) {  
          	objSelect.options.remove(i);  
        }         
    } 
}

function changeTime()
{
	var timeIetm = getElements("timeAllowed");
	if(timeIetm[0].checked){
		//$("weekID").style.display="none";
		$("timeID").style.display="none";	
	}
	else{
		//$("weekID").style.display="";
		$("timeID").style.display="";	
	}
}
//var weekdaystr=[' ',MM_mon,MM_tue,MM_wed,MM_thu,MM_fri,MM_sat,MM_sun];
var weekdaystr={'Mon':MM_week1,'Tue':MM_week2,'Wed':MM_week3,'Thu':MM_week4,'Fri':MM_week5,'Sat':MM_week6,'Sun':MM_week7};

function formmatTime(tmv)
{
	var timeStr=tmv.split("|");
	var weeks=timeStr[1];
	var fromTime=timeStr[2];
	var toTime=timeStr[3];
	var timeSring="";
	weeks=weeks.split(",");
	for(var i=0;i<weeks.length;i++){
		timeSring+=weekdaystr[weeks[i]]+",";
	}
	timeSring=timeSring.substring(0,timeSring.lastIndexOf(','));
	return timeSring+=" "+fromTime+"-"+toTime;
}

function showFilterList()
{
	var showSchedule=$("scheduleList");
	var trNode={};
	var tdNode={};
	var schTime="";
	var itemText="";
	var itemValue="";
	var obj={};
	clearSelect("chooseRule");
	clearSelect("ruleList");

	if (adstimetbl!="")
	{
		var custompage=adstimetbl.split(",");
		for(var i=0;i<custompage.length-1;i++){
			itemText = custompage[i];
			itemValue = custompage[i];
			addItemToSelect('ruleList',itemText,itemValue);
		}
	}
	if(showAdsList!=""){
		var adsList=showAdsList.split(";");
		for(var i=0;i<adsList.length-1;i++){
			for(var i=0;i<adsList.length-1;i++){
				trNode=showSchedule.insertRow(-1);
				var adsPart=adsList[i].split(",");
				trNode.insertCell(0).innerHTML=adsPart[1];
				trNode.insertCell(1).innerHTML=adsPart[2];
				trNode.insertCell(2).innerHTML=adsPart[4];
				trNode.insertCell(3).innerHTML='<input type=\"checkbox\" name=\"select'+adsPart[3]+'\" value=\"'+adsPart[3]+'\" >';
			}
		}
	
	}
/*	var scheduleLen=showSchedule.rows.length;
	var submitStr="";
	var timeStr="";
	var weekSrt="";
	var fromto=""
	var tmp="";
	for(var k=0;k<scheduleLen;k++){
		if(showSchedule.rows[k].cells[0].innerHTML == "--"){
			submitStr=showSchedule.rows[k].cells[3].innerHTML;
			submitStr+="|"+showSchedule.rows[k].cells[4].innerHTML;
		}
		else{
			submitStr=showSchedule.rows[k].cells[0].innerHTML+",";
			submitStr+=showSchedule.rows[k].cells[1].innerHTML+",";
			submitStr+=showSchedule.rows[k].cells[2].innerHTML;	
			submitStr+="|"+showSchedule.rows[k].cells[4].innerHTML;
		}
		timeStr=showSchedule.rows[k].cells[4].innerHTML;
		tmp="";
		if(timeStr != "Mon Tue Wed Thu Fri Sat Sun 00:00-23:59"){
			weekSrt=timeStr.split(" ");
			for(var m=0;m<weekSrt.length-1;m++){
				tmp+=weekdaystr[weekSrt[m]]+" ";
			}
			timeStr=tmp+weekSrt[weekSrt.length-1];
		}
		else{
			timeStr = MM_always;
		}
		showSchedule.rows[k].cells[4].innerHTML=timeStr;
	}
	showSchedule.style.display = "";*/
}

function getAllItemValues(objSelectId,timestr) 
{
	var submitValue="";
 	var objSelect = document.getElementById(objSelectId);
 	var objSchedule = document.getElementById("submitFilterList");
 	var tmpNode={};

 	if (null != objSelect && typeof(objSelect) != "undefined") {
      	var length = objSelect.options.length
        for(var i = 0; i < length; i = i + 1) {  
			submitValue+=objSelect.options[i].value+","+timestr+";";
        }   
		tmpNode = document.createElement("input");
		tmpNode.setAttribute( "type" , "text") ;
		tmpNode.setAttribute( "name" , "scheduleRulesList") ;
		tmpNode.setAttribute( "value" , submitValue) ;
		objSchedule.appendChild(tmpNode);		
   	}  
  	return true;
}

function chooseDel()
{

}

function getAllDelItem(timestr)
{
	var objScheduleDel = document.getElementById("submitDelList");
	var tmpNode={};
	var submitValue="";
	var delList=getElements("scheduleDel");
	for(var i=0;i<delList.length;i++){
		if(delList[i].checked){	
			submitValue+=delList[i].value+","+timestr+";";
		}	
	}
	tmpNode = document.createElement("input");
	tmpNode.setAttribute( "type" , "text") ;
	tmpNode.setAttribute( "name" , "scheduleDelRulesList") ;
	tmpNode.setAttribute( "value" , submitValue) ;
	objScheduleDel.appendChild(tmpNode);	
}

function deleteClick()
{
	if ( !confirm(JS_delete_select_entry) )	return false;
  	else {
		$("ScheduleTime1").value="255,00:00-23:59";//0|1,2,3,4,5,6,7|00:00:00|23:59:59
		getAllDelItem("255,00:00-23:59");
		return true;
	}
}

function disableDelButton()
{
	for (var i=0;i<document.forms[0].length;i++)
		document.forms[0].elements[i].disabled = true;
			
	for (var i=0;i<document.forms[1].length;i++)
		document.forms[1].elements[i].disabled = true;
}

function Load_Setting()
{
	changeTime();
	showFilterList();
	
	if (adstimetbl == "")
		disableDelButton();
}
function addAuthParame(){
	var passtime=$("authPassTime").value;
	if(!isEmpty(passtime)){
		alert(MM_hotspot_passTime+JS_115);
		return false;
	}	
	if(!isNumberMsg(passtime,MM_hotspot_passTime))
		return false;
	var idleOfftime=$("idleOffTime").value;
	if(!isEmpty(idleOfftime)){
		alert(MM_hotspot_idleOffTime+JS_115);
		return false;
	}	
	if(!isNumberMsg(idleOfftime,MM_hotspot_idleOffTime))
		return false;
		
	return true;
}
function checkTime()
{
	var time_tmp = showAdsList.split(";");
	var timeItem = getElements("timeItem");
	var starttime = parseInt(timeItem[0].value)*60+parseInt(timeItem[1].value);
	var endtime = parseInt(timeItem[2].value)*60+parseInt(timeItem[3].value);
	//alert(parseInt(time_tmp[0].split(",")[2].split("-")[0].split(":")[0])*60+parseInt(time_tmp[0].split(",")[2].split("-")[0].split(":")[1]));
//	alert(time_tmp.length-1);
	if(showAdsList != "")
	{
		for(var i = 0;i<(time_tmp.length-1);i++)
		{
	//		alert(i);
			if(starttime < (parseInt(time_tmp[i].split(",")[2].split("-")[1].split(":")[0])*60+parseInt(time_tmp[i].split(",")[2].split("-")[1].split(":")[1]))
			  && endtime > (parseInt(time_tmp[i].split(",")[2].split("-")[0].split(":")[0])*60+parseInt(time_tmp[i].split(",")[2].split("-")[0].split(":")[1])))
			{
				alert(JS_184);
				return false;		
			}
		}	
	}
	return true;
}
</script>
</head>

<body onLoad="Load_Setting();" class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form action="/goform/formADSWebs" method=POST name="formFilterAdd">
<input type="hidden" name="ScheduleTime" id="ScheduleTime">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_ads_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_ads_rule_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr align="center">
<td><b><script>dw(MM_ads_list)</script></b></td>
<td>&nbsp;</td>
<td><b><script>dw(MM_ads_select_list)</script></b></td>
</tr>
<tr>
<td><select id="ruleList" size="15" style="width:300px;height:230px;" ><option value="1"></option></select></td> 
<td align="center"><input type="button" name="operationtol" value="&nbsp;&nbsp;<<&nbsp;&nbsp;" onClick="selectToSelect('chooseRule','ruleList');">&nbsp;&nbsp;&nbsp;&nbsp;</br><input type="button" name="operationtor" id="operationtor" value="&nbsp;&nbsp;>>&nbsp;&nbsp;" onClick="selectToSelect('ruleList','chooseRule');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><select id="chooseRule" size="15" style="width:300px;height:230px;"><option value="1"></option></select></td>
</tr>
</table>

<table width="100%" border="0">
<tr><td class="item_left">&nbsp;</td></tr>
<tr style="display:none;">
<td class="item_left"><script>dw(MM_schedule)</script></td>
<td align="left" colspan="2"><input type="radio" name="timeAllowed" id="timeAllowed1" onClick="changeTime(this);" value="1" > <script>dw(MM_always)</script>
<input type="radio" name="timeAllowed" id="timeAllowed2" onClick="changeTime(this);" value="2" checked> <script>dw(MM_manual)</script></td>
</tr>
<tr id="weekID" style="display:none">
<td class="item_left"><script>dw(MM_week)</script></td>
<td align="left" colspan="2"><input type="checkbox" name="weekdays" value="1" checked> <script>dw(MM_week1)</script>&nbsp;
<input type="checkbox" name="weekdays" value="2" checked> <script>dw(MM_week2)</script>&nbsp;
<input type="checkbox" name="weekdays" value="3" checked> <script>dw(MM_week3)</script>&nbsp;
<input type="checkbox" name="weekdays" value="4" checked> <script>dw(MM_week4)</script>&nbsp;
<input type="checkbox" name="weekdays" value="5" checked> <script>dw(MM_week5)</script>&nbsp;
<input type="checkbox" name="weekdays" value="6" checked> <script>dw(MM_week6)</script>&nbsp;
<input type="checkbox" name="weekdays" value="7" checked> <script>dw(MM_week7)</script></td>
</tr>
<tr id="timeID">
<td class="item_left"><script>dw(MM_time)</script></td>
<td align="left" colspan="2"><input type="text" name="timeItem" style="width:28px" maxlength="2">:
<input type="text" name="timeItem" style="width:28px" maxlength="2">&nbsp;&nbsp;--&nbsp;&nbsp;
<input type="text" name="timeItem" style="width:28px" maxlength="2">:
<input type="text" name="timeItem" style="width:28px" maxlength="2">&nbsp;&nbsp;&nbsp;&nbsp;(HH:MM -- HH:MM)</td>
</tr>
<tr id="">
<td class="item_left"><script>dw(MM_stop_time)</script></td>
<td align="left" colspan="2">
<input type="text" name="adsStopTime" id="adsStopTime" size=32 maxlength="16">&nbsp;&nbsp;&nbsp;&nbsp;<script>dw(MM_seconds)</script></td>
</tr>
</table>

<div id="submitFilterList" style="display:none;"></div>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_apply+'" name="addAds" onClick="return addClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetFilterUrl" onClick="resetForm()">')</script></td>
</tr>
</table>
<input type="hidden" value="/auth/adsSchedule.asp" name="submit-url">
</form>

<br>
<form action="/goform/formADSWebs" method=POST name="formFilterDel">
<input type="hidden" name="ScheduleTime" id="ScheduleTime1">
<table border=0 width="100%">
<tr><td class="item_head" colspan="3"><script>dw(MM_rule_schedule_list)</script></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_ads_name)</script></b></td>
<td class="item_center"><b><script>dw(MM_time)</script></b></td>
<td class="item_center"><b><script>dw(MM_stop_time)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="scheduleList" align="center">

</tbody>
</table>

<div id="submitDelList" style="display:none;"></div>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_delete+'" name="deleteAds" onClick="return deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetSel" onClick="resetForm()">')</script></td>
</tr>
</table>

<input type="hidden" value="/auth/adsSchedule.asp" name="submit-url">
</form>

</td></tr>
<tr><td>
<form action="/goform/formSetAuthParame" method=POST name="formFilterAdd">
<table border=0 width="100%">
<tr><td class="item_head"><script>dw(MM_AuthParame)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table width="100%" border="0">
<tr id="">
<td class="item_left"><script>dw(MM_hotspot_passTime)</script></td>
<td align="left" colspan="2">
<input type="text" name="authPassTime" id="authPassTime" size=32 maxlength="16" value="<% getCfgGeneral(1, "authPassTime"); %>">&nbsp;&nbsp;&nbsp;&nbsp;<script>dw(MM_seconds)</script></td>
</tr>
<tr id="">
<td class="item_left"><script>dw(MM_hotspot_idleOffTime)</script></td>
<td align="left" colspan="2">
<input type="text" name="idleOffTime" id="idleOffTime" size=32 maxlength="16" value="<% getCfgGeneral(1, "idleOffTime"); %>">&nbsp;&nbsp;&nbsp;&nbsp;<script>dw(MM_seconds)</script></td>
</tr>
</table>
<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="submit" class="button" value="'+BT_apply+'" name="SetAuthParame" onClick="return addAuthParame()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetAuthParame" onClick="resetForm()">')</script></td>
</tr>
</table>
<input type="hidden" value="/auth/adsSchedule.asp" name="submit-url">
</form>
</td></tr>
</table>
</body>
</html>
