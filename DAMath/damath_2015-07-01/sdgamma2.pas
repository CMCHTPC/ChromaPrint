unit sdGamma2;

{Double precision inverse/incomplete Gamma/Beta functions}

interface

{$i std.inc}

{$ifdef BIT16}
{$N+}
{$endif}

{$ifdef NOBASM}
  {$undef BASM}
{$endif}


(*************************************************************************

 DESCRIPTION   :  Double precision inverse/incomplete Gamma/Beta functions

 REQUIREMENTS  :  BP7, D1-D7/D9-D10/D12/D17-D18, FPC, VP, WDOSX

 EXTERNAL DATA :  ---

 MEMORY USAGE  :  ---

 DISPLAY MODE  :  ---

 REMARK        :  ---

 REFERENCES    :  References used in this unit, main index in damath_info.txt/references

                  [7] Cephes Mathematical Library, Version 2.8
                      http://www.moshier.net/#Cephes or http://www.netlib.org/cephes/
                 [19] Boost C++ Libraries, Release 1.42.0, 2010.
                      http://www.boost.org/
                 [21] GNU Scientific Library, GSL-1.14 (March 2010),
                      http://www.gnu.org/software/gsl
                 [26] N.M. Temme, A Set of Algorithms for the Incomplete Gamma Functions,
                      Probability in the Engineering and Informational Sciences, 8 (1994), pp.291-307,
                      available as http://oai.cwi.nl/oai/asset/10080/10080A.pdf
                 [27] A.R. Didonato, A.H. Morris, Computation of the Incomplete Gamma Function Ratios
                      and their Inverse. ACM TOMS, Vol 12, No 4, Dec 1986, pp.377-393.
                      Fortran source: ACM TOMS 13 (1987), pp.318-319; available from
                      http://netlib.org/toms/654
                 [33] http://functions.wolfram.com/: Formulas and graphics about
                      mathematical functions for the mathematical and scientific
                      community and/or http://mathworld.wolfram.com/ ("/the web's
                      most extensive mathematical resource/")
                 [37] A.R. DiDonato, A.H. Morris, Algorithm 708: Significant digit computation
                      of the incomplete beta function ratios, ACM TOMS, Vol.18, No.3, 1992,
                      pp.360-373. Fortran source available from http://netlib.org/toms/708

 Version  Date      Author      Modification
 -------  --------  -------     ------------------------------------------
 1.12.00  16.06.14  W.Ehrhardt  Incomplete/inverse functions from sdGamma
 1.12.01  16.06.14  we          sfd_ibeta_inv (code from sdSDist)
 1.12.02  22.06.14  we          sfd_ilng (inverse of lngamma)
 1.12.04  25.06.14  we          sfd_ipsi (inverse of psi)

 1.16.00  16.12.14  we          Check IsNanOrInf in sfd_ilng

***************************************************************************)


(*-------------------------------------------------------------------------
 (C) Copyright 2009-2014 Wolfgang Ehrhardt

 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising from
 the use of this software.

 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software in
    a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

 2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.
----------------------------------------------------------------------------*)

(*-------------------------------------------------------------------------
  This Pascal code uses material and ideas from open source and public
  domain libraries, see the file '3rdparty.ama' for the licenses.
---------------------------------------------------------------------------*)


function sfd_igprefix(a,x: double): double;
  {-return x^a*exp(-x)/gamma(a) using Lanczos sum}

procedure sfd_incgamma_ex(a,x: double; var p,q,dax: double; calcdax: boolean);
  {-Return the normalised incomplete gamma functions P and Q, a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x  )/gamma(a)}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}
  { If calcdax=true, dax = x^a*exp(-x)/gamma(a) is returned. This is extra}
  { effort only in the special cases, otherwise dax is calculated anyway.}

procedure sfd_incgamma(a,x: double; var p,q: double);
  {-Return the normalised incomplete gamma functions P and Q, a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x  )/gamma(a)}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}

function sfd_igammap(a,x: double): double;
  {-Return the normalised lower incomplete gamma function P(a,x), a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x)/gamma(a)}

function sfd_igammaq(a,x: double): double;
  {-Return the normalised upper incomplete gamma function Q(a,x), a>=0, x>=0}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}

function sfd_igamma(a,x: double): double;
  {-Return the non-normalised upper incomplete gamma function}
  { GAMMA(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf), x>=0}

function sfd_igammal(a,x: double): double;
  {-Return the non-normalised lower incomplete gamma function}
  { gamma(a,x) = integral(exp(-t)*t^(a-1), t=0..x); x>=0, a<>0,-1,-2,..}

