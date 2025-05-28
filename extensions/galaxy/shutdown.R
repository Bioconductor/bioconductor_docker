# Shutdown script for Galaxy Interactive tool.
# To shut down this IT, run this script (or below command).
system("sudo s6-svscanctl -t /var/run/s6/services/", wait = FALSE)
