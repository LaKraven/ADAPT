{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Common.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf;

  {$I ADAPT_RTTI.inc}

type
  // Enums
  TADIterateDirection = (idLeft, idRight);

  // Callbacks
  {$IFDEF SUPPORTS_REFERENCETOMETHOD}
    TADListItemCallbackAnon<T> = reference to procedure(const Item: T);
  {$ENDIF SUPPORTS_REFERENCETOMETHOD}
  TADListItemCallbackOfObject<T> = procedure(const Item: T) of object;
  TADListItemCallbackUnbound<T> = procedure(const Item: T);

  ///  <summary><c>A Collection that can Own Objects.</c></summary>
  IADObjectOwner = interface(IADInterface)
  ['{5756A232-26B6-4395-9F1D-CCCC071E5701}']
  // Getters
  function GetOwnership: TADOwnership;
  // Setters
  procedure SetOwnership(const AOwnership: TADOwnership);
  // Properties
  property Ownership: TADOwnership read GetOwnership write SetOwnership;
  end;

  IADIterable<T> = interface(IADInterface)
  ['{910A3785-06C0-4512-A823-3AA4D77BDB18}'] // If we don't provide a GUID here, we cannot cast-reference Collections as "Iterables".
    // Iterators
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure Iterate(const ACallback: TADListItemCallbackAnon<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure Iterate(const ACallback: TADListItemCallbackOfObject<T>; const ADirection: TADIterateDirection = idRight); overload;
    procedure Iterate(const ACallback: TADListItemCallbackUnbound<T>; const ADirection: TADIterateDirection = idRight); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateForward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateForward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateForward(const ACallback: TADListItemCallbackUnbound<T>); overload;
    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      procedure IterateBackward(const ACallback: TADListItemCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    procedure IterateBackward(const ACallback: TADListItemCallbackOfObject<T>); overload;
    procedure IterateBackward(const ACallback: TADListItemCallbackUnbound<T>); overload;
  end;

implementation

end.
