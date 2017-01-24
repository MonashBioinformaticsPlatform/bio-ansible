#!/bin/bash

ver=22
dir=/references/gencode/v$ver

mkdir -p $dir

function may_download {
  url=$1
  size=$2

  dest=$dir/$(basename $url)

  echo $dest

  download=true
  if [ -s "$dest" ]; then
    if [ -z "$size" ]; then
      echo "    Skipping: File exists, but no size specification, assuming it is correct"
      download=false
    else
      sz=$(stat -c %s $dest 2> /dev/null)
      if [ "$size" = "$sz" ]; then
        echo "    File exists and is correct size, skipping"
        download=false
      else
        echo "    File exists but is incorrect size.  Downloading"
      fi
    fi
  fi
  
  if [ "$download" = true ]; then
    wget -O $dest $url
  fi
}

function process {
  url=$1
  size=$2
  may_download $url $size
}

process ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_$ver/gencode.v$ver.annotation.gtf.gz
process ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_$ver/gencode.v$ver.annotation.gff3.gz
process ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_$ver/gencode.v$ver.chr_patch_hapl_scaff.annotation.gtf.gz
process ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_$ver/gencode.v$ver.chr_patch_hapl_scaff.annotation.gff3.gz
process ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_$ver/GRCh38.p2.genome.fa.gz
