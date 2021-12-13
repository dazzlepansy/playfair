% Parse a Playfair-style script into its components parts.
script(parsed_script(Type, Variables, Scenes)) -->
	script_head(Variables),
	newline, newline,
	script_play(Type, Scenes),
	newline.


script_play(Type, Scenes) -->
	script_scene_repeater(Type, Scenes),
	script_end.


script_scene_repeater(_, []) --> [].
	
script_scene_repeater(Type, [Scene|Scenes]) -->
	script_scene(Type, Scene),
	script_scene_repeater(Type, Scenes).


% Scene definition for stage plays
script_scene(stage, scene(Act, SceneDirections, Island)) -->
	script_act(Act),
	newline, newline,
	script_scene_directions(SceneDirections),
	newline, newline,
	script_island_repeater(Island).

% Scene definition for screenplays
script_scene(screen, scene(Slug, null, Island)) -->
	script_slug(Slug),
	newline, newline,
	script_island_repeater(Island).


script_island_repeater([]) --> [].

script_island_repeater([Island|Rest]) -->
	script_island(Island),
	newline,
	script_island_repeater(Rest).


script_island(stage_directions(StageDirections)) -->
	script_stage_directions(StageDirections),
	newline.

script_island(character_dialogue(Character, Dialogue)) -->
	script_character(Character),
	newline,
	script_dialogue_combo(Dialogue).


script_scene_directions([Text]) --> text("\n<", Text).

script_scene_directions([Text|SceneDirections]) -->
	text("\n<", Text),
	script_line_breaks(_),
	scene_directions(SceneDirections).


script_stage_directions(Text) --> text("\n", Text).


script_character(Text) --> text("\n", Text).


script_dialogue_combo([]) --> [].

script_dialogue_combo([character_stage_directions(Directions)|Rest]) -->
	script_character_stage_directions(Directions),
	newline,
	script_dialogue_combo(Rest).

script_dialogue_combo([dialogue(Dialogue)|Rest]) -->
	script_dialogue(Dialogue),
	newline,
	script_dialogue_combo(Rest).


script_dialogue([]) --> [].

script_dialogue([Unit|Rest]) -->
	script_dialogue_unit(Unit),
	script_dialogue(Rest).


script_dialogue_unit(emphatic(Emphatic)) --> script_emphatic(Emphatic).

script_dialogue_unit(break(Break)) --> script_line_breaks(Break).

script_dialogue_unit(neutral(Text)) --> text("\n", Text).


script_character_stage_directions(Text) --> "(", text("\n<>)", Text), ")".


script_emphatic(Text) --> "<em>", text("\n<>()", Text), "</em>".

script_emphatic(Text) --> "<i>", text("\n<>()", Text), "</i>".

script_emphatic(Text) --> "*", text("\n*", Text), "*".


script_head([Title, Author, Personae, Time, Setting]) -->
	tag("title", Title),
	newline,
	tag("author", Author),
	newline,
	tags("persona", Personae),
	newline,
	tag("time", Time),
	newline,
	tag("setting", Setting).

script_head([Title, Author]) -->
	tag("title", Title),
	newline,
	tag("author", Author).


tag(Key, Value) --> "@", Key, ": ", text("\n", Value).


tags(Key, [Value]) --> tag(Key, Value).

tags(Key, [Value|Values]) -->
	tag(Key, Value),
	newline,
	tags(Key, Values).


script_line_break --> "<br/>".

script_line_break --> "<br />".


script_line_breaks([br]) --> script_line_break.

script_line_breaks([br|Break]) -->
	script_line_break,
	script_line_breaks(Break).


script_act(Text) --> "ACT ", text("\n", Text).

script_act(Text) --> "Act ", text("\n", Text).


script_slug(slug(int, Text)) --> "INT. ", text("\n", Text).

script_slug(slug(ext, Text)) --> "EXT. ", text("\n", Text).  


script_end --> "The End.".
