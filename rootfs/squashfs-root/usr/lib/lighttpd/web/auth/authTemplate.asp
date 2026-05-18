<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="../style/normal_ws.css" type="text/css">
<link rel="stylesheet" href="../style/line.css" type="text/css">
<script language="javascript" src="../js/language.js"></script>
<script language="javascript" src="../js/common.js"></script>
<script language="javascript" src="../js/jquery.min.js"></script>
<script language="javascript" src="../js/json2.min.js"></script>
<script type="text/javascript">

var adstimetbl;
var showAdsList;
var responseJsonCus,responseJsonADSUrl;
function addClick()
{	
	var timestr="";
	var week;
	var countWeekdays=0;
	var weekdaysItem=getElements("weekdays");
	var timeItem=getElements("timeItem");
/*	var objSelect = document.getElementById("chooseRule");
	if(objSelect.options.length==0){
		alert(JS_choose_modePage);
		return false;
	}*/
	
	if(getElements('timeAllowed')[0].checked){//alway
		timestr="255,00:00-23:59";
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
	
	document.getElementById("ScheduleTime").value=timestr;
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
	var stoptime=document.getElementById("adsStopTime").value;
	if(!isEmpty(stoptime)){
		alert(MM_stop_time+JS_115);
		return false;
	}	
	if(!isNumberMsg(stoptime,MM_stop_time))
		return false;
		
//	getAllItemValues("chooseRule",timestr);	
	getChooseItemValues("ruleList",timestr);
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
	var timeItem = getElements("timeItem");
	if(timeIetm[0].checked){
		//$("weekID").style.display="none";
		document.getElementById("timeID").style.display="none";		
		timeItem[0].value="00";
		timeItem[1].value="00";
		timeItem[2].value="23";
		timeItem[3].value="59";
	}
	else{
		//$("weekID").style.display="";
		document.getElementById("timeID").style.display="";	
		timeItem[0].value="";
		timeItem[1].value="";
		timeItem[2].value="";
		timeItem[3].value="";
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
	var showSchedule=document.getElementById("scheduleList");
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
var submitAddValue="";
function getChooseItemValues(objSelectId,timestr) 
{
 	var objSelect = document.getElementById(objSelectId);
 	var objSchedule = document.getElementById("submitFilterList");
 	var tmpNode={};

 	if (null != objSelect && typeof(objSelect) != "undefined") {
      	var length = objSelect.options.length
        for(var i = 0; i < length; i = i + 1) { 
			if(objSelect.options[i].selected)
				submitAddValue+=objSelect.options[i].value+","+timestr+";";
        }   
		tmpNode = document.createElement("input");
		tmpNode.setAttribute( "type" , "text") ;
		tmpNode.setAttribute( "name" , "scheduleRulesList") ;
		tmpNode.setAttribute( "value" , submitAddValue) ;
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
		document.getElementById("ScheduleTime1").value="255,00:00-23:59";//0|1,2,3,4,5,6,7|00:00:00|23:59:59
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
//	showFilterList();
	
	if (adstimetbl == "")
		disableDelButton();
}
function addAuthParame(){
	var passtime=document.getElementById("authPassTime").value;
	if(!isEmpty(passtime)){
		alert(MM_hotspot_passTime+JS_115);
		return false;
	}	
	if(!isNumberMsg(passtime,MM_hotspot_passTime))
		return false;
	var idleOfftime=document.getElementById("idleOffTime").value;
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
	var timeItem = getElements("timeItem");
	var starttime = parseInt(timeItem[0].value)*60+parseInt(timeItem[1].value);
	var endtime = parseInt(timeItem[2].value)*60+parseInt(timeItem[3].value);
	for(var i = 1;i<responseJsonADSUrl.length;i++)
	{
		if(starttime < (parseInt(responseJsonADSUrl[i].adstime.split("-")[1].split(":")[0])*60+parseInt(responseJsonADSUrl[i].adstime.split("-")[1].split(":")[1]))
		  && endtime > (parseInt(responseJsonADSUrl[i].adstime.split("-")[0].split(":")[0])*60+parseInt(responseJsonADSUrl[i].adstime.split("-")[0].split(":")[1])))
		{
			alert(JS_184);
			return false;		
		}
	}	
	return true;
}
function initCusList(){
	clearSelect("ruleList");
	for(var i=1;i<responseJsonCus.length;i++){
		itemText = responseJsonCus[i].URL;
		itemValue = responseJsonCus[i].URL;
		addItemToSelect('ruleList',itemText,itemValue);
		adstimetbl+=responseJsonCus[i].URL+",";
	}
	Load_Setting();
}
function initADSUrlList(){
	var ADSUrlList=$("#scheduleList").get(0);
	var trNode,tdNode;
	for(var i=1;i<responseJsonADSUrl.length;i++){
		trNode=ADSUrlList.insertRow(-1);
		trNode.align="center";
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].ADsID;
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].adstime;
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].adsStopTime;
		tdNode=trNode.insertCell(3);
		tdNode.className="item_center2";
		tdNode.innerHTML='<input type=\"checkbox\" id=\"'+responseJsonADSUrl[i].delItemName+'\" name=\"'+responseJsonADSUrl[i].delItemName+'\" value=\"ON\">';
	}
}
$(function(){
	var postVarAds = { topicurl : "setting/getCustomization_List"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJsonCus = JSON.parse(Data);
			initCusList();			
		}
    });	
	var postVarAdsUrl = { topicurl : "setting/getADSWebs_List"};
    postVarAdsUrl = JSON.stringify(postVarAdsUrl);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAdsUrl,  
        async : true,  
        success : function(Data){
			responseJsonADSUrl = JSON.parse(Data);
			initADSUrlList();			
		}
    });
});

