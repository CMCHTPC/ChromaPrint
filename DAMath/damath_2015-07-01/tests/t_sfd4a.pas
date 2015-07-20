{Part 4a of regression test for SPECFUND unit  (c) 2010-2013  W.Ehrhardt}

unit t_sfd4a;

{$i STD.INC}

{$ifdef BIT16}
  {$N+}
  {$ifndef Windows}
    {$O+}
  {$endif}
{$endif}

interface


procedure test_e1;
procedure test_ei;
procedure test_ei_inv;
procedure test_gei;
procedure test_ein;
procedure test_li;
procedure test_en;
procedure test_chi;
procedure test_shi;
procedure test_ci;
procedure test_cin;
procedure test_cinh;
procedure test_si;
procedure test_ssi;


implementation

uses
  damath, specfund, t_sfd0;


{---------------------------------------------------------------------------}
procedure test_e1;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','e1');

  x := succd(0); {x=0.5^1074}
  y := e1(x);
  f := 743.86285625647972945;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-10;
  y := e1(x);
  f := 22.448635265138923980;
  testrel( 2, NE, y, f, cnt,failed);

  x := 0.0009765625;
  y := e1(x);
  f := 6.3552324648310718026;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.125;
  y := e1(x);
  f := 1.6234256405841687915;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.5;
  y := e1(x);
  f := 0.5597735947761608118;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.9990234375;
  y := e1(x);
  f := 0.2197435427851990964;
  testrel( 6, NE, y, f, cnt,failed);

  x := 1.0;
  y := e1(x);
  f := 0.2193839343955202737;
  testrel( 7, NE, y, f, cnt,failed);

  x := 1.0009765625;
  y := e1(x);
  f := 0.2190250276806367220;
  testrel( 8, NE, y, f, cnt,failed);

  x := 1.5;
  y := e1(x);
  f := 0.1000195824066326519;
  testrel( 9, NE, y, f, cnt,failed);

  x := 2.0;
  y := e1(x);
  f := 0.4890051070806111957e-1;
  testrel(10, NE, y, f, cnt,failed);

  x := 100.0;
  y := e1(x);
  f := 0.3683597761682032180e-45;
  testrel(11, 32, y, f, cnt,failed);    {!!!???}

  x := 706.0;
  y := e1(x);
  f := 0.3456823684693928525e-309;
  testrel(12, NE, y, f, cnt,failed);

  x := 707.0;
  y := e1(x);
  f := 0.0;
  testabs(13, 1, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ei;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','ei');

  x := succd(0); {x=0.5^1074}
  y := ei(x);
  f := -743.86285625647972945;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-100;
  y := ei(x);
  f := -229.68129363450303554;
  testrel( 2, NE, y, f, cnt,failed);

  x := 1e-20;
  y := ei(x);
  f := -45.474486194979380820;
  testrel( 3, NE, y, f, cnt,failed);

  x := 1e-10;
  y := ei(x);
  f := -22.448635264938923980;
  testrel( 4, NE, y, f, cnt,failed);

  x := 1e-5;
  y := ei(x);
  f := -10.935699800043695504;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.250;
  y := ei(x);
  f := -0.54254326466191372953;
  testrel( 6, NE, y, f, cnt,failed);

  x := 0.372507410781366634462;
  y := ei(x);
  f := 0.31689558510305276553e-22;
  testabs( 7, NE, y, f, cnt,failed);

  x := 5.9990234375;
  y := ei(x);
  f := 85.92412661441223831;
  testrel( 8, NE, y, f, cnt,failed);

  x := 6.0;
  y := ei(x);
  f := 85.989762142439204804;
  testrel( 9, NE, y, f, cnt,failed);

  x := 6.0009765625;
  y := ei(x);
  f := 86.055451106535934443;
  testrel(10, NE, y, f, cnt,failed);

  x := 9.9990234375;
  y := ei(x);
  f := 2490.0788991846740153;
  testrel(11, NE, y, f, cnt,failed);

  x := 10.0;
  y := ei(x);
  f := 2492.2289762418777591;
  testrel(12, NE, y, f, cnt,failed);

  x := 10.0009765625;
  y := ei(x);
  f := 2494.3809438459312504;
  testrel(13, NE, y, f, cnt,failed);

  x := 19.9990234375;
  y := ei(x);
  f := 25591973.942720267184;
  testrel(14, NE, y, f, cnt,failed);

  x := 20.0;
  y := ei(x);
  f := 25615652.664056588820;
  testrel(15, NE, y, f, cnt,failed);

  x := 20.0009765625;
  y := ei(x);
  f := 25639353.363149838071;
  testrel(16, NE, y, f, cnt,failed);

  x := 39.9990234375;
  y := ei(x);
  f := 6033974287987191.3386;
  testrel(17, NE, y, f, cnt,failed);

  x := 40.0;
  y := ei(x);
  f := 6039718263611241.5784;
  testrel(18, NE, y, f, cnt,failed);

  x := 40.0009765625;
  y := ei(x);
  f := 6045467710957239.9226;
  testrel(19, NE, y, f, cnt,failed);

  x := 100.0;
  y := ei(x);
  f := 0.27155527448538798219e42;
  testrel(20, NE, y, f, cnt,failed);


  x := 716.25;
  y := ei(x);
  f := 0.16179520553005191768e309;
  testrel(21, NE, y, f, cnt,failed);


  x := 717.0;
  y := ei(x);
  f := PosInf_d;
  testabs(22, NE, y, f, cnt,failed);

  x := predd(0); {x=0.5^1074}
  y := ei(x);
  f := -743.86285625647972945;
  testrel(23, NE, y, f, cnt,failed);

  x := -1e-10;
  y := ei(x);
  f := -22.448635265138923980;
  testrel(24, NE, y, f, cnt,failed);

  x := -0.0009765625;
  y := ei(x);
  f := -6.3552324648310718026;
  testrel(25, NE, y, f, cnt,failed);

  x := -0.125;
  y := ei(x);
  f := -1.6234256405841687915;
  testrel(26, NE, y, f, cnt,failed);

  x := -0.5;
  y := ei(x);
  f := -0.5597735947761608118;
  testrel(27, NE, y, f, cnt,failed);

  x := -0.9990234375;
  y := ei(x);
  f := -0.2197435427851990964;
  testrel(28, NE, y, f, cnt,failed);

  x := -1.0;
  y := ei(x);
  f := -0.2193839343955202737;
  testrel(29, NE, y, f, cnt,failed);

  x := -1.0009765625;
  y := ei(x);
  f := -0.2190250276806367220;
  testrel(30, NE, y, f, cnt,failed);

  x := -1.5;
  y := ei(x);
  f := -0.1000195824066326519;
  testrel(31, NE, y, f, cnt,failed);

  x := -2.0;
  y := ei(x);
  f := -0.4890051070806111957e-1;
  testrel(32, NE, y, f, cnt,failed);

  x := -100.0;
  y := ei(x);
  f := -0.368359776168203218e-45;
  testrel(33, 32, y, f, cnt,failed);    {!!!???}

  x := -1000.0;
  y := ei(x);
  f := 0;
  testrel(34, NE, y, f, cnt,failed);

  x := 500.0;
  y := ei(x);
  f := 0.2812821397886294e215;
  testrel(35, NE, y, f, cnt,failed);

  x := 600.0;
  y := ei(x);
  f := 0.6298882891387931e258;
  testrel(36, NE, y, f, cnt,failed);

  x := 700;
  y := ei(x);
  f := 0.1450978736052561e302;
  testrel(37, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ein;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2 = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','ein');

  {ein := x -> ln(abs(x))-Ei(-x)+gamma;}

  x := -1e-19;
  f := -1e-19;
  y := ein(x);
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-16;
  f := 0.999999999999999975e-16;
  y := ein(x);
  testrel( 2, NE, y, f, cnt,failed);

  x := 1e-3;
  f := 0.9997500555451405553e-3;
  y := ein(x);
  testrel( 3, NE, y, f, cnt,failed);

  x := -1e-3;
  f := -0.1000250055565973889e-2;
  y := ein(x);
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.125;
  f := 0.1211997638058657238;
  y := ein(x);
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.25;
  f := 0.2352039382253804363;
  y := ein(x);
  testrel( 6, NE2, y, f, cnt,failed);

  x := 0.5;
  f := 0.4438420791177483629;
  y := ein(x);
  testrel( 7, NE, y, f, cnt,failed);

  x := 1;
  f := 0.7965995992970531343;
  y := ein(x);
  testrel( 8, NE, y, f, cnt,failed);

  x := -1;
  f := -1.317902151454403895;
  y := ein(x);
  testrel( 9, NE, y, f, cnt,failed);

  x := 10;
  f := 2.879804914864508230;
  y := ein(x);
  testrel(10, NE, y, f, cnt,failed);

  x := 45;
  f := 4.383878154671852618;
  y := ein(x);
  testrel(11, NE, y, f, cnt,failed);

  x := -45;
  f := -0.7943916035704453728e18;
  y := ein(x);
  testrel(12, NE, y, f, cnt,failed);

  x := -50;
  f := -0.1058563689713169096e21;
  y := ein(x);
  testrel(13, NE, y, f, cnt,failed);

  x := -700;
  f := -0.1450978736052560853e302;
  y := ein(x);
  testrel(14, NE, y, f, cnt,failed);

  x := 1e9;
  f := 21.30048150184794402;
  y := ein(x);
  testrel(15, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_li;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2 = 10;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','li');

  x := 1+ldexpd(1,-52);
  y := li(x);
  f := -35.466437724215623118;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-50);
  y := li(x);
  f := -34.080143363095732166;
  testrel( 2, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-40);
  y := li(x);
  f := -27.148671557495824769;
  testrel( 3, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-20);
  y := li(x);
  f := -13.285727469460253020;
  testrel( 4, NE, y, f, cnt,failed);

  x := 1.0009765625;
  y := li(x);
  f := -6.3537678991714210449;
  testrel( 5, NE, y, f, cnt,failed);

  x := 1.25;
  y := li(x);
  f := -0.6864884538258715793;
  testrel( 6, NE, y, f, cnt,failed);

  x := 1.45136923488338105028;
  y := li(x);
  f := 0;
  testabs( 7, 2, y, f, cnt,failed);

  x := 1.5;
  y := li(x);
  f := 0.125064986315296356;
  testrel( 8, NE, y, f, cnt,failed);

  x := 2.0;
  y := li(x);
  f := 1.045163780117492785;
  testrel( 9, NE, y, f, cnt,failed);

  x := 10.0;
  y := li(x);
  f := 6.165599504787297938;
  testrel(10, NE, y, f, cnt,failed);

  x := 100.0;
  y := li(x);
  f := 30.12614158407962993;
  testrel(11, NE, y, f, cnt,failed);

  x := 1e5;
  y := li(x);
  f := 9629.809001050798210;
  testrel(12, NE, y, f, cnt,failed);

  x := 1e10;
  y := li(x);
  f := 455055614.5866230760;
  testrel(13, NE, y, f, cnt,failed);

  x := 1e100;
  y := li(x);
  f := 0.436197198714070317e98;
  testrel(14, NE, y, f, cnt,failed);

  x := 1e300;
  y := li(x);
  f := 0.1449750052669336289e298;
  testrel(15, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-20);
  y := li(x);
  f := -13.28572842313456943;
  testrel(16, NE, y, f, cnt,failed);

  x := 0.99;
  y := li(x);
  f := -4.032958701708463680;
  testrel(17, NE, y, f, cnt,failed);

  x := 0.5;
  y := li(x);
  f := -0.3786710430610879767;
  testrel(18, NE, y, f, cnt,failed);

  x := 1e-8;
  y := li(x);
  f := -0.5161659103222966770e-9;
  testrel(19, NE2, y, f, cnt,failed);            {x not exact}

  x := 0;
  y := li(x);
  f := 0;
  testabs(20, 0, y, f, cnt,failed);

  x := MaxDouble;
  y := li(x);
  f := 0.253631570116784220025684508253e306;
  testrel(21, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


{---------------------------------------------------------------------------}
procedure test_en;
var
  x,y,f,r: double;
  cnt, failed, n, i: integer;
const
  NE = 4;
  NE2 = 8;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','en');

  n := 2;

  x := 0.0009765625;
  f := 0.99281763247803906869;
  y := en(n,x);
  testrel( 1, NE, y, f, cnt,failed);

  x := 0.03125;
  f := 0.87799799126354567735;
  y := en(n,x);
  testrel( 2, NE, y, f, cnt,failed);

  x := 0.0625;
  f := 0.79835619401120395932;
  y := en(n,x);
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.1;
  f := 0.72254502219402050656;
  y := en(n,x);
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.32664386232455301773;
  y := en(n,x);
  testrel( 5, NE, y, f, cnt,failed);

  x := 1.0;
  f := 0.14849550677592204792;
  y := en(n,x);
  testrel( 6, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-30);
  f := 0.14849550657160483747;
  y := en(n,x);
  testrel( 7, NE2, y, f, cnt,failed);     {!!! 64-bit}

  x := 1.0009765625;
  f := 0.14828143995694106431;
  y := en(n,x);
  testrel( 8, NE2, y, f, cnt,failed);     {!!! 64-bit}

  x := 10.0;
  f := 0.38302404656316087616e-5;
  y := en(n,x);
  testrel( 9, NE, y, f, cnt,failed);

  x := 100.0;
  f := 0.36478214338803782725e-45;
  y := en(n,x);
  testrel(10, NE, y, f, cnt,failed);

  n := 13;

  x := 0.0009765625;
  f := 0.83244602590716266105e-1;
  y := en(n,x);
  testrel(11, NE, y, f, cnt,failed);

  x := 0.03125;
  f := 0.80540692158877804964e-1;
  y := en(n,x);
  testrel(12, NE, y, f, cnt,failed);

  x := 0.0625;
  f := 0.77842384880014072595e-1;
  y := en(n,x);
  testrel(13, NE, y, f, cnt,failed);

  x := 0.1;
  f := 0.74724414880051478920e-1;
  y := en(n,x);
  testrel(14, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.48355620944849452221e-1;
  y := en(n,x);
  testrel(15, NE, y, f, cnt,failed);

  x := 1.0;
  f := 0.28120779972942619757e-1;
  y := en(n,x);
  testrel(16, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-30);
  f := 0.28120779944602397927e-1;
  y := en(n,x);
  testrel(17, NE, y, f, cnt,failed);

  x := 1.0009765625;
  f := 0.28091078897291851192e-1;
  y := en(n,x);
  testrel(18, NE, y, f, cnt,failed);

  x := 10.0;
  f := 0.20217345582160021599e-5;
  y := en(n,x);
  testrel(19, NE, y, f, cnt,failed);

  x := 100.0;
  f := 0.32954062049629810941e-45;
  y := en(n,x);
  testrel(20, NE, y, f, cnt,failed);

  n := 75;

  x := 0.0009765625;
  f := 0.13500142565573009237e-1;
  y := en(n,x);
  testrel(21, NE, y, f, cnt,failed);

  x := 0.03125;
  f := 0.13092141932336039234e-1;
  y := en(n,x);
  testrel(22, NE, y, f, cnt,failed);

  x := 0.0625;
  f := 0.12683911734645245006e-1;
  y := en(n,x);
  testrel(23, NE, y, f, cnt,failed);

  x := 0.1;
  f := 0.12210805862631421537e-1;
  y := en(n,x);
  testrel(24, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.81406079438215685307e-2;
  y := en(n,x);
  testrel(25, NE, y, f, cnt,failed);

  x := 1.0;
  f := 0.49041759071643911284e-2;
  y := en(n,x);
  testrel(26, NE, y, f, cnt,failed);

  x := 1+ldexpd(1,-30);
  f := 0.49041759025353230157e-2;
  y := en(n,x);
  testrel(27, NE, y, f, cnt,failed);

  x := 1.0009765625;
  f := 0.48993243791812648773e-2;
  y := en(n,x);
  testrel(28, NE, y, f, cnt,failed);

  x := 10.0;
  f := 0.53970351088390947490e-6;
  y := en(n,x);
  testrel(29, NE, y, f, cnt,failed);

  x := 100.0;
  f := 0.21309424216469978017e-45;
  y := en(n,x);
  testrel(30, NE, y, f, cnt,failed);

  n := 10000;

  x := 1e-3;
  f := 0.9991003099443454311e-4;
  y := en(n,x);
  testrel(31, NE, y, f, cnt,failed);

  x := 690;
  f := 0.2031738389909001492e-303;
  y := en(n,x);
  testrel(32, NE, y, f, cnt,failed);

  for i:=1 to 8000 do begin
    x := (1+random(2000))/128.0;
    n := 1+random(100);
    y := en(n+1,x);
    r := en(n,x);
    f := exp(-x);
    f := (f - x*r)/n;
    testrel(1000+i, 200, y, f, cnt,failed);
  end;

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_gei;
var
  x,y,f,p: double;
  cnt, failed: integer;
const
  NE  = 4;
  NE2 = 8;
  NE3 = 50;
  NEX = 10000;  {extreme cases p=-2000}
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','gei');

  {Pari: ep(p,x) = x^(p-1)*incgam(1-p,x)}
  {Maple: ep := (p,x) -> x^(p-1)*GAMMA(1-p,x); }

  p := 0.5;
  {-------}
  y := gei(p, 1e-100);
  f := 0.1772453850905516027e51;
  testrel( 1, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 3.093555673422464140;
  testrel( 2, NE, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.2788055852806619764;
  testrel( 3, NE, y, f, cnt,failed);

  y := gei(p, 2);
  f := 0.57026123992892048276e-1;
  testrel( 4, NE2, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.4340626507388660447e-5;
  testrel( 5, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.3701747860408278920e-45;
  testrel( 6, NE, y, f, cnt,failed);

  y := gei(p, 700);
  f := 0.1407521279338407783e-306;
  testrel( 7, NE, y, f, cnt,failed);


  p := 21.5;
  {-------}
  y := gei(p, 0);
  f := 0.4878048780487804878e-1;
  testrel( 8, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 0.4277452796937324777e-1;
  testrel( 9, NE3, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.1707212867834382249e-1;
  testrel( 10, NE, y, f, cnt,failed);

  y := gei(p, 2);
  f := 0.5990354699843735076e-2;
  testrel( 11, NE, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.1472523580892865630e-5;
  testrel( 12, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.3066197121388436857e-45;
  testrel( 13, NE, y, f, cnt,failed);

  y := gei(p, 700);
  f := 0.1366608827306444418e-306;
  testrel( 14, NE, y, f, cnt,failed);


  p := 10000.5;
  {-------}
  y := gei(p, 0);
  f := 0.1000050002500125006e-3;
  testrel( 15, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 0.8825299963561445599e-4;
  testrel( 16, NE, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.3678610444404259898e-4;
  testrel( 17, NE, y, f, cnt,failed);

  y := gei(p, 2);
  f := 0.1353149832829559993e-4;
  testrel( 18, NE, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.4535683623622977138e-8;
  testrel( 19, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.3683422276878591542e-47;
  testrel(20, NE, y, f, cnt,failed);

  y := gei(p, 700);
  f := 0.9215025235602690746e-308;
  testrel(21, NE, y, f, cnt,failed);


  p := -0.25;
  {-------}
  y := gei(p, 1e-100);
  f := 0.9064024770554770780e125;
  testrel(22, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 11.44827590461419247;
  testrel(23, NE, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.4294433234698169988;
  testrel(24, NE2, y, f, cnt,failed);

  y := gei(p, 2);
  f := 0.7425525943954705813e-1;
  testrel(25, NE, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.4646166613052861213e-5;
  testrel(26, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.3729307602820619259e-45;
  testrel(27, NE, y, f, cnt,failed);

  y := gei(p, 700);
  f := 0.1409027727624418935e-306;
  testrel(28, NE, y, f, cnt,failed);


  p := -10;
  {-------}
  x := 0.8077935669463160887e-27; {2^(-90)}
  y := gei(p, x);
  f := 0.3797158626716334819e305;
  testrel(29, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 0.3117115464744959992e17;
  testrel(30, NE, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.3628799963538665376e7;
  testrel(31, NE, y, f, cnt,failed);

  y := gei(p, 2);
  f := 1771.860278864947092;
  testrel(32, NE, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.2115734645500305809e-4;
  testrel(33, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.4128442039111897090e-45;
  testrel(34, NE, y, f, cnt,failed);

  y := gei(p, 737);
  f := 0.115724212019530449457270901430e-322;  {denormal}
  testrel(35, NE, y, f, cnt,failed);


  p := -100;
  {-------}
  y := gei(p, 0.0625);
  f := 0.3855865735238997662e280;
  testrel(36, NE, y, f, cnt,failed);

  y := gei(p, 0.125);
  f := 0.1520870867155658967e250;
  testrel(37, NE, y, f, cnt,failed);

  y := gei(p, 1);
  f := 0.9332621544394415268e158;
  testrel(38, NE, y, f, cnt,failed);

  y := gei(p, 2);
  f := 0.3681070139798047821e128;
  testrel(39, NE, y, f, cnt,failed);

  y := gei(p, 10);
  f := 0.9332621544394415268e57;
  testrel(40, NE, y, f, cnt,failed);

  y := gei(p, 100);
  f := 0.4914205718464753026e-44;
  testrel(41, NE, y, f, cnt,failed);

  y := gei(p, 700);
  f := 0.1642824847143085383e-306;
  testrel(42, NE3, y, f, cnt,failed);


  p := -2000;
  {-------}
  y := gei(p, 600);
  f := 0.2754219389732493203e177;
  testrel(43, NEX, y, f, cnt,failed);       {!!!!}

  y := gei(p, 735);
  f := 1.201392846268951678;
  testrel(44, NEX, y, f, cnt,failed);       {!!!!}

  y := gei(p, 1000);
  f := 0.3316275092450633241e-267;
  testrel(45, NEX, y, f, cnt,failed);       {!!!!}


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;

{---------------------------------------------------------------------------}
procedure test_chi;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2 = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','chi');

  x := succd(0); {x=0.5^1074}
  y := chi(x);
  f := -743.86285625647972945;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-20;
  y := chi(x);
  f := -45.474486194979380820;
  testrel( 2, NE, y, f, cnt,failed);

  x := 1e-10;
  y := chi(x);
  f := -22.448635265038923980;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.015625;
  y := chi(x);
  f := -3.5816063826810039110;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.250;
  y := chi(x);
  f := -0.79341294955282596203;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.52382257138986440645;
  y := chi(x);
  f := -0.20862054435986945499e-20;
  testabs( 6, NE, y, f, cnt,failed);

  x := 1.0;
  y := chi(x);
  f := 0.83786694098020824089;
  testrel( 7, NE, y, f, cnt,failed);

  x := 5.9990234375;
  y := chi(x);
  f := 42.961883064143711849;
  testrel( 8, NE2, y, f, cnt,failed);

  x := 6.0;
  y := chi(x);
  f := 42.994701029993521072;
  testrel( 9, NE, y, f, cnt,failed);

  x := 6.0009765625;
  y := chi(x);
  f := 43.027545713648386065;
  testrel(10, NE, y, f, cnt,failed);

  x := 9.9990234375;
  y := chi(x);
  f := 1245.0394475116345583;
  testrel(11, NE, y, f, cnt,failed);

  x := 10.0;
  y := chi(x);
  f := 1246.1144860424544147;
  testrel(12, NE, y, f, cnt,failed);

  x := 10.0009765625;
  y := chi(x);
  f := 1247.1904698466967636;
  testrel(13, NE, y, f, cnt,failed);

  x := 19.9990234375;
  y := chi(x);
  f := 12795986.971360133543;
  testrel(14, NE, y, f, cnt,failed);

  x := 20.0;
  y := chi(x);
  f := 12807826.332028294361;
  testrel(15, NE, y, f, cnt,failed);

  x := 20.0009765625;
  y := chi(x);
  f := 12819676.681574918986;
  testrel(16, NE, y, f, cnt,failed);

  x := 39.9990234375;
  y := chi(x);
  f := 3016987143993595.6693;
  testrel(17, NE, y, f, cnt,failed);

  x := 40.0;
  y := chi(x);
  f := 3019859131805620.7892;
  testrel(18, NE, y, f, cnt,failed);

  x := 40.0009765625;
  y := chi(x);
  f := 3022733855478619.9613;
  testrel(19, NE, y, f, cnt,failed);

  x := 100.0;
  y := chi(x);
  f := 0.13577763724269399110e42;
  testrel(20, NE, y, f, cnt,failed);

  x := 716.0;
  y := chi(x);
  f := 0.630251455302044677765e308;
  testrel(21, NE, y, f, cnt,failed);

  x := 718;
  y := chi(x);
  f := PosInf_d;
  testabs(22, 1, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_shi;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','shi');

  x := 0;
  y := shi(x);
  f := 0;
  testabs( 1, 1, y, f, cnt,failed);

  x := succd(0); {x=0.5^1074}
  y := shi(x);
  f := 0.49406564584124654418e-323;
  testrel( 2, NE, y, f, cnt,failed);

  x := 1e-10;
  y := shi(x);
  f := 1e-10;
  testrel( 3, NE, y, f, cnt,failed);

  x := 1e-8;
  y := shi(x);
  f := 0.10000000000000000056e-7;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.015625;
  y := shi(x);
  f := 0.15625211929178078791e-1;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.250;
  y := shi(x);
  f := 0.25086968489091223250;
  testrel( 6, NE, y, f, cnt,failed);

  x := -1.0;
  y := shi(x);
  f := -1.0572508753757285146;
  testrel( 7, NE, y, f, cnt,failed);

  x := 5.9990234375;
  y := shi(x);
  f := 42.962243550268526463;
  testrel( 8, NE, y, f, cnt,failed);

  x := 6.0;
  y := shi(x);
  f := 42.995061112445683731;
  testrel( 9, NE, y, f, cnt,failed);

  x := 6.0009765625;
  y := shi(x);
  f := 43.027905392887548378;
  testrel(10, NE, y, f, cnt,failed);

  x := -9.9990234375;
  y := shi(x);
  f := -1245.0394516730394570;
  testrel(11, NE, y, f, cnt,failed);

  x := 10.0;
  y := shi(x);
  f := 1246.1144901994233444;
  testrel(12, NE, y, f, cnt,failed);

  x := 10.0009765625;
  y := shi(x);
  f := 1247.1904739992344868;
  testrel(13, NE, y, f, cnt,failed);

  x := 19.9990234375;
  y := shi(x);
  f := 12795986.971360133641;
  testrel(14, NE, y, f, cnt,failed);

  x := 20.0;
  y := shi(x);
  f := 12807826.332028294459;
  testrel(15, NE, y, f, cnt,failed);

  x := 20.0009765625;
  y := shi(x);
  f := 12819676.681574919085;
  testrel(16, NE, y, f, cnt,failed);

  x := 39.9990234375;
  y := shi(x);
  f := 3016987143993595.6693;
  testrel(17, NE, y, f, cnt,failed);

  x := -40.0;
  y := shi(x);
  f := -3019859131805620.7892;
  testrel(18, NE, y, f, cnt,failed);

  x := 40.0009765625;
  y := shi(x);
  f := 3022733855478619.9613;
  testrel(19, NE, y, f, cnt,failed);

  x := 100.0;
  y := shi(x);
  f := 0.13577763724269399110e42;
  testrel(20, NE, y, f, cnt,failed);

  x := -716.0;
  y := shi(x);
  f := -0.630251455302044677765e308;
  testrel(21, NE, y, f, cnt,failed);

  x := 718;
  y := shi(x);
  f := PosInf_d;
  testabs(22, 1, y, f, cnt,failed);

  x := -0.0009765625;
  y := shi(x);
  f := -0.97656255174014451449e-3;
  testrel(23, NE, y, f, cnt,failed);

  x := 0.03125;
  y := shi(x);
  f := 0.31251695470678306704e-1;
  testrel(24, NE, y, f, cnt,failed);

  x := 0.125;
  y := shi(x);
  f := 0.12510855782059272682;
  testrel(25, NE, y, f, cnt,failed);

  x := 0.3740234375;
  y := shi(x);
  f := 0.37694252496022112043;
  testrel(26, NE, y, f, cnt,failed);

  x := -0.375;
  y := shi(x);
  f := -0.37794207672312880415;
  testrel(27, NE, y, f, cnt,failed);

  x := 0.3759765625;
  y := shi(x);
  f := 0.37894174938015373576;
  testrel(28, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ci;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2 = 8;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','ci');

  x := -succd(0); {x=0.5^1074}
  y := ci(x);
  f := -743.862856256479729454;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-20;
  y := chi(x);
  f := -45.474486194979380820;
  testrel( 2, NE, y, f, cnt,failed);

  x := 0.9e-10;
  y := ci(x);
  f := -22.5539957806967502808;
  testrel( 3, NE, y, f, cnt,failed);

  x := 1.1e-10;
  y := ci(x);
  f := -22.35332508523459911953;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.0009765625;
  y := ci(x);
  f := -6.354256379116489861225;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.015625;
  y := ci(x);
  f := -3.5817284529935106480;
  testrel( 6, NE, y, f, cnt,failed);

  x := -0.125;
  y := ci(x);
  f := -1.506129584529639664866;
  testrel( 7, NE, y, f, cnt,failed);

  x := 0.5;
  y := ci(x);
  f := -0.17778407880661290133;
  testrel( 8, NE, y, f, cnt,failed);

  x := 0.6165054856207162337971;
  y := ci(x);
  f := -0.13769133124065501538e-22;
  testabs( 9, NE, y, f, cnt,failed);

  x := 1.0;
  y := ci(x);
  f := 0.337403922900968134663;
  testrel(10, NE, y, f, cnt,failed);

  x := 2.0;
  y := ci(x);
  f := 0.422980828774864995699;
  testrel(11, NE, y, f, cnt,failed);

  x := 3.384180422551186426398;
  y := ci(x);
  f := -0.4269722283323267461315e-22;
  testabs(12, NE, y, f, cnt,failed);

  x := 3.9990234375;
  y := ci(x);
  f := -0.14082200723433856129;
  testrel(13, NE2, y, f, cnt,failed);

  x := 4.0;
  y := ci(x);
  f := -0.1409816978869304116;
  testrel(14, NE2, y, f, cnt,failed);

  x := 4.0009765625;
  y := ci(x);
  f := -0.14114116914356792895;
  testrel(15, NE, y, f, cnt,failed);

  x := 5.0;
  y := ci(x);
  f := -0.1900297496566438786;
  testrel(16, NE, y, f, cnt,failed);

  x := 6.427047744050368639638;
  y := ci(x);
  f := -0.20042673585252231089e-22;
  testabs(17, NE, y, f, cnt,failed);

  x := -8.0;
  y := ci(x);
  f := 0.1224338825320095573;
  testrel(18, NE, y, f, cnt,failed);

  x := 15.0;
  y := ci(x);
  f := 0.4627867767436043960e-1;
  testrel(19, NE, y, f, cnt,failed);

  x := 1000.0;
  y := ci(x);
  f := 0.82631551109068228200e-3;
  testrel(20, NE, y, f, cnt,failed);

  x := 1e10;
  y := ci(x);
  f := -0.4875060251748226538e-10;
  testrel(21, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_cin;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','cin');

  {cin := x-> ln(x)+evalf(gamma)-Ci(x);}

  x := 0;
  y := cin(x);
  f := 0;
  testrel( 1, NE, y, f, cnt,failed);

  x := 3e-10;
  y := cin(x);
  f := 0.225e-19;
  testrel( 2, NE, y, f, cnt,failed);

  x := 9.0e-10;
  y := cin(x);
  f := 0.2025e-18;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.0009765625;
  y := cin(x);
  f := 0.23841856962765955731e-6;
  testrel( 4, NE, y, f, cnt,failed);

  x := -0.125;
  y := cin(x);
  f := 0.39037077513365972207e-2;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.5;
  y := cin(x);
  f := 0.618525631482004525251e-1;
  testrel( 6, NE, y, f, cnt,failed);

  x := -1.0;
  y := cin(x);
  f := 0.23981174200056472595;
  testrel( 7, NE, y, f, cnt,failed);

  x := 2.0;
  y := cin(x);
  f := 0.84738201668661317430;
  testrel( 8, NE, y, f, cnt,failed);

  x := 4.0;
  y := cin(x);
  f := 2.1044917239083538910;
  testrel( 9, NE, y, f, cnt,failed);

  x := 6.0;
  y := cin(x);
  f := 2.4370323780228349876;
  testrel(10, NE, y, f, cnt,failed);

  x := 6.125;
  y := cin(x);
  f := 2.4375465091797009492;
  testabs(11, NE, y, f, cnt,failed);

  x := 7.0;
  y := cin(x);
  f := 2.4464305354746616473;
  testrel(12, NE, y, f, cnt,failed);

  x := -12.0;
  y := cin(x);
  f := 3.1119023215736468464;
  testrel(13, NE, y, f, cnt,failed);

  x := -13.0;
  y := cin(x);
  f := 3.1154008967990350417;
  testrel(14, NE, y, f, cnt,failed);

  x := 56.0;
  y := cin(x);
  f := 4.6121464046951505440;
  testrel(15, NE, y, f, cnt,failed);

  x := 57.0;
  y := cin(x);
  f := 4.6128960715754944416;
  testrel(16, NE, y, f, cnt,failed);

  x := 100.0;
  y := cin(x);
  f := 5.1875346760322347207;
  testrel(17, NE, y, f, cnt,failed);

  x := 10000.0;
  y := cin(x);
  f := 9.7875865887944400819;
  testrel(18, NE, y, f, cnt,failed);

  x := 1e10;
  y := cin(x);
  f := 23.603066594890740304;
  testrel(19, NE, y, f, cnt,failed);

  x := 1e100;
  y := cin(x);
  f := 230.83572496430610126;
  testrel(20, NE, y, f, cnt,failed);

  x := 1e308;
  y := cin(x);
  f := 709.77342430706760354;
  testrel(21, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_cinh;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','cinh');

  x := 0;
  y := cinh(x);
  f := 0;
  testrel( 1, NE, y, f, cnt,failed);

  x := 3e-10;
  y := cinh(x);
  f := 0.225e-19;
  testrel( 2, NE, y, f, cnt,failed);

  x := 9.0e-10;
  y := cinh(x);
  f := 0.2025e-18;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.0009765625;
  y := cinh(x);
  f := 0.238418588575465844246e-6;
  testrel( 4, NE, y, f, cnt,failed);

  x := -0.125;
  y := cinh(x);
  f := 0.390879401472700300929e-2;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.250;
  y := cinh(x);
  f := 0.15665746665531796193e-1;
  testrel( 6, NE, y, f, cnt,failed);

  x := -1.0;
  y := cinh(x);
  f := 0.26065127607867538028;
  testabs( 7, NE, y, f, cnt,failed);

  x := 3.0;
  y := cinh(x);
  f := 3.2845641411959672083;
  testrel( 8, NE, y, f, cnt,failed);

  x := 6.0;
  y := cinh(x);
  f := 40.625725895863933210;
  testrel( 9, NE, y, f, cnt,failed);

  x := 6.0009765625;
  y := cinh(x);
  f := 40.658407832346171103;
  testrel(10, NE, y, f, cnt,failed);

  x := -9.9990234375;
  y := cinh(x);
  f := 1242.1597444147576618;
  testrel(11, NE, y, f, cnt,failed);

  x := -10.0;
  y := cinh(x);
  f := 1243.2346852845588361;
  testrel(12, NE, y, f, cnt,failed);

  x := -10.0009765625;
  y := cinh(x);
  f := 1244.3105714373192462;
  testrel(13, NE, y, f, cnt,failed);

  x := 19.9990234375;
  y := cinh(x);
  f := 12795983.398461024404;
  testrel(14, NE, y, f, cnt,failed);

  x := 20.0;
  y := cinh(x);
  f := 12807822.759080355905;
  testrel(15, NE, y, f, cnt,failed);

  x := 20.0009765625;
  y := cinh(x);
  f := 12819673.108578153597;
  testrel(16, NE, y, f, cnt,failed);

  x := 39.9990234375;
  y := cinh(x);
  f := 3016987143993591.4032;
  testrel(17, NE, y, f, cnt,failed);

  x := 40.0;
  y := cinh(x);
  f := 3019859131805616.5231;
  testrel(18, NE, y, f, cnt,failed);

  x := 40.0009765625;
  y := cinh(x);
  f := 3022733855478615.6952;
  testrel(19, NE, y, f, cnt,failed);

  x := 100.0;
  y := cinh(x);
  f := 0.13577763724269399110e42;
  testrel(20, NE, y, f, cnt,failed);

  x := 400.0;
  y := chi(x);
  f := 0.65432364085371386712e171;
  testrel(21, NE, y, f, cnt,failed);

  x := 716.0;
  y := chi(x);
  f := 0.630251455302044677765e308;
  testrel(22, NE, y, f, cnt,failed);

  x := 718;
  y := chi(x);
  f := PosInf_d;
  testabs(23, 1, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_si;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','si');

  x := 0.0;
  y := si(x);
  f := 0;
  testabs( 1, 1, y, f, cnt,failed);

  x := 1e-15;
  y := si(x);
  f := x;
  testrel( 2, NE, y, f, cnt,failed);

  x := -1e-7;
  y := si(x);
  f := -0.9999999999999994444e-7;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.9e-5;
  y := si(x);
  f := 0.8999999999959500000e-5;
  testrel( 4, NE, y, f, cnt,failed);

  x := -1.05e-5;
  y := si(x);
  f := -0.1049999999993568750e-4;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.015625;
  y := si(x);
  f := 0.1562478807392632979e-1;
  testrel( 6, NE, y, f, cnt,failed);

  x := -0.25;
  y := si(x);
  f := -0.2491335703197571641;
  testrel( 7, NE, y, f, cnt,failed);

  x := 1.0;
  y := si(x);
  f := 0.9460830703671830150;
  testrel( 8, NE, y, f, cnt,failed);

  x := -2.0;
  y := si(x);
  f := -1.6054129768026948486;
  testrel( 9, NE, y, f, cnt,failed);

  x := 3.9990234375;
  y := si(x);
  f := 1.758387849778959366;
  testrel(10, NE, y, f, cnt,failed);

  x := -4.0;
  y := si(x);
  f := -1.758203138949053058;
  testrel(11, NE, y, f, cnt,failed);

  x := 4.0009765625;
  y := si(x);
  f := 1.758018317387305653;
  testrel(12, NE, y, f, cnt,failed);

  x := -5.0;
  y := si(x);
  f := -1.549931244944674137;
  testrel(13, NE, y, f, cnt,failed);

  x := 8.0;
  y := si(x);
  f := 1.574186821706942052;
  testrel(14, NE, y, f, cnt,failed);

  x := -15.0;
  y := si(x);
  f := -1.618194443708368739;
  testrel(15, NE, y, f, cnt,failed);

  x := 1e10;
  y := si(x);
  f := 1.570796326707584657;
  testrel(16, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ssi;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2 = 8;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','ssi');

  x := 0.0;
  y := ssi(x);
  f := -Pi_2;
  testabs( 1, 1, y, f, cnt,failed);

  x := 1e-15;
  y := ssi(x);
  f := -1.570796326794895619;
  testrel( 2, NE, y, f, cnt,failed);

  x := -1e-7;
  y := ssi(x);
  f := -1.570796426794896619;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.9e-5;
  y := ssi(x);
  f := -1.570787326794896660;
  testrel( 4, NE, y, f, cnt,failed);

  x := -1.05e-5;
  y := ssi(x);
  f := -1.570806826794896555;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.015625;
  y := ssi(x);
  f := -1.555171538720970289;
  testrel( 6, NE, y, f, cnt,failed);

  x := -0.25;
  y := ssi(x);
  f := -1.819929897114653783;
  testrel( 7, NE, y, f, cnt,failed);

  x := 1.0;
  y := ssi(x);
  f := -0.6247132564277136043;
  testrel( 8, NE, y, f, cnt,failed);

  x := 1.9264476603173705820;
  y := ssi(x);
  f := -0.111405491355682719e-19;
  testabs( 9, 1, y, f, cnt,failed);

  x := 1.9264;
  y := ssi(x);
  f := -0.231922614083280179e-4;
  testabs(10, 1, y, f, cnt,failed);

  x := 1.9265;
  y := ssi(x);
  f := 0.2546818023174051571e-4;
  testabs(11, 1, y, f, cnt,failed);

  x := 2.176;
  y := ssi(x);
  f := 0.1078833303776372;
  testabs(12, NE, y, f, cnt,failed);

  x := 2.177;
  y := ssi(x);
  f := 0.1082610476638330915;
  testabs(13, NE, y, f, cnt,failed);

  x := 1.676;
  y := ssi(x);
  f := -0.1353244503132861735;
  testabs(14, NE, y, f, cnt,failed);

  x := 1.677;
  y := ssi(x);
  f := -0.1347312987714802452;
  testabs(15, NE, y, f, cnt,failed);

  x := 3.9990234375;
  y := ssi(x);
  f := 0.1875915229840627467;
  testrel(16, NE2, y, f, cnt,failed);

  x := -4.0;
  y := ssi(x);
  f := -3.328999465743949677;
  testrel(17, NE, y, f, cnt,failed);

  x := 4.0009765625;
  y := ssi(x);
  f := 0.1872219905924090342;
  testrel(18, NE, y, f, cnt,failed);

  x := 4.8938359526166018016;
  y := ssi(x);
  f := 0.4358276613479410518e-20;
  testabs(19, 1, y, f, cnt,failed);

  x := -5.0;
  y := ssi(x);
  f := -3.120727571739570757;
  testrel(20, NE, y, f, cnt,failed);

  x := 8.0;
  y := ssi(x);
  f := 0.3390494912045432852e-2;
  testrel(21, NE2, y, f, cnt,failed);   {!!64-bit}

  x := -15.0;
  y := ssi(x);
  f := -3.188990770503265358;
  testrel(22, NE, y, f, cnt,failed);

  x := 1e10;
  y := ssi(x);
  f := -0.8731196226281053987e-10;
  testrel(23, NE, y, f, cnt,failed);

  x := -1e10;
  y := ssi(x);
  f := -3.1415926535024812762;
  testrel(24, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_ei_inv;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','ei_inv');

  f := 700;
  x := ei(f);
  y := ei_inv(x);
  testrel(1, NE, y, f, cnt,failed);

  f := 0.001953125;
  x := ei(f);
  y := ei_inv(x);
  testrel(2, NE, y, f, cnt,failed);

  x := -1.5;
  y := ei_inv(x);
  f := 0.1116824805322902507;
  testrel(3, NE, y, f, cnt,failed);

  x := -2;
  y := ei_inv(x);
  f := 0.7070820325089491156e-1;
  testrel(4, NE, y, f, cnt,failed);

  x := -4;
  y := ei_inv(x);
  {f:= 0.10179079377300351405e-1;}
  f := 0.2035815875460070281e-1*0.5;
  testrel(5, NE, y, f, cnt,failed);

  x := -10;
  y := ei_inv(x);
  f := 0.2548957138774709426e-4;
  testrel(6, NE, y, f, cnt,failed);

  x := -20;
  y := ei_inv(x);
  f := 0.1157254247067129905e-8;
  testrel(7, NE, y, f, cnt,failed);

  x := -40;
  y := ei_inv(x);
  f := 0.2385278786185194590e-17;
  testrel(8, NE, y, f, cnt,failed);

  x := -50;
  y := ei_inv(x);
  f := 0.1082914893567529566e-21;
  testrel(9, NE, y, f, cnt,failed);

  x := 1e-5;
  y := ei_inv(x);
  f := 0.3725099773799074235;
  testrel(10, NE, y, f, cnt,failed);

  x := 1e-8;
  y := ei_inv(x);
  f := 0.3725074133479596325;
  testrel(11, NE, y, f, cnt,failed);

  x := 1e-10;
  y := ei_inv(x);
  f := 0.3725074108070325644;
  testrel(12, NE, y, f, cnt,failed);

  x := -1e-7;
  y := ei_inv(x);
  f := 0.3725073851154372641;
  testrel(13, NE, y, f, cnt,failed);

  x := -1e-11;
  y := ei_inv(x);
  f := 0.3725074107788000415;
  testrel(14, NE, y, f, cnt,failed);

  x := 0.5;
  y := ei_inv(x);
  f := 0.5139789904809404574;
  testrel(15, NE, y, f, cnt,failed);

  x := 1;
  y := ei_inv(x);
  f := 0.6775499178144678440;
  testrel(16, NE, y, f, cnt,failed);

  x := 10;
  y := ei_inv(x);
  f := 3.009850414759061250;
  testrel(17, NE, y, f, cnt,failed);

  x := 1000;
  y := ei_inv(x);
  f := 8.957122361339663031;
  testrel(18, NE, y, f, cnt,failed);

  x := 1e300;
  y := ei_inv(x);
  f := 697.3213370748042106;
  testrel(19, NE, y, f, cnt,failed);

  x := -700;
  y := ei_inv(x);
  f := 0.5535808900395892233e-304;
  testrel(20, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);

end;


end.
