{Part 0 of regression test for SPECFUND unit  (c) 2010-2013  W.Ehrhardt}

unit t_sfd0;

{$i STD.INC}

{$ifdef BIT16}
{$N+}
{$endif}

interface

var
  total_cnt, total_failed: longint;

procedure testrel(nbr, neps: integer; fx, y: double; var cnt, failed: integer);
  {-Check if relative error |(fx-y)/y| is <= neps*eps_d, absolute if y=0}

procedure testrele(nbr: integer; eps,fx, y: double; var cnt, failed: integer);
  {-Check if relative error |(fx-y)/y| is <= eps, absolute if y=0}

procedure testabs(nbr, neps: integer; fx, y: double; var cnt, failed: integer);
  {-Check if absolute error |(fx-y)| is <= neps*eps_d, equality if y=Inf}


implementation

uses
  DAMath;


{---------------------------------------------------------------------------}
procedure testrel(nbr, neps: integer; fx, y: double; var cnt, failed: integer);
  {-Check if relative error |(fx-y)/y| is <= neps*eps_d, absolute if y=0}
var
  err: double;
begin
  err := abs(fx-y);
  if (err<>0.0) and (y<>0.0) then err := abs(err/y);
  if err > neps*eps_d then begin
    inc(failed);
    writeln('Test ', nbr:2, ' failed, rel. error = ', err/eps_d:10:3, ' eps > ',neps, ' eps ');
    writeln('      f(x) =',fx:27, ' vs. ',y:27);
  end;
  inc(cnt);
end;


{---------------------------------------------------------------------------}
procedure testrele(nbr: integer; eps,fx, y: double; var cnt, failed: integer);
  {-Check if relative error |(fx-y)/y| is <= eps, absolute if y=0}
var
  err: double;
begin
  err := abs(fx-y);
  if (err<>0.0) and (y<>0.0) then err := abs(err/y);
  if err > eps then begin
    inc(failed);
    writeln('Test ', nbr:2, ' failed, rel. error = ', err:15, ' > ', eps:15);
    writeln('      f(x) =',fx:27, ' vs. ',y:27);
  end;
  inc(cnt);
end;


{---------------------------------------------------------------------------}
procedure testabs(nbr, neps: integer; fx, y: double; var cnt, failed: integer);
  {-Check if absolute error |(fx-y)| is <= neps*eps_d, equality if y=Inf}
var
  err: double;
begin
  if IsInfD(y) then begin
    if fx<>y then begin
      inc(failed);
      writeln('Test ', nbr:2, ' failed: f(x) = ', fx:1, ' <> ',y:1);
    end;
  end
  else begin
    err :=  abs(fx-y);
    if err > neps*eps_d then begin
      inc(failed);
      writeln('Test ', nbr:2, ' failed, abs. error ', err,' > ',neps, 'eps');
      writeln('      f(x) =',fx, ' vs. ',y);
    end;
  end;
  inc(cnt);
end;


end.
