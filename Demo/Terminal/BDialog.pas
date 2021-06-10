///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//     Функции вызова диалогов обзора папок, открытия и сохранения файла     //
//     -----------------------------------------------------------------     //
//            (c) 2004-2007 Брусникин И.В.           majar@nm.ru             //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////

unit BDialog;

interface

uses
  Windows;

type
  TSHItemID = packed record
    cb: Word;
    abID: array[0..0] of Byte;
  end;

  PItemIDList = ^TItemIDList;
  TItemIDList = packed record
     mkid: TSHItemID;
   end;

  TBFCallBack = function(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
  TOSCallBack = function(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;

  PBrowseInfoA = ^TBrowseInfoA;
  PBrowseInfoW = ^TBrowseInfoW;
  PBrowseInfo = PBrowseInfoA;

  TBrowseInfoA = packed record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PAnsiChar;
    lpszTitle: PAnsiChar;
    ulFlags: UINT;
    lpfn: TBFCallBack;
    lParam: LPARAM;
    iImage: Integer;
  end;

  TBrowseInfoW = packed record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PWideChar;
    lpszTitle: PWideChar;
    ulFlags: UINT;
    lpfn: TBFCallBack;
    lParam: LPARAM;
    iImage: Integer;
  end;
  
  TBrowseInfo = TBrowseInfoA;

  POpenFilenameA = ^TOpenFilenameA;
  POpenFilenameW = ^TOpenFilenameW;
  POpenFilename = POpenFilenameA;

  TOpenFilenameA = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PAnsiChar;
    lpstrCustomFilter: PAnsiChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PAnsiChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PAnsiChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PAnsiChar;
    lpstrTitle: PAnsiChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PAnsiChar;
    lCustData: LPARAM;
    lpfnHook: TOSCallBack;
    lpTemplateName: PAnsiChar;
    pvReserved: Pointer;
    dwReserved: DWORD;
    FlagsEx: DWORD;
  end;

  TOpenFilenameW = packed record
    lStructSize: DWORD;
    hWndOwner: HWND;
    hInstance: HINST;
    lpstrFilter: PWideChar;
    lpstrCustomFilter: PWideChar;
    nMaxCustFilter: DWORD;
    nFilterIndex: DWORD;
    lpstrFile: PWideChar;
    nMaxFile: DWORD;
    lpstrFileTitle: PWideChar;
    nMaxFileTitle: DWORD;
    lpstrInitialDir: PWideChar;
    lpstrTitle: PWideChar;
    Flags: DWORD;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PWideChar;
    lCustData: LPARAM;
    lpfnHook: TOSCallBack;
    lpTemplateName: PWideChar;
    pvReserved: Pointer;
    dwReserved: DWORD;
    FlagsEx: DWORD;
  end;
  
  TOpenFilename = TOpenFilenameA;

const
  BIF_RETURNONLYFSDIRS = $0001;
  BIF_DONTGOBELOWDOMAIN = $0002;
  BIF_NEWDIALOGSTYLE = $0040;
  BIF_BROWSEFORCOMPUTER = $1000;
  BIF_BROWSEFORPRINTER = $2000;
  BIF_BROWSEINCLUDEFILES = $4000;

  CSIDL_DESKTOP = $0000;
  CSIDL_PROGRAMS = $0002;
  CSIDL_CONTROLS = $0003;
  CSIDL_PRINTERS = $0004;
  CSIDL_PERSONAL = $0005;
  CSIDL_FAVORITES = $0006;
  CSIDL_STARTUP = $0007;
  CSIDL_RECENT = $0008;
  CSIDL_SENDTO = $0009;
  CSIDL_BITBUCKET = $000a;
  CSIDL_STARTMENU = $000b;
  CSIDL_DESKTOPDIRECTORY = $0010;
  CSIDL_DRIVES = $0011;
  CSIDL_NETWORK = $0012;
  CSIDL_NETHOOD = $0013;
  CSIDL_FONTS = $0014;
  CSIDL_TEMPLATES = $0015;
  CSIDL_COMMON_STARTMENU = $0016;
  CSIDL_COMMON_PROGRAMS = $0017;
  CSIDL_COMMON_STARTUP = $0018;
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  CSIDL_APPDATA = $001a;
  CSIDL_PRINTHOOD = $001b;

function SHGetPathFromIDListA(pidl: PItemIDList; pszPath: PAnsiChar): BOOL; stdcall;
function SHGetPathFromIDListW(pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall;
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall;
function SHBrowseForFolderA(var lpbi: TBrowseInfoA): PItemIDList; stdcall;
function SHBrowseForFolderW(var lpbi: TBrowseInfoW): PItemIDList; stdcall;
function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
function GetOpenFileNameA(var OpenFile: TOpenFilenameA): BOOL; stdcall;
function GetOpenFileNameW(var OpenFile: TOpenFilenameW): BOOL; stdcall;
function GetOpenFileName(var OpenFile: TOpenFilename): BOOL; stdcall;
function GetSaveFileNameA(var OpenFile: TOpenFilenameA): BOOL; stdcall;
function GetSaveFileNameW(var OpenFile: TOpenFilenameW): BOOL; stdcall;
function GetSaveFileName(var OpenFile: TOpenFilename): BOOL; stdcall;

function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: DWORD;
  var ppidl: PItemIDList): HResult; stdcall;

function DirBrowse(Title: String; Flg, Root: DWORD; var Fldr: String): Boolean;
function OpenFileDlg(Title, StartDir, Filter: String; var FName: String): Boolean;
function SaveFileDlg(Title, StartDir, Filter: String; var FName: String): Boolean;

implementation

function NewOSVer: Boolean;
var
  V: TOSVersionInfo;
begin
  V.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  Result := GetVersionEx(V);
  if Result then Result := ((V.dwPlatformId = VER_PLATFORM_WIN32_NT) and
    (V.dwMajorVersion >= 5)) or
    ((V.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) and
    (V.dwMajorVersion >= 4) and (V.dwMinorVersion >= 90));
end;

const
  shl32 = 'shell32.dll';
  cmd32 = 'comdlg32.dll';

  WM_USER = $0400;
  BFFM_INITIALIZED = 1;
  BFFM_SELCHANGED = 2;
  BFFM_ENABLEOK = WM_USER + 101;
  BFFM_SETSELECTIONA = WM_USER + 102;
  BFFM_SETSELECTIONW = WM_USER + 103;
  BFFM_SETSELECTION = BFFM_SETSELECTIONA;

  OFN_OVERWRITEPROMPT = $00000002;
  OFN_HIDEREADONLY = $00000004;
  OFN_ENABLEHOOK = $00000020;
  OFN_PATHMUSTEXIST = $00000800;
  OFN_FILEMUSTEXIST = $00001000;
  OFN_EXPLORER = $00080000;
  OFN_ENABLESIZING = $00800000;
  WM_INITDIALOG = $0110;

var
  Ofn: TOpenFileName;
  Buffer: array[0..MAX_PATH - 1] of Char;
  FDir: PChar;
  SS: DWORD;

function SHGetPathFromIDListA; external shl32 name 'SHGetPathFromIDListA';
function SHGetPathFromIDListW; external shl32 name 'SHGetPathFromIDListW';
function SHGetPathFromIDList; external shl32 name 'SHGetPathFromIDListA';
function SHGetSpecialFolderLocation; external shl32 name 'SHGetSpecialFolderLocation';
function SHBrowseForFolderA; external shl32 name 'SHBrowseForFolderA';
function SHBrowseForFolderW; external shl32 name 'SHBrowseForFolderW';
function SHBrowseForFolder; external shl32 name 'SHBrowseForFolderA';
function GetOpenFileNameA; external cmd32 name 'GetOpenFileNameA';
function GetOpenFileNameW; external cmd32 name 'GetOpenFileNameW';
function GetOpenFileName; external cmd32 name 'GetOpenFileNameA';
function GetSaveFileNameA; external cmd32 name 'GetSaveFileNameA';
function GetSaveFileNameW; external cmd32 name 'GetSaveFileNameW';
function GetSaveFileName; external cmd32 name 'GetSaveFileNameA';

function DirBrowse(Title: String; Flg, Root: DWORD; var Fldr: String): Boolean;
var
  FLst: PItemIDList;
  BInfo: TBrowseInfoA;
  Nam, BP: array[0..MAX_PATH] of Char;

  function BCallBack(Wnd: HWND; Msg: UINT; lParam, lpData: LPARAM): Integer; stdcall;
  var
    WW: String;
    Buf: array[0..MAX_PATH - 1] of Char;
    R: TRect;
    H, W: Integer;
  begin
    Result := 0;
    case Msg of
      BFFM_INITIALIZED:
      begin
        SendMessage(Wnd, BFFM_SETSELECTION, 1, Integer(FDir));
        GetWindowRect(Wnd, R);
        W := R.Right - R.Left; H := R.Bottom - R.Top;
        GetWindowRect(GetDesktopWindow, R);
        MoveWindow(Wnd, (R.Right - W) div 2, (R.Bottom - H) div 2, W, H, True);
      end;
      BFFM_SELCHANGED:
      begin
        SHGetPathFromIDList(Pointer(lParam), Buf); WW := Buf;
        SendMessage(Wnd, BFFM_ENABLEOK, 0, Integer(WW <> ''));
      end;
    end;
  end;

begin
  FDir := PChar(Fldr);
  FillChar(BInfo, SizeOf(BInfo), 0);
  with BInfo do
  begin
    SHGetSpecialFolderLocation(0, Root, pidlRoot);
    pszDisplayName := @Nam;
    lpszTitle := PChar(Title);
    ulFlags := Flg;
    lpfn := @BCallBack;
  end;
  FLst := SHBrowseForFolder(BInfo);
  Result := FLst <> nil;
  if Result then
  begin
    SHGetPathFromIDList(FLst, BP);
    Fldr := BP; GlobalFreePtr(FLst);
  end else Fldr := '';
end;

function OSCallBack(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): UINT stdcall;
var
  R: TRect;
  H, W: Integer;
begin
  Result := 0;
  if Msg = WM_INITDIALOG then
  begin
    GetWindowRect(GetParent(Wnd), R);
    W := R.Right - R.Left; H := R.Bottom - R.Top;
    GetWindowRect(GetDesktopWindow, R);
    MoveWindow(GetParent(Wnd), (R.Right - W) div 2, (R.Bottom - H) div 2, W, H, True);
  end;
end;

function OpenFileDlg(Title, StartDir, Filter: String; var FName: String): Boolean;
begin
  FillChar(Ofn, SS, 0);
  with Ofn do
  begin
    lStructSize := SS;
    lpstrFilter := PChar(Filter);
    lpstrFile := Buffer;
    nMaxFile := MAX_PATH;
    lpstrTitle := PChar(Title);
    lpstrInitialDir := PChar(StartDir);
    lpfnHook := OSCallBack;
    Flags := OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or
             OFN_ENABLESIZING or OFN_ENABLEHOOK or OFN_EXPLORER;
  end;
  Result := GetOpenFileName(Ofn);
  if Result then FName := Buffer else FName := '';
end;

function SaveFileDlg(Title, StartDir, Filter: String; var FName: String): Boolean;
begin
  FillChar(Ofn, SS, 0);
  with Ofn do
  begin
    lStructSize := SS;
    lpstrFilter := PChar(Filter);
    lpstrDefExt := '';
    lpstrFile := Buffer;
    nMaxFile := MAX_PATH;
    lpstrTitle := PChar(Title);
    lpstrInitialDir := PChar(StartDir);
    lpfnHook := OSCallBack;
    Flags := OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or
             OFN_ENABLESIZING or OFN_OVERWRITEPROMPT or OFN_ENABLEHOOK or
             OFN_EXPLORER;
  end;
  Result := GetSaveFileName(Ofn);
  if Result then FName := Buffer else FName := '';
end;

initialization

  SS := SizeOf(TOpenFileName); if not NewOSVer then Dec(SS, 12);

end.

