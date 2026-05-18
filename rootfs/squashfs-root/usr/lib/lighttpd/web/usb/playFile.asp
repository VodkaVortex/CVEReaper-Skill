<html>
<head>
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/player/swfobject.js"></script>
</head>
<body>
<h3 id="fileNameID"></h3>
<p id="player1"><a href="http://www.macromedia.com/go/getflashplayer">Get the Flash Player</a> to see this player.</p>
<script type="text/javascript">
//function Load_Setting()
//{
	var s = location.href.split("filePath=");
	var filePath=s[1];
	document.getElementById("fileNameID").innerHTML=filePath+":";
	var s1 = new SWFObject("/player/flvplayer.swf","single","600","350","7");
	s1.addParam("allowfullscreen","true");
	s1.addVariable("file",filePath);
	//s1.addVariable("displayheight","200");
	//s1.addVariable("image","preview.jpg");
	//s1.addVariable("autostart","true");
	s1.addVariable("width","600");
	s1.addVariable("height","350");
	s1.write("player1");
	
//}
</script>
</body onLoad="">
</html>