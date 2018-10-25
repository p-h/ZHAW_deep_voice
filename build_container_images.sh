#!/usr/bin/env bash

IMAGE_BASE=deep_voice

usage()
{
    echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -c|cpu        Build the cpu version of the image
    -g|gpu        Build the gpu version of the image (default)"

}

build_cpu_image() {
    image_name="${IMAGE_BASE}-cpu.simg"
    rm -f $image_name
    singularity build ../$image_name Singularity-cpu
}

build_gpu_image() {
    image_name="${IMAGE_BASE}.simg"
    rm -f $image_name
    singularity build ../$image_name Singularity
}

build() {
    if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root" 
       exit 1
    fi

    if [[ $1 = true ]]; then
        build_gpu_image
    else
        build_cpu_image
    fi
}

build_gpu=true

while getopts ":hcg" opt
do
  case $opt in

    h|help     )  usage; exit 0   ;;
    c|cpu     )  build_gpu=false;;
    g|gpu|*     )  build_gpu=true;;

  esac
done

build $build_gpu

shift $(($OPTIND-1))
