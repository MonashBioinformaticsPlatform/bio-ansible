#!/bin/bash

dir=/references/iGenomes

mkdir -p $dir/source

function may_download {
  url=$1
  size=$2

  dest=$dir/source/$(basename $url)

  echo $dest

  download=true
  if [ -s "$dest" ]; then
    if [ -z "$size" ]; then
      echo "    Skipping: File exists, but no size specification, assuming it is correct"
      download=false
    else
      sz=$(stat -c %s $dir/source/$(basename $url) 2> /dev/null)
      if [ "$size" = "$sz" ]; then
        echo "    File exists and is correct size, skipping"
        download=false
      else
        echo "    File exists but is incorrect size.  Downloading"
      fi
    fi
  fi
  
  if [ "$download" = true ]; then
    wget -P $dir/source $url
  fi
}

function process {
  url=$1
  size=$2
  creates=$3
  may_download $url $size

  extract=true
  if [ -n "$creates" ]; then
    if [ -s "$dir/$creates" ]; then
      extract=false
    fi
  fi

  if [ "$extract" = true ]; then
    dest=$dir/source/$(basename $url)
    echo "Extract" $(basename $url)
    tar -C $dir -xzf $dest
  fi
}

# Human
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Homo_sapiens/Ensembl/GRCh37/Homo_sapiens_Ensembl_GRCh37.tar.gz 19263455703 Homo_sapiens/Ensembl/GRCh37/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Homo_sapiens/NCBI/build37.2/Homo_sapiens_NCBI_build37.2.tar.gz 46601680064 Homo_sapiens/NCBI/build37.2/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Homo_sapiens/UCSC/hg19/Homo_sapiens_UCSC_hg19.tar.gz 29666884240 Homo_sapiens/UCSC/hg19/Annotation/Genes

# Mouse
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/Ensembl/GRCm38/Mus_musculus_Ensembl_GRCm38.tar.gz 16031228821 Mus_musculus/Ensembl/GRCm38/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/NCBI/GRCm38/Mus_musculus_NCBI_GRCm38.tar.gz 29509499737 Mus_musculus/NCBI/GRCm38/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz 16498340769 Mus_musculus/UCSC/mm10/Annotation/Genes

# C.elegans
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Caenorhabditis_elegans/Ensembl/WBcel235/Caenorhabditis_elegans_Ensembl_WBcel235.tar.gz 552298152 Caenorhabditis_elegans/Ensembl/WBcel235/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Caenorhabditis_elegans/NCBI/WS195/Caenorhabditis_elegans_NCBI_WS195.tar.gz 573511029 Caenorhabditis_elegans/NCBI/WS195/Annotation/Genes
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Caenorhabditis_elegans/UCSC/ce10/Caenorhabditis_elegans_UCSC_ce10.tar.gz 572953236 Caenorhabditis_elegans/UCSC/ce10/Annotation/Genes

# Zebrafish
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Danio_rerio/Ensembl/Zv9/Danio_rerio_Ensembl_Zv9.tar.gz
pricess ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Danio_rerio/NCBI/Zv9/Danio_rerio_NCBI_Zv9.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Danio_rerio/UCSC/danRer7/Danio_rerio_UCSC_danRer7.tar.gz

# Yeast
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Saccharomyces_cerevisiae/Ensembl/R64-1-1/Saccharomyces_cerevisiae_Ensembl_R64-1-1.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Saccharomyces_cerevisiae/NCBI/build3.1/Saccharomyces_cerevisiae_NCBI_build3.1.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Saccharomyces_cerevisiae/UCSC/sacCer3/Saccharomyces_cerevisiae_UCSC_sacCer3.tar.gz

# Arabidopsis
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Arabidopsis_thaliana/Ensembl/TAIR10/Arabidopsis_thaliana_Ensembl_TAIR10.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Arabidopsis_thaliana/NCBI/TAIR10/Arabidopsis_thaliana_NCBI_TAIR10.tar.gz

# Drosophila
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Drosophila_melanogaster/Ensembl/BDGP5/Drosophila_melanogaster_Ensembl_BDGP5.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Drosophila_melanogaster/NCBI/build5.41/Drosophila_melanogaster_NCBI_build5.41.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Drosophila_melanogaster/UCSC/dm3/Drosophila_melanogaster_UCSC_dm3.tar.gz

# Rat
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Rattus_norvegicus/Ensembl/Rnor_5.0/Rattus_norvegicus_Ensembl_Rnor_5.0.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Rattus_norvegicus/NCBI/Rnor_5.0/Rattus_norvegicus_NCBI_Rnor_5.0.tar.gz
process ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Rattus_norvegicus/UCSC/rn5/Rattus_norvegicus_UCSC_rn5.tar.gz

