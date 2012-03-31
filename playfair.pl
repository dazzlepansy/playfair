%--------------------------------------------------------
%
% Filename:		playfair.pl
% Author:		St John Karp
% Date:			3 September 2011
% Version:		1.0
%
% Purpose:
% A program to format stage play scripts.
%
% Copyright:
% Playfair Script Formatter by St John Karp is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
%
%-------------------------------------------------------

play_to_html(File):-
	open(File, read, In, [encoding(utf8)]),
	process_file(In, Play),
	close(In),
	play(HTML, Play, []),
	xml_write(HTML, [header(false)]),
	%write(HTML),
	halt.


play([element(html, [], [Head, Body, End])])
		--> head(Head, Title, Author, Personae, Time, Setting), double_break, body(Body, Title, Author, Personae, Time, Setting), double_break, end(End), single_break.


body(element(body, [], [TitlePage, MetaPage|Scenes]), Title, Author, Personae, Time, Setting) --> title_page(TitlePage, Title, Author), meta_page(MetaPage, Personae, Time, Setting), scene_repeater(Scenes).


scene_repeater([Scene|Scenes]) --> scene(Scene), double_break, scene_repeater(Scenes).

scene_repeater([Scene]) --> scene(Scene).


title_page(element(div, [id = titlepage], [element(h1, [], [Title]), element(p, [id = author], [Author])]), Title, Author) --> [].


meta_page(element(div, [id = metapage], [Personae, Time, Setting]), Personae, Time, Setting) --> [].


scene(element(div, [class = scene], Scene)) --> act(Act), double_break, scene_directions(SceneDirections), double_break, island_repeater(Island),
	{append([Act|SceneDirections], Island, Scene)}.


island_repeater([Island1|Island2]) --> island(Island1), double_break, island_repeater(Island2).

island_repeater([Island]) --> island(Island).


island(element(div, [class = dialogue], [Character, CharacterStageDirections, Dialogue])) --> character(Character), single_break, character_stage_directions(CharacterStageDirections), single_break, dialogue(Dialogue).

island(element(div, [class = stageDirections], [StageDirections])) --> stage_directions(StageDirections).

island(element(div, [class = dialogue], [Character, Dialogue])) --> character(Character), single_break, dialogue(Dialogue).


scene_directions([element(p, [class = sceneDirections], [Text])]) --> text(['\n', <], Text).

scene_directions([element(p, [class = sceneDirections], [Text])|SceneDirections]) --> text(['\n', <], Text), line_break(_), scene_directions(SceneDirections).


stage_directions(element(p, [class = stageDirections], [Text])) --> text(['\n'], Text).


character(element(p, [class = character], [Text])) --> text(['\n'], Text).


dialogue(element(p, [class = dialogue], [Unit])) --> dialogue_unit(Unit).

dialogue(element(p, [class = dialogue], [Unit|Dialogue])) --> dialogue_unit(Unit), dialogue(element(p, [class = dialogue], Dialogue)).

dialogue(element(p, [class = dialogue], [Unit, element(br, [], [])|Dialogue])) --> dialogue_unit(Unit), single_break, dialogue(element(p, [class = dialogue], Dialogue)).

dialogue(element(p, [class = dialogue], [Unit, element(br, [], []), element(br, [], [])|Dialogue])) --> dialogue_unit(Unit), line_break(_), dialogue(element(p, [class = dialogue], Dialogue)).


dialogue_unit(Text) --> text(['\n', <, >, '(', ')'], Text).

dialogue_unit(Italic) --> italic(Italic).

dialogue_unit(CDD) --> character_directions(CDD).


character_stage_directions(element(p, [class = characterStageDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, ')'], Text), [')'].


italic(element(em, [], [Text])) --> [<, e, m, >], text(['\n', <, >, '(', ')'], Text), [<, '/', e, m, >].

italic(element(em, [], [Text])) --> [<, i, >], text(['\n', <, >, '(', ')'], Text), [<, '/', i, >].


character_directions(element(span, [class = characterDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, '(', ')'], Text), [')'].


head(element(head, [], [Charset, TitleTag, AuthorTag, Styles]), Title, Author, Personae, Time, Setting) --> meta_charset(Charset), styles(Styles), tag_title(TitleTag, Title), single_break, tag_author(AuthorTag, Author), single_break, tag_personae(Personae), single_break, tag_time(Time), single_break, tag_setting(Setting).


tag_title(element(title, [], [Text]), Text) --> ['@', t, i, t, l, e, ':', ' '], text(['\n'], Text).


tag_author(element(meta, [name = author, id = authortag, content = Full, last = Last], []), Full) --> ['@', a, u, t, h, o, r, ':', ' '], text(['\n', ','], Last), [',', ' '], text(['\n'], First),
	{atomic_list_concat([First, ' ', Last], Full)}.


tag_time(element(div, [], [element(p, [class = level3], ['Time']), element(p, [], [Text])])) --> ['@', t, i, m, e, ':', ' '], text(['\n'], Text).


tag_setting(element(div, [], [element(p, [class = level3], ['Setting']), element(p, [], [Text])])) --> ['@', s, e, t, t, i, n, g, ':', ' '], text(['\n'], Text).


tag_personae(element(div, [], [element(p, [class = level3], ['Dramatis Personæ']), Persona])) --> persona(Persona).

tag_personae(element(div, [], [element(p, [class = level3], ['Dramatis Personæ']), Persona|Personae])) --> persona(Persona), single_break, tag_personae(element(div, [], [_|Personae])).


persona(element(p, [], [Text])) --> ['@', p, e, r, s, o, n, a, ':', ' '], text(['\n'], Text).


%date(element(meta, [name = date, content = ], [])) --> [].


styles(element(link, [rel = 'stylesheet', type = 'text/css', href = 'scriptfrenzy.css'], [])) --> [].


%meta_charset(element(meta, [charset = 'utf-8'], [])) --> [].

meta_charset(element(meta, ['http-equiv' = 'Content-Type', content = 'text/html; charset=utf-8'], [])) --> [].


single_break --> ['\n'].


double_break --> ['\n', '\n'].


line_break([element(br, [], [])]) --> [<, b, r, '/', >].

line_break([element(br, [], [])|Break]) --> [<, b, r, '/', >], line_break(Break).


act(element(h3, [class = actScene], ['A', 'C', 'T', Text])) --> ['A', 'C', 'T'], text(['\n'], Text).

act(element(h3, [class = actScene], ['A', 'C', 'T', Text])) --> ['A', 'c', 't'], text(['\n'], Text).


end(element(p, [class = end], ['The End.'])) --> ['T', 'h', 'e', ' ', 'E', 'n', 'd', '.'].


text(Forbidden, Text) --> no_funny_business(Forbidden, Text).


no_funny_business(Forbidden, Text, List, Rest):-
	not(List = ['A', 'C', 'T'|_]),
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
