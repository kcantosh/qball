dnl NOT available from the GNU Autoconf Macro Archive at:
dnl http://www.gnu.org/software/ac-archive/htmldoc/acx_scalapack.html
dnl
AC_DEFUN([ACX_SCALAPACK], [
AC_REQUIRE([ACX_BLACS])
acx_scalapack_ok=no

dnl We cannot use SCALAPACK if BLACS is not found
 if test "x$acx_blacs_ok" != xyes; then
  acx_scalapack_ok=noblacs
 fi

dnl Get fortran linker name of SCALAPACK function to check for.
dnl if not compiling with fortran, convert the names
m4_if(_AC_LANG, Fortran, [pcheev=pcheev], [AC_FC_FUNC(pcheev)])

dnl Check if the library was given in the command line
if test $acx_scalapack_ok = no; then
  AC_ARG_WITH(scalapack, [AS_HELP_STRING([--with-scalapack=<lib>], [use SCALAPACK library <lib>])])
  case $with_scalapack in
    yes | "") ;;
    no) acx_scalapack_ok=disable ;;
    -* | */* | *.a | *.so | *.so.* | *.o) LIBS_SCALAPACK="$with_scalapack" ;;
    *) LIBS_SCALAPACK="-l$with_scalapack" ;;
  esac
fi

dnl Backup LIBS 
acx_scalapack_save_LIBS="$LIBS"
LIBS="$LIBS_SCALAPACK $LIBS_BLACS $LIBS_LAPACK $LIBS_BLAS $LIBS $FCLIBS"

dnl First, check LIBS_SCALAPACK environment variable
if test $acx_scalapack_ok = no; then
  AC_MSG_CHECKING([for $pcheev in $LIBS_SCALAPACK])
  AC_LINK_IFELSE([AC_LANG_CALL([], [$pcheev])], [acx_scalapack_ok=yes], [])
  if test $acx_scalapack_ok = no; then
    AC_MSG_RESULT([$acx_scalapack_ok ($LIBS_SCALAPACK)])
  else
    AC_MSG_RESULT([$acx_scalapack_ok ($LIBS_SCALAPACK)])
  fi
fi

dnl Generic SCALAPACK library?
for scalapack in scalapack scalapack-openmpi; do
  if test $acx_scalapack_ok = no; then
    AC_CHECK_LIB($scalapack, $pcheev,
      [acx_scalapack_ok=yes; LIBS_SCALAPACK="$LIBS_SCALAPACK -l$scalapack"], [], [$FCLIBS])
  fi
done

AC_SUBST(LIBS_SCALAPACK)
LIBS="$acx_scalapack_save_LIBS"

dnl Finally, execute ACTION-IF-FOUND/ACTION-IF-NOT-FOUND:
if test x"$acx_scalapack_ok" = xyes; then
  AC_DEFINE(HAVE_SCALAPACK,1,[Defined if you have SCALAPACK library.])
else
  if test "x$acx_blacs_ok" == xyes; then
  AC_MSG_ERROR([Could not find the Scalapack library.])
  fi
fi
])dnl ACX_SCALAPACK

dnl Check for Scalapack 2 (that contains pzheevr)
AC_DEFUN([ACX_SCALAPACK2], [
AC_REQUIRE([ACX_SCALAPACK])
acx_scalapack2_ok=no

dnl We cannot use SCALAPACK if BLACS is not found
if test "x$acx_scalapack_ok" != xyes; then
  acx_scalapack2_ok=noscalapack
else
  dnl Get fortran linker name of SCALAPACK function to check for.
  dnl if not compiling with fortran, convert the names
  m4_if(_AC_LANG, Fortran, [pzheevr=pzheevr], [AC_FC_FUNC(pzheevr)])

  dnl Backup LIBS 
  acx_scalapack_save_LIBS="$LIBS"
  LIBS="$LIBS_SCALAPACK $LIBS_BLACS $LIBS_LAPACK $LIBS_BLAS $LIBS $FCLIBS"
  AC_CHECK_FUNC($pzheevr, [acx_scalapack2_ok=yes], [])
  LIBS="$acx_scalapack_save_LIBS"

  if test "x$acx_scalapack2_ok" == xyes; then
    AC_DEFINE(HAVE_SCALAPACK, 1, [Defined if you have SCALAPACK library version 2 or greater.])
  else
    AC_MSG_ERROR([Found scalapack version 1. Qball requires version 2.0.0 or newer.
    ])
  fi
  
fi

]) dnl ACX_SCALAPACK2


