%--------------------------------------------------------
%
% Filename:		playfair.pl
% Author:		St John Karp
% Date:			30 October 2012
% Version:		2.0
%
% Purpose:
% A program to format stage play scripts.
%
% Copyright:
% Playfair Script Formatter by St John Karp is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
%
%-------------------------------------------------------

play_to_html(Type, File):-
	open(File, read, In, [encoding(utf8)]),
	process_file(In, Script),
	close(In),
	script(Type, HTML, Script, []),
	xml_write(HTML, [header(false)]),
	%write(HTML),
	halt.


script(Type, [element(html, [], [Head, Body])])
		--> head(Type, Head, Variables), double_break, body(Type, Body, Variables).


body(stage, element(body, [], [TitlePage, MetaPage, Play]), [Title, Author, Personae, Time, Setting]) --> title_page(TitlePage, Title, Author), meta_page(MetaPage, Personae, Time, Setting), play(stage, Play).

body(screen, element(body, [], [TitlePage, Play]), [Title, Author]) --> title_page(TitlePage, Title, Author), play(screen, Play).


play(Type, element(div, [id = play], Play)) --> scene_repeater(Type, Scenes), double_break, end(End), single_break, {append(Scenes, [End], Play)}.


scene_repeater(Type, [Scene|Scenes]) --> scene(Type, Scene), double_break, scene_repeater(Type, Scenes).

scene_repeater(Type, [Scene]) --> scene(Type, Scene).


title_page(element(div, [id = titlepage], [element(h1, [], [Title]), element(p, [id = author], [Author])]), Title, Author) --> [].


meta_page(element(div, [id = metapage], [Personae, Time, Setting]), Personae, Time, Setting) --> [].


% Scene definition for stage plays
scene(stage, element(div, [class = scene], Scene)) --> act(Act), double_break, scene_directions(SceneDirections), double_break, island_repeater(Island),
	{append([Act|SceneDirections], Island, Scene)}.

% Scene definition for screenplays
scene(screen, element(div, [class = scene], [Slug|Island])) --> slug(Slug), double_break, island_repeater(Island).


island_repeater([Island1|Island2]) --> island(Island1), double_break, island_repeater(Island2).

island_repeater([Island]) --> island(Island).


island(element(div, [class = stageDirections], [StageDirections])) --> stage_directions(StageDirections).

island(element(div, [class = dialogue], [Character|Dialogue])) --> character(Character), single_break, dialogue_combo(Dialogue).


scene_directions([element(p, [class = sceneDirections], [Text])]) --> text(['\n', <], Text).

scene_directions([element(p, [class = sceneDirections], [Text])|SceneDirections]) --> text(['\n', <], Text), line_break(_), scene_directions(SceneDirections).


stage_directions(element(p, [class = stageDirections], [Text])) --> text(['\n'], Text).


character(element(p, [class = character], [Text])) --> text(['\n'], Text).


dialogue_combo([CharacterStageDirections, Dialogue|DialogueCombo]) --> character_stage_directions(CharacterStageDirections), single_break, dialogue(Dialogue), single_break, dialogue_combo(DialogueCombo).

dialogue_combo([CharacterStageDirections, Dialogue]) --> character_stage_directions(CharacterStageDirections), single_break, dialogue(Dialogue).

dialogue_combo([Dialogue|DialogueCombo]) --> dialogue(Dialogue), single_break, dialogue_combo(DialogueCombo).

dialogue_combo([Dialogue]) --> dialogue(Dialogue).


dialogue(element(p, [class = dialogue], [Unit])) --> dialogue_unit(Unit).

dialogue(element(p, [class = dialogue], [Unit|Dialogue])) --> dialogue_unit(Unit), dialogue(element(p, [class = dialogue], Dialogue)).


dialogue_unit(Text) --> text(['\n', <, >, '*'], Text).

dialogue_unit(Emphatic) --> emphatic(Emphatic).

dialogue_unit(Break) --> line_break([Break]).


