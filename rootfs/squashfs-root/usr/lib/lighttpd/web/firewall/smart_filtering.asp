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
var entries=new Array();
var lanip;
var lanmsk;
var netip;
var rules_num;
var responseJsonLan,responseJson;
function deleteClick()
{
   	for (i=0; i< rules_num; i++)
	{
		var tmp = eval("document.formCLQosDel.delRule"+i);
		if (tmp.checked == true) return true;
	}
	alert(JS_msg36);
	return false;
}

function IpRangeCheck(s1,s2)
{
	var ip1=s1.split(".");
	var ip2=s2.split(".");
	for(var k=0;k<4;k++)
	{
		var a=Number(ip1[3]);
		var b=Number(ip2[3]);
      		if(a>b) {alert(JS_msg100); return 0;}
	}
	return 1;
}

function addClick()
{
	if ( rules_num >= 10 ) 
	{
		alert(JS_msg28);
		return false;
	}
		
	document.l7FilterAdd.ipStart.value = netip+document.l7FilterAdd.ipstart.value;
	document.l7FilterAdd.ipEnd.value = netip+document.l7FilterAdd.ipend.value;
	if (!checkVaildVal.IsVaildIpAddr(document.l7FilterAdd.ipStart.value, MM_start_ipaddr)) 
		return false;		
	if (!checkVaildVal.IsIpSubnet(document.l7FilterAdd.ipStart.value, lanmsk, lanip)) 
	{
		alert(JS_msg38);
		return false;
	}		
	if (document.l7FilterAdd.ipStart.value == lanmsk) 
	{
		alert(JS_msg39);
		return false;
	}		
	if(document.l7FilterAdd.ipEnd.value==netip) 
	{
		document.l7FilterAdd.ipEnd.value=document.l7FilterAdd.ipStart.value;
	}
	else 
	{	
		if (!checkVaildVal.IsVaildIpAddr(document.l7FilterAdd.ipEnd.value, MM_end_ipaddr)) 
			return false;
		if (!checkVaildVal.IsIpSubnet(document.l7FilterAdd.ipEnd.value, lanmsk, lanip)) 
		{
			alert(JS_msg38);
			return false;
		}
		if (!checkVaildVal.IsIpRange(document.l7FilterAdd.ipStart.value, document.l7FilterAdd.ipEnd.value))	
			return false;
		if (document.l7FilterAdd.ipStart.value == lanip || document.l7FilterAdd.ipEnd.value == lanip)
		{
			alert(JS_msg39);
			return false;
		}
	}

/*	if (!isBlankMsg2(document.l7FilterAdd.l7protoFile.value, MM_qos_connlimit)) 
		return false;
	if (!isNumberRange(document.l7FilterAdd.l7protoFile.value, 32, 2048)) 
	{
		alert(MM_qos_connlimit + JS_179);
		return false;
	}		*/

	if(0) //rules_num>0
	{
		for (var i=1; i<responseJson.length; i++)
		{
			v = responseJson[i].ip.split("-");
			for (var j=0; j<v.length; j++)
			{	
				var ips = Number(document.l7FilterAdd.ipStart.value.split(".")[3]);
				var ipe = Number(document.l7FilterAdd.ipEnd.value.split(".")[3]);
				var v0 = Number(v[0].split(".")[3]);
				var v1 = Number(v[1].split(".")[3]);					
				if (ips == v0 || ips == v1 || ipe == v0 || ipe == v1) 
				{
					alert(JS_msg29);
					return false;
				}								
				if (ips < v0 && ipe > v0) 
				{
					alert(JS_msg29);
					return false;
				}	
				if (ips > v0 && ips < v1) 
				{
					alert(JS_msg29);
					return false;
				}		
			}
		}
	}
	
	disableButton(document.l7FilterAdd.add);
	disableButton(document.l7FilterAdd.reset);
	disableButton(document.l7FilterAdd.scanArp);
	disableButton(document.l7FilterAdd.scanL7);
	//setTimeout("enableAddButton();document.l7FilterAdd.submit();", 2000);	
	//return true;
	//document.l7FilterAdd.submit();
}
function disableButton (button) {
  if (document.all || document.getElementById)
    button.disabled = true;
  else if (button) {
    button.oldOnClick = button.onclick;
    button.onclick = null;
    button.oldValue = button.value;
    button.value = 'DISABLED';
  }
}
function disableDelButton()
{
	disableButton(document.l7FilterDel.deleteSelL7);
	disableButton(document.l7FilterDel.reset);
}

