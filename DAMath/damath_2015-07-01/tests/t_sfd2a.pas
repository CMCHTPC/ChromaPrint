{Part 2a of regression test for SPECFUNX unit  (c) 2010  W.Ehrhardt}

unit t_sfd2a;

{$i STD.INC}

{$ifdef BIT16}
  {$N+}
  {$ifndef Windows}
    {$O+}
  {$endif}
{$endif}

interface


procedure test_sncndn;
procedure test_jacobiPQ;
procedure test_theta1p;
procedure test_theta2;
procedure test_theta3;
procedure test_theta4;
procedure test_jacobi_theta;
procedure test_jacobi_theta_relations;
procedure test_EllipticModulus;
procedure test_EllipticNome;
procedure test_jacobi_am;


implementation

uses
  damath, specfund, t_sfd0;

{---------------------------------------------------------------------------}
procedure test_sncndn;
var
  sn,cn,dn,mc,sf,cf,df: double;
  cnt, failed: integer;
const
  NE = 8;
  NE1 = 16;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','sncndn');

  sncndn(0.0,0.0,sn,cn,dn);
  sf := tanh(0.0);
  cf := sech(0.0);
  df := cf;
  testrel( 1, NE, sn, sf, cnt,failed);
  testrel( 2, NE, cn, cf, cnt,failed);
  testrel( 3, NE, dn, df, cnt,failed);

  sncndn(0.5,0.0,sn,cn,dn);
  sf := tanh(0.5);
  cf := sech(0.5);
  df := cf;
  testrel( 4, NE, sn, sf, cnt,failed);
  testrel( 5, NE, cn, cf, cnt,failed);
  testrel( 6, NE, dn, df, cnt,failed);

  sncndn(-8,0.0,sn,cn,dn);
  sf := tanh(-8);
  cf := sech(-8);
  df := cf;
  testrel( 7, NE, sn, sf, cnt,failed);
  testrel( 8, NE, cn, cf, cnt,failed);
  testrel( 9, NE, dn, df, cnt,failed);

  sncndn(0.1,1.0,sn,cn,dn);
  sf := sin(0.1);
  cf := cos(0.1);
  df := 1;
  testrel(10, NE, sn, sf, cnt,failed);
  testrel(11, NE, cn, cf, cnt,failed);
  testrel(12, NE, dn, df, cnt,failed);

  sncndn(2.0,1.0,sn,cn,dn);
  sf := sin(2);
  cf := cos(2);
  df := 1;
  testrel(13, NE, sn, sf, cnt,failed);
  testrel(14, NE, cn, cf, cnt,failed);
  testrel(15, NE, dn, df, cnt,failed);

  sncndn(-8,1.0,sn,cn,dn);
  sf := sin(-8);
  cf := cos(-8);
  df := 1;
  testrel(16, NE, sn, sf, cnt,failed);
  testrel(17, NE, cn, cf, cnt,failed);
  testrel(18, NE, dn, df, cnt,failed);

  {for mc the period is 4*EllipticCK(sqrt(mc))}

  {mc=0.125, Period = 9.8943846950053756480}
  mc := 0.125;
  sncndn(0.0,mc,sn,cn,dn);
  sf := 0;
  cf := 1;
  df := 1;
  testrel(19, NE, sn, sf, cnt,failed);
  testrel(20, NE, cn, cf, cnt,failed);
  testrel(21, NE, dn, df, cnt,failed);

  sncndn(0.1,mc,sn,cn,dn);
  sf := 0.09968866355781217576;
  cf := 0.9950186783965702674;
  df := 0.9956427065284514824;
  testrel(22, NE, sn, sf, cnt,failed);
  testrel(23, NE, cn, cf, cnt,failed);
  testrel(24, NE, dn, df, cnt,failed);

  sncndn(4.947192347502688,mc,sn,cn,dn);
  sf := -0.1760488204945514076e-15;
  cf := -1;
  df :=  1;
  testabs(25, NE, sn, sf, cnt,failed);
  testrel(26, NE, cn, cf, cnt,failed);
  testrel(27, NE, dn, df, cnt,failed);

  sncndn(2.4735961737513439120,mc,sn,cn,dn);
  sf :=  1.0;
  cf :=  0.0;
  df :=  0.3535533905932737622;
  testrel(28, NE, sn, sf, cnt,failed);
  testabs(29, NE, cn, cf, cnt,failed);
  testrel(30, NE, dn, df, cnt,failed);

  sncndn(6,mc,sn,cn,dn);
  sf := -0.7945156446468059922;
  cf := -0.6072436828913663595;
  df :=  0.6690678434284796181;
  testrel(31, NE, sn, sf, cnt,failed);
  testrel(32, NE, cn, cf, cnt,failed);
  testrel(33, NE, dn, df, cnt,failed);

  sncndn(-9,mc,sn,cn,dn);
  sf := 0.7220999653088034001;
  cf := 0.6917887250461841158;
  df := 0.7373941856893074326;
  testrel(34, NE, sn, sf, cnt,failed);
  testrel(35, NE, cn, cf, cnt,failed);
  testrel(36, NE, dn, df, cnt,failed);

  {mc=0.5, Period = 7.4162987092054876736}
  mc := 0.5;
  sncndn(0.1,mc,sn,cn,dn);
  sf := 0.9975068547462483814e-1;
  cf := 0.9950124626090582135;
  df := 0.9975093485144243172;
  testrel(37, NE, sn, sf, cnt,failed);
  testrel(38, NE, cn, cf, cnt,failed);
  testrel(39, NE, dn, df, cnt,failed);

  sncndn(0.5,mc,sn,cn,dn);
  sf := 0.4707504736556572833;
  cf := 0.8822663948904402865;
  df := 0.9429724257773856872;
  testrel(40, NE, sn, sf, cnt,failed);
  testrel(41, NE, cn, cf, cnt,failed);
  testrel(42, NE, dn, df, cnt,failed);

  sncndn(3.7081493546027438368,mc,sn,cn,dn);
  sf := 0;
  cf := -1;
  df := 1;
  testabs(43, 12, sn, sf, cnt,failed);
  testrel(44, NE, cn, cf, cnt,failed);
  testrel(45, NE, dn, df, cnt,failed);

  sncndn(1.8540746773013719184,mc,sn,cn,dn);
  sf := 1.0;
  cf := 0.0;
  df := 0.7071067811865475244;
  testrel(46, NE, sn, sf, cnt,failed);
  testabs(47, NE, cn, cf, cnt,failed);
  testrel(48, NE, dn, df, cnt,failed);

  sncndn(6,mc,sn,cn,dn);
  sf := -0.95097416414900458748;
  cf :=  0.30927033339960378034;
  df :=  0.74015138286741789944;
  testrel(49, NE, sn, sf, cnt,failed);
  testrel(50, NE1, cn, cf, cnt,failed);  {!!!!}
  testrel(51, NE, dn, df, cnt,failed);

  sncndn(-9,mc,sn,cn,dn);
  sf := -0.9815594125425860271;
  cf :=  0.1911573164936498376;
  df :=  0.7199101053774191230;
  testrel(52, NE, sn, sf, cnt,failed);
  testrel(53, NE1, cn, cf, cnt,failed);   {!!!!}
  testrel(54, NE, dn, df, cnt,failed);

  {mc=0.96875, Period = 6.3331547416016978712}
  mc := 0.96875;
  sncndn(0.1,mc,sn,cn,dn);
  sf := 0.9982824476700707379e-1;
  cf := 0.9950046841833150510;
  df := 0.9998442741488974386;
  testrel(55, NE, sn, sf, cnt,failed);
  testrel(56, NE, cn, cf, cnt,failed);
  testrel(57, NE, dn, df, cnt,failed);

  sncndn(0.5,mc,sn,cn,dn);
  sf := 0.4788821690724167707;
  cf := 0.8778791876702039908;
  df := 0.9964103049846059971;
  testrel(58, NE, sn, sf, cnt,failed);
  testrel(59, NE, cn, cf, cnt,failed);
  testrel(60, NE, dn, df, cnt,failed);

  sncndn(3.1665773708008489356,mc,sn,cn,dn);
  sf := 0;
  cf := -1;
  df := 1;
  testabs(61, NE, sn, sf, cnt,failed);
  testrel(62, NE, cn, cf, cnt,failed);
  testrel(63, NE, dn, df, cnt,failed);

  sncndn(1.5832886854004244678,mc,sn,cn,dn);
  sf := 1.0;
  cf := 0.0;
  df := 0.9842509842514763775;
  testrel(64, NE, sn, sf, cnt,failed);
  testabs(65, NE, cn, cf, cnt,failed);
  testrel(66, NE, dn, df, cnt,failed);

  sncndn(6,mc,sn,cn,dn);
  sf := -0.3268479482165394136;
  cf :=  0.9450769380037999689;
  df :=  0.9983293923279192169;
  testrel(67, NE, sn, sf, cnt,failed);
  testrel(68, NE, cn, cf, cnt,failed);
  testrel(69, NE, dn, df, cnt,failed);

  sncndn(-9,mc,sn,cn,dn);
  sf := -0.4786478228540195127;
  cf := -0.8780069827040711844;
  df :=  0.9964138237586879237;
  testrel(70, NE, sn, sf, cnt,failed);
  testrel(71, NE, cn, cf, cnt,failed);
  testrel(72, NE, dn, df, cnt,failed);

  mc := -0.1;
  sncndn(0.1,mc,sn,cn,dn);
  sf := 0.996514612926372326e-1;
  cf := 0.995022404904654407;
  df := 0.994523275186893867;
  testrel(73, NE, sn, sf, cnt,failed);
  testrel(74, NE, cn, cf, cnt,failed);
  testrel(75, NE, dn, df, cnt,failed);

  mc := -3;
  sncndn(0.25,mc,sn,cn,dn);
  sf := 0.237541468014268255;
  cf := 0.971377398838178843;
  df := 0.879941022963758342;
  testrel(76, NE, sn, sf, cnt,failed);
  testrel(77, NE, cn, cf, cnt,failed);
  testrel(78, NE, dn, df, cnt,failed);

  mc := 2;
  sncndn(0.5,mc,sn,cn,dn);
  sf := 0.4968911904193119386;
  cf := 0.8678128513012924283;
  df := 0.1116647148886487292e1;
  testrel(79, NE, sn, sf, cnt,failed);
  testrel(80, NE, cn, cf, cnt,failed);
  testrel(81, NE, dn, df, cnt,failed);

  mc := 1-ldexpd(1,-40);
  sncndn(0.4,mc,sn,cn,dn);
  sf := 0.3894183423086418378;
  cf := 0.9210609940028887416;
  df := 0.9999999999999310391;
  testrel(82, NE, sn, sf, cnt,failed);
  testrel(83, NE, cn, cf, cnt,failed);
  testrel(84, NE, dn, df, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_jacobiPQ;
var
  x,y,f,k: double;
  cnt, failed: integer;
const
  NE = 8;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','jacobiPQ');

  k := 0.75;
  x := 0.125;
  f := 0.1244936999102105350;
  y := jacobi_sn(x,k);
  testrel(1, NE, y, f, cnt,failed);

  x := -1;
  f := -0.797975985021689778;
  y := jacobi_sn(x,k);
  testrel(2, NE, y, f, cnt,failed);

  x := 2;
  f := 0.99826481102389918;
  y := jacobi_sn(x,k);
  testrel(3, NE, y, f, cnt,failed);

  x := -4;
  f := 0.1765648083045932601;
  y := jacobi_sn(x,k);
  testrel(4, NE, y, f, cnt,failed);

  x := 16;
  f := 0.6301663058735622082;
  y := jacobi_sn(x,k);
  testrel(5, NE, y, f, cnt,failed);

  k := 2;
  x := 0.125;
  f := 0.1233907025680708002;
  y := jacobi_sn(x,k);
  testrel(6, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.4113177890649311798;
  y := jacobi_sn(x,k);
  testrel(7, NE, y, f, cnt,failed);

  x := -1;
  f := -0.4814490887991387213;
  y := jacobi_sn(x,k);
  testrel(8, NE, y, f, cnt,failed);

  x := 2;
  f := -0.2901000599068370801;
  y := jacobi_sn(x,k);
  testrel(9, NE, y, f, cnt,failed);

  x := -5;
  f := -0.5709506173037516634e-1;
  y := jacobi_sn(x,k);
  testrel(10, NE, y, f, cnt,failed);

  y := jacobi_sn(0.5,1);
  f := 0.4621171572600097585;
  testrel(11, NE, y, f, cnt,failed);

  y := jacobi_sn(10,0);
  f := -0.5440211108893698134;
  testrel(12, NE, y, f, cnt,failed);

  k := 0.75;
  x := 0.125;
  f := 0.9922203982395576841;
  y := jacobi_cn(x,k);
  testrel(13, NE, y, f, cnt,failed);

  x := -1;
  f := 0.6026892460701982125;
  y := jacobi_cn(x,k);
  testrel(14, NE, y, f, cnt,failed);

  x := 2;
  f := -0.5888435336673791435e-1;
  y := jacobi_cn(x,k);
  testrel(15, NE, y, f, cnt,failed);

  x := -4;
  f := -0.9842890167366301741;
  y := jacobi_cn(x,k);
  testrel(16, NE, y, f, cnt,failed);

  x := 16;
  f := 0.7764601901847048568;
  y := jacobi_cn(x,k);
  testrel(17, NE, y, f, cnt,failed);

  k := 2;
  x := 0.125;
  f := 0.992358168465276395;
  y := jacobi_cn(x,k);
  testrel(18, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.9114920056691319003;
  y := jacobi_cn(x,k);
  testrel(19, NE, y, f, cnt,failed);

  x := -1;
  f := 0.8764740583123262287;
  y := jacobi_cn(x,k);
  testrel(20, NE, y, f, cnt,failed);

  x := 2;
  f := 0.956996319346134966;
  y := jacobi_cn(x,k);
  testrel(21, NE, y, f, cnt,failed);

  x := -5;
  f := 0.9983687464689610611;
  y := jacobi_cn(x,k);
  testrel(22, NE, y, f, cnt,failed);

  y := jacobi_cn(0.5,1);
  f := 0.8868188839700739087;
  testrel(23, NE, y, f, cnt,failed);

  y := jacobi_cn(10,0);
  f := -0.8390715290764524523;
  testrel(24, NE, y, f, cnt,failed);


  k := 0.75;
  x := 0.125;
  f := 0.995631453781468214;
  y := jacobi_dn(x,k);
  testrel(25, NE, y, f, cnt,failed);

  x := -1;
  f := 0.8011362612704367294;
  y := jacobi_dn(x,k);
  testrel(26, NE, y, f, cnt,failed);

  x := 2;
  f := 0.6629105474931539419;
  y := jacobi_dn(x,k);
  testrel(27, NE, y, f, cnt,failed);

  x := -4;
  f := 0.9911932145214946724;
  y := jacobi_dn(x,k);
  testrel(28, NE, y, f, cnt,failed);

  x := 16;
  f := 0.8812637886323755391;
  y := jacobi_dn(x,k);
  testrel(29, NE, y, f, cnt,failed);

  k := 2;
  x := 0.125;
  f := 0.9690711728655597276;
  y := jacobi_dn(x,k);
  testrel(30, NE, y, f, cnt,failed);

  x := 0.5;
  f := 0.5685689980951714899;
  y := jacobi_dn(x,k);
  testrel(31, NE, y, f, cnt,failed);

  x := -1;
  f := -0.2698649654510865793;
  y := jacobi_dn(x,k);
  testrel(32, NE, y, f, cnt,failed);

  x := 2;
  f := -0.8144739535234985949;
  y := jacobi_dn(x,k);
  testrel(33, NE, y, f, cnt,failed);

  x := -5;
  f := -0.9934589149552278271;
  y := jacobi_dn(x,k);
  testrel(34, NE, y, f, cnt,failed);

  y := jacobi_dn(0.5,1);
  f := 0.8868188839700739087;
  testrel(35, NE, y, f, cnt,failed);

  y := jacobi_dn(10,0);
  f := 1;
  testrel(36, NE, y, f, cnt,failed);

  x := 2;
  k := 0.0000152587890625;
  y := jacobi_sn(x,k);  f :=  0.9092974268832935517227;    testrel(37, NE, y, f, cnt,failed);
  y := jacobi_cn(x,k);  f := -0.4161468364212581843044;    testrel(38, NE, y, f, cnt,failed);
  y := jacobi_dn(x,k);  f :=  0.9999999999037452728284;    testrel(39, NE, y, f, cnt,failed);
  y := jacobi_nc(x,k);  f := -2.402997962449286629807 ;    testrel(40, NE, y, f, cnt,failed);
  y := jacobi_sc(x,k);  f := -2.185039864060933593054 ;    testrel(41, NE, y, f, cnt,failed);
  y := jacobi_dc(x,k);  f := -2.402997962217986716538 ;    testrel(42, NE, y, f, cnt,failed);
  y := jacobi_nd(x,k);  f :=  1.000000000096254727181 ;    testrel(43, NE, y, f, cnt,failed);
  y := jacobi_sd(x,k);  f :=  0.9092974269708177274736;    testrel(44, NE, y, f, cnt,failed);
  y := jacobi_cd(x,k);  f := -0.4161468364613142845113;    testrel(45, NE, y, f, cnt,failed);
  y := jacobi_ns(x,k);  f :=  1.099750170224937781947 ;    testrel(46, NE, y, f, cnt,failed);
  y := jacobi_cs(x,k);  f := -0.4576575541928480261514;    testrel(47, NE, y, f, cnt,failed);
  y := jacobi_ds(x,k);  f :=  1.099750170119081629355 ;    testrel(48, NE, y, f, cnt,failed);
  x := -1;
  k := 0.9999847412109375;
  y := jacobi_sn(x,k);  f := -0.7615967622837341757958;    testrel(49, NE, y, f, cnt,failed);
  y := jacobi_cn(x,k);  f :=  0.6480512106916653981179;    testrel(50, NE, y, f, cnt,failed);
  y := jacobi_dn(x,k);  f :=  0.6480648676200413565936;    testrel(51, NE, y, f, cnt,failed);
  y := jacobi_nc(x,k);  f :=  1.543087928086268790223 ;    testrel(52, NE, y, f, cnt,failed);
  y := jacobi_sc(x,k);  f := -1.175210769949617948752 ;    testrel(53, NE, y, f, cnt,failed);
  y := jacobi_dc(x,k);  f :=  1.000021073841311680336 ;    testrel(54, NE, y, f, cnt,failed);
  y := jacobi_nd(x,k);  f :=  1.543055409981423711858 ;    testrel(55, NE, y, f, cnt,failed);
  y := jacobi_sd(x,k);  f := -1.175186004266252334060 ;    testrel(56, NE, y, f, cnt,failed);
  y := jacobi_cd(x,k);  f :=  0.9999789266027857484552;    testrel(57, NE, y, f, cnt,failed);
  y := jacobi_ns(x,k);  f := -1.313030792044581054068 ;    testrel(58, NE, y, f, cnt,failed);
  y := jacobi_cs(x,k);  f := -0.8509111944599270915524;    testrel(59, NE, y, f, cnt,failed);
  y := jacobi_ds(x,k);  f := -0.8509291264274094724238;    testrel(60, NE, y, f, cnt,failed);

  x := 2.5;
  k := 0.5;
  y := jacobi_sn(x,k);  f :=  0.7499030499017841436689;    testrel(61, NE, y, f, cnt,failed);
  y := jacobi_cn(x,k);  f := -0.6615477426066861279252;    testrel(62, NE, y, f, cnt,failed);
  y := jacobi_dn(x,k);  f :=  0.9270444185350562586642;    testrel(63, NE, y, f, cnt,failed);
  y := jacobi_nc(x,k);  f := -1.511606699857693995904 ;    testrel(64, NE, y, f, cnt,failed);
  y := jacobi_sc(x,k);  f := -1.133558474475255547033 ;    testrel(65, NE, y, f, cnt,failed);
  y := jacobi_dc(x,k);  f := -1.401326554123271238653 ;    testrel(66, NE, y, f, cnt,failed);
  y := jacobi_nd(x,k);  f :=  1.078696964251432921173 ;    testrel(67, NE, y, f, cnt,failed);
  y := jacobi_sd(x,k);  f :=  0.8089181434119453683926;    testrel(68, NE, y, f, cnt,failed);
  y := jacobi_cd(x,k);  f := -0.7136095416572206537131;    testrel(69, NE, y, f, cnt,failed);
  y := jacobi_ns(x,k);  f :=  1.333505711346248565548 ;    testrel(70, NE, y, f, cnt,failed);
  y := jacobi_cs(x,k);  f := -0.8821776930942339352916;    testrel(71, NE, y, f, cnt,failed);
  y := jacobi_ds(x,k);  f :=  1.236219026788159574752 ;    testrel(72, NE, y, f, cnt,failed);

  x := -1.25;
  k := 0.0;
  y := jacobi_sn(x,k);  f := -0.9489846193555862143485;    testrel(73, NE, y, f, cnt,failed);
  y := jacobi_cn(x,k);  f :=  0.3153223623952686654475;    testrel(74, NE, y, f, cnt,failed);
  y := jacobi_dn(x,k);  f :=  1.0                     ;    testrel(75, NE, y, f, cnt,failed);
  y := jacobi_nc(x,k);  f :=  3.171357693770103360848 ;    testrel(76, NE, y, f, cnt,failed);
  y := jacobi_sc(x,k);  f := -3.009569673862831288158 ;    testrel(77, NE, y, f, cnt,failed);
  y := jacobi_dc(x,k);  f :=  3.171357693770103360848 ;    testrel(78, NE, y, f, cnt,failed);
  y := jacobi_nd(x,k);  f :=  1.0                     ;    testrel(79, NE, y, f, cnt,failed);
  y := jacobi_sd(x,k);  f := -0.9489846193555862143485;    testrel(80, NE, y, f, cnt,failed);
  y := jacobi_cd(x,k);  f :=  0.3153223623952686654475;    testrel(81, NE, y, f, cnt,failed);
  y := jacobi_ns(x,k);  f := -1.053757858245432987725 ;    testrel(82, NE, y, f, cnt,failed);
  y := jacobi_cs(x,k);  f := -0.3322734172545285677357;    testrel(83, NE, y, f, cnt,failed);
  y := jacobi_ds(x,k);  f := -1.053757858245432987725 ;    testrel(84, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_theta2;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE2= 4;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','theta2');

  x := 0.0;
  y := theta2(x);
  f := 0;
  testrel( 1, 1, y, f, cnt,failed);

  x := 1e-300;
  y := theta2(x);
  f := 2e-75;
  testrel( 2, NE, y, f, cnt,failed);

  x := 2.401e-9;
  y := theta2(x);
  f := 0.1400000000000000008e-1;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.0001;
  y := theta2(x);
  f := 0.200000002;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.001953125;
  y := theta2(x);
  f := 0.4204498115094852660;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.0001;
  y := theta2(x);
  f := 0.200000002;
  testrel( 6, NE, y, f, cnt,failed);

  x := 0.615614429107944095761e-1;
  y := theta2(x);
  f := 1;
  testrel( 7, NE, y, f, cnt,failed);

  x := 0.0625;
  y := theta2(x);
  f := 1.003906309604648328;
  testrel( 8, NE, y, f, cnt,failed);

  x := 0.1;
  y := theta2(x);
  f := 1.135930601568280206;
  testrel( 9, NE, y, f, cnt,failed);

  x := 0.125;
  y := theta2(x);
  f := 1.207793012657073688;
  testrel(10, NE, y, f, cnt,failed);

  x := 0.25;
  y := theta2(x);
  f := 1.502947261299397976;
  testrel(11, NE, y, f, cnt,failed);

  x := 0.5;
  y := theta2(x);
  f := 2.128931250513027559;
  testrel(12, NE, y, f, cnt,failed);

  x := 0.75;
  y := theta2(x);
  f := 3.304597249065604318;
  testrel(13, NE, y, f, cnt,failed);

  x := 0.9;
  y := theta2(x);
  f := 5.460545027060618043;
  testrel(14, NE, y, f, cnt,failed);

  x := 0.99;
  y := theta2(x);
  f := 17.68009722441707442;
  testrel(15, NE2, y, f, cnt,failed);

  x := 0.9990234375;
  y := theta2(x);
  f := 56.70467198706624908;
  testrel(16, NE, y, f, cnt,failed);

  x := 0.99993896484375;
  y := theta2(x);
  f := 226.8706310303493719;
  testrel(17, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_theta3;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 4;
  NE2= 40;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','theta3');

  x := 0.0;
  y := theta3(x);
  f := 1;
  testrel( 1, 1, y, f, cnt,failed);

  x := 1e-10;
  y := theta3(x);
  f := 1.0000000002;
  testrel( 2, NE, y, f, cnt,failed);

  x := -1e-10;
  y := theta3(x);
  f := 0.9999999998;
  testrel( 3, NE, y, f, cnt,failed);

  x := 0.0001;
  y := theta3(x);
  f := 1.0002000000000002;
  testrel( 4, NE, y, f, cnt,failed);

  x := -0.0001;
  y := theta3(x);
  f := 0.9998000000000002;
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.0625;
  y := theta3(x);
  f := 1.125030517607228831;
  testrel( 6, NE, y, f, cnt,failed);

  x := -0.0625;
  y := theta3(x);
  f := 0.8750305175490211697;
  testrel( 7, NE, y, f, cnt,failed);

  x := 0.1;
  y := theta3(x);
  f := 1.2002000020000002;
  testrel( 8, NE, y, f, cnt,failed);

  x := -0.1;
  y := theta3(x);
  f := 0.8001999980000002;
  testrel( 9, NE, y, f, cnt,failed);

  x := 0.125;
  y := theta3(x);
  f := 1.250488296151168299;
  testrel(10, NE, y, f, cnt,failed);

  x := -0.125;
  y := theta3(x);
  f := 0.7504882663488459116;
  testrel(11, NE, y, f, cnt,failed);

  x := 0.25;
  y := theta3(x);
  f := 1.507820129860194314;
  testrel(12, NE, y, f, cnt,failed);

  x := -0.25;
  y := theta3(x);
  f := 0.5078048710711282610;
  testrel(13, NE, y, f, cnt,failed);

  x := 0.5;
  y := theta3(x);
  f := 2.128936827211877159;
  testrel(14, NE, y, f, cnt,failed);

  x := -0.5;
  y := theta3(x);
  f := 0.1211242080025805025;
  testrel(15, NE, y, f, cnt,failed);

  x := 0.75;
  y := theta3(x);
  f := 3.304597249065620979;
  testrel(16, NE, y, f, cnt,failed);

  x := -0.75;
  y := theta3(x);
  f := 0.1245309430198100883e-2;
  testrel(17, NE, y, f, cnt,failed);

  x := -0.875;
  y := theta3(x);
  f := 0.9159962553050060627e-7;
  testrel(18, NE2, y, f, cnt,failed);

  x := -0.9375;
  y := theta3(x);
  f := 0.3475270580223860277e-15;
  testrel(19, NE2, y, f, cnt,failed);

  x := 0.99;
  y := theta3(x);
  f := 17.68009722441707442;
  testrel(20, NE, y, f, cnt,failed);

  x := 0.9990234375;
  y := theta3(x);
  f := 56.70467198706624908;
  testrel(21, NE, y, f, cnt,failed);

  x := 0.99993896484375;
  y := theta3(x);
  f := 226.8706310303493719;
  testrel(22, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_theta4;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 4;
  NE2= 50;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','theta4');

  x := 0.0;
  y := theta4(x);
  f := 1;
  testrel( 1, 1, y, f, cnt,failed);

  x := -1e-10;
  y := theta4(x);
  f := 1.0000000002;
  testrel( 2, NE, y, f, cnt,failed);

  x := 1e-10;
  y := theta4(x);
  f := 0.9999999998;
  testrel( 3, NE, y, f, cnt,failed);

  x := -0.0001;
  y := theta4(x);
  f := 1.0002000000000002;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.0001;
  y := theta4(x);
  f := 0.9998000000000002;
  testrel( 5, NE, y, f, cnt,failed);

  x := -0.0625;
  y := theta4(x);
  f := 1.125030517607228831;
  testrel( 6, NE, y, f, cnt,failed);

  x := 0.0625;
  y := theta4(x);
  f := 0.8750305175490211697;
  testrel( 7, NE, y, f, cnt,failed);

  x := -0.1;
  y := theta4(x);
  f := 1.2002000020000002;
  testrel( 8, NE, y, f, cnt,failed);

  x := 0.1;
  y := theta4(x);
  f := 0.8001999980000002;
  testrel( 9, NE, y, f, cnt,failed);

  x := -0.125;
  y := theta4(x);
  f := 1.250488296151168299;
  testrel(10, NE, y, f, cnt,failed);

  x := 0.125;
  y := theta4(x);
  f := 0.7504882663488459116;
  testrel(11, NE, y, f, cnt,failed);

  x := -0.25;
  y := theta4(x);
  f := 1.507820129860194314;
  testrel(12, NE, y, f, cnt,failed);

  x := 0.25;
  y := theta4(x);
  f := 0.5078048710711282610;
  testrel(13, NE, y, f, cnt,failed);

  x := -0.5;
  y := theta4(x);
  f := 2.128936827211877159;
  testrel(14, NE, y, f, cnt,failed);

  x := 0.5;
  y := theta4(x);
  f := 0.1211242080025805025;
  testrel(15, NE, y, f, cnt,failed);

  x := -0.75;
  y := theta4(x);
  f := 3.304597249065620979;
  testrel(16, NE, y, f, cnt,failed);

  x := 0.75;
  y := theta4(x);
  f := 0.1245309430198100883e-2;
  testrel(17, NE, y, f, cnt,failed);

  x := 0.875;
  y := theta4(x);
  f := 0.9159962553050060627e-7;
  testrel(18, NE2, y, f, cnt,failed);

  x := 0.9375;
  y := theta4(x);
  f := 0.3475270580223860277e-15;
  testrel(19, NE2, y, f, cnt,failed);

  x := 0.96875;
  y := theta4(x);
  f := 0.3522479921477839111e-32;
  testrel(20, NE2, y, f, cnt,failed);

  x := -0.99;
  y := theta4(x);
  f := 17.68009722441707442;
  testrel(21, NE, y, f, cnt,failed);

  x := 0.99609375;
  y := theta4(x);
  f := 0.923200933487867066e-272;
  testrel(22, 200, y, f, cnt,failed);

  x := -0.9990234375;
  y := theta4(x);
  f := 56.70467198706624908;
  testrel(23, NE, y, f, cnt,failed);

  x := -0.99993896484375;
  y := theta4(x);
  f := 226.8706310303493719;
  testrel(24, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_theta1p;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 8;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','theta1p');

  x := 0.0;
  y := theta1p(x);
  f := 0.0;
  testrel( 1, 1, y, f, cnt,failed);

  x := 1e-10;
  y := theta1p(x);
  f := 0.6324555320336758664e-2;
  testrel( 2, NE, y, f, cnt,failed);

  x := 0.001;
  y := theta1p(x);
  f := 0.3556548150401385387;
  testrel( 3, NE, y, f, cnt,failed);

  y := theta1p(0.1);
  f := 1.090947794274656341;
  testrel( 4, NE, y, f, cnt,failed);

  y := theta1p(0.125);
  f := 1.133485713691481151;
  testrel( 5, NE, y, f, cnt,failed);

  y := theta1p(0.5);
  f := 0.5489785325603405619;
  testrel( 6, NE, y, f, cnt,failed);

  y := theta1p(0.7);
  f := 0.5175942137466076372e-1;
  testrel( 7, NE, y, f, cnt,failed);

  y := theta1p(0.875);
  f := 0.21550641012737325941e-5;
  testrel( 8, 16, y, f, cnt,failed);      {!!!}

  y := theta1p(0.9);
  f := 0.2198605228564362599e-7;
  testrel( 9, NE, y, f, cnt,failed);

  y := theta1p(0.9375);
  f := 1.691684955221596958e-14;
  testrel(10, 40, y, f, cnt,failed);    {!!!!}

  y := theta1p(0.99609375);
  f := 7.410311386320144961e-270;
  testrel(11, 200, y, f, cnt,failed);   {!!!!}

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_jacobi_theta;
var
  x,y,f,q: double;
  cnt, failed: integer;
const
  NE = 2;
  NE1= 4;
  NE2= 20;
  NE3= 40;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','jacobi_theta');

  q :=  0.015625;
  x := -6.0;
  f :=  0.1974469480047620137;
  y :=  jacobi_theta(1,x,q);
  testrel( 1, NE, y, f, cnt,failed);
  f :=  0.6790569135647325624;
  y :=  jacobi_theta(2,x,q);
  testrel( 2, NE, y, f, cnt,failed);
  f :=  1.026370486776468471;
  y :=  jacobi_theta(3,x,q);
  testrel( 3, NE, y, f, cnt,failed);
  f :=  0.973629614355687743;
  y :=  jacobi_theta(4,x,q);
  testrel( 4, NE, y, f, cnt,failed);

  x :=  1.0;
  f :=  0.5949854774798068618;
  y :=  jacobi_theta(1,x,q);
  testrel( 5, NE, y, f, cnt,failed);
  f :=  0.3818805185117610063;
  y :=  jacobi_theta(2,x,q);
  testrel( 6, NE, y, f, cnt,failed);
  f :=  0.9869953334375102445;
  y :=  jacobi_theta(3,x,q);
  testrel( 7, NE, y, f, cnt,failed);
  f :=  1.013004510721706430;
  y :=  jacobi_theta(4,x,q);
  testrel( 8, NE, y, f, cnt,failed);

  x := 22.0;
  f := -0.6254237203656787001e-2;
  y :=  jacobi_theta(1,x,q);
  testrel( 9, NE, y, f, cnt,failed);
  f := -0.7072516539054247784;
  y :=  jacobi_theta(2,x,q);
  testrel(10, NE, y, f, cnt,failed);
  f :=  1.031245222529819607;
  y :=  jacobi_theta(3,x,q);
  testrel(11, NE, y, f, cnt,failed);
  f :=  0.968755015739338684;
  y :=  jacobi_theta(4,x,q);
  testrel(12, NE, y, f, cnt,failed);

  q :=  0.125;
  x := -6.0;
  f :=  0.3183330153875734538;
  y :=  jacobi_theta(1,x,q);
  testrel(13, NE, y, f, cnt,failed);
  f :=  1.154111619491954217;
  y :=  jacobi_theta(2,x,q);
  testrel(14, NE, y, f, cnt,failed);
  f :=  1.211170606432237180;
  y :=  jacobi_theta(3,x,q);
  testrel(15, NE, y, f, cnt,failed);
  f :=  0.7892436308796062595;
  y :=  jacobi_theta(4,x,q);
  testrel(16, NE, y, f, cnt,failed);

  x :=  1.0;
  f :=  0.9980567302256493295;
  y :=  jacobi_theta(1,x,q);
  testrel(17, NE, y, f, cnt,failed);
  f :=  0.6241372250906064750;
  y :=  jacobi_theta(2,x,q);
  testrel(18, NE, y, f, cnt,failed);
  f :=  0.8956441432466157738;
  y :=  jacobi_theta(3,x,q);
  testrel(19, NE, y, f, cnt,failed);
  f :=  1.103717532904882537;
  y :=  jacobi_theta(4,x,q);
  testrel(20, NE, y, f, cnt,failed);

  x := 22.0;
  f := -0.1003288410708227573e-1;
  y :=  jacobi_theta(1,x,q);
  testrel(21, NE, y, f, cnt,failed);
  f := -1.207739871936758133;
  y :=  jacobi_theta(2,x,q);
  testrel(22, NE, y, f, cnt,failed);
  f :=  1.250448817278260789;
  y :=  jacobi_theta(3,x,q);
  testrel(23, NE, y, f, cnt,failed);
  f :=  0.7505271331941119067;
  y :=  jacobi_theta(4,x,q);
  testrel(24, NE, y, f, cnt,failed);

  q :=  0.5;
  x := -6.0;
  f :=  0.1797558255722322940;
  y :=  jacobi_theta(1,x,q);
  testrel(25, NE, y, f, cnt,failed);
  f :=  1.896324338970727117;
  y :=  jacobi_theta(2,x,q);
  testrel(26, NE, y, f, cnt,failed);
  f :=  1.896356884035728159;
  y :=  jacobi_theta(3,x,q);
  testrel(27, NE, y, f, cnt,failed);
  f :=  0.2096487964324376349;
  y :=  jacobi_theta(4,x,q);
  testrel(28, NE, y, f, cnt,failed);

  x :=  1.0;
  f :=  1.330378498179274650;
  y :=  jacobi_theta(1,x,q);
  testrel(29, NE1, y, f, cnt,failed);
  f :=  0.5001981385144562006;
  y :=  jacobi_theta(2,x,q);
  testrel(30, NE1, y, f, cnt,failed);
  f :=  0.5058938857304846079;
  y :=  jacobi_theta(3,x,q);
  testrel(31, NE1, y, f, cnt,failed);
  f :=  1.330686328485433289;
  y :=  jacobi_theta(4,x,q);
  testrel(32, NE1, y, f, cnt,failed);

  x := 22.0;
  f := -0.4859996420718287342e-2;
  y :=  jacobi_theta(1,x,q);
  testrel(33, NE, y, f, cnt,failed);
  f := -2.128690618052055354;
  y :=  jacobi_theta(2,x,q);
  testrel(34, NE, y, f, cnt,failed);
  f :=  2.128696212078939425;
  y :=  jacobi_theta(3,x,q);
  testrel(35, NE, y, f, cnt,failed);
  f :=  0.1212079911000069507;
  y :=  jacobi_theta(4,x,q);
  testrel(36, NE, y, f, cnt,failed);

  q :=  0.9375;
  x := -6.0;
  f :=  0.4863996742139718154e-10;
  y :=  jacobi_theta(1,x,q);
  testrel(37, NE2, y, f, cnt,failed);
  f :=  2.013827185165983456;
  y :=  jacobi_theta(2,x,q);
  testrel(38, NE, y, f, cnt,failed);
  f :=  2.013827185165983456;
  y :=  jacobi_theta(3,x,q);
  testrel(39, NE, y, f, cnt,failed);
  f :=  0.4863996742150061654e-10;
  y :=  jacobi_theta(4,x,q);
  testrel(40, NE2, y, f, cnt,failed);

  x :=  1.0;
  f :=  0.4479461566856951708e-1;
  y :=  jacobi_theta(1,x,q);
  testrel(41, NE2, y, f, cnt,failed);
  f :=  0.1301477087901053285e-5;
  y :=  jacobi_theta(2,x,q);
  testrel(42, NE2, y, f, cnt,failed);
  f :=  0.1301477087901053285e-5;
  y :=  jacobi_theta(3,x,q);
  testrel(43, NE2, y, f, cnt,failed);
  f :=  0.4479461566856951708e-1;
  y :=  jacobi_theta(4,x,q);
  testrel(44, NE2, y, f, cnt,failed);

  x := 22.0;
  f := -0.1542271558188657860e-15;
  y :=  jacobi_theta(1,x,q);
  testrel(45, NE3, y, f, cnt,failed);
  f := -6.968482469009551977;
  y :=  jacobi_theta(2,x,q);
  testrel(46, NE, y, f, cnt,failed);
  f :=  6.968482469009551977;
  y :=  jacobi_theta(3,x,q);
  testrel(47, NE, y, f, cnt,failed);
  f :=  0.3798265303356796832e-15;
  y :=  jacobi_theta(4,x,q);
  testrel(48, NE3, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_jacobi_theta_relations;
var
  x,y,f,q,t,e: double;
  i,cnt, failed: integer;
const
  NE = 4;
  NE2= 25;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','Jacobi theta relations');

  randseed := 0;
  {check Jacobi identity NIST[30] 20.4.6}
  for i:=1 to 500 do begin
    q := random;
    f := theta2(q);
    y := theta3(q);
    e := theta4(q);
    f := f*e*y;
    y := theta1p(q);
    testrel(i, NE, y, f, cnt,failed);
  end;
  {check identity NIST[30] 20.7.2}
  for i:=501 to 1000 do begin
    q := random;
    x := (random-0.5)*32;
    e := theta2(q);
    t := jacobi_theta(1,x,q);
    y := sqr(e*t);
    e := theta4(q);
    t := jacobi_theta(3,x,q);
    t := sqr(e*t);
    y := t + y;
    e := theta3(q);
    t := jacobi_theta(4,x,q);
    f := sqr(e*t);
    testrel(i, NE2, y, f, cnt,failed);
  end;

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_EllipticModulus;
var
  y,f: double;
  cnt, failed: integer;
const
  NE = 2;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','EllipticModulus');

  y := EllipticModulus(0);
  f := 0;
  testrel( 1, NE, y, f, cnt,failed);

  y := EllipticModulus(1e-20);
  f := 0.4e-9;
  testrel( 2, NE, y, f, cnt,failed);

  y := EllipticModulus(0.5e-10);
  f := 0.2828427124180504673e-4;
  testrel( 3, NE, y, f, cnt,failed);

  y := EllipticModulus(0.8e-10);
  f := 0.357770876285479671e-4;
  testrel( 4, NE, y, f, cnt,failed);

  y := EllipticModulus(3e-6);
  f := 0.6928120092709691993e-2;
  testrel( 5, NE, y, f, cnt,failed);

  y := EllipticModulus(5e-5);
  f := 0.2827861538302049875e-1;
  testrel( 6, NE, y, f, cnt,failed);

  y := EllipticModulus(1e-3);
  f := 0.1259869078096994858;
  testrel( 7, NE, y, f, cnt,failed);

  y := EllipticModulus(0.015625);
  f := 0.4703855942180768828;
  testrel( 8, NE, y, f, cnt,failed);

  y := EllipticModulus(0.05);
  f := 0.7428797651484181540;
  testrel( 9, NE, y, f, cnt,failed);

  y := EllipticModulus(0.125);
  f := 0.9328799582470243052;
  testrel(10, NE, y, f, cnt,failed);

  y := EllipticModulus(0.25);
  f := 0.9935469827401039811;
  testrel(11, NE, y, f, cnt,failed);

  y := EllipticModulus(0.5);
  f := 0.999994761054931922;
  testrel(12, NE, y, f, cnt,failed);

  y := EllipticModulus(0.625);
  f := 0.999999993927859217;
  testrel(13, NE, y, f, cnt,failed);

  y := EllipticModulus(0.75);
  f := 0.999999999999989917;
  testrel(14, NE, y, f, cnt,failed);

  y := EllipticModulus(0.785);
  f := 1.0;
  testrel(15, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;


{---------------------------------------------------------------------------}
procedure test_EllipticNome;
var
  x,y,f: double;
  cnt, failed: integer;
const
  NE = 2;
  NE1 = 3;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','EllipticNome');

  y := EllipticNome(0);
  f := 0;
  testrel( 1, NE, y, f, cnt,failed);

  x := 1e-8;
  y := EllipticNome(x);
  f := 0.62500000000000003125e-17;
  testrel( 2, NE, y, f, cnt,failed);

  x := 2e-5;
  f := 0.25000000005e-10;
  y := EllipticNome(x);
  testrel( 3, NE, y, f, cnt,failed);

  x := 1e-3;
  y := EllipticNome(x);
  f := 0.6250003125002050783e-7;
  testrel( 4, NE, y, f, cnt,failed);

  x := 0.01;
  f := 0.6250312520509326291e-5;
  y := EllipticNome(x);
  testrel( 5, NE, y, f, cnt,failed);

  x := 0.0625;
  y := EllipticNome(x);
  f := 0.2446186880542634318e-3;
  testrel( 6, NE, y, f, cnt,failed);

  x := 0.1;
  y := EllipticNome(x);
  f := 0.62814566038301559153e-3;
  testrel( 7, NE, y, f, cnt,failed);

  x := 0.125;
  y := EllipticNome(x);
  f := 0.98427103910568735322e-3;
  testrel( 8, NE, y, f, cnt,failed);

  x := 0.25;
  y := EllipticNome(x);
  f := 0.40335700699174980272e-2;
  testrel( 9, NE1, y, f, cnt,failed);  {!!!}

  x := 0.5;
  y := EllipticNome(x);
  f := 0.1797238700896724000e-1;
  testrel( 10, NE, y, f, cnt,failed);

  x := 0.75;
  y := EllipticNome(x);
  f := 0.5148501340868848743e-1;
  testrel(11, NE, y, f, cnt,failed);

  y := EllipticNome(0.875);
  f := 0.8970747667592803680e-1;
  testrel(12, NE, y, f, cnt,failed);

  x := 0.99218750;
  y := EllipticNome(x);
  f := 0.2405834697910484202;
  testrel(13, NE, y, f, cnt,failed);

  x := 0.9990234375;
  y := EllipticNome(x);
  f := 0.3344212209554592571;
  testrel(14, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-20);
  y := EllipticNome(x);
  f := 0.5384398141415984944;
  testrel(15, NE, y, f, cnt,failed);

  x := 0.99999999;
  y := EllipticNome(x);
  {x is stored as 0.99999998999999994975240724670584313571453094482421875}
  {f = 0.6178922154618734163125450826051180822364}  {for 0.99999999}
  {f = 0.6178922153889587608981317345364993502183}  {for stored x}
  f := 0.6178922153889587609;
  testrel(16, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-27);   {just larger than k1}
  f := 0.6221166620579994779;
  y := EllipticNome(x);
  testrel(17, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-30);
  y := EllipticNome(x);
  f := 0.6495472634625518342;
  testrel(18, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-40);
  y := EllipticNome(x);
  f := 0.7181078116552710092;
  testrel(19, NE, y, f, cnt,failed);

  x := 1-ldexpd(1,-50);
  y := EllipticNome(x);
  f := 0.7644052816712215609;
  testrel(20, NE, y, f, cnt,failed);

  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;



{---------------------------------------------------------------------------}
procedure test_jacobi_am;
var
  k,y,f: double;
  cnt, failed: integer;
const
  NE = 4;
  NE2 = 12;
begin
  cnt := 0;
  failed := 0;
  writeln('Function: ','jacobi_am');

(*
  functions.wolfram.com am(x,m=k^2)

  am( 1e4| 0.9801) = 4679.50680849319424074580103530
  am( 100| 0.9801) = 46.4755076587115117103813094315
  am(  50| 0.9801) = 23.5117263061276236669938726702
  am(  10| 0.9801) = 4.70253441861921859964216582491
  am(   5| 0.9801) = 1.91716974194525204788345039589
  am(   2| 0.9801) = 1.31714542384792180493950103681
  am( 1.5| 0.9801) = 1.13914997762694440537074810849
  am(   1| 0.9801) = 0.868393132609333030148629668823
  am( 0.5| 0.9801) = 0.480767644586222955157484970097
  am( 0.1| 0.9801) = 0.0998370555848651194201836599150
  am(1e-8| 0.9801) = 9.9999999999999998366500000000e-9

  am( 1e4| 0.25)   = 9318.09261688556916448088057619
  am( 100| 0.25)   = 93.1507447268719234550491409320
  am(  50| 0.25)   = 46.5586790589360613197846442433
  am(  10| 0.25)   = 9.31033820827885700516208687381
  am(   5| 0.25)   = 4.66280133597017211009047600218
  am(   2| 0.25)   = 1.84404911788569883769540867629
  am( 1.5| 0.25)   = 1.40970163348035428849626926450
  am(   1| 0.25)   = 0.966031052636613917077313357826
  am( 0.5| 0.25)   = 0.495058281122736450313727651291
  am( 0.1| 0.25)   = 0.0999584217409797688248523367620
  am(1e-8| 0.25)   = 9.9999999999999999583333333333e-9

  am( 1e4| 0.01)   = 9974.92228016737631795948718472
  am( 100| 0.01)   = 99.7479581613018037438641709169
  am(  50| 0.01)   = 49.8737217319538650058402332009
  am(  10| 0.01)   = 9.97604154038436340648746901110
  am(   5| 0.01)   = 4.98680427190718565374609944296
  am(   2| 0.01)   = 1.99404220097016077837344949277
  am( 1.5| 0.01)   = 1.49642474036491550996462359096
  am(   1| 0.01)   = 0.998636798043011624120516572525
  am( 0.5| 0.01)   = 0.499801858424564388864495655958
  am( 0.1| 0.01)   = 0.0999983366717400904679036072939
  am(1e-8| 0.01)   = 9.9999999999999999983333333333e-9

  am( 1e4| 2.25)   = 0.702064299427996644366865203987
  am( 100| 2.25)   = 0.719553418259012077129929162280
  am(  50| 2.25)   = 0.570768602655119409927200454341
  am(  10| 2.25)   = 0.333146253178413834734200872691
  am(   5| 2.25)   = 0.172255551749616410219255317163
  am(   2| 2.25)   = 0.387799143010057183383622291983
  am( 1.5| 2.25)   = 0.681655882942545108796180477090
  am(   1| 2.25)   = 0.705925556996020791549085946552
  am( 0.5| 2.25)   = 0.456413455601055166850249795868
  am( 0.1| 2.25)   = 0.0996261665409335520946244355727
  am(1e-8| 2.25)   = 9.99999999999999962500000000000e-9

*)

  k := 0.99;
  y := jacobi_am(1e4, k);
  f := 4679.506808493194241;
  testrel( 1, NE, y, f, cnt,failed);

  y := jacobi_am(100, k);
  f := 46.47550765871151171;
  testrel( 2, NE, y, f, cnt,failed);

  y := jacobi_am(50, k);
  f := 23.51172630612762367;
  testrel( 3, NE, y, f, cnt,failed);

  y := jacobi_am(10, k);
  f := 4.702534418619218600;
  testrel( 4, NE, y, f, cnt,failed);

  y := jacobi_am(5, k);
  f := 1.917169741945252048;
  testrel( 5, NE, y, f, cnt,failed);

  y := jacobi_am(2, k);
  f := 1.317145423847921805;
  testrel( 6, NE, y, f, cnt,failed);

  y := jacobi_am(1.5, k);
  f := 1.139149977626944405;
  testrel( 7, NE, y, f, cnt,failed);

  y := jacobi_am(1, k);
  f := 0.8683931326093330301;
  testrel( 8, NE, y, f, cnt,failed);

  y := jacobi_am(0.5, k);
  f := 0.4807676445862229552;
  testrel( 9, NE, y, f, cnt,failed);

  y := jacobi_am(0.1, k);
  f := 9.983705558486511942e-2;
  testrel(10, NE, y, f, cnt,failed);

  y := jacobi_am(1e-8, k);
  f := 9.99999999999999984e-9;
  testrel( 11, NE, y, f, cnt,failed);

  {--------------------------------}
  k := 0.5;
  y := jacobi_am(1e4, k);
  f := 9318.09261688556916;
  testrel(12, NE, y, f, cnt,failed);

  y := jacobi_am(100, k);
  f := 93.15074472687192346;
  testrel(13, NE, y, f, cnt,failed);

  y := jacobi_am(50, k);
  f := 46.55867905893606132;
  testrel(14, NE, y, f, cnt,failed);

  y := jacobi_am(10, k);
  f := 9.310338208278857005;
  testrel(15, NE, y, f, cnt,failed);

  y := jacobi_am(5, k);
  f := 4.662801335970172110;
  testrel(16, NE, y, f, cnt,failed);

  y := jacobi_am(2, k);
  f := 1.844049117885698838;
  testrel(17, NE, y, f, cnt,failed);

  y := jacobi_am(1.5, k);
  f := 1.409701633480354288;
  testrel(18, NE, y, f, cnt,failed);

  y := jacobi_am(1, k);
  f := 0.9660310526366139171;
  testrel(19, NE, y, f, cnt,failed);

  y := jacobi_am(0.5, k);
  f := 0.4950582811227364503;
  testrel(20, NE, y, f, cnt,failed);

  y := jacobi_am(0.1, k);
  f := 9.995842174097976882e-2;
  testrel(21, NE, y, f, cnt,failed);

  y := jacobi_am(1e-8, k);
  f := 9.99999999999999996e-9;
  testrel(22, NE, y, f, cnt,failed);

  {--------------------------------}
  k := 0.1;
  y := jacobi_am(1e4, k);
  f := 9974.92228016737632;
  testrel(23, NE, y, f, cnt,failed);

  y := jacobi_am(100, k);
  f := 99.7479581613018037;
  testrel(24, NE, y, f, cnt,failed);

  y := jacobi_am(50, k);
  f := 49.87372173195386501;
  testrel(25, NE, y, f, cnt,failed);

  y := jacobi_am(10, k);
  f := 9.97604154038436341;
  testrel(26, NE, y, f, cnt,failed);

  y := jacobi_am(5, k);
  f := 4.986804271907185654;
  testrel(27, NE, y, f, cnt,failed);

  y := jacobi_am(2, k);
  f := 1.994042200970160778;
  testrel(28, NE, y, f, cnt,failed);

  y := jacobi_am(1.5, k);
  f := 1.49642474036491551;
  testrel(29, NE, y, f, cnt,failed);

  y := jacobi_am(1, k);
  f := 0.998636798043011624;
  testrel(30, NE, y, f, cnt,failed);

  y := jacobi_am(0.5, k);
  f := 0.4998018584245643889;
  testrel(31, NE, y, f, cnt,failed);

  y := jacobi_am(0.1, k);
  f := 9.99983366717400905e-2;
  testrel(32, NE, y, f, cnt,failed);

  y := jacobi_am(1e-8, k);
  f := 1.00000000000000000e-8;
  testrel(33, NE, y, f, cnt,failed);

  {--------------------------------}
  k := 1.5;
  y := jacobi_am(1000, k);
  f :=  0.71831695374088110251;
  testrel(34, NE2, y, f, cnt,failed);

  y := jacobi_am(100, k);
  f := -0.7195534182590120771;
  testrel(35, NE2, y, f, cnt,failed);

  y := jacobi_am(50, k);
  f :=  0.5707686026551194099;
  testrel(36, NE2, y, f, cnt,failed);

  y := jacobi_am(10, k);
  f := 0.3331462531784138347;
  testrel(37, NE, y, f, cnt,failed);

  y := jacobi_am(5, k);
  f := 0.1722555517496164102;
  testrel(38, NE, y, f, cnt,failed);

  y := jacobi_am(2, k);
  f := 0.3877991430100571834;
  testrel(39, NE2, y, f, cnt,failed);

  y := jacobi_am(1.5, k);
  f := 0.6816558829425451088;
  testrel(40, NE, y, f, cnt,failed);

  y := jacobi_am(1, k);
  f := 0.7059255569960207915;
  testrel(41, NE, y, f, cnt,failed);

  y := jacobi_am(0.5, k);
  f := 0.4564134556010551669;
  testrel(42, NE, y, f, cnt,failed);

  y := jacobi_am(0.1, k);
  f := 9.96261665409335521e-2;
  testrel(43, NE, y, f, cnt,failed);

  y := jacobi_am(1e-8, k);
  f := 9.999999999999999625e-9;
  testrel(44, NE, y, f, cnt,failed);


  if failed>0 then writeln('*** failed: ',failed,' of ',cnt)
  else writeln(cnt:4, ' tests OK');
  inc(total_cnt, cnt);
  inc(total_failed, failed);
end;

end.
