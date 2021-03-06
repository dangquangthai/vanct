/****** Object:  Table [dbo].[Order]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderNr] [varchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[SessionId] [int] NOT NULL,
	[TableId] [int] NOT NULL,
	[OrderStatus] [varchar](50) NOT NULL,
	[OrderType] [varchar](50) NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Deposit] [float] NULL,
	[CustomerName] [nvarchar](250) NULL,
	[CustomerPhone] [nvarchar](250) NULL,
	[Discount] [int] NULL,
	[TotalLines] [float] NULL,
	[TotalOrder] [float] NULL,
	[IsPrinted] [bit] NOT NULL,
	[ServiceCost] [float] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Orderline]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Orderline](
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Price] [float] NULL,
	[Amount] [float] NOT NULL,
	[Discount] [int] NOT NULL,
	[LineStatus] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Orderline] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[GroupId] [int] NOT NULL,
	[OmName] [nvarchar](50) NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [int] NOT NULL,
	[ImageUrl] [varchar](50) NULL,
	[ValidStatus] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ChangedDate] [datetime] NULL,
	[ChangedBy] [int] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductGroup]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NULL,
	[PrintersName] [nvarchar](250) NULL,
	[ValidStatus] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProductGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Session]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Session](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[WorkingTime] [varchar](50) NOT NULL,
	[SessionStatus] [varchar](50) NOT NULL,
	[TotalReceived] [float] NOT NULL,
	[TotalExpensed] [float] NOT NULL,
	[Total] [float] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TableArea]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableArea](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](250) NOT NULL,
	[Discount] [int] NOT NULL,
 CONSTRAINT [PK_TableArea] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TablePos]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TablePos](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[AreaId] [int] NOT NULL,
	[ActiveOrderId] [int] NULL,
	[IsBusy] [bit] NOT NULL,
	[ValidStatus] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TablePos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 4/5/2016 10:06:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[UserType] [varchar](50) NOT NULL,
	[ValidStatus] [varchar](50) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Session] ADD  DEFAULT ((0)) FOR [TotalReceived]
GO
ALTER TABLE [dbo].[Session] ADD  DEFAULT ((0)) FOR [TotalExpensed]
GO
ALTER TABLE [dbo].[Session] ADD  DEFAULT ((0)) FOR [Total]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Session] FOREIGN KEY([SessionId])
REFERENCES [dbo].[Session] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Session]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_TablePos] FOREIGN KEY([TableId])
REFERENCES [dbo].[TablePos] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_TablePos]
GO
ALTER TABLE [dbo].[Orderline]  WITH CHECK ADD  CONSTRAINT [FK_Orderline_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
GO
ALTER TABLE [dbo].[Orderline] CHECK CONSTRAINT [FK_Orderline_Order]
GO
ALTER TABLE [dbo].[Orderline]  WITH CHECK ADD  CONSTRAINT [FK_Orderline_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[Orderline] CHECK CONSTRAINT [FK_Orderline_Product]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductGroup] FOREIGN KEY([GroupId])
REFERENCES [dbo].[ProductGroup] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductGroup]
GO
ALTER TABLE [dbo].[Session]  WITH CHECK ADD  CONSTRAINT [FK_Session_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Session] CHECK CONSTRAINT [FK_Session_User]
GO
ALTER TABLE [dbo].[TablePos]  WITH CHECK ADD  CONSTRAINT [FK_TablePos_TableArea] FOREIGN KEY([AreaId])
REFERENCES [dbo].[TableArea] ([Id])
GO
ALTER TABLE [dbo].[TablePos] CHECK CONSTRAINT [FK_TablePos_TableArea]
GO
USE [master]
GO
ALTER DATABASE [POS] SET  READ_WRITE 
GO
