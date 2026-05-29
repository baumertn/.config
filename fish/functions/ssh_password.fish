function ssh_pw --argument-names user host
    if test -z $user || test -z $host
        echo "Usage: ssh_pw user host"
        return 1
    end
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password $user@$host
end

function scp_pw --argument-names source destination
  if test -z $source || test -z $destination
    echo "Usage: scp_pw source destination"
    return 1
  end
  scp -o PubkeyAuthentication=no -o PreferredAuthentications=password $source $destination
end
