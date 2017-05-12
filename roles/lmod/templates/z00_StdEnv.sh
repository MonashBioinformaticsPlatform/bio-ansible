if [ -z "$__Init_Default_Modules" ]; then
  export __Init_Default_Modules=1;
  ## ability to predefine elsewhere the default list
  LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"}
  export LMOD_SYSTEM_DEFAULT_MODULES
  module --initial_load restore
else
  module refresh
fi
