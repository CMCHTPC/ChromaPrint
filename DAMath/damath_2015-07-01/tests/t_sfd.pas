{T_SFD - regression test program for SPECFUND unit  (c) 2010-2013  W.Ehrhardt}

program t_sfd;
{$i STD.INC}

{$ifdef AppCons}
  {$apptype console}
{$endif}

{$ifdef BIT16}
  {$ifndef DPMI}
   {$ifndef Windows}
     {$define USEOVR}
   {$endif}
  {$endif}
{$endif}

uses
  {$ifdef USEOVR}
    Overlay,
  {$endif}
  {$ifdef WINCRT}
    WinCRT,
  {$endif}
  t_sfd_m;

  {$ifdef USEOVR}
    {$o t_sfd1}
    {$o t_sfd1a}
    {$o t_sfd1b}
    {$o t_sfd2}
    {$o t_sfd2a}
    {$o t_sfd2b}
    {$o t_sfd3}
    {$o t_sfd3a}
    {$o t_sfd3b}
    {$o t_sfd3c}
    {$o t_sfd4}
    {$o t_sfd4a}
    {$o t_sfd5}
    {$o t_sfd5a}
    {$o t_sfd6}
    {$o t_sfd6a}
    {$o t_sfd7}
    {$o t_sfd8}
    {$o t_sfd8a}
    {$o t_sfd9}
    {$o t_sfd9a}
  {$endif}
begin
  {$ifdef USEOVR}
    OvrInit('T_SFD.OVR');
    if OvrResult <> ovrOk then begin
      case OvrResult of
        ovrError: Writeln('Program has no overlays.');
        ovrNotFound: Writeln('Overlay file not found.');
      end;
      Halt(1);
    end;
  {$endif}
  test_sfd_main;
end.
