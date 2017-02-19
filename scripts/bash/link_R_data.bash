
data_dirs=(r-intro-gh-pages/r-intro-files r-more-gh-pages/r-more-files RNAseq-DE-analysis-with-R-gh-pages/data)

for u in /home/*
do 
  for dd in ${data_dirs[@]}
  do
    if [[ ! -L "$u/$(basename $dd)" ]]
    then
      ln -s /data/bio-data/$dd $u/
      chown -R $(basename $u):$(basename $u) $u/$(basename $dd)
      >&2 echo "MESSAGE: Linked $dd to $u"
    else
      >&2 echo "MESSAGE: Username $(basename $u) already has $dd symlink"
    fi
  done
done