function sfd_git(a,x: double): double;
  {-Return Tricomi's entire incomplete gamma function igammat(a,x)}
  { = igammal(a,x)/gamma(a)/x^a = P(a,x)/x^a }

procedure sfd_incgamma_inv(a,p,q: double; var x: double; var ierr: integer);
  {-Return the inverse normalised incomplete gamma function, i.e. calculate}
  { x with P(a,x)=p and Q(a,x)=q. Input parameter a>0, p>=0, q>0 and p+q=1.}
  { ierr is >= 0 for success, < 0 for input errors or iterations failures. }

function sfd_igamma_inv(a,p,q: double): double;
  {-Return the inverse normalised incomplete gamma function, i.e. calculate}
  { x with P(a,x)=p and Q(a,x)=q. Input parameter a>0, p>=0, q>0 and p+q=1.}

function sfd_igammap_inv(a,p: double): double;
  {-Inverse incomplete gamma: return x with P(a,x)=p, a>=0, 0<=p<1}

function sfd_igammaq_inv(a,q: double): double;
  {-Inverse complemented incomplete gamma: return x with Q(a,x)=q, a>=0, 0<q<=1}

function sfd_ilng(y: double): double;
  {-Inverse of lngamma: return x with lngamma(x) = y, y >= -0.12142, x > 1.4616}

function sfd_ipsi(y: double): double;
  {-Inverse of psi, return x with psi(x)=y, y <= ln_MaxDbl}

function sfd_ibeta(a, b, x: double): double;
  {-Return the normalised incomplete beta function, a>0, b>0, 0 <= x <= 1}
  { sfd_ibeta = integral(t^(a-1)*(1-t)^(b-1) / beta(a,b), t=0..x)}

function sfd_ibeta_inv(a, b, y: double): double;
  {-Return the functional inverse of the normalised incomplete beta function}
  { with a > 0, b > 0, and 0 <= y <= 1.}

function sfd_ibetaprefix(a,b,x,y: double): double;
  {-Return (x^a)(y^b)/Beta(a,b), x+y=1, using Lanczos approximation}

function sfd_nnbeta(a, b, x: double): double;
  {-Return the non-normalised incomplete beta function B_x(a,b)}
  { for 0<=x<=1, B_x = integral(t^(a-1)*(1-t)^(b-1), t=0..x).  }

{#Z+}
procedure igam_qfraction(a,x,dax: double; var p,q: double);
  {-Temme/Gautschi continued fraction for Q(a,x)}
{#Z-}


implementation

uses
  DAMath,
  sdBasic,  {Basic common code}
  sdErf,    {Error function and related}
  sdExpInt, {Exponential integrals and related}
  sdHyperG, {Hypergeometric functions}
  sdGamma;  {Gamma function and related}

{---------------------------------------------------------------------------}
{------------------- Incomplete Gamma functions ----------------------------}
{---------------------------------------------------------------------------}

{---------------------------------------------------------------------------}
procedure igam_pqasymp(a,x: double; var p,q: double);
  {-Incomplete gamma functions for large a and a ~ x}
var
  y,z: double;
  w: array[0..12] of double;
const
  N0=18;
  C0: array[0..N0] of double = (
       -0.333333333333333333333,
        0.0833333333333333333333,
       -0.0148148148148148148148,
        0.00115740740740740740741,
        0.000352733686067019400353,
       -0.0001787551440329218107,
        0.39192631785224377817e-4,
       -0.218544851067999216147e-5,
       -0.18540622107151599607e-5,
        0.829671134095308600502e-6,
       -0.176659527368260793044e-6,
        0.670785354340149858037e-8,
        0.102618097842403080426e-7,
       -0.438203601845335318655e-8,
        0.914769958223679023418e-9,
       -0.255141939949462497669e-10,
       -0.583077213255042506746e-10,
        0.243619480206674162437e-10,
       -0.502766928011417558909e-11);

  N1=16;
  C1: array[0..N1] of double = (
       -0.00185185185185185185185,
       -0.00347222222222222222222,
        0.00264550264550264550265,
       -0.000990226337448559670782,
        0.000205761316872427983539,
       -0.40187757201646090535e-6,
       -0.18098550334489977837e-4,
        0.764916091608111008464e-5,
       -0.161209008945634460038e-5,
        0.464712780280743434226e-8,
        0.137863344691572095931e-6,
       -0.575254560351770496402e-7,
        0.119516285997781473243e-7,
       -0.175432417197476476238e-10,
       -0.100915437106004126275e-8,
        0.416279299184258263623e-9,
       -0.856390702649298063807e-10);

   N2=14;
   C2: array[0..N2] of double = (
         0.00413359788359788359788,
        -0.00268132716049382716049,
         0.000771604938271604938272,
         0.200938786008230452675e-5,
        -0.000107366532263651605215,
         0.529234488291201254164e-4,
        -0.127606351886187277134e-4,
         0.342357873409613807419e-7,
         0.137219573090629332056e-5,
        -0.629899213838005502291e-6,
         0.142806142060642417916e-6,
        -0.204770984219908660149e-9,
        -0.140925299108675210533e-7,
         0.622897408492202203356e-8,
        -0.136704883966171134993e-8);

   N3=12;
   C3: array[0..N3] of double = (
         0.000649434156378600823045,
         0.000229472093621399176955,
        -0.000469189494395255712128,
         0.000267720632062838852962,
        -0.756180167188397641073e-4,
        -0.239650511386729665193e-6,
         0.110826541153473023615e-4,
        -0.56749528269915965675e-5,
         0.142309007324358839146e-5,
        -0.278610802915281422406e-10,
        -0.169584040919302772899e-6,
         0.809946490538808236335e-7,
        -0.191111684859736540607e-7);

   N4=10;
   C4: array[0..N4] of double = (
        -0.000861888290916711698605,
         0.000784039221720066627474,
        -0.000299072480303190179733,
        -0.146384525788434181781e-5,
         0.664149821546512218666e-4,
        -0.396836504717943466443e-4,
         0.113757269706784190981e-4,
         0.250749722623753280165e-9,
        -0.169541495365583060147e-5,
         0.890750753220530968883e-6,
        -0.229293483400080487057e-6);

   N5=8;
   C5: array[0..N5] of double = (
        -0.000336798553366358150309,
        -0.697281375836585777429e-4,
         0.000277275324495939207873,
        -0.000199325705161888477003,
         0.679778047793720783882e-4,
         0.141906292064396701483e-6,
        -0.135940481897686932785e-4,
         0.801847025633420153972e-5,
        -0.229148117650809517038e-5);

   N6=10;
   C6: array[0..N6] of double = (
         0.000531307936463992223166,
        -0.000592166437353693882865,
         0.000270878209671804482771,
         0.790235323266032787212e-6,
        -0.815396936756196875093e-4,
         0.561168275310624965004e-4,
        -0.183291165828433755673e-4,
        -0.307961345060330478256e-8,
         0.346515536880360908674e-5,
        -0.20291327396058603727e-5,
         0.57887928631490037089e-6);

   N7=8;
   C7: array[0..N7] of double = (
         0.000344367606892377671254,
         0.517179090826059219337e-4,
        -0.000334931610811422363117,
         0.000281269515476323702274,
        -0.000109765822446847310235,
        -0.127410090954844853795e-6,
         0.277444515115636441571e-4,
        -0.182634888057113326614e-4,
         0.578769494973505239894e-5);

   N8=6;
   C8: array[0..N8] of double = (
        -0.000652623918595309418922,
         0.000839498720672087279993,
        -0.000438297098541721005061,
        -0.696909145842055197137e-6,
         0.000166448466420675478374,
        -0.000127835176797692185853,
         0.462995326369130429061e-4);

   N9=4;
   C9: array[0..N9] of double = (
        -0.000596761290192746250124,
        -0.720489541602001055909e-4,
         0.000678230883766732836162,
        -0.0006401475260262758451,
         0.000277501076343287044992);

   N10=2;
   C10: array[0..N10] of double = (
          0.00133244544948006563713,
         -0.0019144384985654775265,
          0.00110893691345966373396);

   N11=4;
   C11: array[0..N11] of double = (
          0.00157972766073083495909,
          0.000162516262783915816899,
         -0.00206334210355432762645,
          0.00213896861856890981541,
         -0.00101085593912630031708);

   N12=2;
   C12: array[0..2] of double = (
         -0.00407251211951401664727,
          0.00640336283380806979482,
         -0.00404101610816766177474);
begin
   {Asymptotic expansions of incomplete gamma functions P(a,x) and Q(a,x)}
   {when a is large and x ~ a, }

   {Based on \boost\math\special_functions\detail\igamma_large.hpp [19]}
   {Copyright John Maddock 2006, see 3rdparty.ama for Boost license}

   p := -ln1pmx((x-a)/a);
   y := a*p;
   z := sqrt(2.0*p);
   if x<a then z := -z;

   w[0] := PolEval(z, C0, 1+N0 );
   w[1] := PolEval(z, C1, 1+N1 );
   w[2] := PolEval(z, C2, 1+N2 );
   w[3] := PolEval(z, C3, 1+N3 );
   w[4] := PolEval(z, C4, 1+N4 );
   w[5] := PolEval(z, C5, 1+N5 );
   w[6] := PolEval(z, C6, 1+N6 );
   w[7] := PolEval(z, C7, 1+N7 );
   w[8] := PolEval(z, C8, 1+N8 );
   w[9] := PolEval(z, C9, 1+N9 );
   w[10]:= PolEval(z, C10,1+N10);
   w[11]:= PolEval(z, C11,1+N11);
   w[12]:= PolEval(z, C12,1+N12);

   p := PolEval(1.0/a, w, 13);
   p := p*exp(-y)/sqrt(a*TwoPi);
   if x<a then p := -p;
   p := p + 0.5*sfd_erfc(sqrt(y));
   if x>=a then begin
     q := p;
     p := 1.0 - q;
   end
   else begin
     q := 1.0 - p;
   end;
end;


{---------------------------------------------------------------------------}
function igam_aux(x: double): double;
  {-Temme's function g(x) in 1/Gamma(x) = 1 + x*(x-1)*g(x), x >= -1}
const
  {Maple definition: g := x -> (1/GAMMA(x+1)-1)/(x*(x-1));}
  {chebyshev(g(x), x=0..1, 0.5e-20); calculated with Digits:=30;}
  gan = 17;
  gah : array[0..gan-1] of THexDblW = (
          ($3404,$5761,$37BE,$BFF0),  {-1.01360925800986577694906309789     }
          ($6B3A,$9BA0,$17F1,$3FB4),  {+0.784903531024782283533943840994e-1 }
          ($949B,$82EE,$AF2F,$3F7B),  {+0.675886687432583155292019772240e-2 }
          ($2924,$7C96,$F4B2,$BF54),  {-0.127904348696234681212975260904e-2 }
          ($51EA,$2C70,$4579,$3F08),  {+0.462939838642739584694545688440e-4 }
          ($2093,$9678,$3212,$3ED2),  {+0.433816817447403519173829550977e-5 }
          ($2B1B,$A238,$DFBF,$BEA1),  {-0.532687242261800541117044891072e-6 }
          ($8F36,$35D8,$7E51,$3E52),  {+0.172233457410539543634464445150e-7 }
          ($75C0,$EAC2,$853B,$3E0C),  {+0.830054210711905120609172324971e-9 }
          ($ECE7,$94BF,$02B6,$BDDD),  {-0.105539942399565611532163232305e-9 }
          ($AF16,$5237,$55D4,$3D91),  {+0.394158428521837947892479562496e-11}
          ($B5D6,$2241,$61F5,$3D24),  {+0.362068538620576498220306882292e-13}
          ($F922,$E718,$3181,$BD08),  {-0.107440227418271864750448383428e-13}
          ($E432,$777E,$0411,$3CC2),  {+0.500041439419368462237596022981e-15}
          ($13E7,$D380,$CCFD,$BC5C),  {-0.624516672751596145046065537918e-17}
          ($A131,$FF6E,$212D,$BC23),  {-0.518509067074711462577736062188e-18}
          ($C12A,$A288,$78A4,$3BE4)); {+0.346796669906221429536559013309e-19}
var
  ga: array[0..gan-1] of double absolute gah;

  function csfun(x: double): double;
  begin
    csfun := CSEvalD(2.0*x-1, ga, gan);
  end;

begin
  {See Temme [26] function auxgam for the ranges. Temme uses a rational}
  {approximation, I use a Chebyshev expansion calculated with Maple V. }
  if x<=-1 then igam_aux := -0.5
  else if x<0.0  then igam_aux := -(1.0+sqr(1.0+x)*csfun(x+1.0))/(1.0-x)
  else if x<=1.0 then igam_aux := csfun(x)
  else if x<=2.0 then igam_aux := ((x-2.0)*csfun(x)-1.0)/sqr(x)
  else igam_aux := (1.0/sfd_gamma(x+1.0)-1.0)/(x*(x-1.0));
end;


{---------------------------------------------------------------------------}
procedure igam_qtaylor(a,x: double; var p,q: double);
  {-Temme/Gautschi code for Q(a,x) when x < 1}
var
  r,s,t,v,u: double;
begin
  {Ref: Temme [26] function qtaylor}
  q := powm1(x,a);
  s := -a*(a-1.0)*igam_aux(a);
  u := s - q*(1-s);
  p := a*x;
  q := a + 1.0;
  r := a + 3.0;
  t := 1.0;
  v := 1.0;
  repeat
    p := p + x;
    q := q + r;
    r := r + 2.0;
    t := -p*t/q;
    v := v + t;
  until abs(t) < eps_d*abs(v);
  t := a*(1.0-s)*x*exp(a*ln(x));
  r := t*v/(a+1);
  q := r + u;
  p := 1.0 - q;
end;


{---------------------------------------------------------------------------}
procedure igam_ptaylor(a,x,dax: double; var p,q: double);
  {-Temme/Gautschi code for P(a,x), dax = x^a*exp(-x)/gamma(a+1)}
var
  c,r: double;
begin
  {Ref: Temme [26] formula (5.5) and function ptaylor}
  if (a<=0.0) or (x<=0.0) then p := 0.0
  else begin
    r := a;
    c := 1.0;
    p := 1.0;
    repeat
      r := r+1.0;
      c := c*x/r;
      p := p+c;
    until c < p*eps_d;
    p := p*dax/a;
  end;
  q := 1.0 - p;
end;


{---------------------------------------------------------------------------}
procedure igam_qfraction(a,x,dax: double; var p,q: double);
  {-Temme/Gautschi continued fraction for Q(a,x)}
var
  g,r,s,t,y,rho,tau: double;
begin
  {Ref: Temme [26] function qfraction}
  s := 1.0-a;
  y := x+s;
  p := 0.0;
  q := y*(x-1.0-a);
  r := 4.0*y;
  t := 1.0;
  g := 1.0;
  rho:= 0.0;
  repeat
    p := p + s;
    q := q + r;
    r := r + 8.0;
    s := s + 2.0;
    tau := p*(1.0+rho);
    rho := tau/(q-tau);
    t := rho*t;
    g := g + t;
  until abs(t) < eps_d*abs(g);
  q := g/y*dax;
  p := 1.0-q;
end;


{---------------------------------------------------------------------------}
function igammaq_int(a, x: double): double;
  {-Return Q(a,x) when is an integer, a < min(30,x+1)}
var
  s,t: double;
  n: integer;
begin
  {Ref: Boost [19], gamma.hpp, function finite_gamma_q}
  s := exp(-x);
  if (s>0.0) and (a>=2.0) then begin
    t := s;
    n := 1;
    while n<a do begin
      t := (t/n)*x;
      s := s+t;
      inc(n);
    end;
  end;
  igammaq_int := s;
end;


{---------------------------------------------------------------------------}
function igammaq_half(a, x: double): double;
  {-Return Q(a,x) when is a half-integer, a < min(30,x+1)}
var
  e,s,t: double;
  n: integer;
begin
  {Ref: Boost [19], gamma.hpp, function finite_half_gamma_q}
  e := sfd_erfc(sqrt(x));
  if (e<>0.0) and (a>1.0) then begin
    t := 2.0*exp(-x)*sqrt(x/Pi);
    s := t;
    n := 2;
    while n<a do begin
      t := (t/(n-0.5))*x;
      s := s+t;
      inc(n);
    end;
    e := e + s;
  end;
  igammaq_half := e;
end;


{---------------------------------------------------------------------------}
function sfd_igprefix(a,x: double): double;
  {-return x^a*exp(-x)/gamma(a) using Lanczos sum}
const
  e1h: THexDblW = ($EF38,$362C,$8B56,$3FD7);  { 1/e = 3.67879441171442E-0001}
var
  prefix,agh,alx,amx,amxa,d,mina,maxa: double;
  em1: double absolute e1h;  {1/e}
begin
  {Ref: Boost [19], gamma.hpp, function regularised_gamma_prefix}
  if a<1.0 then begin
    if x<ln_MaxDbl then sfd_igprefix := power(x,a)*exp(-x)/sfd_gamma(a)
    else begin
      {underflow exp(-x)}
      d := sfd_lngamma(a);
      prefix := a*ln(x) - x - d;
      sfd_igprefix := exp(prefix);
    end;
    exit;
  end;

  agh := a + lanczos_gm05;
  d := ((x-a) - lanczos_gm05)/agh;
  if ((abs(d*d*a) <= 100.0) and (a > 150.0)) then begin
    prefix := a*ln1pmx(d) - x*lanczos_gm05/agh;
    prefix := exp(prefix);
  end
  else begin
    alx := a * ln(x/agh);
    amx := a - x;
    if alx < amx then begin
      mina := alx;
      maxa := amx;
    end
    else begin
      maxa := alx;
      mina := amx;
    end;
    if (mina <= ln_MinDbl) or (maxa >= ln_MaxDbl) then begin
      amxa := amx/a;
      if (0.5*mina > ln_MinDbl) and (0.5*maxa < ln_MaxDbl) then begin
        {compute square root of the result and then square it}
        prefix := power(x/agh, 0.5*a)*exp(0.5*amx);
        prefix := sqr(prefix);
      end
      else if (0.25*mina > ln_MinDbl) and (0.25*maxa < ln_MaxDbl) and (x > a) then begin
        {compute the 4th root of the result then square it twice}
        prefix := power(x/agh, 0.25*a)*exp(0.25*amx);
        prefix := sqr(sqr(prefix));
      end
      else if ((amxa > ln_MinDbl) and (amxa < ln_MaxDbl)) then begin
        prefix := power((x*exp(amxa))/agh, a);
      end
      else prefix := exp(alx + amx);
    end
    else begin
      prefix := power(x/agh,a)*exp(amx);
    end;
  end;
  sfd_igprefix := prefix*sqrt(agh*em1)/lanczos(a, true);
end;


{---------------------------------------------------------------------------}
procedure sfd_incgamma_ex(a,x: double; var p,q,dax: double; calcdax: boolean);
  {-Return the normalised incomplete gamma functions P and Q, a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x  )/gamma(a)}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}
  { If calcdax=true, dax = x^a*exp(-x)/gamma(a) is returned. This is extra}
  { effort only in the special cases, otherwise dax is calculated anyway.}
var
  mu,alfa: double;
  use_temme: boolean;
begin
  dax := 0.0;
  if (x<0.0) or (a<0.0) or IsNanOrInfD(x) or IsNanOrInfD(a) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    p := NaN_d;
    q := NaN_d;
    exit;
  end;

  {The logic is based on Temme [26] and Boost's gamma.hpp [19]}
  {First handle trivial cases}
  if (a=0.0) and (x=0.0) then begin
    p := 0.5;
    q := 0.5;
    exit;
  end
  else if x=0.0 then begin
    p := 0.0;
    q := 1.0;
    exit;
  end
  else if a=0.0 then begin
    p := 1.0;
    q := 0.0;
    exit;
  end;

  {Calculate prefix factor if requested. The Lanczos based routine seems to}
  {give the best overall results, although daxw is sometimes more accurate.}
  if calcdax then dax := sfd_igprefix(a,x);

  if frac(2.0*a)=0.0 then begin
    {a is integer or half integer}
    if a=0.5 then begin
      {q = erfc(sqrt(x))}
      {p =  erf(sqrt(x))}
      x := sqrt(x);
      if x < 1.0 then begin
        p := sfd_erf(x);
        q := 1.0 - p;
      end
      else begin
        q := sfd_erfc(x);
        p := 1.0 - q;
      end;
      exit;
    end
    else if a=1.0 then begin
      q := exp(-x);
      p := -expm1(-x);
      exit;
    end
    else if (a < 30.0) and (a < x+1.0) then begin
      {Note: }
      if frac(a)=0.0 then begin
        {a is integer}
        if x > 0.6 then begin
          q := igammaq_int(a,x);
          p := 1.0 - q;
        end;
      end
      else begin
        {a is half-integer}
        if x > 0.2 then begin
          q := igammaq_half(a,x);
          p := 1.0 - q;
        end;
      end;
      exit;
    end;
  end;

  {Check if asymptotic expansion should be used}
  if a > 20.0 then begin
    mu := (x-a)/a;
    use_temme := false;
    if a > 200.0 then begin
      if abs(mu) < sqrt(20.0/a) then use_temme := true;
    end
    else if abs(mu) < 0.4 then use_temme := true;
    if use_temme then begin
      igam_pqasymp(a,x,p,q);
      exit;
    end;
  end;

  {If calcdax=true this has already been done above}
  if not calcdax then dax := sfd_igprefix(a,x);

  if dax < MinDouble then begin
    {Special case:  dax is zero or denormal. Note that this will not}
    {really help if the un-normalised functions shall be calculated!}
    if a > x then p := 0.0 else p := 1.0;
    q := 1.0-p;
  end
  else begin
    {Calculate Taylor series or continued fraction}
    if x > 0.25 then alfa := x+0.25 else alfa := -ln2/ln(x);
    if a > alfa then igam_ptaylor(a,x,dax,p,q)
    else if x < 1.0 then igam_qtaylor(a,x,p,q)
    else igam_qfraction(a,x,dax,p,q);
  end;
end;


{---------------------------------------------------------------------------}
procedure sfd_incgamma(a,x: double; var p,q: double);
  {-Return the normalised incomplete gamma functions P and Q, a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x  )/gamma(a)}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}
var
  dax: double;
begin
  sfd_incgamma_ex(a,x,p,q,dax,false);
end;


{---------------------------------------------------------------------------}
function sfd_igammap(a,x: double): double;
  {-Return the normalised lower incomplete gamma function P(a,x), a>=0, x>=0}
  { P(a,x) = integral(exp(-t)*t^(a-1), t=0..x)/gamma(a)}
var
  p,q,dax: double;
begin
  sfd_incgamma_ex(a,x,p,q,dax,false);
  sfd_igammap := p;
end;


{---------------------------------------------------------------------------}
function sfd_igammaq(a,x: double): double;
  {-Return the normalised upper incomplete gamma function Q(a,x), a>=0, x>=0}
  { Q(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf)/gamma(a)}
var
  p,q,dax: double;
begin
  sfd_incgamma_ex(a,x,p,q,dax,false);
  sfd_igammaq := q;
end;


{---------------------------------------------------------------------------}
function sfd_igamma(a,x: double): double;
  {-Return the non-normalised upper incomplete gamma function}
  { GAMMA(a,x) = integral(exp(-t)*t^(a-1), t=x..Inf), x>=0}
var
  p,q,t,lnx: double;
  k: integer;
  ok: boolean;
begin
  if (x<0.0) or IsNanOrInfD(x) or IsNanOrInfD(a) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_igamma := NaN_d;
    exit;
  end;
  {Special cases: GAMMA(a,0) = gamma(a) and GAMMA(0,x) = E_1(x)}
  if x=0.0 then sfd_igamma := sfd_gamma(a)
  else if (a=0.0) and (x>0.0) then sfd_igamma := sfd_e1(x)
  else if (a>0) and (a<MAXGAMD) then begin
    {Result is just Q(a,x)*Gamma(a)}
    sfd_incgamma_ex(a,x,p,q,t,false);
    t := sfd_gamma(a);
    sfd_igamma := q*t;
  end
  else if a<0.0 then begin
    {Logic for a<0 is similar to GSL [21], function gamma_inc.c}
    if (x>0.25) or (a <= -10000) then begin
      t := a*ln(x)-x;
      if t>ln_MaxDbl then begin
        sfd_igamma := PosInf_d;
        exit;
      end;
      igam_qfraction(a,x,exp(t),p,q);
      sfd_igamma := q;
    end
    else if a >= -0.5 then begin
      igam_qtaylor(a,x,p,q);
      t := sfd_gamma(a);  {a <> 0!}
      sfd_igamma := q*t;
    end
    else begin
      {-10000 < a < -0.5}
      t := a - floor(a);
      {0 <= t < 1, set q = GAMMA(t,x) and use the recurrence formula}
      {NIST[30] 8.8.2:  GAMMA(t,x) = [GAMMA(t+1,x) - x^t*exp(-x)]/t }
      if t>0.0 then q := sfd_igammaq(t,x)*sfd_gamma(t)
      else q := sfd_e1(x);
      lnx := ln(x);
      for k:=1 to -floor(a) do begin
        t := t-1.0;
        p := -x + t*lnx;
        if p>ln_MaxDbl then begin
          sfd_igamma := PosInf_d;
          exit;
        end;
        q := (q-exp(p))/t;
      end;
      sfd_igamma := q;
    end
  end
  else begin
    {here a >= MAXGAMD, i.e. gamma(a) overflows}
    if (x >= 1.0) and (a < x+0.25) then begin
      {qfraction if t=x^a*exp(-x) is not too large}
      t := a*ln(x);
      ok := false;
      if (t < ln_MaxDbl) and (-x > ln_MinDbl) then begin
        t := power(x,a)*exp(-x);
        ok := true;
      end
      else if t-x < ln_MaxDbl then begin
        t := power(x/exp(x/a), a);
        ok := true;
      end;
      if ok then begin
        igam_qfraction(a,x,t,p,q);
        sfd_igamma := q;
        exit;
      end;
    end;
    {return Q(a,x)*Gamma(a) using lngamma}
    sfd_incgamma_ex(a,x,p,q,t,false);
    if q=0.0 then sfd_igamma := 0.0
    else begin
      t := sfd_lngamma(a);
      if q<0.75 then t := t + ln(q)
      else t := t + ln1p(-p);
      if t>ln_MaxDbl then sfd_igamma := PosInf_d
      else sfd_igamma := exp(t);
    end;
  end;
end;


{---------------------------------------------------------------------------}
function igaml_mser(a,x: double; var err: double): double;
  {-Return igaml_mser(a,x) = M(1,1+a,x) = igammal(a,x)*a*exp(x)/x^a}
var
  p,c,r,t,e: double;
  n: integer;
begin
  {Modified non-normalised Temme/Gautschi code for P(a,x), cf. igam_ptaylor}
  r := a;
  c := 1.0;
  p := 1.0;
  e := 1.0;
  n := 0;
  repeat
    r := r+1.0;
    c := c*x/r;
    p := p+c;
    t := abs(c);
    if t>e then e := t;
    inc(n);
  until t < abs(p)*eps_d;
  e := e*eps_d;
  if p<>0 then e := e/abs(p);
  err := 0.5*n*eps_d + e;
  igaml_mser := p;
end;


{---------------------------------------------------------------------------}
function sfd_igammal(a,x: double): double;
  {-Return the non-normalised lower incomplete gamma function}
  { gamma(a,x) = integral(exp(-t)*t^(a-1), t=0..x); x>=0, a<>0,-1,-2,..}
var
  r,t,p: double;
begin
  if (x<0.0) or IsNanOrInfD(x) or IsNanOrInfD(a) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_igammal := NaN_d;
    exit;
  end;
  if x=0.0 then sfd_igammal := 0.0
  else if a<=0.0 then begin
    if frac(a)=0.0 then begin
      {$ifopt R+}
        if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
      {$endif}
      sfd_igammal := NaN_d;
      exit;
    end;
    {Split for TP5}
    r := sfd_gamma(a);
    t := sfd_igamma(a,x);
    p := r-t;
    {$ifdef debug}
      if abs(p)<sqrt_epsh*(abs(t)+abs(r)) then begin
        sfd_write_debug_str('*** sfd_igammal: loss of accuracy');
      end;
    {$endif}
    sfd_igammal := p;
  end
  else if (a<MinDouble) then sfd_igammal := PosInf_d
  else if (a<MinDouble*x) then sfd_igammal := 1.0/a
  else if (x<a-0.25) or (x<4.0) then begin
    if a<MAXGAMD then begin
      {Result is just P(a,x)*Gamma(a) if P(a,x) <> 0}
      p := sfd_igammap(a,x);
      if p<>0.0 then begin
        r := sfd_gamma(a);
        sfd_igammal := p*r;
        exit;
      end;
    end;
    p := igaml_mser(a,x,t);
    {$ifdef debug}
      if abs(p)<t then begin
        sfd_write_debug_str('*** sfd_igammal: large error from igaml_mser');
      end;
    {$endif}
    {Now gamma(a,x) = x^a*exp(-x)*p/a, but handle possible overflows}
    t := a*ln(x)-x;
    r := t + ln(p/a);
    if r > ln_MaxDbl then sfd_igammal := PosInf_d
    else sfd_igammal := exp(r);
  end
  else begin
    {x>=4 and x >= a - 0.25}
    if a<MAXGAMD then begin
      {Split for TP5}
      r := sfd_gamma(a);
      t := sfd_igamma(a,x);
      p := r-t;
      {$ifdef debug}
        if abs(p)<sqrt_epsh*(abs(t)+abs(r)) then begin
          sfd_write_debug_str('*** sfd_igammal: loss of accuracy');
        end;
      {$endif}
      sfd_igammal := p;
    end
    else begin
      {Handle small window below overflow}
      sfd_igammal := PosInf_d;
      p := sfd_igammap(a,x);
      if p<>0 then begin
        t := ln(p) + sfd_lngamma(a);
        if t<=ln_MaxDbl then sfd_igammal := exp(t);
      end;
    end;
  end;
end;


{---------------------------------------------------------------------------}
function lnigam(a,x,alx: double): double;
  {-Return ln(igamma(a,x)) for large x and for a <= x, SLATEC d9lgic, alx=ln(x)}
var
  eps,k,p,r,s,t,xma,xpa: double;
const
  KMAX = 300;
begin
  xpa := x + 1.0 - a;
  xma := x - 1.0 - a;
  r   := 0.0;
  p   := 1.0;
  s   := p;
  k   := 0.0;
  eps := 0.25*eps_d;
  repeat
    k := k + 1.0;
    t := k*(a-k)*(1.0+r);
    r := -t/((xma+2.0*k)*(xpa+2.0*k)+t);
    p := r*p;
    s := s + p;
  until (abs(p) < eps*abs(s)) or (k>KMAX);
  lnigam := a*alx - x + ln(s/xpa);
  {$ifopt R+}
    if (k>KMAX) and (RTE_NoConvergence>0) then RunError(byte(RTE_NoConvergence));
  {$endif}
end;


{---------------------------------------------------------------------------}
function sfd_git(a,x: double): double;
  {-Return Tricomi's entire incomplete gamma function igammat(a,x)}
  { = igammal(a,x)/gamma(a)/x^a = P(a,x)/x^a }
var
  p,r,t,h: double;
  s: integer;
const
  alneps = 36.73680056967710139911; {-ln(0.5*eps_d)}
begin
  if IsNanOrInfD(x) or IsNanOrInfD(a) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_git := NaN_d;
    exit;
  end;
  if x=0.0 then begin
    sfd_git := sfd_rgamma(a+1.0);
    exit;
  end
  else if a=0.0 then begin
    sfd_git := 1.0;
    exit;
  end
  else if x<0.0 then begin
    if (a<0.0) and (frac(a)=0.0) then begin
      {NIST[30], 8.4.12}
      sfd_git := power(x,-a);
    end
    else begin
      {NIST[30], 8.5.2}
      h := sfd_1f1(1.0, a + 1.0, x);
      t := sfd_lngammas(a+1.0,s);
      sfd_git := s*h*exp(-(x+t));
    end;
    exit;
  end;


  if a>=0 then begin
    if (a > x+1.0) and (a+1.0 < MAXGAMD) then begin
      p := igaml_mser(a,x,t);
      {$ifdef debug}
        if abs(p)<t then begin
          sfd_write_debug_str('*** sfd_git: large error from igaml_mser');
        end;
      {$endif}
      r := exp(-x);
      t := sfd_gamma(a+1.0);
      sfd_git := (p*r)/t;
    end
    else begin
      p := sfd_igammap(a,x);
      t := power(x,-a);
      sfd_git := t*p;
    end;
  end
  else if frac(a)=0 then begin
    {NIST[30], 8.4.12}
    sfd_git := power(x,-a);
  end
  else begin
    {Here a < 0}
    if x < 1.0 then begin
      p := igaml_mser(a,x,t);
      {$ifdef debug}
        if abs(p)<t then begin
          sfd_write_debug_str('*** sfd_git: large error from igaml_mser');
        end;
      {$endif}
      if a > -MAXGAMD then begin
        r := exp(-x);
        t := sfd_gamma(a+1.0);
        sfd_git := (p*r)/t;
      end
      else begin
        t := sfd_lngammas(a+1.0,s);
        if p>0.0 then p := ln(p)
        else begin
          s := -s;
          p := ln(abs(p));
        end;
        t := p-x-t;
        sfd_git := exp(t)*s;
      end;
    end
    else begin
      {Here a<0, x >= 1}
      if a < -MAXGAMD then begin
        {Compute result using logarithmic form, see SLATEC, dgamit.f label 40}
        r := ln(x);
        p := lnigam(a,x,r);
        t := sfd_lngammas(a+1.0,s);
        t := ln(abs(a)) + p - t;
        if t <= alneps then begin
          h := 1.0;
          if t >= -alneps then begin
            h := 1.0 + s*exp(t);
            if abs(h)<sqrt_epsh then begin
              {$ifdef debug}
                {ex:  sfd_git(-179.5,49.32046374);}
                sfd_write_debug_str('*** sfd_git: loss of accuracy');
              {$endif}
            end;
          end;
          t := -a*r + ln(abs(h));
          if t>ln_MaxDbl then t := PosInf_d else t := exp(t);
          if h<0.0 then t := -t;
          sfd_git := t;
        end
        else begin
          t := t-a*r;
          if t>ln_MaxDbl then t := PosInf_d else t := exp(t);
          sfd_git := s*t;
        end;
      end
      else begin
        p := sfd_igamma(a,x);
        t := sfd_gamma(a);
        r := t-p;
        {$ifdef debug}
          if abs(r)<sqrt_epsh*abs(t) then begin
            sfd_write_debug_str('*** sfd_git: loss of accuracy');
          end;
        {$endif}
        p := r/t;
        t := power(x,-a);
        sfd_git := t*p;
      end;
    end;
  end;
end;


{---------------------------------------------------------------------------}
{----------------- Inverse Incomplete Gamma function -----------------------}
{---------------------------------------------------------------------------}

{---------------------------------------------------------------------------}
function DM_Fettis(a,lnB: double): double;
  {-Initial x for inverse incomplete gamma when a<1, q*Gamma(a) < 0.01}
var
  y,c1,c2,c3,c4,c5,a1,a2,a3: double;
begin
  {DiDonato & Morris [27], Eq (25)}
  y  := -lnB;
  a1 := a-1.0;
  a2 := sqr(a);
  a3 := a2*a;
  c1 := a1*ln(y);
  c2 := 1.0 + c1;
  c3 := (-0.5*c1 + (a-2.0))*c1 + (1.5*a-2.5);
  c4 := ((c1/THREE - (1.5*a-2.5))*c1 + (a2 -6.0*a + 7.0))*c1 + (11.0*a2 - 46.0*a+47.0)/6.0;
  c5 := (((-0.25*c1 + (11.0*a - 17.0)/6.0)*c1 + (-3.0*a2 + 13.0*a - 13.0))*c1
           + (a3 - 12.5*a2 + 36.0*a - 30.5))*c1
           + (25.0*a3 - 195.0*a2 + 477.0*a - 379.0)/12.0;
  DM_Fettis := ((((c5/y + c4)/y + c3)/y + c2)*a1/y + c1) + y;
end;


{---------------------------------------------------------------------------}
function DM_CF6(a,p,q: double): double;
  {-Cornish-Fisher 6-term approximation for inverse incomplete gamma}
const
  ca: array[0..3] of double = (3.31125922108741, 11.6616720288968, 4.28342155967104, 0.213623493715853);
  cb: array[0..4] of double = (1.0, 6.61053765625462, 6.40691597760039, 1.27364489782223, 0.3611708101884203e-1);
var
  rta,s,s2,t: double;
begin
  {DiDonato & Morris [27], Eq (32)}
  if p<0.5 then t := sqrt(-2.0*ln(p))
  else t := sqrt(-2.0*ln(q));
  s2 := PolEval(t,ca,4);
  s  := PolEval(t,cb,5);
  s  := t - s2/s;
  if p<0.5 then s := -s;
  {DiDonato & Morris [27], Eq (31)}
  s2  := s*s;
  rta := sqrt(a);
  t   := a + s*rta + (s2 - 1.0)/3.0 + s*(s2 - 7.0)/(36.0*rta)
           - ((3.0*s2 + 7.0)*s2 - 16.0)/(810.0*a)
           + s*((9.0*s2 + 256.0)*s2 - 433.0)/(38880.0*a*rta);
  if t<0.0 then DM_CF6 := 0.0
  else DM_CF6 := t;
end;


{---------------------------------------------------------------------------}
function igamma_inv_guess(a,p,q: double; var noiter: boolean): double;
  {-Return an initial approximation for inverse incomplete gamma}
var
  b,g,s,t,u,v,w,x,y,z,am1,ap1: double;
  i: integer;
const
  ln10 = 2.302585092994;
begin
  noiter := false;
  am1 := a-1.0;
  if a=1.0 then x := - ln(q)
  else if a<1.0 then begin
    g := sfd_gamma(a);
    b := q*g;
    if ((b > 0.6) or ((b >= 0.45) and (a >= 0.3))) then begin
      {DiDonato & Morris [27], Eq (21), see comment in Boost for a slight variation}
      if (b*q > 1e-8) and (q > 1e-5) then u := power(p*g*a, 1.0/a)
      else u := exp(-q/a - EulerGamma);
      x := u/(1.0 - u/(a+1.0));
    end
    else if (a < 0.3) and (b >= 0.35) then begin
      {DiDonato & Morris [27], Eq (22)}
      t := exp(-EulerGamma - b);
      u := t*exp(t);
      x := t*exp(u);
    end
    else if (b > 0.15) or (a >= 0.3) then begin
      {DiDonato & Morris [27], Eq (23)}
      y := -ln(b);
      v := y + am1*ln(y);
      x := y + am1*ln(v) - ln1p(-am1/(1.0+v));
    end
    else if b>0.1 then begin
      {DiDonato & Morris [27], Eq (24)}
      y := -ln(b);
      v := y + am1*ln(y);
      t := v*v + 2.0*(3.0-a)*v + (2.0-a)*(3.0-a);
      u := v*v + (5.0-a)*v + 2.0;
      x := y + am1*ln(v) - ln(u/t);
    end
    else begin
      {DiDonato & Morris [27], Eq (25)}
      x  := DM_Fettis(a,ln(b));
    end;
  end
  else begin {a > 1}
    w := DM_CF6(a,p,q);
    t := abs(1.0 - w/a);
    if (a >= 500.0) and (t < 1e-6) then begin
      x := w;
      if t<1e-17 then noiter := true;
    end
    else if p>0.5 then begin
      if w < 3.0*a then begin
        x := w;
      end
      else begin
        {here b = ln(q*Gamma(a)) = ln(B)}
        b := ln(q) + sfd_lngamma(a);
        t := maxd(2.0, a*am1);
        if b < -ln10*t then begin
          x := DM_Fettis(a,b)
        end
        else begin
          {DiDonato & Morris [27], Eq (33)}
          u := am1*ln(w) - b - ln1p(-am1/(1.0+w));
          x := am1*ln(u) - b - ln1p(-am1/(1.0+u));
        end;
      end
    end
    else begin
      {p < 0.5}
      z := w;
      ap1 := a+1.0;
      if w < 0.15*ap1 then begin
        {DiDonato & Morris [27], Eq (35)}
        v := ln(p) + sfd_lngamma(ap1);
        t := a+2.0;
        z := exp((v+w)/a);
        s := ln1p(z/ap1*(1.0 + z/t));
        z := exp((v + z - s)/a);
        {Note: the next line is missing in the Boost code!}
        s := ln1p(z/ap1*(1.0 + z/t));
        z := exp((v + z - s)/a);
        s := ln1p(z/ap1 * (1.0 + z/t*(1.0 + z/(a+3.0))));
        z := exp((v + z - s)/a);
      end;

      {WE: The setting noiter := true if z<0.002(a+1) has been dropped}
      if (z <= 0.01*ap1) or (z > 0.7*ap1) then begin
        x := z;
      end
      else begin
        {DiDonato & Morris [27], Eq (34)}
        i := 1;
        t := z/ap1;
        s := 1.0+t;
        while (i<100) and (t>1e-4) do begin
          inc(i);
          t := t*(z/(a+i));
          s := s+t;
        end;
        {DiDonato & Morris [27], Eq (36)}
        t := ln(p) + sfd_lngamma(ap1) - ln(s);
        z := exp((z+t)/a);
        x := z*(1.0 - (a*ln(z) - z - t)/(a-z));
      end;
    end;
  end;
  igamma_inv_guess := x;
end;


{---------------------------------------------------------------------------}
procedure sfd_incgamma_inv(a,p,q: double; var x: double; var ierr: integer);
  {-Return the inverse normalised incomplete gamma function, i.e. calculate}
  { x with P(a,x)=p and Q(a,x)=q. Input parameter a>0, p>=0, q>=0 and p+q=1.}
  { ierr is >= 0 for success, < 0 for input errors or iterations failures. }
var
  pn,qn,r,t,h,w,d,td,am1: double;
  done: boolean;
const
  eps  = 2.3e-11;    {~ (eps_d/2)^(2/3), cf. Boost's [19] 2/3*digits}
  tol  = 2.2e-11;
  rmin = 1.01-292;   {Threshold for derivative, ~MinDouble/eps_d}
begin

  {The classical reference is A.R. Didonato, A.H. Morris[27]. The original}
  {text and equations are used together with the Boost interpretation from}
  {\boost\math\special_functions\detail\igamma_inverse.hpp [19], which is }
  {Copyright John Maddock 2006, see 3rdparty.ama for Boost license}

  {Some of the ierr return codes from [27] are used: }
  { ierr >=  0, iteration count                      }
  { ierr  = -2, if a <= 0                            }
  { ierr  = -4, if p < 0, q < 0, or |p+q-1| > eps_d  }
  { ierr  = -6, if 10 iterations were performed      }
  { ierr  = -7, iteration failed                     }
  { ierr  = -8, x is calculated with unknown accuracy}

  x := -1.0;
  if a <= 0.0 then begin
    ierr := -2;
    exit;
  end;

  {Use eps_d for check because function may be called with 'double' p,q}
  if (p<0.0) or (q<0.0) or (abs(p+q-1.0)>eps_d) then begin
    ierr := -4;
    exit;
  end;

  if (p=1.0) and (q=0.0) then begin
    x := PosInf_d;
    exit;
  end;

  x := 0.0;
  ierr := 0;
  if p=0.0 then exit;

  if a=1.0 then begin
    {No guess, no iteration. Use known answer}
    if q <= 0.9 then x := -ln(q)
    else x := -ln1p(-p);
    exit;
  end;

  {Calculate initial approximation, done if no iteration needed/useful}
  x := igamma_inv_guess(a,p,q,done);
  if done then begin
    exit;
  end;

  if (p <= MinDouble) or (q <= MinDouble) then begin
    ierr := -8;
    exit;
  end;

  td   := tol*mind(p,q);  {iteration tolerance for |p-pn| or |q-qn|}
  am1  := a - 1.0;
  done := false;

  repeat
    {Note that DiDonato & Morris [27] use two different iteration loops:}
    {one for P and one for Q, they can be combined with minimal effort. }
    inc(ierr);
    if ierr>10 then begin
      ierr := -6;
      exit;
    end;
    sfd_incgamma_ex(a,x,pn,qn,r,true);
    if r<rmin then begin
      ierr := -8;
      exit;
    end;
    if p<=0.5 then d := pn-p else d := q-qn;
    t := d/r;
    w := 0.5*(am1-x);
    if (abs(t) < 0.1) and (abs(w*t) <= 0.1) then begin
      {Schr�der step}
      h := w*sqr(t);
      done := (abs(w) > 1.0) and (abs(h) < eps);
      h := t + h;
    end
    else begin
      {Newton step}
      h := t;
    end;
    x := x*(1.0-h);
    if x<=0.0 then begin
      ierr := -7;
      exit;
    end;
    if (abs(h) < eps) or (abs(d) < td) then done := true;
  until done;
end;


{---------------------------------------------------------------------------}
function sfd_igamma_inv(a,p,q: double): double;
  {-Return the inverse normalised incomplete gamma function, i.e. calculate}
  { x with P(a,x)=p and Q(a,x)=q. Input parameter a>0, p>=0, q>0 and p+q=1.}
var
  ierr: integer;
  x: double;
begin
  sfd_incgamma_inv(a,p,q,x,ierr);
  sfd_igamma_inv := x;
  if ierr<0 then begin
    if (ierr=-2) or (ierr=-4) then begin
      {$ifopt R+}
        if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
      {$endif}
      sfd_igamma_inv := NaN_d;
      exit;
    end;
    {$ifopt R+}
      if RTE_NoConvergence>0 then RunError(byte(RTE_NoConvergence));
    {$endif}
  end;
end;


{---------------------------------------------------------------------------}
function sfd_igammap_inv(a,p: double): double;
  {-Inverse incomplete gamma: return x with P(a,x)=p, a>=0, 0<=p<1}
begin
  sfd_igammap_inv := sfd_igamma_inv(a,p,1.0-p);
end;


{---------------------------------------------------------------------------}
function sfd_igammaq_inv(a,q: double): double;
  {-Inverse complemented incomplete gamma: return x with Q(a,x)=q, a>=0, 0<q<=1}
begin
  sfd_igammaq_inv := sfd_igamma_inv(a,1.0-q,q);
end;


{---------------------------------------------------------------------------}
function sfd_ilng(y: double): double;
  {-Inverse of lngamma: return x with lngamma(x) = y, y >= -0.12142, x > 1.4616}
var
  x,d,z: double;
const
  eps = 1.05e-10;   {~ 0.01*sqrt_epsh  }
  x0  = 1.462164;   {> zero of psi     }
  f0  = 2.36527212; {~ 1/(1-EulerGamma)}
begin
  if IsNanOrInfD(y) then begin
    if IsInfD(y) and (y>0.0) then sfd_ilng := y
    else sfd_ilng := NaN_d;
    exit;
  end;
  if y >= 10.0 then begin
    z := ln(y)-1.0;
    d := exp(ln(z)/z);
    x := y/z*d;
  end
  else if y > 3.0  then x := 3.5*ln1p(y)
  else if y > 0.15 then x := 2.25 + 0.9*y
  else if y >= -0.1214200001 then x := 2.00 + f0*y
  else begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_ilng := NaN_d;
    exit;
  end;
  repeat
    {Newton iteration}
    d := sfd_lngamma(x) - y;
    z := sfd_psi(x);
    d := d/z;
    x := x - d;
    if x < x0 then x := x0;
  until abs(d)<=eps*x;
  sfd_ilng := x;
end;


{--------------------------------------------------------------------------}
function sfd_ipsi(y: double): double;
  {-Inverse of psi, return x with psi(x)=y, y <= ln_MaxDbl}
var
  x,d,z,eps: double;
  k: integer;
const
  e0 = 1.05e-10; {~ 0.01*sqrt_epsh} 
  ym = 41.0;     {psi_inv(y) = exp(y) for y>ym} 
const
  tipsi: array[-4..2] of single = ( {psi_inv(0.5*k), k=-4..2}
           0.4926978, {-2}
           0.6113439, {-1.5}
           0.7850033, {-1}
           1.048595,  {-0.5}
           1.461632,  {0}
           2.124338,  {0.5}
           3.203172); {1}
begin
  if IsNanOrInfD(y) then begin
    if y=NegInf_D then sfd_ipsi := 0.0
    else sfd_ipsi := y;
    exit;
  end;

  if y < -2.0 then begin
    x := -1.0/y;
    if x<=Mindouble then begin
      {underflow}
      sfd_ipsi := x;
      exit;
    end;
    if y <= -8.0 then x := x + EulerGamma*sqr(x);
  end
  else if y <= 1.0 then begin
    {linear interpolation for -2 <= y <= 1}
    z := 2.0*y;
    k := floor(z); {k=-4..2}
    z := z-k;
    x := tipsi[k];
    if z<>0.0 then x := x + z*(tipsi[k+1] - x);
  end
  else if y>ln_MaxDbl then begin
    sfd_ipsi := PosInf_d;
    exit;
  end
  else begin
    {y > 1}
    x := exp(y);
    if y >= ym then begin
      sfd_ipsi := x;
      exit;
    end
    else x := x + 0.5*y;
  end;
  eps := 4.0*eps_d;
  k := 0;
  {Newton iteration}
  repeat
    {For first compare use small eps, this avoids false exit with good}
    {starting values but suboptimal rel. error, e.g. order eps_d^0.75 }
    if k=1 then eps := e0;
    inc(k);
    d := sfd_psi(x) - y;
    if d<>0.0 then begin
      z := sfd_trigamma(x);
      d := d/z;
      x := x - d;
    end;
  until abs(d)<=eps*x;
  sfd_ipsi := x;
end;




{---------------------------------------------------------------------------}
{------------------- Incomplete Beta functions -----------------------------}
{---------------------------------------------------------------------------}

{---------------------------------------------------------------------------}
function sfd_ibetaprefix(a,b,x,y: double): double;
  {-Return (x^a)(y^b)/Beta(a,b), x+y=1, using Lanczos approximation}
var
  res,c,
  agh,bgh,cgh,b1,b2,
  l,l1,l2,l3,ratio: double;
  sa: boolean;
begin

  {Ref: Boost [19], beta.hpp, function ibeta_power_terms}
  c := a + b;
  {combine power terms with Lanczos approximation}
  agh := a + lanczos_gm05;
  bgh := b + lanczos_gm05;
  cgh := c + lanczos_gm05;
  res := lanczos(c,true)/(lanczos(a,true)*lanczos(b,true));

  {l1 and l2 are the base of the exponents minus one}
  l1 := (x*b - y*agh) / agh;
  l2 := (y*a - x*bgh) / bgh;
  if mind(abs(l1), abs(l2)) < 0.2 then begin
    {when the base of the exponent is very near 1 we get really}
    {gross errors unless extra care is taken}
    if (l1*l2 > 0) or (mind(a, b) < 1) then begin
      if abs(l1) < 0.1 then res := res*exp(a*ln1p(l1))
      else res := res*power((x * cgh) / agh, a);
      if abs(l2) < 0.1 then res := res*exp(b*ln1p(l2))
      else res := res*power((y * cgh) / bgh, b);
    end
    else if maxd(abs(l1), abs(l2)) < 0.5 then begin
      sa := a < b;
      ratio := b / a;
      if (sa and (ratio*l2 < 0.1)) or ((not sa) and (l1/ratio > 0.1)) then begin
        l3 := expm1(ratio*ln1p(l2));
        l3 := l1 + l3 + l3*l1;
        l3 := a*ln1p(l3);
        res := res*exp(l3);
      end
      else begin
        l3 := expm1(ln1p(l1) / ratio);
        l3 := l2 + l3 + l3*l2;
        l3 := b*ln1p(l3);
        res := res*exp(l3);
      end;
    end
    else if abs(l1) < abs(l2) then begin
      {First base near 1 only}
      l := a*ln1p(l1) + b*ln((y*cgh) / bgh);
      res := res*exp(l);
    end
    else begin
      {Second base near 1 only}
      l := b*ln1p(l2) + a*ln((x*cgh) / agh);
      res := res*exp(l);
    end
  end
  else begin
    {general case:}
    b1 := (x*cgh) / agh;
    b2 := (y*cgh) / bgh;
    l1 := a*ln(b1);
    l2 := b*ln(b2);
    if (l1 >= ln_MaxDbl) or (l1 <= ln_MinDbl) or (l2 >= ln_MaxDbl) or (l2 <= ln_MinDbl) then begin
      {Oops, overflow, sidestep}
      if a < b then res := res*power(power(b2, b/a)*b1, a)
      else res := res*power(power(b1, a/b)*b2, b);
    end
    else begin
      {finally the normal case}
      res := res*power(b1,a)*power(b2,b);
    end;
  end;
  {combine with the leftover terms from the Lanczos approximation}
  res := res*sqrt(bgh/exp(1));
  res := res*sqrt(agh/cgh);
  sfd_ibetaprefix:= res;
end;


{---------------------------------------------------------------------------}
function ibeta_series(a, b, x: double; normalised: boolean): double;
  {-Power series for incomplete beta integral. Use when b*x is small }
var
  s, t, u, v, t1, z, ai: double;
  n: integer;
const
  nmax = 30000;
begin
  {Ref: Cephes [7], function pseriesl in ldouble/incbetl.c}
  ai := 1.0/a;
  u  := (1.0-b)*x;
  v  := u/(a+1.0);
  t1 := v;
  t  := u;
  n  := 2;
  s  := 0.0;
  z  := abs(t1+ai)*eps_d;
  if z=0.0 then z := sqr(eps_d);
  repeat
    u := (n - b)*x/n;
    t := t*u;
    v := t/(a + n);
    s := s + v;
    n := n + 1;
  until (abs(v) <= z) or (n>nmax);

  if (n>=nmax) and (RTE_NoConvergence>0) then begin
    RunError(byte(RTE_NoConvergence));
  end;

  s := (s + t1) + ai;
  if normalised then begin
    if a+b < MAXGAMD then begin
      t := sfd_beta(a,b);
      ibeta_series := s/t*power(x, a);
    end
    else begin
      u := a*ln(x);
      s := ln(s);
      t := sfd_lnbeta(a,b);
      ibeta_series := exp((u+s)-t);
    end;
  end
  else begin
    {no overflow because x <= 1, a > 0}
    ibeta_series := s*power(x, a);
  end;
end;


{---------------------------------------------------------------------------}
function ibeta_cf(a, b, x: double; type2: boolean): double;
  {-Continued fraction expansion type #1 or #2 for incomplete beta integral}
var
  xk, pk, pkm1, pkm2, qk, qkm1, qkm2: double;
  k1, k2, k3, k4, k5, k6, k7, k8: double;
  dk, r, t, ans, big, thresh: double;
  i,imax: integer;
begin
  {Ref: Cephes [7], functions incbcfl & incbdl in ldouble/incbetl.c}
  {The two continued fraction from [7] are almost identical and are}
  {merged into a single routine, selected by the type2 parameter.}
  k1 := a;
  k3 := a;
  k4 := a + 1.0;
  k5 := 1.0;
  k7 := k4;
  k8 := a + 2.0;

  pkm2 := 0.0;
  qkm2 := 1.0;
  pkm1 := 1.0;
  qkm1 := 1.0;

  ans  := 1.0;
  big  := ldexpd(1,63);

  r := 1.0;
  t := sqrt(maxd(a,b));
  if t<400.0 then t := 400.0
  else if t>32000.0 then t := 32000.0;
  imax := round(t);

  thresh := 3.0*eps_d;
  if type2 then begin
    k2 := b - 1.0;
    k6 := a + b;
    dk := -1.0;
    x  := x/(1.0 - x);
  end
  else begin
    k2 := a + b;
    k6 := b - 1.0;
    dk := 1.0;
  end;

  for i:=1 to imax do begin
    xk := - (x * k1 * k2) / (k3 * k4);
    pk := pkm1 + pkm2 * xk;
    qk := qkm1 + qkm2 * xk;
    pkm2 := pkm1;
    pkm1 := pk;
    qkm2 := qkm1;
    qkm1 := qk;

    xk := (x * k5 * k6) / (k7 * k8);
    pk := pkm1 + pkm2 * xk;
    qk := qkm1 + qkm2 * xk;
    pkm2 := pkm1;
    pkm1 := pk;
    qkm2 := qkm1;
    qkm1 := qk;

    if qk <> 0.0 then r := pk / qk;
    if r <> 0.0 then begin
      t := abs((ans - r) / r);
      ans := r;
    end
    else t := 1.0;

    if t < thresh then begin
      ibeta_cf := ans;
      exit;
    end;

    k1 := k1 + 1.0;
    k2 := k2 + dk;
    k3 := k3 + 2.0;
    k4 := k4 + 2.0;
    k5 := k5 + 1.0;
    k6 := k6 - dk;
    k7 := k7 + 2.0;
    k8 := k8 + 2.0;

    if abs(qk) + abs(pk) > big then begin
      pkm2 := pkm2 * eps_d;
      pkm1 := pkm1 * eps_d;
      qkm2 := qkm2 * eps_d;
      qkm1 := qkm1 * eps_d;
    end;
    if (abs(qk) < eps_d) or (abs(pk) < eps_d) then begin
      pkm2 := pkm2 * big;
      pkm1 := pkm1 * big;
      qkm2 := qkm2 * big;
      qkm1 := qkm1 * big;
    end;

  end;

  if RTE_NoConvergence>0 then begin
    RunError(byte(RTE_NoConvergence));
  end;
  ibeta_cf := ans;
end;


{---------------------------------------------------------------------------}
function basym(a,b,lambda,eps: double): double;
  {-Return I_x(a,b) for large a,b. lambda = (a+b)*(1-x) - b, }
  { eps is the tolerance used. It is assumed that lambda is  }
  { nonnegative and that a,b are greater than or equal to 15.}
  { -1 is returned if no convergence for array size num.     }
const
  num = 20; {maximum n value in the main repeat loop, must be even.}
  e0  = 1.128379167095512573896; {2/sqrt(Pi)}
  e1  = 0.353553390593273762200; {2^(-3/2)}
var
  a0,b0,c,d: array[0..num] of double;
var
  h,r,s,t,w,j0,j1,h2,r0,r1,t0,t1,w0,z0,z2,hn,zn,sum,znm1,bsum,dsum: double;
  i,j,m,n,im1,mm1,mmj: integer;
  done: boolean;
begin
  {Ref: [37] Algorithm 708, function BASYM}
  {ln1pmx = -rlog1}
  h := -a*ln1pmx(-lambda/a);
  t := -b*ln1pmx(lambda/b);
  h := h+t;
  t := exp(-h);
  if t=0.0 then begin
    basym := 0.0;
    exit;
  end;

  z0  := sqrt(h);
  z2  := 2.0*h;
  znm1:= 0.5*z0/e1;
  if a<b then begin
    h  := a/b;
    r0 := 1.0/(1.0+h);
    r1 := (b-a)/b;
    w0 := 1.0/sqrt(a*(1.0+h));
  end
  else begin
    h  := b/a;
    r0 := 1.0/(1.0+h);
    r1 := (b-a) / a;
    w0 := 1.0/sqrt(b*(1.0+h));
  end;

  a0[0]:= (2.0*r1)/THREE;
  c[0] := -0.5*a0[0];
  d[0] := -c[0];
  j0   := sfd_erfce(z0)*0.5/e0;
  j1   := e1;
  sum  := j0 + d[0]*w0*j1;
  s    := 1.0;
  h2   := h*h;
  hn   := 1.0;
  w    := w0;
  zn   := z2;

  n := 2;
  repeat
    hn := h2*hn;
    s  := s + hn;
    a0[n-1]:= 2.0*r0*(1.0+h*hn)/(n+2);
    a0[n]  := 2.0*r1*s/(n+3);

    for i:=n to n+1 do begin
      im1 := pred(i);
      r   := -0.5*succ(i);
      b0[0] := r*a0[0];
      for m:=2 to i do begin
        bsum := 0.0;
        mm1  := m-1;
        for j:=1 to mm1 do begin
          mmj := m-j;
          bsum := bsum + (j*r - mmj)*a0[j-1]*b0[mmj-1];
        end;
        b0[mm1] := r*a0[mm1] + bsum/m;
      end;
      c[im1] := b0[im1]/succ(i);
      dsum := 0.0;
      for j:=1 to im1 do dsum := dsum + d[im1-j]*c[j-1];
      d[im1] := -(dsum + c[im1]);
    end;

    j0 := e1*znm1 + (n-1)*j0;
    j1 := e1*zn   + n*j1;
    znm1 := z2*znm1;
    zn := z2*zn;
    w  := w0*w;
    t0 := d[n-1]*w*j0;
    w  := w0*w;
    t1 := d[n]*w*j1;
    sum := sum + (t0+t1);
    inc(n,2);
    done := abs(t0) + abs(t1) <= eps*sum;
  until done or (n>num);

  if done then begin
    {compute w = exp(-bcorr(a,b)) using sfd_lngcorr}
    w := sfd_lngcorr(b) - sfd_lngcorr(a+b);
    w := w + sfd_lngcorr(a);
    w := exp(-w);
    basym := e0*t*w*sum;
  end
  else basym := -1;
end;


{---------------------------------------------------------------------------}
function ccdf_binom(n,k: integer; x,y: double): double;
  {-Return complement of the binomial distribution}
var
  s,t,p: double;
  i: integer;
begin
  {Ref: Boost [19], beta.hpp, function binomial_ccdf}
  p := power(x,n);
  s := 1.0;
  if p>0.0 then begin
    t := s;
    for i:=pred(n) downto succ(k) do begin
      t := t*(succ(i)*y);
      t := t/((n-i)*x);
      s := s + t;
    end;
  end;
  ccdf_binom := s*p;
end;


{---------------------------------------------------------------------------}
function sfd_ibeta(a, b, x: double): double;
  {-Return the normalised incomplete beta function, a>0, b>0, 0 <= x <= 1}
  { sfd_ibeta = integral(t^(a-1)*(1-t)^(b-1) / beta(a,b), t=0..x)}
var
  a1, b1, x1, t, w, xc, y: double;
  flag : boolean;
begin

  {Refs:  Cephes[7], function incbetl in ldouble/incbetl.c}
  {and  Boost [19], beta.hpp; [37] Alg.708, function BASYM}

  if (a <= 0.0) or (b <= 0.0) or (x < 0.0) or (x > 1.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_ibeta := NaN_d;
    exit;
  end;

  if (x=0.0) or (x=1.0) then begin
    sfd_ibeta := x;
    exit;
  end
  else if b=1.0 then begin
    sfd_ibeta := power(x,a);
    exit;
  end
  else if (a<1e-22) and (b<1e-22) then begin
    sfd_ibeta  := b/(a+b);
    exit;
  end;

  flag := false;
  w := 1.0 - x;

  {here t corresponds to lambda from [19] and [37]}
  if a>b then t := a - (a+b)*x
  else t := (a+b)*w - b;

  {reverse a and b if x is greater than the mean}
  if t < 0 then begin
    flag := true;
    a1 := b;
    b1 := a;
    xc := x;
    x1 := w;
    t  := -t;
  end
  else begin
    a1 := a;
    b1 := b;
    xc := w;
    x1 := x;
  end;

  if (a>=100.0) and (b>=100.0) then begin
    {Check if asymptotic expansion can be used}
    if ((a1<=b1) and (t<=0.03*a1)) or ((a1>b1) and (t<=0.03*b1)) then begin
      t := basym(a1,b1,t,100.0*eps_d);
      if t>=0.0 then begin
        {convergence with current basym array size}
        if flag then t := 1.0 - t;
        sfd_ibeta := t;
        exit;
      end;
    end;
  end;

  if (b1<=40) and (frac(b1)=0) and (a1<=32000) and (frac(a1)=0) then begin
    {Use finite sum related to binomial distribution}
    t := ccdf_binom(round(a1+b1-1),round(a1-1), x1, xc);
  end
  else if (b1*x1 <= 1.0) and (x1 <= 0.95) then begin
    t := ibeta_series(a1, b1, x1, true);
  end
  else begin
    {choose expansion for optimal convergence}
    y := x1*(a1 + b1 - 2.0) - (a1 - 1.0);
    if y < 0.0 then w := ibeta_cf(a1, b1, x1, false)
    else w := ibeta_cf(a1, b1, x1, true) / xc;
    t := sfd_ibetaprefix(a1,b1,x1,xc);
    t := w*(t/a1);
  end;

  if flag then sfd_ibeta := 1.0 - t
  else sfd_ibeta := t;

end;


{---------------------------------------------------------------------------}
function sfd_nnbeta(a, b, x: double): double;
  {-Return the non-normalised incomplete beta function B_x(a,b)}
  { for 0<=x<=1, B_x = integral(t^(a-1)*(1-t)^(b-1), t=0..x).  }
var
  a1, b1, x1, t, w, xc, y: double;
  flag : boolean;
begin
  {Refs:  Cephes[7], function incbetl in ldouble/incbetl.c}
  {and  Boost [19], beta.hpp; [37] Alg.708, function BASYM}
  if (x < 0.0) or (x > 1.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_nnbeta := NaN_d;
    exit;
  end;

  if x=0.0 then begin
    sfd_nnbeta := 0.0;
    exit;
  end
  else if x=1.0 then begin
    sfd_nnbeta := sfd_beta(a,b);
    exit;
  end
  else if a=1.0 then begin
    sfd_nnbeta := -pow1pm1(-x,b)/b;
    exit;
  end
  else if b=1.0 then begin
    sfd_nnbeta := power(x,a)/a;
    exit;
  end;

  if (a<=0.0) or (b<=0.0) then begin
    if (a>0.0) or (frac(a)<>0.0) then begin
      {http://functions.wolfram.com/06.19.26.0005.01}
      y := sfd_2F1(a,1.0-b,a+1.0,x);
      w := power(x,a);
      sfd_nnbeta := (w/a)*y;
    end
    else begin
      {here: a is a negative integer or zero}
      if (b>0.0) or (frac(b)<>0.0) then begin
        {http://functions.wolfram.com/06.19.26.0007.01}
        y := sfd_2F1(1.0,a+b,b+1.0,1.0-x);
        w := power(1.0-x, b);
        t := power(x,a);
        y := (w*t/b)*y;
        t := sfd_beta(a,b);
        sfd_nnbeta := t-y;
      end
      else begin
        {$ifopt R+}
          if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
        {$endif}
        sfd_nnbeta := NaN_d;
      end;
    end;
    exit;
  end;

  flag := false;
  w := 1.0 - x;

  {here t corresponds to lambda from [19] and [37]}
  if a>b then t := a - (a+b)*x
  else t := (a+b)*w - b;

  {reverse a and b if x is greater than the mean}
  if t < 0 then begin
    flag := true;
    a1 := b;
    b1 := a;
    xc := x;
    x1 := w;
    t  := -t;
  end
  else begin
    a1 := a;
    b1 := b;
    xc := w;
    x1 := x;
  end;

  if (a>=100.0) and (b>=100.0) then begin
    {Check if asymptotic expansion can be used}
    if ((a1<=b1) and (t<=0.03*a1)) or ((a1>b1) and (t<=0.03*b1)) then begin
      t := basym(a1,b1,t,100.0*eps_d);
      if t>=0.0 then begin
        {convergence with current basym array size}
        if flag then t := 1.0 - t;
        w := sfd_beta(a1,b1);
        sfd_nnbeta := w*t;
        exit;
      end;
    end;
  end;

  if (b1*x1 <= 1.0) and (x1 <= 0.95) then begin
    t := ibeta_series(a1, b1, x1, false);
  end
  else begin
    {choose expansion for optimal convergence}
    y := x1*(a1 + b1 - 2.0) - (a1 - 1.0);
    if y < 0.0 then begin
      w := ibeta_cf(a1, b1, x1, false);
      t := power(xc, b1);
    end
    else begin
      w := ibeta_cf(a1, b1, x1, true);
      t := power(xc, b1 - 1.0);
    end;
    y := power(x1, a1);
    t := (t*y/a1)*w;
  end;

  if flag then begin
    {Anti Ver50 code}
    w := sfd_beta(a1,b1);
    sfd_nnbeta := w - t;
  end
  else sfd_nnbeta := t;

end;


{---------------------------------------------------------------------------}
function sfd_ibeta_inv(a, b, y: double): double;
  {-Return the functional inverse of the normalised incomplete beta function}
  { with a > 0, b > 0, and 0 <= y <= 1.}
var
  aa, bb, y0, yy, d, x, x0, x1, lgm, yp, di, dithresh, yl, yh, xt: double;
  i, rflg, dir, nflg: integer;

label
  ihalve, newt, breaknewt, done;

begin

  {Ref: Cephes[7], function incbil in ldouble/incbil.c}

  {The routine performs up to 15 Newton iterations to find the root of}
  {ibeta(a,b,x) - y = 0. If Newton failed or is not applicable interval}
  {halving is used. The Pascal input variables are renamed to a,b,y.}

  if (a <= 0.0) or (b <= 0.0) or (y < 0.0) or (y > 1.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_ibeta_inv := NaN_d;
    exit;
  end;

  if (y=0.0) or (y=1.0) then begin
    sfd_ibeta_inv := y;
    exit;
  end;

  {Copy Pascal input to C variables}
  aa := a;
  bb := b;
  yy := y;

  x0 := 0.0;
  yl := 0.0;
  x1 := 1.0;
  yh := 1.0;
  nflg := 0;

  if (aa <= 1.0) or (bb <= 1.0) then begin
    dithresh := 1e-7;
    rflg := 0;
    y0 := yy;
    x  := a/(a+b);
    y  := sfd_ibeta(a, b, x);
    goto ihalve;
  end
  else dithresh := 1e-4;

  {approximation to inverse function}
  yp := sfd_erfc_inv(2.0*yy)*sqrt2;

  if yy > 0.5 then begin
    rflg := 1;
    a  := bb;
    b  := aa;
    y0 := 1.0 - yy;
    yp := -yp;
  end
  else
  begin
    rflg := 0;
    a  := aa;
    b  := bb;
    y0 := yy;
  end;

  lgm := (yp*yp - 3.0)/6.0;

  y := 1.0 / (2.0*a-1.0);
  x := 1.0 / (2.0*b-1.0);
  d := y - x;
  x := 2.0 / (y + x);
  d := d*(lgm + 5.0/6.0 - 2.0/(3.0*x));
  d := 2.0*(d + yp*sqrt(x+lgm)/x);
  if d < ln_MinDbl then begin
    {underflow}
    x := 0.0;
    goto done;
  end;

  x  := a/(a+b*exp(d));
  y  := sfd_ibeta(a, b, x);
  yp := (y-y0)/y0;
  if abs(yp) < 0.2 then goto newt;

  {resort to interval halving if not close enough}
ihalve:

  dir := 0;
  di  := 0.5;

  for i:=0 to 400 do begin
    if i<>0 then begin
      x := x0 + di*(x1-x0);
      if x=1.0 then x := 1.0-eps_d;
      if x=0.0 then begin
        di := 0.5;
        x  := x0 + di * (x1 - x0);
        if x=0.0 then goto done; {underflow}
      end;
      y := sfd_ibeta(a, b, x);
      yp := (x1 - x0) / (x1 + x0);
      if abs(yp) < dithresh then goto newt;
      yp := (y-y0)/y0;
      if abs(yp) < dithresh then goto newt;
    end;
    if y<y0 then begin
      x0 := x;
      yl := y;
      if dir < 0 then begin
        dir := 0;
        di  := 0.5;
      end
      else if dir > 3 then di := 1.0 - sqr(1.0-di)
      else if dir > 1 then di := 0.5*di + 0.5
      else di := (y0-y)/(yh-yl);

      inc(dir);

      if x0 > 0.75 then begin
        if rflg = 1 then begin
          rflg := 0;
          a  := aa;
          b  := bb;
          y0 := yy;
        end
        else begin
          rflg := 1;
          a  := bb;
          b  := aa;
          y0 := 1.0 - yy;
        end;
        x  := 1.0 - x;
        y  := sfd_ibeta(a, b, x);
        x0 := 0.0;
        yl := 0.0;
        x1 := 1.0;
        yh := 1.0;
        goto ihalve
      end
    end
    else begin
      x1 := x;
      if (rflg=1) and (x1<eps_d) then begin
        x := 0.0;
        goto done
      end;
      yh := y;
      if dir>0 then begin
        dir := 0;
        di  := 0.5
      end
      else if dir < -3 then di := sqr(di)
      else if dir < -1 then di := 0.5*di
      else di := (y-y0)/(yh - yl);
      dec(dir);
    end;
  end; {for i}

  if RTE_NoConvergence>0 then RunError(byte(RTE_NoConvergence));

  if x0 >= 1.0 then begin
    x := 1.0 - eps_d;
    goto done;
  end;

  if x <= 0.0 then begin
    x := 0.0;
    goto done;
  end;

newt:

  if nflg = 1 then goto done;

  nflg := 1;
  lgm  := -sfd_lnbeta(a, b);
  for i:=0 to 14 do begin
    {compute the function at this point}
    if i<>0 then y := sfd_ibeta(a, b, x);
    if y < yl then begin
      x := x0;
      y := yl;
    end
    else if y > yh then begin
      x := x1;
      y := yh;
    end
    else if y < y0 then begin
      x0 := x;
      yl := y;
    end
    else begin
      x1 := x;
      yh := y;
    end;

    if (x=1.0) or (x=0.0) then goto breaknewt;

    {compute the derivative of the function at this point}
    d := (a-1.0)*ln(x) + (b-1.0)*ln1p(-x) + lgm;
    if d < ln_MinDbl then goto done;
    if d > ln_MaxDbl then goto breaknewt;
    d := exp(d);

    {compute the step to the next approximation of x}
    d  := (y-y0)/d;
    xt := x - d;
    if xt <= x0 then begin
      y  := (x-x0)/(x1-x0);
      xt := x0 + 0.5*y*(x-x0);
      if xt <= 0.0 then goto breaknewt;
    end;
    if xt >= x1 then begin
      y  := (x1-x)/(x1-x0);
      xt := x1 - 0.5*y*(x1-x);
      if xt >= 1.0 then goto breaknewt;
    end;
    x := xt;
    if abs(d/x) < 128.0*eps_d then goto done
  end;

breaknewt:
  {Newton steps did not converge}
  dithresh := 256.0*eps_d;
  goto ihalve;

done:
  if rflg=1 then begin
    if x <= eps_d then x := 1.0-eps_d
    else x := 1.0-x;
  end;

  sfd_ibeta_inv := x;
end;


end.
