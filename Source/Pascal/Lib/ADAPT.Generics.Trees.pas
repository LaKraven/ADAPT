{
  AD.A.P.T. Library
  Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved

  Original Source Location: https://github.com/LaKraven/ADAPT
  Subject to original License: https://github.com/LaKraven/ADAPT/blob/master/LICENSE.md
}
unit ADAPT.Generics.Trees;

{$I ADAPT.inc}

interface

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  ADAPT.Common, ADAPT.Common.Intf,
  ADAPT.Generics.Lists.Intf,
  ADAPT.Generics.Trees.Intf;

  {$I ADAPT_RTTI.inc}

type
  TADTreeNode<T> = class(TADObject, IADTreeNode<T>)
  private type
    IADTreeNodeT = IADTreeNode<T>;
  private
    FChildren: IADList<IADTreeNodeT>;
    FDestroying: Boolean;
    FParent: Pointer;
    FValue: T;

    // Geters
    function GetChildCount: Integer;
    function GetDepth: Integer;
    function GetIsDestroying: Boolean;
    function GetRootNode: IADTreeNode<T>;
    function GetParent: IADTreeNode<T>;
    function GetChildren: IADList<IADTreeNodeT>;
    function GetIndexAsChild: Integer;
    function GetIsBranch: Boolean;
    function GetIsRoot: Boolean;
    function GetIsLeaf: Boolean;
    function GetValue: T;
    // Setters
    procedure SetValue(const AValue: T);

    procedure DoAncestorChanged;
  protected
    procedure AncestorChanged; virtual;
    procedure Destroying; virtual;

    procedure AddChild(const AIndex: Integer; const AChild: IADTreeNode<T>); virtual;
    procedure RemoveChild(const AChild: IADTreeNode<T>); virtual;

    property IsDestroying: Boolean read FDestroying;
  public
    constructor Create(const AParent: IADTreeNode<T>; const AValue: T); reintroduce; overload;
    constructor Create(const AParent: IADTreeNode<T>); reintroduce; overload;
    constructor Create(const AValue: T); reintroduce; overload;
    constructor Create; overload; override;
    destructor Destroy; override;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    // Management Methods
    procedure MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer = -1); overload;
    procedure MoveTo(const AIndex: Integer); overload;

    function IndexOf(const AChild: IADTreeNode<T>): Integer;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
      procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, down, and executes the given Callback.</c></summary>
    procedure PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    {$IFDEF SUPPORTS_REFERENCETOMETHOD}
      ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>); overload;
      ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
      procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>); overload;
    {$ENDIF SUPPORTS_REFERENCETOMETHOD}
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>); overload;
    ///  <summary><c>Steps recursively through the Tree from the current node, up, and executes the given Callback.</c></summary>
    procedure PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>); overload;

    ///  <summary><c>The Depth of the given Node relative to the Root.</c></summary>
    property Depth: Integer read GetDepth;

    ///  <summary><c>Reference to the Parent of the given Node.</c></summary>
    ///  <remarks><c>This reference would be Nil for the Root Node.</c></summary>
    property Parent: IADTreeNode<T> read GetParent;
    ///  <summary><c>Reference to the Root Node.</c></summary>
    ///  <remarks><c>This reference would be Nil for the Root Node.</c></summary>
    property RootNode: IADTreeNode<T> read GetRootNode;
    ///  <summary><c>The number of Child Nodes directly beneath the given Node.</c></summary>
    property ChildCount: Integer read GetChildCount;
    ///  <summary><c>Returns the Child List.</c></summary>
    property Children: IADList<IADTreeNodeT> read GetChildren;
    ///  <summary><c>Returns the Index of the given Node relative to its Parent Node.</c></summary>
    ///  <remarks><c>Returns -1 if there is no Parent Node.</c></remarks>
    property IndexAsChild: Integer read GetIndexAsChild;

    ///  <summary><c>Is the given Node a Branch.</c></summary>
    property IsBranch: Boolean read GetIsBranch;
    ///  <summary><c>Is the given Node the Root.</c></summary>
    property IsRoot: Boolean read GetIsRoot;
    ///  <summary><c>Is the given Node a Leaf.</c></summary>
    property IsLeaf: Boolean read GetIsLeaf;

    ///  <summary><c>The Value specialized to the given Generic Type.</c></summary>
    property Value: T read GetValue write SetValue;
  end;

implementation

uses
  ADAPT.Generics.Lists;

{ TADTreeNode<T> }

procedure TADTreeNode<T>.AddChild(const AIndex: Integer; const AChild: IADTreeNode<T>);
begin
  if AIndex < 0 then
    FChildren.Add(AChild)
  else
    FChildren.Insert(AChild, AIndex);
end;

procedure TADTreeNode<T>.AfterConstruction;
begin
  inherited;

  if Parent <> nil then
    Parent.AddChild(-1, Self);

  DoAncestorChanged;
end;

procedure TADTreeNode<T>.AncestorChanged;
begin
  // Do nothing (yet)
end;

