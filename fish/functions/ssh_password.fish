function ssh_pw --argument-names user host
    if test -z $user || test -z $host
        echo "Usage: ssh_pw user host"
        return 1
    end
    ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password $user@$host
end
