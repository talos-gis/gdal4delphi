unit GdalDLL_API;
{$Z4} // 32bit enum, for compatability with C
{$IFDEF DEBUG}
  {$DEFINE GDAL_DEV}
{$ENDIF}

interface

uses
  SysUtils, Classes,
  TypesC, GdalDataTypes,
  DynamicDll;

  //depends on msvcr100, msvcp100 (vcredist-2010-x64.exe - visual studio 2010 redistributable):
  //gdal 2.1.x - osgeo4w build (i.e. from QGIS.2.18.4)

  //depends on msvcp140 (vcredist_2015_x64.exe - visual studio 2015 redistributable):
  //gdal 2.2.x - osgeo4w build (i.e. from QGIS 3.2.3)
  //gdal 2.3.x - osgeo4w build (i.e. from QGIS 3.4.0)
  //gdal 2.3.x - gisinternal build (i.e. release-1900-x64-gdal-2-3-1-mapserver-7-2-0.zip), apperantly this build of proj.dll is missing geod functions
  //gdal 2.4.x - osgeo4w build (i.e. from QGIS 3.4.3)

// if you add more functions to here pay extra attension for the calling convention form the h file!
// CPL_DLL = = cdecl
// CPL_DLL CPL_STDCALL = = stdcall
type
  //from gdal.h
  TGDALAllRegister = procedure; stdcall;
  TGDALCreate = function(hDriver: GDALDriverH; const p: PAnsiChar; i,j,k: Integer; dt: GDALDataType; pp: PPAnsiChar): GDALDatasetH; stdcall;
  TGDALOpen = function(pszFilename:PAnsiChar; eAccess:GDALAccess):GDALDatasetH; stdcall;
  TGDALOpenEx = function(pszFilename:PAnsiChar; nOpenFiles: Cardinal; const papszAllowdDrivers: PPAnsiChar; const papszOpenOptions: PPAnsiChar; const papszSiblingFiles: PPAnsiChar):GDALDatasetH; stdcall;
  TGDALClose = procedure(hDS: GDALDatasetH); stdcall;

  TGDALGetRasterBand = function (hDataSet: GDALDatasetH; i: Integer): GDALRasterBandH; stdcall;
  TGDALGetBandNumber = function (hDataSet: GDALRasterBandH): integer; stdcall;
  TGDALGetRasterDataType = function (hDataSet: GDALRasterBandH): GDALDataType; stdcall;
  TGDALGetMetadata = function(hBnd: GDALMajorObjectH; const pszDomain:PAnsiChar): PPAnsiChar; stdcall;
  TGDALSetMetadata = function(hBnd: GDALMajorObjectH; papszMD: CSLConstList; const pszDomain:PAnsiChar): CPLErr; stdcall;
  TGDALGetMetadataItem = function (hBnd: GDALMajorObjectH; const pszName:PAnsiChar; const pszDomain:PAnsiChar):PAnsiChar; stdcall;
  TGDALSetMetadataItem = function (hBnd: GDALMajorObjectH; const pszName:PAnsiChar; const pszValue:PAnsiChar; const pszDomain:PAnsiChar):CPLErr; stdcall;
  TGDALGetRasterXSize = function (hDataSet: GDALDatasetH): integer; stdcall;
  TGDALGetRasterYSize = function (hDataSet: GDALDatasetH): integer; stdcall;
  TGDALGetProjectionRef = function (hDataSet: GDALDatasetH): PAnsiChar; stdcall;
  TGDALSetProjection = function (hDataSet: GDALDatasetH; p: PAnsiChar):CPLErr; stdcall;
  TGDALGetGeoTransform = function (hDataSet: GDALDatasetH; p: pDouble):CPLErr; stdcall;
  TGDALSetGeoTransform = function (hDataSet: GDALDatasetH; p: pDouble):CPLErr; stdcall;
  TGDALDatasetRasterIO = function (hDS:GDALDatasetH; eRWFlag:GDALRWFlag; nDSXOff:integer; nDSYOff:integer; nDSXSize:integer; nDSYSize:integer;
    pBuffer:Pointer; nBXSize:integer; nBYSize:integer; eBDataType:GDALDataType; nBandCount:integer; panBandCount:pInteger; nPixelSpace:integer;
    nLineSpace:integer; nBandSpace:integer ):CPLErr; stdcall;
  TGDALGetOverview = function (hBnd: GDALRasterBandH; i: Integer):GDALRasterBandH; stdcall;
  TGDALGetDriverByName = function(const Driver: PAnsiChar): GDALDriverH; stdcall;
  TGDALGetRasterCount = function(hDS: GDALDatasetH): Integer; stdcall;
  TGDALGetRasterNoDataValue = function(SrcBnd: GDALRasterBandH; pbSuccess: PInteger): Double; stdcall;
  TGDALGetRasterScale = function(SrcBnd: GDALRasterBandH; pbSuccess: PInteger): Double; stdcall;
  TGDALGetRasterMinimum = function(SrcBnd: GDALRasterBandH; pbSuccess: PInteger): Double; stdcall;
  TGDALGetRasterMaximum = function(SrcBnd: GDALRasterBandH; pbSuccess: PInteger): Double; stdcall;
  TGDALGetBlockSize = procedure(SrcBnd: GDALRasterBandH; pnXSize, pnYSize: PInteger); stdcall;
  TGDALGetOverviewCount = function (SrcBnd: GDALRasterBandH): Integer; stdcall;
  TGDALRasterIO = function(
    hDS: GDALDatasetH; eRWFlag: GDALRWFlag;
    nDSXOff, nDSYOff, nDSXSize, nDSYSize: Integer;
    pBuffer: Pointer; nBXSize, nBYSize: Integer; eBDataType: GDALDataType;
    nPixelSpace, nLineSpace: Integer): CPLErr; stdcall;
  TGDALReadBlock =  function(
    hDS: GDALDatasetH;
    nXOff, nYOff: Integer;
    pBuffer: Pointer): CPLErr; stdcall;
  TGDALWriteBlock =  function(
    hDS: GDALDatasetH;
    nXOff, nYOff: Integer;
    pBuffer: Pointer): CPLErr; stdcall;
  TGDALGetDataTypeSize = function(dt: GDALDataType): Integer; stdcall;
  TGDALSetRasterNoDataValue = function(SrcBnd: GDALRasterBandH; d: double): CPLErr; stdcall;
  TGDALSetRasterScale = function(hBand: GDALRasterBandH; dfNewOffset: double): CPLErr; stdcall;
  TGDALGetRasterStatistics = function (hBand: GDALRasterBandH; bApproxOK: Integer; bForce: Integer; pdfMin, pdfMax, pdfMean, pdfStdDev: PDouble): CPLErr; stdcall;
  TGDALComputeRasterStatistics = function(hBand: GDALRasterBandH; bApproxOK: Integer; pdfMin, pdfMax, pdfMean, pdfStdDev: PDouble; pfnProgress: GDALProgressFunc; pProgressData: Pointer): CPLErr; stdcall;
  TGDALSetRasterStatistics = function (hBand: GDALRasterBandH; dfMin, dfMax, dfMean, dfStdDev: Double): CPLErr; stdcall;
  TGDALComputeRasterMinMax = function (hBand: GDALRasterBandH; bApproxOK: Integer; adfMinMax: TArray2Double): CPLErr; stdcall;

  TGDALSetCacheMax64 = procedure (nBytes: GIntBig); stdcall;
  TGDALGetCacheMax64 = function (): GIntBig; stdcall;
  TGDALGetCacheUsed64 = function (): GIntBig; stdcall;

  TGDALCreateColorTable = function (eInterp: GDALPaletteInterp = GPI_RGB): GDALColorTableH; stdcall;
  TGDALDestroyColorTable = procedure (hCT: GDALColorTableH); stdcall;
  TGDALGetColorEntryCount = function (hTable: GDALColorTableH): Integer; stdcall;
  TGDALGetColorEntry = function (hTable: GDALColorTableH; i: Integer): PGDALColorEntry; stdcall;
  TGDALSetColorEntry = procedure (hTable: GDALColorTableH; i: Integer; const poEntry: PGDALColorEntry); stdcall;
  TGDALGetRasterColorTable = function (hBand: GDALRasterBandH): GDALColorTableH; stdcall;
  TGDALSetRasterColorTable = function (hBand: GDALRasterBandH; hCT: GDALColorTableH): CPLErr; stdcall;

  // from gdal.h - ogr functions (cdecl)
  TGDALDatasetCreateLayer = function( 	hDS:GDALDatasetH;const pszName:PAnsiChar; hSpatialRef:OGRSpatialReferenceH;
    eGType:OGRwkbGeometryType; papszOptions:CSLConstList):OGRLayerH; cdecl;
  TGDALDatasetGetLayerByName = function(hDS:GDALDatasetH;const pszName:PAnsiChar):OGRLayerH; cdecl;
  TGDALDatasetGetLayer = function(hDS:GDALDatasetH;ilayer: integer):OGRLayerH; cdecl;

  //from ogr_core.h (cdecl)
  TOGRFree = procedure (p: Pointer); cdecl;

  //from ogr_api.h (cdecl)
  TOGRRegisterAll = procedure(); cdecl;
  TOGROpen = function(const pszName: PAnsiChar):OGRDataSource; cdecl;
  TOGRGetDriverByName = function(const pszName:PAnsiChar):OGRSFDriverH; cdecl;

  TOGR_Dr_CreateDataSource = function(hDriver:OGRSFDriverH;const pszName:PAnsiChar;papszOptions:PAnsiChar):OGRDataSourceH; cdecl;

  TOGR_DS_GetLayerByName = function(hDS:OGRDataSourceH;const pszLayerName: PAnsiChar):OGRLayerH; cdecl;
  TOGR_DS_GetLayer = function(hDS:OGRDataSourceH;ilayer: integer):OGRLayerH; cdecl;
  TOGR_DS_Destroy	 = procedure( 	hDataSource:OGRDataSourceH); cdecl;
  TOGR_DS_CreateLayer = function(hDS:OGRDataSourceH;const pszName:PAnsiChar;hSpatialRef:OGRSpatialReferenceH;
                      	eType:OGRwkbGeometryType;papszOptions:PAnsiChar):OGRLayerH; cdecl;

  TOGR_G_GetGeometryType = function(hGeom:OGRGeometryH):OGRwkbGeometryType; cdecl;
  TOGR_G_DestroyGeometry = procedure(hGeom:OGRGeometryH); cdecl;
  TOGR_G_CreateGeometry = function(eGeometryType:OGRwkbGeometryType):OGRGeometryH; cdecl;
  TOGR_G_SetPoint_2D = procedure(hGeom:OGRGeometryH;  i:integer;dfX:Double 	;	dfY:Double); cdecl;
  TOGR_G_CreateFromWkt = function(ppszData: PPAnsiChar; hSRS: OGRSpatialReferenceH; phGeometry: POGRGeometryH): OGRErr; cdecl;
  TOGR_G_ExportToIsoWkt = function(phGeometry: POGRGeometryH; ppszData: PPAnsiChar): OGRErr; cdecl;

  TOGR_Fld_Create = function(const pszName:PAnsiChar;eType:OGRFieldType):OGRFieldDefnH; cdecl;
  TOGR_Fld_SetWidth = procedure(	hDefn:OGRFieldDefnH;nNewWidth:integer); cdecl;
  TOGR_Fld_GetType = function(hDefn:OGRFieldDefnH):OGRFieldType; cdecl;
  TOGR_Fld_GetNameRef = function(hDefn:OGRFieldDefnH):pansichar; cdecl;
  TOGR_Fld_Destroy = procedure(hDefn:OGRFieldDefnH); cdecl;
  TOGR_Fld_SetPrecision = procedure(hDefn: OGRFieldDefnH; precision: integer); cdecl;

  TOGR_GFld_GetSpatialRef = function(hGfdn: OGRGeomFieldDefnH): OGRSpatialReferenceH; cdecl;
  TOGR_GFld_SetSpatialRef = procedure(hGfdn: OGRGeomFieldDefnH; hSRS: OGRSpatialReferenceH); cdecl;

  TOGR_FD_GetFieldCount = function(hDefn:OGRFeatureDefnH):integer; cdecl;
  TOGR_FD_GetFieldDefn = function(hDefn:OGRFeatureDefnH; iField:integer):OGRFieldDefnH; cdecl;
  TOGR_FD_GetFieldIndex = function(hDefn:OGRFeatureDefnH; const pszName:PAnsiChar):integer; cdecl;
  TOGR_FD_GetGeomFieldDefn = function(hDefn: OGRFeatureDefnH; iGeomField: Integer):OGRGeomFieldDefnH; cdecl;

  TOGR_F_Create = function(hDefn:OGRFeatureDefnH):OGRFeatureH; cdecl;
  TOGR_F_GetFieldAsInteger = function(hFeat:OGRFeatureH;iField:integer):integer; cdecl;
  TOGR_F_GetFieldAsDouble = function(hFeat:OGRFeatureH;iField:integer):Double; cdecl;
  TOGR_F_GetFieldAsString = function(hFeat:OGRFeatureH;iField:integer):PAnsiChar; cdecl;
  TOGR_F_GetFieldAsInteger64 = function(hFeat:OGRFeatureH; 	iField:integer):GIntBig; cdecl;
  TOGR_F_GetGeometryRef = function(hFeat:OGRFeatureH ):OGRGeometryH; cdecl;
  TOGR_F_SetFieldString = procedure(hFeat:OGRFeatureH;iField:integer;const pszValue:PAnsiChar); cdecl;
  TOGR_F_SetFieldInteger = procedure(hFeat:OGRFeatureH;iField:integer;const value:integer); cdecl;
  TOGR_F_SetFieldDouble = procedure(hFeat:OGRFeatureH;iField:integer;const value:double); cdecl;
  TOGR_F_SetFieldDoubleList = procedure(hFeat: OGRFeatureH; iField:integer; n: integer; pvalue: PDouble); cdecl;
  TOGR_F_SetGeometry = function(hFeat:OGRFeatureH;hGeom:OGRGeometryH):OGRErr; cdecl;
  TOGR_F_SetGeometryDirectly = function(hFeat:OGRFeatureH;hGeom:OGRGeometryH):OGRErr; cdecl;
  TOGR_F_GetFieldIndex = function(hFeat:OGRFeatureH;const pszName:PAnsiChar):integer; cdecl;
  TOGR_F_SetFieldRaw = procedure(hFeat: OGRFeatureH; iField: Integer; psValue: Pointer); cdecl;
  TOGR_F_Destroy = procedure(hFeat:OGRFeatureH); cdecl;
  TOGR_F_GetDefnRef = function(hFeat: OGRFeatureH):OGRFeatureDefnH; cdecl;
  TOGR_F_GetFieldDefnRef = function(hFeat: OGRFeatureH; ind: integer):OGRFieldDefnH; cdecl;

  TOGR_L_CreateField = function(hLayer:OGRLayerH; hField:OGRFieldDefnH; bApproxOK:integer):OGRErr; cdecl;
  TOGR_L_CreateFeature = function(hLayer:OGRLayerH;hFeat:OGRFeatureH):OGRErr; cdecl;
  TOGR_L_ResetReading	 = procedure(hLayer:OGRLayerH); cdecl;
  TOGR_L_GetNextFeature = function(hLayer:OGRLayerH):OGRFeatureH; cdecl;
  TOGR_L_GetLayerDefn  = function(hLayer:OGRLayerH):OGRFeatureDefnH; cdecl;
  TOGR_L_GetSpatialRef = function(hLayer:OGRLayerH):OGRSpatialReferenceH; cdecl;

  // from ogr_srs_api.h
  TOSRNewSpatialReference = function (p:PPAnsiChar):OGRSpatialReferenceH; stdcall;
  //TOSRDestroySpatialReference = procedure (hSRS: OGRSpatialReferenceH); stdcall; // replace with OSRRelease()
  TOSRGetAttrValue = function (hSRS:OGRSpatialReferenceH; pszKey:PAnsiChar; iChild:integer):PAnsiChar; stdcall;
  TOSRSetAttrValue = function (hSRS:OGRSpatialReferenceH; pszPath:PAnsiChar; pszValue:PAnsiChar):OGRErr; stdcall;
  TOSRExportToWkt = function (hSRS: OGRSpatialReferenceH; a:PPAnsiChar):OGRErr; stdcall;
  TOSRExportToProj4 = function (hSRS:OGRSpatialReferenceH; ppszReturn:PPAnsiChar):OGRErr; stdcall;
  TOSRImportFromEPSG = function (hSRS:OGRSpatialReferenceH; i: Integer):OGRErr; stdcall;

  TOSRRelease = procedure( hSRS:OGRSpatialReferenceH ); cdecl;

  // from ogr_srs_api.h (cdecl)
  TOSRImportFromWkt = function (hSRS: OGRSpatialReferenceH; a:PPAnsiChar):OGRErr; cdecl;
  TOSRImportFromProj4 = function (hSRS: OGRSpatialReferenceH; a:PAnsiChar):OGRErr; cdecl;
  TOSRIsGeographic = function (hSRS: OGRSpatialReferenceH):integer; cdecl;
  TOSRSetUTM = function (hSRS:OGRSpatialReferenceH; nZone:integer; bNorth:integer):OGRErr; cdecl;
  TOSRGetUTMZone = function (hSRS:OGRSpatialReferenceH; pbNorth:pInteger):integer; cdecl;
  TOSRGetProjParm = function (hSRS:OGRSpatialReferenceH; pszName:PAnsiChar; dfDefaultValue: double; pnErr: pOGRErr):double; cdecl;
  TOSRGetAngularUnits = function (hSRS:OGRSpatialReferenceH; p: PPAnsiChar):double; cdecl;
  TOSRGetLinearUnits = function (hSRS:OGRSpatialReferenceH; p: PPAnsiChar):double; cdecl;
  TOSRSetLocalCS = function (hSRS:OGRSpatialReferenceH; pszName:PAnsiChar):OGRErr; cdecl;
  TOSRSetProjCS = function (hSRS:OGRSpatialReferenceH; pszName:PAnsiChar):OGRErr; cdecl;
  TOSRSetGeocCS = function (hSRS:OGRSpatialReferenceH; pszName:PAnsiChar):OGRErr; cdecl;
  TOSRSetLinearUnits = function (hSRS: OGRSpatialReferenceH; p: PAnsiChar; d: double):OGRErr; cdecl;
  TOSRSetAngularUnits = function (hSRS: OGRSpatialReferenceH; p: PAnsiChar; d: double):OGRErr; cdecl;
  TOSRSetWellKnownGeogCS = function (hSRS:OGRSpatialReferenceH; pszName:PAnsiChar):OGRErr; cdecl;
  TOSRIsProjected = function (hSRS:OGRSpatialReferenceH):LongBool; cdecl;
  //TRUE if they are the same or FALSE otherwise.
  TOSRIsSame = function (hSRS0:OGRSpatialReferenceH; hSRS1:OGRSpatialReferenceH):IntBool; cdecl;
  TOSRIsSameGeogCS = function (hSRS0:OGRSpatialReferenceH; hSRS1:OGRSpatialReferenceH):IntBool; cdecl;

  // from cpl_string.h
  TCSLDestroy = procedure(papszStrList: PPAnsiChar); stdcall;
  // from cpl_string.h (cdecl)
  TCSLFetchBoolean = function(papszStrList: PPAnsiChar; const pszKey: PAnsiChar; bDefault: Integer): Integer; cdecl;
  TCSLSetNameValue = function (papszStrList: PPAnsiChar; const pszName: PAnsiChar; const pszValue: PAnsiChar): PPAnsiChar; cdecl;

  // from cpl_conv.h
  TCPLSetConfigOption = procedure(const name: PAnsiChar; const value: PAnsiChar); stdcall;
  TCPLGetConfigOption = function(const name: PAnsiChar; const default: PAnsiChar): PAnsiChar; stdcall;

  //from cpl_error.h
  TCPLGetLastErrorType = function(): CPLErr; stdcall;
  TCPLErrorReset = procedure();stdcall;

