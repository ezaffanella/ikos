###############################################################################
#
# Find FLINT headers and libraries.
#
# Author: Enea Zaffanella
#
# Contact: enea.zaffanella@unipr.it
#
# Notices:
#
# Copyright (c) 2018-2019 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Disclaimers:
#
# No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
# ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
# TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS,
# ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE
# ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO
# THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
# ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
# RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
# RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
# DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE,
# IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."
#
# Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST
# THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL
# AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS
# IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH
# USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM,
# RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD
# HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS,
# AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.
# RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE,
# UNILATERAL TERMINATION OF THIS AGREEMENT.
#
###############################################################################

if (NOT FLINT_FOUND)
  set(FLINT_ROOT "" CACHE PATH "Path to flint install directory")

  find_path(FLINT_INCLUDE_DIR
    NAMES flint/flint.h
    HINTS "${FLINT_ROOT}/flint"
    DOC "Path to flint include directory"
  )

  find_library(FLINT_LIB
    NAMES flint
    HINTS "${FLINT_ROOT}/lib"
    DOC "Path to flint library"
  )

  if (FLINT_INCLUDE_DIR AND FLINT_LIB)
    file(WRITE "${PROJECT_BINARY_DIR}/FindFLINTVersion.c" "
      #include <assert.h>
      #include <stdio.h>
      #include <flint/fmpz.h>

      int main() {
        fmpz_t i, j, k;
        fmpz_init_set_si(i, 26);
        fmpz_init(j);
        fmpz_init(k);
        fmpz_sqrtrem(j, k, i);
        assert(fmpz_get_si(j) == 5 && fmpz_get_si(k) == 1);
        printf(\"%s\", version);
        return 0;
      }
    ")

    try_run(
      RUN_RESULT
      COMPILE_RESULT
      "${PROJECT_BINARY_DIR}"
      "${PROJECT_BINARY_DIR}/FindFLINTVersion.c"
      CMAKE_FLAGS
        "-DINCLUDE_DIRECTORIES:STRING=${FLINT_INCLUDE_DIR}"
        "-DLINK_LIBRARIES:STRING=${FLINT_LIB};${GMP_LIB}"
      COMPILE_OUTPUT_VARIABLE COMPILE_OUTPUT
      RUN_OUTPUT_VARIABLE FLINT_VERSION
    )

    if (NOT COMPILE_RESULT)
      message(FATAL_ERROR "error when trying to compile a program with FLINT:\n${COMPILE_OUTPUT}")
    endif()
    if (RUN_RESULT)
      message(FATAL_ERROR "error when running a program linked with FLINT:\n${FLINT_VERSION}")
    endif()
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(FLINT
    REQUIRED_VARS
      FLINT_INCLUDE_DIR
      FLINT_LIB
    VERSION_VAR
      FLINT_VERSION
    FAIL_MESSAGE
      "Could NOT find FLINT. Please provide -DFLINT_ROOT=/path/to/flint")
endif()
