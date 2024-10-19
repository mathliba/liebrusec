program project1;
uses Classes, SysUtils, SQLite3Conn, SQLDB, lazutf8, AbUnzper, Interfaces;

var SQLite3Connection1: TSQLite3Connection;
 SQLQuery1: TSQLQuery;
 SQLTransaction1: TSQLTransaction;
 i:integer;
 author,header:string;
 a_h:tstringlist;
 AbUnZipper1: TAbUnZipper;
 book_id,fn:string;
 books_count:integer;

 path_zip, path_db, path_files:string;
 vf:textfile;

 //возвращаем имя fb2 файла по номеру книги
 function get_file_name():string;
 var ss:tstringlist;
  sr: TSearchRec;
  N:integer;
 begin
  ss:=tstringlist.Create;
  N:=strtoint(book_id);
  if FindFirst(UTF8ToSys(path_zip+'*.zip'),faAnyFile,sr)=0 then begin
   repeat
    ss.Clear;
    ExtractStrings(['-','.'],[],PChar(sr.Name),ss);
    if (N>strtoint(ss[1])) and (N<strtoint(ss[2])) then begin
     result:=Sr.Name;
     ss.Free;
     exit;
    end;
   until FindNext(sr)<>0;
  FindClose(sr);
  end;
  ss.Free;
  result:='';
 end;

 //получаем список найденных книг в SQLQuery1
 procedure get_book_list();
 begin
  SQLite3Connection1:=TSQLite3Connection.Create(nil);
  SQLQuery1:=TSQLQuery.Create(nil);
  SQLTransaction1:=TSQLTransaction.Create(nil);

  SQLite3Connection1.LoginPrompt:=False;
  SQLite3Connection1.DatabaseName:=path_db;
  SQLite3Connection1.KeepConnection:=True;
  SQLite3Connection1.Transaction:=SQLTransaction1;
  SQLite3Connection1.AlwaysUseBigint:=False;

  SQLTransaction1.Database:=SQLite3Connection1;

  SQLQuery1.Database:=SQLite3Connection1;
  SQLQuery1.Transaction:=SQLTransaction1;

  SQLite3Connection1.Connected:=True;
  SQLTransaction1.Active:=True;

  SQLQuery1.SQL.Clear;
  SQLQuery1.Active:=false;
  SQLQuery1.SQL.Add('SELECT count(id) FROM books_content WHERE c1 LIKE ''%'
    +author+'%'' AND c3 LIKE ''%'+header+'%''');
//  SQLQuery1.SQL.SaveToFile('c:/log_sql_0.txt');
  SQLQuery1.Active:=true;
  books_count:=SQLQuery1.Fields[0].AsInteger;
  if books_count>0 then begin
   SQLQuery1.SQL.Clear;
   SQLQuery1.Active:=false;
   SQLQuery1.SQL.Add('SELECT * FROM books_content WHERE c1 LIKE ''%'
     +author+'%'' AND c3 LIKE ''%'+header+'%'' LIMIT 0, 9');
//   SQLQuery1.SQL.SaveToFile('c:/log_sql_1.txt');
   SQLQuery1.Active:=true;
  end;
 end;

begin

 books_count:=-10;
 if paramCount()=0 then exit;

 AssignFile(vf, 'c:\lazarus\components\mathliba\l.liebrusec\inits.txt');
 Reset(vf);
 readln(vf,path_zip);
 readln(vf,path_db);
 readln(vf,path_files);
 closefile(vf);

 if paramStr(1)[4]='@' then begin //поиск книг
  a_h:=tstringlist.Create;
  ExtractStrings(['@'],[],PChar(paramStr(1)),a_h);
  if a_h.Count<2 then begin
   a_h.Free;
   exit;
  end;
  author:=a_h[1];
  if a_h.Count=3 then header:=a_h[2] else header:='';
  get_book_list();
  if (books_count=0) then Writeln(SySToUTF8('Ничего не найдено'))
  else begin
   if (books_count>9) then begin
    Writeln('Найдено '+inttostr(books_count)+' книг, уточните поиск. Первые 9:');
    books_count:=9;
   end;
   SQLQuery1.First;
   for i:=0 to books_count-1 do begin
    WriteLn('№'+SySToUTF8(SQLQuery1.FieldByName('c7').AsString)
            +': '+SQLQuery1.FieldByName('c1').AsString
            +'. '+SQLQuery1.FieldByName('c3').AsString);
    SQLQuery1.Next;
   end;
  end;
  SQLite3Connection1.Free;
  SQLQuery1.Free;
  SQLTransaction1.Free;
 end;

 if paramStr(1)[4]='$' then begin //отдача книги
  book_id:=copy(paramStr(1),5,length(paramStr(1))-4);
  fn:=get_file_name();
  if fn='' then writeln(': архив обновлений не найден на диске')
  else begin
   fn:='f:\lib\Libruks\Архивы Либрусек\'+fn;
   //write(fn);
   AbUnZipper1:=TAbUnZipper.Create(nil);
   AbUnzipper1.FileName:=fn;
   AbUnzipper1.BaseDirectory:=path_files;
   AbUnzipper1.ExtractFiles(book_id+'.zip');
   AbUnZipper1.Free;
   write('F'+path_files+book_id+'.zip');
  end;
 end;

 //Readln;

end.
