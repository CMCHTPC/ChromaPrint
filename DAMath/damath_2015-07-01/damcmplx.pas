unit DAMCmplx;

{DAMath based Complex routines}

interface

{$i STD.INC}

{$ifdef BIT16}
{$N+,F+}
{$endif}

(*************************************************************************

 DESCRIPTION   :  DAMath based Complex routines


 REQUIREMENTS  :  BP7, D1-D7/D9-D10/D12/D17-D18, FPC, VP, WDOSX

 EXTERNAL DATA :  ---

 MEMORY USAGE  :  ---

 DISPLAY MODE  :  ---

 REFERENCES    : References used in this unit, main index in damath_info.txt/references

                  [1] [HMF]: M. Abramowitz, I.A. Stegun. Handbook of Mathematical Functions. Dover, 1970
                      http://www.math.sfu.ca/~cbm/aands/
                 [13] W.H. Press et al, Numerical Recipes in C, 2nd ed., Cambridge, 1992,
                      http://www.nrbook.com/a/bookcpdf.html
                 [19] Boost C++ Libraries, Release 1.42.0, 2010, (or newer)
                      http://www.boost.org/
                 [30] [NIST]: F.W.J. Olver, D.W. Lozier, R.F. Boisvert, C.W. Clark, NIST Handbook
                      of Mathematical Functions, Cambridge, 2010. Online resource: NIST Digital
                      Library of Mathematical Functions, http://dlmf.nist.gov/
                 [32] D.E. Knuth: The Art of computer programming; Volume 1, Fundamental
                      Algorithms, 3rd ed., 1997; Volume 2, Seminumerical Algorithms, 3rd
                      ed., 1998; http://www-cs-faculty.stanford.edu/~knuth/taocp.html
                 [33] http://functions.wolfram.com/: Formulas and graphics about
                      mathematical functions for the mathematical and scientific
                      community and/or http://mathworld.wolfram.com/ ("/the web's
                      most extensive mathematical resource/")
                 [61] W. Kahan, "Branch Cuts for Complex Elementary Functions, or Much Ado
                      About Nothing's Sign Bit", in The State of Art in Numerical Analysis,
                      ed. by A. Iserles and M.J.D. Powell, 1987, pp. 165-211.
                      Available as http://people.freebsd.org/~das/kahan86branch.pdf
                 [62] PARI/GP: Open Source Number Theory-oriented Computer Algebra System,
                      available from http://pari.math.u-bordeaux.fr/
                 [63] R.M. Corless, J.H. Davenport, D.J. Jeffrey, and S.M. Watt, "According to
                      Abramowitz and Stegun" or arccoth needn't be uncouth. SIGSAM BULLETIN:
                      Communications on Computer Algebra, 34(2), June 2000. Available as
                      http://www.sigsam.org/bulletin/articles/132/paper12.pdf or from the Ontario
                      Research Centre for Computer Algebra http://www.orcca.on.ca/TechReports/2000/TR-00-17.html

 Version  Date      Author      Modification
 -------  --------  -------     ------------------------------------------
 0.10     22.12.13  W.Ehrhardt  Initial version from CAMath
 0.11     27.12.13  we          csc,csch,sec,sech,arccsc,arccsch,arcsec,arcsech
 0.12     28.12.13  we          special case for cpow
 0.13     29.12.13  we          ccbrt as cnroot(z,3,w)
 0.14     31.12.13  we          carccot/h for very small z
 0.15     03.01.14  we          carccos, carcsin for small z
 0.16     04.01.14  we          'uses damath' moved to implementation
 0.17     07.01.14  we          Fix carctanh for very small |x| and on the cut

 0.18     28.01.14  we          DAMCmplx_Version
 0.19     28.01.14  we          branch point series
 0.20     28.01.14  we          use arccsch(z) = i*arccsc(i*z), arccothc(z) = i*arccotc(i*z)
 0.21     16.02.14  we          cagm1, cagm, csurd, ccis, cnroot1
 0.22     22.02.14  we          cset
 0.23     25.02.14  we          Improved cagm

 0.24     16.03.14  we          Improved carccsc/sec/sech without branch point series
 0.25     16.03.14  we          Improved carccoth, carccot(z) = i*carccoth(i*z)
 0.26     20.03.14  we          csgn, changed agmstep1 to allow in/out overlap
 0.27     29.03.14  we          clngamma
 0.28     30.03.14  we          cgamma
 0.29     31.03.14  we          Improved clngamma near 0,1,2

 0.30     19.04.14  we          cpowx, clog10, clogbase
 0.31     24.04.14  we          cln1p, cexpm1
 0.32     26.04.14  we          cpolar

 0.33     24.05.14  we          improved cln1p, cexpm1

 0.34     07.10.14  we          cpoly, cpolyr
 0.35     09.10.14  we          cpsi

 0.36     07.11.14  we          fix value of C_1.re
 0.37     07.11.14  we          cdilog
 0.38     10.11.14  we          csqrt1mz2
 0.39     10.11.14  we          cellk/cellck

 0.40     15.12.14  we          const z in agm1sz

 0.41     26.06.15  we          Fix: double y in csqrt1mz2

***************************************************************************)


(*-------------------------------------------------------------------------
 (C) Copyright 2013-2015 Wolfgang Ehrhardt

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

const
  DAMCmplx_Version = '0.41';


type
  complex = record
              re: double; {real part     }
              im: double; {imaginary part}
            end;

const
  C_I: complex = (re: 0.0; im: 1.0);  {i = (0,1)}
  C_0: complex = (re: 0.0; im: 0.0);  {complex 0}
  C_1: complex = (re: 1.0; im: 0.0);  {complex 1}


function  cabs(const z: complex): double;          {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex absolute value |z| = sqrt(z.re^2 + z.im^2)}

procedure cadd(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex sum z = x + y}

procedure cagm(const x,y: complex; var w: complex);
  {-Return the 'optimal' arithmetic-geometric mean w = AGM(x,y)}

procedure cagm1(const z: complex; var w: complex);
  {-Return the 'optimal' arithmetic-geometric mean w = AGM(1,z)}

procedure carccos(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cosine w = arccos(z)}

procedure carccosh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cosine w = arccosh(z)}

procedure carccot(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cotangent w = arccot(z) = arctan(1/z)}

procedure carccotc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cotangent w = arccotc(z) = Pi/2 - arctan(z)}

procedure carccoth(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cotangent w = arccoth(z) = arctanh(1/z)}

procedure carccothc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cotangent w = arccothc(z) = arctanh(z) + i*Pi/2}

procedure carccsc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cosecant w = arccsc(z) = arcsin(1/z)}

procedure carccsch(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cosecant w = arccsch(z) = arcsinh(1/z)}

procedure carcsec(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular secant w = arcsec(z) = arccos(1/z)}

procedure carcsech(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic secant w = arcsech(z) = arccosh(1/z)}

procedure carcsin(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular sine w = arcsin(z)}

procedure carcsinh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic sine w = arcsinh(z)}

procedure carctan(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular tangent w = arctan(z)}

procedure carctanh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic tangent w = arctanh(z)}

function  carg(const z: complex): double;          {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the principle value of the argument or phase angle arg(z) = arctan2(z.im, z.re)}

procedure ccbrt(const z: complex; var w: complex);
  {-Return the complex principal cube root w = cbrt(z) = z^(1/3)}

procedure ccis(x: double; var z: complex);           {$ifdef HAS_INLINE} inline;{$endif}
  {-Return z = exp(i*x) = cos(x) + i*sin(x)}

procedure cconj(const z: complex; var w: complex);   {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex conjugate w = z.re - i*z.im}

procedure ccos(const z: complex; var w: complex);
  {-Return the complex circular cosine w = cos(z)}

procedure ccosh(const z: complex; var w: complex);
  {-Return the complex hyperbolic cosine w = cosh(z)}

procedure ccot(const z: complex; var w: complex);
  {-Return the complex circular cotangent w = cot(z)}

procedure ccoth(const z: complex; var w: complex);
  {-Return the complex hyperbolic cotangent w = coth(z)}

procedure ccsc(const z: complex; var w: complex);
  {-Return the complex circular cosecant w = csc(z) = 1/sin(z)}

procedure ccsch(const z: complex; var w: complex);
  {-Return the complex hyperbolic cosecant w = csch(z) = 1/sinh(z)}

procedure cdilog(const z: complex; var w: complex);
  {-Return the principal branch of the complex dilogarithm w = -integral(ln(1-t)/t, t=0..z)}

procedure cdiv(const x,y: complex; var z: complex);
  {-Return the quotient z = x/y}

procedure cellk(const k: complex; var w: complex);
  {-Return w = K(k), the complete elliptic integral of the first kind}

