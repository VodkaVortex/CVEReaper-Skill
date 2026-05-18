<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
    <!-- HTTP 1.1 -->
    <meta http-equiv="pragma" content="no-cache">
    <!-- HTTP 1.0 -->
    <meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<title>TOTOLINK</title>
    <link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/csstyle.css">
    <script language="javascript" src="js/jquery-1.11.1.min.js"></script>
    <script language="javascript" src="js/mobile.js"></script>
	<style>
		body{font-size: 12px; background-color: #15B9D5 !important;color: #fff !important;}
		.cs_img_center>div{padding: 0;}
		.cs_img_center div div{position: absolute;bottom: 5%;color: #15b9d5;font-size: 1.1em;font-weight: bold;}
        .container{padding-right: 30px;padding-left: 30px;}
	</style>
</head>
<body>
	<div id="cs_menu" class="container-fluid">
        <div class="row cs-header" align="center">
			<h3><script>dw(MB_router_setting)</script></h3>
		</div>

		<div>
            <div class="cs-h-50"></div>
            <div class="container col-xs-10 col-xs-offset-1">
            	<div class="row" align="center">
                    <h4><script>dw(MB_model_no)</script>&nbsp;-&nbsp;<span id="productName"></span></h4>
                    <h5><script>dw(MB_version)</script>&nbsp;<span id="fmVersion"></span></h5>
                </div>
                <div class="cs-h-50"></div>
                <div class="row cs_img_center" align="center">
                    <div class="col-xs-6">
                        <img src="img/quick.png" id="cs_quick_btn" class="img-responsive">
                        <div class="col-xs-12"><script>dw(MB_quick_setup)</script></div>
                    </div>
                    <div class="col-xs-6">
                        <img src="img/adv.png" id="cs_adv_btn" class="img-responsive" style="margin-left: 10px;">
                        <div class="col-xs-12" style="margin-left:10px"><script>dw(MB_advanced_setup)</script></div>
                    </div>
                </div>
            </div>
		</div>
	</div>

<div id="myModal" class="modal" tabindex="-1" role="dialog" style="width: 100%; height: 100%;">
  <div class="modal-dialog" role="document" style="width: 100%; height: 100%;margin:0;">
    <div class="container-fluid" style="height: 100%; background: #14b9d6;">
        <div id="cs_detect">
            <div class="cs-h-100"></div>
            <div class="container col-xs-10 col-xs-offset-1">
                <div align="center">
                    <img src="img/loading.gif">
                    <br><br>
                    <h5><script>dw(MB_wating)</script></h5>
                </div>
            </div>
        </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<div id="cs_detect_fail_model" class="modal" tabindex="-1" role="dialog" style="width: 100%; height: 100%;">
  <div class="modal-dialog" role="document" style="width: 100%; height: 100%;margin:0;">
    <div class="container-fluid" style="height: 100%; background: #14b9d6;">
        <div id="cs_detect_fail">
            <div class="cs-h-20"></div>
            <div class="container">
                <div align="center">
                    <img src="img/link_fail.png" width="100%">
                    <br><br>
                    <label><script>dw(MB_not_con)</script></h5></label>
                </div>
                <div class="cs-h-20"></div>
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                        <button type="button" class="btn btn-lg btn-block btn-default" id="cs_skip_detect_btn"><script>dw(MB_skip)</script></button>
                    </div>
                </div>
                <div class="cs-h-10"></div>
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-2">
                        <button type="button" class="btn btn-lg btn-block btn-default" id="cs_try_again_btn"><script>dw(BT_try_again)</script></button>
                    </div>
                </div>
            </div>
        </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
	<script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
	<script>
		$(function(){
            $('#cs_quick_btn').on('click', function(event) {
                event.preventDefault();

 //               $('#myModal').modal();
                setTimeout(function() {
                    getWanconfig();
                }, 10);
            });

            $('#cs_adv_btn').on('click', function(event) {
                event.preventDefault();
                gotoUrl('../home.asp');
            });

            $('#cs_skip_detect_btn').on('click', function(event) {
                var postVar={"topicurl" : "setting/discoverWan"};
                $.ajax({
                    type : "post",
                    data : postVar,
                    url : " /cgi-bin/cstecgi.cgi",
                    async : true,
                    success : function(){
                        setTimeout("$('#cs_detect_fail_model').modal('hide');");
                        location.href='internet.asp?ret=0';
                    }
                });
            });

            $('#cs_try_again_btn').on('click', function(event) {
                $('#cs_detect_fail_model').modal('hide');
//                $('#myModal').modal();
                setTimeout(function() {
                    getWanconfig();
                }, 10);
            });
        });
        if(getCookie("languageType")=="EN"){
            $('#cs_quick_btn').attr("src","img/quick.png");
            $('#cs_adv_btn').attr("src","img/adv.png");
        }else{
            $('#cs_quick_btn').attr("src","img/quick.png");
            $('#cs_adv_btn').attr("src","img/adv.png");
        }
        $('#productName').html(getCookie("productName"));
        $('#fmVersion').html(getCookie("fmVersion"));

        function getWanconfig(){
            var postVar={"topicurl" : "setting/getWanConfig"};
            postVar=JSON.stringify(postVar);
            $.ajax({
                type : "post",
                url : " /cgi-bin/cstecgi.cgi",
                data : postVar,
                async : true,
                success : function(Data){
                    var rJson=JSON.parse(Data);
                    var ret=rJson['wanConnectionMode'];
                    if(ret=="dhcp"){//DHCP
                        location.href="/mobile/internet.asp?ret=1";
                    }else if(ret=="pppoe"){//PPPoE
                        location.href="/mobile/internet.asp?ret=2";
                    }else if(ret=="static"){//Static IP
                        location.href="/mobile/internet.asp?ret=3";
                    }else {
                        location.href="/mobile/internet.asp?ret=1";
                   	}
                }
            });
        }

        function autoDetect(){
            var postVar={"topicurl" : "setting/discoverWan"};
            postVar=JSON.stringify(postVar);
            $.ajax({
                type : "post",
                url : " /cgi-bin/cstecgi.cgi",
                data : postVar,
                async : true,
                success : function(Data){
                    var rJson=JSON.parse(Data);
                    var ret=rJson['discover_proto'];
                    setCookie("change_lanip",rJson.change_lanip);
                    if(ret==1){//DHCP
                    	startDial();
                    }else if(ret==2){//PPPoE
                        location.href="/mobile/internet.asp?ret=2";
                    }else if(ret==3){//Static IP
                        location.href="/mobile/internet.asp?ret=3";
                    }else if(ret==4){//modify WAN IP
                        location.href="/mobile/internet.asp?ret=4";
                    }else{
                        // setTimeout('$("#cs_detect, #cs_menu").hide();$("#cs_detect_fail").show();',2000);
//                        $('#cs_detect_fail_model').modal();
                    }
                    setTimeout("$('#myModal').modal('hide');");

                }
            });
        }
	</script>
</body>
</html>