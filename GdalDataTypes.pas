unit GdalDataTypes;
{$Z4} // 32bit enum, for compatability with C

interface

type
  GDALProgressFunc = Pointer;
  TArray2Double = array [0..1] of double;

type
  CPLErr = (
      CE_None = 0,
      CE_Debug = 1,
      CE_Warning = 2,
      CE_Failure = 3,
      CE_Fatal = 4
  );

  //*! Read/Write flag for RasterIO() method */
  GDALRWFlag =(
      {! Read data }   GF_Read = 0,
      {! Write data }  GF_Write = 1
  );

  //! Flag indicating read/write, or read-only access to data.
  GDALAccess = (
      (*! Read only (no update) access *) GA_ReadOnly = 0,
      (*! Read/write access. *)           GA_Update = 1
  ) ;

type
  OGRErr = Integer;
const
  OGRERR_NONE = 0;

type
  POGRErr = ^OGRErr;
  GIntBig = Int64;

//! Types of color interpretations for a GDALColorTable. */
  GDALPaletteInterp = (
    (*! Grayscale (in GDALColorEntry.c1) *)                      GPI_Gray=0,
    (*! Red, Green, Blue and Alpha in (in c1, c2, c3 and c4) *)  GPI_RGB=1,
    (*! Cyan, Magenta, Yellow and Black (in c1, c2, c3 and c4)*) GPI_CMYK=2,
    (*! Hue, Lightness and Saturation (in c1, c2, and c3) *)     GPI_HLS=3
  );

// GDALOpenEx flags
const
     GDAL_OF_READONLY      =  $00;
     GDAL_OF_UPDATE        =  $01;
     GDAL_OF_ALL           =  $00;
     GDAL_OF_RASTER        =  $02;
     GDAL_OF_VECTOR        =  $04;
     GDAL_OF_GNM           =  $08;
     GDAL_OF_SHARED        =  $20;
     GDAL_OF_VERBOSE_ERROR =  $40;
     GDAL_OF_INTERNAL      =  $80;

type
  //* Color tuple */
  GDALColorEntry = packed record
    c1: Word; //! gray, red, cyan or hue */
    c2: Word; //! green, magenta, or lightness */
    c3: Word; //! blue, yellow, or saturation */
    c4: Word; //! alpha or blackband */
  end;
  PGDALColorEntry = ^GDALColorEntry;

const
  SRS_UA_DEGREE_CONV = 0.0174532925199433; //=M_PI_180 = degtorad [degrees]*deg=rad
  GDAL_DCAP_CREATE = 'DCAP_CREATE';

type
  //*! Pixel data types */
  GDALDataType =(
      {! Unknown or unspecified type }          GDT_Unknown = 0,
      {! Eight bit unsigned integer }           GDT_Byte = 1,
      {! Sixteen bit unsigned integer }         GDT_UInt16 = 2,
      {! Sixteen bit signed integer }           GDT_Int16 = 3,
      {! Thirty two bit unsigned integer }      GDT_UInt32 = 4,
      {! Thirty two bit signed integer }        GDT_Int32 = 5,
      {! Thirty two bit floating point }        GDT_Float32 = 6,
      {! Sixty four bit floating point }        GDT_Float64 = 7,
      {! Complex Int16 }                        GDT_CInt16 = 8,
      {! Complex Int32 }                        GDT_CInt32 = 9,
      {! Complex Float32 }                      GDT_CFloat32 = 10,
      {! Complex Float64 }                      GDT_CFloat64 = 11
  );

  //GDALDataType = GDT_Unknown..GDT_CFloat64;

  GDALDatasetH = Pointer;
  GDALRasterBandH = Pointer;

  OGRFieldType = (OFTInteger = 0, OFTIntegerList = 1, OFTReal = 2,
    OFTRealList = 3, OFTString = 4, OFTStringList = 5, OFTWideString = 6,
    FTWideStringList = 7, OFTBinary = 8, OFTDate = 9, OFTTime = 10,
    OFTDateTime = 11, OFTInteger64 = 12, OFTInteger64List = 13,
    OFTMaxType = 13);

