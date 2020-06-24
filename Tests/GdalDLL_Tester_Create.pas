unit GdalDLL_Tester_Create;

interface

uses
  GdalDLL_Tester,
  GdalDLL_API,
  ProjStringsConsts,
  {$IFNDEF MIN_INIT}
  GdalDLL_Intf,
  GdalDLL,
  TalosDirs,
  {$ENDIF}
  SysUtils; //placeholder

function CreateGDAL_Tester: TGdalTester;

implementation

function CreateGDAL_Tester: TGdalTester;
var
  gdal: TGdalDLL_API;
  sGDAL_Version: String;
  b: string;
begin
  {$IFDEF MIN_INIT}
  gdal := TGdalDll_API.Create(nil);
  gdal.DLL_Version := 201;
  sGDAL_Version := 'gdal'+IntToStr(gdal.DLL_Version);
  b := {$IFDEF WIN64}'64'{$ELSE}''{$ENDIF};
  gdal.DllPath := 'd:\dev\git.bin\bin'+b+'\'+sGDAL_Version+'\';
  gdal.DllName := sGDAL_Version+'.dll';
  {$ELSE}
  gdal := TGdalDll.Create(nil);
  InitPaths;
  {$ENDIF}

  {gdal.DLL_VersionMin := 201;
  gdal.DLL_VersionMax := 204;
  gdal.GDAL_DATA := '';
  gdal.GDAL_DRIVER_PATH := '';}

  if not gdal.LoadDll then
    FreeAndNil(gdal);
  if gdal=nil then exit;

  Result := TGdalTester.Create;
  Result.iProjString := WGS84GeoProjString;
  Result.iTestFileName := 'd:\Maps\srtm.tif';
  Result.gdal := gdal;
end;

end.

