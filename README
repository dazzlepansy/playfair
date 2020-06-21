Playfair Script Formatter
=========================

The code for Playfair can be run locally on any machine running [SWI-Prolog](http://www.swi-prolog.org/). Prolog does all the grunt-work of parsing and formatting the play as HTML. You can then use [Prince](http://www.princexml.com/) to convert the HTML output into a PDF file.

What is the Playfair Script Formatter?
--------------------------------------

Writers have a colossal plague in the form of scripts. When you're writing a script you don't want to have to think about how every line is going to be formatted — and yet that's exactly what you have to do. Characters' names have to be indented, dialogue is left-aligned, stage and character directions are italicized and indented at different levels — the list is endless. I have spent hours trying to format my scripts correctly, and I certainly don't want to interrupt my writing by having to click 100 different buttons on the word processor.

And yet the structure of a script is essentially predictable. The text is delineated in neat blocks that conform to regular patterns. Why not just write the play in plain, unformatted text and run it through a program to format it automatically? That's exactly what the Playfair Script Formatter is for.

How to Use Playfair
-------------------

Because Playfair expects a predictable document structure, you have to stick pretty closely to what's expected. To help out, here's a quick demo of features and a checklist of things to do before uploading your document. If you don't follow this example, your script will not pass through the formatter correctly.

### Sample

First up, here's a little demo of what a typical script might look like:

	@title: Time Passes Like a Gym Teacher's Laxative
	@author: Karp, St John

	ACT I Scene 1

	The stage is decorated in the manner of the Belgian Walloons. A Victrola stands in the background. A giant and a dwarf are onstage.

	The Victrola is playing "Yes! We Have No Bananas". The GIANT is pacing up and down while the DWARF attempts to put toothpaste back into the tube.

	GIANT
	(complaining)
	I find this entire state of affairs unsatisfactory. Don't you realize that unless we can assassinate King Pumpernickel V, the Duke is going to corner the market in rubber chickens?
	(turning to the dwarf)
	How can you sit there playing with your tube?!

	The DWARF looks up.

	DWARF
	It's extra-minty. (indicating the toothpaste) Look, it has stripes. What's the matter, don't you *care* about stripes?

	…

	The End.

### The Breakdown

Let's step through this thing one at a time, shall we? You'll notice that each discrete group of text is separated either by a single new line or a double new line. This is very important, as it helps distinguish a character and their dialogue from the next character. Don't go adding extra new lines or you'll wind up with chaos.

First up, you give your script's meta-data, such as the title and the author. The author's name must be in the format of "Last Name, First Names". These two tags are the bare minimum of data required to format your script. However, especially if you're writing a stage play, you may also want to include a dramatis personæ — no problem. For a fully-formatted character page, you can include these lines:

	@persona: Dwarf: an expert cheese-maker.
	@persona: Giant: a professional baseball-player.
	@time: The year three million.
	@setting: Space.

Include an extra line for each new character in your play. If you're doing a character page, you are also required to include a @time and @setting.

Next, you'll notice a declaration of which act/scene this is. This is the notation for a stage play, but the convention for a screenplay works the same way. Instead of "ACT I Scene 1" you can just as well write "INT. SPACESHIP" or "EXT. GOLF COURSE".

Skip this if you're writing a screenplay. If writing a stage play, you must include a paragraph of scene directions that describe the setting.

Now that you're in the body of the script, each block of text (separated by two new lines) is either one of two things — a paragraph of stage directions or a character speaking. Stage directions describe what's happening. Those are simple enough. The character speaking is where things get fun.

Each character block starts with the character's name followed by a new line. Then you can write the dialogue itself. Any text in parentheses will be rendered as a character direction, whether its on its own new line or whether it's in the middle of a character's dialogue. You can have as many new lines as you like in the middle of dialogue so that you can put character directions on their own line or break the dialogue up into paragraphs. Either way, do not add a double new line until you're ready for the next stage direction or the next character to speak.

One thing that isn't generally recommended for scripts, but which I find quite handy, is adding emphasis to a word. If you want to add emphasis, enclose the text *between two asterisks*. This format is very human-readable to users who chat online, and the formatter will output the text as underlined.

Finally, at the very end of your script, you write "The End." followed by one newline — and you're done! Save your script as a plain text, UTF-8 file with a .txt extension and run it through `playfair.pl`.
