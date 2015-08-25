if [ -e "${ECLIPSE_HOME}/eclimd" ]; then
  # Start the eclim deamon
  alias start_eclimd='$ECLIPSE_HOME/eclimd -f ${ECLIMSTARTUP} &> /dev/null &'

  # Stop the eclim deamon
  alias stop_eclimd='$ECLIPSE_HOME/eclim -f ${ECLIMSTARTUP} -command shutdown'
fi