character_stage_directions(element(p, [class = characterStageDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, ')'], Text), [')'].


emphatic(element(em, [], [Text])) --> [<, e, m, >], text(['\n', <, >, '(', ')'], Text), [<, '/', e, m, >].

emphatic(element(em, [], [Text])) --> [<, i, >], text(['\n', <, >, '(', ')'], Text), [<, '/', i, >].

emphatic(element(em, [], [Text])) --> ['*'], text(['\n', '*'], Text), ['*'].


character_directions(element(span, [class = characterDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, '(', ')'], Text), [')'].


head(stage, element(head, [], [Charset, TitleTag, AuthorTag|Styles]), [Title, Author, Personae, Time, Setting]) --> meta_charset(Charset), styles(stage, Styles), tag_title(TitleTag, Title), single_break, tag_author(AuthorTag, Author), single_break, tag_personae(Personae), single_break, tag_time(Time), single_break, tag_setting(Setting).

head(screen, element(head, [], [Charset, TitleTag, AuthorTag|Styles]), [Title, Author]) --> meta_charset(Charset), styles(screen, Styles), tag_title(TitleTag, Title), single_break, tag_author(AuthorTag, Author).


tag_title(element(title, [], [Text]), Text) --> ['@', t, i, t, l, e, ':', ' '], text(['\n'], Text).


tag_author(element(meta, [name = author, id = authortag, content = Full, last = Last], []), Full) --> ['@', a, u, t, h, o, r, ':', ' '], text(['\n', ','], Last), [',', ' '], text(['\n'], First),
	{atomic_list_concat([First, ' ', Last], Full)}.


tag_time(element(div, [], [element(p, [class = level3], ['Time']), element(p, [], [Text])])) --> ['@', t, i, m, e, ':', ' '], text(['\n'], Text).


tag_setting(element(div, [], [element(p, [class = level3], ['Setting']), element(p, [], [Text])])) --> ['@', s, e, t, t, i, n, g, ':', ' '], text(['\n'], Text).


tag_personae(element(div, [], [element(p, [class = level3], ['Dramatis Personæ']), Persona])) --> persona(Persona).

tag_personae(element(div, [], [element(p, [class = level3], ['Dramatis Personæ']), Persona|Personae])) --> persona(Persona), single_break, tag_personae(element(div, [], [_|Personae])).


persona(element(p, [], [Text])) --> ['@', p, e, r, s, o, n, a, ':', ' '], text(['\n'], Text).


%date(element(meta, [name = date, content = ], [])) --> [].


styles(Type, [element(link, [rel = 'stylesheet', type = 'text/css', href = 'common.css'], []), Specific]) --> styles_specific(Type, Specific).


styles_specific(stage, element(link, [rel = 'stylesheet', type = 'text/css', href = 'scriptfrenzy_stage.css'], [])) --> [].

styles_specific(screen, element(link, [rel = 'stylesheet', type = 'text/css', href = 'scriptfrenzy_screen.css'], [])) --> [].


%meta_charset(element(meta, [charset = 'utf-8'], [])) --> [].

meta_charset(element(meta, ['http-equiv' = 'Content-Type', content = 'text/html; charset=utf-8'], [])) --> [].


single_break --> ['\n'].


double_break --> ['\n', '\n'].


line_break([element(br, [], [])]) --> [<, b, r, '/', >].

line_break([element(br, [], [])|Break]) --> [<, b, r, '/', >], line_break(Break).


act(element(h3, [class = actScene], ['A', 'C', 'T', Text])) --> ['A', 'C', 'T'], text(['\n'], Text).

act(element(h3, [class = actScene], ['A', 'C', 'T', Text])) --> ['A', 'c', 't'], text(['\n'], Text).


slug(element(h2, [class = slug], ['I', 'N', 'T', '.', ' ', Text])) --> ['I', 'N', 'T', '.', ' '], text(['\n'], Text).

slug(element(h2, [class = slug], ['E', 'X', 'T', '.', ' ', Text])) --> ['E', 'X', 'T', '.', ' '], text(['\n'], Text).  


end(element(p, [class = 'character end'], ['The End.'])) --> ['T', 'h', 'e', ' ', 'E', 'n', 'd', '.'].


text(Forbidden, Text) --> no_funny_business(Forbidden, Text).


no_funny_business(Forbidden, Text, List, Rest):-
	not(List = ['A', 'C', 'T'|_]),
	not(List = ['I', 'N', 'T', '.'|_]),
	not(List = ['E', 'X', 'T', '.'|_]),
	forbidden_fruit(Forbidden, List, CharList),
	not(CharList = []),
	atom_chars(Text, CharList),
	append(CharList, Rest, List).


forbidden_fruit(Forbidden, [First|_], []):-
	member(First, Forbidden).

forbidden_fruit(Forbidden, [First|Rest], [First|List]):-
	not(member(First, Forbidden)),
	forbidden_fruit(Forbidden, Rest, List).


process_file(File, []):-
	peek_char(File, end_of_file).

process_file(File, [Letter|List]):-
	get_char(File, Letter),
	process_file(File, List).
