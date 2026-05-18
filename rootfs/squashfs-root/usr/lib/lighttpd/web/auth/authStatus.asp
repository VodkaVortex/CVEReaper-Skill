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
var responseJsonADS,responseJsonUser;

function showTime(){
	var currTime=(new Date()).Format("yyyy-MM-dd hh:mm:ss");
	document.getElementById("currTime").innerHTML=currTime;
	setTimeout(function(){showTime();},1000);
}
function load_setting(){
	showTime();
}

function initADSList(){
	var adsListTab=$("#adsRuleList").get(0);
	var trNode,tdNode;
	for(var i=1;i<responseJsonADS.length;i++){
		trNode=adsListTab.insertRow(-1);
		trNode.align="center";
		if(responseJsonADS[i].status){
			trNode.style.backgroundColor="#2f4f4f";
			trNode.style.color="#fff";
		}
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADS[i].idx;
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADS[i].ADsID;
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADS[i].adstime;
		tdNode=trNode.insertCell(3);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADS[i].adsStopTime;
	}
	load_setting();
}

function initUserList(){
	var userListTab=$("#userRuleList").get(0);
	var trNode,tdNode;
	for(var i=1;i<responseJsonUser.length;i++){
		trNode=userListTab.insertRow(-1);
		trNode.align="center";
		if(responseJsonUser[i].status){
			trNode.style.backgroundColor="#2f4f4f";
			trNode.style.color="#fff";
		}
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonUser[i].idx;
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonUser[i].ip;
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonUser[i].mac.replace(/%3a/ig,":");
		tdNode=trNode.insertCell(3);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonUser[i].online?MM_user_online:MM_user_outline;
		tdNode=trNode.insertCell(4);
		tdNode.className="item_center2";
		if(responseJsonUser[i].online)
			tdNode.innerHTML='<input type=\"button\" onclick=\"DisconnectUser('+responseJsonUser[i].token+',1)\" value=\"'+MM_user_disconnect+'\">';
		else
			tdNode.innerHTML='<input type=\"button\" onclick=\"DisconnectUser('+responseJsonUser[i].token+',1)\" disabled value=\"'+MM_user_disconnect+'\">';
	}
}

$(function(){
	var postVarAds = { topicurl : "setting/getADStatus_List"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJsonADS = JSON.parse(Data);
			initADSList();			
		}
    });
		 
	var postVar = { topicurl : "setting/getCsUserStatus_List"};
    postVar = JSON.stringify(postVar);
	$.ajax({  
       	type : "post",			
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVar,  
        async : true,  
        success : function(Data){
		  	responseJsonUser = JSON.parse(Data);
			initUserList();
		}
    });		
});

function doSubmit(){
	var postVar ={"topicurl":"setting/formDisconnectUser"};
	postVar['token']= $("#token").val();
	postVar['connAction']=$("#connAction").val();
	
	uiPost(postVar);
}
//0:断开；1：连接
function DisconnectUser(token,act){

	document.getElementById("token").value=token;
	document.getElementById("connAction").value=act;
	if(confirm(MSG_auth_disconnect)){
		doSubmit();
	}
	return true;
}
</script>
</head>

<body class="mainbody" onload="load_setting();">
<table width="600"><tr><td>
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_auth_status)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_auth_status)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr><td class="item_head" ><script>dw(MM_ads_status)</script></td>
<td class="">&nbsp;</td>
<td align="right"><b><script>dw(MM_current_time)</script>:</b></td>
<td class=""><b id="currTime"></b></td>
</tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_ads_num)</script></b></td>
<td class="item_center"><b><script>dw(MM_ads_name)</script></b></td>
<td class="item_center"><b><script>dw(MM_time)</script></b></td>
<td class="item_center"><b><script>dw(MM_stop_time)</script></b></td>
</tr>
<tbody id="adsRuleList" align="center">
</tbody>
</table>
<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
</table>
<form action="/goform/formDisconnectUser" method="POST" name="formDisconnect" id="formDisconnect">
<input type="hidden" value="/auth/authStatus.asp" name="submit-url">
<input type="hidden" value="" name="token" id="token">
<input type="hidden" value="" name="connAction" id="connAction">
<table border=0 width="100%">
<tr><td class="item_head" colspan="4"><script>dw(MM_user_status)</script></td></tr>
<tr><td colspan="5"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_ads_num)</script></b></td>
<td class="item_center"><b><script>dw(MM_ipaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_macaddr)</script></b></td>
<td class="item_center"><b><script>dw(MM_online_status)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="userRuleList" align="center">
</tbody>
</table>
<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
</table>

</form>
</td></tr></table>
</body>
</html>