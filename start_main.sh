#!/bin/bash

API=tonapi
TIMEOUT=5
GIVERS=10000


minerDir="$HOME/JettonGramGpuMiner"

if [ ! -d "${minerDir}" ]; then
    echo "Miner not installed. Installing."
    sudo apt update
    sudo apt install vim -y
    
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs
    git clone https://github.com/4e4evi1sa/JettonGramGpuMiner.git

    echo ${minerDir}
    cd JettonGramGpuMiner || cd ${minerDir} || exit
else
    cd ${minerDir} || exit
    echo "Miner've already installed. Updating."
    git pull
fi

GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)

commandForRun=""
if [ "$GPU_COUNT" = "" ]; then
  echo "Cant get GPU count. Aborting."
  exit 1
elif [ "$GPU_COUNT" = "1" ]; then




cat > start_gpu_.sh <<EOF
#!/bin/bash
npm install


while true; do
  node send_universal_gpu.js --api tonapi --bin ./pow-miner-cuda --givers ${GIVERS}
  sleep 1;
done;
EOF


   #commandForRun="./start_custom.sh ${API} ${TIMEOUT} ${GIVERS} ${COIN}"
   commandForRun="./start_gpu_.sh"
   chmod +x start_gpu_.sh
else

cat > start_multi_gpu_.sh <<EOF
#!/bin/bash
npm install


while true; do
  node send_multigpu_gpu.js --api tonapi --bin ./pow-miner-cuda --givers ${GIVERS} --gpu-count ${GPU_COUNT}
  sleep 1;
done;
EOF
  #commandForRun="./start_multi.sh ${API} ${TIMEOUT} ${GPU_COUNT}"
  commandForRun="./start_multi_gpu_.sh"
  chmod +x start_multi_gpu_.sh
fi

echo "Start miner within command ${commandForRun}"