type
  TGdalDll_API = class(TDynamicDll)
  public
    GDALAllRegister: TGDALAllRegister;
    GDALCreate: TGDALCreate;
    GDALOpen: TGDALOpen;
    GDALOpenEx: TGDALOpenEx;
    GDALClose: TGDALClose;

    GDALGetRasterBand: TGDALGetRasterBand;
    GDALGetBandNumber: TGDALGetBandNumber;
    GDALGetRasterDataType: TGDALGetRasterDataType;
    GDALGetMetadata: TGDALGetMetadata;
    GDALSetMetadata: TGDALSetMetadata;
    GDALGetMetadataItem: TGDALGetMetadataItem;
    GDALSetMetadataItem: TGDALSetMetadataItem;
    GDALGetRasterXSize: TGDALGetRasterXSize;
    GDALGetRasterYSize: TGDALGetRasterYSize;
    GDALGetProjectionRef: TGDALGetProjectionRef;
    GDALSetProjection: TGDALSetProjection;
    GDALGetGeoTransform: TGDALGetGeoTransform;
    GDALSetGeoTransform: TGDALSetGeoTransform;
    GDALDatasetRasterIO: TGDALDatasetRasterIO;
    GDALGetOverview: TGDALGetOverview;
    GDALGetDriverByName: TGDALGetDriverByName;
    GDALGetRasterCount: TGDALGetRasterCount;
    GDALGetBlockSize: TGDALGetBlockSize;
    GDALGetRasterNoDataValue: TGDALGetRasterNoDataValue;
    GDALGetRasterScale: TGDALGetRasterScale;
    GDALGetRasterMinimum: TGDALGetRasterMinimum;
    GDALGetRasterMaximum: TGDALGetRasterMaximum;
    GDALGetOverviewCount: TGDALGetOverviewCount;
    GDALRasterIO: TGDALRasterIO;
    GDALReadBlock: TGDALReadBlock;
    GDALWriteBlock: TGDALWriteBlock;
    GDALGetDataTypeSize: TGDALGetDataTypeSize;
    GDALSetRasterNoDataValue: TGDALSetRasterNoDataValue;
    GDALSetRasterScale: TGDALSetRasterScale;
    GDALGetRasterStatistics: TGDALGetRasterStatistics;
    GDALComputeRasterStatistics: TGDALComputeRasterStatistics;
    GDALSetRasterStatistics: TGDALSetRasterStatistics;
    GDALComputeRasterMinMax: TGDALComputeRasterMinMax;

    GDALSetCacheMax64: TGDALSetCacheMax64;
    GDALGetCacheMax64: TGDALGetCacheMax64;
    GDALGetCacheUsed64: TGDALGetCacheUsed64;

    GDALCreateColorTable: TGDALCreateColorTable;
    GDALDestroyColorTable: TGDALDestroyColorTable;
    GDALGetColorEntryCount: TGDALGetColorEntryCount;
    GDALGetColorEntry: TGDALGetColorEntry;
    GDALSetColorEntry: TGDALSetColorEntry;
    GDALGetRasterColorTable: TGDALGetRasterColorTable;
    GDALSetRasterColorTable: TGDALSetRasterColorTable;

    GDALDatasetCreateLayer: TGDALDatasetCreateLayer;
    GDALDatasetGetLayerByName: TGDALDatasetGetLayerByName;
    GDALDatasetGetLayer: TGDALDatasetGetLayer;

    OGRFree: TOGRFree;

    OGRRegisterAll: TOGRRegisterAll;
    OGROpen: TOGROpen;
    OGR_DS_GetLayerByName: TOGR_DS_GetLayerByName;
    OGR_DS_GetLayer: TOGR_DS_GetLayer;
    OGR_L_ResetReading: TOGR_L_ResetReading;
    OGR_L_GetNextFeature: TOGR_L_GetNextFeature;
    OGR_L_GetLayerDefn: TOGR_L_GetLayerDefn;
    OGR_L_GetSpatialRef: TOGR_L_GetSpatialRef;
    OGR_FD_GetFieldCount: TOGR_FD_GetFieldCount;
    OGR_FD_GetFieldDefn: TOGR_FD_GetFieldDefn;
    OGR_FD_GetFieldIndex: TOGR_FD_GetFieldIndex;
    OGR_FD_GetGeomFieldDefn: TOGR_FD_GetGeomFieldDefn;
    OGR_Fld_GetType: TOGR_Fld_GetType;
    OGR_Fld_GetNameRef: TOGR_Fld_GetNameRef;
    OGR_Fld_SetPrecision: TOGR_Fld_SetPrecision;
    OGR_GFld_GetSpatialRef: TOGR_GFld_GetSpatialRef;
    OGR_GFld_SetSpatialRef: TOGR_GFld_SetSpatialRef;
    OGR_F_GetFieldAsInteger: TOGR_F_GetFieldAsInteger;
    OGR_F_GetFieldAsDouble: TOGR_F_GetFieldAsDouble;
    OGR_F_GetFieldAsString: TOGR_F_GetFieldAsString;
    OGR_F_SetFieldString: TOGR_F_SetFieldString;
    OGR_F_SetFieldInteger: TOGR_F_SetFieldInteger;
    OGR_F_SetFieldDouble: TOGR_F_SetFieldDouble;
    OGR_F_GetFieldAsInteger64: TOGR_F_GetFieldAsInteger64;
    OGR_F_SetFieldDoubleList: TOGR_F_SetFieldDoubleList;
    OGR_F_GetDefnRef: TOGR_F_GetDefnRef;
    OGR_F_GetGeometryRef: TOGR_F_GetGeometryRef;
    OGR_G_GetGeometryType: TOGR_G_GetGeometryType;
    OGR_F_Destroy: TOGR_F_Destroy;
    OGR_DS_Destroy: TOGR_DS_Destroy;
    OGRGetDriverByName: TOGRGetDriverByName;
    OGR_Dr_CreateDataSource: TOGR_Dr_CreateDataSource;
    OGR_DS_CreateLayer: TOGR_DS_CreateLayer;
    OGR_Fld_Create: TOGR_Fld_Create;
    OGR_Fld_SetWidth: TOGR_Fld_SetWidth;
    OGR_L_CreateField: TOGR_L_CreateField;
    OGR_Fld_Destroy: TOGR_Fld_Destroy;
    OGR_F_Create: TOGR_F_Create;
    OGR_F_SetGeometry: TOGR_F_SetGeometry;
    OGR_F_SetGeometryDirectly: TOGR_F_SetGeometryDirectly;
    OGR_G_DestroyGeometry: TOGR_G_DestroyGeometry;
    OGR_F_GetFieldIndex: TOGR_F_GetFieldIndex;
    OGR_F_SetFieldRaw: TOGR_F_SetFieldRaw;
    OGR_L_CreateFeature: TOGR_L_CreateFeature;
    OGR_G_CreateGeometry: TOGR_G_CreateGeometry;
    OGR_G_SetPoint_2D: TOGR_G_SetPoint_2D;
    OGR_G_CreateFromWkt: TOGR_G_CreateFromWkt;
    OGR_F_GetFieldDefnRef: TOGR_F_GetFieldDefnRef;
    OGR_G_ExportToIsoWkt: TOGR_G_ExportToIsoWkt;

    //osr
    OSRNewSpatialReference: TOSRNewSpatialReference;
    //OSRDestroySpatialReference: TOSRDestroySpatialReference;
    OSRGetAttrValue: TOSRGetAttrValue;
    OSRSetAttrValue: TOSRSetAttrValue;
    OSRExportToWkt: TOSRExportToWkt;
    OSRExportToProj4: TOSRExportToProj4;
    OSRImportFromEPSG: TOSRImportFromEPSG;
    OSRRelease: TOSRRelease;

    OSRImportFromWkt: TOSRImportFromWkt;
    OSRImportFromProj4: TOSRImportFromProj4;
    OSRIsGeographic: TOSRIsGeographic;
    OSRSetUTM: TOSRSetUTM;
    OSRGetUTMZone: TOSRGetUTMZone;
    OSRGetProjParm: TOSRGetProjParm;
    OSRGetAngularUnits: TOSRGetAngularUnits;
    OSRGetLinearUnits: TOSRGetLinearUnits;
    OSRSetLocalCS: TOSRSetLocalCS;
    OSRSetProjCS: TOSRSetProjCS;
    OSRSetGeocCS: TOSRSetGeocCS;
    OSRSetLinearUnits: TOSRSetLinearUnits;
    OSRSetAngularUnits: TOSRSetAngularUnits;
    OSRSetWellKnownGeogCS: TOSRSetWellKnownGeogCS;
    OSRIsProjected: TOSRIsProjected;
    OSRIsSame: TOSRIsSame;
    OSRIsSameGeogCS: TOSRIsSameGeogCS;

    CSLDestroy: TCSLDestroy;
    CSLFetchBoolean: TCSLFetchBoolean;
    CSLSetNameValue: TCSLSetNameValue;

    CPLSetConfigOption: TCPLSetConfigOption;
    CPLGetConfigOption: TCPLGetConfigOption;

    CPLGetLastErrorType: TCPLGetLastErrorType;
    CPLErrorReset: TCPLErrorReset;
  protected
    DLL_VersionMinDefault: Integer;
    DLL_VersionMaxDefault: Integer;
  public
    DLL_Version: Integer;
    DLL_VersionMin: Integer;
    DLL_VersionMax: Integer;
    GDAL_DATA: String;
    GDAL_DRIVER_PATH: String;
    GDALWorkingReadThreads, GDALWorkingWriteThreads: Integer;
    GDALDefaultCacheMax: GIntBig;
    constructor Create(AOwner: TComponent); override;
    procedure MapDll; override;

    procedure CPLSetConfigOption1(name: string; value: string);
    function CPLGetConfigOption1(const name: string; const default: string = ''): string;
    function CSLSetNameValue1(papszStrList: PPAnsiChar; const Name: String; const Value: String): PPAnsiChar;
    function OSRSetAttrValue1(hSRS:OGRSpatialReferenceH; Path, Value: AnsiString): OGRErr;
  protected
    procedure GDALAllRegisterVerify;
    procedure AfterLoad; override;
    procedure BeforeLoad; override;
    function ResolvePaths: Boolean; virtual;
    function ResolveDLLPath: Boolean; virtual;
    function ResolveDLLPath_StandAlone(BasePath: String; IsVersionPath: Boolean): Boolean;
    function ResolveDLLDriverPath: Boolean;
    function ResolveDataPath: Boolean; virtual;
  end;

