# lecture-08 Setup
The following packages are required for this lecture:

### `tidyverse`

* `dplyr` - data wrangling
* `ggplot2` - plotting
    * this lecture uses the **development** version, which should be installed using `devtools` - see the [course website](https://slu-soc5650.github.io/course-software/) for additional details
* `readr` - reading and writing `.csv` files

### Spatial Data
* `sf` - spatial data tools
    * using `sf` requires additional dependencies - see the [course website](https://slu-soc5650.github.io/course-software/) for additional details 
* `tidycensus` - download census demographic data
    * using `tidycensus` requires a [Census Bureau API](https://api.census.gov/data/key_signup.html)
* `tigris` - download census geometric data

### Literate Programming
* `knitr` - create documents from R notebooks
* `rmarkdown` - write in Markdown syntax

### Project Organization
* `here` - manage file paths
