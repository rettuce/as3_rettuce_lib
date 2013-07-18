<?php
session_start();
$_SESSION['application_id'] = "398215813610795";
$_SESSION['application_secret'] = "b661cb49bb2668d5920df60ead6035d5";
$_SESSION['redirect_uri'] = "http://lab.rettuce.com/oauth/scd/fb/callback.php";

$url = 'https://www.facebook.com/dialog/oauth'
        . '?client_id=' . $_SESSION['application_id']
        . '&redirect_uri=' . urlencode($_SESSION['redirect_uri']);
?>
<!doctype html>
<html>
  <head>
    <title>OAuth Start</title>
  </head>
  <body onload="location.href='<?php echo $url; ?>'"></body>
</html>