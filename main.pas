program main;
uses crt,Strings,Windows,CommDlg,CommCtrl;

Type
  TFileName = Array[0..Max_Path] Of Char;

var
   charList : array['A'..'Z'] of integer;
   totalWord : integer;
   inputText : text;
   hWindow : Hwnd;
   
procedure init;
var
   i : char;
begin
   for i := 'A' to 'Z' do
      charList[i] := 0;
   totalWord := 0;
end;


Function SelectFile(Var FName:TFileName; Open:Boolean): Boolean;
Const
   Filter: PChar = 'Text files (*.txt)'#0'*.txt'#0'All files (*.*)'#0'*.*'#0;
   Ext: PChar = 'txt';

Var
   NameRec: OpenFileName;
Begin
   FillChar(NameRec,SizeOf(NameRec),0);
   FName[0] := #0;
   With NameRec Do
      Begin
         LStructSize := SizeOf(NameRec);
         HWndOwner := HWindow;
         LpStrFilter := Filter;
         LpStrFile := @FName;
         NMaxFile := Max_Path;
         Flags := OFN_Explorer Or OFN_HideReadOnly;
         If Open Then
            Begin
               Flags := Flags Or OFN_FileMustExist;
            End;
         LpStrDefExt := Ext;
      End;
   If Open Then
      SelectFile := GetOpenFileName(@NameRec)
   Else
      SelectFile := GetSaveFileName(@NameRec);
End;


procedure loadFile;
var
   Fname : TFileName;
begin
      if SelectFile(Fname, True) then
         assign(inputText, @FName)
      else
         begin
            MessageBox(0,'File not assigned',Nil,MB_OK);
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
   Clrscr;
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