#!/bin/sh

dir=/references

mkdir -p $dir/uniprot/latest

wget -N -P $dir/uniprot/latest ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/taxonomic_divisions/*

