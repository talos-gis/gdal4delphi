unit TypesC;

interface

type
  // the following types are as defined in stdint.h
  uint8_t = Byte;
  uint16_t = Word;
  uint32_t = Cardinal;
  int8_t = ShortInt;
  int16_t = SmallInt;
  int32_t = Integer;
  int64_t = int64;

  float = Single;

  // intptr_t, uintptr_t are defined like that for compatability with 32bit version of Delphi
  // where some functions accept only Integer/Cardinal and not NativeInt/NativeUInt
  // which are exactly the same on 32bit...
  intptr_t = {$IFDEF WIN64}NativeInt{$ELSE}Integer{$ENDIF};
  uintptr_t = {$IFDEF WIN64}NativeUInt{$ELSE}Cardinal{$ENDIF};

  size_t = uintptr_t;

  // additional basic types

  //Delphi bool type is 4 bytes
  //C(stdbool.h), C++, C# bool types area 1 byte.
  //IntBool type is to be used with C interface to allow a consistent ABI
  IntBool = Boolean;
  pIntBool = ^IntBool;

  NativeInt1 = intptr_t;
  NativeUInt1 = uintptr_t;
  PNativeInt = ^NativeInt1;

  psize_t = ^size_t;
  {$POINTERMATH ON}
  // POINTERMATH is enabled in order to be able to use the following
  // pointers types with [] as if they were array. available since Delphi 2009
  puint8_t   = ^uint8_t;
  puint16_t  = ^uint16_t;
  puint32_t  = ^uint32_t;
  pint8_t    = ^int8_t;
  pint16_t   = ^int16_t;
  pint32_t   = ^int32_t;
  pfloat     = ^single;
  pdouble1   = ^double; // the builtin type system.pdouble is with pointermath on. pdouble1 can be used with array notation

  ppuint8_t  = ^puint8_t;
  ppuint16_t = ^puint16_t;
  ppuint32_t = ^puint32_t;
  ppint8_t   = ^pint8_t;
  ppint16_t  = ^pint16_t;
  ppint32_t  = ^pint32_t;
  ppfloat    = ^psingle;
  ppdouble   = ^pdouble1;
  {$POINTERMATH OFF}

implementation

end.
