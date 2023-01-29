set -- $(getopt abo: $*)
while [[ ${1:--} != - ]]; do
    echo $1
    shift
done