implementation

constructor TGdalDll_API.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DLL_VersionMinDefault := 201;
  DLL_VersionMaxDefault := {$IFDEF GDAL_DEV}302{$ELSE}204{$ENDIF};
  DLL_VersionMin := 0;
  DLL_VersionMax := 0;
  DLL_Version := 0;
  GDALWorkingReadThreads := 1;
  GDALWorkingWriteThreads := 1;
  GDAL_DATA := '';
  GDAL_DRIVER_PATH := '';
  GDALDefaultCacheMax := 0;
end;

procedure TGdalDll_API.MapDll;
begin
  @GDALAllRegister := Import2('GDALAllRegister',0);
  @GDALCreate := Import2('GDALCreate',28);
  @GDALOpen := Import2('GDALOpen',8);
  @GDALOpenEx := Import2('GDALOpenEx',20);
  @GDALClose := Import2('GDALClose',4);

  @GDALGetRasterBand := Import2('GDALGetRasterBand',8);
  @GDALGetBandNumber := Import2('GDALGetBandNumber',4);
  @GDALGetRasterDataType := Import2('GDALGetRasterDataType',4);
  @GDALGetMetadata := Import2('GDALGetMetadata',8);
  @GDALSetMetadata := Import2('GDALSetMetadata',12);
  @GDALGetMetadataItem := Import2('GDALGetMetadataItem',12);
  @GDALSetMetadataItem := Import2('GDALSetMetadataItem',16);
  @GDALGetRasterXSize := Import2('GDALGetRasterXSize',4);
  @GDALGetRasterYSize := Import2('GDALGetRasterYSize',4);
  @GDALGetProjectionRef := Import2('GDALGetProjectionRef',4);
  @GDALSetProjection := Import2('GDALSetProjection',8);
  @GDALGetGeoTransform := Import2('GDALGetGeoTransform',8);
  @GDALSetGeoTransform := Import2('GDALSetGeoTransform',8);
  @GDALDatasetRasterIO := Import2('GDALDatasetRasterIO',60);
  @GDALGetOverview := Import2('GDALGetOverview',8);
  @GDALGetDriverByName := Import2('GDALGetDriverByName',4);
  @GDALGetRasterDataType := Import2('GDALGetRasterDataType',4);
  @GDALGetRasterCount := Import2('GDALGetRasterCount',4);
  @GDALGetBlockSize := Import2('GDALGetBlockSize',12);
  @GDALGetRasterNoDataValue := Import2('GDALGetRasterNoDataValue',8);
  @GDALGetRasterScale := Import2('GDALGetRasterScale',8);
  @GDALGetRasterMinimum := Import2('GDALGetRasterMinimum',8);
  @GDALGetRasterMaximum := Import2('GDALGetRasterMaximum',8);
  @GDALGetOverviewCount := Import2('GDALGetOverviewCount',4);
  @GDALRasterIO := Import2('GDALRasterIO',48);
  @GDALReadBlock := Import2('GDALReadBlock',16);
  @GDALWriteBlock := Import2('GDALWriteBlock',16);
  @GDALGetDataTypeSize := Import2('GDALGetDataTypeSize',4);
  @GDALSetRasterNoDataValue := Import2('GDALSetRasterNoDataValue',12);
  @GDALSetRasterScale := Import2('GDALSetRasterScale',12);
  @GDALGetRasterStatistics := Import2('GDALGetRasterStatistics',28);
  @GDALComputeRasterStatistics := Import2('GDALComputeRasterStatistics',32);
  @GDALSetRasterStatistics := Import2('GDALSetRasterStatistics',36);
  @GDALComputeRasterMinMax := Import2('GDALComputeRasterMinMax',12);

  @GDALSetCacheMax64 := Import2('GDALSetCacheMax64',8);
  @GDALGetCacheMax64 := Import2('GDALGetCacheMax64',0);
  @GDALGetCacheUsed64 := Import2('GDALGetCacheUsed64',0);

  @GDALCreateColorTable := Import2('GDALCreateColorTable',4);
  @GDALDestroyColorTable := Import2('GDALDestroyColorTable',4);
  @GDALGetColorEntryCount := Import2('GDALGetColorEntryCount',4);
  @GDALGetColorEntry := Import2('GDALGetColorEntry',8);
  @GDALSetColorEntry := Import2('GDALSetColorEntry',12);
  @GDALGetRasterColorTable := Import2('GDALGetRasterColorTable',4);
  @GDALSetRasterColorTable := Import2('GDALSetRasterColorTable',8);

  @GDALDatasetCreateLayer := Import2('GDALDatasetCreateLayer');
  @GDALDatasetGetLayerByName := Import2('GDALDatasetGetLayerByName');
  @GDALDatasetGetLayer := Import2('GDALDatasetGetLayer');

  @OGRFree := Import2('OGRFree');
  @OGRRegisterAll := Import2('OGRRegisterAll');
  @OGROpen := Import2('OGROpen');
  @OGR_DS_GetLayerByName := Import2('OGR_DS_GetLayerByName');
  @OGR_DS_GetLayer := Import2('OGR_DS_GetLayer');
  @OGR_L_ResetReading := Import2('OGR_L_ResetReading');
  @OGR_L_GetNextFeature := Import2('OGR_L_GetNextFeature');
  @OGR_L_GetLayerDefn := Import2('OGR_L_GetLayerDefn');
  @OGR_L_GetSpatialRef := Import2('OGR_L_GetSpatialRef');
  @OGR_FD_GetFieldCount := Import2('OGR_FD_GetFieldCount');
  @OGR_Fld_GetType := Import2('OGR_Fld_GetType');
  @OGR_Fld_GetNameRef := Import2('OGR_Fld_GetNameRef');
  @OGR_FD_GetFieldDefn := Import2('OGR_FD_GetFieldDefn');
  @OGR_F_GetFieldAsInteger := Import2('OGR_F_GetFieldAsInteger');
  @OGR_F_GetFieldAsDouble := Import2('OGR_F_GetFieldAsDouble');
  @OGR_F_GetFieldAsString := Import2('OGR_F_GetFieldAsString');
  @OGR_F_GetFieldAsInteger64 := Import2('OGR_F_GetFieldAsInteger64');
  @OGR_F_SetFieldString := Import2('OGR_F_SetFieldString');
  @OGR_F_SetFieldInteger := Import2('OGR_F_SetFieldInteger');
  @OGR_F_SetFieldDouble := Import2('OGR_F_SetFieldDouble');
  @OGR_F_SetFieldDoubleList := Import2('OGR_F_SetFieldDoubleList');
  @OGR_F_GetGeometryRef := Import2('OGR_F_GetGeometryRef');
  @OGR_F_GetDefnRef := Import2('OGR_F_GetDefnRef');
  @OGR_G_GetGeometryType := Import2('OGR_G_GetGeometryType');
  @OGR_F_Destroy := Import2('OGR_F_Destroy');
  @OGR_DS_Destroy := Import2('OGR_DS_Destroy');
  @OGRGetDriverByName := Import2('OGRGetDriverByName');
  @OGR_Dr_CreateDataSource := Import2('OGR_Dr_CreateDataSource');
  @OGR_DS_CreateLayer := Import2('OGR_DS_CreateLayer');
  @OGR_Fld_Create := Import2('OGR_Fld_Create');
  @OGR_Fld_SetWidth := Import2('OGR_Fld_SetWidth');
  @OGR_Fld_SetPrecision := Import2('OGR_Fld_SetPrecision');
  @OGR_GFld_GetSpatialRef := Import2('OGR_GFld_GetSpatialRef');
  @OGR_GFld_SetSpatialRef := Import2('OGR_GFld_SetSpatialRef');
  @OGR_L_CreateField := Import2('OGR_L_CreateField');
  @OGR_Fld_Destroy := Import2('OGR_Fld_Destroy');
  @OGR_F_Create := Import2('OGR_F_Create');
  @OGR_F_SetGeometry := Import2('OGR_F_SetGeometry');
  @OGR_F_SetGeometryDirectly := Import2('OGR_F_SetGeometryDirectly');
  @OGR_F_GetFieldDefnRef := Import2('OGR_F_GetFieldDefnRef');
  @OGR_G_DestroyGeometry := Import2('OGR_G_DestroyGeometry');
  @OGR_L_CreateFeature := Import2('OGR_L_CreateFeature');
  @OGR_G_CreateGeometry := Import2('OGR_G_CreateGeometry');
  @OGR_F_GetFieldIndex := Import2('OGR_F_GetFieldIndex');
  @OGR_F_SetFieldRaw := Import2('OGR_F_SetFieldRaw');
  @OGR_G_SetPoint_2D := Import2('OGR_G_SetPoint_2D');
  @OGR_G_CreateFromWkt := Import2('OGR_G_CreateFromWkt');
  @OGR_FD_GetFieldIndex := Import2('OGR_FD_GetFieldIndex');
  @OGR_FD_GetGeomFieldDefn := Import2('OGR_FD_GetGeomFieldDefn');
  @OGR_G_ExportToIsoWkt := Import2( 'OGR_G_ExportToIsoWkt');
  @OSRNewSpatialReference := Import2('OSRNewSpatialReference',4);
  //@OSRDestroySpatialReference := Import2('OSRDestroySpatialReference',4); //use OSRRelease();
  @OSRGetAttrValue := Import2('OSRGetAttrValue',12);
  @OSRSetAttrValue := Import2('OSRSetAttrValue',12);
  @OSRExportToWkt := Import2('OSRExportToWkt',8);
  @OSRExportToProj4 := Import2('OSRExportToProj4',8);
  @OSRImportFromEPSG := Import2('OSRImportFromEPSG',8);
  @OSRRelease := Import2('OSRRelease');

  @OSRImportFromWkt := Import2('OSRImportFromWkt');
  @OSRImportFromProj4 := Import2('OSRImportFromProj4');
  @OSRIsGeographic := Import2('OSRIsGeographic');
  @OSRSetUTM := Import2('OSRSetUTM');
  @OSRGetUTMZone := Import2('OSRGetUTMZone');
  @OSRGetProjParm := Import2('OSRGetProjParm');
  @OSRGetAngularUnits := Import2('OSRGetAngularUnits');
  @OSRGetLinearUnits := Import2('OSRGetLinearUnits');
  @OSRSetLocalCS := Import2('OSRSetLocalCS');
  @OSRSetProjCS := Import2('OSRSetProjCS');
  @OSRSetLinearUnits := Import2('OSRSetLinearUnits');
  @OSRSetAngularUnits := Import2('OSRSetAngularUnits');
  @OSRSetWellKnownGeogCS := Import2('OSRSetWellKnownGeogCS');
  @OSRIsProjected := Import2('OSRIsProjected');
  @OSRIsSame := Import2('OSRIsSame');
  @OSRIsSameGeogCS := Import2('OSRIsSameGeogCS');

  @CSLDestroy := Import2('CSLDestroy',4);
  @CSLFetchBoolean := Import2('CSLFetchBoolean');
  @CSLSetNameValue := Import2('CSLSetNameValue');

  @CPLSetConfigOption := Import2('CPLSetConfigOption',8);
  @CPLGetConfigOption := Import2('CPLGetConfigOption',8);

  @CPLGetLastErrorType := Import2('CPLGetLastErrorType',0);
  @CPLErrorReset := Import2('CPLErrorReset',0);
