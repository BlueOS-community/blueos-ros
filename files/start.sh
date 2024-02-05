#!/bin/bash

echo "Starting.."
[ ! -e /var/run/nginx.pid ] && nginx&

ROS_MAVROS_FCU_URL="${ROS_MAVROS_FCU_URL:-tcp://0.0.0.0:5777@}"

# Create a new tmux session
tmux -f /etc/tmux.conf start-server
tmux new -d -s "ROS"

# Split the screen into a 2x2 matrix
tmux split-window -v
tmux split-window -h
tmux select-pane -t 0
tmux split-window -h

tmux send-keys -t 0 "/ros_entrypoint.sh roscore" Enter
tmux send-keys -t 1 "sleep 10 && /ros_entrypoint.sh roslaunch rosbridge_server rosbridge_websocket.launch port:=8889" Enter
tmux send-keys -t 2 "while true; do sleep 10; /ros_entrypoint.sh roslaunch mavros apm.launch fcu_url:=${ROS_MAVROS_FCU_URL}; done" Enter
tmux send-keys -t 3 "echo 'Hi! :)'" Enter

function create_service {
    tmux new -d -s "$1" || true
    SESSION_NAME="$1:0"
    # Set all necessary environment variables for the new tmux session
    for NAME in $(compgen -v | grep MAV_); do
        VALUE=${!NAME}
        tmux setenv -t $SESSION_NAME -g $NAME $VALUE
    done
    tmux send-keys -t $SESSION_NAME "$2" C-m
}

create_service 'ttyd' 'ttyd -p 88 sh -c "/usr/bin/tmux attach -t ROS || /usr/bin/tmux new -s user_terminal"'

echo "Done!"
sleep infinity