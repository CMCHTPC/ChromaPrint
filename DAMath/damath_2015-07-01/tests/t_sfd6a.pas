{Part 6a of regression test for SPECFUND unit  (c) 2011-2013  W.Ehrhardt}

unit t_sfd6a;

{$i STD.INC}

{$ifdef BIT16}
  {$N+}
  {$ifndef Windows}
    {$O+}
  {$endif}
{$endif}

interface

procedure test_airy_ai;
procedure test_airy_bi;
procedure test_airy_aip;
procedure test_airy_bip;
procedure test_airy_ais;
procedure test_airy_bis;
procedure test_airy_scorer;

procedure test_sph_bess_jn;
procedure test_sph_bess_yn;
procedure test_sph_bessel_in;
procedure test_sph_bessel_ine;
procedure test_sph_bessel_kn;
procedure test_sph_bessel_kne;

procedure test_ber;
procedure test_bei;
procedure test_ker;
procedure test_kei;

procedure test_struve_h0;
procedure test_struve_h1;
procedure test_struve_h;
procedure test_struve_l0;
procedure test_struve_l1;
procedure test_struve_l;

implementation

uses
  damath, specfund, t_sfd0;

{---------------------------------------------------------------------------}
procedure test_airy_ai;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 6;
  NE2 = 32;
  NE3 = 64;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_ai');


  y := airy_ai(50);
  f := 0.45849417240748284783e-103;
  testrel(1, NE3, y, f, cnt,failed);

  y := airy_ai(5);
  f := 0.10834442813607441735e-3;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_ai(1);
  f := 0.13529241631288141552;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_ai(0.5);
  f := 0.23169360648083348977;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_ai(0);
  f := 0.35502805388781723926;
  testrel(5, NE, y, f, cnt,failed);

  y := airy_ai(-0.25);
  f := 0.41872461427545292423;
  testrel(6, NE, y, f, cnt,failed);

  y := airy_ai(-0.5);
  f := 0.47572809161053958880;
  testrel(7, NE, y, f, cnt,failed);

  y := airy_ai(-1.0);
  f := 0.53556088329235211880;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_ai(-2.0);
  f := 0.22740742820168557599;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_ai(-5);
  f := 0.35076100902411431979;
  testrel(10, NE, y, f, cnt,failed);

  y := airy_ai(-20);
  f := -0.17640612707798468959;
  testrel(11, NE2, y, f, cnt,failed);

  y := airy_ai(-100);
  f := 0.17675339323955287809;
  testrel(12, NE3, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_bi;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 6;
  NE2 = 32;
  NE3 = 64;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_bi');

  y := airy_bi(50);
  f := 0.4909099699444219329e102;
  testrel(1, NE3, y, f, cnt,failed);

  y := airy_bi(5);
  f := 657.7920441711711824;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_bi(1);
  f := 1.207423594952871259;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_bi(0.5);
  f := 0.8542770431031554933;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_bi(0);
  f := 0.6149266274460007352;
  testrel(5, NE, y, f, cnt,failed);

  y := airy_bi(-0.25);
  f := 0.5013998734692333890;
  testrel(6, NE, y, f, cnt,failed);

  y := airy_bi(-0.5);
  f := 0.3803526597510538502;
  testrel(7, NE, y, f, cnt,failed);

  y := airy_bi(-1.0);
  f := 0.1039973894969446119;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_bi(-2.0);
  f := -0.4123025879563984881;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_bi(-5);
  f := -0.1383691349016005769;
  testrel(10, NE2, y, f, cnt,failed);

  y := airy_bi(-20);
  f := -0.2001393093226513493;
  testrel(11, NE2, y, f, cnt,failed);

  y := airy_bi(-100);
  f := 0.2427388768016013161e-1;
  testrel(12, 2000, y, f, cnt,failed);  {!!!!}

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_ais;
var
  y,f: double;
  cnt, failed: integer;
const
  NE = 4;
  NE1 = 10;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_ais');

  y := airy_ais(1e-20);
  f := 0.3550280538878172393;
  testrel(1, NE, y, f, cnt,failed);

  y := airy_ais(0.125);
  f := 0.3324375951095047298;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_ais(1);
  f := 0.2635136447491400686;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_ais(1.125);
  f := 0.2579914489991170531;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_ais(1.5);
  f := 0.2441848976714084334;
  testrel(5, NE, y, f, cnt,failed);

  y := airy_ais(1.9375);
  f := 0.2317137238870651524;
  testrel(6, NE1, y, f, cnt,failed);

  y := airy_ais(2);
  f := 0.2301649186525116059;
  testrel(7, NE1, y, f, cnt,failed);

  y := airy_ais(3);
  f := 0.2105720427859769851;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_ais(4);
  f := 0.1970948026430665127;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_ais(10);
  f := 0.1581236668543461503;
  testrel(10, NE, y, f, cnt,failed);

  y := airy_ais(100);
  f := 0.8919692093633041318e-1;
  testrel(11, NE, y, f, cnt,failed);

  y := airy_ais(500);
  f := 0.05965522950749524825;
  testrel(12, NE, y, f, cnt,failed);

  y := airy_ais(1000);
  f := 0.50164170749970862190e-1;
  testrel(13, NE, y, f, cnt,failed);

  y := airy_ais(17179869184.0);
  f := 0.7791841414090481631e-3;
  testrel(14, NE, y, f, cnt,failed);

  y := airy_ais(2e12);
  f := 0.2372124991643971727e-3;
  testrel(15, NE, y, f, cnt,failed);

  y := airy_ais(3e12);
  f := 0.2143456895262479282e-3;
  testrel(16, NE, y, f, cnt,failed);

  y := airy_ais(maxdouble);
  f := 0.2436218170273481498e-77;
  testrel(17, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_bis;
var
  y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE1 = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_bis');

  y := airy_bis(1e-20);
  f := 0.6149266274460007352;
  testrel(1, NE, y, f, cnt,failed);

  y := airy_bis(0.125);
  f := 0.6516858507482041529;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_bis(1);
  f := 0.6199119435726784851;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_bis(2);
  f := 0.5004372543040949650;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_bis(2.125);
  f := 0.4902398661293438879;
  testrel(5, NE1, y, f, cnt,failed);

  y := airy_bis(4);
  f := 0.4048094678892980736;
  testrel(6, NE, y, f, cnt,failed);

  y := airy_bis(9.0);
  f := 0.3270313582774302788;
  testrel(7, NE, y, f, cnt,failed);

  y := airy_bis(9.5);
  f := 0.3225380750221299793;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_bis(100);
  f := 0.1784310111708354151;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_bis(500);
  f := 0.1193126822548645875;
  testrel(10, NE, y, f, cnt,failed);

  y := airy_bis(1000);
  f := 0.1003290024731051856;
  testrel(11, NE, y, f, cnt,failed);

  y := airy_bis(17179869184.0);
  f := 0.1558368282818096470e-2;
  testrel(12, NE, y, f, cnt,failed);

  y := airy_bis(2e12);
  f := 0.4744249983287943454e-3;
  testrel(13, NE, y, f, cnt,failed);

  y := airy_bis(3e12);
  f := 0.4286913790524958564e-3;
  testrel(14, NE, y, f, cnt,failed);

  y := airy_bis(maxdouble);
  f := 0.4872436340546962995e-77;
  testrel(15, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_aip;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 8;
  NE2 = 32;
  NE3 = 64;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_aip');


  y := airy_aip(50);
  f := -0.3244331819828799296e-102;
  testrel(1, NE3, y, f, cnt,failed);

  y := airy_aip(5);
  f := -0.2474138908684624760e-3;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_aip(1);
  f := -0.1591474412967932128;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_aip(0.5);
  f := -0.2249105326646838931;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_aip(0);
  f := -0.2588194037928067984;
  testrel(5, NE, y, f, cnt,failed);

  y := airy_aip(-0.25);
  f := -0.2463891899201759730;
  testrel(6, NE, y, f, cnt,failed);

  y := airy_aip(-0.5);
  f := -0.2040816703395473861;
  testrel(7, NE, y, f, cnt,failed);

  y := airy_aip(-1.0);
  f := -0.1016056711664520939e-1;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_aip(-2.0);
  f := 0.6182590207416910414;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_aip(-5);
  f := 0.3271928185544431368;
  testrel(10, NE, y, f, cnt,failed);

  y := airy_aip(-20);
  f := 0.8928628567364712384;
  testrel(11, NE2, y, f, cnt,failed);

  y := airy_aip(-100);
  f := -0.2422970316605838054;
  testrel(12, 1500, y, f, cnt,failed);   {!!!!}


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_bip;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 8;
  NE2 = 32;
  NE3 = 64;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_bip');


  y := airy_bip(50);
  f := 0.3468798779545976724e103;
  testrel(1, NE3, y, f, cnt,failed);

  y := airy_bip(5);
  f := 1435.819080217982519;
  testrel(2, NE, y, f, cnt,failed);

  y := airy_bip(1);
  f := 0.9324359333927756330;
  testrel(3, NE, y, f, cnt,failed);

  y := airy_bip(0.5);
  f := 0.5445725641405923018;
  testrel(4, NE, y, f, cnt,failed);

  y := airy_bip(0);
  f := 0.4482883573538263579;
  testrel(5, NE, y, f, cnt,failed);

  y := airy_bip(-0.25);
  f := 0.46515148833715370327;
  testrel(6, NE, y, f, cnt,failed);

  y := airy_bip(-0.5);
  f := 0.50593371362384716657;
  testrel(7, NE, y, f, cnt,failed);

  y := airy_bip(-1.0);
  f := 0.59237562642279235082;
  testrel(8, NE, y, f, cnt,failed);

  y := airy_bip(-2.0);
  f := 0.27879516692116952269;
  testrel(9, NE, y, f, cnt,failed);

  y := airy_bip(-5);
  f := 0.77841177300189924609;
  testrel(10, NE, y, f, cnt,failed);

  y := airy_bip(-20);
  f := -0.79142903383953647936;
  testrel(11, NE3, y, f, cnt,failed);

  y := airy_bip(-100);
  f := 1.7675948932340609324;
  testrel(12, NE2, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_airy_scorer;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 6;
  NE1 = 50;
  NE2 = 200;
{$ifdef BIT64}
  NE0 = 15;
{$else}
  {$ifdef FPC}
    NE0 = 15;   {needed for SSE2}
  {$else}
    NE0 = NE;
  {$endif}
{$endif}
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','airy_gi/hi');

  {MISCFUN test values}
  f := 0.20468308070040542435;
  y := airy_gi(-0.001953125);
  testrel(1, NE, y, f, cnt,failed);

  f := 0.18374662832557904078;
  y := airy_gi(-0.125);
  testrel(2, NE, y, f, cnt,failed);

  f :=-0.11667221729601528265;
  y := airy_gi(-1);
  testrel(3, NE, y, f, cnt,failed);

  f := 0.31466934902729557596;
  y := airy_gi(-4);
  testrel(4, NE, y, f, cnt,failed);

  f :=-0.37089040722426257729;
  y := airy_gi(-8);
  testrel(5, NE, y, f, cnt,failed);

  f := -0.25293059772424019694;
  y := airy_gi(-8.25);
  testrel(6, NE, y, f, cnt,failed);

  f := 0.28967410658692701936;
  y := airy_gi(-9);
  testrel(7, NE, y, f, cnt,failed);

  f :=-0.34644836492634090590;
  y := airy_gi(-10);
  testrel(8, NE, y, f, cnt,failed);

  f := 0.28076035913873049496;
  y := airy_gi(-11);
  testrel(9, NE, y, f, cnt,failed);

  f := 0.21814994508094865815;
  y := airy_gi(-13);
  testrel(10, NE0, y, f, cnt,failed);

  f := 0.20526679000810503329;
  y := airy_gi(0.001953125);
  testrel(11, NE, y, f, cnt,failed);

  f := 0.22123695363784773258;
  y := airy_gi(0.125);
  testrel(12, NE, y, f, cnt,failed);

  f := 0.23521843981043793760;
  y := airy_gi(1);
  testrel(13, NE, y, f, cnt,failed);

  f := 0.82834303363768729338e-1;
  y := airy_gi(4.0);
  testrel(15, NE, y, f, cnt,failed);

  y := airy_gi(7.0);
  f := 0.45757385490989281893e-1;
  testrel(15, NE, y, f, cnt,failed);

  y := airy_gi(7.25);
  f := 0.44150012014605159922e-1;
  testrel(16, NE, y, f, cnt,failed);

  y := airy_gi(8.0);
  f := 0.39951133719508907541e-1;
  testrel(17, NE, y, f, cnt,failed);

  y := airy_gi(9.0);
  f := 0.35467706833949671483e-1;
  testrel(18, NE, y, f, cnt,failed);

  y := airy_gi(10.0);
  f := 0.31896005100679587981e-1;
  testrel(19, NE, y, f, cnt,failed);

  y := airy_gi(12.0);
  f := 0.26556892713512410405e-1;
  testrel(20, NE, y, f, cnt,failed);

  f := 0.40936798278458884024;
  y := airy_hi(-0.001953125);
  testrel(21, NE, y, f, cnt,failed);

  f := 0.37495291608048868619;
  y := airy_hi(-0.125);
  testrel(22, NE, y, f, cnt,failed);

  f := 0.22066960679295989454;
  y := airy_hi(-1);
  testrel(23, NE, y, f, cnt,failed);

  f := 0.77565356679703713590e-1;
  y := airy_hi(-4);
  testrel(24, NE, y, f, cnt,failed);

  f := 0.39638826473124717315e-1;
  y := airy_hi(-8);
  testrel(25, NE, y, f, cnt,failed);

  f := 0.38450072575004151871e-1;
  y := airy_hi(-8.25);
  testrel(26, NE, y, f, cnt,failed);

  f := 0.35273216868317898556e-1;
  y := airy_hi(-9);
  testrel(27, NE, y, f, cnt,failed);

  f := 0.31768535282502272742e-1;
  y := airy_hi(-10);
  testrel(28, NE, y, f, cnt,failed);

  f := 0.28894408288051391369e-1;
  y := airy_hi(-11);
  testrel(29, NE, y, f, cnt,failed);

  f := 0.24463284011678541180e-1;
  y := airy_hi(-13);
  testrel(30, NE, y, f, cnt,failed);

  f := 0.41053540139998941517;
  y := airy_hi(0.001953125);
  testrel(31, NE, y, f, cnt,failed);

  f := 0.44993502381204990817;
  y := airy_hi(0.125);
  testrel(32, NE, y, f, cnt,failed);

  f := 0.97220515514243332184;
  y := airy_hi(1);
  testrel(33, NE, y, f, cnt,failed);

  f := 0.83764237105104371193e2;
  y := airy_hi(4);
  testrel(34, NE, y, f, cnt,failed);

  f := 0.80327744952044756016e5;
  y := airy_hi(7);
  testrel(35, NE, y, f, cnt,failed);

  f := 0.15514138847749108298e6;
  y := airy_hi(7.25);
  testrel(36, NE, y, f, cnt,failed);

  f := 0.11995859641733262114e7;
  y := airy_hi(8);
  testrel(37, NE0, y, f, cnt,failed);

  y := airy_hi(9.0);
  f := 0.21472868855967642259e8;
  testrel(38, NE, y, f, cnt,failed);

  y := airy_hi(10.0);
  f := 0.45564115351632913590e9;
  testrel(39, NE0, y, f, cnt,failed);

  y := airy_hi(12.0);
  f := 0.32980722582904761929e12;
  testrel(40, NE0, y, f, cnt,failed);

  {---------------------------------------}
  f := 0.392203077804138178e36;
  y := airy_hi(25);
  testrel(41, NE1, y, f, cnt,failed);

  f := 0.6041223996670201399e289;
  y := airy_hi(100);
  testrel(42, NE2, y, f, cnt,failed);

  f := 0.3183098855471709119e-3;
  y := airy_hi(-1000);
  testrel(43, NE, y, f, cnt,failed);

  f := 0.3183098861831540518e-4;
  y := airy_hi(-10000);
  testrel(44, NE, y, f, cnt,failed);

  f := 2.122065907891937809e-7; {Alpha}
  y := airy_hi(-1.5e6);
  testrel(45, NE, y, f, cnt,failed);

  f := 1.061032953945968905e-7; {Alpha}
  y := airy_hi(-3e6);
  testrel(46, NE, y, f, cnt,failed);

  f := 3.183098861837906715e-8; {Alpha}
  y := airy_hi(-1e7);
  testrel(47, NE, y, f, cnt,failed);

  y := airy_gi(20.0);
  f := 0.1591948320056103765e-1;
  testrel(48, NE, y, f, cnt,failed);

  y := airy_gi(50.0);
  f := 0.6366299599144166116e-2;
  testrel(49, NE, y, f, cnt,failed);

  y := airy_gi(100.0);
  f := 0.3183105228162961477e-2;
  testrel(50, NE, y, f, cnt,failed);

  f := -0.1435162480096224794;
  y := airy_gi(-50);
  testrel(51, NE1, y, f, cnt,failed);

  f := -0.8358288400262780392e-1;
  y := airy_gi(-1000);
  testrele(52, 2e-12, y, f, cnt,failed);      {!!!!!!!!!!!!!}

  f := -0.4953937439675591109e-1;
  y := airy_gi(-10000);
  testrele(53, 3e-11, y, f, cnt,failed);      {!!!!!!!!!!!!!}


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


{---------------------------------------------------------------------------}
procedure test_sph_bess_jn;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 16;
  NE3 = 256;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_jn');

  {Test values from GSL, some corrected with Maple}
  y := sph_bessel_jn(0,-10.0);
  f := -0.05440211108893698134;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,0.001);
  f := 0.9999998333333416667;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,1.0);
  f := 0.84147098480789650670;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,10.0);
  f := -0.05440211108893698134;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,100.0);
  f := -0.005063656411097587937;
  testrel(5, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,1048576.0);
  f := 3.1518281938718287624e-07;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,-10.0);
  f := -0.07846694179875154709;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,0.01);
  f := 0.003333300000119047399;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,1.0);
  f := 0.30116867893975678925;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,10.0);
  f := 0.07846694179875154709;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,100.0);
  f := -0.008673825286987815220;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,1048576.0);
  f := -9.000855242905546158e-07;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,-10.0);
  f := 0.07794219362856244547;
  testrel(13, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,0.01);
  f := 6.666619047751322551e-06;
  testrel(14, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,1.0);
  f := 0.062035052011373861103;
  testrel(15, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,10.0);
  f := 0.077942193628562445467;
  testrel(16, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,100.0);
  f := 0.48034416524879534799e-2;
  testrel(17, 2*NE, y, f, cnt,failed);   {!!!64-bit}

  y := sph_bessel_jn(2,1048576.0);
  f := -3.1518539455252413111e-07;
  testrel(18, NE, y, f, cnt,failed);

  y := sph_bessel_jn(0,0.0);
  f := 1.0;
  testrel(19, NE, y, f, cnt,failed);

  y := sph_bessel_jn(1,10.0);
  f := 0.07846694179875154709000;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_jn(5,1.0);
  f := 0.00009256115861125816357;
  testrel(21, NE, y, f, cnt,failed);

  y := sph_bessel_jn(10,10.0);
  f := 0.06460515449256426427;
  testrel(22, NE, y, f, cnt,failed);

  y := sph_bessel_jn(100,100.0);
  f := 0.010880477011438336540;
  testrel(23, 2*NE2, y, f, cnt,failed);  {!!! *2 for 32 bit}

  y := sph_bessel_jn(2,900.0);
  f := -0.0011089115568832940086;
  testrel(24, NE, y, f, cnt,failed);

  y := sph_bessel_jn(2,15000.0);
  f := -0.59555920330757505537e-4;
  testrel(25, NE, y, f, cnt,failed);

  y := sph_bessel_jn(100,1000.0);
  f := -0.00025326311230945818285;
  testrel(26, NE3, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_sph_bess_yn;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 8;
  NE3 = 20;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_yn');

  {Test values from GSL, some corrected with Maple}
  y := sph_bessel_yn(0,0.001);
  f := -999.99950000004166670;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_yn(0,1.0);
  f := -0.5403023058681397174;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_yn(0,10.0);
  f := 0.08390715290764524523;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_yn(0,100.0);
  f := -0.008623188722876839341;
  testrel(4, NE2, y, f, cnt,failed);

  y := sph_bessel_yn(0,65536.0);
  f := 0.000011014324202158573930;
  testrel(5, NE, y, f, cnt,failed);

  y := sph_bessel_yn(0,4294967296.0);
  f := 2.0649445131370357007e-10;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_yn(1,0.01);
  f := -10000.499987500069444;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_yn(1,1.0);
  f := -1.3817732906760362241;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_yn(1,10.0);
  f := 0.06279282637970150586;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_yn(1,100.0);
  f := 0.49774245238688195431e-2;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_yn(1,4294967296.0);
  f := 1.0756463271573404688e-10;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_yn(2,0.01);
  f := -3.0000500012499791668e+06;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_yn(2,1.0);
  f := -3.605017566159968955;
  testrel(13, NE, y, f, cnt,failed);

  y := sph_bessel_yn(2,10.0);
  f := -0.06506930499373479347;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_yn(2,100.0);
  f := 0.008772511458592903927;
  testrel(15, NE, y, f, cnt,failed);

  y := sph_bessel_yn(2,4294967296.0);
  f := -2.0649445123857054207e-10;
  testrel(16, NE, y, f, cnt,failed);

  y := sph_bessel_yn(0,0.01);
  f := -99.995000041666527779;
  testrel(17, NE, y, f, cnt,failed);

  y := sph_bessel_yn(5,1.0);
  f := -999.44034339223640949;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_yn(10,0.01);
  f := -0.65473079797378378406e31;
  testrel(21, NE3, y, f, cnt,failed);

  y := sph_bessel_yn(10,10.0);
  f := -0.172453672088057849;
  testrel(22, NE, y, f, cnt,failed);

  y := sph_bessel_yn(100,1.0);
  f := -0.66830794632586775138e187;
  testrel(23, NE, y, f, cnt,failed);

  y := sph_bessel_yn(100,100.0);
  f := -0.22983850491562281089e-1;
  testrel(24, 3*NE2, y, f, cnt,failed);   {!!!! 3* for 32bit}

  y := sph_bessel_yn(2000,1048576.0);
  f := 5.9545201447146155e-07;
  testrel(25, NE2, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;



{---------------------------------------------------------------------------}
procedure test_sph_bessel_in;
var
  f,y: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_in');

  y := sph_bessel_in(0,0);
  f := 1.0;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_in(1,0);
  f := 0.0;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_in(2,0);
  f := 0.0;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,0.1);
  f := 1.001667500198440258;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_in(1,0.1);
  f := 0.3336667857363340751e-1;
  testrel(5, NE, y, f, cnt,failed);

  y := sph_bessel_in(2,0.1);
  f := 0.6671429894380330319e-3;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,2);
  f := 1.813430203923509384;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_in(1,2);
  f := 0.974382743580061038;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_in(2,2);
  f := 0.3518560885534178270;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,100);
  f := 0.1344058570908067724e42;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_in(1,100);
  f := 0.1330617985198987047e42;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_in(2,100);
  f := 0.1304140031352098113e42;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_in(4,0.001);
  f := 0.1058201106301107226e-14;
  testrel(13, NE, y, f, cnt,failed);

  y := sph_bessel_in(4,0.1);
  {f:= 0.1058682151192429726e-6;}
  f := 0.1058682151192429961e-6;     {computed with double(0.1) = 0.10000000000000000555}
  testrel(14, NE, y, f, cnt,failed);

  y := sph_bessel_in(5,2);
  f := 0.3584848301270655334e-2;
  testrel(15, NE, y, f, cnt,failed);

  y := sph_bessel_in(5,100);
  f := 0.1156010470006571019e42;
  testrel(16, NE, y, f, cnt,failed);

  y := sph_bessel_in(100,100);
  f := 0.3735988741596951155e21;
  testrel(17, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,1e-5);
  f := 1.000000000016666667;
  testrel(18, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,700);
  f := 0.7244514676678603639e301;
  testrel(19, NE, y, f, cnt,failed);

  y := sph_bessel_in(5,700);
  f := 0.7090818630104572109e301;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_in(0,-8);
  f := 186.3098532236937733;
  testrel(21, NE, y, f, cnt,failed);

  y := sph_bessel_in(1,-8);
  f := -163.0211635035605394;
  testrel(22, NE, y, f, cnt,failed);

  y := sph_bessel_in(2,-8);
  f := 125.1769169098585710;
  testrel(23, NE, y, f, cnt,failed);

  y := sph_bessel_in(3,-8);
  f := -84.78559043489893256;
  testrel(24, NE, y, f, cnt,failed);

  y := sph_bessel_in(-1,8);
  f := 186.3098951565222611;
  testrel(25, NE, y, f, cnt,failed);

  y := sph_bessel_in(-2,8);
  f := 163.0211163291284906;
  testrel(26, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


{---------------------------------------------------------------------------}
procedure test_sph_bessel_ine;
var
  f,y: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_ine');

  y := sph_bessel_ine(0,0);
  f := 1.0;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_ine(1,0);
  f := 0.0;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_ine(2,0);
  f := 0.0;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,0.1);
  f := 0.9063462346100907067;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_ine(1,0.1);
  f := 0.3019141928900222685e-1;
  testrel(5, NE, y, f, cnt,failed);

  y := sph_bessel_ine(2,0.1);
  f := 0.6036559400239012567e-3;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,2);
  f := 0.2454210902778164549;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_ine(1,2);
  f := 0.1318683645832753176;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_ine(2,2);
  f := 0.4761854340290347851e-1;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,100);
  f := 0.005;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_ine(1,100);
  f := 0.00495;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_ine(2,100);
  f := 0.48515e-2;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_ine(4,0.001);
  f := 0.1057143434119036501e-14;
  testrel(13, NE, y, f, cnt,failed);

  y := sph_bessel_ine(4,0.1);
  f := 0.957935224205713493e-7;
  testrel(14, NE, y, f, cnt,failed);

  y := sph_bessel_ine(5,2);
  f := 0.4851564602127540059e-3;
  testrel(15, NE, y, f, cnt,failed);

  y := sph_bessel_ine(5,100);
  f := 0.43004467775e-2;
  testrel(16, NE, y, f, cnt,failed);

  y := sph_bessel_ine(100,100);
  f := 0.1389816196429913279e-22;
  testrel(17, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,1e-5);
  f := 0.9999900000666663333;
  testrel(18, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,20000);
  f := 0.25e-4;
  testrel(19, NE, y, f, cnt,failed);

  y := sph_bessel_ine(5,20000);
  f := 0.2498125656118764765e-4;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_ine(0,-8);
  f := 0.6249999296655158005e-1;
  testrel(21, NE, y, f, cnt,failed);

  y := sph_bessel_ine(1,-8);
  f := -0.5468750791262947245e-1;
  testrel(22, NE, y, f, cnt,failed);

  y := sph_bessel_ine(2,-8);
  f := 0.4199217749931552788e-1;
  testrel(23, NE, y, f, cnt,failed);

  y := sph_bessel_ine(3,-8);
  f := -0.2844239697555726752e-1;
  testrel(24, NE, y, f, cnt,failed);

  y := sph_bessel_ine(-1,8);
  f := 0.6250000703344841995e-1;
  testrel(25, NE, y, f, cnt,failed);

  y := sph_bessel_ine(-2,8);
        {1234567890123456789}
  f := 0.5468749208737052755e-1;
  testrel(26, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_sph_bessel_kne;
var
  f,y: double;
  cnt, failed: integer;
const
  NE  = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_kne');

  {GSL arguments, recalculated with Maple}
  y := sph_bessel_kne(0,0.1);
  f := 15.70796326794896619;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_kne(0,2);
  f := 0.7853981633974483096;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_kne(0,100);
  f := 0.1570796326794896619e-1;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_kne(1,0.1);
  f := 172.7875959474386281;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_kne(1,2);
  f := 1.178097245096172464;
  testrel(5, 2*NE, y, f, cnt,failed);   {!!!64-bit}

  y := sph_bessel_kne(1,100);
  f := 0.1586504290062845585e-1;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_kne(2,0.1);
  f := 5199.335841691107810;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_kne(2,2);
  f := 2.552544031041707006;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_kne(2,100);
  f := 0.1618391455496781987e-1;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_kne(4,1/256);
  f := 0.1820559981696195444e15;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_kne(4,1/8);
  f := 0.6117321781440659753e7;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_kne(5,2);
  f := 138.1073582949200512;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_kne(100,100);
  f := 0.3985930768060258219e19;
  testrel(13, NE, y, f, cnt,failed);

  y := sph_bessel_kne(25,ldexpd(1,-34));
  f := 0.1183900887300384e299;
  testrel(14, NE, y, f, cnt,failed);

  y := sph_bessel_kne(-25,ldexpd(1,-34));
  f := 0.1406369416390490e287;
  testrel(15, 2*NE, y, f, cnt,failed);      {!!!vpc}

  y := sph_bessel_kne(100,2);
  f := 0.3021343835088123453e158;
  testrel(16, 2*NE, y, f, cnt,failed);  {!!!64-bit}

  y := sph_bessel_kne(100,10);
  f := 0.1794607980003062273e91;
  testrel(17, 2*NE, y, f, cnt,failed);   {!!!64-bit}

  y := sph_bessel_kne(100,1000);
  f := 0.243431420384866238982038265809;
  testrel(18, NE, y, f, cnt,failed);

  y := sph_bessel_kne(-10,100);
  f := 0.2457213721229154669e-1;
  testrel(19, NE, y, f, cnt,failed);

  y := sph_bessel_kne(-21,100);
  f := 0.1260553345815578451;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_kne(-4,1/8);
  f := 109189.1942681668538;
  testrel(21, NE, y, f, cnt,failed);

  y := sph_bessel_kne(-5,1/8);
  f := 6117321.781440659753;
  testrel(22, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_sph_bessel_kn;
var
  f,y: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sph_bessel_kn');

  y := sph_bessel_kn(0,0.1);
  f := 14.21315292597463638;
  testrel(1, NE, y, f, cnt,failed);

  y := sph_bessel_kn(0,2);
  f := 0.1062920828969090821;
  testrel(2, NE, y, f, cnt,failed);

  y := sph_bessel_kn(0,100);
  f := 0.5843481678531469047e-45;
  testrel(3, NE, y, f, cnt,failed);

  y := sph_bessel_kn(1,0.1);
  f := 156.3446821857210002;
  testrel(4, NE, y, f, cnt,failed);

  y := sph_bessel_kn(1,2);
  f := 0.1594381243453636232;
  testrel(5, NE, y, f, cnt,failed);

  y := sph_bessel_kn(1,100);
  f := 0.5901916495316783737e-45;
  testrel(6, NE, y, f, cnt,failed);

  y := sph_bessel_kn(2,0.1);
  f := 4704.553618497604642;
  testrel(7, NE, y, f, cnt,failed);

  y := sph_bessel_kn(2,2);
  f := 0.3454492694149545169;
  testrel(8, NE, y, f, cnt,failed);

  y := sph_bessel_kn(2,100);
  f := 0.6020539173390972559e-45;
  testrel(9, NE, y, f, cnt,failed);

  y := sph_bessel_kn(4,1/256);
  f := 0.1813462290970072313e15;
  testrel(10, NE, y, f, cnt,failed);

  y := sph_bessel_kn(4,1/8);
  f := 0.5398517524234661520e7;
  testrel(11, NE, y, f, cnt,failed);

  y := sph_bessel_kn(5,2);
  f := 18.69079845190335641;
  testrel(12, NE, y, f, cnt,failed);

  y := sph_bessel_kn(100,100);
  f := 0.1482796529234324543e-24;
  testrel(13, 2*NE, y, f, cnt,failed);     {!!!64-bit}

  y := sph_bessel_kn(25,ldexpd(1,-34));
  f := 0.1183900887231472874e299;
  testrel(14, NE, y, f, cnt,failed);

  y := sph_bessel_kn(-25,ldexpd(1,-34));
  f := 0.1406369416308628332e287;
  testrel(15, NE, y, f, cnt,failed);

  y := sph_bessel_kn(100,2);
  f := 0.4088944236768448154e157;
  testrel(16, 2*NE, y, f, cnt,failed);   {!!!64-bit}

  y := sph_bessel_kn(100,10);
  f := 0.8147507624333384617e86;
  testrel(17, NE, y, f, cnt,failed);

  y := sph_bessel_kn(100,700);
  f := 0.2954256072518645516e-303;
  testrel(18, NE, y, f, cnt,failed);

  y := sph_bessel_kn(-10,100);
  f := 0.9141021732293337889e-45;
  testrel(19, NE, y, f, cnt,failed);

  y := sph_bessel_kn(-21,100);
  f := 0.4689354218261218366e-44;
  testrel(20, NE, y, f, cnt,failed);

  y := sph_bessel_kn(-4,1/8);
  f := 96359.12573736490671;
  testrel(21, NE, y, f, cnt,failed);

  y := sph_bessel_kn(-5,1/8);
  f := 5398517.524234661520;
  testrel(22, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;





{---------------------------------------------------------------------------}
procedure test_ber;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 32;
  NE3 = 100;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','kelvin_ber');


  y := kelvin_ber(0);
  f := 1.0;
  testrel(1, NE, y, f, cnt,failed);

  y := kelvin_ber(1e-5);
  f := 1.0;
  testrel(2, NE, y, f, cnt,failed);

  y := kelvin_ber(0.03125);
  f := 0.9999999850988388123;
  testrel(3, NE, y, f, cnt,failed);

  y := kelvin_ber(0.5);
  f := 0.9990234639908382556;
  testrel(4, NE, y, f, cnt,failed);

  y := kelvin_ber(-1);
  f := 0.9843817812130868840;
  testrel(5, NE, y, f, cnt,failed);

  y := kelvin_ber(2.75);
  f := 0.1284781977714383538;
  testrel(6, NE, y, f, cnt,failed);

  y := kelvin_ber(-3.0);
  f := -0.2213802495986938889;
  testrel(7, NE, y, f, cnt,failed);

  y := kelvin_ber(10);
  f := 138.8404659416326472;
  testrel(8, NE, y, f, cnt,failed);

  y := kelvin_ber(19.5);
  f := 59956.93311223375741;
  testrel(9, NE2, y, f, cnt,failed);

  y := kelvin_ber(-20);
  f := 47489.37026506176015;
  testrel(10, NE2, y, f, cnt,failed);

  y := kelvin_ber(100);
  f := 0.7368706878094957313e29;
  testrel(11, NE3, y, f, cnt,failed);

  y := kelvin_ber(1000);
  f := -0.1545186630003373009e306;
  testrel(12, 500, y, f, cnt,failed);    {!!!}


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_bei;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 32;
  NE3 = 100;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','kelvin_bei');


  y := kelvin_bei(0);
  f := 0.0;
  testrel(1, NE, y, f, cnt,failed);

  y := kelvin_bei(1e-5);
  f := 0.25e-10;
  testrel(2, NE, y, f, cnt,failed);

  y := kelvin_bei(0.03125);
  f := 0.2441406245957801326e-3;
  testrel(3, NE, y, f, cnt,failed);

  y := kelvin_bei(0.5);
  f := 0.6249321838219945865e-1;
  testrel(4, NE, y, f, cnt,failed);

  y := kelvin_bei(-1);
  f := 0.2495660400366597214;
  testrel(5, NE, y, f, cnt,failed);

  y := kelvin_bei(2.75);
  f := 1.704577752311522268;
  testrel(6, NE, y, f, cnt,failed);

  y := kelvin_bei(-3.0);
  f := 1.937586785266042767;
  testrel(7, NE, y, f, cnt,failed);

  y := kelvin_bei(10);
  f := 56.37045855390663823;
  testrel(8, NE2, y, f, cnt,failed);

  y := kelvin_bei(19.5);
  f := 64879.42349727954849;
  testrel(9, NE2, y, f, cnt,failed);

  y := kelvin_bei(-20);
  f := 114775.1973600662216;
  testrel(10, NE2, y, f, cnt,failed);

  y := kelvin_bei(100);
  f := 0.1906911409362379763e30;
  testrel(11, NE3, y, f, cnt,failed);

  y := kelvin_bei(1000);
  f := 0.2246152918745784947e305;
  testrel(12, 4000, y, f, cnt,failed);    {!!!!}

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ker;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 32;
  NE3 = 100;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','kelvin_ker');


  y := kelvin_ker(1e-10);
  f := 23.14178244559886929;
  testrel(1, NE, y, f, cnt,failed);

  y := kelvin_ker(1e-5);
  f := 11.62885698064827582;
  testrel(2, NE, y, f, cnt,failed);

  y := kelvin_ker(0.03125);
  f := 3.581859090333561926;
  testrel(3, NE, y, f, cnt,failed);

  y := kelvin_ker(0.5);
  f := 0.8559058721186342137;
  testrel(4, NE, y, f, cnt,failed);

  y := kelvin_ker(1);
  f := 0.2867062087283160460;
  testrel(5, NE, y, f, cnt,failed);

  y := kelvin_ker(2.75);
  f := -0.7072857588003313910e-1;
  testrel(6, NE2, y, f, cnt,failed);

  y := kelvin_ker(3.0);
  f := -0.6702923330379869775e-1;
  testrel(7, NE, y, f, cnt,failed);

  y := kelvin_ker(10);
  f := 0.1294663302148061222e-3;
  testrel(8, NE2, y, f, cnt,failed);

  y := kelvin_ker(19.5);
  f := -0.1153142853119002640e-7;
  testrel(9, NE2, y, f, cnt,failed);

  y := kelvin_ker(20);
  f := -0.7715233109860961461e-7;
  testrel(10, NE2, y, f, cnt,failed);

  y := kelvin_ker(100);
  f := -0.9898417996730774015e-32;
  testrel(11, NE3, y, f, cnt,failed);

  y := kelvin_ker(1000);
  f := -0.2566470946629444788e-308;
  testrel(12, 600, y, f, cnt,failed);    {!!!}

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_kei;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE3 = 100;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','kelvin_kei');


  y := kelvin_kei(1e-10);
  f := -0.7853981633974483096;
  testrel(1, NE, y, f, cnt,failed);

  y := kelvin_kei(1e-5);
  f := -0.7853981630817268851;
  testrel(2, NE, y, f, cnt,failed);

  y := kelvin_kei(0.03125);
  f := -0.7842795805492080246;
  testrel(3, NE, y, f, cnt,failed);

  y := kelvin_kei(0.5);
  f := -0.6715816950943676032;
  testrel(4, NE, y, f, cnt,failed);

  y := kelvin_kei(1);
  f := -0.4949946365187199003;
  testrel(5, NE, y, f, cnt,failed);

  y := kelvin_kei(2.75);
  f := -0.7735398824302068709e-1;
  testrel(6, 2*NE, y, f, cnt,failed);   {!!64-bit}

  y := kelvin_kei(3.0);
  f := -0.5112188404598678140e-1;
  testrel(7, NE, y, f, cnt,failed);

  y := kelvin_kei(10);
  f := -0.3075245690881441990e-3;
  testrel(8, NE, y, f, cnt,failed);

  y := kelvin_kei(19.5);
  f := -0.2900202390640604669e-6;
  testrel(9, NE, y, f, cnt,failed);

  y := kelvin_kei(20);
  f := -0.1858941511119437205e-6;
  testrel(10, 3*NE, y, f, cnt,failed);    {!!64-bit}

  y := kelvin_kei(100);
  f := -0.2236535526041445723e-31;
  testrel(11, NE3, y, f, cnt,failed);

  y := kelvin_kei(1000);
  f := 0.1915021570632197478e-308;
  testrel(12, 300, y, f, cnt,failed);  {!!!!}


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;



{---------------------------------------------------------------------------}
procedure test_struve_h0;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 20;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_h0');

  x := 1e-10;
  f := 0.6366197723675813431e-10;
  y := struve_h0(x);
  testrel(1, NE, y, f, cnt,failed);

  x := 0.125;
  f := 0.7943940253295662488e-1;
  y := struve_h0(x);
  testrel(2, NE, y, f, cnt,failed);

  x := 1.5;
  f := 0.7367234656043998716;
  y := struve_h0(x);
  testrel(3, NE, y, f, cnt,failed);

  x := 5.0;
  f := -0.1852168157766848901;
  y := struve_h0(x);
  testrel(4, NE, y, f, cnt,failed);

  x := 10.9375;
  f := -0.1005132970627699984;
  y := struve_h0(x);
  testrel(5, 2*NE, y, f, cnt,failed);   {!!64-bit}

  x := -11.0625;
  f := 0.12160763382511235722;
  y := struve_h0(x);
  testrel(6, 2*NE, y, f, cnt,failed);   {!!64-bit}

  x := 50;
  f := -0.8533767482611899895e-1;
  y := struve_h0(x);
  testrel(7, NE, y, f, cnt,failed);

  x := -200.0;
  f := 0.5108275594755779573e-1;
  y := struve_h0(x);
  testrel(8, NE2, y, f, cnt,failed);

  x := 10000.0;
  f := 0.3711467535586744306e-2;
  y := struve_h0(x);
  testrel(9, NE, y, f, cnt,failed);

  x := 1e10;
  f := -7.676444513815699932354438350541348934573911340922678e-6;  {Alpha}
  y := struve_h0(x);
  testrel(10, NE, y, f, cnt,failed);

  x := ldexpd(1,200);
  f := 1.775696965839498604282508984743015823013271680925546e-31;  {Alpha}
  y := struve_h0(x);
  testrel(11, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_struve_h1;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 10;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_h1');

  x := 1e-10;
  f := 0.21220659078919378103e-20;
  y := struve_h1(x);
  testrel(1, NE, y, f, cnt,failed);

  x := 9e-10;
  f := 0.17188733853924696262111255e-18;
  y := struve_h1(x);
  testrel(2, NE, y, f, cnt,failed);

  x := 10e-10;
  f := 2.122065907891938e-19;
  y := struve_h1(x);
  testrel(3, NE, y, f, cnt,failed);   {err = 1.02}

  x := 0.125;
  f := 0.3312275639297361862e-2;
  y := struve_h1(x);
  testrel(4, NE, y, f, cnt,failed);

  x := -1.5;
  f := 0.4102884759694156390;
  y := struve_h1(x);
  testrel(5, NE, y, f, cnt,failed);

  x := 4.0;
  f := 1.069726661308919359;
  y := struve_h1(x);
  testrel(6, NE, y, f, cnt,failed);

  x := 8.9375;
  f := 0.73350546732887753298;
  y := struve_h1(x);
  testrel(7, NE2, y, f, cnt,failed);

  x := 9;
  f := 0.7485424374510771033;
  y := struve_h1(x);
  testrel(8, NE, y, f, cnt,failed);

  x := 9.0625;
  f := 0.7630757591588199560;
  y := struve_h1(x);
  testrel(9, NE, y, f, cnt,failed);

  x := 50.0;
  f := 0.580078447945441898996;
  y := struve_h1(x);
  testrel(10, NE, y, f, cnt,failed);

  x := -100;
  f := 0.6163111032720133845;
  y := struve_h1(x);
  testrel(11, NE2, y, f, cnt,failed);

  x := 10000;
  f := 0.6437161214863153709;
  y := struve_h1(x);
  testrel(12, NE, y, f, cnt,failed);

  x := 1e40;
  f := 0.6366197723675813431;  {Alpha}
  y := struve_h1(x);
  testrel(13, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_struve_l0;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_l0');

  x := -1e-10;
  f := -0.6366197723675813431e-10;
  y := struve_l0(x);
  testrel(1, NE, y, f, cnt,failed);

  x := 0.125;
  f := 0.79715713253115014945e-1;
  y := struve_l0(x);
  testrel(2, NE, y, f, cnt,failed);

  x := 1.0;
  f := 0.71024318593789088874;
  y := struve_l0(x);
  testrel(3, NE, y, f, cnt,failed);

  x := -5;
  f := -27.10591712655814655;
  y := struve_l0(x);
  testrel(4, NE, y, f, cnt,failed);

  x := 10.0;
  f := 2815.652249374594856;
  y := struve_l0(x);
  testrel(5, NE, y, f, cnt,failed);

  x := 21.9375;
  f := 288526427.5058929094;
  y := struve_l0(x);
  testrel(6, NE, y, f, cnt,failed);

  x := 22;
  f := 306692993.6113665191;
  y := struve_l0(x);
  testrel(7, NE, y, f, cnt,failed);

  x := 22.0625;
  f := 326004733.7583088458;
  y := struve_l0(x);
  testrel(8, NE, y, f, cnt,failed);

  x := -50;
  f := -0.2932553783849336327e21;
  y := struve_l0(x);
  testrel(9, NE, y, f, cnt,failed);

  x := 100.0;
  f := 0.10737517071310738235e43;
  y := struve_l0(x);
  testrel(10, NE, y, f, cnt,failed);

  x := -700;
  f := -0.1529593347671873736e303;
  y := struve_l0(x);
  testrel(11, NE, y, f, cnt,failed);

  x := 11600;
  f := PosInf_d;
  y := struve_l0(x);
  testabs(12, 0, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_struve_l1;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_l1');

  x := -1e-10;
  f := 0.2122065907891937810e-20;
  y := struve_l1(x);
  testrel(1, NE, y, f, cnt,failed);

  x := 0.125;
  f := 0.3319183406689451674e-2;
  y := struve_l1(x);
  testrel(2, NE, y, f, cnt,failed);

  x := 1.0;
  f := 0.2267643810558086368;
  y := struve_l1(x);
  testrel(3, NE, y, f, cnt,failed);

  x := -5;
  f := 23.72821578040828245;
  y := struve_l1(x);
  testrel(4, NE, y, f, cnt,failed);

  x := 10.0;
  f := 2670.358285208482969;
  y := struve_l1(x);
  testrel(5, NE, y, f, cnt,failed);

  x := 21.9375;
  f := 281871698.9854743394;
  y := struve_l1(x);
  testrel(6, NE, y, f, cnt,failed);

  x := 22;
  f := 299639606.2420829644;
  y := struve_l1(x);
  testrel(7, NE, y, f, cnt,failed);

  x := 22.0625;
  f := 318528712.6350923864;
  y := struve_l1(x);
  testrel(8, NE, y, f, cnt,failed);

  x := -50;
  f := 0.2903078590103556797e21;
  y := struve_l1(x);
  testrel(9, NE, y, f, cnt,failed);

  x := 100.0;
  f := 0.1068369390338162481e43;
  y := struve_l1(x);
  testrel(10, NE, y, f, cnt,failed);

  x := -700;
  f := 0.1528500390233900688e303;
  y := struve_l1(x);
  testrel(11, NE, y, f, cnt,failed);

  x := 11600;
  f := PosInf_d;
  y := struve_l1(x);
  testabs(12, 0, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_struve_l;
var
  y,f: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_l');

  y := struve_l(2,0.125);
  f := 0.8295489743456552627e-4;
  testrel(1, NE, y, f, cnt,failed);

  y := struve_l(2,1);
  f := 0.4450783303707983406e-1;
  testrel(2, NE, y, f, cnt,failed);

  y := struve_l(2,10);
  f := 0.2279458526425006324e4;
  testrel(3, NE, y, f, cnt,failed);

  y := struve_l(2,20);
  f := 0.3931278100849803299e8;
  testrel(4, NE, y, f, cnt,failed);

  y := struve_l(2,29);
  f := 0.2726977277708515203e12;
  testrel(5, NE, y, f, cnt,failed);

  y := struve_l(2,30);
  f := 0.7304368285550353082e12;
  testrel(6, NE, y, f, cnt,failed);

  y := struve_l(2,40);
{$ifdef BIT16}
  f := 0.2831880997051384763e17*0.5;
{$else}
  f := 0.141594049852569238149e17;
{$endif}
  testrel(7, NE, y, f, cnt,failed);

  y := struve_l(3,0.125);
  f := 0.1481092567124268210e-5;
  testrel(8, NE, y, f, cnt,failed);

  y := struve_l(3,1);
  f := 0.6291730749650544377e-2;
  testrel(9, NE, y, f, cnt,failed);

  y := struve_l(3,10);
  f := 0.1754330742822696564e4;
  testrel(10, NE, y, f, cnt,failed);

  y := struve_l(3,20);
  f := 0.3459239957188510972e8;
  testrel(11, NE, y, f, cnt,failed);

  y := struve_l(3,29);
  f := 0.2498186283973945593e12;
  testrel(12, NE, y, f, cnt,failed);

  y := struve_l(3,30);
  f := 0.6711404617594525287e12;
  testrel(13, NE, y, f, cnt,failed);

  y := struve_l(3,40);
  f := 0.2658291132946718363e17*0.5;
  testrel(14, NE, y, f, cnt,failed);

  y := struve_l(22,22);
  f := 0.8808824715288026159e4;
  testrel(15, NE, y, f, cnt,failed);

  y := struve_l(100,10);
  f := 0.5612962056656603369e-88;
  testrel(16, NE, y, f, cnt,failed);

  y := struve_l(100,125);
  f := 0.1586799477332954879e37;
  testrel(17, NE, y, f, cnt,failed);

  y := struve_l(100,200);
  f := 0.4352750449727021914e75;
  testrel(18, NE, y, f, cnt,failed);

  y := struve_l(0,-5);
  f := -0.2710591712655814655e2;
  testrel(19, NE, y, f, cnt,failed);

  y := struve_l(2,-30);
  f := -0.7304368285550353082e12;
  testrel(20, NE, y, f, cnt,failed);

  y := struve_l(3,-30);
  f := 0.6711404617594525287e12;
  testrel(21, NE, y, f, cnt,failed);

  y := struve_l(4,-30);
  f := -0.5962087360394425753e12;
  testrel(22, NE, y, f, cnt,failed);

  y := struve_l(10,-5);
  f := -0.3267717256563183426e-2;
  testrel(23, NE, y, f, cnt,failed);

  {non-integer nu}

  y := struve_l(0.5, 0.125);
  f := 0.1765389337886431062e-1;
  testrel(24, NE, y, f, cnt,failed);

  y := struve_l(0.5, 1);
  f := 0.4333156537901020906;
  testrel(25, NE, y, f, cnt,failed);

  y := struve_l(4.125, 30);
  f := 0.5860632942110845909e12;
  testrel(26, NE, y, f, cnt,failed);

  y := struve_l(0.125, 1);
  f := 0.6385292223521091581;
  testrel(27, NE, y, f, cnt,failed);

  y := struve_l(0.125, 20);
  f := 0.43540820615210402417e8;
  testrel(28, NE, y, f, cnt,failed);

  y := struve_l(0.125, 30);
  f := 0.7814652427883059899e12;
  testrel(29, NE, y, f, cnt,failed);

  y := struve_l(0.125, 600);
  f := 0.6146225307628329318e259;
  testrel(30, NE, y, f, cnt,failed);

  y := struve_l(2.5, 0.125);
  f := 0.1148594175782397002e-4;
  testrel(31, NE, y, f, cnt,failed);

  y := struve_l(2.5, 20.0);
  f := 0.3711237359585533815e8;
  testrel(32, NE, y, f, cnt,failed);

  y := struve_l(2.5, 30.0);
  f := 0.7031240155028873763e12;
  testrel(33, NE, y, f, cnt,failed);

  y := struve_l(34.5, 1.0);
  f := 0.2257714211993053785e-50;
  testrel(34, NE, y, f, cnt,failed);

  y := struve_l(34.5, 20.0);
  f := 0.2699008185941967816e-3;
  testrel(35, NE, y, f, cnt,failed);

  y := struve_l(34.5, 60.0);
  f := 0.3464808963345829804e21;
  testrel(36, NE, y, f, cnt,failed);

  y := struve_l(34.5, 600.0);
  f := 0.2278283882763869035e259;
  testrel(37, NE, y, f, cnt,failed);

  y := struve_l(0.0078125, 10.5);
  f := 0.4527364872181681461e4;
  testrel(38, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


{---------------------------------------------------------------------------}
procedure test_struve_h;
var
  y,f: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE1 = 6; {SSE}
  NE2 = 12;
  NA  = 1;
  NA1 = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','struve_h');

  y := struve_h(3,-2);
  f := 0.8363766505550048094e-1;
  testrel(1, NE, y, f, cnt,failed);

  y := struve_h(3,-20);
  f := 0.1734324046607079089e2;
  testrel(2, NE, y, f, cnt,failed);

  y := struve_h(3,-40);
  f := 0.6811268391613181297e2;
  testrel(3, NE, y, f, cnt,failed);

  y := struve_h(2,-2);
  f := -0.2803180603538537866;
  testrel(4, NE, y, f, cnt,failed);

  y := struve_h(2,-20);
  f := -0.4197006936131656458e1;
  testrel(5, NE, y, f, cnt,failed);

  y := struve_h(2,-38);
  f := -0.8135239017003814325e1;
  testrel(6, NE, y, f, cnt,failed);

  y := struve_h(2,-40);
  f := -0.8377982783015674911e1;
  testrel(7, NE, y, f, cnt,failed);

  y := struve_h(3,12);
  f := 0.6466466749652133069e1;
  testrel(8, NE, y, f, cnt,failed);

  y := struve_h(4,12);
  f := 0.1089385313566373143e2;
  testrel(9, NE, y, f, cnt,failed);

  y := struve_h(12,12);
  f := 0.1916310028811865144e1;
  testrel(10, NE, y, f, cnt,failed);

  y := struve_h(15,12);
  f := 0.1724346086687928455;
  testrel(11, NE, y, f, cnt,failed);

  y := struve_h(20,12);
  f := 0.8174274710118640982e-3;
  testrel(12, NE, y, f, cnt,failed);

  y := struve_h(50, 0.125);
  f := 0.2025435664804135908e-126;
  testrel(13, NE, y, f, cnt,failed);

  y := struve_h(50,1);
  f := 0.2305285238913316546e-80;
  testrel(14, NE, y, f, cnt,failed);

  y := struve_h(50,12);
  f := 0.1617549730830877160e-25;
  testrel(15, NE, y, f, cnt,failed);

  y := struve_h(50,50);
  f := 0.4337948946341474352e5;
  testrel(16, NE2, y, f, cnt,failed);

  y := struve_h(50,100);
  f := 0.2359715627416222343e20;
  testrel(17, NE, y, f, cnt,failed);

  y := struve_h(2,0.125);
  f := 0.8283154445038754206e-4;
  testrel(18, NE, y, f, cnt,failed);

  y := struve_h(2,1);
  f := 0.4046463614479462791e-1;
  testrel(19, NE, y, f, cnt,failed);

  y := struve_h(2,6);
  f := 0.1617186635063330261e1;
  testrel(20, NE, y, f, cnt,failed);

  y := struve_h(2,8);
  f := 0.3035387252267535533e1*0.5;
  testrel(21, NE, y, f, cnt,failed);

  y := struve_h(2,10);
  f := 0.2181688722623384164e1;
  testrel(22, NE, y, f, cnt,failed);

  y := struve_h(2,12);
  f := 0.2816322778697388064e1;
  testrel(23, NE, y, f, cnt,failed);

  y := struve_h(2,20);
  f := 0.4197006936131656458e1;
  testrel(24, NE, y, f, cnt,failed);

  y := struve_h(2,30);
  f := 0.6510412837119774873e1;
  testrel(25, NE, y, f, cnt,failed);

  y := struve_h(2,40);
  f := 0.8377982783015674911e1;
  testrel(26, NE, y, f, cnt,failed);

  y := struve_h(2,50);
  f := 0.10718870352203625726e2;
  testrel(27, NE, y, f, cnt,failed);

  y := struve_h(2,100);
  f := 0.2130386405267446571e2;
  testrel(28, NE, y, f, cnt,failed);

  y := struve_h(10,0.125);
  f := 0.5389034941017067878e-20;
  testrel(29, NE, y, f, cnt,failed);

  y := struve_h(10,1);
  f := 0.4563623880470109001e-10;
  testrel(30, NE, y, f, cnt,failed);

  y := struve_h(10,4);
  f := 0.1544763075114888737e-3;
  testrel(31, NE, y, f, cnt,failed);

  y := struve_h(10,6);
  f := 0.1013711880650545025e-1;
  testrel(32, NE, y, f, cnt,failed);

  y := struve_h(10,8);
  f := 0.16687353850333171213;
  testrel(33, NE, y, f, cnt,failed);

  y := struve_h(10,9);
  f := 0.4966834740182485912;
  testrel(34, NE, y, f, cnt,failed);

  y := struve_h(10,20);
  f := 0.5251927521745221582e3;
  testrel(35, NE, y, f, cnt,failed);

  y := struve_h(10,30);
  f := 0.1956771527019647543e5;
  testrel(36, NE, y, f, cnt,failed);

  y := struve_h(20,40);
  f := 0.5615220059442179315e7;
  testrel(37, NE, y, f, cnt,failed);

  y := struve_h(30,4);
  f := 0.1514561328076532737e-23;
  testrel(38, NE, y, f, cnt,failed);

  y := struve_h(30,5);
  f := 0.1459461294786301802e-20;
  testrel(39, NE, y, f, cnt,failed);

  y := struve_h(30,10);
  f := 0.2157359166313841896e-11;
  testrel(40, NE, y, f, cnt,failed);

  y := struve_h(30,20);
  f := 0.1460043012228651387e-2;
  testrel(41, NE1, y, f, cnt,failed);

  y := struve_h(30,30);
  f := 0.1623595353884071012e3;
  testrel(42, NE, y, f, cnt,failed);

  y := struve_h(30,40);
  f := 0.6542690683966296798e6;
  testrel(43, NE, y, f, cnt,failed);

  {non-integer nu}

  y := struve_h(0.5, Pi);
  f := 0.9003163161571060696;
  testrel(44, NE, y, f, cnt,failed);

  y := struve_h(0.5, 60.0);
  f := 0.2011111376078884702;
  testrel(45, NE, y, f, cnt,failed);

  y := struve_h(2.5, 20.0);
  f := 0.9058993618079528111e1;
  testrel(46, NE, y, f, cnt,failed);

  y := struve_h(34.5, 20.0);
  f := 0.7692959060558401110e-5;
  testrel(47, NE, y, f, cnt,failed);

  y := struve_h(34.5, 40.0);
  f := 0.7702896071503372942e5;
  testrel(48, NE, y, f, cnt,failed);

  y := struve_h(34.5, 60.0);
  f := 0.5935220289490881169e11;
  testrel(49, NE, y, f, cnt,failed);

  y := struve_h(0.125, 0.5);
  f := 0.2578567948941973427;
  testrel(50, NE, y, f, cnt,failed);

  y := struve_h(0.125, 2);
  f := 0.8149844854995485319;
  testrel(51, NE, y, f, cnt,failed);

  y := struve_h(0.125, 5);          {int + Yv: abs}
  f := -0.9618309457354139700e-1;
  testabs(52, NA1, y, f, cnt,failed);

  y := struve_h(0.125, 30);         {int + Yv: abs}
  f := -0.6146886542830816681e-1;
  testabs(53, NA, y, f, cnt,failed);

  y := struve_h(0.125, 40);         {AE  + Yv: abs}
  f := 0.1506693495161465447;
  testabs(54, NA, y, f, cnt,failed);

  y := struve_h(0.25, 5);           {int + Yv: abs}
  f := 0.8861990084230123199e-2;
  testabs(55, NA, y, f, cnt,failed);

  y := struve_h(0.25, 4);
  f := 0.4008926305910176599;
  testrel(56, NE, y, f, cnt,failed);

  y := struve_h(0.625, 5);
  f := 0.3910731128047716249;
  testrel(57, NE, y, f, cnt,failed);

  y := struve_h(0.0078125, 10.5);   {int + Yv: abs}
  f := -0.2779771777082488473e-2;
  testabs(58, NA, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


end.

