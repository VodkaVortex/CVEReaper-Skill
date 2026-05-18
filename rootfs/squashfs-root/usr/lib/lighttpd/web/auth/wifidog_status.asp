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
var lanIP;
var lanage;
var responseJson;
function load_setting(){
	lanIP=responseJson['lanIp'];
	lanage=responseJson['LanguageType'];
	
	document.getElementById("showStatusPage").src="http://"+lanIP+":2060/wifidog/status?lan="+lanage;
}
function iframeAutoFit(){
	var iframeObj = document.getElementById("showStatusPage");
	iframeObj.height=(iframeObj.Document?iframeObj.Document.body.scrollHeight:iframeObj.contentDocument.body.offsetHeight)+20;
}
$(function(){
	var postVarAds = { topicurl : "setting/getWifidogInfo"};
    postVarAds = JSON.stringify(postVarAds);
	$.ajax({  
       	type : "post",  
        url : " /cgi-bin/cstecgi.cgi",  
        data : postVarAds,  
        async : true,  
        success : function(Data){
			responseJson = JSON.parse(Data);
			load_setting();			
		}
    });	
});
</script>
</head>

<body class="mainbody">
<table width="800"><tr><td>
<form action=/goform/formCsAuth method=POST name="formCsAuth">
<input type="hidden" value="/auth/wifidog_status.asp" name="submit-url">
<table border=0 width="100%">
<tr><td class="content_title"><script>dw(MM_wifidog_status)</script></td></tr>
<tr><td class="content_help"><script>dw(MSG_wifidog_status)</script></td></tr>
<tr><td><hr size=1 noshade align=top></td></tr>
</table>
</form>
<iframe src="" id="showStatusPage" name="showStatusPage" onload="" marginheight="0" marginwidth="0" frameBorder="0" width="100%" height="900;"></iframe>
</td></tr></table>
</body>
</html>