program main;
uses Strings,Windows,CommDlg,CommCtrl;

Type
   tFileName = Array[0..Max_Path] Of Char;
var
   charList : array['A'..'Z'] of integer;
   totalWord, totalParagraph : integer;
   inputText : text;
   hWindow : hwnd;
   
procedure init;
var
   i : char;
begin
   for i := 'A' to 'Z' do
      charList[i] := 0;
   totalWord := 0;
   totalParagraph := 0;
end;

function selectFile(var fName:tFileName; Open:boolean): boolean;
Const
   filter: PChar = 'Text files (*.txt)'#0'*.txt'#0'All files (*.*)'#0'*.*'#0;
   ext: PChar = 'txt';

Var
   nameRec: openFileName;
Begin
   fillChar(nameRec,sizeOf(NameRec),0);
   fName[0] := #0;
   with nameRec do
      begin
         LStructSize := sizeOf(nameRec);
         HWndOwner := hWindow;
         LpStrFilter := filter;
         LpStrFile := @FName;
         NMaxFile := Max_Path;
         Flags := OFN_Explorer Or OFN_HideReadOnly;
         if open then
            begin
               Flags := Flags Or OFN_FileMustExist;
            end;
         LpStrDefExt := ext;
      end;
   if open then
      selectFile := getOpenFileName(@nameRec)
   else
      selectFile := getSaveFileName(@nameRec);
end;


procedure loadFile;
var
   fname : tFileName;
begin
      if selectFile(fname, True) then
         assign(inputText, @fName)
      else
         begin
            messageBox(0,'File not assigned',Nil,MB_OK or MB_ICONERROR);
            halt(1);
         end;
         
end;


function isVisable(input : char):boolean;
var
   ordValue : integer;
begin
   ordValue := ord(input);
   if (ordValue >= 32) and (ordValue <= 126) then
      isVisable := true
   else
      isVisable := false;
end;

function isChar2(input : char):boolean;
begin
   if ((input >= 'A') and (input <= 'Z')) or
   ((input >= 'a') and (input <= 'z')) or
   ((input >= '0') and (input <= '9')) then
      isChar2 := true
   else
      isChar2 := false;
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
   if (isVisable(input)) and (not isChar(input)) then
      isPun := true
   else
      isPun := false;
end;

function upper(input : char):char;
begin
   if ((input >= 'a') and (input <= 'z')) then
      upper := chr(ord(input) - 32)
   else
      upper := input;
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
              inc(charList[cache], 1)
         else
              inc(charList[upper(cache)], 1)
   until eof(inputText);
end;

procedure wordCount;
var
   cacheString : string[2];
   cacheChar : char;
begin
   reset(inputText);
   cacheString := '  ';
   repeat
      read(inputText, cacheChar);
      cacheString[1] := cacheString[2];
      cacheString[2] := cacheChar;
      if isPun(cacheString[2]) and isChar2(cacheString[1]) then
         inc(totalWord, 1);
   until eof(inputText);
end;

procedure paragraphCount;
var
   cache : string[255];
begin
   reset(inputText);
   repeat
      readln(inputText, cache);
      if cache <> '' then
         inc(totalParagraph, 1);
   until eof(inputText);
end;

procedure apostropheFix;
var
   cacheString : string[2];
   cacheChar : char;
begin
   reset(inputText);
   cacheString := '  ';
   repeat
      read(inputText, cacheChar);
      cacheString[1] := cacheString[2];
      cacheString[2] := cacheChar;
      if (cacheString[1] = chr(39)) and isChar2(cacheString[2]) then
         dec(totalWord, 1);
   until eof(inputText);
end;

procedure hyphenFix;
var
   cacheString : string[2];
   cacheChar : char;
begin
   reset(inputText);
   cacheString := '  ';
   repeat
      read(inputText, cacheChar);
      cacheString[1] := cacheString[2];
      cacheString[2] := cacheChar;
      if (cacheString[1] = '-') and isChar2(cacheString[2]) then
         dec(totalWord, 1);
   until eof(inputText);
end;

procedure printResult;
var
   i : char;
   j : integer;
begin
   j := 0;
   writeln;
   for i := 'A' to 'Z' do
   begin
      write(i,': ',charList[i]:5);
      write(' ');
      inc(j, 1);
      if (j mod 4 = 0) then
         writeln;
   end;
   writeln;
   writeln('=======================================================');
   writeln('Total Word: ', totalWord);
   writeln('Total Paragraph: ', totalParagraph);
end; 


begin
init;
loadFile;
letterCount;
wordCount;
apostropheFix;
hyphenFix;
paragraphCount;
printResult;
readln
end.
