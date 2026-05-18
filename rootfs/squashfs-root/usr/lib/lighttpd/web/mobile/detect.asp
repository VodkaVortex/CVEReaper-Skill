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
</head>
<body>
	<div class="container-fluid">
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
        
		<div id="cs_detect_fail" style="display: none;">
            <div class="cs-h-50"></div>
            <div class="container">
            	<div align="center">
            		<img src="img/link_fail.png" width="100%">
                    <br><br>
                    <h5><script>dw(MB_not_con)</script></h5>
                </div>
                <div class="cs-h-40"></div>
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
	</div>
    <script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
	<script>
		$(function() {
            $("#cs_detect").show();
			autoDetect();

           	$('#cs_skip_detect_btn').on('click', function(event) {
           		setTimeout('location.href="internet.asp?ret=0"','500');
           	});

			$('#cs_try_again_btn').on('click', function(event) {
				$('#cs_detect_fail').hide();
                $('#cs_detect').show();
				autoDetect();
			});
		});
	</script>
</body>
</html>