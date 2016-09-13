{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Math.Averagers.Intf;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT, ADAPT.Intf,
  ADAPT.Collections.Intf;

  {$I ADAPT_RTTI.inc}

type
  ///  <summary><c>An Averagering Algorithm for a Series of Values of the given Type.</c></summary>
  IADAverager<T> = interface(IADInterface)
    // Management Methods
    ///  <returns><c>The Calculated Average for the given Series.</c></returns>
    function CalculateAverage(const ASeries: IADCollectionList<T>): T; overload;
    ///  <returns><c>The Calculated Average for the given Series.</c></returns>
    function CalculateAverage(const ASeries: Array of T; const ASortedState: TADSortedState): T; overload;
  end;

  ///  <summary><c>An Object containing an Averager.</c></summary>
  IADAveragable<T> = interface(IADInterface)
  ['{B3B4B967-F6EB-42CC-BD81-A39FA71A5209}']
    // Getters
    ///  <returns>The Averager used by this Object.</c></returns>
    function GetAverager: IADAverager<T>;

    // Setters
    ///  <summary><c>Defines the Averager to be used by this Object.</c></summary>
    procedure SetAverager(const AAverager: IADAverager<T>);

    // Properties
    ///  <summary><c>Defines the Averager to be used by this Object.</c></summary>
    ///  <returns>The Averager used by this Object.</c></returns>
    property Averager: IADAverager<T> read GetAverager write SetAverager;
  end;


implementation

end.