end;

procedure TGdalDll_API.BeforeLoad;
begin
  inherited;
  ResolvePaths;
end;

function TGdalDll_API.ResolvePaths: Boolean;
var
  b1, b2, b3: boolean;
begin
  b1 := ResolveDLLPath;
  b2 := ResolveDataPath;
  b3 := ResolveDLLDriverPath;
  Result := b1 and b2 and b3;
end;

function TGdalDll_API.ResolveDLLPath: Boolean;
begin
  Result := DLL_Version<>0;
  if Result then exit;

  if DLL_VersionMin <= 0 then
    DLL_VersionMin := DLL_VersionMinDefault;
  if DLL_VersionMax <= 0 then
    DLL_VersionMax := DLL_VersionMaxDefault;

  // first try to use a given path, if one explicitly supplied
  Result := ResolveDLLPath_StandAlone(FDllPath, false);
end;

function TGdalDll_API.ResolveDLLPath_StandAlone(BasePath: String; IsVersionPath: Boolean): Boolean;
var
  v: Integer;
  NewDllPath: String;
begin
  Result := DLL_Version<>0;
  if Result or (BasePath = '') then exit;
  for v := DLL_VersionMax downto DLL_VersionMin do begin
    FDLLName := 'Gdal'+IntToStr(v)+'.dll';
    if IsVersionPath then
      NewDllPath := BasePath+'Gdal'+IntToStr(v)
    else
      NewDllPath := BasePath;
    NewDllPath := IncludeTrailingPathDelimiter(NewDllPath);
    Result := FileExists(NewDllPath + FDLLName);
    if Result then begin
      FDllPath := NewDllPath;
      DLL_Version := v;
      exit;
    end;
  end;
