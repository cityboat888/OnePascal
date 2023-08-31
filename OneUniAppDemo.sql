
 
CREATE TABLE [dbo].[demo_user](
	[FUserID] [nvarchar](32) primary key ,
	[FUserCode] [nvarchar](30) NULL,
	[FUserName] [nvarchar](30) NULL,
	[FUserPass] [nvarchar](50) NULL,
	[FCreateTime] [datetime] NULL)



 
CREATE TABLE [dbo].[demo_goods](
	[FGoodsID] [nvarchar](32) primary key,
	[FGoodsCode] [nvarchar](30) NULL,
	[FGoodsName] [nvarchar](50) NULL,
	[FGoodsPrice] [decimal](18, 2) NULL,
	[FGoodsRemark] [nvarchar](100) NULL,
	[FGoodsImgUrl] [nvarchar](255) NULL)


CREATE TABLE [dbo].[demo_sendreceiv](
	[FCustomerID] [nvarchar](32) primary key,
	[FCustomerCode] [nvarchar](30) NULL,
	[FCustomerName] [nvarchar](50) NULL,
	[FCustomerType] [nvarchar](10) NULL,
	[FCustomerLXR] [nvarchar](30) NULL,
	[FCustomerTel] [nvarchar](30) NULL,
	[FCustomerRemark] [nvarchar](100) NULL,
	[FCreateID] [nvarchar](32) NULL,
	[FCreateName] [nvarchar](30) NULL,
	[FCreateTime] [datetime] NULL)

	
CREATE TABLE [dbo].[demo_billsend](
	[FBillID] [nvarchar](32) primary key ,
	[FBillNo] [nvarchar](30) NULL,
	[FBillType] [nvarchar](10) NULL,
	[FBillDate] [datetime] NULL,
	[FBillSenderID] [nvarchar](32) NULL,
	[FBillSenderCode] [nvarchar](30) NULL,
	[FBillSenderName] [nvarchar](50) NULL,
	[FBillSenderLXR] [nvarchar](50) NULL,
	[FBillSenderTel] [nvarchar](30) NULL,
	[FBillSenderAddress] [nvarchar](50) NULL,
	[FBillReceivID] [nvarchar](32) NULL,
	[FBillReceivCode] [nvarchar](30) NULL,
	[FBillReceivName] [nvarchar](50) NULL,
	[FBillReceivLXR] [nvarchar](50) NULL,
	[FBillReceivTel] [nvarchar](30) NULL,
	[FBillReceivAddress] [nvarchar](50) NULL,
	[FBillAmount] [decimal](18, 4) NULL,
	[FBillRemark] [nvarchar](100) NULL,
	[FIsCFM] [bit] NULL,
	[FCFMName] [nvarchar](30) NULL,
	[FCFMTime] [datetime] NULL,
	[FCreateID] [nvarchar](32) NULL,
	[FCreateName] [nvarchar](30) NULL,
	[FCreateTime] [datetime] NULL)


	 

CREATE TABLE [dbo].[demo_billdetail](
	[FDetailID] [nvarchar](32) primary key,
	[FBillID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FGoodsID] [nvarchar](32) NULL,
	[FGoodsCode] [nvarchar](30) NULL,
	[FGoodsName] [nvarchar](50) NULL,
	[FGoodsQuantity] [decimal](18, 4) NULL,
	[FGoodsPrice] [decimal](18, 4) NULL,
	[FGoodsAmount] [decimal](18, 4) NULL,
	[FDetailRemark] [nvarchar](100) NULL)