//** Opaque type used for the C bindings of the C++ classes */
type
  GDALMajorObjectH = Pointer;
  GDALDriverH = Pointer;
  GDALColorTableH = Pointer;
  GDALRasterAttributeTableH = Pointer;
  GDALAsyncReaderH = Pointer;
  OGRSpatialReferenceH = Pointer;

  OGRDataSource = Pointer;
  OGRDataSourceH = Pointer;
  OGRLayerH  = Pointer;
  OGRFeatureH = pointer;
  OGRFeatureDefnH = pointer;
  OGRFieldDefnH = pointer;
  OGRGeometryH = pointer;
  OGRGeomFieldDefnH = pointer;
  OGRSFDriverH = pointer;

  CSLConstList = PPAnsiChar;
  POGRGeometryH = ^OGRGeometryH;

type
  OGRwkbGeometryType = Integer;
const
//OGRwkbGeometryType
  wkbUnknown = 0;
  wkbPoint = 1;
  wkbLineString = 2;
  wkbPolygon = 3;
  wkbMultiPoint = 4;
  wkbMultiLineString = 5;
  wkbMultiPolygon = 6;
  wkbGeometryCollection = 7;
  wkbCircularString = 8;
  wkbCompoundCurve = 9;
  wkbCurvePolygon = 10;
  wkbMultiCurve = 11;
  wkbMultiSurface = 12;
  wkbCurve = 13;
  wkbSurface = 14;
  wkbPolyhedralSurface = 15;
  wkbTIN = 16;
  wkbTriangle = 17;
  wkbNone = 100;
  wkbLinearRing = 101;
  wkbCircularStringZ = 1008;
  wkbCompoundCurveZ = 1009;
  wkbCurvePolygonZ = 1010;
  wkbMultiCurveZ = 1011;
  wkbMultiSurfaceZ = 1012;
  wkbCurveZ = 1013;
  wkbSurfaceZ = 1014;
  wkbPolyhedralSurfaceZ = 1015;
  wkbTINZ = 1016;
  wkbTriangleZ = 1017;
  wkbPointM = 2001;
  wkbLineStringM = 2002;
  wkbPolygonM = 2003;
  wkbMultiPointM = 2004;
  wkbMultiLineStringM = 2005;
  wkbMultiPolygonM = 2006;
  wkbGeometryCollectionM = 2007;
  wkbCircularStringM = 2008;
  wkbCompoundCurveM = 2009;
  wkbCurvePolygonM = 2010;
  wkbMultiCurveM = 2011;
  wkbMultiSurfaceM = 2012;
  wkbCurveM = 2013;
  wkbSurfaceM = 2014;
  wkbPolyhedralSurfaceM = 2015;
  wkbTINM = 2016;
  wkbTriangleM = 2017;
  wkbPointZM = 3001;
  wkbLineStringZM = 3002;
  wkbPolygonZM = 3003;
  wkbMultiPointZM = 3004;
  wkbMultiLineStringZM = 3005;
  wkbMultiPolygonZM = 3006;
  wkbGeometryCollectionZM = 3007;
  wkbCircularStringZM = 3008;
  wkbCompoundCurveZM = 3009;
  wkbCurvePolygonZM = 3010;
  wkbMultiCurveZM = 3011;
  wkbMultiSurfaceZM = 3012;
  wkbCurveZM = 3013;
  wkbSurfaceZM = 3014;
  wkbPolyhedralSurfaceZM = 3015;
  wkbTINZM = 3016;
  wkbTriangleZM = 3017;
  wkbPoint25D = $80000001;
  wkbLineString25D = $80000002;
  wkbPolygon25D = $80000003;
  wkbMultiPoint25D = $80000004;
  wkbMultiLineString25D = $80000005;
  wkbMultiPolygon25D = $80000006;
  wkbGeometryCollection25D = $80000007;

implementation

end.
