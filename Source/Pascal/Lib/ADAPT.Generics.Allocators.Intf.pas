{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Allocators.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common.Intf,
  ADAPT.Generics.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>A Geometric Allocation Algorithm for Lists.</c></summary>
  ///  <remarks>
  ///    <para><c>When the number of Vacant Slots falls below the Threshold, the number of Vacant Slots increases by the value of the current Capacity multiplied by the Mulitplier.</c></para>
  ///  </remarks>
  IADExpanderGeometric = interface(IADExpander)
  ['{CAF4B15C-9BE5-4A66-B31F-804AB752A102}']
    // Getters
    function GetCapacityMultiplier: Single;
    function GetCapacityThreshold: Integer;
    // Setters
    procedure SetCapacityMultiplier(const AMultiplier: Single);
    procedure SetCapacityThreshold(const AThreshold: Integer);
    // Properties
    property CapacityMultiplier: Single read GetCapacityMultiplier write SetCapacityMultiplier;
    property CapacityThreshold: Integer read GetCapacityThreshold write SetCapacityThreshold;
  end;

implementation

end.
