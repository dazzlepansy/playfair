<?php
if (($_FILES["file"]["type"] == "text/plain") && ($_FILES["file"]["size"] < 1000000)) {
	if ($_FILES["file"]["error"] > 0) {
		echo "Return Code: " . $_FILES["file"]["error"] . "<br />";
	}
	else {
		echo("<p>Processing…</p>");
		$filename = time();
		system("swipl -s playfair.pl -g \"play_to_html('".$_FILES["file"]["tmp_name"]."')\" > $filename.html");
		system("prince --javascript --script javascript.js $filename.html -o $filename.pdf");
		header("Location: /$filename.pdf");
		sleep(60);
		unlink("$filename.php");
	}
}
else {
	echo "Invalid file";
}
?>
