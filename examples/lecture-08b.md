Lecture 08b Notebook
================
Christopher Prener, Ph.D.
(March 14, 2018)

Introduction
------------

This is the lecture notebook for Lecture-08b from the course SOC 4650/5650: Introduction to GISc.

Load Dependencies
-----------------

The following code loads the package dependencies for our analysis:

``` r
library(dplyr) # data wrangling
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidycensus) # access census data
```

tidycensus Set-up
-----------------

Before using `tidycensus`, you need to install a census API key. Use the syntax below, copied into your console, to install the key you received via email.

``` r
census_api_key("KEY", install = TRUE)
```

This is not a code chunk you will need in each notebook. As long as `install = TRUE`, you will only have to do this once!

Census Data
-----------

### Get List of Variables

To get a preview of variables available in the `get_decennial()` function, we can use the `load_variables()` function:

``` r
census <- load_variables(year = 2010, dataset = "sf1", cache = TRUE) 
```

I find it useful to assign the output of this function to an object so that I can search through it. Try searching for the variable `P0010001`, the total population of a geographic unit, in the `census` object.

### Download Data

To download data, we can use use the `get_decennial()` function to access, for example, population by state in 2010:

``` r
popStates <- get_decennial(geography = "state", year = "2010", variable = "P0010001")
```

County-level data can be download both for an entire state and for a specific county. Here is the syntax to download all county populations for Missouri:

``` r
popMOCounties <- get_decennial(geography = "county", year = "2010", state = "MO", variable = "P0010001")
```

Here is the syntax to download only the city of St. Louis:

``` r
popSTL <- get_decennial(geography = "county", year = "2010", state = "MO",
                               county = "St. Louis city", variable = "P0010001")
```

For the 2010 census, we can also download data the tract, block group, and block levels:

``` r
popSTL_tract <- get_decennial(geography = "tract", year = "2010", state = "MO",
                               county = "St. Louis city", variable = "P0010001")
  
popSTL_blockGroup <- get_decennial(geography = "block group", year = "2010", state = "MO",
                               county = "St. Louis city", variable = "P0010001")
  
popSTL_block <- get_decennial(geography = "block", year = "2010", state = "MO",
                               county = "St. Louis city", variable = "P0010001")
```

These data can also be downloaded for the entire state of Missouri as well by removing the `county` argument from each function.

### Download Tables

Most variables in the decennial census are actually a part of a table. There are individual variables, for example, for race:

``` r
census %>%
  filter(concept == "P3. RACE [8]")
```

    ## # A tibble: 8 x 3
    ##   name     label                                            concept     
    ##   <chr>    <chr>                                            <chr>       
    ## 1 P0030001 Total population                                 P3. RACE [8]
    ## 2 P0030002 White alone                                      P3. RACE [8]
    ## 3 P0030003 Black or African American alone                  P3. RACE [8]
    ## 4 P0030004 American Indian and Alaska Native alone          P3. RACE [8]
    ## 5 P0030005 Asian alone                                      P3. RACE [8]
    ## 6 P0030006 Native Hawaiian and Other Pacific Islander alone P3. RACE [8]
    ## 7 P0030007 Some Other Race alone                            P3. RACE [8]
    ## 8 P0030008 Two or More Races                                P3. RACE [8]

We rarely want to download these one at a time. Instead, we want to download them at one time into a single data frame. The table number for these data is `P003` - we take the first four characters from the `name` variable.

``` r
raceSTL_tract <- get_decennial(geography = "tract", year = "2010", state = "MO",
                               county = "St. Louis city", table = "P003", output = "tidy")
```

These are downloaded in "long" fashion, which is preferred by `R` for some operations Long data will give us one row per variable per unit. In this case, that works out to one row per variable per tract, or 848 rows in total:

``` r
glimpse(raceSTL_tract)
```

    ## Observations: 848
    ## Variables: 4
    ## $ GEOID    <chr> "29510101100", "29510101200", "29510101300", "2951010...
    ## $ NAME     <chr> "Census Tract 1011", "Census Tract 1012", "Census Tra...
    ## $ variable <chr> "P0030001", "P0030001", "P0030001", "P0030001", "P003...
    ## $ value    <dbl> 2600, 3100, 4336, 2703, 3126, 3092, 2780, 6028, 1846,...

This is what they look like as a table:

``` r
raceSTL_tract
```

    ## # A tibble: 848 x 4
    ##    GEOID       NAME              variable value
    ##    <chr>       <chr>             <chr>    <dbl>
    ##  1 29510101100 Census Tract 1011 P0030001 2600.
    ##  2 29510101200 Census Tract 1012 P0030001 3100.
    ##  3 29510101300 Census Tract 1013 P0030001 4336.
    ##  4 29510101400 Census Tract 1014 P0030001 2703.
    ##  5 29510101500 Census Tract 1015 P0030001 3126.
    ##  6 29510101800 Census Tract 1018 P0030001 3092.
    ##  7 29510102100 Census Tract 1021 P0030001 2780.
    ##  8 29510102200 Census Tract 1022 P0030001 6028.
    ##  9 29510102300 Census Tract 1023 P0030001 1846.
    ## 10 29510102400 Census Tract 1024 P0030001 2478.
    ## # ... with 838 more rows

Usually, for GIS purposes, we want to work with "wide data":

``` r
raceSTL_tractW <- get_decennial(geography = "tract", year = "2010", state = "MO",
                               county = "St. Louis city", table = "P003000", output = "wide")
```

These will give us only 106 rows for our data:

``` r
glimpse(raceSTL_tractW)
```

    ## Observations: 106
    ## Variables: 10
    ## $ GEOID    <chr> "29510101100", "29510101200", "29510101300", "2951010...
    ## $ NAME     <chr> "Census Tract 1011", "Census Tract 1012", "Census Tra...
    ## $ P0030001 <dbl> 2600, 3100, 4336, 2703, 3126, 3092, 2780, 6028, 1846,...
    ## $ P0030002 <dbl> 2284, 2779, 3692, 1749, 1960, 1977, 2512, 5701, 1701,...
    ## $ P0030003 <dbl> 87, 98, 373, 694, 945, 853, 153, 136, 50, 210, 106, 2...
    ## $ P0030004 <dbl> 20, 6, 6, 29, 23, 12, 12, 8, 1, 11, 6, 8, 6, 12, 3, 7...
    ## $ P0030005 <dbl> 120, 140, 76, 44, 30, 32, 37, 65, 49, 31, 21, 46, 16,...
    ## $ P0030006 <dbl> 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 2, 0, 3, 0, 0, 0,...
    ## $ P0030007 <dbl> 28, 26, 83, 86, 38, 98, 16, 24, 14, 35, 14, 45, 17, 4...
    ## $ P0030008 <dbl> 61, 51, 105, 100, 130, 119, 49, 93, 31, 71, 48, 57, 4...

Now we have a column for each variable and only the requisite number of rows, one for each census tract.

ACS Data
--------

### Get List of Variables

To get a preview of variables available in the `get_acs()` function, we can use the `load_variables()` function:

``` r
acs <- load_variables(year = 2016, dataset = "acs5", cache = TRUE) 
```

As before, I find it useful to assign the output of this function to an object so that I can search through it. Try searching for the table `B11001A`, the estimate for different household types per geographic unit, in the `acs` object. The characters after the underscore identify specific variables - `B11001A_001E` is the estimate for the total number of household units.

### Download Variables

As with `get_decennial()`, we can download data as single variables at various geographies. For instance, we can download household types at the county level in Missouri:

``` r
hhMOCounties <- get_acs(geography = "county", year = "2016", state = "MO", 
                        variable = "B11001A_001", survey = "acs5")
```

    ## Please note: `get_acs()` now defaults to a year or endyear of 2016.

We can get the same data at the county-level for St. Louis by changing the geography and supplying St. Louis's county FIPS code.

``` r
hhSTL_tract <- get_acs(geography = "tract", year = "2016", state = "MO", county = 510,
                        variable = "B11001A_001", survey = "acs5")
```

    ## Please note: `get_acs()` now defaults to a year or endyear of 2016.

Now open both of these objects and explore the estimate (those that end with an `E`) and margin variables (those that end with an `M`). Notice how the margins are significantly different between the two tables. These are 90% margins of error, which is an assessment how much we think the estimate is likely to be off by. With the ACS in particular, we are especially interested in observations where the margin of error is larger than the estimate itself. This is more likely at smaller geographies, like tracts and block groups, than it is at larger geographies.

### Download Tables

As with the decennial census, we can also download census data in table format. We can get table names by using all of the characters *before* the underscore - `B11001A` is the table name for the household data accessed above. Here is the table for all of the household type variables:

``` r
hhSTL_tractW <- get_acs(geography = "tract", year = "2016", state = "MO", county = 510,
                        table = "B11001A", output = "wide", survey = "acs5")
```

    ## Please note: `get_acs()` now defaults to a year or endyear of 2016.
