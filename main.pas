program main;
uses Windows,CommDlg;

{$H+}

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

function selectFile(var fileName: TFileName): Boolean;
var
  OpenFileName: TOpenFileName;
begin
  ZeroMemory(@OpenFileName, SizeOf(TOpenFileName));

  with OpenFileName do
  begin
      lStructSize := SizeOf(TOpenFileName);
      hwndOwner := GetActiveWindow;
      lpstrFile := fileName;
      nMaxFile := MAX_PATH;
      lpstrFilter := 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
      nFilterIndex := 1;
      Flags := OFN_FILEMUSTEXIST;
  end;
  selectFile := GetOpenFileName(@OpenFileName);
end;
   

procedure loadFile;
var
   fname : tFileName;
   emptyTest : string;
begin
   if selectFile(fname) then
      assign(inputText, @fName)
   else
      begin
         messageBox(0,'File not assigned',Nil,MB_OK or MB_ICONERROR);
         halt(1);
      end;
   reset(inputText);
   read(inputText, emptyTest);
   if emptyTest = '' then
      begin
         messageBox(0,'File is empty',Nil,MB_OK or MB_ICONERROR);
         halt(1);
      end;
end;


procedure letterCount;
var
   cache : char;
begin
   reset(inputText);
   repeat
      read(inputText, cache);
      if cache in ['A'..'Z'] then
         inc(charList[cache]);
      if cache in ['a'..'z'] then
         inc(charList[upcase(cache)]);
   until eof(inputText);
end;

procedure wordCount;
var
   cacheChar : char;
   inWord : boolean;
begin
   inWord := false;
   reset(inputText);
   while not eof(inputText) do
   begin
      read(inputText, cacheChar);
      if cacheChar in ['A'..'Z', 'a'..'z', '0'..'9', '-',#39] then
      begin
         if not inWord then
         begin
            inWord := true;
            inc(totalWord);
         end;
      end
      else
      begin
        inWord := false
      end;
   end;
end;


procedure paragraphCount;
var
   cache : string[255];
begin
   reset(inputText);
   repeat
      readln(inputText, cache);
      if (cache[1] <> '') and (cache[1] <> ' ') then
         inc(totalParagraph);
   until eof(inputText);
end;


function findWord(input : string):integer;
var
   cache : string;
   passage : string;
   count, expressionPos : integer;
   pre : boolean;
begin
   pre := false;
   reset(inputText);
   count := 0;
   cache := '';
   passage := '';
   repeat
      readln(inputText, cache);
      passage := concat(passage, cache);
   until eof(inputText);
   while pos(input, passage) <> 0 do
   begin
      if not (passage[pos(input, passage) - 1] in ['A'..'Z', 'a'..'z', '0'..'9', '-',#39]) then
         pre := true;
      expressionPos := pos(input, passage) + length(input);
      passage := copy(passage,expressionPos, length(passage) - expressionPos);
      if (not (passage[1] in ['A'..'Z', 'a'..'z', '0'..'9', '-',#39])) and pre then 
         inc(count);
      pre := false;
   end;
   findWord := count;
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

procedure findSpecific;
var
   toFind : string;
begin
   repeat
      write('Search for expression(case-sensitive) (input % to exit): ');
      readln(toFind);
      if (toFind <> '') and (toFind <> '%') then
         writeln('The occurrence of expression "', toFind, '" is : ',findWord(toFind));
   until toFind = '%';
end;


begin
init;
loadFile;
letterCount;
wordCount;
paragraphCount;
printResult;
findSpecific;
end.
