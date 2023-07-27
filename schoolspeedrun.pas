program test;
uses crt;
var
   charList : array['A'..'Z'] of integer;
   totalWord : integer;
   inputText : text;

procedure init;
var
   i : char;
begin
   for i := 'A' to 'Z' do
      charList[i] := 0;
   totalWord := 0;
end;

procedure loadFile;
var
   path : string[255];
   error : integer;
begin
   write('text path: ');
   repeat
   readln(path);
   assign(inputText, path);
   {$i-}
   reset(inputText);
   {$i+}
   error := ioresult;
   if error <> 0 then
      begin
         writeln('Path not valid!');
         write('Enter again: ');
      end;
   until error = 0;
end;



function isASCII(input : char):boolean;
var
   ordValue : integer;
begin
   ordValue := ord(input);
   if (ordValue >= 32) and (ordValue <= 126) then
      isASCII := true
   else
      isASCII := false;
end;

function isChar(input : char):boolean;
begin
   if ((input >= 'A') and (input <= 'Z')) or
   ((input >= 'a') and (input <= 'z')) then
      isChar := true
   else
      isChar := false;
end;

function isPun(input : char):boolean;
begin
   if (isASCII(input)) and (not isChar(input)) then
      isPun := true
   else
      isPun := false;
end;

function upper(input : char):char;
begin
   if isChar(input) then
      if input >= 'a' then
         upper := chr(ord(input) - 32);
end;

procedure letterCount;
var
   cache : char;
begin
   reset(inputText);
   repeat
      read(inputText, cache);
      if isChar(cache) then
         if (cache <= 'Z') then
            charList[cache] := charList[cache] + 1
         else
            charList[upper(cache)] := charList[upper(cache)] + 1;
   until eof(inputText);
end;

procedure wordCount;
var
   cacheString : string[2];
   cacheChar : char;
begin
   reset(inputText);
   repeat
      read(inputText, cacheChar);
      cacheString[1] := cacheString[2];
      cacheString[2] := cacheChar;
      if isPun(cacheString[2]) and isChar(cacheString[1]) then
         totalWord := totalWord + 1;
   until eof(inputText);
end;

procedure printResult;
var
   i : char;
   j : integer;
begin
   Clrscr;
   j := 0;
   for i := 'A' to 'Z' do
   begin
      write(i,': ',charList[i]:5);
      write(' ');
      j := j + 1;
      if (j mod 4 = 0) then
         writeln;
   end;
   writeln;
   writeln('=======================================================');
   writeln('Total Word: ', totalWord);
end; 

begin
init;
loadFile;
letterCount;
wordCount;
printResult;
readln
end.