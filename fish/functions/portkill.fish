function kill_port --argument-names port
    sudo lsof -t -i:$port | xargs -r sudo kill
end
