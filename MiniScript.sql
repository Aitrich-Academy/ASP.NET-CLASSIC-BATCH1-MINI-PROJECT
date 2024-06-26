USE [DBHungryhive]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Categoryname] [varchar](20) NOT NULL,
	[Image] [varchar](20) NULL,
	[Status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dishes]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dishes](
	[dishid] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[DishName] [varchar](20) NOT NULL,
	[Image] [varchar](20) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[dishid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[feedback]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[feedback](
	[feedbackId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NULL,
	[comment] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[feedbackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[dishid] [int] NOT NULL,
	[DishName] [varchar](20) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Quantity] [int] NOT NULL,
	[TotalPrice] [decimal](18, 2) NOT NULL,
	[status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](20) NOT NULL,
	[Email] [varchar](20) NOT NULL,
	[Mobile] [varchar](20) NOT NULL,
	[Pincode] [bigint] NOT NULL,
	[District] [varchar](20) NULL,
	[Password] [varchar](20) NOT NULL,
	[Status] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dishes]  WITH CHECK ADD FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([CategoryId])
GO
ALTER TABLE [dbo].[feedback]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([dishid])
REFERENCES [dbo].[Dishes] ([dishid])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[Category_Insert]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Category_Insert]
(
@Categoryname as varchar(20),
@Image as varchar(20)
)
as
begin
begin transaction
declare @result as varchar(50), @exist as int
set @exist = (select count (*) from  Category where Categoryname = @Categoryname and Status ='A')

if (@exist>0)
begin
set @result ='Already Exist'
end
else
begin
insert into Category(Categoryname,Image,Status)
 values(@Categoryname,@Image,'A')
 if (@@error>0)
 begin
set @result='Error'
rollback transaction
end
else
begin
set @result='Success'
end
end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[Dish_update]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Dish_update]
(@dishid int,
@CategoryId int,
@DishName varchar(500),
@Image varchar(500),
@Quantity int,
@Price decimal(18,2),
@Status varchar(20))
as
begin
begin transaction
declare @result as varchar(30)
update Dishes set DishName=@DishName,Price=@Price,Quantity=@Quantity,Image=@Image,CategoryId=@CategoryId
Where dishid=@DishId
if(@@ERROR>0)
begin
set @result='Error'
rollback transaction
end
else
begin
set @result='Success'
end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[dishbycategoryid]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[dishbycategoryid](@categoryid int)
as
begin
select dishid,DishName,Price,Image from Dishes where CategoryId=@categoryid and Status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[Dishes_delete]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Dishes_delete](@DishId bigint)
as
begin
begin transaction
declare @result as varchar(30)
update Dishes set Status='D' where dishid=@DishId
if (@@ERROR>0)
begin
set @result='Error'
rollback transaction
end
else
begin
set @result= 'Success'
end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[Dishes_insert]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Dishes_insert](
@CategoryId as int,
 @DishName as varchar(20),
 @Image as varchar(20),
 @Price as Decimal(18,2),
 @Quantity as int
)
as
begin
begin transaction
     declare @result as varchar(50),@exist as int
    set @exist=(select count(*) from Dishes where DishName=@DishName and Status='A')
if(@exist>0)
     begin
         set @result='Already Exist'
     end
else
     begin
insert into  Dishes(CategoryId,DishName,Image,Price,Quantity,Status)
values(@CategoryId,@DishName,@Image,@Price,@Quantity,'A')

 if (@@error>0)
 begin
set @result='Error'
rollback transaction
end
else
begin
set @result='Success'
end
end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[feedback_insert]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[feedback_insert](
@userId int,
@comment varchar(200))
as
begin
   
insert into feedback(userId,comment)
values(@userId,@comment)