procedure cellck(const k: complex; var w: complex);
  {-Return w = K'(k), the complementary complete elliptic integral of the first kind}

procedure cexp(const z: complex; var w: complex);
  {-Return the complex exponential function w = exp(z)}

procedure cexpm1(const z: complex; var w: complex);
  {-Return w = exp(z)-1, accuracy improved for z near 0}

procedure cgamma(const z: complex; var w: complex);
  {-Return the complex Gamma function w = Gamma(z)}

procedure cinv(const z: complex; var w: complex);
  {-Return the complex inverse w = 1/z}

procedure cln(const z: complex; var w: complex);
  {-Return the complex natural logarithm w = ln(z); principal branch ln(|z|) + i*arg(z), accurate near |z|=1}

procedure cln1p(const z: complex; var w: complex);
  {-Return the principal branch of ln(1+z), accuracy improved for z near 0}

procedure clngamma(const z: complex; var w: complex);
  {-Return w = lnGamma(z), the principal branch of the log-Gamma function}

procedure clog10(const z: complex; var w: complex);
  {-Return the principal branch of the base 10 logarithm of z, w=ln(z)/ln(10)}

procedure clogbase(const b,z: complex; var w: complex);
  {-Return the principal branch of the base b logarithm of z, w=ln(z)/ln(b)}

procedure cmul(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex product z = x*y}

procedure cneg(const z: complex; var w: complex);    {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the negative w = -z}

procedure cnroot(const z: complex; n: integer; var w: complex);
  {-Return the complex principal n'th root w = z^(1/n)}

procedure cnroot1(n: integer; var z: complex);
  {-Return the principal nth root of unity z = exp(2*Pi*i/n)}

procedure cpolar(const z: complex; var r,theta: double);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the polar form z = r*exp(i*theta) with r = |z|, theta = arg z}

procedure cpoly(const z: complex; const a: array of complex; n: integer; var w: complex);
  {-Evaluate polynomial; return a[0] + a[1]*z + ... + a[n-1]*z^(n-1)}

procedure cpolyr(const z: complex; const a: array of double; n: integer; var w: complex);
  {-Evaluate polynomial; return a[0] + a[1]*z + ... + a[n-1]*z^(n-1)}

procedure cpow(const z,a: complex; var w: complex);
  {-Return the principal value of the complex power w = z^a = exp(a*ln(z))}

procedure cpowx(const z: complex; x: double; var w: complex);
  {-Return the principal value w = z^x = |z|^x * exp(i*x*arg(z))}

procedure cpsi(const z: complex; var w: complex);
  {-Return the complex digamma function w = psi(z), z <> 0,-1,-2...}

procedure csec(const z: complex; var w: complex);
  {-Return the complex circular secant w = sec(z) = 1/cos(z)}

procedure csech(const z: complex; var w: complex);
  {-Return the complex hyperbolic secant w = sech(z) = 1/cosh(z)}

procedure cset(var z: complex; x,y: double);   {$ifdef HAS_INLINE} inline;{$endif}
  {-Set real and imaginary part of z = x+iy}

function  csgn(const z: complex): integer;
  {-Return the sign of z. Result = isign(z.re) if z.re<>0, isign(z.im) otherwise}

procedure csin(const z: complex; var w: complex);
  {-Return the complex circular sine w = sin(z)}

procedure csinh(const z: complex; var w: complex);
  {-Return the complex hyperbolic sine w = sinh(z)}

procedure csqr(const z: complex; var w: complex);    {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the square w = z^2}

procedure csqrt(const z: complex; var w: complex);
  {-Return the complex principal square root w = sqrt(z)}

procedure csqrt1mz2(const z: complex; var w: complex);
  {-Return the complex principal square root w = sqrt(1-z^2)}

procedure csub(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex difference z = x - y}

procedure csurd(const z: complex; n: integer; var w: complex);
  {-Return the complex n'th root w = z^(1/n) with arg(w) closest to arg(z)}

procedure ctan(const z: complex; var w: complex);
  {-Return the complex circular tangent w = tan(z)}

procedure ctanh(const z: complex; var w: complex);
  {-Return the complex hyperbolic tangent w = tanh(z)}

{#Z+}
{-------------------------------------------------------------------}
{---------------------- Internal functions -------------------------}
{-------------------------------------------------------------------}
{#Z-}
procedure rdivc(x: double; const y: complex; var z: complex);
  {-Return the quotient z = x/y for real x}

procedure cx_sqrt(a,b: double; var u,v: double);
  {-Return u + iv := sqrt(a + bi)}

procedure coshsinhmult(y,a,b: double; var u,v: double);
  {-Return u = a*cosh(y), v = b*sinh(y) with |a|,|b| <= 1}


implementation


uses
  DAmath;

const
  MV_4  : double = 0.44942328371e308;  {< MaxDouble/4}
  MV_125: double = 0.14381545079e309;  { ~MaxDouble/1.25}
  SLB   : double = 0.29833362925e-153; {> 2*sqrt_MinDbl}
  SUB   : double = 0.670390396497e154; {< sqrt_MaxDbl/2}


{---------------------------------------------------------------------------}
function cabs(const z:complex): double;  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex absolute value |z| = sqrt(z.re^2 + z.im^2)}
begin
  cabs := hypot(z.re, z.im);
end;


{---------------------------------------------------------------------------}
function carg(const z: complex): double;  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the principle value of the argument or phase angle arg(z) = arctan2(z.im, z.re)}
begin
  carg := arctan2(z.im, z.re);
end;


{---------------------------------------------------------------------------}
procedure cconj(const z: complex; var w: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex conjugate w = z.re - i*z.im}
begin
  w.re :=  z.re;
  w.im := -z.im;
end;


{---------------------------------------------------------------------------}
procedure cneg(const z: complex; var w: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the negative w = -z}
begin
  w.re := -z.re;
  w.im := -z.im;
end;


{---------------------------------------------------------------------------}
procedure cpolar(const z: complex; var r,theta: double);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the polar form z = r*exp(i*theta) with r = |z|, theta = arg z}
begin
  r := hypot(z.re, z.im);
  theta := arctan2(z.im, z.re);
end;


{---------------------------------------------------------------------------}
procedure csqr(const z: complex; var w: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the square w = z^2}
var
  t: double;
begin
  t := (z.re - z.im)*(z.re + z.im);
  w.im := 2.0*z.re*z.im;
  w.re := t;
end;


{---------------------------------------------------------------------------}
procedure cadd(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex sum z = x + y}
begin
  z.re := x.re + y.re;
  z.im := x.im + y.im;
end;


{---------------------------------------------------------------------------}
procedure csub(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex difference z = x - y}
begin
  z.re := x.re - y.re;
  z.im := x.im - y.im;
end;


{---------------------------------------------------------------------------}
procedure cmul(const x,y: complex; var z: complex);  {$ifdef HAS_INLINE} inline;{$endif}
  {-Return the complex product z = x*y}
var
  t: double;
begin
  t    := x.re*y.re - x.im*y.im;
  z.im := x.re*y.im + x.im*y.re;
  z.re := t;
end;


{---------------------------------------------------------------------------}
procedure cset(var z: complex; x,y: double);   {$ifdef HAS_INLINE} inline;{$endif}
  {-Set real and imaginary part of z = x+iy}
begin
  z.re := x;
  z.im := y;
end;


{---------------------------------------------------------------------------}
procedure cdiv(const x,y: complex; var z: complex);
  {-Return the quotient z = x/y}
var
  d,q,t: double;
begin
  {Smith's method: see Knuth[32], Exercise 4.2.1.16 and NR[13], (5.4.5)}
  if abs(y.re) >= abs(y.im) then begin
    q := y.im/y.re;
    d := y.re + q*y.im;
    t := (x.re + q*x.im)/d;
    z.im := (x.im - q*x.re)/d;
    z.re := t;
  end
  else begin
    q := y.re/y.im;
    d := y.im + q*y.re;
    t := (q*x.re + x.im)/d;
    z.im := (q*x.im - x.re)/d;
    z.re := t;
  end;
end;


{---------------------------------------------------------------------------}
procedure rdivc(x: double; const y: complex; var z: complex);
  {-Return the quotient z = x/y for real x}
var
  d,q: double;
begin
  {Stripped-down version of cdiv}
  if abs(y.re) >= abs(y.im) then begin
    q := y.im/y.re;
    if abs(y.re) < MV_4 then d := y.re + q*y.im
    else begin
      d := 0.5*y.re + 0.5*q*y.im;
      x := 0.5*x;
    end;
    z.im := -(q*x)/d;
    z.re := x/d;
  end
  else begin
    q := y.re/y.im;
    if abs(y.re) < MV_4 then d := y.im + q*y.re
    else begin
      d := 0.5*y.im + 0.5*q*y.re;
      x := 0.5*x;
    end;
    z.re := (q*x)/d;
    z.im := -x/d;
  end;
end;


{---------------------------------------------------------------------------}
procedure cinv(const z: complex; var w: complex);
  {-Return the complex inverse w = 1/z}
begin
  rdivc(1.0,z,w);
end;


{---------------------------------------------------------------------------}
procedure cx_sqrt(a,b: double; var u,v: double);
  {-Return u + iv := sqrt(a + bi)}
var
  x,y,r,t: double;
begin
  x := abs(a);
  y := abs(b);
  if (x=0.0) and (y=0.0) then begin
    u := 0.0;
    v := 0.0;
  end
  else begin
    {Ref: NR[13], (5.4.6/7), see also HMF[1], 3.7.27}
    if x >= y then begin
      r := y/x;
      t := x;
      r := 0.5*(1.0+sqrt(1.0+r*r));
    end
    else begin
      r := x/y;
      t := y;
      r := 0.5*(r+sqrt(1.0+r*r));
    end;
    if t<=MV_125 then t := sqrt(t*r)
    else t := sqrt(t)*sqrt(r);
    if a >= 0.0 then begin
      u := t;
      v := 0.5*(b/t);
    end
    else begin
      if b < 0.0 then t := -t;
      u := 0.5*(b/t);
      v := t;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure csqrt(const z: complex; var w: complex);
  {-Return the complex principal square root w = sqrt(z)}
begin
  cx_sqrt(z.re,z.im,w.re,w.im);
end;


{---------------------------------------------------------------------------}
procedure csqrt1mz2(const z: complex; var w: complex);
  {-Return the complex principal square root w = sqrt(1-z^2)}
var
  u: complex;
  y: double;
begin
  y := z.im;
  if (abs(z.re) < SUB) and (abs(y) < SUB) then begin
    u.re := (1.0-z.re)*(1.0+z.re) + sqr(y);
    u.im := -2.0*z.re*y;
    csqrt(u,w);
  end
  else begin
    {w = +- Iz with w.re >= 0}
    if y >= 0.0 then begin
      w.im := -z.re;
      w.re :=  y;
    end
    else begin
      w.im :=  z.re;
      w.re := -y;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure cpolyr(const z: complex; const a: array of double; n: integer; var w: complex);
  {-Evaluate polynomial; return a[0] + a[1]*z + ... + a[n-1]*z^(n-1)}
var
  u: complex;
  x: double;
  i: integer;
begin
  if n<=1 then begin
    w.im := 0.0;
    if n=1 then w.re := a[0]
    else w.re := 0.0;
    exit;
  end;
  {$ifdef debug}
    if n>high(a)+1 then begin
      writeln('cpolyr:  n > high(a)+1, n = ',n, ' vs. ', high(a)+1);
      readln;
      if n>high(a)+1 then n := high(a)+1;
    end;
  {$endif}
  u.re := a[n-1];
  u.im := 0;
  for i:=n-2 downto 0 do begin
    {u = u*z + a[i]}
    x := u.re*z.re - u.im*z.im;
    u.im := u.re*z.im + u.im*z.re;
    u.re := x + a[i];
  end;
  w.re := u.re;
  w.im := u.im;
end;


{---------------------------------------------------------------------------}
procedure cpoly(const z: complex; const a: array of complex; n: integer; var w: complex);
  {-Evaluate polynomial; return a[0] + a[1]*z + ... + a[n-1]*z^(n-1)}
var
  u: complex;
  x: double;
  i: integer;
begin
  if n<=1 then begin
    if n=1 then w := a[0]
    else w := C_0;
    exit;
  end;
  {$ifdef debug}
    if n>high(a)+1 then begin
      writeln('cpolyr:  n > high(a)+1, n = ',n, ' vs. ', high(a)+1);
      readln;
      if n>high(a)+1 then n := high(a)+1;
    end;
  {$endif}
  u := a[n-1];
  for i:=n-2 downto 0 do begin
    {u = u*z + a[i]}
    x := u.re*z.re - u.im*z.im;
    u.im := u.re*z.im + u.im*z.re + a[i].im;
    u.re := x + a[i].re;
  end;
  w.re := u.re;
  w.im := u.im;
end;


{---------------------------------------------------------------------------}
procedure cln(const z: complex; var w: complex);
  {-Return the complex natural logarithm w = ln(z); principal branch ln(|z|) + i*arg(z), accurate near |z|=1}
var
  a,x,y: double;
begin
  {Ref: HMF[1], 4.1.2/3, accuracy improved for |z| near 1}
  x := abs(z.re);
  y := abs(z.im);
  if x<y then begin
    a := x;
    x := y;
    y := a;
  end;
  if (x<0.5) or (x>1.5) or (x+y>2.0) then a := ln(hypot(x, y))
  else begin
    {avoid inaccuracies for |z|~1, eg ln(1e-20 + i) ~ 0.5e-40 + Pi/2}
    {ln(|z|) = 0.5*ln(x^2 + y^2) = 0.5*ln1p[(x^2-1) + y^2]}
    a := ln1p((x-1.0)*(x+1.0) + y*y)*0.5;
  end;
  w.im := arctan2(z.im, z.re);
  w.re := a;
end;


{---------------------------------------------------------------------------}
procedure cln1p(const z: complex; var w: complex);
  {-Return the principal branch of ln(1+z), accuracy improved for z near 0}
var
  a: double;
begin
  {w.re = ln(|1+z|), w.im = arg(1+z), z = x + i*y}
  a := maxd(abs(z.re), abs(z.im));
  if a <= 0.5*eps_d then begin
    w := z;
    exit;
  end;
  if (a > 0.75) or (z.re < -0.5) then begin
    {This is simply the 'standard' real part; cf. cln with x<0.5 or x>1.75}
    a := ln(hypot(1.0+z.re, z.im));
  end
  else begin
    {|1+z|^2 = (1+x)^2 + y^2 = 1 + 2x + x^2 + y^2 = 1 + 2x + |z|^2}
    a := sqr(z.re) + sqr(z.im);
    {Note: This becomes inaccurate if x < 0 and 2x+a ~ 0, here the relative}
    {error of w.re can be of order eps_x/x, eg for y=1e-5, x=-0.5e-10 where}
    {it is 1.442e-9. Even when using the correctly rounded double values }
    {the relative error of 2x+a (and of w.re) is 2.984e-10 in this case.   }
    {But also note that in many of these cases the complete relative error }
    {cabs((f-w)/f) with f=ln(1+z) remains small because |w.im| >> |w.re| !!}
    {**** If x>0 there is no cancellation and the error of w.re is small.  }
    {As for cexpm1 in the Taylor series for the case x=-y^2/2 there is no  }
    {y^2 term: i*y + i*y^3/6 + y^4/4 - i*y^5/20 - i*y^7/56 - y^8/64 ...    }
    a := 0.5*ln1p(2.0*z.re + a);
  end;
  w.im := arctan2(z.im, 1.0 + z.re);
  w.re := a;
end;


{---------------------------------------------------------------------------}
procedure clog10(const z: complex; var w: complex);
  {-Return the principal branch of the base 10 logarithm of z, w=ln(z)/ln(10)}
begin
  cln(z,w);
  w.re := w.re*log10e;
  w.im := w.im*log10e;
end;


{---------------------------------------------------------------------------}
procedure clogbase(const b,z: complex; var w: complex);
  {-Return the principal branch of the base b logarithm of z, w=ln(z)/ln(b)}
var
  u: complex;
begin
  cln(b,u);
  cln(z,w);
  cdiv(w,u,w);
end;


{---------------------------------------------------------------------------}
procedure cexp(const z: complex; var w: complex);
  {-Return the complex exponential function w = exp(z)}
var
  s,c,x: double;

  function expmul(const y: double): double;
    {-Return exp(x)*y}
  var
    t: double;
  begin
    if y=0.0 then expmul := 0.0
    else begin
      t := x + ln(abs(y));
      if t<=ln_MaxDbl then t := exp(t)
      else t := PosInf_d;
      if y<0.0 then expmul := -t
      else expmul := t;
    end;
  end;
begin
  {HMF[1], 4.3.47: exp(x + iy) = cos(y)*exp(x) + i*sin(y)*exp(x)}
  sincos(z.im,s,c);
  x := z.re;
  if x<=ln_MaxDbl then begin
    {No overflow}
    x := exp(x);
    w.re := c*x;
    w.im := s*x;
  end
  else begin
    {exp(x) will overflow, but product(s) may be finite}
    w.re := expmul(c);
    w.im := expmul(s);
  end;
end;


{---------------------------------------------------------------------------}
procedure cexpm1(const z: complex; var w: complex);
  {-Return w = exp(z)-1, accuracy improved for z near 0}
var
  a,x,y: double;
  u: complex;
  k: integer;
const
  a0 = 1.4e-17;   {~ eps/8  }
  a1 = 6.1e-5;    {~ a0^0.25}
begin
  {Note that like cln1p there are z = x+iy with relative errors for w.re of }
  {order eps_x/x if x = y^2/2. For these x, y the Taylor series starts with }
  {exp(y^2/2 + i*y)-1 = i*y + i*y^3/3 - y^4/12 + i*y^5/20 - y^6/45 + O(y^7) }
  {i.e. the (real) 2nd order term vanishes and there will be 'large' errors.}

  {BUT: Also note that in many of these cases the 'complete' relative error }
  {cabs((f-w)/f) with f = exp(z)-1 remains small because |w.im| >> |w.re| !!}

  a := maxd(abs(z.re), abs(z.im));
  if a >= a1 then begin
    if a >= 1.0 then begin
      {Use definition if |x| and |y| are large enough}
      cexp(z,w);
      w.re := w.re - 1.0;
    end
    else begin
      {With z = x + iy and a = exp(x)-1 the value for exp(z)-1 is}
      {exp(z)-1 = exp(x)*exp(iy)-1 = exp(x)*[cos(y)+i*sin(y)] - 1}
      {= exp(x)cos(y) - 1         + i*exp(x)sin(y)}
      {= exp(x)(1-vers(y)) - 1    + i*exp(x)sin(y)}
      {= exp(x)-1 - exp(x)vers(y) + i*(1+a)sin(y) }
      {= a - (1+a)vers(y)         + i*(1+a)sin(y) }
      a := expm1(z.re);
      x := 1.0 + a;
      y := vers(z.im);
      w.re := a - x*y;
      w.im := x*sin(z.im);
    end
  end
  else if a < a0 then w := z
  else begin
    {Use truncated Taylor series with backwards summation: }
    {exp(z)-1 = (((z/k + 1)/(k-1) + 1)/(k-2 + 1) ...)/2 + 1}
    {Nbr of terms from heuristics based on Stirling formula}
    k := 1 - floor(58/(log2(a)-2.5));
    u.re := 1.0;
    u.im := 0.0;
    while k>1 do begin
      x := u.re*z.re - u.im*z.im;
      y := u.re*z.im + u.im*z.re;
      u.re := 1.0 + x/k;
      u.im := y/k;
      dec(k);
    end;
    cmul(z,u,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure coshsinhmult(y,a,b: double; var u,v: double);
  {-Return u = a*cosh(y), v = b*sinh(y) with |a|,|b| <= 1}
var
  t: double;
begin
  {u = a*cosh(y), v = b*sinh(y)}
  if abs(y)<=ln_MaxDbl then begin
    if y=0.0 then begin
      u := a;
      v := 0.0;
    end
    else begin
      {v=sinh(y), u=cosh(y)}
      sinhcosh(y,v,u);
      u := a*u;
      v := b*v;
    end;
  end
  else begin
    {extreme case: exp(|y|) will overflow}
    t := abs(y);
    if a=0.0 then u := 0.0
    else begin
      {compute a*cosh(y)}
      u := t + ln(abs(a)) - ln2;
      if u<=ln_MaxDbl then u := exp(u)
      else u := PosInf_d;
      if a<0.0 then u := -u;
    end;
    if b=0.0 then v := 0.0
    else begin
      {compute b*sinh(y)}
      v := t + ln(abs(b)) - ln2;
      if v<=ln_MaxDbl then v := exp(v)
      else v := PosInf_d;
      if (b<0.0) <> (y<0.0) then v := -v;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure ccos(const z: complex; var w: complex);
  {-Return the complex circular cosine w = cos(z)}
var
  c,s: double;
begin
  {HMF[1], 4.3.56: cos(x + iy) = cos(x)*cosh(y) - i*sin(x)*sinh(y)}
  sincos(z.re, s,c);
  coshsinhmult(z.im, c, -s, w.re, w.im);
end;


{---------------------------------------------------------------------------}
procedure csin(const z: complex; var w: complex);
  {-Return the complex circular sine w = sin(z)}
var
  c,s: double;
begin
  {HMF[1], 4.3.55: sin(x + iy) = sin(x)*cosh(y) + i*cos(x)*sinh(y)}
  sincos(z.re, s,c);
  coshsinhmult(z.im, s, c, w.re, w.im);
end;


{---------------------------------------------------------------------------}
procedure ccosh(const z: complex; var w: complex);
  {-Return the complex hyperbolic cosine w = cosh(z)}
var
  c,s: double;
begin
  {HMF[1], 4.5.50: cosh(x + iy) = cos(y)*cosh(x) + i*sin(y)*sinh(x)}
  sincos(z.im, s,c);
  coshsinhmult(z.re, c, s, w.re, w.im);
end;


{---------------------------------------------------------------------------}
procedure csinh(const z: complex; var w: complex);
  {-Return the complex hyperbolic sine w = sinh(z)}
var
  c,s: double;
begin
  {HMF[1], 4.5.49: sinh(x + iy) = cos(y)*sinh(x) + i*sin(y)*cosh(x)}
  sincos(z.im, s,c);
  coshsinhmult(z.re, s, c, w.im, w.re);
end;


{---------------------------------------------------------------------------}
procedure ctanh(const z: complex; var w: complex);
  {-Return the complex hyperbolic tangent w = tanh(z)}
var
  x,y,c,s,h,t: double;
const
  t0 = 19.0;
begin
  {HMF[1], 4.5.51: tanh(x + iy) = (sinh(2x) + i*sin(2y))/(cosh(2x) + cos(2y))}
  {See AMath reference manual for implementation notes}
  x := z.re;
  y := z.im;
  t := abs(x);
  if y=0.0 then begin
    w.re := tanh(x);
    w.im := 0.0;
  end
  else if t=0.0 then begin
    w.re := 0.0;
    w.im := tan(y);
  end
  else if t >= t0 then begin
    w.re := isign(x);
    w.im := 2.0*sin(2.0*y)*exp(-2.0*t);
  end
  else begin
    {Note: The argument y for sincos is correct! NOT 2y,}
    {the argument doubling is implicit in the formulas. }
    sincos(y,s,c);
    {accurately compute h=exp(2x)-1 and t=4(h+1)c}
    if t<=1.0 then begin
      h := expm1(2.0*x);
      t := 4*(1.0 + h)*c;
    end
    else begin
      t := exp(2.0*x);
      h := t - 1.0;
      t := 4.0*t*c;
    end;
    x := h*h;
    {Note: theoretically y = h^2 + 4(h+1)c^2 > 0 because h+1>0}
    {but underflow may occur, therefore multiply by 1/y or Inf}
    y := x + t*c;
    if abs(y) < Mindouble then y := PosInf_d else y := 1.0/y;
    w.re := (x+2.0*h)*y;
    w.im := (t*s)*y;
  end;
end;


{---------------------------------------------------------------------------}
procedure ccoth(const z: complex; var w: complex);
  {-Return the complex hyperbolic cotangent w = coth(z)}
var
  x,y,c,s,t: double;
const
  t0 = 19.0;
begin
  {HMF[1], 4.5.52: coth(x + iy) = (sinh(2x) - i*sin(2y))/(cosh(2x) - cos(2y))}
  x := z.re;
  y := z.im;
  t := abs(x);
  if y=0.0 then begin
    w.re := coth(x);
    w.im := 0.0;
  end
  else if t=0.0 then begin
    w.re := 0.0;
    w.im := -cot(y);
  end
  else if t >= t0 then begin
    w.re := isign(x);
    w.im := -2.0*sin(2.0*y)*exp(-2.0*t);
  end
  else begin
    x := 2.0*x;
    y := 2.0*y;
    if t<0.5 then begin
      {accurately compute cosh(2x) - cos(2y) for small x}
      {cosh(2x) = coshm1(2x)+1 and -cos(2y) = vers(2y)-1}
      t := coshm1(x) + vers(y);
      {Note: theoretically  t > 0 because  cosh(2x) > 1, but}
      {underflow may occur, therefore multiply by 1/y or Inf}
      if abs(t) < Mindouble then t := PosInf_d else t := 1.0/t;
      w.re := sinh(x)*t;
      w.im := -sin(y)*t;
    end
    else begin
      sincos(y,s,c);
      sinhcosh(x,x,y);  {x=sinh(2x), y=cosh(2x)}
      {here cosh >= 1.5 and t will be > 0.5}
      t := y - c;
      w.re :=  x/t;
      w.im := -s/t;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure ctan(const z: complex; var w: complex);
  {-Return the complex circular tangent w = tan(z)}
var
  u: complex;
begin
  {tan(z) = - i*tanh(iz)}
  u.re := -z.im;
  u.im :=  z.re;
  ctanh(u,u);
  w.re :=  u.im;
  w.im := -u.re;
end;


{---------------------------------------------------------------------------}
procedure ccot(const z: complex; var w: complex);
  {-Return the complex circular cotangent w = cot(z)}
var
  u: complex;
begin
  {cot(z) = i*coth(iz)}
  u.re := -z.im;
  u.im :=  z.re;
  ccoth(u,u);
  w.re := -u.im;
  w.im :=  u.re;
end;


{---------------------------------------------------------------------------}
procedure cpow(const z,a: complex; var w: complex);
  {-Return the principal value of the complex power w = z^a = exp(a*ln(z))}
var
  u: complex;
  t: double;
begin
  {Ref: NIST[30], 4.2(iv) and Kahan[61], Table 1]}
  if (a.re=0.0) and (a.im=0.0) then begin
    {z^0 = 1}
    w.re := 1.0;
    w.im := 0.0;
  end
  else if (z.re=0.0) and (z.im=0.0) and (a.re > 0.0) then begin
    {0^a = 0 if re(a) > 0}
    w.re := 0.0;
    w.im := 0.0;
  end
  else begin
    {w = exp(a*ln(z))}
    cln(z,u);
    {u := u*a}
    t    := u.re*a.re - u.im*a.im;
    u.im := u.re*a.im + u.im*a.re;
    u.re := t;
    cexp(u,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure cpowx(const z: complex; x: double; var w: complex);
  {-Return the complex principal value w = z^x = |z|^x * exp(i*x*arg(z))}
var
  r,s,c,t: double;
begin
  if x=0.0 then w := C_1
  else begin
    cpolar(z,r,t);
    r := power(r,x);
    sincos(t*x,s,c);
    w.re := r*c;
    w.im := r*s;
  end;
end;


{---------------------------------------------------------------------------}
procedure ccbrt(const z: complex; var w: complex);
  {-Return the complex principal cube root w = cbrt(z) = z^(1/3)}
begin
  cnroot(z,3,w);
end;


{---------------------------------------------------------------------------}
procedure cnroot(const z: complex; n: integer; var w: complex);
  {-Return the complex principal n'th root w = z^(1/n)}
var
  r,s,c,t: double;
begin
  cpolar(z,r,t);
  r := nroot(r,n);
  sincos(t/n,s,c);
  w.re := r*c;
  w.im := r*s;
end;


{---------------------------------------------------------------------------}
procedure cnroot1(n: integer; var z: complex);
  {-Return the principal nth root of unity z = exp(2*Pi*i/n)}
begin
  sincos(TwoPi/n, z.im, z.re);
end;


{---------------------------------------------------------------------------}
procedure ccis(x: double; var z: complex); {$ifdef HAS_INLINE} inline;{$endif}
  {-Return z = exp(i*x) = cos(x) + i*sin(x)}
begin
  sincos(x, z.im, z.re);
end;


{---------------------------------------------------------------------------}
procedure carctanh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic tangent w = arctanh(z)}
var
  x,x1,y,u,v: double;
begin
  {Ref: Boost[19], function math\complex\atanh.hpp}
  x  := abs(z.re);
  if x=0.0 then begin
    {arctanh(iy)=i*arctan(y);}
    w.re := 0.0;
    w.im := arctan(z.im);
    exit;
  end;
  {here x > 0}
  x1 := 1.0-x;
  y  := abs(z.im);
  if (x>SLB) and (x<SUB) and (y>SLB) and (y<SUB) then begin
    {x and y in standard safe range}
    v := y*y;
    u := ln1p(4.0*x/(sqr(x1) + v));
    v := arctan2(2.0*y, x1*(1.0+x) - v);
    w.im := copysignd(0.5 ,z.im)*v;
    w.re := copysignd(0.25,z.re)*u;
  end
  else begin
    {special cases where standard formulas may over/underflow}
    {safe-compute (w.re) = ln1p(4*x/((1-x)^2 + y^2)}
    if x>=SUB then begin
      if (x=PosInf_d) or (y=PosInf_d) then u := 0.0
      else if y >= SUB then u := ln1p((4.0/y)/(x/y + y/x))
      else if y > 1.0 then u := ln1p(4.0/(x + y*y/x))
      else u := ln1p(4.0/x);
    end
    else if y >= SUB then begin
      if x > 1.0 then u := ln1p((4.0*x/y)/(y + x1*x1/y))
      else u := 4.0*x/y/y;
    end
    else if x <> 1.0 then begin
      u := x1*x1;
      if y > SLB then u := u + y*y;
      u := ln1p(4.0*x/u);
    end
    else u := 2.0*(ln2 - ln(y));
    {safe-compute (w.im) = arctan2(2y, (1-x^2) - y^2)}
    if (x >= SUB) or (y >= SUB) then v := Pi
    else if (x <= SLB) then begin
       if y <= SLB then v := arctan2(2.0*y, 1.0)
       else begin
         if (x=0.0) and (y=0.0) then v := 0.0
         else v := arctan2(2.0*y, 1.0 - y*y);
       end;
    end
    else begin
      {The next statement adjusts the sign on the cut: if z.im=0 then}
      {w.im=Pi/2 for z.re < -1, 0 for |z.re| < 1, -Pi/2 for z.re > 1 }
      if (y=0.0) and (z.re>1.0) then v := -Pi
      else v := arctan2(2.0*y, x1*(1.0+x));
    end;
    if (z.im < 0.0) and (v<>0.0) then v := -v;
    w.im := 0.5*v;
    w.re := copysignd(0.25,z.re)*u;
  end;
end;


{---------------------------------------------------------------------------}
procedure carctan(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular tangent w = arctan(z)}
var
  u: complex;
begin
  {Ref HMF[1], 4.4.22: arctan(z) = -i*arctanh(iz)}
  u.re := -z.im;
  u.im :=  z.re;
  carctanh(u,u);
  w.re :=  u.im;
  w.im := -u.re;
end;


{---------------------------------------------------------------------------}
procedure carccosh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cosine w = arccosh(z)}
var
  x,y,xm,ym,xp,yp: double;
begin
  {Ref: Kahan[61], procedure CACOSH                  }
  {u = arcsinh(re(sqrt(cconj(z)-1.0)*sqrt(z+1.0)))   }
  {v = 2.0*arctan2(im(sqrt(z-1.0), re(sqrt(z+1.0)))) }
  x := z.re;
  y := z.im;
  if (abs(x) > MV_4) or (abs(y) > MV_4) then begin
    w.re := ln(hypot(0.5*x, 0.5*y)) + 2.0*ln2;
    w.im := arctan2(y,x);
  end
  else begin
    {xp + i*yp = sqrt(z+1)}
    cx_sqrt(x+1.0, y, xp, yp);
    {xm + i*ym = sqrt(z-1)}
    cx_sqrt(x-1.0, y, xm, ym);
    {use im(sqrt(cconj(z)-1)) = -im(sqrt(z-1))}
    y := xp*xm + yp*ym;
    w.re := arcsinh(y);
    w.im := 2.0*arctan2(ym, xp);
  end;
end;


{---------------------------------------------------------------------------}
procedure carccos(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cosine w = arccos(z)}
var
  x,y,xm,ym,xp,yp: double;
begin
  {Ref: Kahan[61], procedure CACOS               }
  {u = 2.0*arctan2(re(sqrt(1-z), re(sqrt(1+z)))) }
  {v = arcsinh(im(sqrt(1+cconj(z))*sqrt(1-z)))   }
  x  := z.re;
  xp := abs(x);
  y  := z.im;
  yp := abs(y);

  if (xp > MV_4) or (xp > MV_4) then begin
    w.re := arctan2(y,x);
    w.im := ln(hypot(0.5*x, 0.5*y)) + 2.0*ln2;
  end
  else if (xp <= sqrt_epsh) and (yp <= sqrt_epsh) then begin
    {arccos(z) = Pi/2 - z - 1/6*z^3 - 3/40*z^5 +O(z^6)}
    w.re := Pi_2-x;
    w.im := -y;
  end
  else begin
    {xp + i*yp = sqrt(1+z)}
    cx_sqrt(1.0+x, y, xp, yp);
    {xm + i*ym = sqrt(1-z)}
    cx_sqrt(1.0-x, -y, xm, ym);
    {use im(sqrt(1+cconj(z))) = -im(sqrt(1+z))}
    y := xp*ym - yp*xm;
    w.re:= 2.0*arctan2(xm, xp);
    w.im := arcsinh(y);
  end;
end;


{---------------------------------------------------------------------------}
procedure carcsin(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular sine w = arcsin(z)}
var
  x,y,xm,ym,xp,yp: double;
begin
  {Ref: Kahan[61], procedure CASIN             }
  {u = arctan2(re(z), re(sqrt(1-z)*sqrt(1+z))) }
  {v = arcsinh(im(sqrt(1-cconj(z))*sqrt(1+z))) }
  x  := z.re;
  xp := abs(x);
  y  := z.im;
  yp := abs(y);
  if (abs(x) > MV_4) or (abs(y) > MV_4) then begin
    if y >= 0.0 then w.re := arctan2(x,y)
    else w.re := arctan2(-x,-y);
    w.im := ln(hypot(0.5*x, 0.5*y)) + 2.0*ln2;
    w.re := copysignd(w.re,x);
    w.im := copysignd(w.im,y);
  end
  else if (xp <= sqrt_epsh) and (yp <= sqrt_epsh) then begin
    {arcsin(z) = z + 1/6*z^3 + 3/40*z^5 +O(z^6) }
    w.re := x;
    w.im := y;
  end
  else begin
    {xp + i*yp = sqrt(1+z)}
    cx_sqrt(1.0+x, y, xp, yp);
    {xm + i*ym = sqrt(1-z)}
    cx_sqrt(1.0-x, -y, xm, ym);
    {use im(sqrt(1-cconj(z))) = -im(sqrt(1-z)) = -ym}
    y := yp*xm - xp*ym;
    w.re := arctan2(x, xp*xm - yp*ym);
    w.im := arcsinh(y);
  end;
end;


{---------------------------------------------------------------------------}
procedure carcsinh(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic sine w = arcsinh(z)}
var
  u: complex;
begin
  {HMF[1], 4.6.14: arcsinh(z) = - i*arcsin(iz)}
  u.re := -z.im;
  u.im :=  z.re;
  carcsin(u,u);
  w.re :=  u.im;
  w.im := -u.re;
end;


{---------------------------------------------------------------------------}
procedure carccot(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cotangent w = arccot(z) = arctan(1/z)}
var
  u: complex;
begin
  {arccot(z) = i*arccoth(i*z))}
  u.re := -z.im;
  u.im :=  z.re;
  carccoth(u,u);
  w.re := -u.im;
  w.im :=  u.re;
end;


{---------------------------------------------------------------------------}
procedure carccotc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cotangent w = arccotc(z) = Pi/2 - arctan(z)}
begin
  if z.re > 0.0 then carccot(z, w)
  else if (abs(z.re) < eps_d) and (abs(z.im) < eps_d) then begin
    {arccotc(z) = Pi_2 - z + z^3/3 + O(z^5)}
    w.re := Pi_2;
    w.im := -z.im;
  end
  else begin
    carctan(z,w);
    w.re := Pi_2 - w.re;
    w.im := -w.im;
  end;
end;


{---------------------------------------------------------------------------}
procedure carccoth(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cotangent w = arccoth(z) = arctanh(1/z)}
var
  u: complex;
  x: double;
begin
  x := abs(z.re);
  if z.im=0.0 then begin
    {z is real}
    if x >= 1.0 then begin
      w.re := arctanh(1.0/z.re);
      w.im := 0.0;
    end
    else begin
      w.re := arctanh(z.re);
      if z.re>0.0 then w.im := -Pi_2 else w.im := Pi_2;
    end;
  end
  else if (abs(1.0-x) < 0.5) and (abs(z.im) < 0.5) then begin
    {See [63] 5.4: Definition of arccoth, and appendix Lemma 3}
    {arccoth(z) = 0.5*[ln(-1-z) - ln(1-z)]}
    u.re := -1.0 - z.re;
    u.im := -z.im;
    w.re := 1.0 - z.re;
    w.im := -z.im;
    cln(u,u);
    cln(w,w);
    w.re := 0.5*(u.re - w.re);
    w.im := 0.5*(u.im - w.im);
  end
  else begin
    {arccoth(z) = arctanh(1/z)}
    rdivc(1.0, z, w);
    carctanh(w,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure carccothc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cotangent w = arccothc(z) = arctanh(z) + i*Pi/2}
begin
  if z.im < 0.0 then carccoth(z,w)
  else begin
    carctanh(z,w);
    w.re := w.re;
    w.im := w.im + Pi_2;
  end;
end;


{---------------------------------------------------------------------------}
procedure csec(const z: complex; var w: complex);
  {-Return the complex circular secant w = sec(z) = 1/cos(z)}
begin
  ccos(z,w);
  rdivc(1.0, w, w);
end;


{---------------------------------------------------------------------------}
procedure ccsc(const z: complex; var w: complex);
  {-Return the complex circular cosecant w = csc(z) = 1/sin(z)}
begin
  csin(z,w);
  rdivc(1.0, w, w);
end;


{---------------------------------------------------------------------------}
procedure csech(const z: complex; var w: complex);
  {-Return the complex hyperbolic secant w = sech(z) = 1/cosh(z)}
begin
  ccosh(z,w);
  rdivc(1.0, w, w);
end;


{---------------------------------------------------------------------------}
procedure ccsch(const z: complex; var w: complex);
  {-Return the complex hyperbolic cosecant w = csch(z) = 1/sinh(z)}
begin
  csinh(z,w);
  rdivc(1.0, w, w);
end;


{---------------------------------------------------------------------------}
procedure carccsc(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular cosecant w = arccsc(z) = arcsin(1/z)}
var
  u: complex;
  xm,ym,xp,yp: double;
begin
  xp := abs(z.re);
  if (abs(xp-1.0) < 0.5) and (abs(z.im) < 0.5) then begin
    {This is the code for arcsin(1/z) with 1 +- 1/z = (z +- 1)/z}
    {xp + i*yp = sqrt(1+1/z) = sqrt((z+1)/z)}
    u.re := z.re + 1.0;
    u.im := z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xp, yp);
    {xm + i*ym = sqrt(1-1/z) = sqrt((z-1)/z)}
    u.re := z.re - 1.0;
    u.im := z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xm, ym);
    rdivc(1.0,z,u);
    w.re := arctan2(u.re, xp*xm - yp*ym);
    w.im := arcsinh(yp*xm - xp*ym);
  end
  else begin
    rdivc(1.0, z, w);
    carcsin(w,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure carcsec(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse circular secant w = arcsec(z) = arccos(1/z)}
var
  u: complex;
  xm,ym,xp,yp: double;
begin
  xp := abs(z.re);
  if (abs(xp-1.0) < 0.5) and (abs(z.im) < 0.5) then begin
    {This is the code for arccos(1/z) with 1 +- 1/z = (z +- 1)/z}
    {xp + i*yp = sqrt(1+1/z) = sqrt((1+z)/z}
    u.re := z.re + 1.0;
    u.im := z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xp, yp);
    {xm + i*ym = sqrt(1-1/z)=sqrt(z-1)/z}
    u.re := z.re - 1.0;
    u.im := z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xm, ym);
    w.re := 2.0*arctan2(xm, xp);
    w.im := arcsinh(xp*ym - yp*xm);
  end
  else begin
    rdivc(1.0, z, w);
    carccos(w,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure carcsech(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic secant w = arcsech(z) = arccosh(1/z)}
var
  u: complex;
  xm,ym,xp,yp: double;
begin
  xp := abs(z.re);
  if (abs(xp-1.0) < 0.5) and (abs(z.im) < 0.5) then begin
    {This is the code for arccosh(1/z) with 1/z +- 1 = (1 +- z)/z}
    {xp + i*yp = sqrt(1/z+1) = sqrt((1+z)/z}
    u.re := z.re + 1.0;
    u.im := z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xp, yp);
    {xm + i*ym = sqrt(1/z-1) = sqrt((1-z)/z)}
    u.re := 1.0 - z.re;
    u.im := -z.im;
    cdiv(u,z,u);
    cx_sqrt(u.re, u.im, xm, ym);
    w.re := arcsinh(xp*xm + yp*ym);
    w.im := 2.0*arctan2(ym, xp);
  end
  else begin
    rdivc(1.0, z, w);
    carccosh(w,w);
  end;
end;


{---------------------------------------------------------------------------}
procedure carccsch(const z: complex; var w: complex);
  {-Return the principal value of the complex inverse hyperbolic cosecant w = arccsch(z) = arcsinh(1/z)}
var
  u: complex;
begin
  {Use arccsch(z) = i*arccsc(i*z)}
  u.re := -z.im;
  u.im :=  z.re;
  carccsc(u,u);
  w.re := -u.im;
  w.im :=  u.re;
end;

(*
Wolfram Alpha:
AGM(1,-2)
-0.42296620840880168736459740606  +0.66126618346180476446723986556*I
AGM(1,-1/2)
 0.21148310420440084368229870303  +0.33063309173090238223361993278*I

Maple
AGM(1,-2)
-0.422966208408801687364597406061 -0.661266183461804764467239865563*I
AGM(1,-1/2)
 0.211483104204400843682298703030 +0.330633091730902382233619932782*I

Pari 2.6.2
agm(1,-2)
-0.4229662084088016873645974061   -0.6612661834618047644672398656*I
agm(1,-0.5)
 0.2114831042044008436822987030   -0.3306330917309023822336199328*I
*)

{---------------------------------------------------------------------------}
procedure agm1sz(const z: complex; var w: complex);
  {-Compute 'optimal' w = AGM(1,z), 'small' z:  |z| <= 2*Sqrt_MaxExt}
var
  a,b: complex;
  r: integer;
  done: boolean;
begin

  if (z.im=0.0) and ((z.re=0.0) or (z.re+1.0=0.0)) then begin
    w.re := 0.0;
    w.im := 0.0;
    exit;
  end;

  {Compute suitable starting values a, b for optimal AGM, see Pari/GP }
  {source code and the discussion in the pari-dev thread 'Complex AGM'}
  {http://pari.math.u-bordeaux.fr/archives/pari-dev-1202/msg00045.html}
  {or http://comments.gmane.org/gmane.comp.mathematics.pari.devel/3543}
  if z.re < 0.0 then begin
    {If the second condition is included, then the values on the cut are}
    {conjugated if re.z<1 like Maple, without it we have Wolfram values.}
    if (z.im < 0.0) {or ((z.im=0.0) and (z.re<-1.0))} then begin
      {a := +I*a}
      r := -1;
      a.re := -0.5*z.im;
      a.im := +0.5*(z.re + 1.0);
    end
    else begin
      {a := -I*a}
      r := 1;
      a.re := +0.5*z.im;
      a.im := -0.5*(z.re + 1.0);
    end;
    cx_sqrt(-z.re, -z.im, b.re, b.im);
  end
  else begin
    {no rotation}
    r := 0;
    a.re := 0.5*(z.re + 1.0);
    a.im := 0.5*z.im;
    cx_sqrt(z.re, z.im, b.re, b.im);
  end;
  {Here a.re >= 0 and b.re >= 0}

  {standard AGM iteration}
  repeat
    {w = a*b}
    w.re := a.re*b.re - a.im*b.im;
    w.im := a.re*b.im + a.im*b.re;
    {a = (a+b)/2}
    a.re := 0.5*(a.re+b.re);
    a.im := 0.5*(a.im+b.im);
    {b = sqrt(a*b)}
    cx_sqrt(w.re, w.im, b.re, b.im);
    {loop until a-b is small of order sqrt(eps)}
    done := (abs(a.re-b.re)<=sqrt_epsh*abs(a.re)) and
            (abs(a.im-b.im)<=sqrt_epsh*abs(a.im))
  until done;

  {final iteration makes |a-b| ~ eps*|a|}
  a.re := 0.5*(a.re+b.re);
  a.im := 0.5*(a.im+b.im);

  {undo rotation}
  case r of
      1: begin
           {w=a*I}
           w.re := -a.im;
           w.im :=  a.re;
         end;
     -1: begin
           {w=-a*I}
           w.re :=  a.im;
           w.im := -a.re;
         end;
    else begin
           w.re := a.re;
           w.im := a.im;
         end;
  end; {case}
end;


{---------------------------------------------------------------------------}
procedure cagm1(const z: complex; var w: complex);
  {-Return the 'optimal' arithmetic-geometric mean w = AGM(1,z)}
var
  u: complex;
begin

  {'Optimal' means: |w| is maximal over all possible AGM sequences}
  {which can be obtained by choosing one of the two sqrt branches.}

  if (abs(z.re) > Sqrt_MaxDbl) or (abs(z.im) > Sqrt_MaxDbl) then begin
    {Avoid possible overflow in AGM iteration loop and}
    {use  AGM(1,z) = AGM(1/z,1)*z = AGM(1/z,1) / (1/z)}
    cinv(z,u);
    agm1sz(u,w);
    cdiv(w,u,w);
  end
  else agm1sz(z,w);
end;


{---------------------------------------------------------------------------}
procedure agmstep1(const x,y: complex; var a,b: complex);
  {-compute one step of optimal AGM}
var
  u,v: complex;
begin
  cmul(x,y,u);
  a.re := 0.5*(x.re + y.re);
  a.im := 0.5*(x.im + y.im);
  csqrt(u,b);
  csub(a,b,u);
  cadd(a,b,v);
  if cabs(u)>cabs(v) then begin
    {if |a-b| > |a+b| then select other branch of sqrt: b -> -b}
    b.re := -b.re;
    b.im := -b.im;
  end;
end;


{---------------------------------------------------------------------------}
procedure cagm(const x,y: complex; var w: complex);
  {-Return the 'optimal' arithmetic-geometric mean w = AGM(x,y)}
var
  u,v: complex;
  ax,ay: double;
  zerostep: boolean;
begin
  ax := cabs(x);
  ay := cabs(y);
  if (ax=0.0) or (ay=0.0) then w := C_0
  else begin
    zerostep := false;
    if ax>ay then begin
      if ay/ax>succd0 then begin
        cdiv(y,x,v);
        u := x;
      end
      else zerostep := true;
    end
    else begin
      if ax/ay>succd0 then begin
        u := y;
        cdiv(x,y,v);
      end
      else zerostep := true;
    end;
    if zerostep then begin
      {quotient might underflow, take one manual step and a recursive call}
      agmstep1(x,y,u,v);
      cagm(u,v,w);
    end
    else begin
      cagm1(v,w);
      cmul(w,u,w);
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure cellk(const k: complex; var w: complex);
  {-Return w = K(k), the complete elliptic integral of the first kind}
begin
  {K(k) = Pi/2 / AGM(1,k'), see NIST[30], 19.8.5 or}
  {or http://functions.wolfram.com/08.02.26.0133.01}
  csqrt1mz2(k,w);
  cagm1(w,w);
  rdivc(Pi_2,w,w);
end;


{---------------------------------------------------------------------------}
procedure cellck(const k: complex; var w: complex);
  {-Return w = K'(k), the complementary complete elliptic integral of the first kind}
begin
  {K'(k) = K(k') = Pi/2 / AGM(1,k)}
  cagm1(k,w);
  rdivc(Pi_2,w,w);
end;


{---------------------------------------------------------------------------}
procedure csurd(const z: complex; n: integer; var w: complex);
  {-Return the complex n'th root w = z^(1/n) with arg(w) closest to arg(z)}
var
  r,s,c,a: double;
  k: integer;
begin
  if n=1 then w:=z
  else if n=2 then csqrt(z,w)
  else begin
    r := nroot(cabs(z),n);
    if (z.re=0.0) and (n and 3 = 1) then begin
      {I^(4k+1) = I,  (-I)^(4k+1) = -I}
      if z.im < 0 then r := -r;
      w.re := 0.0;
      w.im := r;
    end
    else if (z.im=0.0) and odd(n) then begin
       if z.re < 0 then r := -r;
       w.re := r;
       w.im := 0.0;
    end
    else begin
      a := carg(z);
      k := round(a*(n-1)/TwoPi);
      sincos((k*TwoPi+a)/n,s,c);
      w.re := r*c;
      w.im := r*s;
    end;
  end
end;


{---------------------------------------------------------------------------}
function csgn(const z: complex): integer;
  {-Return the sign of z. Result = isign(z.re) if z.re<>0, isign(z.im) otherwise}
var
  s: integer;
begin
  if IsNaNd(z.re) then csgn := 0
  else begin
    s := isign(z.re);
    if s=0 then s := isign(z.im);
    csgn := s;
  end;
end;


{---------------------------------------------------------------------------}
procedure clngam_lanczos(const z: complex; var w: complex);
  {-Return lnGamma(z) using Lanczos sum, assumes z.re >= 1}
var
  k: integer;
  xr,tr: double;
  s,t: complex;
{Coefficients for g=9 from Paul Godfrey's  http://my.fit.edu/~gabdo/gammacoeff.txt}
const
  lgam = 9;
  lcoeffh: array[0..lgam+1] of THexDblW = (
             ($0001,$0000,$0000,$3FF0),  {+1.0000000000000002220}
             ($1E8A,$72BD,$5466,$40B6),  {+5.7164001882743414171E+3}
             ($544E,$F23E,$EFA6,$C0CC),  {-1.4815304267684139631E+4}
             ($8478,$134D,$E9BF,$40CB),  {+1.4291492776574785239E+4}
             ($FA4F,$0405,$CC29,$C0B8),  {-6.3481602176414589849E+3}
             ($5C6C,$E28A,$566E,$4094),  {+1.3016082860583219372E+3}
             ($5CCC,$23F6,$0B4F,$C05B),  {-1.0817670535143696497E+2}
             ($3B56,$68D7,$D877,$4004),  {+2.6056965056117560309}
             ($59AC,$DC13,$680D,$BF7E),  {-7.4234525102014163600E-3}
             ($8CA3,$989F,$E7E6,$3E6C),  {+5.3841364325095641522E-8}
             ($1056,$E5B1,$47EB,$BE31)); {-4.0235331412682361993E-9}
var
  lcoeff: array[0..lgam+1] of double absolute lcoeffh;
begin
  {compute s = ln(Lanczos sum) = ln(c[0]+sum(c[k]/(z+k)))}
  s.re := lcoeff[0];
  s.im := 0.0;
  for k:=1 to lgam+1 do begin
    t.re := z.re + (k-1);
    t.im := z.im;
    rdivc(lcoeff[k],t,t);
    s.re := s.re + t.re;
    s.im := s.im + t.im;
  end;
  cln(s,s);

  {t = ln(z+lgam-0.5)}
  t.re := z.re + (lgam-0.5);
  t.im := z.im;
  cln(t,t);

  {w = -(z+lgam-0.5) + (z-0.5)*t + ln(sqrt(2Pi)) + s}
  xr := z.re - 0.5;
  tr := t.re - 1.0;
  w.re := tr*xr   - t.im*z.im + s.re + (LnSqrt2Pi-lgam);
  w.im := tr*z.im + t.im*xr   + s.im;

end;


{---------------------------------------------------------------------------}
procedure clngam1z(const z: complex; var w: complex);
  {-Return lnGamma(1+z) with power series, |z| < 2}
var
  s,p,d: complex;
  x,eps: double;
  n: integer;
const
  NMAX = 128;
const
  znhex: array[2..28] of THexDblW = ( {for n from 2 to 28 do evalf((-1)^n*(Zeta(n)-1)/n) od;}
           ($0FA6,$C4A6,$A34C,$3FD4),  {+3.2246703342411320303E-1}
           ($7607,$1A55,$3E00,$BFB1),  {-6.7352301053198102010E-2}
           ($8483,$AC7D,$1322,$3F95),  {+2.0580808427784546416E-2}
           ($F5F2,$C218,$404F,$BF7E),  {-7.3855510286739856768E-3}
           ($6C30,$EADB,$ADD6,$3F67),  {+2.8905103307415233593E-3}
           ($8E08,$C2BF,$8AC5,$BF53),  {-1.1927539117032610189E-3}
           ($96E9,$F863,$B36A,$3F40),  {+5.0966952474304245014E-4}
           ($2FC8,$C76D,$3FD4,$BF2D),  {-2.2315475845357938579E-4}
           ($D65A,$0F17,$127B,$3F1A),  {+9.9457512781808530980E-5}
           ($81EF,$BD7C,$8DE5,$BF07),  {-4.4926236738133142046E-5}
           ($EB02,$EE66,$80DC,$3EF5),  {+2.0507212775670691067E-5}
           ($2243,$63CE,$CBC9,$BEE3),  {-9.4394882752683967152E-6}
           ($4AAC,$39F3,$597A,$3ED2),  {+4.3748667899074881744E-6}
           ($9541,$B767,$1B2E,$BEC1),  {-2.0392157538013661897E-6}
           ($2F0F,$DEB2,$064C,$3EB0),  {+9.5514121304074193530E-7}
           ($FD2F,$D93C,$2600,$BE9E),  {-4.4924691987645661855E-7}
           ($7A4D,$B3F0,$76BB,$3E8C),  {+2.1207184805554664645E-7}
           ($8A97,$CBBF,$F5A6,$BE7A),  {-1.0043224823968099084E-7}
           ($0B0F,$C207,$9B93,$3E69),  {+4.7698101693639803983E-8}
           ($3EAC,$34DF,$62C7,$BE58),  {-2.2711094608943163504E-8}
           ($ADCD,$ACCF,$469D,$3E47),  {+1.0838659214896954593E-8}
           ($AEAD,$8447,$434A,$BE36),  {-5.1834750419700466442E-9}
           ($D2C3,$77FF,$55A8,$3E25),  {+2.4836745438024784752E-9}
           ($8D0E,$7925,$7B16,$BE14),  {-1.1921401405860911547E-9}
           ($C10C,$2B2F,$B15D,$3E03),  {+5.7313672416788622514E-10}
           ($E3E0,$9FAB,$F69A,$BDF2),  {-2.7595228851242333559E-10}
           ($434C,$A337,$4932,$3DE2)); {+1.3304764374244488820E-10}
begin
  {HMF[1], 6.1.33}
  x := 0.4227843350984671394; {1-EulerGamma}
  n := 2;
  s.re := z.re + 1.0;
  s.im := z.im;
  cln(s,s);
  s.re := z.re*x - s.re;
  s.im := z.im*x - s.im;
  eps  := 0.5*eps_d;
  {p = z^n}
  p.re := z.re;
  p.im := z.im;

  repeat
    cmul(p,z,p);
    {compute x = (-1)^n*(Zeta(n)-1)/n}
    if n<29 then x := double(znhex[n])
    else begin
      x := ldexpd(1,-n);
      x := x + x*x + exp3(-n); {1/2^n + 1/3^n + 1/4^n}
      if odd(n) then x := -x/n
      else x := x/n
    end;
    d.re := p.re*x;
    d.im := p.im*x;
    s.re := s.re + d.re;
    s.im := s.im + d.im;
    inc(n);
  until ((abs(d.re) <= eps*abs(s.re)) and (abs(d.im) <= eps*abs(s.im))) or (n>NMAX);
  {$ifdef debug}
    if n>NMAX then begin
      writeln('No convergence in clngam1z');
    end;
  {$endif}
  w.re := s.re;
  w.im := s.im;
end;


{---------------------------------------------------------------------------}
procedure clngamma(const z: complex; var w: complex);
  {-Return w = lnGamma(z), the principal branch of the log-Gamma function}
var
  t: complex;
  afix,s,c,y,sh,ch: double;
  si: integer;
begin
  {Note that lnGamma(z) is normally <> ln(Gamma(z)), real parts are }
  {equal but Im(Ln(Gamma(z)) is in [-Pi, Pi]. This function contains}
  {some guesswork about the multiples of 2*Pi which are to be added }
  {to w.im if z.re < 0, the reference was Maple's lnGAMMA function. }
  y := abs(z.im);
  if (y <= 0.75) and (abs(z.re-1)<=1.25) then begin
    {Use power series if z near pole at 0 or zeroes at 1,2}
    {Near the zeroes Lanczos gives only absolute accuracy }
    if abs(z.re-1) <= 0.25 then begin
      {Code for z near 1}
      w.re := z.re - 1.0;
      w.im := z.im;
      clngam1z(w,w);
      exit;
    end;
    if abs(z.re) <= 0.25 then begin
      {Code for z near 0: lnGamma(z) = lnGamma(z+1) - ln(z)}
      {ln(z)}
      cln(z,t);
      w.re := z.re;
      w.im := z.im;
      {lnGamma(z+1)}
      clngam1z(w,w);
      w.re := w.re - t.re;
      w.im := w.im - t.im;
      exit;
    end;
    if abs(z.re-2.0) <= 0.25 then begin
      {Code for z near 2: lnGamma(z) = ln(z-1) + lnGamma(z-1)}
      {ln(z-1)}
      t.re := z.re - 1.0;
      t.im := z.im;
      cln(t,t);
      {compute lnGamma(z-1) with z-1 near 1}
      w.re := z.re - 2.0;
      w.im := z.im;
      clngam1z(w,w);
      w.re := w.re + t.re;
      w.im := w.im + t.im;
      exit;
    end;
  end;

  if z.re > 1.0 then begin
    {Here Lanczos seems OK, for z.re=1 sometimes w.im is off by 2*Pi}
    clngam_lanczos(z,w);
  end
  else if z.re >= 0.0 then begin
    {Use recursive call lnGamma(z) = lnGamma(z+1) - ln(z) to make z.re > 1}
    t.re := z.re + 1.0;
    t.im := z.im;
    cln(z,t);
    w.re := z.re + 1.0;
    w.im := z.im;
    clngamma(w,w);
    w.re := w.re - t.re;
    w.im := w.im - t.im;
  end
  else begin
    {Use reflection formula HMF[1], 6.1.17: Gamma(z)Gamma(1-z)=Pi/sin(Pi*z}
    {and conjugation [1], 6.1.23: ln(Gamma(z)) = conj(ln(Gamma(conj(z))). }
    {Note: The real case could be simplified by using sfGamma, but then a }
    {large overhead from other special functions units would be included. }
    if y=0.0 then begin
      {Real case for z.re < 0}
      t.re := -z.re;
      t.im := 0.0;
      clngamma(t,t);
      s := z.re*sinPi(z.re);
      w.re := ln(abs(Pi/s)) - t.re;
      w.im := floord(z.re)*Pi;
    end
    else begin
      si := isign(z.im);
      {t := lngam(1-z)}
      t.re := 1.0 - z.re;
      t.im := -y;
      clngam_lanczos(t,t);
      {This is the 'magic' arg fix to make w.im compatible to Maple and}
      {Wolfram Alpha, see http://functions.wolfram.com/06.11.16.0002.01}
      afix := floord(0.5*(z.re+0.5))*TwoPi;
      {w := ln(sin(Pi*z))}
      sincosPi(z.re,s,c);
      if y >= 8.0 then begin
        {Here sinh(Pi*y)^2 > 1/eps_x, tanh(Pi*y) = 1}
        {HMF[1], 4.3.59: w.re ~ ln(sinh(y*Pi) = y*Pi - ln(2)}
        w.re := y*Pi - ln2;
        {HMF[1], 4.3.60: w.im ~ arctan(cot(z.re*Pi)tanh(Pi*y)), so}
        {w.im = arctan(cot(z.re*Pi)) = arctan(c/s) = arctan2(c,s).}
        w.im := arctan2(c,s);
      end
      else begin
        {Use full formulas from HMF[1] 4.3.59/60. An option would be:}
        {coshsinhmult(y*Pi, s,c, w.re,w.im); cln(w,w);}
        sinhcosh(y*Pi,sh,ch);
        w.re := ln(hypot(s,sh));
        w.im := arctan2(c*sh, s*ch);
      end;
      w.re :=  LnPi - w.re - t.re;
      w.im := (afix - w.im - t.im)*si;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure cgamma(const z: complex; var w: complex);
  {-Return the complex Gamma function w = Gamma(z)}
var
  rez: boolean;
begin
  rez := z.im=0.0;
  clngamma(z,w);
  cexp(w,w);
  if rez then w.im := 0.0;
end;


{---------------------------------------------------------------------------}
procedure cpsi(const z: complex; var w: complex);
  {-Return the complex digamma function w = psi(z), z <> 0,-1,-2...}
const
  NB = 6;                     {Bernoulli(2(k+1))/(2(k+1)), k=0..NB}
  B: array[0..NB] of double = (1.0/12.0,  -1.0/120.0,     1.0/252.0, -1.0/240.0,
                               1.0/132.0, -691.0/32760.0, 1.0/12.0 {,-3617/8160});
var
  u,v,x: complex;
  a: double;
const
  x0 = 12.0;
begin
  if z.re < 0.0 then begin
    {HMF [1], 6.3.7: psi(z) = psi(1-z) - Pi*cot(Pi*z)}
    x.re := 1.0-z.re;
    x.im := -z.im;
    cpsi(x,u);
    {compute v = Pi*cot(Pi*z)}
    if z.im=0.0 then begin
      sincosPi(x.re,v.re,v.im);
      {cot(x) = cos(x)/sin(x), will crash if frac(x)=0!}
      v.re := Pi*v.im/v.re;
      v.im := 0.0;
    end
    else if frac(z.re)=0.0 then begin
      {cot((-m + y*I)*Pi)= -I*coth(Pi*y))}
      v.re := 0.0;
      v.im := -Pi*coth(Pi*z.im);
    end
    else begin
      {Because cot has period Pi, use only the fractional part of z.re.  }
      {Note: There can be a large relative error, if z.re is not exactly }
      {representable as float, e.g. if z.re = -10 - 1e-8 then frac(z.re) }
      { = -1.0000000827403710e-8 with a relative error of 8.2740371E-8!  }
      {And then v.im, w.im will have relative errors of the same order.  }
      a := frac(z.re);
      {a < 0: if abs(a) > 0.5 take the next multiple of Pi. Note that }
      {a+1 generates no additional error according to Sterbenz' lemma.}
      if a < -0.5 then a := a + 1.0;
      x.re := Pi*a;
      x.im := Pi*z.im;
      ccot(x,v);
      v.re := Pi*v.re;
      v.im := Pi*v.im;
    end;
    w.re := u.re - v.re;
    w.im := u.im - v.im;
    exit;
  end;

  {This next code is analogous to the real digamma sfd_psi:}
  {Step 1: Make Re(x) >= x0 using HMF [1], 6.3.5}
  x.re := z.re;
  x.im := z.im;
  w.re := 0.0;
  w.im := 0.0;
  while x.re < x0 do begin
    cinv(x,v);
    cadd(w,v,w);
    x.re := x.re + 1.0;
  end;

  {Step 2: If re(x) >= x0, use asymptotic expansion from HMF [1], 6.3.18}
  {v = -1/(2x) - sum(B_2k/(2k*x^2k)}
  a := maxd(abs(x.re), abs(x.im));
  if a >= 1e10 then begin
    {Avoid overflow on square and useless polynomial evaluation}
    rdivc(-0.5, x, v);
  end
  else begin
    {TODO: optimize and use fewer terms depending on a?}
    csqr(x,u);
    cinv(u,u);
    cpolyr(u,B,NB+1,v);
    cmul(v,u,v);
    rdivc(-0.5, x, u);
    csub(u,v,v);
  end;

  {Step 3: psi(x) = ln(x) + v - w, with w from Step 1}
  cln(x,u);
  cadd(u,v,u);
  csub(u,w,w);
end;


{---------------------------------------------------------------------------}
procedure cli_taylor(const z: complex; var w: complex);
  {-Compute w = dilog(z), |z| <= 0.5 with Taylor series}
var
  u,v,s,t: complex;
  f: double;
  n: integer;
const
  NMAX = 150;
begin
  {dilog(z) = sum(z^n/n^2, n=1..INF}
  u := z;
  t := u;
  s := t;
  for n:=2 to NMAX do begin
    cmul(t,u,t);
    f := sqr(n);
    v.re := s.re + t.re/f;
    v.im := s.im + t.im/f;
    if (v.re=s.re) and (v.im=s.im) then break;
    s.re := v.re;
    s.im := v.im;
  end;
  w.re := s.re;
  w.im := s.im;
end;


{---------------------------------------------------------------------------}
procedure cli_bernsum(const z: complex; var w: complex);
  {-Compute w = dilog(z) with Debye function / Bernoulli sum}
  { Note: this procedure is only called if 0.5 < |z| < 2.0 !}
var
  s,y,t,v,f: complex;
  n: integer;
  b: double;
begin
  {Maximon[35], (4.3)}
  y.re := 1.0 - z.re;
  y.im := -z.im;
  cln(y,y);
  {The series converges for |ln(1-z)| < 2*Pi. Because z arguments near 1 are}
  {handled via transformation 1-z, the observed maximum of |ln(1-z)| < 3.22!}
  y.re := -y.re;
  y.im := -y.im;
  csqr(y,t);
  f.re := 1.0;
  f.im := 0.0;
  s.re := 1.0;
  s.im := 0.0;
  n := 0;
  while n < MaxB2nSmall do begin
    cmul(f,t,f);
    inc(n);
    b := n+n;
    b := sqr(b)+b; {=2n(2n+1)}
    f.re := f.re/b;
    f.im := f.im/b;
    {here f = (-ln(1-z))^(2n)/(2n+1)!}
    b := double(DAMath.B2nHex[n]);
    v.re := s.re + b*f.re;
    v.im := s.im + b*f.im;
    if (v.re=s.re) and (v.im=s.im) then break;
    s.re := v.re;
    s.im := v.im;
  end;
  {$ifdef debug}
    {Should not happen, observed maximum n was 34, MaxB2nSmall is 60!}
    if n>=MaxB2nSmall then writeln('cli_bernsum: no convergence');
  {$endif}
  cmul(s,y,s);
  w.re := s.re - 0.25*t.re;
  w.im := s.im - 0.25*t.im;
end;


{---------------------------------------------------------------------------}
procedure cdilog(const z: complex; var w: complex);
  {-Return the principal branch of the complex dilogarithm w = -integral(ln(1-t)/t, t=0..z)}
var
  a: double;
  u,v,t: complex;
  isre,negi: boolean;
begin
  if (z.im=0.0) and (z.re=1.0) then begin
    {avoid evaluation of ln(0)}
    w.re := PiSqr/6.0;
    w.im := 0.0;
    exit;
  end;
  isre := (z.im=0.0) and (z.re<=1.0);  {result is real}
  negi := (z.im=0.0) and (z.re>1.0);   {z on branch cut, w.im is negative}
  a := hypot(z.re, z.im);
  if a<=0.5 then begin
    {Use Taylor series: Maximon[35], (3.1)}
    cli_taylor(z, w);
  end
  else if a>=2.0 then begin
    {Maximon[35], (3.2)}
    {compute t=ln^2(-z)}
    t.re := -z.re;
    t.im := -z.im;
    cln(t,t);
    csqr(t,t);
    {compute u = dilog(1/z)}
    cinv(z,u);
    cli_taylor(u,u);
    {Complete transformation}
    w.re := (-0.5)*t.re - u.re - PiSqr/6.0;
    w.im := (-0.5)*t.im - u.im;
  end
  else if hypot(1.0 - z.re,z.im) <= 0.5 then begin
    {Maximon[35], (3.3)}
    {t=1-z}
    t.re := 1.0 - z.re;
    t.im := -z.im;
    {compute v = ln(z)*ln(1-z)}
    cln(t,u);
    cln(z,v);
    cmul(u,v,v);
    {compute u = dilog(1-z)}
    cli_taylor(t,u);
    {Complete transformation}
    w.re := PiSqr/6.0 - v.re - u.re;
    w.im := -v.im - u.im;
  end
  else begin
    {Maximon[35], (4.3)}
    cli_bernsum(z,w);
    if negi then w.im := -w.im;
  end;
  if isre then begin
    {force real result}
    w.im := 0.0;
  end
  else if negi and (w.im > 0.0) then begin
    {Fix the sign of the imaginary part of the principal branch on}
    {the cut: Here we have Im(dilog(x+0*i)) = -Pi*ln(x) for x > 1.}
    w.im := -w.im;
  end;
end;

end.

