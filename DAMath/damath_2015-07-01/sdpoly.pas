unit sdPoly;

{Double precision Orthogonal polynomials, Legendre functions and related}

interface

{$i std.inc}

{$ifdef BIT16}
{$N+}
{$endif}

{$ifdef NOBASM}
  {$undef BASM}
{$endif}


(*************************************************************************

 DESCRIPTION   :  Double precision Orthogonal polynomials, Legendre functions and related

 REQUIREMENTS  :  BP7, D1-D7/D9-D10/D12/D17-D18, FPC, VP, WDOSX

 EXTERNAL DATA :  ---

 MEMORY USAGE  :  ---

 DISPLAY MODE  :  ---

 REMARKS       :  The absolute values of l,m (degree/order) for the
                  Legendre functions and some others must be less than
                  MaxInt div 2 (but even for 16-bit values about 16000 are
                  normally not used with recurrence relations)

 REFERENCES    :  References used in this unit, main index in damath_info.txt/references

                  [1] [HMF]: M. Abramowitz, I.A. Stegun. Handbook of Mathematical Functions, New York, 1970
                      http://www.math.sfu.ca/~cbm/aands/
                 [13] [NR]: W.H. Press et al, Numerical Recipes in C, 2nd ed., Cambridge, 1992,
                      http://www.nrbook.com/a/bookcpdf.html
                 [19] Boost C++ Libraries, Release 1.42.0, 2010.
                      http://www.boost.org/
                 [30] [NIST]: F.W.J. Olver, D.W. Lozier, R.F. Boisvert, C.W. Clark, NIST Handbook
                      of Mathematical Functions, Cambridge, 2010. Online resource: NIST Digital
                      Library of Mathematical Functions, http://dlmf.nist.gov/
                 [33] http://functions.wolfram.com/: Formulas and graphics about
                      mathematical functions for the mathematical and scientific
                      community and/or http://mathworld.wolfram.com/ ("/the web's
                      most extensive mathematical resource/")
                 [45] N.N. Lebedev, Special Functions and Their Applications,
                      Dover, New York, 1972
                 [58] W. Gautschi, On mean convergence of extended Lagrange interpolation,
                      J. Comput. Appl. Math. 43, 1992, pp.19-35, available as
                      http://www.cs.purdue.edu/homes/wxg/selected_works/section_03/132.pdf
                 [59] J.C. Mason. Chebyshev polynomials of second, third and fourth kinds.
                      J. Comput. Appl. Math. 49, 1993, 169-178;
                      http://dx.doi.org/10.1016/0377-0427(93)90148-5


 Version  Date      Author      Modification
 -------  --------  -------     ------------------------------------------
 1.00.00  10.02.13  W.Ehrhardt  Initial BP7 version from AMath.sfpoly
 1.00.01  10.02.13  we          adjusted tol in lq_hf

 1.03.00  13.05.13  we          Change limits to 2e16 in p0ph,p1mh,p1ph

 1.06.00  18.09.13  we          sfd_chebyshev_v/w

 ***************************************************************************)


