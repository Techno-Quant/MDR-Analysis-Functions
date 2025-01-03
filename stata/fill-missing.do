/*
    Purpose:
    This function forward fills missing values in a specified range of variables based on the last known value for each ID.

    Variables:
    - var_range: A range of variables to forward fill (e.g., "weight height").
    - id_var: The name of the ID variable (e.g., "id").

    Example Usage:
    forward_fill, var_range("weight height") id_var("id")
*/

* Function to forward fill missing values
capture program drop forward_fill
program define forward_fill
    syntax , var_range(string) id_var(string)
    
    * Loop through the range of variables and forward fill missing values
    foreach var of varlist `var_range' {
        by `id_var' (xtemp), sort: replace `var' = `var'[_n-1] if mi(`var') & !mi(`var'[_n-1])
    }
end

* Example usage
* forward_fill, var_range("weight height") id_var("id")

/*
    Purpose:
    This function checks if the dataset is already sorted by `id_var` and `date_var`, and sorts if necessary.

    Variables:
    - id_var: The name of the ID variable (e.g., "id").
    - date_var: The name of the date variable (e.g., "date").

    Example Usage:
    sort_if_needed, id_var("id") date_var("date")
*/

* Function to check if sorted and sort if needed
capture program drop sort_if_needed
program define sort_if_needed
    syntax , id_var(string) date_var(string)
    
    * Check if the dataset is already sorted by id_var and date_var
    tempvar sorted
    gen `sorted' = 1 if _n == 1
    by `id_var' (xtemp), sort: replace `sorted' = `sorted'[_n-1] & `id_var' == `id_var'[_n-1] & `date_var' >= `date_var'[_n-1]
    
    * If not sorted, sort by id_var and date_var
    if sum(`sorted') != _N {
        sort `id_var' `date_var'
    }
    
    drop `sorted'
end

* Example usage
* sort_if_needed, id_var("id") date_var("date")


* Function to back and forward fill missing values with date, checking if sorted
capture program drop back_and_forward_fill_with_date
program define back_and_forward_fill_with_date
    syntax , var_range(string) id_var(string) date_var(string)
    
    * Check if the dataset is already sorted by id_var and date_var
    sort_if_needed, id_var(`id_var') date_var(`date_var')
    
    * Generate a temporary variable for sorting
    gen long xtemp = _n
    
    * Loop through the range of variables and back fill missing values
    foreach var of varlist `var_range' {
        replace `var' = `var'[_n-1] if mi(`var') & !mi(`var'[_n-1]) & `id_var' == `id_var'[_n-1]
    }
    
    * Reverse the order and forward fill missing values
    sort `id_var' -`date_var'
    
    * Loop through the range of variables and forward fill due to reverse sort
    foreach var of varlist `var_range' {
        replace `var' = `var'[_n-1] if mi(`var') & !mi(`var'[_n-1]) & `id_var' == `id_var'[_n-1]
    }
    
    * Sort back to the original order
    sort xtemp
    drop xtemp
end

* Example usage
* back_and_forward_fill_with_date, var_range("weight height") id_var("id") date_var("date")
