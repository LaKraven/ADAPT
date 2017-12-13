unit ADAPT.Collections;

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
  ///  <summary><c>A Simple Generic Array with basic Management Methods.</c></summary>
  ///  <remarks>
  ///    <para><c>Use IADArray or IADArrayReader if you want to take advantage of Reference Counting.</c></para>
  ///    <para><c>This is NOT Threadsafe</c></para>
  ///  </remarks>
  TADArray<T> = class(TADObject, IADArrayReader<T>, IADArray<T>)
  private
    FArray: TArray<IADValueHolder<T>>;
    FCapacityInitial: Integer;
    // Getters
    { IADArrayReader<T> }
    function GetCapacity: Integer;
    function GetItem(const AIndex: Integer): T;
    { IADArray<T> }
    function GetReader: IADArrayReader<T>;

    // Setters
    { IADArray<T> }
    procedure SetCapacity(const ACapacity: Integer);
    procedure SetItem(const AIndex: Integer; const AItem: T);
  public
    // Management Methods
    { IADArray<T> }
    procedure Clear;
    procedure Delete(const AIndex: Integer); overload;
    procedure Delete(const AFirstIndex, ACount: Integer); overload;
    procedure Finalize(const AIndex, ACount: Integer);
    procedure Insert(const AItem: T; const AIndex: Integer);
    procedure Move(const AFromIndex, AToIndex, ACount: Integer);

    // Properties
    { IADArrayReader<T> }
    property Capacity: Integer read GetCapacity;
    property Items[const AIndex: Integer]: T read GetItem; default;
    { IADArray<T> }
    property Items[const AIndex: Integer]: T read GetItem write SetItem; default;
    property Reader: IADArrayReader<T> read GetReader;
  end;

implementation

{ TADArray<T> }

procedure TADArray<T>.Clear;
begin

end;

procedure TADArray<T>.Delete(const AIndex: Integer);
begin

end;

procedure TADArray<T>.Delete(const AFirstIndex, ACount: Integer);
begin

end;

procedure TADArray<T>.Finalize(const AIndex, ACount: Integer);
begin

end;

function TADArray<T>.GetCapacity: Integer;
begin

end;

function TADArray<T>.GetItem(const AIndex: Integer): T;
begin

end;

function TADArray<T>.GetReader: IADArrayReader<T>;
begin
  Result := IADArrayReader<T>(Self);
end;

procedure TADArray<T>.Insert(const AItem: T; const AIndex: Integer);
begin

end;

procedure TADArray<T>.Move(const AFromIndex, AToIndex, ACount: Integer);
begin

end;

procedure TADArray<T>.SetCapacity(const ACapacity: Integer);
begin

end;

procedure TADArray<T>.SetItem(const AIndex: Integer; const AItem: T);
begin

end;

end.
