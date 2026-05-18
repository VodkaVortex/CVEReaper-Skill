<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>多媒体</title>
<link rel="stylesheet" type="text/css" href="" />
<script language="javascript" src="../js/common.js"></script>
<style type="text/css">
body, h1, h2, h3, h4, h5, h6, hr, p,blockquote,dl, dt, dd, ul, ol, li,pre,form,legend, button, input, , td,img{border:medium none;margin: 0;padding: 0;}
body,button, input, select, textarea,#content a {font: 14px/18px Tahoma,Arial,"微软雅黑","宋体";}
body{background:#dadada;}
h1, h2, h3, h4, h5, h6 {font-size: 100%;}
em{font-style:normal;}
ul, ol {list-style: none;}
img{ border:0px;}
table {border-collapse: collapse; border-spacing: 0;}
.center {text-align: center}
#layout{margin:0 auto;text-align:left;width:1000px;}
#content{background:#fff;float:left;height:auto;padding:0px 0px;width:970px;margin:15px;}
.media{background:#fcfcfc;border-bottom:5px solid #f0f0f0;float:left;padding:0px;}
.media ul{width:980px;padding:20px;padding-top:0px;margin:0px;}
.media ul li{background:#f8f8f8;display:inline;float:left;height:160px;margin-left:11px;padding-bottom:50px;margin-top:20px;overflow:hidden;width:150px;}
.media ul li.last{margin-right:0px;}
.media ul li.hover{background:#e6e6e6;}
.media ul li.hover img{display:block;opacity:0.5;-moz-opacity:0.5;filter:alpha(opacity=50)}
.media ul li a{float:left;padding:2px;text-align:center;width:150px;text-decoration: none;}
.media ul li h5{float:left;font-weight:normal;height:20px;line-height:20px;overflow:hidden;margin:0px;}
.media ul li img{display:block;height:170px;width:147px;}
.boxbar{padding-left:30px;height:29px;padding-right:10px;padding-top:5px;width:970px;margin-bottom:-20px;}
</style>
<script type="text/javascript">
var media_list='<% getCSMedia_List(); %>';//'aaa||bbb||ccc||ddd||eee||fff||EEE';//
function load_setting(){
	var playUrl="";
	var imgURL="";
	var mediaNode=$("showMediaList");
	var liNode={},imgNode={},h5Node={},aNode1={},aNode2={};
	var mediaArray=media_list.split("||");
 	if (null != mediaNode && typeof(mediaNode) != "undefined") {
        for(var i = 0; i < mediaArray.length-1; i++) {  
			playUrl="/usb/playFile.asp?media="+mediaArray[i].substring(6);
			imgURL="/media/"+getImgPath(mediaArray[i])+".jpg";
			//img
			imgNode = document.createElement("img");
			imgNode.setAttribute( "src" , imgURL) ;
			imgNode.setAttribute( "alt" ,  getMediaName(mediaArray[i])) ;
			//a2
			aNode2 = document.createElement("a");
			aNode2.setAttribute( "href" , playUrl) ;
			aNode2.setAttribute( "title" ,  getMediaName(mediaArray[i])) ;
			aNode2.innerHTML=getMediaName(mediaArray[i])
			//a1
			aNode1 = document.createElement("a");
			aNode1.setAttribute( "href" , playUrl) ;
			aNode1.setAttribute( "title" ,  getMediaName(mediaArray[i])) ;
			aNode1.appendChild(imgNode);
			//h5
			h5Node = document.createElement("h5");
			h5Node.appendChild(aNode2);
			//li
			liNode = document.createElement("li");
			liNode.appendChild(aNode1);
			liNode.appendChild(h5Node);
			
			mediaNode.appendChild(liNode);	
		} 		
   	}
}
function getImgPath(path){
	//var str="/media/sda1/customization/media/video.flv"
	var arr=path.split("\/");
	var len=arr.length;
	return arr[len-1].split("\.")[0];
}
function getMediaName(path){
	//var str="/media/sda1/customization/media/video.flv"
	var arr=path.split("\/");
	var len=arr.length;
	return arr[len-1];
}
</script>
</head>
<body onload="load_setting();">
<div id="layout">
	<div id="content" class="left w1000">	
		<div id="right">
			<div id="media" class="media">
				<h2 class="boxbar"><a href="" title="More Products..." class="right"></a>多媒体列表</h2>
				<ul id="showMediaList">
				<!--	<li><a href="" title="视频名称"><img src="images/333.jpg" alt="视频名称" /></a> 
					    <h5><a href="" title="视频名称">视频名称</a></h5>
					</li>-->
				</ul>
			</div>
		</div>
	</div>
</div>
</body> 
</html> 

