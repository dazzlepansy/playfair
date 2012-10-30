<?php
if (($_FILES['script']['type'] == 'text/plain') && ($_FILES['script']['size'] < 1000000)) {
	if ($_FILES['script']['error'] > 0) {
		echo "Return Code: " . $_FILES['script']['error'] . "<br />";
	}
	else {
		header("Content-Type: application/pdf");
		$script_name = pathinfo($_FILES['script']['name']);
		$output_name = $script_name['filename'] . '.pdf';
		header("Content-Disposition:attachment; filename='$output_name'");
		passthru("LANG='en_US.UTF8' swipl -s playfair.pl -g \"play_to_html(".$_POST['type'].",'".$_FILES['script']['tmp_name']."')\" | prince - --javascript --script javascript.js");
		exit();
	}
}
else {
	echo "Invalid file";
}
?>
