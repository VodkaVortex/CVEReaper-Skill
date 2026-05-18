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
<script>
var protalURL;
var authType;
var rules_num=0;
var responseJson,responseJsonADSUrl;
window.onerror=function(){return true;}
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
	if(protalURL==1){	
		var succURL=document.getElementById("authSuccToUrl").value;
		if(!isEmpty(succURL)){
			alert(MM_succ_url+JS_115);
			return false;
		}	
	}
	return true;
}
function Load_Setting(){
	protalURL=responseJson['portalUrl'];
	authType=responseJson['userAuthType'];
	
	document.getElementById("gowhere").value = protalURL;
	document.getElementById("userAuthType").value = authType;
	changeURL();
}
function changeURL(){
	if(document.getElementById("gowhere").value==1){
		document.getElementById("showManualUrl").style.visibility="";
		document.getElementById("showManualUrl").style.display="";
	}else{
		document.getElementById("showManualUrl").style.visibility="hidden";
		document.getElementById("showManualUrl").style.display="none";
	}
}
function doSubmit(){
	var postVar ={"topicurl":"setting/formADSUrl"};
	postVar['adsAction']= $("#adsAction").val();
	postVar['ads_url']=$("#ads_url").val();
	postVar['ads_url_desc']=$("#ads_url_desc").val();
	
	uiPost(postVar);
}
function addADSUrlFun(){
	var ads_url=document.getElementById("ads_url").value;
	if(!isEmpty(ads_url)){
		alert(MM_ads_domain+JS_115);
		return false;
	}
	document.getElementById("adsAction").value="add";
	
	doSubmit();
	return true;
}
function deleteAdsURLFun(){
	document.getElementById("adsAction").value="del";
	
	var postVar ={"topicurl":"setting/formADSUrl"};
	postVar['adsAction']= $("#adsAction").val();
	var flg=0;
	for (i=0; i< rules_num; i++) {		
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
function initADSUrlList(){
	var ADSUrlList=$("#scheduleList").get(0);
	var trNode,tdNode;
	for(var i=1;i<responseJsonADSUrl.length;i++){
		trNode=ADSUrlList.insertRow(-1);
		trNode.align="center";
		tdNode=trNode.insertCell(0);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].idx;
		tdNode=trNode.insertCell(1);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].url;
		tdNode=trNode.insertCell(2);
		tdNode.className="item_center2";
		tdNode.innerHTML=responseJsonADSUrl[i].desc;
		tdNode=trNode.insertCell(3);
		tdNode.className="item_center2";
		tdNode.innerHTML='<input type=\"checkbox\" id=\"'+responseJsonADSUrl[i].delItemName+'\" name=\"'+responseJsonADSUrl[i].delItemName+'\" value=\"ON\">';
		rules_num++;
	}
}

$(function(){
/*	var postVarAds = { topicurl : "setting/getAuthParame"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJson = JSON.parse(Data);
			Load_Setting();			
		}
    });	*/
	var postVarAdsUrl = { topicurl : "setting/getCsAdsUrl_List"};
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

</script>
</head>

<body class="mainbody">
<table width="600"><tr><td>
<form action="/goform/formADSUrl" method=POST name="formAdsUrl">
<input type="hidden" value="/auth/urlSchedule.asp" name="submit-url">
<input type="hidden" value="" id="adsAction" name="adsAction">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_url_schedule)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_url_schedule)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>

<table border=0 width="100%">
<tr id="">
<td class="item_left"><script>dw(MM_ads_domain)</script></td>
<td align="left" colspan="2">
<input type="text" name="ads_url" id="ads_url" size="32" maxlength="64" value=""></td>
</tr>
<tr id="">
<td class="item_left"><script>dw(MM_comment)</script></td>
<td align="left" colspan="2">
<input type="text" name="ads_url_desc" id="ads_url_desc" size="32" maxlength="64" value=""></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="button" class="button" value="'+BT_add+'" name="addADSUrl" onClick="return addADSUrlFun()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" onClick="resetForm()">')</script></td>
</tr>
</table>

<table border=0 width="100%">
<tr><td class="item_head" colspan="3"><script>dw(MM_ads_list)</script></td></tr>
<tr><td colspan="4"><hr size=1 noshade align=top></td></tr>
<tr align=center>
<td class="item_center"><b><script>dw(MM_ads_num)</script></b></td>
<td class="item_center"><b><script>dw(MM_ads_domain)</script></b></td>
<td class="item_center"><b><script>dw(MM_comment)</script></b></td>
<td class="item_center"><b><script>dw(MM_select)</script></b></td>
</tr>
<tbody id="scheduleList" align="center">
</tbody>
</table>

<table border=0 width="100%">
<tr><td><hr size=1 noshade align=top></td></tr>
<tr><td height="10"></td></tr>
<tr>
<td align="center"><script>dw('<input type="button" class="button" value="'+BT_delete+'" name="deleteAdsURL" onClick="return deleteAdsURLFun()">&nbsp;&nbsp;&nbsp;&nbsp;\
<input type="button" class="button" value="'+BT_reset+'" name="resetSel" onClick="resetForm()">')</script></td>
</tr>
</table>
</form>
</td></tr></table>
</body>
</html>