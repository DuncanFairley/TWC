/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */


var/Tokenizer
Tokenizer/var
	String
	Token
	Current=1
Tokenizer/New(s,t)
	String=s;
	Token=t;
Tokenizer/proc
//next() returns characters until the token is found
	next()
		var/tmpCurrent=0;
		var/subStr;
		if(Current == length(String))
			subStr = "";
		else
			tmpCurrent = findtextEx(String,Token,Current);
			if(tmpCurrent == 0)
				subStr=copytext(String,Current,length(String)+1);
				Current=length(String);
			else
				subStr = copytext(String,Current,tmpCurrent);
				Current=tmpCurrent+length(Token);
		return subStr;
//more() reports if there are any more tokens left 1 if true
//0 if false
	more()
		var/returner=1;
		if(Current == length(String))
			returner=0
		return returner
//END CLASS DEFINITION
proc
	strreplace(base as text,find as text,replace as text)
		var/returner
		var/Tokenizer/tokenStr
		tokenStr = new(base,find)
		while(tokenStr.more() != 0)
			returner += tokenStr.next() + replace;
		returner=copytext(returner,1,length(returner)+1-length(replace));
		return returner;

