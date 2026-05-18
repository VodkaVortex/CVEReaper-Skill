<html>
<head>
<title></title>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="favicon.ico">
<script language="javascript" src="js/jquery.min.js"></script>
<script language="javascript" src="js/json2.min.js"></script>
<script language="javascript" src="js/jcommon.js"></script>
<script>
var responseJson = _globalCfg_;
function initValue(){
	v_Title=responseJson['Title'];
	if(v_Title!="") top.document.title=v_Title;
}

$(function(){
	initValue();
})
</script>
</head>
<frameset rows="96,*,40" border="0" framespacing="0" frameborder="NO">
<frame src="top.asp" name="top" id="topasp" frameborder="NO" scrolling="NO" marginwidth="0" marginheight="0">
<frameset cols="6,1,*,1,6" border="0" framespacing="0" frameborder="NO">
	<frame frameborder="NO" name=other1 marginWidth=0 marginheight=0 src="empty3.htm"  scrolling=no  noresize>
	<frame src="empty1.htm" name="empty1" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO"> 
	<frameset rows="44,*" border="0" framespacing="0" frameborder="NO">
		<frame src="title.asp" name="title" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO">
		<frameset  cols="224,1,25,*" border="0" framespacing="0" frameborder="NO">
			<frame src="left.asp" name="menu" id="menu" marginwidth="0" marginheight="0" scrolling="AUTO" frameborder="NO" noresize>
			<frame src="empty1.htm" name="empty3" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" noresize>
			<frame src="empty2.htm" name="empty4" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" noresize> 
			<frame src="adm/status.asp" id="view" name="view" scrolling="Auto" marginwidth="0" topmargin="0" marginheight="0" frameborder="NO" noresize>
		</frameset>
	</frameset>
	<frame src="empty1.htm" name="empty2" marginwidth="0" marginheight="0" scrolling="NO" frameborder="NO" >
	<frame frameborder="NO" name=other2 marginWidth=0 marginheight=0 src="empty3.htm" scrolling=no  noresize>
</frameset>
<frame name="bottom" scrolling="no" noresize="noresize" target="contents" src="bottom.asp">
</frameset>

<noframes>
<body bgcolor="#FFFFFF" style="overflow-x:hidden;">
</body></noframes>
</html>
