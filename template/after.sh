# Wait for the Jupyter Notebook server to start
echo "Waiting for Jupyter Notebook server to open port ${port}..."
echo "TIMING - Starting wait at: $(date)"
if wait_until_port_used "${host}:${port}" 60; then
  echo "Discovered Jupyter Notebook server listening on port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
else
  echo "Timed out waiting for Jupyter Notebook server to open port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
  pkill -P ${SCRIPT_PID}
  clean_up 1
fi
sleep 2


# setup portforwarding.
echoinfo () 
{
        echo -e "\033[32m[INFO] $@\033[0m"
}

echoerror ()
{
        echo -e "\033[31m[ERROR] $@\033[0m"
}

echoalert ()
{
        echo -e "\033[34;5m[INFO] $@\033[0m"
}

# remote host ondemand
remote_host="ondemand"

# set remote port to be 4+last 4 digit of jobid. \$LSB_JOBID
remote_port="4$(echo $LSB_JOBID|cut -c 5-)"

ssh -g -N -R $remote_port:localhost:${port} $remote_host &

access_host="ondemand.hpc.mssm.edu"
external_url="http://$access_host:$remote_port/node/${host}/${port}"

echoalert "Copy the following link in your browser for the jupyter notebook web access."
echoinfo "$external_url"
echoinfo "Please find the password in the connection.yml file in the Jupyter session directory in the Ondemand browser."