procedure TADTreeNode<T>.BeforeDestruction;
begin
  inherited;

  if not IsDestroying then
    PreOrderWalk(procedure(const Node: IADTreeNode<T>)
                 begin
                   Node.IsDestroying;
                 end);

  if (Parent <> nil) and (not Parent.IsDestroying) then
    Parent.RemoveChild(Self);
end;

constructor TADTreeNode<T>.Create(const AParent: IADTreeNode<T>; const AValue: T);
begin
  inherited Create;

  FDestroying := False;
  FParent := @AParent;
  FChildren := TADList<IADTreeNodeT>.Create;
  FValue := AValue;
end;

constructor TADTreeNode<T>.Create;
begin
  Create(nil, Default(T));
end;

constructor TADTreeNode<T>.Create(const AValue: T);
begin
  Create(nil, AValue);
end;

constructor TADTreeNode<T>.Create(const AParent: IADTreeNode<T>);
begin
  Create(AParent, Default(T));
end;

destructor TADTreeNode<T>.Destroy;
begin

  inherited;
end;

procedure TADTreeNode<T>.Destroying;
begin
  FDestroying := True;
end;

procedure TADTreeNode<T>.DoAncestorChanged;
begin
  PreOrderWalk(procedure(const Node: IADTreeNode<T>)
               begin
                 Node.AncestorChanged;
               end);
end;

function TADTreeNode<T>.GetChildren: IADList<IADTreeNodeT>;
begin
  Result := FChildren;
end;

function TADTreeNode<T>.GetChildCount: Integer;
begin
  Result := FChildren.Count;
end;

function TADTreeNode<T>.GetDepth: Integer;
var
  Ancestor: IADTreeNode<T>;
begin
  Ancestor := Parent;
  Result := 0;

  while Ancestor <> nil do
  begin
    Inc(Result);
    Ancestor := Ancestor.Parent;
  end;
end;

function TADTreeNode<T>.GetIsDestroying: Boolean;
begin
  Result := FDestroying;
end;

function TADTreeNode<T>.GetIndexAsChild: Integer;
begin
  if Parent = nil then
    Result := -1
  else
    Result := Parent.IndexOf(Self);
end;

function TADTreeNode<T>.GetIsBranch: Boolean;
begin
  Result := (not GetIsRoot) and (not GetIsLeaf);
end;

function TADTreeNode<T>.GetIsLeaf: Boolean;
begin
  Result := FChildren.Count = 0;
end;

function TADTreeNode<T>.GetIsRoot: Boolean;
begin
  Result := Parent = nil;
end;

function TADTreeNode<T>.GetParent: IADTreeNode<T>;
begin
  if FParent = nil then
    Result := nil
  else
    Result := IADTreeNode<T>(FParent^);
end;

function TADTreeNode<T>.GetRootNode: IADTreeNode<T>;
begin
  if IsRoot then
    Result := Self
  else
    Result := Parent.RootNode;
end;

function TADTreeNode<T>.GetValue: T;
begin
  Result := FValue;
end;

function TADTreeNode<T>.IndexOf(const AChild: IADTreeNode<T>): Integer;
begin
//  Result := FChildren.IndexOf(AChild);
//TODO -oDaniel -cTADTreeNode<T>: Need to know the Index of this Node in its Parent's "Children" list.
end;

procedure TADTreeNode<T>.MoveTo(const ANewParent: IADTreeNode<T>; const AIndex: Integer);
begin
  if (Parent = nil) and (ANewParent = nil) then
    Exit;

  if Parent = ANewParent then
  begin
    if AIndex <> IndexAsChild then
    begin
//      Parent.Children.Remove(Self); //TODO -oDaniel -cTADTreeNode<T>: Need to know the Index of this Node in its Parent's "Children" list.
      if AIndex < 0 then
        Parent.Children.Add(Self)
      else
        Parent.Children.Insert(Self, AIndex);
    end;
  end else
  begin
    if Parent <> nil then
      Parent.RemoveChild(Self);

    FParent := @ANewParent;

    if Parent <> nil then
      Parent.AddChild(AIndex, Self);

    DoAncestorChanged;
  end;
end;

procedure TADTreeNode<T>.MoveTo(const AIndex: Integer);
begin
  MoveTo(Parent, AIndex);
end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}

  procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>);
  begin

  end;

  procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>);
begin

end;

procedure TADTreeNode<T>.RemoveChild(const AChild: IADTreeNode<T>);
begin
  // TODO -oDaniel -cTADTreeNode<T>: Each Tree Node needs to be aware of its Index within its Parent's "FChildren" list!
end;

procedure TADTreeNode<T>.PreOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>);
begin

end;

{$IFDEF SUPPORTS_REFERENCETOMETHOD}
  procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<IADTreeNode<T>>);
  begin

  end;

  procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackAnon<T>);
  begin

  end;
{$ENDIF SUPPORTS_REFERENCETOMETHOD}

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<T>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackOfObject<IADTreeNode<T>>);
begin

end;

procedure TADTreeNode<T>.PostOrderWalk(const AAction: TADTreeNodeValueCallbackUnbound<T>);
begin

end;

procedure TADTreeNode<T>.SetValue(const AValue: T);
begin
  FValue := AValue;
end;

end.
