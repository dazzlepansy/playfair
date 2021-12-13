% Parse an HTML-style script into its component parts.
html(parsed_script(Type, [Title, Author|Variables], Scenes)) -->
	"<!DOCTYPE html>",
	newline,
	"<html lang=\"en\" xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">",
	newline,
	"<head>",
	newline, tab,
	"<meta charset=\"utf-8\" />",
	newline, tab,
	"<meta name=\"author\" id=\"authortag\" content=\"", text("\n", Author), "\" />",
	newline, tab,
	"<link rel=\"stylesheet\" href=\"common.css\" />",
	newline,
	html_type_css(Type),
	newline, tab,
	"<title>", text("\n", Title), "</title>",
	newline,
	"</head>",
	newline,
	"<body>",
	newline,
	html_body(Type, Title, Author, Variables, Scenes),
	newline,
	"</body>",
	newline,
	"</html>",
	newline.


html_type_css(screen) -->
	tab,
	"<link rel=\"stylesheet\" href=\"scriptfrenzy_screen.css\" />".

html_type_css(stage) -->
	tab,
	"<link rel=\"stylesheet\" href=\"scriptfrenzy_stage.css\" />".


html_body(Type, Title, Author, Variables, Scenes) -->
	html_title_page(Title, Author),
	newline,
	html_meta_page(Variables),
	newline,
	html_play(Type, Scenes).


html_title_page(Title, Author) -->
	tab,
	"<div id=\"titlepage\">",
	newline, tab, tab,
	"<h1>", Title, "</h1>",
	newline, tab, tab,
	"<p id=\"author\">", Author, "</p>",
	newline, tab,
	"</div>".


html_meta_page([]) --> [].

html_meta_page([Personae, Time, Setting]) -->
	tab,
	"<div id=\"metapage\">",
	newline, tab, tab,
	"<div>",
	newline, tab, tab, tab,
	"<p class=\"level3\">Dramatis Personæ</p>",
	html_personae(Personae),
	newline, tab, tab,
	"</div>",
	newline, tab, tab,
	"<div>",
	newline, tab, tab, tab,
	"<p class=\"level3\">Time</p>",
	newline, tab, tab, tab,
	"<p>", text("\n", Time), "</p>",
	newline, tab, tab,
	"</div>",
	newline, tab, tab,
	"<div>",
	newline, tab, tab, tab,
	"<p class=\"level3\">Setting</p>",
	newline, tab, tab, tab,
	"<p>", text("\n", Setting), "</p>",
	newline, tab, tab,
	"</div>",
	newline, tab,
	"</div>".


html_personae([]) --> [].

html_personae([Persona|Rest]) -->
	newline, tab, tab, tab,
	"<p>", text("\n", Persona), "</p>",
	html_personae(Rest).


html_play(Type, Scenes) -->
	tab,
	"<div id=\"play\">",
	newline,
	html_scene_repeater(Type, Scenes),
	newline, tab, tab,
	"<p class=\"character end\">The End.</p>",
	newline, tab,
	"</div>",
	newline.


html_scene_repeater(_, []) --> [].

html_scene_repeater(Type, [Scene|Scenes]) -->
	html_scene(Type, Scene),
	newline,
	html_scene_repeater(Type, Scenes).


% Scene definition for stage plays
html_scene(stage, scene(Act, SceneDirections, Island)) -->
	tab, tab,
	"<div class=\"scene\">",
	newline, tab, tab, tab,
	"<h3 class=\"actScene\">ACT ", Act, "</h3>",
	newline,
	html_scene_directions(SceneDirections),
	newline,
	html_island_repeater(Island),
	newline, tab, tab,
	"</div>".

% Scene definition for screenplays
html_scene(screen, scene(Slug, null, Island)) -->
	tab, tab,
	"<div class=\"scene\">",
	newline,
	html_slug(Slug),
	newline,
	html_island_repeater(Island),
	tab, tab,
	"</div>".


html_island_repeater([]) --> [].
	
html_island_repeater([Island|Rest]) -->
	html_island(Island),
	newline,
	html_island_repeater(Rest).


html_island(character_dialogue(Character, Dialogue)) -->
	tab, tab, tab,
	"<div class=\"dialogue\">",
	newline, tab, tab, tab, tab,
	"<p class=\"character\">", text("\n", Character), "</p>",
	newline,
	html_dialogue_combo(Dialogue),
	newline, tab, tab, tab,
	"</div>".

html_island(stage_directions(StageDirections)) -->
	tab, tab, tab,
	"<div class=\"stageDirections\">",
	newline, tab, tab, tab, tab,
	"<p class=\"stageDirections\">", text("\n", StageDirections), "</p>",
	newline, tab, tab, tab,
	"</div>".


html_scene_directions([]) --> [].

html_scene_directions([SceneDirections|Rest]) -->
	tab, tab, tab,
	"<p class=\"sceneDirections\">", text("\n<", SceneDirections), "</p>",
	newline,
	html_scene_directions(Rest).


html_dialogue_combo([]) --> [].

html_dialogue_combo([character_stage_directions(Directions)|Rest]) -->
	html_character_stage_directions(Directions),
	newline,
	html_dialogue_combo(Rest).

html_dialogue_combo([dialogue(Dialogue)|Rest]) -->
	tab, tab, tab, tab,
	"<p class=\"dialogue\">",
	html_dialogue(Dialogue),
	"</p>",
	newline,
	html_dialogue_combo(Rest).



html_dialogue([]) --> [].

html_dialogue([Unit|Rest]) -->
	html_dialogue_unit(Unit),
	html_dialogue(Rest).


html_dialogue_unit(emphatic(Emphatic)) --> html_emphatic(Emphatic).

html_dialogue_unit(break(Break)) --> html_line_break(Break).

html_dialogue_unit(neutral(Text)) --> text("\n<>*", Text).


html_character_stage_directions(Text) -->
	tab, tab, tab, tab,
	"<p class=\"characterStageDirections\">",
	"(",
	text("\n<>)", Text),
	")",
	"</p>".


html_emphatic(Text) --> "<em>", text("\n<>()", Text), "</em>".


html_line_break([]) --> [].

html_line_break([br|Rest]) -->
	"<br />",
	html_line_break(Rest).


html_slug(slug(int, Text)) -->
	tab, tab, tab,
	"<h2 class=\"slug\"> INT. ",
	text("\n", Text),
	"</h2>".

html_slug(slug(ext, Text)) -->
	tab, tab, tab,
	"<h2 class=\"slug\"> EXT. ",
	text("\n", Text),
	"</h2>".

