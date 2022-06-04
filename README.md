# UniqKmer
Generate Kmer file from a collection of genomes.

## Usage
`perl UniqKmer.pl <fasta> <kmer> <outdir>`

## Test
`cat test/cmd.sh`
```
perl ../UniqKmer.pl ../data/NCBI.HBV.fa 25 $PWD
```

## Output files
`UniqKmer.pl` will give you three files:
* processed.fa
* uniqness.25.txt
* kmer_stat.txt


> processed.fa
```
>genome_1
ref_1
>genome_2
ref_2
```

> uniqness.25.txt
```
ref     pos     seq     times   flag
>X75657|E|3212  0       TTCCACAACATTCCACCAAGCTCTG       1       UNIQ
>X75657|E|3212  1       TCCACAACATTCCACCAAGCTCTGC       2       Not-UNIQ
>X75657|E|3212  2       CCACAACATTCCACCAAGCTCTGCA       1       UNIQ
>X75657|E|3212  3       CACAACATTCCACCAAGCTCTGCAG       1       UNIQ
>X75657|E|3212  4       ACAACATTCCACCAAGCTCTGCAGG       1       UNIQ
>X75657|E|3212  5       CAACATTCCACCAAGCTCTGCAGGA       1       UNIQ
>X75657|E|3212  6       AACATTCCACCAAGCTCTGCAGGAT       1       UNIQ
>X75657|E|3212  7       ACATTCCACCAAGCTCTGCAGGATC       1       UNIQ
>X75657|E|3212  8       CATTCCACCAAGCTCTGCAGGATCC       1       UNIQ
>X75657|E|3212  9       ATTCCACCAAGCTCTGCAGGATCCC       1       UNIQ
```

> kmer_stat.txt
```
ref     UNIQ_count      unUNIQ_count
>X02763|A|3221  1594    1603
>X65259|D|3182  1681    1477
>AF160501|G|3248        2187    1037
>D00329|B|3215  2013    1178
>X04615|C|3215  1973    1218
>AY090454|H|3215        2187    1004
>X69798|F|3215  2113    1078
>X75657|E|3212  1903    1285
```
