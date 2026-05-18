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
var v_igmpEnabled;
var responseJson;
var osplatfrom="";
function resultFun(data){
	if(data=="" || data==null)
		win78reload();
	else
		window.location.href='/internet/igmpproxy.asp';
}

function errorFun(readyState,status){
	win78reload();
}

function win78reload(){
	setTimeout(function(){Ajax.getInstance('/login.asp','',0,resultFun,errorFun);Ajax.get();},"5000");
}

function initValue(){	
	v_igmpEnabled=responseJson[0]['enable'];	
	var trNode;
	var igmpListTab=$("#div_igmpshow").get(0);
	for(var i=1;i<responseJson.length;i++){
		trNode=igmpListTab.insertRow(-1);
		trNode.align="center";
		trNode.insertCell(0).innerHTML=responseJson[i].idx;		
		trNode.insertCell(1).innerHTML=responseJson[i].mac;
		trNode.insertCell(2).innerHTML=responseJson[i].ip;
		trNode.insertCell(3).innerHTML=responseJson[i].host;
		trNode.insertCell(4).innerHTML=responseJson[i].port;
	  	if("reported" ==responseJson[i].status)
	  		trNode.insertCell(5).innerHTML=MM_igmp_status1;
	  	else
	    	trNode.insertCell(5).innerHTML=MM_igmp_status2;
	}
	
	if (v_igmpEnabled==1) {
		$("#igmpEnbl").get(0).selectedIndex = 1;
		$("#div_igmplist").show();
	}
	else {
		$("#igmpEnbl").get(0).selectedIndex = 0;
		$("#div_igmplist").hide();
	}	
}

$(function(){
	var postVar = { topicurl : "setting/getIgmpTable"};
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
	var f=document.igmpCfg;	
	var postVar ={"topicurl":"setting/setIgmpConfig"};
	postVar['igmpEnbl']= $("#igmpEnbl").val();
	$(":input").attr('disabled',true);	
	postVar = JSON.stringify(postVar);
	$.post(" /cgi-bin/cstecgi.cgi",postVar,
	function(Data){
		responseJson = JSON.parse(Data);
	});
	f.target="win78target";
	win78reload();
}
</script>
</head>
<body class="mainbody">
<script>showToper()</script>
<script>showContainer()</script>
<form  name="igmpCfg" id="igmpCfg">
<table border=0 width="100%"> 
<tr><td class="content_title"><script>dw(MM_igmpproxy_setting)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_igmpproxy_setting)</script></td></tr>
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
</table>

<table border=0 width="100%">
<tr>
<td class="item_left"><script>dw(MM_onoff)</script></td>
<td><select id="igmpEnbl" name="igmpEnbl" onChange="updateState()">
<option value="0"><script>dw(MM_disable)</script></option>
<option value="1"><script>dw(MM_enable)</script></option>
</select></td>
</tr>
<tr><td colspan="2"><hr size=1 noshade align=top class=bline></td></tr>
</table>
</form>

<div id="div_igmplist" style="display:none">
<table border=0 width="100%">
<tr><td colspan="6"><b><script>dw(MM_igmpproxy_table)</script></b></td></tr>
<tr><td colspan="6"><hr size=1 noshade align=top class=bline></td></tr>
<tr align="center">
<td class="item_center"><b>ID</b></td>
<td class="item_center"><b><script>dw(MM_mac_group)</script></b></td>
<td class="item_center"><b><script>dw(MM_ip_group)</script></b></td>
<td class="item_center"><b><script>dw(MM_ip_host)</script></b></td>
<td class="item_center"><b><script>dw(MM_port)</script></b></td>
<td class="item_center"><b><script>dw(MM_status)</script></b></td>
</tr>
<tbody id="div_igmpshow">
</tbody>
</table>

<table border=0 width="100%"> 
<tr><td><hr size=1 noshade align=top class=bline></td></tr>
<tr><td height="10"></td></tr>
<tr><td align="right"><script>dw('<input type=button class=button value="'+BT_refresh+'" onClick="window.location.reload()">')</script></td></tr>
</table>
</div>

<script>showFooter()</script>
<iframe id="win78iframe" class="hidden" name="win78target"></iframe>
</body></html>