if ( ! $?__Init_Default_Modules || ! $?LD_LIBRARY_PATH ) then
  module getdefault default
  if ( $status != 0 ) then
    module load StdEnv
  endif
  setenv __Init_Default_Modules 1
endif