end;

function TGdalDll_API.ResolveDLLDriverPath: Boolean;
begin
  Result := DirectoryExists(GDAL_DRIVER_PATH);
  if Result then exit;

  GDAL_DRIVER_PATH := IncludeTrailingPathDelimiter(FDllPath+'gdalplugins');
  Result := DirectoryExists(GDAL_DRIVER_PATH);
  if Result then exit;

  {GDAL_DRIVER_PATH := FDllPath;
  Result := DirectoryExists(GDAL_DRIVER_PATH);
  if Result then exit;}

  GDAL_DRIVER_PATH := '';
end;

function TGdalDll_API.ResolveDataPath: Boolean;
begin
  Result := DirectoryExists(GDAL_DATA);
  if Result then exit;

  GDAL_DATA := IncludeTrailingPathDelimiter(FDllPath+'gdal-data');
  Result := DirectoryExists(GDAL_DATA);
  if Result then exit;

  GDAL_DATA := IncludeTrailingPathDelimiter(FDllPath+'..\share\gdal');
  Result := DirectoryExists(GDAL_DATA);
  if Result then exit;

  {GDAL_DATA := FDllPath;
  Result := DirectoryExists(GDAL_DATA);
  if Result then exit;}

  GDAL_DATA := '';
end;

procedure TGdalDll_API.AfterLoad;
begin
  inherited;
  GDALAllRegisterVerify;
  GDALDefaultCacheMax := GDALGetCacheMax64;
