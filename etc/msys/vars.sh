# msys does not support symlinks (without admin access)
: ${src:=$(cygpath -ms "${OneDrive:-${HOME}}/src")}
