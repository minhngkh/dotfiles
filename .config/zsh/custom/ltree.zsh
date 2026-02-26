lt() {
   if [[ "$1" =~ ^[0-9]+$ ]]
   then
      lsd --group-directories-first --tree --depth=$1 "${@:2}"
   else
      lsd --group-directories-first --tree "$@"
   fi
}
