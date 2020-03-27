go
use WHiring;

CREATE TABLE TestT(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_TestT PRIMARY KEY CLUSTERED 
(
  [hid] ASC
));

insert into TestT values(hierarchyid::GetRoot(), 1, 'User1'); 
select * from TestT;

go
declare @Id hierarchyid  
select @Id = MAX(hid) from TestT where hid.GetAncestor(1) = hierarchyid::GetRoot() ; 
insert into TestT values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'User2');

go
declare @Id hierarchyid
select @Id = MAX(hid) from TestT where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into TestT values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'User2');
 
go
declare @phId hierarchyid
select @phId = (SELECT hid FROM TestT WHERE userId = 2);
declare @Id hierarchyid
select @Id = MAX(hid) from TestT where hid.GetAncestor(1) = @phId;
insert into TestT values( @phId.GetDescendant(@id, null), 7, 'User2');

select hid.ToString(), hid.GetLevel(), * from TestT; 


GO  
CREATE PROCEDURE SelectRoot(@level int)    
AS   
BEGIN  
   select hid.ToString(), * from TestT where hid.GetLevel() = @level;
END;
  
GO  
exec SelectRoot 1;


CREATE PROCEDURE AddDocherRoot(@UserId int,@UserName nvarchar(50))   
AS   
BEGIN  
declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT hid FROM TestT WHERE UserId = @UserId);

select @Id = MAX(hid) from TestT where hid.GetAncestor(1) = @phId

insert into TestT values( @phId.GetDescendant(@id, null),@UserId,@UserName);
END;  

GO  
exec AddDocherRoot 2, 'User3';
select * from TestT; 

go
CREATE PROCEDURE MovRoot(@old_node int, @new_node int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM TestT WHERE UserId = @old_node ;  
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM TestT WHERE UserId = @new_node ; 
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM TestT WHERE hid.GetAncestor(1)=@nnew ; 
UPDATE TestT   
SET hid = hid.GetReparentedValue(@nold, @nnew)   
WHERE hid.IsDescendantOf(@nold) = 1 ;   
 commit;
  END ;  
GO  

exec MovRoot 2,3
select hid.ToString(), hid.GetLevel(), * from TestT