function deleteAdsURLFun(){
	var postVar ={"topicurl":"setting/formADSWebs"};
	postVar['deleteAds']= "del";
	var flg=0;
	for (i=0; i< responseJsonADSUrl.length-1; i++) {		
		var tmpNode=$("#select"+i).get(0);
		if (tmpNode.checked == true){
			postVar[tmpNode.name]=tmpNode.value;
			flg=1;
		}
  	}
	if(flg==0){
		alert(JS_18);
		return false;
	}
	
	uiPost(postVar);
	return true;
}
function doSubmit(){
	if(addClick()==false)
		return false;
	var postVar ={"topicurl":"setting/formADSWebs"};
	postVar['addAds']= "add";
	postVar['scheduleRulesList']=submitAddValue;
	postVar['adsStopTime']=$("#adsStopTime").val();
	
	uiPost(postVar);
}
</script>
</head>

<body onLoad="Load_Setting();" class="mainbody">
<script>showLanguageLabel()</script>
<table width="700"><tr><td>
<form action="" method=POST name="formFilterAdd">
<input type="hidden" name="ScheduleTime" id="ScheduleTime">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_ads_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_ads_rule_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%" style="display:none;">
<tr align="center">
<td><b><script>dw(MM_ads_list)</script></b></td>
<td>&nbsp;</td>
<td><b><script>dw(MM_ads_select_list)</script></b></td>
</tr>
<tr>
<td><select id="ruleList_dis" size="15" style="width:300px;height:230px;" ><option value="1"></option></select></td> 
<td align="center"><input type="button" name="operationtol" value="&nbsp;&nbsp;<<&nbsp;&nbsp;" onClick="selectToSelect('chooseRule','ruleList');">&nbsp;&nbsp;&nbsp;&nbsp;</br><input type="button" name="operationtor" id="operationtor" value="&nbsp;&nbsp;>>&nbsp;&nbsp;" onClick="selectToSelect('ruleList','chooseRule');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><select id="chooseRule" size="15" style="width:300px;height:230px;"><option value="1"></option></select></td>
</tr>
</table>

<table width="100%" border="0">
<tr><td class="item_left">&nbsp;</td></tr>
<tr>
<td class="item_left"><script>dw(MM_ads_template)</script></td>
<td ><select id="ruleList" style="width:230px;" ><option value="1"></option></select></td>
</tr>
<tr style="">
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
<td align="center"><script>dw('<input type="button" class="button" value="'+BT_apply+'" name="addAds" onClick="return doSubmit()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetFilterUrl" onClick="resetForm()">')</script></td>
</tr>
</table>
<input type="hidden" value="/auth/authTemplate.asp" name="submit-url">
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
<td align="center"><script>dw('<input type="button" class="button" value="'+BT_delete+'" name="deleteAds" onClick="return deleteAdsURLFun()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetSel" onClick="resetForm()">')</script></td>
</tr>
</table>

<input type="hidden" value="/auth/authTemplate.asp" name="submit-url">
</form>

</td></tr>
</table>
</body>
</html>
