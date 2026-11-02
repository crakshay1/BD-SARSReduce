# BD-SARSReduce

**Mapping the pandemic, reducing the processing time**  
*Cloud Computing & Big Data — Université Paris-Saclay*

-----------------------------------------------------
This project is a Big Data benchmark built around COVID-19 data. It compares how the MapReduce paradigm is implemented and performs across three technologies: Hadoop, MongoDB and PySpark.

The same processing is run on the same dataset with each approach, in order to compare their processing times and to understand the strengths and trade-offs of each tool when mapping the evolution of the pandemic.

-------
## Dataset
The database comes from the ECDC COVID-19 dataset, obtained from the Humanitarian Data Exchange (HDX): [https://data.humdata.org/dataset/ecdc-covid-19](https://data.humdata.org/dataset/ecdc-covid-19).

It is provided in this repository as [ecdc_covid19_cases.xls](ecdc_covid19_cases.xls).

## Report
You can find the description of the work, the implementations and the benchmark results in the [BIGDATA-Report3-Akshay.pdf](https://github.com/crakshay1/BD-SARSReduce/blob/main/BIGDATA-Report3-Akshay.pdf).

## Tech stack
* Hadoop (MapReduce)
* MongoDB (MapReduce)
* PySpark

## Structure

```
.
├── BIGDATA-Report3-Akshay.pdf      # Project report
├── covid.csv                       # COVID-19 dataset (CSV)
├── ecdc_covid19_cases.xls          # COVID-19 dataset (ECDC, source: HDX)
└── Scripts/
    ├── all_coms.sh                 # Commands used to run the jobs
    ├── desc&fig.r                  # Descriptive statistics and figures
    ├── Question1/ ... Question3/
    │   ├── MapN.py                 # Hadoop mapper
    │   ├── RedN.py                 # Hadoop reducer
    │   ├── MRN_mongo.js            # MongoDB MapReduce
    │   ├── MRN_PySpark.ipynb       # PySpark implementation
    │   └── TimeExecN.r             # Execution time comparison
    ├── Question4/
    │   ├── Map4.py, Red4.py        # Hadoop mapper and reducer
    │   ├── MR4_mongo.js            # MongoDB MapReduce
    │   ├── MR4_PySpark.ipynb       # PySpark implementation
    │   └── MEMCPU.r                # Memory and CPU usage comparison
    └── Question5/
        ├── Map5.py, Red5.py        # Hadoop mapper and reducer
        ├── MR5_mongo.js            # MongoDB MapReduce
        ├── MR5_PySpark.ipynb       # PySpark implementation
        ├── MEMCPU.r                # Memory and CPU usage comparison
        └── covid_peaks.png         # Figure: COVID-19 peaks
```
