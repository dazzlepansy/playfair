<?php
if (($_FILES["file"]["type"] == "text/plain")
&& ($_FILES["file"]["size"] < 1000000)) {
	if ($_FILES["file"]["error"] > 0) {
		echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
	}
	else {
		system("swipl -s playfair.pl -g \"play_to_html('".$_FILES["file"]["tmp_name"]."')\"");
	}
}
else {
	echo "Invalid file";
}
?>
