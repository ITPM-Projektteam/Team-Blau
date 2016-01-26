unit mSRWLock;

interface

type
  TSRWLock = class
  private
    Lock: Pointer;
  public
    procedure AcquireShared;
    procedure ReleaseShared;
    procedure AcquireExclusive;
    procedure ReleaseExclusive;
  end;

implementation

procedure AcquireSRWLockShared(var P: Pointer); stdcall;
  external 'kernel32.dll';
procedure ReleaseSRWLockShared(var P: Pointer); stdcall;
  external 'kernel32.dll';

procedure AcquireSRWLockExclusive(var P: Pointer); stdcall;
  external 'kernel32.dll';
procedure ReleaseSRWLockExclusive(var P: Pointer); stdcall;
  external 'kernel32.dll';

procedure TSRWLock.AcquireShared;
begin
  AcquireSRWLockShared(Lock);
end;

procedure TSRWLock.ReleaseShared;
begin
  ReleaseSRWLockShared(Lock);
end;

procedure TSRWLock.AcquireExclusive;
begin
  AcquireSRWLockExclusive(Lock);
end;

procedure TSRWLock.ReleaseExclusive;
begin
  ReleaseSRWLockExclusive(Lock);
end;

end.

{ Alternativ:

  unit mSRWLock;

  interface

  type
  TSRWLock = Pointer

  implementation

  procedure AcquireSRWLockShared(var P: TSRWLock); stdcall; external 'kernel32.dll';
  procedure ReleaseSRWLockShared(var P: TSRWLock); stdcall; external 'kernel32.dll';

  procedure AcquireSRWLockExclusive(var P: TSRWLock); stdcall; external 'kernel32.dll';
  procedure ReleaseSRWLockExclusive(var P: TSRWLock); stdcall; external 'kernel32.dll';

  end. }