end;

procedure TGdalDll_API.GDALAllRegisterVerify;
begin
  // Path to directory containing various GDAL data files
  // (EPSG CSV files, S-57 definition files, DXF header and footer files, ...).
  // This option is read by the GDAL and OGR driver registration functions.
  // It is used to expand EPSG codes into their description in the OSR model (WKT based).
  // needed for instance to get some info about some CRSs
  if GDAL_DATA<>'' then
    CPLSetConfigOption1('GDAL_DATA',GDAL_DATA);

  // Path to directory containing driver files in format "gdal_XYZ.dll" or "ogr_XYZ.dll"
  // needed for instance to load ECW files
  if GDAL_DRIVER_PATH<>'' then
    CPLSetConfigOption1('GDAL_DRIVER_PATH',GDAL_DRIVER_PATH);

  // registers GDAL drivers
  // for external driver plugins (in GDAL_DRIVER_PATH):
  // it will call GDALRegisterMe for each driver, and also:
  // GDALRegister_XYZ (for "gdal_XYZ.dll") or RegisterOGRXYZ (for "ogr_XYZ.dll")
  GDALAllRegister();
end;

procedure TGdalDll_API.CPLSetConfigOption1(name: string; value: string);
var
  pszName, pszValue: RawByteString;
begin
  if name = '' then exit;
  pszName := UTF8Encode(name);
  pszValue := UTF8Encode(value);
  CPLSetConfigOption(PAnsiChar(pszName),PAnsiChar(pszValue));
end;

function TGdalDll_API.CPLGetConfigOption1(const name: string; const default: string): string;
var
  pszName, pszValue, pszDefault: RawByteString;
begin
  if name = '' then exit;
  pszName := UTF8Encode(name);
  pszDefault := UTF8Encode(default);
  pszValue := CPLGetConfigOption(PAnsiChar(pszName),PAnsiChar(pszDefault));
  Result := UTF8ToString(pszValue);
end;

function TGdalDll_API.CSLSetNameValue1(papszStrList: PPAnsiChar; const Name: String; const Value: String): PPAnsiChar;
var
  pszName, pszValue: RawByteString;
begin
  pszName := UTF8Encode(name);
  pszValue := UTF8Encode(value);
  Result := CSLSetNameValue(papszStrList, PAnsiChar(pszName), PAnsiChar(pszValue));
end;

function TGdalDll_API.OSRSetAttrValue1(hSRS:OGRSpatialReferenceH; Path, Value: AnsiString): OGRErr;
begin
  Result := OSRSetAttrValue(hSRS, PAnsiChar(Path), PAnsiChar(Value));
end;

end.

