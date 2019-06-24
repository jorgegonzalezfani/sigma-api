USE [master]
GO
/****** Object:  Database [sigma]    Script Date: 6/23/2019 8:52:54 PM ******/
CREATE DATABASE [sigma]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'sigma', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sigma.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'sigma_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\sigma_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [sigma] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [sigma].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [sigma] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [sigma] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [sigma] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [sigma] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [sigma] SET ARITHABORT OFF 
GO
ALTER DATABASE [sigma] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [sigma] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [sigma] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [sigma] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [sigma] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [sigma] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [sigma] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [sigma] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [sigma] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [sigma] SET  DISABLE_BROKER 
GO
ALTER DATABASE [sigma] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [sigma] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [sigma] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [sigma] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [sigma] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [sigma] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [sigma] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [sigma] SET RECOVERY FULL 
GO
ALTER DATABASE [sigma] SET  MULTI_USER 
GO
ALTER DATABASE [sigma] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [sigma] SET DB_CHAINING OFF 
GO
ALTER DATABASE [sigma] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [sigma] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [sigma] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'sigma', N'ON'
GO
ALTER DATABASE [sigma] SET QUERY_STORE = OFF
GO
USE [sigma]
GO
/****** Object:  UserDefinedFunction [dbo].[fnRandomCharacter]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnRandomCharacter] 
(    
    @size AS INT, --Tamaño de la cadena aleatoria
    @op AS VARCHAR(2) --Opción para letras(ABC..), numeros(123...) o ambos.
)
RETURNS VARCHAR(62)
AS
BEGIN    

    DECLARE @chars AS VARCHAR(52),
            @numbers AS VARCHAR(10),
            @strChars AS VARCHAR(62),        
            @strPass AS VARCHAR(62),
            @index AS INT,
            @cont AS INT

    SET @strPass = ''
    SET @strChars = ''    
    SET @chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    SET @numbers = '0123456789'

    SET @strChars = CASE @op WHEN 'C' THEN @chars --Letras
                        WHEN 'N' THEN @numbers --Números
                        WHEN 'CN' THEN @chars + @numbers --Ambos (Letras y Números)
                        ELSE '------'
                    END

    SET @cont = 0
    WHILE @cont < @size
    BEGIN
        SET @index = ceiling( ( SELECT rnd FROM vwRandom ) * (len(@strChars)))--Uso de la vista para el Rand() y no generar error.
        SET @strPass = @strPass + substring(@strChars, @index, 1)
        SET @cont = @cont + 1
    END    
        
    RETURN @strPass

END
GO
/****** Object:  View [dbo].[vwRandom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwRandom]
AS
SELECT RAND() as Rnd
GO
/****** Object:  Table [dbo].[AvailBooking]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailBooking](
	[DraffBookingId] [int] IDENTITY(1,1) NOT NULL,
	[Since] [datetime] NOT NULL,
	[Until] [datetime] NOT NULL,
	[Nights] [int] NOT NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[Show] [bit] NOT NULL,
 CONSTRAINT [PK_DraddBooking] PRIMARY KEY CLUSTERED 
(
	[DraffBookingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AvailHotel]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailHotel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HotelId] [int] NOT NULL,
 CONSTRAINT [PK_AvailHotel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AvailRoom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AvailToken] [varchar](100) NOT NULL,
	[RoomTypeId] [int] NOT NULL,
	[RateCode] [varchar](50) NOT NULL,
	[QuantityAvailable] [int] NOT NULL,
	[Nights] [int] NOT NULL,
	[Price] [decimal](18, 0) NOT NULL,
	[PriceTaxes] [decimal](18, 0) NOT NULL,
	[Taxes] [decimal](18, 0) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
 CONSTRAINT [PK_AvailRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AvailTransp]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AvailTransp](
	[AvailToken] [varchar](100) NULL,
	[MaxAdults] [int] NULL,
	[MaxChildren] [int] NULL,
	[Taxes] [decimal](18, 0) NULL,
	[Total] [decimal](18, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Booking]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Booking](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Number] [varchar](100) NOT NULL,
	[Since] [datetime] NOT NULL,
	[Until] [datetime] NOT NULL,
	[HotelId] [int] NOT NULL,
	[Nights] [int] NOT NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[IdStatus] [int] NOT NULL,
	[StatusDescription] [varchar](100) NOT NULL,
	[Taxes] [decimal](18, 0) NOT NULL,
	[Total] [decimal](18, 0) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdateAt] [datetime] NULL,
	[UpdatedByID] [int] NULL,
	[UpdatedByName] [varchar](50) NULL,
	[Show] [bit] NOT NULL,
 CONSTRAINT [PK_Reservation] PRIMARY KEY CLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormBooking]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormBooking](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BookingId] [int] NULL,
	[Since] [datetime] NOT NULL,
	[Until] [datetime] NOT NULL,
	[HotelId] [int] NULL,
	[Nights] [int] NOT NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[IdStatus] [int] NOT NULL,
	[IdTransfers] [int] NULL,
	[IncludeReverseTransfer] [bit] NOT NULL,
 CONSTRAINT [PK_FormBooking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormBookingRoom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormBookingRoom](
	[AvailToken] [varchar](100) NULL,
	[RoomTypeId] [int] NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_FormBookingRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormBookingRoomGuest]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormBookingRoomGuest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GuestId] [int] NULL,
	[Name] [varchar](50) NOT NULL,
	[Age] [int] NOT NULL,
	[IdAgeQualifying] [int] NOT NULL,
 CONSTRAINT [PK_FormBookingRoomGuest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FormBookingTranfer]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FormBookingTranfer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AvailTransFer] [varchar](100) NULL,
	[OriginType] [varchar](50) NOT NULL,
	[DestinationType] [int] NOT NULL,
 CONSTRAINT [PK_FormBookingTranfer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Guest]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Guest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoomId] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Age] [int] NOT NULL,
	[IdAgeQualifying] [int] NOT NULL,
	[AgeQualifyingDescription] [varchar](100) NOT NULL,
	[IdStatus] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdateAt] [datetime] NOT NULL,
	[UpdatedById] [int] NOT NULL,
	[UpdateByName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Guest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hotel]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hotel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ImageUrl] [varchar](250) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Show] [bit] NOT NULL,
 CONSTRAINT [PK_Hotels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RAvailBookingRoom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RAvailBookingRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdAvailBooking] [int] NOT NULL,
	[IdAvailRoom] [int] NOT NULL,
 CONSTRAINT [PK_AvailBookingRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RBookingRoom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RBookingRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumberBooking] [varchar](100) NOT NULL,
	[IdRoom] [int] NOT NULL,
 CONSTRAINT [PK_BookingRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RBookingTransfer]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RBookingTransfer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumberBooking] [varchar](100) NOT NULL,
	[IdTransfer] [int] NOT NULL,
 CONSTRAINT [PK_BookingTransfer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFormBookingBookingRoom]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFormBookingBookingRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdFormBooking] [int] NOT NULL,
	[IdFormRoomBooking] [int] NOT NULL,
 CONSTRAINT [PK_RFormBookingBookingRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RFormBookingRoomRoomGuest]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RFormBookingRoomRoomGuest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdFormBookingRoom] [int] NULL,
	[idFormBookingRoomGuest] [int] NULL,
 CONSTRAINT [PK_RFormBookingRoomRoomGuest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoomTypeId] [int] NOT NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[IdStatus] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdateAt] [datetime] NULL,
	[UpdatesById] [int] NULL,
	[UpdatedByName] [varchar](50) NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomType]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ImageUrl] [varchar](250) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Show] [bit] NOT NULL,
 CONSTRAINT [PK_RoomTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomTypeback]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomTypeback](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BookingId] [int] NOT NULL,
	[Adults] [int] NOT NULL,
	[Children] [int] NOT NULL,
	[IdStatus] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdateAt] [datetime] NOT NULL,
	[UpdatesById] [int] NULL,
	[UpdatedByName] [varchar](50) NULL,
	[Show] [bit] NOT NULL,
 CONSTRAINT [PK_RoomType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RRoomGuest]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RRoomGuest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRoom] [int] NOT NULL,
	[IdGuests] [int] NOT NULL,
 CONSTRAINT [PK_RoomGuests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IdType] [int] NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transfer]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transfer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](100) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[OriginCode] [varchar](100) NOT NULL,
	[OriginType] [int] NOT NULL,
	[DestinationCode] [varchar](100) NOT NULL,
	[DestinationType] [int] NOT NULL,
	[IdStatus] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_Transport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Type]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Type](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IdType] [int] NULL,
 CONSTRAINT [PK_Type] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypeStatus]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_TypeStatu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TypeType]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TypeType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TypeType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AvailBooking] ADD  CONSTRAINT [DF_AvailBooking_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[Booking] ADD  CONSTRAINT [DF_Booking_UpdatedByID]  DEFAULT ((0)) FOR [UpdatedByID]
GO
ALTER TABLE [dbo].[Booking] ADD  CONSTRAINT [DF_Booking_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[Hotel] ADD  CONSTRAINT [DF_Hotel_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[RoomType] ADD  CONSTRAINT [DF_RoomType_Show_1]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[RoomTypeback] ADD  CONSTRAINT [DF_RoomType_Show]  DEFAULT ((1)) FOR [Show]
GO
ALTER TABLE [dbo].[AvailRoom]  WITH CHECK ADD  CONSTRAINT [FK_AvailRoom_RoomType] FOREIGN KEY([RoomTypeId])
REFERENCES [dbo].[RoomType] ([Id])
GO
ALTER TABLE [dbo].[AvailRoom] CHECK CONSTRAINT [FK_AvailRoom_RoomType]
GO
ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK_Booking_Hotel] FOREIGN KEY([HotelId])
REFERENCES [dbo].[Hotel] ([Id])
GO
ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK_Booking_Hotel]
GO
ALTER TABLE [dbo].[Booking]  WITH CHECK ADD  CONSTRAINT [FK_Booking_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Booking] CHECK CONSTRAINT [FK_Booking_Status]
GO
ALTER TABLE [dbo].[FormBookingRoomGuest]  WITH CHECK ADD  CONSTRAINT [FK_FormBookingRoomGuest_Type] FOREIGN KEY([IdAgeQualifying])
REFERENCES [dbo].[Type] ([Id])
GO
ALTER TABLE [dbo].[FormBookingRoomGuest] CHECK CONSTRAINT [FK_FormBookingRoomGuest_Type]
GO
ALTER TABLE [dbo].[Guest]  WITH CHECK ADD  CONSTRAINT [FK_Guest_Room] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[Guest] CHECK CONSTRAINT [FK_Guest_Room]
GO
ALTER TABLE [dbo].[Guest]  WITH CHECK ADD  CONSTRAINT [FK_Guest_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Guest] CHECK CONSTRAINT [FK_Guest_Status]
GO
ALTER TABLE [dbo].[Guest]  WITH CHECK ADD  CONSTRAINT [FK_Guest_Type] FOREIGN KEY([IdAgeQualifying])
REFERENCES [dbo].[Type] ([Id])
GO
ALTER TABLE [dbo].[Guest] CHECK CONSTRAINT [FK_Guest_Type]
GO
ALTER TABLE [dbo].[RAvailBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_AvailBookingRoom_AvailBooking] FOREIGN KEY([IdAvailBooking])
REFERENCES [dbo].[AvailBooking] ([DraffBookingId])
GO
ALTER TABLE [dbo].[RAvailBookingRoom] CHECK CONSTRAINT [FK_AvailBookingRoom_AvailBooking]
GO
ALTER TABLE [dbo].[RAvailBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_AvailBookingRoom_AvailRoom] FOREIGN KEY([IdAvailRoom])
REFERENCES [dbo].[AvailRoom] ([Id])
GO
ALTER TABLE [dbo].[RAvailBookingRoom] CHECK CONSTRAINT [FK_AvailBookingRoom_AvailRoom]
GO
ALTER TABLE [dbo].[RBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_BookingRoom_Booking] FOREIGN KEY([NumberBooking])
REFERENCES [dbo].[Booking] ([Number])
GO
ALTER TABLE [dbo].[RBookingRoom] CHECK CONSTRAINT [FK_BookingRoom_Booking]
GO
ALTER TABLE [dbo].[RBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_BookingRoom_Room] FOREIGN KEY([IdRoom])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[RBookingRoom] CHECK CONSTRAINT [FK_BookingRoom_Room]
GO
ALTER TABLE [dbo].[RBookingTransfer]  WITH CHECK ADD  CONSTRAINT [FK_BookingTransfer_Booking] FOREIGN KEY([NumberBooking])
REFERENCES [dbo].[Booking] ([Number])
GO
ALTER TABLE [dbo].[RBookingTransfer] CHECK CONSTRAINT [FK_BookingTransfer_Booking]
GO
ALTER TABLE [dbo].[RBookingTransfer]  WITH CHECK ADD  CONSTRAINT [FK_BookingTransfer_Transport] FOREIGN KEY([IdTransfer])
REFERENCES [dbo].[Transfer] ([Id])
GO
ALTER TABLE [dbo].[RBookingTransfer] CHECK CONSTRAINT [FK_BookingTransfer_Transport]
GO
ALTER TABLE [dbo].[RFormBookingBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_RFormBookingBookingRoom_FormBooking] FOREIGN KEY([IdFormBooking])
REFERENCES [dbo].[FormBooking] ([Id])
GO
ALTER TABLE [dbo].[RFormBookingBookingRoom] CHECK CONSTRAINT [FK_RFormBookingBookingRoom_FormBooking]
GO
ALTER TABLE [dbo].[RFormBookingBookingRoom]  WITH CHECK ADD  CONSTRAINT [FK_RFormBookingBookingRoom_FormBookingRoom] FOREIGN KEY([IdFormRoomBooking])
REFERENCES [dbo].[FormBookingRoom] ([Id])
GO
ALTER TABLE [dbo].[RFormBookingBookingRoom] CHECK CONSTRAINT [FK_RFormBookingBookingRoom_FormBookingRoom]
GO
ALTER TABLE [dbo].[RFormBookingRoomRoomGuest]  WITH CHECK ADD  CONSTRAINT [FK_RFormBookingRoomRoomGuest_FormBookingRoom] FOREIGN KEY([IdFormBookingRoom])
REFERENCES [dbo].[FormBookingRoom] ([Id])
GO
ALTER TABLE [dbo].[RFormBookingRoomRoomGuest] CHECK CONSTRAINT [FK_RFormBookingRoomRoomGuest_FormBookingRoom]
GO
ALTER TABLE [dbo].[RFormBookingRoomRoomGuest]  WITH CHECK ADD  CONSTRAINT [FK_RFormBookingRoomRoomGuest_FormBookingRoomGuest] FOREIGN KEY([idFormBookingRoomGuest])
REFERENCES [dbo].[FormBookingRoomGuest] ([Id])
GO
ALTER TABLE [dbo].[RFormBookingRoomRoomGuest] CHECK CONSTRAINT [FK_RFormBookingRoomRoomGuest_FormBookingRoomGuest]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [FK_Room_RoomType] FOREIGN KEY([RoomTypeId])
REFERENCES [dbo].[RoomType] ([Id])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [FK_Room_RoomType]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [FK_Room_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [FK_Room_Status]
GO
ALTER TABLE [dbo].[RRoomGuest]  WITH CHECK ADD  CONSTRAINT [FK_RoomGuest_Guest] FOREIGN KEY([IdGuests])
REFERENCES [dbo].[Guest] ([Id])
GO
ALTER TABLE [dbo].[RRoomGuest] CHECK CONSTRAINT [FK_RoomGuest_Guest]
GO
ALTER TABLE [dbo].[RRoomGuest]  WITH CHECK ADD  CONSTRAINT [FK_RoomGuest_Room] FOREIGN KEY([IdRoom])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[RRoomGuest] CHECK CONSTRAINT [FK_RoomGuest_Room]
GO
ALTER TABLE [dbo].[Transfer]  WITH CHECK ADD  CONSTRAINT [FK_Transfer_Status] FOREIGN KEY([IdStatus])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Transfer] CHECK CONSTRAINT [FK_Transfer_Status]
GO
ALTER TABLE [dbo].[Transfer]  WITH CHECK ADD  CONSTRAINT [FK_Transfer_Type] FOREIGN KEY([OriginType])
REFERENCES [dbo].[Type] ([Id])
GO
ALTER TABLE [dbo].[Transfer] CHECK CONSTRAINT [FK_Transfer_Type]
GO
ALTER TABLE [dbo].[Transfer]  WITH CHECK ADD  CONSTRAINT [FK_Transfer_Type1] FOREIGN KEY([DestinationType])
REFERENCES [dbo].[Type] ([Id])
GO
ALTER TABLE [dbo].[Transfer] CHECK CONSTRAINT [FK_Transfer_Type1]
GO
/****** Object:  StoredProcedure [dbo].[Procedure_AvailBookingChange]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de los ipdate, insert and edit de la data referia a la tabla AvailBooking
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_AvailBookingChange]
@FILTER VARCHAR(MAX),
@DATA VARCHAR(MAX)
AS
BEGIN

-- EXEC Procedure_AvailBookingChange '{"NAME_QUERY":"create"}', '{ "Data": { "Since": "2019-06-23 17:57:30.127", "Until": "2019-06-23 17:57:30.127", "Adults": 5, "Children": 0  },  "Room": {    "IdAvailRoom": 3, "Link": 1  }}'

-- EXEC Procedure_AvailBookingChange '{"NAME_QUERY":"update"}', '{ "Data": { "DraffBookingId": 1, "Since": "2019-06-23 17:57:30.127", "Until": "2019-06-23 17:57:30.127",  "Adults": 10, "Children": 0 },  "Room": {  "IdAvailBooking": 1,  "IdAvailRoom": 3, "Link": 1  }}'

-- EXEC Procedure_AvailBookingChange '{"NAME_QUERY":"deleteById"}', '{"DraffBookingId":1}'


BEGIN TRANSACTION TRANS_AVAILBOOKING
   BEGIN TRY

	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js
	
	--Seccion para crear un nuevo registro
	IF (@NAME_QUERY = 'create')
	BEGIN

	--Declarando tabla temporal para almacenar los datos insertando en la tabla, tales como el id generado
	DECLARE @IdentityAvailBooking AS TABLE ([ActualKey] INT, [IdAuto] INT IDENTITY(1,1));
	--insertando los datos a la tabla AvailBooking, mediante el json
	INSERT INTO [dbo].[AvailBooking]
           ([Since]
           ,[Until]
           ,[Nights]
           ,[Adults]
           ,[Children])
	OUTPUT inserted.[DraffBookingId] INTO @IdentityAvailBooking(ActualKey)
	SELECT	[Since], 
			[Until], 
			0 AS [Nights], --calcular a partir de la fecha desde y hasta
			[Adults],
			[Children]
		FROM OPENJSON (@DATA)  WITH ([Data] NVARCHAR(MAX) AS JSON ) dp
		CROSS APPLY OPENJSON (dp.[Data]) 
		WITH(
			[Since]				DATETIME,
			[Until]				DATETIME,
			[Adults]			INT,
			[Children]			INT
		) AS js

		--Insertando la relacion entre la habitaciones y la reservacion
		INSERT INTO [dbo].[RAvailBookingRoom]
           ([IdAvailBooking]
           ,[IdAvailRoom])
		SELECT ib.[ActualKey], js.[IdAvailRoom]
		FROM OPENJSON (@DATA)  WITH ([Room] NVARCHAR(MAX) AS JSON) dp
			CROSS APPLY OPENJSON (dp.[Room]) 
			WITH(
				[IdAvailRoom]	INT,
				[Link]			INT
			) AS js
			INNER JOIN @IdentityAvailBooking ib ON ib.[IdAuto] = js.[Link]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Actualizando los registros
	ELSE IF (@NAME_QUERY = 'update')
	BEGIN

		--Actualizando los datos de la cabezera
		UPDATE ab SET	[Since]				= js.[Since], 
						[Until]				= js.[Until], 
						[Adults]			= js.[Adults],
						[Children]			= js.[Children]
			FROM OPENJSON (@DATA)  WITH ([Data] NVARCHAR(MAX) AS JSON ) dp
			CROSS APPLY OPENJSON (dp.[Data]) 
			WITH(
				[DraffBookingId]	INT,
				[Since]				DATETIME,
				[Until]				DATETIME,
				[Adults]			INT,
				[Children]			INT
			) AS js
			INNER JOIN [dbo].[AvailBooking] ab ON ab.[DraffBookingId] = js.[DraffBookingId]

			--Declarando tabla temporal entre la habitaciones y la reservacion
			DECLARE @tmpRAvailBookingRoom AS TABLE ([IdAvailRoom] INT, [IdAvailBooking] INT);

			--insertando los datos a la tabla temporal
			INSERT INTO @tmpRAvailBookingRoom
			SELECT [IdAvailRoom], [IdAvailBooking]
			FROM OPENJSON (@DATA)  WITH ([Room] NVARCHAR(MAX) AS JSON) dp
				CROSS APPLY OPENJSON (dp.[Room]) 
				WITH(
					[IdAvailRoom]		INT,
					[IdAvailBooking]	INT
				) AS js

			--Eliminado los registros existenten entre la habitaciones y la reservacion
			DELETE FROM rab
			FROM @tmpRAvailBookingRoom tmpB
			INNER JOIN [dbo].[RAvailBookingRoom] rab ON rab.[IdAvailBooking] = tmpB.[IdAvailBooking]

			--Insertando la relacion entre la habitaciones y la reservacion
			INSERT INTO [dbo].[RAvailBookingRoom]
			   ([IdAvailRoom]
			   ,[IdAvailBooking])
			SELECT [IdAvailRoom], [IdAvailBooking]
			FROM @tmpRAvailBookingRoom

			--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
			IF(@@ROWCOUNT > 0)
				SELECT 0 AS Error
			ELSE
				SELECT 1 AS Error

	END
	--Ocultando los datos a la vista del usuario
	ELSE IF (@NAME_QUERY = 'deleteById')
	BEGIN

		--Actualizando el estado del show en booking
		UPDATE ab
		   SET [Show] = 0
		FROM OPENJSON (@DATA) 
		WITH(
			[DraffBookingId]	INT  N'strict $.DraffBookingId'
		) AS js
		INNER JOIN [dbo].[AvailBooking] ab ON ab.[DraffBookingId] = js.[DraffBookingId]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END

--Haciendo commit
COMMIT TRANSACTION TRANS_AVAILBOOKING;

END TRY
   BEGIN CATCH
    
	--RETORNANDO EL ERROR OCURRIDO
	SELECT  '[0] OCURRIO ALGUN ERROR' AS MAIN, ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage ;  
	IF(@@TRANCOUNT > 0)
	ROLLBACK TRANSACTION TRANS_AVAILBOOKING;

   END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Procedure_AvailBookingQuery]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de obtener los datos de la tabla AvailBooking
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_AvailBookingQuery]
	@FILTER VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js

	--Obteniendo los registro de la tabla AvailBooking, que esten disponibles
	IF (@NAME_QUERY = 'list')
	BEGIN

			SELECT [DraffBookingId]
			  ,[Since]
			  ,[Until]
			  ,[Nights]
			  ,[Adults]
			  ,[Children]
		  FROM [sigma].[dbo].[AvailBooking]
		  WHERE [Show] = 1
		  
	END


END
GO
/****** Object:  StoredProcedure [dbo].[Procedure_BookingChange]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de los ipdate, insert and edit de la data referia a la tabla Booking
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_BookingChange]
@FILTER VARCHAR(MAX),
@DATA VARCHAR(MAX)
AS
BEGIN

-- EXEC Procedure_BookingChange '{"NAME_QUERY":"create"}', '{ "Data": { "Since": "2019-06-23 17:57:30.127", "Until": "2019-06-23 17:57:30.127", "HotelId": 1,   "Adults": 5, "Children": 0, "IdStatus": 1, "StatusDescription": "se actualizo el registro"  },  "Room": {    "IdRoom": 4, "Link": 1  },  "Transfer": {   "IdTransfer": 1,    "Link": 1  }}'

-- EXEC Procedure_BookingChange '{"NAME_QUERY":"update"}', '{ "Data": { "Number": "R241TBCW1HL1UUN8T1U643M378DYAJ9N1H4DV0XW0KPX4BDG7O832G73J5FYH8", "Since": "2019-06-23 17:57:30.127", "Until": "2019-06-23 17:57:30.127", "HotelId": 1,   "Adults": 5, "Children": 0, "IdStatus": 1, "StatusDescription": "se actualizo el registro"  },  "Room": {  "Number": "R241TBCW1HL1UUN8T1U643M378DYAJ9N1H4DV0XW0KPX4BDG7O832G73J5FYH8",  "IdRoom": 4, "Link": 1  },  "Transfer": {  "Number": "R241TBCW1HL1UUN8T1U643M378DYAJ9N1H4DV0XW0KPX4BDG7O832G73J5FYH8", "IdTransfer": 1,    "Link": 1  }}'

-- EXEC Procedure_BookingChange '{"NAME_QUERY":"deleteById"}', '{"NumberBooking":"R241TBCW1HL1UUN8T1U643M378DYAJ9N1H4DV0XW0KPX4BDG7O832G73J5FYH8"}'


BEGIN TRANSACTION TRANS_BOOKING
   BEGIN TRY

	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js

	--Seccion para crear un nuevo registro
	IF (@NAME_QUERY = 'create')
	BEGIN
	--Declarando tabla temporal para almacenar los datos insertando en la tabla, tales como el id generado
	DECLARE @IdentityBooking AS TABLE ([ActualKey] VARCHAR(100), [IdAuto] INT IDENTITY(1,1))
	--insertando los datos a la tabla Booking, mediante el json
	INSERT INTO [dbo].[Booking]
           ([Number]
           ,[Since]
           ,[Until]
           ,[HotelId]
           ,[Nights]
           ,[Adults]
           ,[Children]
           ,[IdStatus]
           ,[StatusDescription]
           ,[Taxes]
           ,[Total]
           ,[CreatedAt])
	OUTPUT inserted.[Number] INTO @IdentityBooking(ActualKey)
	SELECT	sigma.dbo.fnRandomCharacter(100,'CN') AS [Number], 
			[Since], 
			[Until], 
			[HotelId],
			0 AS [Nights], --calcular a partir de la fecha desde y hasta
			[Adults],
			[Children],
            [IdStatus],
            [StatusDescription],
            0 AS Taxes,--[Taxes],
            ([Adults] + ([Children] / 2) * 500) AS [Total], -- calculado todo a 500 por persona y los ni;os a 250
            GETDATE()
		FROM OPENJSON (@DATA)  WITH ([Data] NVARCHAR(MAX) AS JSON ) dp
		CROSS APPLY OPENJSON (dp.[Data]) 
		WITH(
			[Since]				DATETIME,
			[Until]				DATETIME,
			[HotelId]			INT,
			[Adults]			INT,
			[Children]			INT,
            [IdStatus]			INT,
            [StatusDescription]	VARCHAR(100)
		) AS js

		--Insertando la relacion entre la habitaciones y la reservacion
		INSERT INTO [dbo].[RBookingRoom]
           ([NumberBooking]
           ,[IdRoom])
		SELECT ib.[ActualKey], js.[IdRoom]
		FROM OPENJSON (@DATA)  WITH ([Room] NVARCHAR(MAX) AS JSON) dp
			CROSS APPLY OPENJSON (dp.[Room]) 
			WITH(
				[IdRoom]	INT,
				[Link]		INT
			) AS js
			INNER JOIN @IdentityBooking ib ON ib.[IdAuto] = js.[Link]

		--Insertando la relacion entre la reservacion y el tranporte
		INSERT INTO [dbo].[RBookingTransfer]
           ([NumberBooking]
           ,[IdTransfer])
		SELECT ib.[ActualKey], js.[IdTransfer]
		FROM OPENJSON (@DATA)  WITH ([Transfer] NVARCHAR(MAX) AS JSON) dp
			CROSS APPLY OPENJSON (dp.[Transfer]) 
			WITH(
				[IdTransfer]	INT,
				[Link]			INT
			) AS js
			INNER JOIN @IdentityBooking ib ON ib.[IdAuto] = js.[Link]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Actualizando los registros
	ELSE IF (@NAME_QUERY = 'update')
	BEGIN

		--Actualizando los datos de la cabezera
		UPDATE bk SET	[Since]				= js.[Since], 
						[Until]				= js.[Until], 
						[HotelId]			= js.[HotelId],
						[Adults]			= js.[Adults],
						[Children]			= js.[Children],
						[IdStatus]			= js.[IdStatus],
						[StatusDescription] = js.[StatusDescription],
						[Total]				= (js.[Adults] + (js.[Children] / 2) * 500),
						[UpdateAt]			= GETDATE()
			FROM OPENJSON (@DATA)  WITH ([Data] NVARCHAR(MAX) AS JSON ) dp
			CROSS APPLY OPENJSON (dp.[Data]) 
			WITH(
				[Number]			VARCHAR(100),
				[Since]				DATETIME,
				[Until]				DATETIME,
				[HotelId]			INT,
				[Adults]			INT,
				[Children]			INT,
				[IdStatus]			INT,
				[StatusDescription]	VARCHAR(100)
			) AS js
			INNER JOIN [dbo].[Booking] bk ON bk.[Number] = js.[Number]

			--Declarando tabla temporal entre la habitaciones y la reservacion
			DECLARE @tmpRBookingRoom AS TABLE ([IdRoom]	INT, [Number] VARCHAR(100));

			--insertando los datos a la tabla temporal
			INSERT INTO @tmpRBookingRoom
			SELECT [IdRoom], [Number]
			FROM OPENJSON (@DATA)  WITH ([Room] NVARCHAR(MAX) AS JSON) dp
				CROSS APPLY OPENJSON (dp.[Room]) 
				WITH(
					[IdRoom]	INT,
					[Number] VARCHAR(100)
				) AS js

			--Eliminado los registros existenten entre la habitaciones y la reservacion
			DELETE FROM rbr
			FROM @tmpRBookingRoom tmpB
			INNER JOIN [dbo].[RBookingRoom] rbr ON rbr.[NumberBooking] = tmpB.[Number]

			--Insertando la relacion entre la habitaciones y la reservacion
			INSERT INTO [dbo].[RBookingRoom]
			   ([NumberBooking]
			   ,[IdRoom])
			SELECT [Number], [IdRoom]
			FROM @tmpRBookingRoom

			--Declarando tabla temporal entre la habitaciones y la reservacion
			DECLARE @tmpRBookingTransfer AS TABLE ([IdTransfer]	INT, [Number] VARCHAR(100));

			--insertando los datos a la tabla temporal
			INSERT INTO @tmpRBookingTransfer
			SELECT [IdTransfer], [Number]
			FROM OPENJSON (@DATA)  WITH ([Transfer] NVARCHAR(MAX) AS JSON) dp
				CROSS APPLY OPENJSON (dp.[Transfer]) 
				WITH(
					[IdTransfer]	INT,
					[Number] VARCHAR(100)
				) AS js

			--Eliminado los registros existenten entre la habitaciones y la reservacion
			DELETE FROM rbt
			FROM @tmpRBookingTransfer tmpB
			INNER JOIN [dbo].[RBookingTransfer] rbt ON rbt.[NumberBooking] = tmpB.[Number]

			--Insertando la relacion entre la reservacion y el tranporte
			INSERT INTO [dbo].[RBookingTransfer]
			   ([NumberBooking]
			   ,[IdTransfer])
			SELECT [Number], [IdTransfer]
			FROM @tmpRBookingTransfer

			--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
			IF(@@ROWCOUNT > 0)
				SELECT 0 AS Error
			ELSE
				SELECT 1 AS Error

	END
	--Ocultando los datos a la vista del usuario
	ELSE IF (@NAME_QUERY = 'deleteById')
	BEGIN

		--Actualizando el estado del show en booking
		UPDATE bk
		   SET [Show] = 0
		FROM OPENJSON (@DATA) 
		WITH(
			[NumberBooking]	VARCHAR(MAX) N'strict $.NumberBooking'
		) AS js
		INNER JOIN [dbo].[Booking] bk ON bk.[Number] = js.[NumberBooking]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END

--Haciendo commit
COMMIT TRANSACTION TRANS_BOOKING;

END TRY
   BEGIN CATCH
    
	--RETORNANDO EL ERROR OCURRIDO
	SELECT  '[0] OCURRIO ALGUN ERROR' AS MAIN, ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage ;  
	IF(@@TRANCOUNT > 0)
	ROLLBACK TRANSACTION TRANS_BOOKING;

   END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Procedure_BookingQuery]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de obtener los datos de la tabla Booking
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_BookingQuery]
	@FILTER VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js

	--Obteniendo los registro de la tabla AvailBooking, que esten disponibles
	IF (@NAME_QUERY = 'list')
	BEGIN

			SELECT [Id]
			  ,[Number]
			  ,[Since]
			  ,[Until]
			  ,[HotelId]
			  ,[Nights]
			  ,[Adults]
			  ,[Children]
			  ,[IdStatus]
			  ,[StatusDescription]
			  ,[Taxes]
			  ,[Total]
			  ,[CreatedAt]
			  ,[UpdateAt]
			  ,[UpdatedByID]
			  ,[UpdatedByName]
		  FROM [sigma].[dbo].[Booking]
		  WHERE [Show] = 1
		  
	END


END
GO
/****** Object:  StoredProcedure [dbo].[Procedure_HotelChange]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de los ipdate, insert and edit de la data referia a la tabla AvailBooking
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_HotelChange]
@FILTER VARCHAR(MAX),
@DATA VARCHAR(MAX)
AS
BEGIN

BEGIN TRANSACTION TRANS_HOTEL
   BEGIN TRY

	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js
	
	--Seccion para crear un nuevo registro
	IF (@NAME_QUERY = 'create')
	BEGIN

		--insertando los datos a la tabla [Hotel], mediante el json
		INSERT INTO [dbo].[Hotel]
           ([Code]
           ,[Name]
           ,[ImageUrl]
           ,[CreatedAt])
     SELECT sigma.dbo.fnRandomCharacter(8,'CN') AS [Code], [Name], [ImageUrl], GETDATE()
		FROM OPENJSON (@DATA) 
		WITH(
			[Name] VARCHAR(50)	N'strict $.Name',
			[ImageUrl] VARCHAR(250)
		) AS js

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Actualizando los registros
	ELSE IF (@NAME_QUERY = 'update')
	BEGIN

		--Actualizando los datos de la cabezera
		UPDATE [dbo].[Hotel]
		   SET [Name] = js.[Name]
			  ,[ImageUrl] = js.[ImageUrl]
		FROM OPENJSON (@DATA) 
		WITH(
			[Id]	INT N'strict $.Id',
			[Name] VARCHAR(50),
			[ImageUrl] VARCHAR(250)
		) AS js
		INNER JOIN [dbo].[Hotel] ht ON ht.[Id] = js.[Id]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Ocultando los datos a la vista del usuario
	ELSE IF (@NAME_QUERY = 'deleteById')
	BEGIN

	--Actualizando el estado del show en [Hotel]
		UPDATE [dbo].[Hotel]
		   SET [Show] = 0
		FROM OPENJSON (@DATA) 
		WITH(
			[Id]	INT N'strict $.Id'
		) AS js
		INNER JOIN [dbo].[Hotel] ht ON ht.[Id] = js.[Id]

		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END

--Haciendo commit
COMMIT TRANSACTION TRANS_HOTEL;

END TRY
   BEGIN CATCH
    
	--RETORNANDO EL ERROR OCURRIDO
	SELECT  '[0] OCURRIO ALGUN ERROR' AS MAIN, ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage ;  
	IF(@@TRANCOUNT > 0)
	ROLLBACK TRANSACTION TRANS_HOTEL;

   END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[Procedure_HotelQuery]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de obtener los datos de la tabla Hotel
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_HotelQuery]
	@FILTER VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js

	--Obteniendo los registro de la tabla AvailBooking, que esten disponibles
	IF (@NAME_QUERY = 'list')
	BEGIN

		SELECT [Id]
			  ,[Code]
			  ,[Name]
			  ,[ImageUrl]
			  ,[CreatedAt]
		  FROM [sigma].[dbo].[Hotel]
		  WHERE [Show] = 1
	END


END
GO
/****** Object:  StoredProcedure [dbo].[Procedure_RoomTypeChange]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de los ipdate, insert and edit de la data referia a la tabla RoomType
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_RoomTypeChange]
@FILTER VARCHAR(MAX),
@DATA VARCHAR(MAX)
AS
BEGIN

BEGIN TRANSACTION TRANS_ROOMTYPE
   BEGIN TRY

	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js
	
	--Seccion para crear un nuevo registro
	IF (@NAME_QUERY = 'create')
	BEGIN
		--insertando los datos a la tabla AvailBooking, mediante el json
		INSERT INTO [dbo].[RoomType]
           ([Code]
           ,[Name]
           ,[ImageUrl]
           ,[CreatedAt])
     SELECT sigma.dbo.fnRandomCharacter(8,'CN') AS [Code], [Name], [ImageUrl], GETDATE()
		FROM OPENJSON (@DATA) 
		WITH(
			[Name] VARCHAR(50)	N'strict $.Name',
			[ImageUrl] VARCHAR(250)
		) AS js
		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Actualizando los registros
	ELSE IF (@NAME_QUERY = 'update')
	BEGIN
		--Actualizando los datos de la cabezera
		UPDATE [dbo].[RoomType]
		   SET [Name] = js.[Name]
			  ,[ImageUrl] = js.[ImageUrl]
		FROM OPENJSON (@DATA) 
		WITH(
			[Id]	INT N'strict $.Id',
			[Name] VARCHAR(50),
			[ImageUrl] VARCHAR(250)
		) AS js
		INNER JOIN [dbo].[Hotel] ht ON ht.[Id] = js.[Id]
		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END
	--Ocultando los datos a la vista del usuario
	ELSE IF (@NAME_QUERY = 'deleteById')
	BEGIN
	--Actualizando el estado del show en [RoomType]
		UPDATE rt
		   SET [Show] = 0
		FROM OPENJSON (@DATA) 
		WITH(
			[Id]	INT N'strict $.Id'
		) AS js
		INNER JOIN [dbo].[RoomType] rt ON rt.[Id] = js.[Id]
		--Si hubo laguna transaacion, entonces devolver error 0 de lo contrario 1
		IF(@@ROWCOUNT > 0)
			SELECT 0 AS Error
		ELSE
			SELECT 1 AS Error

	END

	
--Haciendo commit
COMMIT TRANSACTION TRANS_ROOMTYPE;

END TRY
   BEGIN CATCH
    
	--RETORNANDO EL ERROR OCURRIDO
	SELECT  '[0] OCURRIO ALGUN ERROR' AS MAIN, ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage ;  
	IF(@@TRANCOUNT > 0)
	ROLLBACK TRANSACTION TRANS_ROOMTYPE;

   END CATCH

END

GO
/****** Object:  StoredProcedure [dbo].[Procedure_RoomTypeQuery]    Script Date: 6/23/2019 8:52:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		JORGE ALEJANDRO GONZALEZ FANI
-- Create date: 6/23/2019
-- Description:	Este procedimineto se encarga de obtener los datos de la tabla RoomType
-- Parametros:	Los parametros se envian en formato json y se recorren, haci dando una mayor flexibilidad y manipulacion de los datos, con mayor legibilidad.
-- =============================================
CREATE PROCEDURE [dbo].[Procedure_RoomTypeQuery]
	@FILTER VARCHAR(MAX)
AS
BEGIN
	
	DECLARE @NAME_QUERY VARCHAR(50);

	SELECT @NAME_QUERY = NAME_QUERY
	FROM OPENJSON (@FILTER) 
	WITH(
		NAME_QUERY VARCHAR(50)	N'strict $.NAME_QUERY'
	) AS js

	--Obteniendo los registro de la tabla AvailBooking, que esten disponibles
	IF (@NAME_QUERY = 'list')
	BEGIN

		SELECT [Id]
			  ,[Code]
			  ,[Name]
			  ,[ImageUrl]
			  ,[CreatedAt]
		  FROM [sigma].[dbo].[RoomType]
		  WHERE [Show] = 1
	END


END
GO
USE [master]
GO
ALTER DATABASE [sigma] SET  READ_WRITE 
GO