end
GO
/****** Object:  StoredProcedure [dbo].[Order_Insert]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[Order_Insert]
(
    @UserID INT,
    @UserName VARCHAR(20),
    @Email VARCHAR(20),
@Mobile int,
    @District VARCHAR(20),
    @Pincode BIGINT,
    @DishName VARCHAR(20),
    @Price DECIMAL(18,2),
    @Quantity INT,
    @Total_Price DECIMAL(18,2)
   
)
AS
BEGIN
    BEGIN TRANSACTION;
    DECLARE @result AS VARCHAR(50);

    UPDATE Users
    SET UserName = @UserName,
        Email = @Email,
        Mobile = @Mobile,
        District = @District,
        Pincode  = @Pincode
    WHERE UserID = @UserID;

   if (@@error>0)
    BEGIN  
        SET @result = 'Error';  
        ROLLBACK TRANSACTION;  
    END  
    ELSE  
    BEGIN  
        INSERT INTO Orders (UserId, dishid, DishName, Price ,  TotalPrice,Quantity,Status)
        VALUES (@UserID, (SELECT dishid FROM Dishes WHERE DishName = @DishName), @DishName, @Price,  @Total_Price,@Quantity,'Ordered');

        if (@@error>0)
        BEGIN  
            SET @result = 'Error';  
            ROLLBACK TRANSACTION;  
        END  
        ELSE  
        BEGIN  
            SET @result = 'Success';  
            COMMIT TRANSACTION;  
        END
    END

    SELECT @result;
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDishes]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SearchDishes]
   (
    @SearchCriteria NVARCHAR(100)
)
as
begin
    SET NOCOUNT ON;

    SELECT *
    FROM Dishes
    WHERE DishName LIKE '%' + @SearchCriteria + '%' AND Status = 'A';
end;




GO
/****** Object:  StoredProcedure [dbo].[selectallCategory]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[selectallCategory]
as
begin
select * from Category where Status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[selectalldishes]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[selectalldishes]
as
begin
select*from Dishes where Status='A';
end
GO
/****** Object:  StoredProcedure [dbo].[selectallfeedback]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[selectallfeedback]
as
begin
select * from feedback;
end
GO
/****** Object:  StoredProcedure [dbo].[selectallorders]    Script Date: 20-05-2024 11:52:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[selectallorders]
as
begin
select * from Orders  where status='Ordered'
end
GO
/****** Object:  StoredProcedure [dbo].[selectbyCategoryId]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[selectbyCategoryId](@CategoryId int)
as
begin
select Categoryname from Category where CategoryId=@CategoryId and Status='A'
end

GO
/****** Object:  StoredProcedure [dbo].[selectbydishbyid]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[selectbydishbyid](@dishid  int)
as
begin
select DishName,Image,Price from Dishes where dishid=@dishid and Status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[selectbyUserId]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[selectbyUserId](@UserId bigint)
as
begin
select  UserName,Email,Mobile,District,Pincode,Password from Users where UserId=@UserId and Status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[User_Insert]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[User_Insert](@UserName Varchar(100),
@Email Varchar(20),
@Mobile varchar(20),
@Pincode bigint,
@District varchar(20),
@Password varchar(20))
as
begin
begin transaction
     declare @result as varchar(50),@exist as int
    set @exist=(select count(*) from Users where UserName=@UserName and Status='A')
	 if(@exist>0)
     begin
         set @result='Already Exist'
     end
	 else
     begin
	insert into Users (UserName,Email,Mobile,Pincode,District,Password,Status )
	values(@UserName,@Email,@Mobile,@Pincode,@District,@Password,'A')
 if (@@error>0)
 begin
			set @result='Error'
			rollback transaction
		end
		else
		begin
			set @result='Success'
		end
	end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[Users_Delete]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Users_Delete](@UserId bigint)
as
begin
begin transaction
declare @result as varchar(30)
update Users set Status='D' where UserId=@UserId
if (@@ERROR>0)
begin
set @result='Error'
rollback transaction
end
else
begin
set @result= 'Success'
end
commit transaction
select @result
end
GO
/****** Object:  StoredProcedure [dbo].[Users_Update]    Script Date: 20-05-2024 11:52:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[Users_Update]
(@UserId as int,
@UserName Varchar(20),
@Email Varchar(20),
@Mobile varchar(20),
@Pincode bigint,
@District varchar(20),
@Password varchar(20)
)

as
begin
begin transaction
declare @result as varchar(30)


update [dbo].[Users] set UserName=@UserName,Email=Email,Mobile=@Mobile,District=@District,Password=@Password  where UserId=@UserId 
                             
if(@@ERROR>0)
begin
			set @result='Error'
			rollback transaction
		end
		else
		begin
			set @result='Success'
		end

commit transaction
select @result
end
GO
