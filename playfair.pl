%--------------------------------------------------------
%
% Filename:		playfair.pl
% Author:		St John Karp
% Date:			13 December 2021
% Version:		3.0
%
% Purpose:
% A program to format stage play scripts.
%
% Copyright:
% Playfair Script Formatter by St John Karp is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
%
%-------------------------------------------------------

:- include('html.pl').
:- include('script.pl').

% parse_entry.
%	Read in a script file from stdin.
play_to_html:-
	read_file(user_input, RawScript),
	script(ParsedScript, RawScript, []),
	html(ParsedScript, HTML, []),
	write_codes(user_output, HTML),
	halt.


% read_file(+Stream, -Codes).
%	Read a file to a list of character codes.
read_file(Stream, Codes):-
	get_code(Stream, Code),
	read_file_next(Code, Stream, Codes).

read_file_next(-1, _, []).

read_file_next(Code, Stream, [Code|Rest]):-
	read_file(Stream, Rest).


% write_codes(+CodesList).
%   Loop through a list of character codes, convert each one to a
%   character, and write them to the current output stream one at
%   a time. This is better than converting the whole list to an atom
%   with atom_codes/2, which can trigger a segfault if the atom is too long.
write_codes(_, []).

write_codes(Stream, [X|Rest]):-
	char_code(Char, X),
	write(Stream, Char),
	write_codes(Stream, Rest).


text(Forbidden, Text) -->
	anything(Forbidden, Text),
	{ Text \= [] }.


anything(_, []) --> [].

anything(Forbidden, [X|Rest]) -->
	[X],
	anything(Forbidden, Rest),
	{ not_forbidden(Forbidden, X) }.


not_forbidden([], _).

not_forbidden([A|Rest], X):-
	A \= X,
	not_forbidden(Rest, X).


newline --> "\n".

tab --> "\t".
