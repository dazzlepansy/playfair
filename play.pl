play_to_html(File):-
	consult('/home/stjohn/XML/xmlprint-1.0.pl'),
	open(File, read, In),
	process_file(In, Play),
	close(In),
	play(HTML, Play, []),
	xml_print(HTML),
	atom_concat(File, '.html', OutFile),
	open(OutFile, write, Out),
	xml_write(Out, HTML, []),
	close(Out).


play([element(html, [],
	[element(head, [], Head),
	element(body, [], [element(h1, [], Title)|Text])])])
		--> head(Head), double_break, body(Body), double_break, end(End), single_break,
			{member(element(title, [], Title), Head), append(Body, [End], Text)}.


body(Scene) --> scene(Scene).

body(Scene) --> scene(Scene1), double_break, body(Body),
	{append(Scene1, Body, Scene)}.


scene(Scene) --> act(Act), double_break, scene_directions(SceneDirections), double_break, block_repeater(Block),
	{append([Act|SceneDirections], Block, Scene)}.


block_repeater(Repeater) --> block(Block1), double_break, block_repeater(Block2),
	{append(Block1, Block2, Repeater)}.

block_repeater(Block) --> block(Block).


block([Character, CharacterStageDirections, Dialogue]) --> character(Character), single_break, character_stage_directions(CharacterStageDirections), single_break, dialogue(Dialogue).

block([StageDirections]) --> stage_directions(StageDirections).

block([Character, Dialogue]) --> character(Character), single_break, dialogue(Dialogue).


scene_directions([element(p, [class = sceneDirections], [Text])]) --> text(['\n', <], Text).

scene_directions([element(p, [class = sceneDirections], [Text])|SceneDirections]) --> text(['\n', <], Text), line_break(_), scene_directions(SceneDirections).


stage_directions(element(p, [class = stageDirections], [Text])) --> text(['\n'], Text).


character(element(p, [class = character], [Text])) --> text(['\n'], Text).


dialogue(element(p, [class = dialogue], Line)) --> dialogue_line(Line).

dialogue(element(p, [class = dialogue], Dialogue)) --> dialogue_line(Line), single_break, dialogue(element(p, [class = dialogue], Dialogue1)),
	{append(Line, [element(br, [], [])|Dialogue1], Dialogue)}.


dialogue_line([Unit]) --> dialogue_unit(Unit).

dialogue_line([Unit|Dialogue]) --> dialogue_unit(Unit), dialogue(element(p, [class = dialogue], Dialogue)).


dialogue_unit(Text) --> text(['\n', <, >, '(', ')'], Text).

dialogue_unit(Italic) --> italic(Italic).

dialogue_unit(CDD) --> character_directions(CDD).


character_stage_directions(element(p, [class = characterStageDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, ')'], Text), [')'].


italic(element(em, [], [Text])) --> [<, e, m, >], text(['\n', <, >, '(', ')'], Text), [<, '/', e, m, >].

italic(element(em, [], [Text])) --> [<, i, >], text(['\n', <, >, '(', ')'], Text), [<, '/', i, >].


character_directions(element(span, [class = characterDirections], ['(', Text, ')'])) --> ['('], text(['\n', <, >, '(', ')'], Text), [')'].


head([Styles|Tags]) --> styles(Styles), sisu_repeater(Tags).


sisu_repeater([Tag]) --> sisu_tag(Tag).

sisu_repeater([Tag|Tags]) --> sisu_tag(Tag), double_break, sisu_repeater(Tags).


sisu_tag(element(title, [], [Text])) --> ['@', t, i, t, l, e, ':', ' '], text(['\n'], Text).


styles(element(link, [rel = 'stylesheet', type = 'text/css', href = '/Data/styles/scriptfrenzy.css'], [])) --> [].


single_break --> ['\n'].


double_break --> ['\n', '\n'].


line_break([element(br, [], [])]) --> [<, b, r, '/', >].

line_break([element(br, [], [])|Break]) --> [<, b, r, '/', >], line_break(Break).


act(element(h3, [class = actScene], ['A', 'C', 'T', Text])) --> ['A', 'C', 'T'], text(['\n'], Text).


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