function initValue()
{
	lanip=responseJsonLan['lanIp'];
	lanmsk=responseJsonLan['lanNetmask'];
	netip=lanip.replace(/\.\d{1,3}$/,".")
	rules_num=responseJson.length-1;
	if (rules_num==0) 
		disableDelButton();
		
	if (lanip !="") decomIP2(document.l7FilterAdd.ips,lanip,0);
	
	var trNode,tdNode;
	var l7ListTab=$("#div_l7List").get(0);
	for(var i=1;i<responseJson.length;i++){
		trNode=l7ListTab.insertRow(-1);
		trNode.align="center";
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].idx;	
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].ip;	
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].protoFile;	
		tdNode=trNode.insertCell(3);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJson[i].comment;	
		tdNode=trNode.insertCell(4);
		tdNode.className="item_center2";	
		tdNode.innerHTML='<input type=\"checkbox\" id=\"'+responseJson[i].delRuleName+'\" name=\"'+responseJson[i].delRuleName+'\" value=\"'+responseJson[i].delRuleName+'\" >';	
	}
}

function arpTblClick(url)
{
	openWindow(url,"_blank",700,400);
}
$(function(){
	var postVarLan = { topicurl : "setting/getLanConfig"};
    postVarLan = JSON.stringify(postVarLan);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarLan,  
        async : false,  
        success : function(Data){
			responseJsonLan = JSON.parse(Data);							
		}
    });	
	
	var postVar = { topicurl : "setting/getL7FilterRules"};
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
function deleteClick(){	
	var flg=0;
	var postVar ={"topicurl":"setting/delL7FilterRules"};
    for (i=0; i< rules_num; i++){
		var tmp = $("#delRule"+i).get(0);
		if (tmp.checked == true){
			postVar['delRule'+i]= i;
			flg=1;
		}
	}
	
	if(flg==0){
		alert(JS_msg36);
	 	event.returnValue = false;
	}
	
	if(flg==1){
		uiPost(postVar);
	}
}
function doSubmit(){	
	if (addClick()==false)
		return false;
		 
	var postVar ={"topicurl":"setting/setL7FilterRules"};
	postVar['ipStart']=	$("input[name='ipStart']").val();
	postVar['ipEnd']  = $("input[name='ipEnd']").val();
	postVar['comment']= $("input[name='comment']").val();
	postVar['l7protoFile']= $("input[name='l7protoFile']").val();

	uiPost(postVar);
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form method=post name="l7FilterAdd" action="/goform/l7FilterAdd">
<input type="hidden" value="/firewall/smart_filtering.asp" name="submit-url">
<input type="hidden" name="ipStart">
<input type="hidden" name="ipEnd">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_smart_filtering)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_smart_desc)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr><td colspan="2"><b><script>dw(MM_add_rule)</script></b></td>
<tr>
<td class="item_left"><script>dw(MM_ipaddr)</script></td>
<td><input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ips" maxlength="3" disabled>.
<input type="text" style="width:33px" name="ipstart" maxlength="3" value=""> - <input type="text" style="width:33px" name="ipend" maxlength="3" value=""> 
<script>dw('<input name=scanArp type=button value="'+BT_scan+'" onClick=arpTblClick(\"arpinfo.asp#flag=7\")>')</script></td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_smart_conf_file)</script></td>
<td><input type="text" name="l7protoFile" size="26" maxlength="4" readonly>
<script>dw('<input name=scanL7 type=button value="'+BT_scan+'" onClick=arpTblClick(\"l7protoFile.asp#flag=1\")>')</script>
</td>
</tr>
<tr>
<td class="item_left"><script>dw(MM_comment)</script></td>
<td><input type="text" name="comment" size="26" maxlength="10"></td>
</tr>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_add+'" name=add onClick="return doSubmit()">')</script></td></tr>
</table>
</form>

<form method=post name="l7FilterDel" action="/goform/l7FilterDelete">
<input type="hidden" value="/firewall/smart_filtering.asp" name="submit-url">
<table border=0 width="100%">
<tr><td colspan="7"><b><script>dw(MM_smart_table)</script>&nbsp;&nbsp;<script>dw(JS_msg59)</script></b></td></tr>
<tr><td colspan="7"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_smart_conf_file)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="div_l7List"></tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_delete+'" name="deleteSelL7" onClick="return deleteClick()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="reset" onClick="resetForm()">')</script></td></tr>
</table>
</form>

<script>showFooter()</script>
</body></html>
