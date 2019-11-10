source /home/LAB/meijj/Env/miniconda3/etc/profile.d/conda.sh
conda activate tf15
export PATH="/home/LAB/meijj/Env/cudnn-10.1-v7.6.3:/usr/local/cuda-10.0/bin:/usr/local/cuda-10.1/bin:/usr/local/cuda-10.1/NsightCompute-2019.1${PATH:+:${PATH}}"
export LD_LIBRARY_PATH="/home/LAB/meijj/Env/cudnn-10.1-v7.6.3/lib64:/usr/local/cuda-10.0/lib64:/usr/local/cuda-10.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"


counter=0
for dataset in FB15K WN18 FB15K-237 WN18RR
do
  for model in TransE HOLE DistMult ComplEx
  do
    target_dir=${dataset}_${model}
    cp -r ../OpenKE ../${target_dir} && cd ../${target_dir} || exit 1
    srun -p sugon --gres=gpu:P100:1 python -u train_${model}_${dataset}.py ${HOME}/benchmarks_vae/${dataset}/ > log.txt 2>&1 &
    counter=$((counter+1))
    if [[ $(( counter % 6 )) -eq 0 ]]; then
      echo "${counter} processes were started, pause to wait them to finish."
      wait
    fi
  done
done