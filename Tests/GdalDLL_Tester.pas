unit GdalDLL_Tester;

interface

uses
  GdalDataTypes,
  GdalDLL_API;

type
  TGdalTester = class
  public
    gdal:TGdalDll_API;
    iProjString: AnsiString;
    owkt: AnsiString;
    obuf: PByte;
    MemSize: NativeInt;
    iTestFileName: String;
    function GDAL_RunTests: Boolean;
    destructor Destroy; override;
  end;

function GdalSRSWktFromProj4_TEST(gdal:TGdalDll_API; Proj4: PAnsiChar): AnsiString;
function GdalRead_TEST(gdal:TGdalDll_API; FileName: String; var MemSize: NativeInt): PByte;

implementation

destructor TGdalTester.Destroy;
begin
  FreeMem(self.obuf, MemSize);
  inherited;
end;

function TGdalTester.GDAL_RunTests: Boolean;
var
  s: AnsiString;
begin
  s := Self.iProjString;
  Self.owkt := GdalSRSWktFromProj4_TEST(Self.gdal, PAnsiChar(s));
  Self.obuf := GdalRead_TEST(Self.gdal, Self.iTestFileName, Self.MemSize);
  Result := True;
end;

function GdalRead_TEST(gdal:TGdalDll_API; FileName: String; var MemSize: NativeInt): PByte;
var
  pafScanline: pSingle;
  nXSize, nBlockXSize, nBlockYSize, bGotMin, bGotMax: Integer;
  adfMinMax: array [0..1] of double;
  hBand: GDALRasterBandH;
  hDataset: GDALDatasetH;
  pszFilename: RawByteString;
  nLineSpaceResult: Integer;
  nBXSize, nBYSize: Integer;
  odt: GDALDataType;
  err: CPLErr;
  tmp: PByte;
begin
  Result := 0;
  MemSize := 0;
  //    Gdal.GDALAllRegister();
  pszFilename := utf8encode(FileName);
  hDataset := Gdal.GDALOpen( PAnsiChar(pszFilename), GA_ReadOnly );
  if (hDataset = nil) then
    exit;

  hBand := Gdal.GDALGetRasterBand( hDataset, 1 );
  Gdal.GDALGetBlockSize( hBand, @nBlockXSize, @nBlockYSize );
  {printf( "Block=%dx%d Type=%s, ColorInterp=%s\n",
        nBlockXSize, nBlockYSize,
        Gdal.GDALGetDataTypeName(Gdal.GDALGetRasterDataType(hBand)),
        Gdal.GDALGetColorInterpretationName(
            Gdal.GDALGetRasterColorInterpretation(hBand)) );}

  odt := Gdal.GDALGetRasterDataType(hBand);
  nLineSpaceResult := nBXSize * (Gdal.GDALGetDataTypeSize(odt) shr 3); //times bytes per sample

  //nXSize = Gdal.GDALGetRasterBandXSize( hBand );
  nXSize := 10;
  nBYSize := 10;
  MemSize := nLineSpaceResult * nBYSize;
  GetMem(tmp, MemSize);

  if tmp=nil then
    exit;
  err := Gdal.GDALRasterIO( hBand, GF_Read, 0, 0, nXSize, 1,
            tmp, nXSize, 1, odt,
            0, 0 );
  if err<>CE_None then
    exit;
  Result := tmp;
end;

function GdalSRSWktFromProj4_TEST(gdal:TGdalDll_API; Proj4: PAnsiChar): AnsiString;
var
  hSRS: OGRSpatialReferenceH;
  pszCRS_WKT: PAnsiChar;
begin
  hSRS := Gdal.OSRNewSpatialReference(nil);
  Gdal.OSRImportFromProj4(hSRS, Proj4);
  //Gdal.OSRImportFromEPSG(hSRS, 4326);
  Gdal.OSRExportToWkt(hSRS, @pszCRS_WKT);
  Result := AnsiString(pszCRS_WKT);
  Gdal.OSRRelease(hSRS);
end;

end.

