USE [OneFastClient]
GO
/****** Object:  Table [dbo].[onefast_group]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_group](
	[FGroupID] [nvarchar](32) NOT NULL,
	[FPGroupID] [nvarchar](32) NULL,
	[FGroupCode] [nvarchar](50) NULL,
	[FGroupCaption] [nvarchar](50) NULL,
	[FGroupType] [nvarchar](20) NULL,
	[FGroupTreeCode] [nvarchar](50) NULL,
	[FRemark] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[FGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_role]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_role](
	[FRoleID] [nvarchar](32) NOT NULL,
	[FPRoleID] [nvarchar](32) NULL,
	[FRoleCode] [nvarchar](50) NULL,
	[FRoleCaption] [nvarchar](50) NULL,
	[FRoleTreeCode] [nvarchar](50) NULL,
	[FRemark] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[FRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_admin]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_admin](
	[FAdminID] [nvarchar](32) NOT NULL,
	[FAdminCode] [nvarchar](50) NULL,
	[FAdminName] [nvarchar](50) NULL,
	[FAdminPass] [nvarchar](50) NULL,
	[FAdminTel] [nvarchar](20) NULL,
	[FAdminType] [nvarchar](10) NULL,
	[FGroupID] [nvarchar](32) NULL,
	[FRoleID] [nvarchar](32) NULL,
	[FIsEnable] [bit] NULL,
	[FIsMultiLogin] [bit] NULL,
	[FIsLimit] [bit] NULL,
	[FLimtStartTime] [datetime] NULL,
	[FLimtEndTime] [datetime] NULL,
	[FRemark] [nvarchar](100) NULL,
	[FCreateTime] [datetime] NULL,
 CONSTRAINT [PK__onefast___F5DAD0F4FE1E6D6B] PRIMARY KEY CLUSTERED 
(
	[FAdminID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_onefast_admin_group]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_onefast_admin_group]
as
select 
A.FAdminID, A.FAdminCode, A.FAdminName,A.FAdminPass,A.FAdminTel,A.FAdminType,A.FIsEnable,A.FIsLimit,
A.FLimtStartTime,A.FLimtEndTime,A.FRemark,A.FCreateTime,A.FIsMultiLogin,
A.FGroupID,B.FGroupTreeCode,B.FGroupCaption,A.FRoleID,C.FRoleCaption
from  onefast_admin A 
Left join onefast_group B on (A.FGroupID=B.FGroupID)
left join onefast_role C on (A.FRoleID=C.FRoleID)
GO
/****** Object:  Table [dbo].[demo_billdetail]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demo_billdetail](
	[FDetailID] [nvarchar](32) NOT NULL,
	[FBillID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FGoodsID] [nvarchar](32) NULL,
	[FGoodsCode] [nvarchar](30) NULL,
	[FGoodsName] [nvarchar](50) NULL,
	[FGoodsQuantity] [decimal](18, 4) NULL,
	[FGoodsPrice] [decimal](18, 4) NULL,
	[FGoodsAmount] [decimal](18, 4) NULL,
	[FDetailRemark] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[FDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[demo_billsend]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demo_billsend](
	[FBillID] [nvarchar](32) NOT NULL,
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
	[FCreateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FBillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[demo_goods]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demo_goods](
	[FGoodsID] [nvarchar](32) NOT NULL,
	[FGoodsCode] [nvarchar](30) NULL,
	[FGoodsName] [nvarchar](50) NULL,
	[FGoodsPrice] [decimal](18, 2) NULL,
	[FGoodsRemark] [nvarchar](100) NULL,
	[FGoodsImgUrl] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[FGoodsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[demo_sendreceiv]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demo_sendreceiv](
	[FCustomerID] [nvarchar](32) NOT NULL,
	[FCustomerCode] [nvarchar](30) NULL,
	[FCustomerName] [nvarchar](50) NULL,
	[FCustomerType] [nvarchar](10) NULL,
	[FCustomerLXR] [nvarchar](30) NULL,
	[FCustomerTel] [nvarchar](30) NULL,
	[FCustomerRemark] [nvarchar](100) NULL,
	[FCreateID] [nvarchar](32) NULL,
	[FCreateName] [nvarchar](30) NULL,
	[FCreateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FCustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[demo_user]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[demo_user](
	[FUserID] [nvarchar](32) NOT NULL,
	[FUserCode] [nvarchar](30) NULL,
	[FUserName] [nvarchar](30) NULL,
	[FUserPass] [nvarchar](50) NULL,
	[FCreateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[FUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_admin_role]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_admin_role](
	[FID] [nvarchar](32) NOT NULL,
	[FAdminID] [nvarchar](32) NULL,
	[FRoleID] [nvarchar](32) NULL,
	[FStatus] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_api]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_api](
	[FApiID] [nvarchar](32) NULL,
	[FPApiID] [nvarchar](32) NULL,
	[FApiCode] [nvarchar](50) NULL,
	[FApiCaption] [nvarchar](50) NULL,
	[FOrderNumber] [int] NULL,
	[FIsMenu] [bit] NULL,
	[FIsEnabled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_api_data]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_api_data](
	[FDataID] [nvarchar](32) NOT NULL,
	[FPDataID] [nvarchar](32) NULL,
	[FApiID] [nvarchar](32) NULL,
	[FTreeCode] [nvarchar](30) NULL,
	[FDataName] [nvarchar](50) NULL,
	[FDataCaption] [nvarchar](50) NULL,
	[FDataJsonName] [nvarchar](50) NULL,
	[FDataJsonType] [nvarchar](20) NULL,
	[FDataZTCode] [nvarchar](50) NULL,
	[FDataTable] [nvarchar](50) NULL,
	[FDataStoreName] [nvarchar](100) NULL,
	[FDataPrimaryKey] [nvarchar](50) NULL,
	[FDataOpenMode] [nvarchar](20) NULL,
	[FDataPageSize] [int] NULL,
	[FDataUpdateMode] [nvarchar](20) NULL,
	[FDataSQL] [text] NULL,
	[FMinAffected] [int] NULL,
	[FMaxAffected] [int] NULL,
 CONSTRAINT [PK_onefast_api_data] PRIMARY KEY CLUSTERED 
(
	[FDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_api_field]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_api_field](
	[FFieldID] [nvarchar](32) NULL,
	[FDataID] [nvarchar](32) NULL,
	[FApiID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FFieldName] [nvarchar](50) NULL,
	[FFieldCaption] [nvarchar](50) NULL,
	[FFieldJsonName] [nvarchar](50) NULL,
	[FFieldKind] [nvarchar](20) NULL,
	[FFieldDataType] [nvarchar](30) NULL,
	[FFieldSize] [int] NULL,
	[FFieldPrecision] [int] NULL,
	[FFieldProvidFlagKey] [bit] NULL,
	[FFieldProvidFlagUpdate] [bit] NULL,
	[FFieldProvidFlagWhere] [bit] NULL,
	[FFieldDefaultValueType] [nvarchar](30) NULL,
	[FFieldDefaultValue] [nvarchar](30) NULL,
	[FFieldShowPass] [bit] NULL,
	[FFieldCheckEmpty] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_api_filter]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_api_filter](
	[FFilterID] [nvarchar](32) NOT NULL,
	[FDataID] [nvarchar](32) NULL,
	[FApiID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FFilterName] [nvarchar](50) NULL,
	[FFilterCaption] [nvarchar](50) NULL,
	[FFilterJsonName] [nvarchar](50) NULL,
	[FFilterFieldMode] [nvarchar](20) NULL,
	[FFilterField] [nvarchar](50) NULL,
	[FPFilterField] [nvarchar](50) NULL,
	[FFilterFieldItems] [nvarchar](500) NULL,
	[FFilterDataType] [nvarchar](20) NULL,
	[FFilterFormat] [nvarchar](20) NULL,
	[FFilterExpression] [nvarchar](10) NULL,
	[FFilterbMust] [bit] NULL,
	[FFilterbValue] [bit] NULL,
	[FFilterDefaultType] [nvarchar](20) NULL,
	[FFilterDefaultValue] [nvarchar](50) NULL,
	[FbOutParam] [bit] NULL,
	[FOutParamTag] [nvarchar](30) NULL,
 CONSTRAINT [PK_onefast_api_filter] PRIMARY KEY CLUSTERED 
(
	[FFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_db]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_db](
	[FDBID] [nvarchar](32) NOT NULL,
	[FDBCode] [nvarchar](50) NULL,
	[FDBCaption] [nvarchar](50) NULL,
 CONSTRAINT [PK_onefast_db] PRIMARY KEY CLUSTERED 
(
	[FDBID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_db_field]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_db_field](
	[FFieldID] [nvarchar](32) NOT NULL,
	[FObjID] [nvarchar](32) NULL,
	[FDBID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FFieldName] [nvarchar](50) NULL,
	[FFieldCaption] [nvarchar](50) NULL,
	[FFieldType] [nvarchar](50) NULL,
	[FFieldPrecision] [int] NULL,
	[FFieldLength] [int] NULL,
	[FFieldRemark] [nvarchar](100) NULL,
 CONSTRAINT [PK_onefast_db_field] PRIMARY KEY CLUSTERED 
(
	[FFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_db_obj]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_db_obj](
	[FObjID] [nvarchar](32) NOT NULL,
	[FDBID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FObjName] [nvarchar](100) NULL,
	[FObjType] [nvarchar](20) NULL,
	[FObjCaption] [nvarchar](50) NULL,
 CONSTRAINT [PK_onefast_db_obj] PRIMARY KEY CLUSTERED 
(
	[FObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_file]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_file](
	[FFileID] [nvarchar](32) NOT NULL,
	[FFileSetCode] [nvarchar](50) NULL,
	[FFileName] [nvarchar](200) NULL,
	[FFileType] [nvarchar](50) NULL,
	[FFilePhyPath] [nvarchar](500) NULL,
	[FFileHttpUrl] [nvarchar](500) NULL,
	[FFileSize] [bigint] NULL,
	[FRelationID] [nvarchar](50) NULL,
	[FPRelationID] [nvarchar](50) NULL,
	[FFileRemark] [nvarchar](500) NULL,
	[FCreateTime] [datetime] NULL,
 CONSTRAINT [PK_onefast_file] PRIMARY KEY CLUSTERED 
(
	[FFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_file_set]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_file_set](
	[FFileSetID] [nvarchar](32) NOT NULL,
	[FFileSetCode] [nvarchar](50) NULL,
	[FFileSetCaption] [nvarchar](50) NULL,
	[FSavePhyPath] [nvarchar](255) NULL,
	[FSaveTable] [nvarchar](50) NULL,
	[FSaveMode] [nvarchar](30) NULL,
	[FIsEnabled] [bit] NULL,
 CONSTRAINT [PK_onefast_file_set_1] PRIMARY KEY CLUSTERED 
(
	[FFileSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_lsh_his]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_lsh_his](
	[FHisID] [nvarchar](32) NOT NULL,
	[FLshCode] [nvarchar](30) NULL,
	[FLshYear] [int] NULL,
	[FLshMonth] [int] NULL,
	[FLshDay] [int] NULL,
	[FLshMax] [int] NULL,
	[FUpdateTime] [datetime] NULL,
 CONSTRAINT [PK_onefast_lsh_his] PRIMARY KEY CLUSTERED 
(
	[FHisID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_lsh_set]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_lsh_set](
	[FLshID] [nvarchar](32) NOT NULL,
	[FLshCode] [nvarchar](30) NULL,
	[FLshCaption] [nvarchar](50) NULL,
	[FLshHead] [nvarchar](10) NULL,
	[FLshDateFormat] [nvarchar](20) NULL,
	[FLshNoLength] [int] NULL,
	[FIsEnabled] [bit] NULL,
 CONSTRAINT [PK_onefast_lsh_set] PRIMARY KEY CLUSTERED 
(
	[FLshID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_menu]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_menu](
	[FMenuID] [nvarchar](32) NOT NULL,
	[FPMenuID] [nvarchar](32) NULL,
	[FMenuTreeCode] [nvarchar](30) NULL,
	[FMenuCaption] [nvarchar](50) NULL,
	[FMenuImgIndex] [int] NULL,
	[FMenuOpenMode] [nvarchar](50) NULL,
	[FMenuModuleCode] [nvarchar](50) NULL,
	[FMenuScript] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[FMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module](
	[FModuleID] [nvarchar](32) NOT NULL,
	[FPModuoleID] [nvarchar](32) NULL,
	[FModuleCode] [nvarchar](50) NULL,
	[FModuleCaption] [nvarchar](50) NULL,
	[FModuleOrderNumber] [int] NULL,
	[FNextModuleOpenMode] [nvarchar](50) NULL,
	[FNextModuleCode] [nvarchar](50) NULL,
	[FbContextUnion] [bit] NULL,
	[FModuleRemark] [nvarchar](100) NULL,
	[FIsMenu] [bit] NULL,
	[FIsMulti] [bit] NULL,
	[FIsShowFilter] [bit] NULL,
	[FIsStart] [bit] NULL,
	[FModuleScript] [text] NULL,
	[FFileSetCode] [nvarchar](50) NULL,
 CONSTRAINT [PK__onefast___53901949D8BF4429] PRIMARY KEY CLUSTERED 
(
	[FModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_data]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_data](
	[FDataID] [nvarchar](32) NOT NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FDataName] [nvarchar](50) NULL,
	[FDataCaption] [nvarchar](50) NULL,
	[FDataTag] [int] NULL,
	[FDataZTCode] [nvarchar](50) NULL,
	[FDataTable] [nvarchar](50) NULL,
	[FDataPrimaryKey] [nvarchar](100) NULL,
	[FDataOpenMode] [nvarchar](20) NULL,
	[FDataPageSize] [int] NULL,
	[FDataIsPost] [bit] NULL,
	[FDataUpdateMode] [nvarchar](20) NULL,
	[FDataSQL] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[FDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_dataparam]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_dataparam](
	[FParamID] [nvarchar](32) NOT NULL,
	[FDataID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FParamName] [nvarchar](50) NULL,
	[FParamCaption] [nvarchar](50) NULL,
	[FParamValueType] [nvarchar](30) NULL,
	[FParamValue] [nvarchar](50) NULL,
	[FPDataIndex] [int] NULL,
	[FPDataFieldName] [nvarchar](50) NULL,
 CONSTRAINT [PK_onefast_module_dataparam] PRIMARY KEY CLUSTERED 
(
	[FParamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_field]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_field](
	[FFieldID] [nvarchar](32) NOT NULL,
	[FDataID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FFieldName] [nvarchar](50) NULL,
	[FFieldCaption] [nvarchar](50) NULL,
	[FFieldTag] [int] NULL,
	[FFieldKind] [nvarchar](20) NULL,
	[FFieldDataType] [nvarchar](30) NULL,
	[FFieldSize] [int] NULL,
	[FFieldPrecision] [int] NULL,
	[FFieldProvidFlagKey] [bit] NULL,
	[FFieldProvidFlagUpdate] [bit] NULL,
	[FFieldProvidFlagWhere] [bit] NULL,
	[FFieldDefaultValueType] [nvarchar](30) NULL,
	[FFieldDefaultValue] [nvarchar](30) NULL,
	[FFieldShowPassChar] [nvarchar](4) NULL,
	[FFieldSaveCheckEmpty] [nvarchar](20) NULL,
	[FFieldSaveCheckRepeat] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[FFieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_layout]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_layout](
	[FLayoutID] [nvarchar](32) NOT NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FButtonLayout] [text] NULL,
	[FControlLayout] [text] NULL,
	[FFormWidth] [int] NULL,
	[FFormHeight] [int] NULL,
	[FFilterFormLayout] [text] NULL,
	[FFilterFormWidth] [int] NULL,
	[FFilterFormHeight] [int] NULL,
	[FLayoutType] [nvarchar](20) NULL,
 CONSTRAINT [PK_onefast_module_layout] PRIMARY KEY CLUSTERED 
(
	[FLayoutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_report]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_report](
	[FReportID] [nvarchar](32) NOT NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FReportName] [nvarchar](50) NULL,
	[FPrintCount] [int] NULL,
	[FReportImg] [image] NULL,
	[FRemark] [nvarchar](100) NULL,
 CONSTRAINT [PK_onefast_module_report] PRIMARY KEY CLUSTERED 
(
	[FReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_reportdata]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_reportdata](
	[FDataID] [nvarchar](32) NOT NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FDataName] [nvarchar](30) NULL,
	[FDataCaption] [nvarchar](50) NULL,
	[FDataOpenMode] [nvarchar](20) NULL,
	[FDataStoreName] [nvarchar](50) NULL,
	[FDataSQL] [nvarchar](2000) NULL,
	[FDataRemark] [nvarchar](100) NULL,
 CONSTRAINT [PK_onefast_module_reportdata] PRIMARY KEY CLUSTERED 
(
	[FDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_ui]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_ui](
	[FUIID] [nvarchar](32) NOT NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FDataID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FUIType] [nvarchar](30) NULL,
	[FUIName] [nvarchar](50) NULL,
	[FUICaption] [nvarchar](50) NULL,
	[FUIShowGirdNo] [bit] NULL,
	[FUIShowGirdFindPanel] [bit] NULL,
	[FUIShowGridFilter] [bit] NULL,
	[FUIGridCanEdit] [bit] NULL,
	[FUIGridCanAdd] [bit] NULL,
	[FUIGridCanDel] [bit] NULL,
	[FTreeKeyID] [nvarchar](50) NULL,
	[FTreePKeyID] [nvarchar](50) NULL,
	[FUISet] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[FUIID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_uiband]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_uiband](
	[FBandID] [nvarchar](32) NOT NULL,
	[FPBandID] [nvarchar](32) NULL,
	[FUIID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FCaption] [nvarchar](50) NULL,
	[FFixedKind] [int] NULL,
	[FTreeCode] [nvarchar](30) NULL,
 CONSTRAINT [PK_onefast_module_uiband] PRIMARY KEY CLUSTERED 
(
	[FBandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_uibutton]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_uibutton](
	[FButtonID] [nvarchar](32) NOT NULL,
	[FPButtonID] [nvarchar](32) NULL,
	[FUIID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FButtonName] [nvarchar](50) NULL,
	[FButtonCaption] [nvarchar](30) NULL,
	[FButtonTag] [int] NULL,
	[FButtonType] [nvarchar](30) NULL,
	[FButtonImgIndex] [int] NULL,
	[FButtonTreeCode] [nvarchar](30) NULL,
	[FButtonScript] [text] NULL,
 CONSTRAINT [PK__onefast___3876DE5CF9E44C66] PRIMARY KEY CLUSTERED 
(
	[FButtonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_uibuttonpop]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_uibuttonpop](
	[FButtonID] [nvarchar](32) NOT NULL,
	[FPButtonID] [nvarchar](32) NULL,
	[FUIID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FButtonName] [nvarchar](50) NULL,
	[FButtonCaption] [nvarchar](30) NULL,
	[FButtonTag] [int] NULL,
	[FButtonType] [nvarchar](30) NULL,
	[FButtonImgIndex] [int] NULL,
	[FButtonTreeCode] [nvarchar](30) NULL,
	[FButtonScript] [text] NULL,
 CONSTRAINT [PK__onefast___3876DE5CE7EE850C] PRIMARY KEY CLUSTERED 
(
	[FButtonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_uicontrol]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_uicontrol](
	[FControlID] [nvarchar](32) NOT NULL,
	[FUIID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FControlType] [nvarchar](50) NULL,
	[FControlCaption] [nvarchar](50) NULL,
	[FGridBandID] [nvarchar](32) NULL,
	[FControlWidth] [int] NULL,
	[FControlField] [nvarchar](50) NULL,
	[FControlTag] [int] NULL,
	[FControlLabelColor] [int] NULL,
	[FControlOptionFormat] [nvarchar](30) NULL,
	[FControlVisible] [bit] NULL,
	[FControlReadOnly] [bit] NULL,
	[FControlEnabled] [bit] NULL,
	[FControlShowPass] [bit] NULL,
	[FControlSet] [text] NULL,
	[FColumnSum] [nvarchar](20) NULL,
 CONSTRAINT [PK__onefast___BEA2AED39031728D] PRIMARY KEY CLUSTERED 
(
	[FControlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_module_uifilter]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_module_uifilter](
	[FFilterID] [nvarchar](32) NOT NULL,
	[FUIID] [nvarchar](32) NULL,
	[FModuleID] [nvarchar](32) NULL,
	[FOrderNumber] [int] NULL,
	[FControlType] [nvarchar](50) NULL,
	[FControlName] [nvarchar](50) NULL,
	[FControlCaption] [nvarchar](50) NULL,
	[FControlWidth] [int] NULL,
	[FControlField] [nvarchar](50) NULL,
	[FControlTag] [int] NULL,
	[FControlLabelColor] [int] NULL,
	[FControlOptionFormat] [nvarchar](30) NULL,
	[FControlVisible] [bit] NULL,
	[FControlReadOnly] [bit] NULL,
	[FControlEnabled] [bit] NULL,
	[FCompareDefault] [nvarchar](20) NULL,
	[FControlDefaultValue] [nvarchar](30) NULL,
	[FIsNotEmpty] [bit] NULL,
	[FIsFastFilter] [bit] NULL,
 CONSTRAINT [PK__onefast___F88B6CA9262EB13C] PRIMARY KEY CLUSTERED 
(
	[FFilterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_role_menu]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_role_menu](
	[FID] [nvarchar](32) NOT NULL,
	[FRoleID] [nvarchar](32) NULL,
	[FMenuID] [nvarchar](32) NULL,
	[FStatus] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_weixin]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_weixin](
	[FAccountID] [nvarchar](32) NOT NULL,
	[FSourceID] [nvarchar](50) NULL,
	[FAppType] [nvarchar](20) NULL,
	[FAppID] [nvarchar](100) NULL,
	[FAppSecret] [nvarchar](255) NULL,
	[FMessageToken] [nvarchar](50) NULL,
	[FMessageEncodingAESKey] [nvarchar](255) NULL,
	[FAccessTokenExpireIn] [int] NULL,
	[FAccessToken] [nvarchar](250) NULL,
	[FAccessTokenLastTime] [datetime] NULL,
	[FGetAuthorCodeUrl] [nvarchar](200) NULL,
	[FErrWebUrl] [nvarchar](200) NULL,
	[FAccessTokenErrMsg] [nvarchar](1000) NULL,
	[FCreateTime] [datetime] NULL,
	[FJsApiTicket] [nvarchar](250) NULL,
	[FJsApiLastTime] [datetime] NULL,
	[FGetAuthorCodeAPI] [nvarchar](200) NULL,
 CONSTRAINT [PK__onefast___F99CBF9E9AEA59E9] PRIMARY KEY CLUSTERED 
(
	[FAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_weixin_user]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_weixin_user](
	[FID] [nvarchar](32) NOT NULL,
	[FAppID] [nvarchar](32) NULL,
	[FUnionID] [nvarchar](100) NULL,
	[FOpenID] [nvarchar](100) NULL,
	[FNickName] [nvarchar](255) NULL,
	[FAvatarUrl] [nvarchar](255) NULL,
 CONSTRAINT [PK_onefast_weixin_user] PRIMARY KEY CLUSTERED 
(
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_wexin_userbind]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_wexin_userbind](
	[FBindID] [nvarchar](32) NOT NULL,
	[FWXAppID] [nvarchar](32) NULL,
	[FOpenID] [nvarchar](100) NULL,
	[FUserType] [nvarchar](20) NULL,
	[FUserID] [nvarchar](32) NULL,
	[FCreateTime] [datetime] NULL,
	[FIsSuperAdmin] [bit] NULL,
 CONSTRAINT [PK_onefast_wexin_userbind] PRIMARY KEY CLUSTERED 
(
	[FBindID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_work]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_work](
	[FWorkID] [nvarchar](32) NOT NULL,
	[FWorkCode] [nvarchar](50) NULL,
	[FWorkCaption] [nvarchar](50) NULL,
	[FWorkBlod] [image] NULL,
	[FWorkRemark] [nvarchar](100) NULL,
 CONSTRAINT [PK_onefast_work] PRIMARY KEY CLUSTERED 
(
	[FWorkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[onefast_work_step]    Script Date: 2023/5/7 20:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onefast_work_step](
	[FStepID] [nvarchar](32) NOT NULL,
	[FWorkID] [nvarchar](32) NULL,
	[FStepCaption] [nvarchar](50) NULL,
	[FStepScript] [text] NULL,
 CONSTRAINT [PK_onefast_work_step] PRIMARY KEY CLUSTERED 
(
	[FStepID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'主键ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'onefast_db', @level2type=N'COLUMN',@level2name=N'FDBID'
GO
