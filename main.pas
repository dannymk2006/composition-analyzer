program main;
uses Strings,Windows,CommDlg,CommCtrl;

Type
   tFileName = Array[0..Max_Path] Of Char;

var
   charList : array['A'..'Z'] of integer;
   totalWord : integer;
   inputText : text;
   hWindow : hwnd;
   
procedure init;
var
   i : char;
begin
   for i := 'A' to 'Z' do
      charList[i] := 0;
   totalWord := 0;
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
            messageBox(0,'File not assigned',Nil,MB_OK);
            halt(1);
         end;
         
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
      if isPun(cacheString[2]) and isChar(cacheString[1]) then
           inc(totalWord, 1);
   until eof(inputText);
end;

procedure printResult;
var
   i : char;
   j : integer;
begin
   j := 0;
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
end; 


begin
init;
loadFile;
letterCount;
wordCount;
printResult;
readln
end.