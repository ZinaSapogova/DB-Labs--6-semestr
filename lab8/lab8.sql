create tablespace first_blob
datafile 'C:\Lab08BLOB\first_blob.dbf'
size 50m autoextend on next 1m;

create user C##BED identified by TopSecret666
grant all privileges to C##BED;

alter user C##BED container=all;
select * from v$tablespace

alter user C##BED default tablespace first_blob quota unlimited on first_blob
account unlock container=current;

create directory BLOBS as 'C:\BLOBS';
grant read, write on directory BLOBS to C##BED;


create table BigFiles(
id number(5) primary key,
FOTO BLOB,
DOC_or_PDF BFILE);

insert into BigFiles values(1, null, BFILENAME('BLOBS', 'sert.JPG'));
insert into BigFiles values(2, null, BFILENAME('BLOBS', 'Otchet.docx'));

select * from BigFiles;
delete BigFiles;


declare 
v_blob BLOB;
v_file BFILE;
v_file_size binary_integer;
 begin 
  v_file := BFILENAME('BLOBS', 'sert.JPG');
 insert into BigFiles(id, FOTO, DOC_or_PDF) values (3, EMPTY_BLOB(), null) RETURNING FOTO INTO v_blob;
 DBMS_LOB.FILEOPEN(v_file, DBMS_LOB.FILE_READONLY);
 v_file_size := DBMS_LOB.GETLENGTH(v_file);
DBMS_LOB.LOADFROMFILE(v_blob, v_file, v_file_size);
DBMS_LOB.FILECLOSE(v_file);
commit;
end;

select * from BigFiles