(*-------------------------------------------------------------------------
 (C) Copyright 2010-2013 Wolfgang Ehrhardt

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

function sfd_chebyshev_t(n: integer; x: double): double;
  {-Return Tn(x), the Chebyshev polynomial of the first kind, degree n}

function sfd_chebyshev_u(n: integer; x: double): double;
  {-Return Un(x), the Chebyshev polynomial of the second kind, degree n}

function sfd_chebyshev_v(n: integer; x: double): double;
  {-Return V_n(x), the Chebyshev polynomial of the third kind, degree n>=0}

function sfd_chebyshev_w(n: integer; x: double): double;
  {-Return W_n(x), the Chebyshev polynomial of the fourth kind, degree n>=0}

function sfd_gegenbauer_c(n: integer; a,x: double): double;
  {-Return Cn(a,x), the nth Gegenbauer (ultraspherical) polynomial with}
  { parameters a. The degree n must be non-negative; a should be > -0.5}
  { When a=0, C0(0,x) = 1, and Cn(0,x) = 2/n*Tn(x) for n<>0.}

function sfd_hermite_h(n: integer; x: double): double;
  {-Return Hn(x), the nth Hermite polynomial, degree n >= 0}

function sfd_jacobi_p(n: integer; a,b,x: double): double;
  {-Return Pn(a,b,x), the nth Jacobi polynomial with parameters a,b. Degree n}
  { must be >= 0; a,b should be > -1 (a+b must not be an integer < -1).}

function sfd_laguerre(n: integer; a,x: double): double;
  {-Return Ln(a,x), the nth generalized Laguerre polynomial with parameter a;}
  { degree n must be >= 0. x >=0 and a > -1 are the standard ranges.}

function sfd_laguerre_ass(n,m: integer; x: double): double;
  {-Return the associated Laguerre polynomial Ln(m,x); n,m >= 0}

function sfd_laguerre_l(n: integer; x: double): double;
  {-Return the nth Laguerre polynomial Ln(0,x); n >= 0}

function sfd_zernike_r(n,m: integer; r: double): double;
  {-Return the Zernike radial polynomial Rnm(r), r >= 0, n >= m >= 0, n-m even}

function sfd_legendre_p(l: integer; x: double): double;
  {-Return P_l(x), the Legendre polynomial/function P_l, degree l}

function sfd_legendre_q(l: integer; x: double): double;
  {-Return Q_l(x), the Legendre function of the 2nd kind, degree l >=0, |x| <> 1}

function sfd_legendre_plm(l,m: integer; x: double): double;
  {-Return the associated Legendre polynomial P_lm(x)}

function sfd_legendre_qlm(l,m: integer; x: double): double;
  {-Return Q(l,m,x), the associated Legendre function of the second kind; l >= 0, l+m >= 0, |x|<>1}

procedure sfd_spherical_harmonic(l, m: integer; theta, phi: double; var yr,yi: double);
  {-Return Re and Im of the spherical harmonic function Y_lm(theta,phi)}

function sfd_thp(l,m: integer; x: double): double;
  {-Return the toroidal harmonic function P(l-0.5,m,x); l,m=0,1; x >= 1}

function sfd_thq(l,m: integer; x: double): double;
  {-Return the toroidal harmonic function Q(l-0.5,m,x); l=0,1; x > 1}

{#Z+}
function legendre_plmf(l,m: integer; x,f: double): double;
  {-Associated Legendre polynomial P_lm(x), f=|1-x^2|^(|m|/2) calculated externally}
{#Z-}


implementation

uses
  DAMath,
  {$ifopt R+}
    sdBasic,  {for RTE_ArgumentRange}
  {$endif}
  sdEllInt,
  sdGamma;


{---------------------------------------------------------------------------}
function sfd_chebyshev_t(n: integer; x: double): double;
  {-Return Tn(x), the Chebyshev polynomial of the first kind, degree n}
var
  t0, t1, tk, z: double;
  k: integer;
const
  NTR = 64;
begin
  {T(k+1,x) = 2x*T(k,x) - T(k-1,x);   T(0,x) = 1;   T(1,x) = x}
  {We use the trig/hyp form of Tn to generalize to negative degree: If n<0}
  {define T(-n,x) = T(n,x) because cos(nz) and cosh(nz) are even functions}
  n := abs(n);
  z := abs(x);
  if n=0 then sfd_chebyshev_t := 1.0
  else if n=1 then sfd_chebyshev_t := x
  else if z=1.0 then begin
    if odd(n) and (x<0.0) then sfd_chebyshev_t := -1.0
    else sfd_chebyshev_t := 1.0
  end
  else if n>NTR then begin
    {use trigonometric/hyperbolic functions if n is large}
    if z<1.0 then sfd_chebyshev_t:= cos(n*arccos(x))
    else begin
      {cannot use x < -1 for arccosh, use abs and adjust sign}
      t1 := cosh(n*arccosh(z));
      if odd(n) and (x<0.0) then sfd_chebyshev_t := -t1
      else sfd_chebyshev_t := t1;
    end;
  end
  else begin
    z  := 2.0*x;
    t0 := 1.0;
    t1 := x;
    for k:=2 to n do begin
      tk := z*t1 - t0;
      t0 := t1;
      t1 := tk;
    end;
    sfd_chebyshev_t := t1;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_chebyshev_u(n: integer; x: double): double;
  {-Return Un(x), the Chebyshev polynomial of the second kind, degree n}
var
  u0, u1, uk, z: double;
  k,n1: integer;
const
  NTR = 64;
begin
  {U(k+1,x) = 2x*U(k,x) - U(k-1,x);   U(0,x) = 1;   U(1,x) = 2x}
  if n<0 then begin
    {We use the trig/hyp form of U_n to generalize to negative degree: If n<0}
    {then sin((n+1)z) = sin((-|n|+1)z) = -sin((|n|-1)z) = -sin(((|n|-2)+1)z) }
    {and a similar argument applies for sinh. So define U(n,x) = -U(-n-2,x). }
    {The only special case is n=-1. Then we have -n-2 = -1 again. Here we can}
    {use sin((n+1)z) = sin(0z) = 0, and therefore U(-1,x) = 0 for all x.}
    if n=-1 then sfd_chebyshev_u := 0.0
    else sfd_chebyshev_u := -sfd_chebyshev_u(-n-2,x);
    exit;
  end;
  n1 := n+1;
  z  := abs(x);
  if n=0 then sfd_chebyshev_u := 1.0
  else if n=1 then sfd_chebyshev_u := 2.0*x
  else if z=1.0 then begin
    if odd(n) and (x<0.0) then sfd_chebyshev_u := -n1
    else sfd_chebyshev_u := n1
  end
  else if n>NTR then begin
    {Use trigonometric/hyperbolic functions if n is large,}
    {calculate U(n, abs(x)) and adjust sign}
    if z<1.0 then begin
      z  := arccos(z);
      u0 := sin(z);
      if u0=0.0 then u1 := n1 {u0=0 -> z=0 or Pi -> x ~ 1 or -1}
      else u1 := sin(n1*z)/u0;
    end
    else begin
      z  := arccosh(z);
      u0 := sinh(z);
      if u0=0.0 then u1 := n1  {u0=0 -> arccosh(z)=0 -> x ~ +-1}
      else u1 := sinh(n1*z)/u0;
    end;
    if odd(n) and (x<0.0) then sfd_chebyshev_u := -u1
    else sfd_chebyshev_u := u1;
  end
  else begin
    z  := 2.0*x;
    u0 := 1.0;
    u1 := z;
    for k:=2 to n do begin
      uk := z*u1 - u0;
      u0 := u1;
      u1 := uk;
    end;
    sfd_chebyshev_u := u1;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_chebyshev_v(n: integer; x: double): double;
  {-Return V_n(x), the Chebyshev polynomial of the third kind, degree n>=0}
var
  t0, t1, tk, z: double;
  k: integer;
const
  N1 = 512;
  N2 = 16;
  E2 = 1e-5;
begin
  {V(k+1,x) = 2x*V(k,x) - V(k-1,x);   V(0,x) = 1;   V(1,x) = 2x-1}
  z := abs(x);
  if n<0 then sfd_chebyshev_v := 0.0
  else if n=0 then sfd_chebyshev_v := 1.0
  else if n=1 then sfd_chebyshev_v := 2.0*x - 1.0
  else if x=0.0 then begin
    if n and 3 in [1,2] then sfd_chebyshev_v := -1.0
    else sfd_chebyshev_v := 1.0
  end
  else if z=1.0 then begin
    if x=1.0 then sfd_chebyshev_v := 1.0
    else if odd(n) then sfd_chebyshev_v := (-2)*n-1
    else sfd_chebyshev_v := 2*n+1;
  end
  else if (n>N1) or ((n>N2) and (abs(z-1.0)<E2))  then begin
    {use trigonometric/hyperbolic functions if n is large or |x| near 1}
    if z<1.0 then begin
      {Mason [59], (2)}
      z := 0.5*arccos(x);
      sfd_chebyshev_v := cos((2*n+1)*z)/cos(z);
    end
    else begin
      z := 0.5*arccosh(z);
      if x>=0.0 then sfd_chebyshev_v := cosh((2*n+1)*z)/cosh(z)
      else begin
        {Mason [59], (3): V(n,-x) = (-1)^n W(n,x)}
        t1 := sinh((2*n+1)*z)/sinh(z);
        if odd(n) then t1 := -t1;
        sfd_chebyshev_v := t1;
      end;
    end;
  end
  else begin
    {Mason [59], p.170}
    z  := 2.0*x;
    t0 := 1.0;
    t1 := z - 1.0;
    for k:=2 to n do begin
      tk := z*t1 - t0;
      t0 := t1;
      t1 := tk;
    end;
    sfd_chebyshev_v := t1;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_chebyshev_w(n: integer; x: double): double;
  {-Return W_n(x), the Chebyshev polynomial of the fourth kind, degree n>=0}
var
  t0, t1, tk, z: double;
  k: integer;
const
  N1 = 512;
  N2 = 16;
  E2 = 1e-5;
begin
  {W(k+1,x) = 2x*W(k,x) - W(k-1,x);   W(0,x) = 1;   W(1,x) = 2x+1}
  z := abs(x);
  if n<0 then sfd_chebyshev_w := 0.0
  else if n=0 then sfd_chebyshev_w := 1.0
  else if n=1 then sfd_chebyshev_w := 2.0*x + 1.0
  else if x=0.0 then begin
    if n and 3 in [0,1] then sfd_chebyshev_w := 1.0
    else sfd_chebyshev_w := -1.0
  end
  else if z=1.0 then begin
    if x=1.0 then sfd_chebyshev_w := 2*n+1
    else if odd(n) then sfd_chebyshev_w := -1.0
    else sfd_chebyshev_w := 1.0;
  end
  else if (n>N1) or ((n>N2) and (abs(z-1.0)<E2))  then begin
    {use trigonometric/hyperbolic functions if n is large or |x| near 1}
    if z<1.0 then begin
      {Mason [59], (2)}
      z := 0.5*arccos(x);
      sfd_chebyshev_w := sin((2*n+1)*z)/sin(z);
    end
    else begin
      z := 0.5*arccosh(z);
      if x>=0.0 then sfd_chebyshev_w := sinh((2*n+1)*z)/sinh(z)
      else begin
        {Mason [59], (3): W(n,-x) = (-1)^n V(n,x)}
        t1 := cosh((2*n+1)*z)/cosh(z);
        if odd(n) then t1 := -t1;
        sfd_chebyshev_w := t1;
      end;
    end;
  end
  else begin
    {Mason [59], p.170}
    z  := 2.0*x;
    t0 := 1.0;
    t1 := z + 1.0;
    for k:=2 to n do begin
      tk := z*t1 - t0;
      t0 := t1;
      t1 := tk;
    end;
    sfd_chebyshev_w := t1;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_gegenbauer_c(n: integer; a,x: double): double;
  {-Return Cn(a,x), the nth Gegenbauer (ultraspherical) polynomial with}
  { parameters a. The degree n must be non-negative; a should be > -0.5}
  { When a=0, C0(0,x) = 1, and Cn(0,x) = 2/n*Tn(x) for n<>0.}
var
  c0,c1,ck,a1,a2: double;
  k: integer;
begin

  {When a=0, C0(0,x) = 1, and Cn(0,x) = 2/n*Tn(x) for n<>0.}
  if a=0.0 then begin
    if n=0 then sfd_gegenbauer_c := 1.0
    else sfd_gegenbauer_c := 2.0*sfd_chebyshev_t(n,x)/n;
    exit;
  end;

  x  := 2.0*x;
  c0 := 1.0;
  c1 := a*x;

  {Recurrence relation, HMF[1] 22.7.3:  C(0,a,x) = 1;  C(1,a,x) = 2*a*x;}
  {k*C(k,a,x) = 2(k+a-1)*x*C(k-1,a,x) - (k+2*a-2)*C(k-2,a,x)  for k > 1.}
  if n<=1 then begin
    if n=1 then sfd_gegenbauer_c := c1
    else if n=0 then sfd_gegenbauer_c := c0
    else sfd_gegenbauer_c := 0.0;
    exit;
  end;

  {Note that a > -0.5 is not checked. It seems that this requirement is}
  {related to the weight function w(x) = (1-x^2)^(a-0.5) HMF[1] 22.2.3.}
  {For a formal definition of Gegenbauer polynomials via the recurrence}
  {relation it is obviously not needed.}
  a1 := a-1.0;
  a2 := 2.0*a1;
  for k:=2 to n do begin
    ck := (k+a1)*x*c1 - (k+a2)*c0;
    c0 := c1;
    c1 := ck/k;
  end;
  sfd_gegenbauer_c := c1;
end;


{---------------------------------------------------------------------------}
function sfd_hermite_h(n: integer; x: double): double;
  {-Return Hn(x), the nth Hermite polynomial, degree n >= 0}
var
  h0,h1,hk: double;
  k: integer;
begin

  h0 := 1.0;
  h1 := 2.0*x;

  {Recurrence relation, HMF[1] 22.7.13:   H(0,x) = 1, H(1,x) = 2*x}
  {H(k,x) = 2*x*H(k-1,x) - 2*(k-1)*H(k-2,x), for k>1.}
  if n<=1 then begin
    if n=1 then sfd_hermite_h := h1
    else if n=0 then sfd_hermite_h := h0
    else sfd_hermite_h := 0.0;
    exit;
  end;

  for k:=2 to n do begin
    hk := x*h1 - pred(k)*h0;
    h0 := h1;
    h1 := 2.0*hk;
  end;
  sfd_hermite_h := h1;
end;


{---------------------------------------------------------------------------}
function sfd_jacobi_p(n: integer; a,b,x: double): double;
  {-Return Pn(a,b,x), the nth Jacobi polynomial with parameters a,b. Degree n}
  { must be >= 0; a,b should be > -1 (a+b must not be an integer < -1).}
var
  p0,p1,pk,q,r,s,t,ab: double;
  k: integer;
begin
  if n<=0 then begin
    if n=0 then sfd_jacobi_p := 1.0
    else sfd_jacobi_p := 0.0;
    exit;
  end;
  ab := a + b;
  if (ab<-1.0) and (frac(ab)=0.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_jacobi_p := NaN_d;
    exit;
  end;
  s  := ab*(a-b);  {a^2 - b^2}
  p0 := 1.0;
  p1 := (ab + 2.0)*x;
  p1 := 0.5*(p1+(a-b));
  for k:= 2 to n do begin
    {See HMF[1], 22.7.1 with "translations": n+1 -> k; a1n -> q; a4n -> r}
    t  := 2*k + ab;
    q  := 2*k*(k+ab)*(t-2.0);
    r  := 2.0*t*(pred(k)+a)*(pred(k)+b);
    pk := s + t*(t-2.0)*x;
    pk := (t-1.0)*pk*p1 - r*p0;
    p0 := p1;
    p1 := pk/q;
  end;
  sfd_jacobi_p := p1;
end;


{---------------------------------------------------------------------------}
function sfd_laguerre(n: integer; a,x: double): double;
  {-Return Ln(a,x), the nth generalized Laguerre polynomial with parameter a;}
  { degree n must be >= 0. x >=0 and a > -1 are the standard ranges.}
var
  l0,l1,lk,a1,ax: double;
  k: integer;
begin

  {Recurrence relation, HMF[1] 22.7.12:  L(0,a,x) = 1;  L(1,a,x) = -x+1+a}
  {L(k,a,x) = (2*k+a-1-x)*L(k-1,a,x)/k - (k+a-1)*L(k-2,a,x)/k  for  k > 1}

  if n<=1 then begin
    if n=1 then sfd_laguerre := a+1.0-x
    else if n=0 then sfd_laguerre := 1.0
    else sfd_laguerre := 0.0;
    exit;
  end;

  if (x<0.0) and (a>-1.0) then begin
    {Calculate result via confluent hypergeometric function M.}
    { = binom(a+n,n) * M(-n,a+1,x); see HMF[1] 22.5.54, 13.1.2}
    a1 := a+1.0;
    ax := 1.0;  {binom}
    lk := 1.0;  {kth term of M}
    l1 := lk;   {sum M}
    for k:=0 to n-1 do begin
      {here (k-n)*x > 0, and lk > 0}
      lk := (k-n)/(a1+k)*x/(k+1)*lk;
      l1 := l1 + lk;
      ax := ax*(a1+k)/(k+1);
    end;
    l1 := l1*ax;
  end
  else begin
    {Calculate via standard recurrence relation}
    a1 := a-1.0;
    ax := a1-x;
    l0 := 1.0;
    l1 := a+1.0-x;
    for k:=2 to n do begin
      lk := (2*k+ax)*l1 - (k+a1)*l0;
      l0 := l1;
      l1 := lk/k;
    end;
  end;
  sfd_laguerre := l1;
end;


{---------------------------------------------------------------------------}
function sfd_laguerre_ass(n,m: integer; x: double): double;
  {-Return the associated Laguerre polynomial Ln(m,x); n,m >= 0}
begin
  if (n<0) or (m<0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_laguerre_ass := NaN_d;
    exit;
  end;
  sfd_laguerre_ass := sfd_laguerre(n,m,x);
end;


{---------------------------------------------------------------------------}
function sfd_laguerre_l(n: integer; x: double): double;
  {-Return the nth Laguerre polynomial Ln(0,x); n >= 0}
begin
  if n<0 then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_laguerre_l := NaN_d;
    exit;
  end;
  sfd_laguerre_l := sfd_laguerre(n,0.0,x);
end;


{---------------------------------------------------------------------------}
function sfd_zernike_r(n,m: integer; r: double): double;
  {-Return the Zernike radial polynomial Rnm(r), r >= 0, n >= m >= 0, n-m even}
var
  t: double;
begin
  if (m<0) or (n<m) or odd(n-m) or (r<0.0) then sfd_zernike_r := 0.0
  else if r=1.0 then sfd_zernike_r := 1.0
  else if r=0.0 then begin
    {Rnm(0) is non-zero only if m=0. Then n is even and Rn0(0) = (-1)^(n/2)}
    if m>0 then sfd_zernike_r := 0.0
    else if n and 3 = 0 then sfd_zernike_r := 1.0
    else sfd_zernike_r := -1.0;
  end
  else begin
    t := power(r,m);
    if n=m then sfd_zernike_r := t   {Rmm(r) = r^m}
    else begin
      {See http://mathworld.wolfram.com/ZernikePolynomial.html, (6)}
      {Rnm(r) = (-1)^k * r^m * jacobi_p(k,m,0,1-2*r^2), k = (n-m)/2}
      n := (n-m) div 2;
      if odd(n) then t := -t;
      sfd_zernike_r := t*sfd_jacobi_p(n, m, 0.0, 1.0 - 2.0*sqr(r));
    end;
  end;
end;


{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}


{---------------------------------------------------------------------------}
function sfd_legendre_p(l: integer; x: double): double;
  {-Return P_l(x), the Legendre polynomial/function P_l, degree l}
var
  p0, p1, pk: double;
  k: integer;
begin
  if IsNanOrInfD(x) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_legendre_p := NaN_d;
    exit;
  end;
  if abs(x)=1.0 then begin
    if (x=-1.0) and odd(l) then sfd_legendre_p := -1.0
    else sfd_legendre_p := 1.0;
  end
  else begin
    if l<0 then l := -l-1;            {negative degree: HMF[1] 8.2.1}
    {here l >= 0}
    if l=0 then sfd_legendre_p := 1                    {HMF[1] 8.4.1}
    else if l=1 then sfd_legendre_p := x               {HMF[1] 8.4.3}
    else if l=2 then sfd_legendre_p := 1.5*sqr(x)-0.5  {HMF[1] 8.4.5}
    else begin
      if (x=0.0) and odd(l) then sfd_legendre_p := 0.0
      else begin
        p0 := 1.0;
        p1 := x;
        {Recurrence relation for varying degree: HMF[1] 8.5.3}
        for k:=2 to l do begin
          pk := ((2*k-1)*x*p1 - (k-1)*p0)/k;
          p0 := p1;
          p1 := pk;
        end;
        sfd_legendre_p := p1;
      end;
    end;
  end;
end;


(*
{With unit sdhyperg use this function}
{---------------------------------------------------------------------------}
function lq_hf(l: integer; x: double): double;
var
  f,t: double;
begin
  f := sfd_2f1(1+0.5*l, 0.5*(l+1), l+1.5, 1/sqr(x));
  t := sfd_gamma_ratio(l+1,l+1.5);
  t := t*SqrtPi/power(2*x,l+1);
  lq_hf := f*t;
end;
*)

{---------------------------------------------------------------------------}
function lq_hf(l: integer; x: double): double;
  {-Compute Q_l(x) for 1 < x <= 1.05 if CF did not converge}
var
  a,b,p,q,r,s,k,y: double;
const
  TOL = 1.5e-15;
begin
  {Hypergeometric summation for x near 1 uses Lebedev[45], 7.3.7}
  {with HMF[1], 15.3.10 and psi function recursion formulas}
  a := 1.0 + 0.5*l;
  b := 0.5*(l+1);
  s := (x-1.0)*(x+1.0)/sqr(x);
  p := sfd_psi(a);
  q := sfd_psi(b);
  r := -2.0*Eulergamma - p - q - ln(s);
  y := r;
  p := a*b*s;
  k := 1.0;
  repeat
    r := r + 2.0/k - 1.0/(a+k-1.0) - 1.0/(b+k-1.0);
    q := p*r;
    y := y+q;
    p := p*(s*(a+k)/(k+1.0));
    p := p*((b+k)/(k+1.0));
    k := k+1.0;
  until abs(q)<=TOL*abs(y);
  s := sfd_beta(a,b);
  y := y/s;
  s := sfd_gamma_ratio(l+1,l+1.5);
  s := s*SqrtPi/power(2.0*x,l+1);
  lq_hf := y*s;
end;


{---------------------------------------------------------------------------}
procedure lq_cfrac(x: double; n: integer; var fv: double; var OK: boolean);
  {-Compute CF for Q(n,x)/Q(n-1) for n>0, x>1}
var
  a,b,c,d,f,t,r,tiny,tol: double;
  k,maxiter: integer;
begin

  {Evaluate the continued fraction NIST [30], 14.14.3/4 using}
  {using the modified Lentz method. For x ~ 1 the convergence}
  {of the CF is very slow!}

  tol  := 2.0*eps_d;
  tiny := Sqrt_MinDbl;

  {If x <= 1.05 hypergeometric summation is available if the CF does}
  {not converge, so do not waste iterations and use a smaller limit!}
  if x>1.05 then maxiter := 5000
  else maxiter := 500;

  f := tiny;
  c := f;
  d := 0.0;
  x := x+x;
  b := (n-0.5)*x;
  r := n;

  for k:=0 to maxiter do begin
    a := sqr(r);
    b := b+x;
    d := b - a*d;
    c := b - a/c;
    if c=0.0 then c := tiny;
    if d=0.0 then d := tiny;
    d := 1.0/d;
    t := c*d;
    f := f*t;
    if abs(t-1.0) < tol then begin
      fv := -f/n;
      OK := true;
      exit;
    end;
    r := r+1.0;
  end;
  OK := false;
  fv := -f/n;
end;


{---------------------------------------------------------------------------}
function lq1(x: double): double;
  {-Return Legendre Q_1(x), |x|<>1}
var
  s,t,f,y: double;
  k: integer;
begin
  t := abs(x);
  if t<1.0 then lq1 := arctanh(x)*x - 1.0
  else begin
    {Q_1(x) = x*arccoth(x)-1}
    if t<2.0 then lq1 := 0.5*ln1p(2.0/(t-1.0))*t - 1.0
    else if t>=Sqrt_MaxDbl then lq1 := 0.0
    else begin
      {x*arccoth(x)-1 = sum(1/((2k+1)x^(2k)), k=1..Inf}
      y := 1.0/(x*x);
      t := 1.0;
      f := 3.0;
      s := t;
      k := 5;
      repeat
        f := f*y;
        t := f/k;
        s := s+t;
        inc(k,2);
      until t <= s*eps_d;
      lq1 := s*y/3.0;
    end;
  end;
end;


{---------------------------------------------------------------------------}
function lq0(x: double): double;
  {-Return Legendre Q_0(x), |x|<>1}
begin
  if abs(x)<1.0 then lq0 := arctanh(x)
  else lq0 := arccoth(x)
end;


{---------------------------------------------------------------------------}
function sfd_legendre_q(l: integer; x: double): double;
  {-Return Q_l(x), the Legendre function of the second kind, degree l >= 0, |x| <> 1}
var
  q0,q1,qk: double;
  k: integer;
  ok: boolean;
begin
  if (l<0) or IsNanOrInfD(x) or (abs(x)=1.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_legendre_q := NaN_d;
    exit;
  end;
  if (x=0.0) and (l and 1 = 0) then sfd_legendre_q := 0.0
  else if l=0 then sfd_legendre_q := lq0(x)
  else if l=1 then sfd_legendre_q := lq1(x)
  else begin
    if abs(x) <= 1.0 then begin
      q0 := lq0(x);
      q1 := lq1(x);
      {Recurrence relation for varying degree: HMF[1] 8.5.3}
      for k:=2 to l do begin
        qk := ((2*k-1)*x*q1 - (k-1)*q0)/k;
        q0 := q1;
        q1 := qk;
      end;
      sfd_legendre_q := q1;
    end
    else begin
      {Backward recurrence using QF for starting value and normalise with}
      {Q0 or Q1. Note that for x close to 1 the QF does not converge fast}
      lq_cfrac(x,l+1,q1,ok);
      if ok then begin
        q0 := Sqrt_MinDbl;
        q1 := q1*Sqrt_MinDbl;
        for k:=l downto 1 do begin
          qk := ((2*k+1)*x*q0 - (k+1)*q1)/k;
          q1 := q0;
          q0 := qk;
        end;
        if abs(q0) > abs(q1) then begin
          qk := lq0(x);
          sfd_legendre_q := Sqrt_MinDbl*qk/q0;
        end
        else begin
          qk := lq1(x);
          sfd_legendre_q := Sqrt_MinDbl*qk/q1;
        end;
      end
      else begin
        {With unit sdhyperg use lq_hf with sfd_2f1 and drop test 'x > 1.05'}
        sfd_legendre_q := lq_hf(l, x);
        {$ifopt R+}
          if x > 1.05 then begin
            {No convergence}
            if RTE_NoConvergence>0 then RunError(byte(RTE_NoConvergence));
          end;
        {$endif}
      end
    end;
  end;
end;


{---------------------------------------------------------------------------}
function legendre_plmf(l,m: integer; x,f: double): double;
  {-Associated Legendre polynomial P_lm(x), f=|1-x^2|^(|m|/2) calculated externally}
var
  p0, p1, pk: double;
  k: integer;
begin
  {Ref: HMF [1], ch.8; NR [13] ch.6.8; [19] legendre.hpp/legendre_imp}
  if l<0 then l := -l-1; {negative degree: HMF[1] 8.2.1}
  if m<0 then begin
    {Negative order: P(l,-m) = s*(l-m)!/(l+m)! P(l,m), for s see below}
    k := l+m;
    if k<0 then p1 := 0
    else p1 := legendre_plmf(l, -m, x, f);
    if p1<>0.0 then begin
      {calculate Gamma(l+m+1)/Gamma(l-m+1) via sfd_fac if possible}
      l := l-m;
      if l<MAXGAMD then p0 := sfd_fac(k)/sfd_fac(l)
      else p0 := sfd_gamma_ratio(k+1, l+1);
      {If |x| <= 1 there is an additional factor s=(-1)^m, but no factor}
      {if |x| > 1, see NIST [30], 14.9.3 vs 14.9.13}
      if odd(m) and (abs(x)<=1.0) then p1 := -p1*p0
      else p1 := p1*p0;
    end;
    legendre_plmf := p1;
  end
  else if m>l then legendre_plmf := 0.0
  else if m=0 then legendre_plmf := sfd_legendre_p(l,x)
  else begin
    {Starting value p0 = P_mm = (-1)^m * (2m-1)!! * f,  NR[13] 6.8.8}
    p0 := sfd_dfac(2*m-1)*f;
    if odd(m) and (x<=1.0) then p0 := -p0;
    if m=l then begin
      legendre_plmf := p0;
      exit;
    end;
    p1 := x*p0*(2*m + 1);
    k := succ(m);
    while k<l do begin
      {Recurrence relation for varying degree: HMF[1] 8.5.3}
      pk := ((2*k+1)*x*p1 - (k+m)*p0)/(k+1-m);
      p0 := p1;
      p1 := pk;
      inc(k);
    end;
    legendre_plmf := p1;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_legendre_plm(l,m: integer; x: double): double;
  {-Return the associated Legendre polynomial P_lm(x)}
var
  f: double;
begin
  if IsNanOrInfD(x) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_legendre_plm := NaN_d;
    exit;
  end;
  if m=0 then sfd_legendre_plm := sfd_legendre_p(l,x)
  else begin
    f := (1.0-x)*(1.0+x);
    if f=0.0 then sfd_legendre_plm := 0.0
    else begin
      f := power(abs(f), 0.5*abs(m));
      if x > -1.0 then sfd_legendre_plm := legendre_plmf(l,m,x,f)
      else begin
        {Switch to positive degree. Although legendre_plmf handles this case, }
        {it is already done here because it changes the odd/even status below.}
        if l<0 then l := -l-1;
        {x on the branch cut (-inf,-1), choose P_lm(x + i*0)}
        {and use Lebedev [45], 7.12.24 with integer nu = l}
        f := legendre_plmf(l,m,abs(x),f);
        if odd(l) then sfd_legendre_plm := -f
        else sfd_legendre_plm := f;
      end;
    end;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_legendre_qlm(l,m: integer; x: double): double;
  {-Return Q(l,m,x), the associated Legendre function of the second kind; l >= 0, l+m >= 0, |x|<>1}
var
  q0,q1,qk,r: double;
  k: integer;
  neg: boolean;
begin
  if (l<0) or (l+m<0) or IsNanOrInfD(x) or (abs(x)=1.0) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_legendre_qlm := NaN_d;
    exit;
  end;
  if m<0 then begin
    {Negative order: Q(l,-m) = s*(l-m)!/(l+m)! Q(l,m), for s see below}
    k  := l+m;
    q1 := sfd_legendre_qlm(l, -m, x);
    if q1<>0.0 then begin
      {calculate Gamma(l+m+1)/Gamma(l-m+1) via sfd_fac if possible}
      l := l-m;
      if l<MAXGAMD then q0 := sfd_fac(k)/sfd_fac(l)
      else q0 := sfd_gamma_ratio(k+1, l+1);
      {If |x| < 1 there is an additional factor s=(-1)^m, but no factor}
      {if |x| > 1 see NIST [30], 14.9.4/14 and HMF[1], 8.2.6}
      if odd(m) and (abs(x)<1.0) then q1 := -q1*q0
      else q1 := q1*q0;
    end;
    sfd_legendre_qlm := q1;
  end
  else if m=0 then sfd_legendre_qlm := sfd_legendre_q(l,x)
  else begin
    {here m>0}
    if abs(x)<1.0 then begin
      r := sqrt((1.0-x)*(1.0+x));
      q0 := sfd_legendre_q(l,x);
      if l=0 then q1 := -1.0/r
      else begin
        {NIST[30] 14.10.2: Q(l,1,x) = ((l+1)*Q(l+1,x) - (l+1)*x*Q(l,x))/r }
        q1 := sfd_legendre_q(l+1,x);
        q1 := (q1 - x*q0)*(l+1)/r;
      end;
      if m>1 then begin
        r := -2.0*x/r;
        for k:=0 to m-2 do begin
          {NIST[30] 14.10.1}
          qk := (k+1)*r*q1 - (l-k)*q0*(l+k+1);
          q0 := q1;
          q1 := qk;
        end;
      end;
      sfd_legendre_qlm := q1;
    end
    else begin
      {Let Q(l,m,z) to be continuous onto the cut (-inf,-1) from above, i.e.}
      {Q(-x) = Q(-x+i0) and use HMF[1] 8.2.4: thus Q(-x) = -exp(i*l*Pi)*Q(x)}
      neg := (x<-1.0) and (l and 1 = 0);
      x := abs(x);

      r := sqrt((x-1.0)*(x+1.0));
      q0 := sfd_legendre_q(l,x);
      if l=0 then q1 := -1.0/r
      else begin
        {NIST[30] 14.10.7: Q(l,1) = ((l+1)*Q(l+1,x) - (l+1)*x*Q(l,x))/r }
        q1 := sfd_legendre_q(l+1,x);
        q1 := (q1 - x*q0)*(l+1)/r;
      end;
      if m>1 then begin
        r := -2.0*x/r;
        for k:=0 to m-2 do begin
          {NIST[30] 14.10.6}
          qk := (k+1)*r*q1 + (l-k)*q0*(l+k+1);
          q0 := q1;
          q1 := qk;
        end;
      end;
      if neg then sfd_legendre_qlm := -q1
      else sfd_legendre_qlm := q1;
    end;
  end;
end;


{---------------------------------------------------------------------------}
procedure sfd_spherical_harmonic(l, m: integer; theta, phi: double; var yr,yi: double);
  {-Return Re and Im of the spherical harmonic function Y_lm(theta,phi)}
var
  r_sign, i_sign: boolean;
  t,f: double;
  k: integer;
begin
  {Ref: Boost [19], special_functions\spherical_harmonic.hpp}
  if (l<0) or (abs(m)>l) then begin
    yr := 0.0;
    yi := 0.0;
    exit;
  end;
  if m < 0 then begin
    {Reflect and adjust sign if m < 0}
    r_sign := odd(m);
    i_sign := not r_sign;
    m := abs(m);
  end
  else begin
    r_sign := false;
    i_sign := false;
  end;
  if odd(m) then begin
    {Check phase if theta is outside [0, Pi]:}
    t := rem_2pi(theta);
    if t<0.0 then t := t+TwoPi;
    if t>Pi  then begin
      r_sign := not r_sign;
      i_sign := not i_sign;
    end;
  end;
  {Calculate amplitude}
  k := l+m;
  if (k>=0) and (k<MAXGAMD) then t := sfd_fac(l-m)/sfd_fac(k)
  else t := sfd_gamma_delta_ratio(l-m+1, 2*m);
  t := 0.5*sqrt(t*(2*l+1)/Pi);
  f := power(abs(sin(theta)), m);
  f := legendre_plmf(l,m,cos(theta),f);
  f := f*t;
  {f*exp(i*m*phi)}
  sincos(m*phi, yi, yr);
  yr := f*yr;
  yi := f*yi;
  {Add in the signs}
  if r_sign then yr := -yr;
  if i_sign then yi := -yi;
end;


{---------------------------------------------------------------------------}
function q0mh(x: double): double;
  {-Return Q, order 0, degree -1/2}
var
  k: double;
begin
  k := sqrt(2.0/(1.0+x));
  q0mh := sfd_EllipticK(k)*k;
end;


{---------------------------------------------------------------------------}
function q0pha(x: double): double;
  {-Return Q, order 0, degree +1/2, x >= 8}
const
  {Ref: HMF[1], 8.1.3 with nu=1/2, m=0. Coefficients are evaluated with Maple:}
  {for n from 0 to 10 do print(evalf(pochhammer(3/4,n)*pochhammer(5/4,n)/n!/(n+1)!)); od;}
  ca0: array[0..10] of double = (
         1.0,
         0.4687500000000000000000000000000000000000,
         0.3076171875000000000000000000000000000000,
         0.2291107177734375000000000000000000000000,
         0.1825726032257080078125000000000000000000,
         0.1517634764313697814941406250000000000000,
         0.1298571412917226552963256835937500000000,
         0.1134800687850656686350703239440917968750,
         0.1007726652492380026160390116274356842041,
         0.09062541770678000929706286115106195211411,
         0.08233525165519388344659290623894776217639);
var
  s: double;
const
  Pi_r32: double = 0.5553603672697957809; {Pi/sqrt(32)}
begin
  if x>=1e40 then s := 1.0
  else s := PolEval(1.0/sqr(x),ca0,11);
  q0pha := s*Pi_r32*power(x,-1.5);
end;


{---------------------------------------------------------------------------}
function q0ph(x: double): double;
  {-Return Q, order 0, degree +1/2}
var
  kc,a: double;
begin
  if x>=8.0 then q0ph := q0pha(x)
  else begin
    {The standard form with elliptic integrals is [k := sqrt(2/(1+x))]:
    q0ph := sfd_EllipticK(k)*k*x - sfd_EllipticEC(k)*sqrt(2*(1+x));
    but this suffers from severe cancellation even for medium x ~ 8.
    Use algebraic manipulation and Bulirsch's cel function}
    kc   := sqrt((x-1.0)/(x+1.0));
    a    := sqrt(2.0/(1.0+x));
    q0ph := a*sfd_cel(kc,1,-1,1);
  end;
end;


{---------------------------------------------------------------------------}
function q1mh(x: double): double;
  {-Return Q, order 1, degree -1/2}
var
  k: double;
begin
  k := sqrt(2.0/(x+1.0));
  q1mh := -0.5*sfd_EllipticEC(k)/sqrt(0.5*(x-1.0));
end;


{---------------------------------------------------------------------------}
function q1pha(x: double): double;
  {-Return Q, order 1, degree +1/2, x >= 8}
const
  {Ref: HMF[1], 8.1.3 with nu=1/2, m=1. Coefficients are evaluated with Maple:}
  {for n from 0 to 10 do print(evalf(pochhammer(7/4,n)*pochhammer(5/4,n)/n!/(n+1)!)); od;}
  ca1p: array[0..10] of double = (
          1.0,
          1.093750000000000000000000000000000000000,
          1.127929687500000000000000000000000000000,
          1.145553588867187500000000000000000000000,
          1.156293153762817382812500000000000000000,
          1.163519985973834991455078125000000000000,
          1.168714271625503897666931152343750000000,
          1.172627377445678575895726680755615234375,
          1.175681094574443363853788468986749649048,
          1.178130430188140120861817194963805377483,
          1.180138607057778996067831656091584591195);
const
  c1p: double = -0.83304055090469367131547768563638; {-3*Pi/sqrt(128)}
var
  s,y: double;
begin
  if x>=1e40 then s := 1.0
  else begin
    y := 1.0/sqr(x);
    s := PolEval(y,ca1p,11);
    s := sqrt(1.0-y)*s;
  end;
  q1pha := c1p*s*power(x,-1.5);
end;


{---------------------------------------------------------------------------}
function q1ph(x: double): double;
  {-Return Q, order 1, degree +1/2}
var
  kc2,a,b: double;
begin
  if x>=8.0 then q1ph := q1pha(x)
  else begin
    a := (-1.0)/sqrt(2.0*(x-1.0));
    b := sqrt(0.5*(x-1.0))/(x+1.0);
    kc2  := (x-1.0)/(x+1.0);
    q1ph := sfd_cel(sqrt(kc2),1.0,a,b);
  end;
end;


{---------------------------------------------------------------------------}
function sfd_thq(l,m: integer; x: double): double;
  {-Return the toroidal harmonic function Q(l-0.5,m,x); l=0,1; x > 1}
var
  f,y,nu,q0,q1,qk: double;
  k: integer;
begin
  if (x<=1.0) or (l<0) or (l>1) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_thq := NaN_d;
    exit;
  end;

  if m<0 then begin
    {Map to positive order, HMF[1], 8.2.6}
    m := -m;
    f := sfd_gamma_ratio(l-m+0.5,l+m+0.5);
  end
  else f := 1.0;

  if m=0 then begin
    if l=1 then sfd_thq := q0ph(x) else sfd_thq := q0mh(x);
  end
  else if m=1 then begin
    if l=1 then sfd_thq := f*q1ph(x) else sfd_thq := f*q1mh(x);
  end
  else begin
    if l=1 then begin
      nu := 0.5;
      q0 := q0ph(x);
      q1 := q1ph(x);
    end
    else begin
      nu := -0.5;
      q0 := q0mh(x);
      q1 := q1mh(x);
    end;
    if x >= 1e10 then y := 2.0
    else begin
      y := sqrt((x+1.0)*(x-1.0));
      y := 2.0*x/y;
    end;
    for k:=1 to pred(m) do begin
      qk := (nu-(k-1))*(nu+k)*q0 - k*y*q1;
      q0 := q1;
      q1 := qk;
    end;
    sfd_thq := f*q1;
  end;
end;


{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}

function p0mh(x: double): double;
  {-Return P, order 0, degree -1/2}
var
  kc: double;
begin
  {HMF[1], 8.13.1: EllipticK(sqrt((x-1)/(x+1))) * sqrt(2/(x+1)) / (Pi/2)}
  {Rewritten for increased accuracy to use kc and cel1}
  kc := sqrt(2.0/(1.0+x));
  p0mh := kc*sfd_cel1(kc)/Pi_2;
end;


{---------------------------------------------------------------------------}
function p0ph(x: double): double;
  {-Return P, order 0, degree +1/2}
var
  y,z: double;
begin
  {HMF[1], 8.13.5}
  if x>=2e16 then p0ph := sqrt(0.5*x)/Pi_4
  else begin
    y := sqrt((x-1.0)*(x+1.0));
    z := x + y;
    y := sfd_EllipticEC(sqrt(2.0*(y/z)));
    p0ph := y*sqrt(z)/Pi_2;
  end;
end;


{---------------------------------------------------------------------------}
function p1mh(x: double): double;
  {-Return P, order 1, degree -1/2}
var
  c,t,f: double;
const
  cinf = -0.794415416798359282516963643745297e-1; {2*Eulergamma + ln(2) + Psi(1/2) + Psi(-1/2)}
begin
  {Alternate forms from Wolfram Alpha output: LegendreP(-1/2,1,3,x). The IMO}
  {complicated expressions are simplified and transformed to Bulirsch style.}
  if x=1.0 then p1mh := 0.0
  else if x>=2e16 then begin
    t := cinf-ln(x);
    p1mh := t/sqrt(0.5*x)/TwoPi;
  end
  else begin
    c := 0.5*(x+1.0);  {c = kc^2 = 1 - (1-x)/2}
    f := -sqrt((x+1.0)/(x-1.0))/Pi;
    if c<2.0 then t := (c-1.0)/c
    else t := 1.0-1.0/c;
    t := sfd_cel2(sqrt(c), t, 0.0);
    p1mh := f*t;
  end;
end;


{---------------------------------------------------------------------------}
function p1ph(x: double): double;
  {-Return P, order 1, degree 1/2}
var
  c,t,f: double;
begin
  {Alternate forms from Wolfram Alpha output: LegendreP(+1/2,1,3,x). The IMO}
  {complicated expressions are simplified and transformed to Bulirsch style.}
  if x=1.0 then p1ph := 0.0
  else if x>=2e16 then p1ph := sqrt(0.5*x)/Pi_2
  else begin
    c := 0.5*(x+1.0);  {c = kc^2 = 1 - (1-x)/2}
    f := -sqrt((x+1.0)/(x-1.0))/Pi;
    if c<2.0 then t := (1.0-x)/(1.0+x)
    else t := 1.0-x/c;
    t := sfd_cel(sqrt(c), 1.0, t, 1.0-x);
    p1ph := f*t;
  end;
end;


{---------------------------------------------------------------------------}
function sfd_thp(l,m: integer; x: double): double;
  {-Return the toroidal harmonic function P(l-0.5,m,x); l,m=0,1; x >= 1}
begin
  if (x<1.0) or (l<0) or (l>1) or (m<0) or (m>1) then begin
    {$ifopt R+}
      if RTE_ArgumentRange>0 then RunError(byte(RTE_ArgumentRange));
    {$endif}
    sfd_thp := NaN_d;
    exit;
  end;

  if m=0 then begin
    if l=1 then sfd_thp := p0ph(x) else sfd_thp := p0mh(x);
  end
  else begin
    if l=1 then sfd_thp := p1ph(x) else sfd_thp := p1mh(x);
  end;
end;


end.
