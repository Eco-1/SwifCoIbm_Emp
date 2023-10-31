# SwifCoIbm_Emp
### SwifCoIbm_Emp model, R code and required input files

## I - The individual based model:

Main file: *SwiFCoIBM_emp.nlogo*

    1. Preparation:

Extract **AreaCodeSamplerFiles**.zip into a folder of the same name in the root directory, those files are needed to tell the model which cells to sample at what time

*Note: there should be NO subfolders, just a folder named AreaCodeSamplerFiles that should contain 1790 txt files*

    2. Install NetLogo:

The model is designed in and needs to be run in [NetLogo 6.3.0](https://ccl.northwestern.edu/netlogo/) (functionality in different versions can not be guaranteed)

    3. Running the model:

Load *SwiFCoIBM_emp.nlogo* in NetLogo 6.3.0

The model is controlled through the NetLogo UI

Parameters can be set manually through various sliders and fields within the UI

The **Default Values** button will set the model parameters to an example simulation

The model is initialized with the **Setup** button

The model simulation is started with the **Run Until End** button

*Note: The model output will not be saved when manually starting a single simulation run*

    4. Running experiments:

 The simulations used in the submitted manuscript can be found in form of a NetLogo BehaviorSpace Experiment

 **NetLogo main window** > **Tools** > **BehaviorSpace** > ***AreaCode_msRun2*** > **Run**

 *Note: select Table output and as many parallel runs as possible. The runtime varies heavily depending on computer specifications and can take several days (it is recommended to use at least 40 parallel runs)*

 The simulation experiment will create aa cvs table with all necessary outputs


## II - The analysis script:

Main file: *SwiFCoIBM_an.Rmd*

The R-Markdown for the analysis of the SwifCoIbm_Emp model output was created under R version 4.0.3

    1. Preparation:

Set the working directory to the location of the repository and the R subfolder

The csv file generated from the simulation model should be loaded here:

*Note: replace **modeloutputfile***

```r
#chunk: output string prep

tst1 <- read.csv("./modeloutputfile.csv", skip = 6, header = TRUE) # due to size restrictions the model output can not be included in the repository

```

    2. Executing the script

The Markdown can be run chuck by chunk or as a whole (not recommended)

**Important**: The *string separator* (shown below) chunk should only be run once and will create a rds file for the intermediary data that is used throughout the rest of the script. The spatial output of the simulation model is created as a long string for each timestep. For further analysis the string need to be split up into its individual components for each timestep of each repetition of each parameter combination. It is highly recommended to execute the chunk on a hpc with a large amount of memory and threads.

<details>
<summary> string separator </summary>

```r
#chunk: string separator

tstWithArea <- data.frame()  

  library(parallel)
  library(foreach)
  library(doParallel)


cores=detectCores()
cl <- makeCluster(cores[1]-2) #not to overload your computer
registerDoParallel(cl)

tstWithArea<- foreach::foreach(i = 1:nrow(tst2),.combine =  "rbind") %dopar% {

  library(dplyr)

  a <- tst2[i, ]
  b <- base::strsplit(a$acStringClean, " ") %>%
    base::as.data.frame() %>%
    dplyr::rename(areaCode = 1) %>%
    dplyr::mutate(areaCode = base::as.numeric(areaCode)) %>%
    dplyr::left_join(acKM2, by = "areaCode")

  tst2[i,]$infectedAreaInSqkm <- base::sum(b$km2)


}

stopCluster(cl)

tst2_combine <- cbind(tst2,tstWithArea)

saveRDS(tst2_combine, paste0("./speedOfSpreadCombination.rds"))

```

</details><br>


    3. Outputs

The script will create 3 outputs in the root directory:

The speed of pathogen spread over time in relation to the observed outbreak data -> *sos1.png*

The age class distribution of infected individuals in relation to the observed outbreak data -> *ageClass.png*

A SIR classification table -> *sirTab2.csv*


## III - General notes:

While the model is able to handle both realistic and theoretical landscapes with a host of parameters, the current output is specifically designed for this manuscript. Deviations from the parameter combinations that are used in the experiment would entail substantial changes to the analysis script that go beyond the scope of this readme.  
