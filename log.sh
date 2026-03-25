#/bin/bash

NODE_NUM=${1:-0}
NODE_NAME="node${NODE_NUM}"

echo "print log for bsc-node: ${NODE_NAME}"

tail -f -n100 .local/${NODE_NAME}/bsc.log
