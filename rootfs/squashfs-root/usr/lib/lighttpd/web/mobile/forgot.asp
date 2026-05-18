<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TOTOLINK</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/csstyle.css">
    <script language="javascript" src="js/jquery-1.11.1.min.js"></script>
    <script language="javascript" src="js/mobile.js"></script>
    <style>
        .has-feedback .form-control{
            padding-right: 0;
            padding-left: 34px;
        }
        .form-control-feedback {
            left: 0;
            top: 30px !important;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="container" align="center">
            <div class="cs-h-20"></div>
            <img src="img/config.png" class="cs-img">
        </div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div align="center">
                <h3><script>dw(MB_reset)</script></h3>
            </div>
        </div>
        <div class="cs-h-50"></div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div class="form-group">
            <div class="cs-h-50"></div>
                <h4><script>dw(MB_operation)</script></h4>
                <h5><script>dw(MB_quickly)</script></h5>
            </div>
        </div>
        <div class="container col-xs-10 col-xs-offset-1">
            <div class="form-group">
                <h5><script>dw(MB_def_name)</script>&nbsp;:&nbsp;admin</h5>
                <h5><script>dw(MB_def_pass)</script>&nbsp;:&nbsp;admin</h5>
            </div>
            <div class="cs-h-30"></div>
            <div class="row">
                <div class="col-xs-8 col-xs-offset-2">
                    <button type="button" class="btn btn-lg btn-block btn-default" id="cs_back_btn" onClick="doBack()"><script>dw(BT_back)</script></button>
                </div>
            </div>
            <div class="cs-h-50"></div>
        </div>
        </div>
    </div>
    <script language="javascript" src="js/bootstrap.min.js"></script>
    <script language="javascript" src="js/router.js"></script>
    <script>
        function doBack(){
            gotoUrl('login.asp');
        }
    </script>
</body>
</html>